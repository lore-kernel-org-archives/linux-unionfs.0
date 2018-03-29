Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49994 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751642AbeC2TjD (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 29 Mar 2018 15:39:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v13 13/28] ovl: Add helper ovl_dentry_lowerdata() to get lower data dentry
Date: Thu, 29 Mar 2018 15:38:39 -0400
Message-Id: <20180329193854.13814-14-vgoyal@redhat.com>
In-Reply-To: <20180329193854.13814-1-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Now we have the notion of data dentry and metacopy dentry. ovl_dentry_lower()
will return lower dentry at idx 0, but it could be either data or metacopy
dentry. Now we support metacopy dentries in lower layers so it is possible
that lowerstack[0] is metacopy dentry while lowerstack[1] is actual data
dentry.

So add an helper which returns lowest most dentry which is supposed to be
data dentry.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 4eb4b765887f..214d9f08c574 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -226,6 +226,7 @@ void ovl_path_lowerdata(struct dentry *dentry, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
 struct dentry *ovl_dentry_lower(struct dentry *dentry);
+struct dentry *ovl_dentry_lowerdata(struct dentry *dentry);
 struct dentry *ovl_dentry_real(struct dentry *dentry);
 struct dentry *ovl_i_dentry_upper(struct inode *inode);
 struct inode *ovl_inode_upper(struct inode *inode);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index fd98329e820c..394674c4c820 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -186,6 +186,20 @@ struct dentry *ovl_dentry_lower(struct dentry *dentry)
 	return oe->numlower ? oe->lowerstack[0].dentry : NULL;
 }
 
+/*
+ * ovl_dentry_lower() could return either a data dentry or metacopy dentry
+ * dependig on what is stored in lowerstack[0]. At times we need to find
+ * lower dentry which has data (and not metacopy dntry). This helper
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

