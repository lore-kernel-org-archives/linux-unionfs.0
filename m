From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 7/7] ovl: Fix ovl_getattr() to get size from lower
Date: Mon,  2 Oct 2017 09:40:05 -0400
Message-ID: <1506951605-31440-8-git-send-email-vgoyal@redhat.com>
References: <1506951605-31440-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59972 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750957AbdJBNkP (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 2 Oct 2017 09:40:15 -0400
In-Reply-To: <1506951605-31440-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com

If an inode has been copied up metadata only, then we need to query the
size from lower and fill up the stat->size.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/inode.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index e5825b8948e0..1b676deacc2d 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -140,6 +140,16 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 	if (!is_dir && ovl_test_flag(OVL_INDEX, d_inode(dentry)))
 		stat->nlink = dentry->d_inode->i_nlink;
 
+	if (ovl_test_flag(OVL_METACOPY, d_inode(dentry))) {
+		struct kstat lowerstat;
+		u32 lowermask = STATX_SIZE;
+
+		ovl_path_lower(dentry, &realpath);
+		err = vfs_getattr(&realpath, &lowerstat, lowermask, flags);
+		if (err)
+			goto out;
+		stat->size = lowerstat.size;
+	}
 out:
 	revert_creds(old_cred);
 
-- 
2.13.5
