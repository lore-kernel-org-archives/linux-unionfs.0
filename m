From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 4/5] ovl: verify lower root dir by file handle
Date: Thu,  1 Jun 2017 20:01:53 +0300
Message-ID: <1496336514-11000-5-git-send-email-amir73il@gmail.com>
References: <1496336514-11000-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35108 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751923AbdFARB4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Jun 2017 13:01:56 -0400
In-Reply-To: <1496336514-11000-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

With mount option 'verify_lower', verify that the file handle stored
in upper root dir matches the lower root dir or fail to mount.

If upper root dir has no stored file handle, encode and store the lower
root dir file handle in overlay.origin xattr.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h |  5 ++++-
 fs/overlayfs/super.c     | 43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e65910ef215b..bf7e1d95e640 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -22,13 +22,16 @@ enum ovl_path_type {
 
 enum ovl_verify_dir {
 	__OVL_VERIFY_MERGE	= (1 << 0),
+	__OVL_VERIFY_ROOT	= (1 << 1),
 };
 
 /* Verify on lookup of merge dir that lower matches origin fh stored in upper */
 #define OVL_VERIFY_MERGE(v)	((v) & __OVL_VERIFY_MERGE)
+/* Verify on mount that lower root matches origin fh stored in upper root */
+#define OVL_VERIFY_ROOT(v)	((v) & __OVL_VERIFY_ROOT)
 
 /* Verify flags for mount options 'verify_lower' */
-#define OVL_VERIFY_LOWER	(__OVL_VERIFY_MERGE)
+#define OVL_VERIFY_LOWER	(__OVL_VERIFY_MERGE | __OVL_VERIFY_ROOT)
 
 #define OVL_XATTR_PREFIX XATTR_TRUSTED_PREFIX "overlay."
 #define OVL_XATTR_OPAQUE OVL_XATTR_PREFIX "opaque"
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index b677d38bca5c..3d7b5c9bc042 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -413,6 +413,41 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 	return 0;
 }
 
+/*
+ * Verify that stored file handle in dir matches origin.
+ * If dir has no stored file handle, encode and store origin file handle.
+ */
+static int ovl_verify_set_origin(struct dentry *dir, struct vfsmount *mnt,
+				 struct dentry *origin, const char *name)
+{
+	const struct ovl_fh *fh = NULL;
+	int err;
+
+	err = ovl_verify_origin(dir, mnt, origin);
+	if (!err)
+		return 0;
+
+	if (err != -ENODATA)
+		goto fail;
+
+	fh = ovl_encode_fh(origin);
+	err = PTR_ERR(fh);
+	if (IS_ERR(fh))
+		goto fail;
+	err = ovl_do_setxattr(dir, OVL_XATTR_ORIGIN, fh, fh->len, 0);
+	if (err)
+		goto fail;
+
+out:
+	kfree(fh);
+	return err;
+
+fail:
+	pr_err("overlayfs: failed to verify %s dir. (err=%i)\n",
+	       name, err);
+	goto out;
+}
+
 #define OVL_WORKDIR_NAME "work"
 
 static struct dentry *ovl_workdir_create(struct vfsmount *mnt,
@@ -996,6 +1031,14 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 				pr_err("overlayfs: option \"verify_lower\" not supported by lower fs.\n");
 				goto out_put_lower_mnt;
 			}
+			/* Verify lower root matches origin stored in upper */
+			if (i == 0 && OVL_VERIFY_ROOT(ufs->config.verify_dir)) {
+				err = ovl_verify_set_origin(upperpath.dentry,
+							    mnt, mnt->mnt_root,
+							    "lower root");
+				if (err)
+					goto out_put_lower_mnt;
+			}
 		}
 
 	}
-- 
2.7.4
