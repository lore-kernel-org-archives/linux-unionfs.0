From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7/8] ovl: intercept fsync
Date: Thu,  1 Dec 2016 11:15:02 +0100
Message-ID: <1480587303-25088-8-git-send-email-mszeredi@redhat.com>
References: <1480587303-25088-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1480587303-25088-1-git-send-email-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Fsync is really an inode operation (AFAICS) so a doing it on a O_RDONLY
file descriptor should flush any data written through an O_WRONLY file
descriptor for example.

To make this work correctly in case the file is copied up after being
opened for read intercept the fsync fop, similarly to read_iter and mmap.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/inode.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 210838f97777..d861aa7462c5 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -412,6 +412,24 @@ static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
 	return file->f_op->mmap(file, vma);
 }
 
+static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	int ret;
+
+	if (likely(ovl_file_is_lower(file))) {
+		return OVL_CALL_REAL_FOP(file,
+					 fsync(file, start, end, datasync));
+	}
+	file = filp_clone_open(file);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	ret = vfs_fsync_range(file, start, end, datasync);
+	fput(file);
+
+	return ret;
+}
+
 static struct ovl_fops *ovl_fops_find(const struct file_operations *orig)
 {
 	struct ovl_fops *ofop;
@@ -455,9 +473,8 @@ static struct ovl_fops *ovl_fops_get(struct file *file)
 		ofop->fops.read_iter = ovl_read_iter;
 	if (orig->mmap)
 		ofop->fops.mmap = ovl_mmap;
-
-	/* These will need to be intercepted: */
-	ofop->fops.fsync = orig->fsync;
+	if (orig->fsync)
+		ofop->fops.fsync = ovl_fsync;
 
 	/*
 	 * These should be intercepted, but they are very unlikely to be
-- 
2.5.5
