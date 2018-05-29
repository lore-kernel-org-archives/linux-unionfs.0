From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 11/28] ovl: Add helper ovl_dentry_lowerdata() to get lower data dentry
Date: Tue, 29 May 2018 16:45:55 +0200
Message-ID: <20180529144612.16675-12-mszeredi@redhat.com>
References: <20180529144612.16675-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144612.16675-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

Now we have the notion of data dentry and metacopy dentry.
ovl_dentry_lower() will return uppermost lower dentry, but it could be
either data or metacopy dentry.  Now we support metacopy dentries in lower
layers so it is possible that lowerstack[0] is metacopy dentry while
lowerstack[1] is actual data dentry.

So add an helper which returns lowest most dentry which is supposed to be
data dentry.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 31795c041d61..13b2151cf4df 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -221,6 +221,7 @@ void ovl_path_lowerdata(struct dentry *dentry, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
 struct dentry *ovl_dentry_lower(struct dentry *dentry);
+struct dentry *ovl_dentry_lowerdata(struct dentry *dentry);
 struct ovl_layer *ovl_layer_lower(struct dentry *dentry);
 struct dentry *ovl_dentry_real(struct dentry *dentry);
 struct dentry *ovl_i_dentry_upper(struct inode *inode);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 32ff67fa0bfb..7c7b95d5da1f 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -207,6 +207,19 @@ struct ovl_layer *ovl_layer_lower(struct dentry *dentry)
 	return oe->numlower ? oe->lowerstack[0].layer : NULL;
 }
 
+/*
+ * ovl_dentry_lower() could return either a data dentry or metacopy dentry
+ * dependig on what is stored in lowerstack[0]. At times we need to find
+ * lower dentry which has data (and not metacopy dentry). This helper
+ * returns the lower data dentry.
+ */
+struct dentry *ovl_dentry_lowerdata(struct dentry *dentry)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+
+	return oe->numlower ? oe->lowerstack[oe->numlower - 1].dentry : NULL;
+}
+
 struct dentry *ovl_dentry_real(struct dentry *dentry)
 {
 	return ovl_dentry_upper(dentry) ?: ovl_dentry_lower(dentry);
-- 
2.14.3
