From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 04/13] ovl: store file handle of stable inode
Date: Mon, 17 Apr 2017 02:59:34 +0300
Message-ID: <1492387183-18847-5-git-send-email-amir73il@gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Sometimes it is interesting to know if an upper file is pure
upper or a copy up target, and if it is a copy up target, it
may be interesting to know which is the copy up origin.

One such case is nfs export, where we need to have persistent
and consistent file handles across copy up.

Store the lower inode file handle in upper inode xattr on copy up
to use it later for these cases.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 428dc26..77a8715 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -391,12 +391,10 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 	if (err)
 		goto out_cleanup;
 
-	if (S_ISDIR(stat->mode) &&
-	    ovl_redirect_dir(dentry->d_sb) &&
-	    ovl_redirect_fh(dentry->d_sb)) {
+	if (ovl_redirect_fh(dentry->d_sb)) {
 		/*
-		 * Store file handle of lower dir in upper dir xattr to
-		 * create a chain of file handles for merged dir stack
+		 * Store file handle of lower inode in upper inode xattr to
+		 * allow lookup of stable (pre copy up) inode
 		 */
 		err = ovl_set_redirect_fh(dentry, temp);
 		if (err)
-- 
2.7.4
