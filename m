Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36172 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726036AbfBKQzK (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 11 Feb 2019 11:55:10 -0500
From: Ignaz Forster <iforster@suse.com>
Subject: [PATCH 5/5] Use __vfs_getxattr to get overlayfs xattrs
Date: Mon, 11 Feb 2019 17:53:23 +0100
Message-Id: <20190211165323.9369-6-iforster@suse.com>
In-Reply-To: <20190211165323.9369-1-iforster@suse.com>
References: <20190211165323.9369-1-iforster@suse.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Cc: Fabian Vogt <fvogt@suse.com>, Ignaz Forster <iforster@suse.de>, Fabian Vogt <fvogt@suse.de>
List-ID: <linux-unionfs@vger.kernel.org>

From: Ignaz Forster <iforster@suse.de>

In vfs_getxattr a query of "security.selinux" will return
"unlabeled", while in __vfs_getxattr -ENODATA will be returned for
the same query. This causes a difference in the generated EVM hashes
for the file on the underlying file system and overlayfs.

Circumvent this by calling __vfs_getxattr directly.

Co-developed-by: Fabian Vogt <fvogt@suse.de>
Signed-off-by: Fabian Vogt <fvogt@suse.de>
Signed-off-by: Ignaz Forster <iforster@suse.de>
---
 fs/overlayfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 3b7ed5d2279c..e2c737936576 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -374,7 +374,8 @@ int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char *name,
 		ovl_i_dentry_upper(inode) ?: ovl_dentry_lower(dentry);
 
 	old_cred = ovl_override_creds(dentry->d_sb);
-	res = vfs_getxattr(realdentry, name, value, size);
+	res = __vfs_getxattr(realdentry, d_backing_inode(realdentry),
+			name, value, size);
 	revert_creds(old_cred);
 	return res;
 }
-- 
2.20.1
