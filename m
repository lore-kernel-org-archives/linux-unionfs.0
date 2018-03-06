Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33420 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754024AbeCFUyQ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Mar 2018 15:54:16 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v12 15/17] ovl: Remove redirect when data of a metacopy file is copied up
Date: Tue,  6 Mar 2018 15:54:06 -0500
Message-Id: <20180306205408.23383-16-vgoyal@redhat.com>
In-Reply-To: <20180306205408.23383-1-vgoyal@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

When a metacopy file is no longer a metacopy and data has been copied up,
remove REDIRECT xattr. Its not needed anymore.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 0c8d2755bd25..704febd2e2fa 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -775,6 +775,15 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
 	if (err)
 		return err;
 
+	/*
+	 * A metacopy files does not need redirect xattr once data has
+	 * been copied up.
+	 */
+	err = vfs_removexattr(upperpath.dentry, OVL_XATTR_REDIRECT);
+	if (err && err != -ENODATA && err != -EOPNOTSUPP)
+		return err;
+
+	err = 0;
 	ovl_set_upperdata(d_inode(c->dentry));
 	return err;
 }
-- 
2.13.6

