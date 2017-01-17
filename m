From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 2/6] ovl: check if upperdir fs supports O_TMPFILE
Date: Tue, 17 Jan 2017 06:34:53 +0200
Message-ID: <1484627697-17262-3-git-send-email-amir73il@gmail.com>
References: <1484627697-17262-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1484627697-17262-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This is needed for choosing between concurrent copyup
using O_TMPFILE and legacy copyup using workdir+rename.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h |  9 +++++++++
 fs/overlayfs/ovl_entry.h |  1 +
 fs/overlayfs/super.c     | 10 ++++++++++
 3 files changed, 20 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 8af450b..3822a90 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -127,6 +127,15 @@ static inline int ovl_do_whiteout(struct inode *dir, struct dentry *dentry)
 	return err;
 }
 
+static inline struct dentry *ovl_do_tmpfile(struct dentry *dentry, umode_t mode)
+{
+	struct dentry *ret = vfs_tmpfile(dentry, mode, 0);
+	int err = IS_ERR(ret) ? PTR_ERR(ret) : 0;
+
+	pr_debug("tmpfile(%pd2, 0%o) = %i\n", dentry, mode, err);
+	return ret;
+}
+
 static inline struct inode *ovl_inode_real(struct inode *inode, bool *is_upper)
 {
 	unsigned long x = (unsigned long) READ_ONCE(inode->i_private);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index d14bca1..65f24000 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -27,6 +27,7 @@ struct ovl_fs {
 	struct ovl_config config;
 	/* creds of process who forced instantiation of super block */
 	const struct cred *creator_cred;
+	bool tmpfile;
 };
 
 /* private information held for every overlayfs dentry */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 20f48ab..ff05065 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -825,6 +825,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		 * creation of workdir in previous step.
 		 */
 		if (ufs->workdir) {
+			struct dentry *temp;
+
 			err = ovl_check_d_type_supported(&workpath);
 			if (err < 0)
 				goto out_put_workdir;
@@ -836,6 +838,14 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			 */
 			if (!err)
 				pr_warn("overlayfs: upper fs needs to support d_type.\n");
+
+			/* Check if upper/work fs supports O_TMPFILE */
+			temp = ovl_do_tmpfile(ufs->workdir, S_IFREG | 0);
+			ufs->tmpfile = !IS_ERR(temp);
+			if (ufs->tmpfile)
+				dput(temp);
+			else
+				pr_warn("overlayfs: upper fs does not support tmpfile.\n");
 		}
 	}
 
-- 
2.7.4

