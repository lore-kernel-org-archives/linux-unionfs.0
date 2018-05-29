From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 25/39] vfs: don't open real
Date: Tue, 29 May 2018 16:43:25 +0200
Message-ID: <20180529144339.16538-26-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Let overlayfs do its thing when opening a file.

This enables stacking and fixes the corner case when a file is opened for
read, modified through a writable open, and data is read from the read-only
file.  After this patch the read-only open will not return stale data even
in this case.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/open.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 6e52fd6fea7c..244cd2ecfefd 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -897,13 +897,8 @@ EXPORT_SYMBOL(file_path);
 int vfs_open(const struct path *path, struct file *file,
 	     const struct cred *cred)
 {
-	struct dentry *dentry = d_real(path->dentry, NULL, file->f_flags, 0);
-
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
-
 	file->f_path = *path;
-	return do_dentry_open(file, d_backing_inode(dentry), NULL, cred);
+	return do_dentry_open(file, d_backing_inode(path->dentry), NULL, cred);
 }
 
 /**
-- 
2.14.3
