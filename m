From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 11/17] ovl: decode indexed dir file handles
Date: Thu,  4 Jan 2018 19:20:43 +0200
Message-ID: <1515086449-26563-12-git-send-email-amir73il@gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Decoding an indexed dir file handle is done by looking up the file handle
in index dir by name and then decoding the upper dir from the index origin
file handle. The decoded upper path is used to lookup an overlay dentry of
the same path.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c    | 13 +++++++++++++
 fs/overlayfs/namei.c     |  2 +-
 fs/overlayfs/overlayfs.h |  1 +
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 6ecb54d4b52c..6141682301d6 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -401,6 +401,19 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
 		index = NULL;
 	}
 
+	/* Then try to get upper dir by index */
+	if (index && d_is_dir(index)) {
+		struct dentry *upper = ovl_index_upper(ofs, index);
+
+		err = PTR_ERR(upper);
+		if (IS_ERR_OR_NULL(upper))
+			goto out_err;
+
+		dentry = ovl_get_dentry(sb, upper, NULL, NULL);
+		dput(upper);
+		goto out;
+	}
+
 	/* Then lookup origin by fh */
 	err = ovl_check_origin_fh(fh, NULL, ofs->lower_layers, ofs->numlower,
 				  &stack);
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 638ff196da93..13869108dc32 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -436,7 +436,7 @@ int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
 }
 
 /* Get upper dentry from index */
-static struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index)
+struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index)
 {
 	struct ovl_fh *fh;
 	struct ovl_layer layer = { .mnt = ofs->upper_mnt };
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 8fa8253af7cb..7310e0eca383 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -265,6 +265,7 @@ int ovl_check_origin_fh(struct ovl_fh *fh, struct dentry *upperdentry,
 			struct ovl_path **stackp);
 int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
 		      bool is_upper, bool set);
+struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index);
 int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index);
 int ovl_get_index_name(struct dentry *origin, struct qstr *name);
 struct dentry *ovl_get_index_fh(struct ovl_fs *ofs, struct ovl_fh *fh);
-- 
2.7.4
