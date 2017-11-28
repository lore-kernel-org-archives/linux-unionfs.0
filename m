From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v8 14/15] ovl: Fix encryption/compression status of a metacopy only file
Date: Tue, 28 Nov 2017 10:59:58 -0500
Message-ID: <20171128155959.20114-15-vgoyal@redhat.com>
References: <20171128155959.20114-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53686 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753962AbdK1QAN (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 11:00:13 -0500
In-Reply-To: <20171128155959.20114-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

If file is metacopy only, it is possible that lower is encrypted while
other is not. In that case, report file as encrypted (despite the fact
that only data is encrypted while metadata is not).

Similarly if lower is compressed, report that in stat for a metacopy
only file.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/inode.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index da5cc2c6c413..5fbfb670963d 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -66,6 +66,23 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 	return err;
 }
 
+#define OVL_STATX_ATTR_MASK	(STATX_ATTR_ENCRYPTED | STATX_ATTR_COMPRESSED)
+
+static void ovl_stat_fix_attributes(struct kstat *ustat, struct kstat *lstat) {
+	unsigned int attr_mask, attr;
+
+	attr_mask = lstat->attributes_mask & OVL_STATX_ATTR_MASK;
+	if (!attr_mask)
+		return;
+
+	attr = lstat->attributes & attr_mask;
+	if (!attr)
+		return;
+
+	ustat->attributes_mask |= attr_mask;
+	ustat->attributes |= attr;
+}
+
 int ovl_getattr(const struct path *path, struct kstat *stat,
 		u32 request_mask, unsigned int flags)
 {
@@ -123,8 +140,10 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 			else
 				stat->dev = ovl_get_pseudo_dev(dentry);
 
-			if (metacopy)
+			if (metacopy) {
 				stat->blocks = lowerstat.blocks;
+				ovl_stat_fix_attributes(stat, &lowerstat);
+			}
 		}
 		if (samefs) {
 			/*
-- 
2.13.6
