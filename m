Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v15 12/30] ovl: Add helper ovl_dentry_lowerdata() to get lower data dentry
Date: Mon,  7 May 2018 13:40:44 -0400
Message-Id: <20180507174102.24086-13-vgoyal@redhat.com>
In-Reply-To: <20180507174102.24086-1-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Now we have the notion of data dentry and metacopy dentry. ovl_dentry_lower()
will return uppermost lower dentry, but it could be either data or metacopy
dentry. Now we support metacopy dentries in lower layers so it is possible
that lowerstack[0] is metacopy dentry while lowerstack[1] is actual data
dentry.

So add an helper which returns lowest most dentry which is supposed to be
data dentry.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index ee66307451f0..4f2bb472c07b 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -227,6 +227,7 @@ void ovl_path_lowerdata(struct dentry *dentry, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
 struct dentry *ovl_dentry_lower(struct dentry *dentry);
+struct dentry *ovl_dentry_lowerdata(struct dentry *dentry);
 struct ovl_layer *ovl_layer_lower(struct dentry *dentry);
 struct dentry *ovl_dentry_real(struct dentry *dentry);
 struct dentry *ovl_i_dentry_upper(struct inode *inode);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 74b38e17a476..58c4031c1b88 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -209,6 +209,20 @@ struct ovl_layer *ovl_layer_lower(struct dentry *dentry)
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
+	int idx = oe->numlower - 1;
+
+	return idx >= 0 ? oe->lowerstack[idx].dentry : NULL;
+}
+
 struct dentry *ovl_dentry_real(struct dentry *dentry)
 {
 	return ovl_dentry_upper(dentry) ?: ovl_dentry_lower(dentry);
-- 
2.13.6
