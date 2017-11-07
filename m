From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v8 5/9] ovl: return anonymous st_dev for lower inodes
Date: Tue,  7 Nov 2017 18:58:05 +0200
Message-ID: <1510073889-11657-6-git-send-email-amir73il@gmail.com>
References: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:46543 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754954AbdKGQ5i (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 11:57:38 -0500
Received: by mail-wm0-f65.google.com with SMTP id r68so5176677wmr.1
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Nov 2017 08:57:38 -0800 (PST)
In-Reply-To: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

For non-samefs setup, to make sure that st_dev/st_ino pair is unique
across the system, we return a unique anonymous st_dev for stat(2)
of lower layer inode.

A following patch is going to fix constant st_dev/st_ino across copy up
by returning origin st_dev/st_ino for copied up objects.

If the st_dev/st_ino for copied up object would have been the same as
that of the real underlying lower file, running diff on underlying lower
file and overlay copied up file would result in diff reporting that the
2 files are equal when in fact, they may have different content.

[amir: split from allocate anonymous bdev patch
       simplify get pseudo dev code]

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 6c54ecff56ee..29b0adc77ebe 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -15,6 +15,7 @@
 #include <linux/ratelimit.h>
 #include "overlayfs.h"
 
+
 int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	int err;
@@ -60,6 +61,7 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 
 static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat)
 {
+	struct ovl_layer *lower_layer = ovl_layer_lower(dentry);
 	bool samefs = ovl_same_sb(dentry->d_sb);
 
 	if (samefs) {
@@ -81,6 +83,14 @@ static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat)
 		 */
 		stat->dev = dentry->d_sb->s_dev;
 		stat->ino = dentry->d_inode->i_ino;
+	} else if (lower_layer) {
+		/*
+		 * For non-samefs setup, if we cannot map all layers st_ino
+		 * to a unified address space, we need to make sure that st_dev
+		 * is unique per layer. Upper layer uses real st_dev and lower
+		 * layers use the unique anonymous bdev.
+		 */
+		stat->dev = lower_layer->pseudo_dev;
 	}
 
 	return 0;
-- 
2.7.4
