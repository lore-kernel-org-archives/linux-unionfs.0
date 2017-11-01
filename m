From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v6 4/9] ovl: return anonymous st_dev for lower inodes
Date: Wed,  1 Nov 2017 22:22:48 +0200
Message-ID: <1509567773-25590-5-git-send-email-amir73il@gmail.com>
References: <1509567773-25590-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:57270 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755040AbdKAUWR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 1 Nov 2017 16:22:17 -0400
Received: by mail-wr0-f194.google.com with SMTP id r79so2995901wrb.13
        for <linux-unionfs@vger.kernel.org>; Wed, 01 Nov 2017 13:22:16 -0700 (PDT)
In-Reply-To: <1509567773-25590-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

From: Chandan Rajendra <chandan@linux.vnet.ibm.com>

For non-samefs setup, to make sure that st_dev/st_ino pair
is unique across the system, we return a unique anonymous
st_dev for stat(2) of lower layer inode.

We need to make this change before fixing constant st_dev/st_ino across
copy up for non-samefs. Otherwise, we can end up with two objects
in the system, the real lower inode and the overlay inode which
have same st_dev/st_ino value, but different content.

[amir: simplify ovl_get_pseudo_dev()
       split from allocate anonymous bdev patch]

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index b772e5a2a730..607a50c50042 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -15,6 +15,14 @@
 #include <linux/ratelimit.h>
 #include "overlayfs.h"
 
+
+static dev_t ovl_get_pseudo_dev(struct dentry *dentry)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+
+	return oe->lowerstack[0].layer->pseudo_dev;
+}
+
 int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	int err;
@@ -121,6 +129,13 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 		 */
 		stat->dev = dentry->d_sb->s_dev;
 		stat->ino = dentry->d_inode->i_ino;
+	} else if (!OVL_TYPE_UPPER(type)) {
+		/*
+		 * For non-samefs setup, to make sure that st_dev/st_ino pair
+		 * is unique across the system, we use a unique anonymous
+		 * st_dev for lower layer inode.
+		 */
+		stat->dev = ovl_get_pseudo_dev(dentry);
 	}
 
 	/*
-- 
2.7.4
