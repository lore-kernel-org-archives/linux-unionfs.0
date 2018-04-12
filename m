From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH 23/35] vfs: simplify dentry_open()
Date: Thu, 12 Apr 2018 17:08:14 +0200
Message-ID: <20180412150826.20988-24-mszeredi@redhat.com>
References: <20180412150826.20988-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412150826.20988-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

dentry_open() can now just call path_open().

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/open.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 1d1a52908b0f..442088ca30f9 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -891,31 +891,13 @@ EXPORT_SYMBOL(path_open);
 struct file *dentry_open(const struct path *path, int flags,
 			 const struct cred *cred)
 {
-	int error;
-	struct file *f;
-
 	validate_creds(cred);
 
 	/* We must always pass in a valid mount pointer. */
 	BUG_ON(!path->mnt);
 
-	f = get_empty_filp();
-	if (!IS_ERR(f)) {
-		f->f_flags = flags;
-		error = vfs_open(path, f, cred);
-		if (!error) {
-			/* from now on we need fput() to dispose of f */
-			error = open_check_o_direct(f);
-			if (error) {
-				fput(f);
-				f = ERR_PTR(error);
-			}
-		} else { 
-			put_filp(f);
-			f = ERR_PTR(error);
-		}
-	}
-	return f;
+	return path_open(path, flags, d_backing_inode(path->dentry), cred,
+			 true);
 }
 EXPORT_SYMBOL(dentry_open);
 
-- 
2.14.3
