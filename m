From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 08/13] ovl: Fix ovl_getattr() to get number of blocks from lower
Date: Wed, 25 Oct 2017 15:09:30 -0400
Message-ID: <1508958575-14086-9-git-send-email-vgoyal@redhat.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53268 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932344AbdJYTJn (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 25 Oct 2017 15:09:43 -0400
In-Reply-To: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com

If an inode has been copied up metadata only, then we need to query the
number of blocks from lower and fill up the stat->st_blocks.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/inode.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 1b4b42c..dcc012c 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -140,6 +140,18 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 	if (!is_dir && ovl_test_flag(OVL_INDEX, d_inode(dentry)))
 		stat->nlink = dentry->d_inode->i_nlink;
 
+	if (ovl_dentry_upper(dentry) && ovl_dentry_check_upperdata(dentry) &&
+	    !ovl_test_flag(OVL_UPPERDATA, d_inode(dentry))) {
+		struct kstat lowerstat;
+
+		if (WARN_ON(!OVL_TYPE_ORIGIN(type)))
+			goto out;
+		ovl_path_lower(dentry, &realpath);
+		err = vfs_getattr(&realpath, &lowerstat, STATX_BLOCKS, flags);
+		if (err)
+			goto out;
+		stat->blocks = lowerstat.blocks;
+	}
 out:
 	revert_creds(old_cred);
 
-- 
2.5.5
