From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v7 13/14] ovl: Fix encryption/compression status of a metacopy only file
Date: Thu, 16 Nov 2017 17:03:34 -0500
Message-ID: <20171116220335.13448-14-vgoyal@redhat.com>
References: <20171116220335.13448-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58578 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936244AbdKPWDp (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Nov 2017 17:03:45 -0500
In-Reply-To: <20171116220335.13448-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: vgoyal@redhat.com, amir73il@gmail.com, miklos@szeredi.hu

If file is metacopy only, it is possible that lower is encrypted while
other is not. In that case, report file as encrypted (despite the fact
that only data is encrypted while metadata is not).

Similarly if lower is compressed, report that in stat for a metacopy
only file.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/inode.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 7af8a292d54d..fe2d62cc07a7 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -66,6 +66,22 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 	return err;
 }
 
+#define OVL_STATX_ATTR_MASK	(STATX_ATTR_ENCRYPTED | STATX_ATTR_COMPRESSED)
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
@@ -123,8 +139,10 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
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
