Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60216 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726077AbfAPRjt (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Jan 2019 12:39:49 -0500
Date: Wed, 16 Jan 2019 11:39:45 -0600
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH] ovl: IMA Call ima_post_mknod_path() on copy_up'd dentry
Message-ID: <20190116173945.mmnwsw5bglk6yryj@merlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: zohar@linux.ibm.com, iforster@suse.de, linux-integrity@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Since copy_up() happens when you are modifying a file on overlay,
it is still a new file for the underlying filesystem. Mark it
in IMA for re-evaluating as a new file.

Putting ima calls within overlayfs may not be the best method, but this is
the only one which I thought would work.

Here is a test case:
mount /dev/vdb /lower
mount /dev/vdc /upper
echo "Original contents" > /lower/existingfile.txt
mount -t overlay overlay /mnt -o upperdir=/upper/upper,workdir=/upper/workdir,lowerdir=/lower
echo "New contents" > /mnt/existingfile.txt

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/overlayfs/copy_up.c            | 8 ++++++++
 security/integrity/ima/ima_main.c | 1 +
 2 files changed, 9 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 9e62dcf06fc4..f3f7f65ce4d3 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -21,6 +21,7 @@
 #include <linux/fdtable.h>
 #include <linux/ratelimit.h>
 #include <linux/exportfs.h>
+#include <linux/ima.h>
 #include "overlayfs.h"
 
 #define OVL_COPY_UP_CHUNK_SIZE (1 << 20)
@@ -102,6 +103,11 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
 			goto retry;
 		}
 
+		if (!strcmp(name, XATTR_NAME_IMA)) {
+			ima_post_path_mknod(new);
+			continue;
+		}
+
 		error = security_inode_copy_up_xattr(name);
 		if (error < 0 && error != -EOPNOTSUPP)
 			break;
@@ -485,6 +491,8 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 		err = ovl_set_size(temp, &c->stat);
 	if (!err)
 		err = ovl_set_attr(temp, &c->stat);
+	if (!err)
+		ima_post_path_mknod(c->dentry);
 	inode_unlock(temp->d_inode);
 
 	return err;
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index dbd4c8decde0..2229ea2a0ba6 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -449,6 +449,7 @@ void ima_post_path_mknod(struct dentry *dentry)
 	/* needed for re-opening empty files */
 	iint->flags |= IMA_NEW_FILE;
 }
+EXPORT_SYMBOL_GPL(ima_post_path_mknod);
 
 /**
  * ima_read_file - pre-measure/appraise hook decision based on policy
-- 
2.16.4


-- 
Goldwyn
