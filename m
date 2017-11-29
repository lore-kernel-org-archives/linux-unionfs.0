From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v9 14/15] ovl: Fix encryption/compression status of a metacopy only file
Date: Wed, 29 Nov 2017 10:54:47 -0500
Message-ID: <20171129155448.32721-15-vgoyal@redhat.com>
References: <20171129155448.32721-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41432 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933572AbdK2PzC (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 29 Nov 2017 10:55:02 -0500
In-Reply-To: <20171129155448.32721-1-vgoyal@redhat.com>
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
 fs/overlayfs/inode.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 605308a9d60f..0b83efaac9e0 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -66,6 +66,24 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 	return err;
 }
 
+#define OVL_STATX_ATTR_MASK	(STATX_ATTR_ENCRYPTED | STATX_ATTR_COMPRESSED)
+
+static void ovl_stat_fix_attributes(struct kstat *ustat, struct kstat *lstat)
+{
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
@@ -123,8 +141,10 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
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
