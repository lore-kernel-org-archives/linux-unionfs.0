Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v14 12/31] ovl: Add an helper to get real data dentry
Date: Thu, 26 Apr 2018 15:09:54 -0400
Message-Id: <20180426191013.13219-13-vgoyal@redhat.com>
In-Reply-To: <20180426191013.13219-1-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

ovl_dentry_real() returns the real dentry. (Either upper or lower). We
also need an helper to ignore metacopy dentries and return "real data"
dentry. This helper returns an upper/lower dentry which contains data.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 08df75f473fe..5077d2992d07 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -230,6 +230,7 @@ struct dentry *ovl_dentry_lower(struct dentry *dentry);
 struct dentry *ovl_dentry_lowerdata(struct dentry *dentry);
 struct ovl_layer *ovl_layer_lower(struct dentry *dentry);
 struct dentry *ovl_dentry_real(struct dentry *dentry);
+struct dentry *ovl_dentry_real_data(struct dentry *dentry);
 struct dentry *ovl_i_dentry_upper(struct inode *inode);
 struct inode *ovl_inode_upper(struct inode *inode);
 struct inode *ovl_inode_lower(struct inode *inode);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 7029036b9aa3..2bef013ca432 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -228,6 +228,18 @@ struct dentry *ovl_dentry_real(struct dentry *dentry)
 	return ovl_dentry_upper(dentry) ?: ovl_dentry_lower(dentry);
 }
 
+/* Return real dentry which contains data. Skip metacopy dentries */
+struct dentry *ovl_dentry_real_data(struct dentry *dentry)
+{
+	struct dentry *upperdentry;
+
+	upperdentry = ovl_dentry_upper(dentry);
+	if (upperdentry && ovl_has_upperdata(d_inode(dentry)))
+		return upperdentry;
+
+	return ovl_dentry_lowerdata(dentry);
+}
+
 struct dentry *ovl_i_dentry_upper(struct inode *inode)
 {
 	return ovl_upperdentry_dereference(OVL_I(inode));
-- 
2.13.6
