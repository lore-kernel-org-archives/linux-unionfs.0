From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 6/9] ovl: Fix ovl_getattr() to get number of blocks from lower
Date: Tue, 10 Oct 2017 11:32:21 -0400
Message-ID: <1507649544-4539-7-git-send-email-vgoyal@redhat.com>
References: <1507649544-4539-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54522 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932262AbdJJPcj (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 10 Oct 2017 11:32:39 -0400
In-Reply-To: <1507649544-4539-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com, ebiederm@xmission.com

If an inode has been copied up metadata only, then we need to query the
number of blocks from lower and fill up the stat->st_blocks.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/inode.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index e5825b8948e0..d333fd48659f 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -140,6 +140,15 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 	if (!is_dir && ovl_test_flag(OVL_INDEX, d_inode(dentry)))
 		stat->nlink = dentry->d_inode->i_nlink;
 
+	if (ovl_test_flag(OVL_METACOPY, d_inode(dentry))) {
+		struct kstat lowerstat;
+
+		ovl_path_lower(dentry, &realpath);
+		err = vfs_getattr(&realpath, &lowerstat, STATX_BLOCKS, flags);
+		if (err)
+			goto out;
+		stat->blocks = lowerstat.blocks;
+	}
 out:
 	revert_creds(old_cred);
 
-- 
2.13.5
