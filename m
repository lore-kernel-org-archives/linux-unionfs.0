From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v6 12/15] ovl: Fix encryption status of a metacopy only file
Date: Thu,  9 Nov 2017 15:50:16 -0500
Message-ID: <20171109205019.11409-13-vgoyal@redhat.com>
References: <20171109205019.11409-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42500 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753356AbdKIUuc (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Nov 2017 15:50:32 -0500
In-Reply-To: <20171109205019.11409-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com

If file is metacopy only, it is possible that lower is encrypted while
other is not. In that case, report file as encrypted (despite the fact
that only data is encrypted while metadata is not).

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/inode.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 7ba19a97a8da..15713d4ac2dd 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -66,6 +66,16 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 	return err;
 }
 
+static void ovl_stat_set_encryption(struct kstat *ustat, struct kstat *lstat) {
+	if (!((lstat->attributes_mask & STATX_ATTR_ENCRYPTED) &&
+	    (lstat->attributes & STATX_ATTR_ENCRYPTED)))
+		return;
+
+	ustat->attributes |= STATX_ATTR_ENCRYPTED;
+	ustat->attributes_mask |= STATX_ATTR_ENCRYPTED;
+}
+
+
 int ovl_getattr(const struct path *path, struct kstat *stat,
 		u32 request_mask, unsigned int flags)
 {
@@ -123,8 +133,10 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 			else
 				stat->dev = ovl_get_pseudo_dev(dentry);
 
-			if (metacopy)
+			if (metacopy) {
 				stat->blocks = lowerstat.blocks;
+				ovl_stat_set_encryption(stat, &lowerstat);
+			}
 		}
 		if (samefs) {
 			/*
-- 
2.13.6
