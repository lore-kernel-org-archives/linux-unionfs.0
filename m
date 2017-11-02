From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v7 4/8] ovl: return anonymous st_dev for lower inodes
Date: Thu,  2 Nov 2017 22:38:07 +0200
Message-ID: <1509655091-13630-5-git-send-email-amir73il@gmail.com>
References: <1509655091-13630-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:45687 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934441AbdKBUhe (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 2 Nov 2017 16:37:34 -0400
Received: by mail-wm0-f66.google.com with SMTP id y80so1369783wmd.0
        for <linux-unionfs@vger.kernel.org>; Thu, 02 Nov 2017 13:37:33 -0700 (PDT)
In-Reply-To: <1509655091-13630-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

From: Chandan Rajendra <chandan@linux.vnet.ibm.com>

For non-samefs setup, to make sure that st_dev/st_ino pair is unique
across the system, we return a unique anonymous st_dev for stat(2)
of lower layer inode.

A following patch is going to fix constant st_dev/st_ino across copy up
by returning origin st_dev/st_ino for copied up objects.

If the st_dev/st_ino for copied up object would have been the same as
that of the real underlying lower file, running diff on underlying lower
file and overlay copied up file would result in diff reporting that the
2 files are equal when in fact, they may have different content.

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
