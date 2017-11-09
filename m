From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v6 13/15] ovl: Fix compression status of a metacopy only file
Date: Thu,  9 Nov 2017 15:50:17 -0500
Message-ID: <20171109205019.11409-14-vgoyal@redhat.com>
References: <20171109205019.11409-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56344 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753778AbdKIUuc (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Nov 2017 15:50:32 -0500
In-Reply-To: <20171109205019.11409-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com

If file is metacopy only, it is possible that lower is compressed while
upper is not. In that case, report file as compressed (despite the fact
that only data is compressed while metadata is not).

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/inode.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 15713d4ac2dd..dc7573ed947a 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -75,6 +75,15 @@ static void ovl_stat_set_encryption(struct kstat *ustat, struct kstat *lstat) {
 	ustat->attributes_mask |= STATX_ATTR_ENCRYPTED;
 }
 
+static void ovl_stat_set_compressed(struct kstat *ustat, struct kstat *lstat) {
+	if (!((lstat->attributes_mask & STATX_ATTR_COMPRESSED) &&
+	    (lstat->attributes & STATX_ATTR_COMPRESSED)))
+		return;
+
+	ustat->attributes |= STATX_ATTR_COMPRESSED;
+	ustat->attributes_mask |= STATX_ATTR_COMPRESSED;
+}
+
 
 int ovl_getattr(const struct path *path, struct kstat *stat,
 		u32 request_mask, unsigned int flags)
@@ -136,6 +145,7 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 			if (metacopy) {
 				stat->blocks = lowerstat.blocks;
 				ovl_stat_set_encryption(stat, &lowerstat);
+				ovl_stat_set_compressed(stat, &lowerstat);
 			}
 		}
 		if (samefs) {
-- 
2.13.6
