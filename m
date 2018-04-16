Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56016 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752840AbeDPOfa (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Apr 2018 10:35:30 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5C40BABC8
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Apr 2018 14:35:29 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH] ovl: copy up files with incompatible xattrs
Date: Mon, 16 Apr 2018 09:35:25 -0500
Message-Id: <20180416143525.8328-1-rgoldwyn@suse.de>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: rgoldwyn@suse.com, Fabian Vogt <fvogt@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

From: Fabian Vogt <fvogt@suse.com>

xattrs are not guarantees to be compatible across different filesystems.
Operations which lead to copying of files to the upper layer fail with an
"Operation not supported" error from the filesystem if a xattr could not be
written in the upper layer. We can safely ignore "system" xattrs.

One easy to hit example is using NFS as a read-only lower layer and !NFS as
upper layer to store changes. Files on NFS can have the "system.nfs4_acl"
xattr set to make the full information available to userspace, but it cannot
be written to on other filesystems.

Signed-off-by: Fabian Vogt <fvogt@suse.com>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/overlayfs/copy_up.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index d855f508fa20..e7662e9664be 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -125,6 +125,10 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
 			continue; /* Discard */
 		}
 		error = vfs_setxattr(new, name, value, size, 0);
+		if (error == -EOPNOTSUPP && strncmp("system.", name, 7) == 0) {
+			error = 0;
+			continue; /* Discard */
+		}
 		if (error)
 			break;
 	}
-- 
2.16.2

