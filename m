From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 09/15] ovl: validate lower layer uuid on redirect by fh
Date: Mon,  1 May 2017 16:42:00 +0300
Message-ID: <1493646126-10101-10-git-send-email-amir73il@gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35599 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424497AbdEANmO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 May 2017 09:42:14 -0400
In-Reply-To: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On copy up, we store in xattr overlay.origin the lower file handle
along with the lower fs uuid.

Before decoding the file handle in overlay.origin verify:
- All lower layers are on the same fs
- UUID of lower fs matches the stored uuid

In the future we will support finding the lower layer by uuid so
we won't have to require that all lower layers are on the same fs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c |  8 ++++++--
 fs/overlayfs/super.c | 15 +++++++++++++--
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 695a78e..2be2917 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -343,8 +343,12 @@ static int ovl_find_layer_by_fh(struct dentry *dentry, int idx,
 {
 	struct super_block *same_sb = ovl_same_sb(dentry->d_sb);
 
-	/* We only support redirect_fh when all layers are on the same fs */
-	if (!same_sb)
+	/*
+	 * We only support redirect_fh when all layers are on the same fs.
+	 * Make sure that the stored uuid matches the uuid of the lower
+	 * layer where file handle will be decoded.
+	 */
+	if (!same_sb || memcmp(same_sb->s_uuid, fh->uuid, sizeof(fh->uuid)))
 		return -1;
 
 	/*
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index de246a5..e639750 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -18,6 +18,7 @@
 #include <linux/seq_file.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/exportfs.h>
+#include <linux/uuid.h>
 #include "overlayfs.h"
 #include "ovl_entry.h"
 
@@ -941,10 +942,20 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	 * Also, for NFS export of overlay, it is easier if all layers are on
 	 * the same fs, because then we can export the encoded file handle
 	 * without adding a layer descriptor to it.
+	 *
+	 * We use the lower fs uuid to validate that file handles are decoded
+	 * from the same fs they were encoded from, so redirect_fh requires
+	 * that the lower fs has filled a valid uuid in sb->s_uuid.
 	 */
 	if (ufs->same_sb && ufs->same_sb->s_export_op &&
-	    ufs->same_sb->s_export_op->fh_to_dentry)
-		ufs->redirect_fh = true;
+	    ufs->same_sb->s_export_op->fh_to_dentry) {
+		uuid_le *uuid = (uuid_le *) ufs->same_lower_sb->s_uuid;
+
+		if (uuid_le_cmp(*uuid, NULL_UUID_LE))
+			ufs->redirect_fh = true;
+		else
+			pr_warn("overlayfs: lower fs needs to report s_uuid.\n");
+	}
 
 	if (remote)
 		sb->s_d_op = &ovl_reval_dentry_operations;
-- 
2.7.4
