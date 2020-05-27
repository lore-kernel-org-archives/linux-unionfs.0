Return-Path: <SRS0=jndh=7J=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB68C433E0
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 May 2020 03:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA572207CB
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 May 2020 03:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbgE0DpX (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 26 May 2020 23:45:23 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5345 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728293AbgE0DpX (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 26 May 2020 23:45:23 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C00FBB6DB72DADA2EC5B;
        Wed, 27 May 2020 11:45:20 +0800 (CST)
Received: from fedora-aep.huawei.cmm (10.175.113.49) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 27 May 2020 11:45:13 +0800
From:   yangerkun <yangerkun@huawei.com>
To:     <vgoyal@redhat.com>, <miklos@szeredi.hu>, <amir73il@gmail.com>
CC:     <linux-unionfs@vger.kernel.org>, <yangerkun@huawei.com>
Subject: [PATCH] ovl: fix some bug exist in ovl_get_inode
Date:   Wed, 27 May 2020 12:17:11 +0800
Message-ID: <20200527041711.60219-1-yangerkun@huawei.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.49]
X-CFilter-Loop: Reflected
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Run generic/461 with ext4 upper/lower layer sometimes may trigger the
bug as below(linux 4.19):

[  551.001349] overlayfs: failed to get metacopy (-5)
[  551.003464] overlayfs: failed to get inode (-5)
[  551.004243] overlayfs: cleanup of 'd44/fd51' failed (-5)
[  551.004941] overlayfs: failed to get origin (-5)
[  551.005199] ------------[ cut here ]------------
[  551.006697] WARNING: CPU: 3 PID: 24674 at fs/inode.c:1528 iput+0x33b/0x400
...
[  551.027219] Call Trace:
[  551.027623]  ovl_create_object+0x13f/0x170
[  551.028268]  ovl_create+0x27/0x30
[  551.028799]  path_openat+0x1a35/0x1ea0
[  551.029377]  do_filp_open+0xad/0x160
[  551.029944]  ? vfs_writev+0xe9/0x170
[  551.030499]  ? page_counter_try_charge+0x77/0x120
[  551.031245]  ? __alloc_fd+0x160/0x2a0
[  551.031832]  ? do_sys_open+0x189/0x340
[  551.032417]  ? get_unused_fd_flags+0x34/0x40
[  551.033081]  do_sys_open+0x189/0x340
[  551.033632]  __x64_sys_creat+0x24/0x30
[  551.034219]  do_syscall_64+0xd5/0x430
[  551.034800]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
...
[  556.107515] BUG: Dentry 000000006bc1d73f{i=4129c,n=fd51}  still in use (-1) [unmount of ext4 sdb]
[  556.108946] ------------[ cut here ]------------
[  556.109686] WARNING: CPU: 1 PID: 24682 at fs/dcache.c:1557 umount_check+0x95/0xc0
[  556.130343]  d_walk+0x10d/0x430
[  556.130832]  do_one_tree+0x30/0x60
[  556.131365]  shrink_dcache_for_umount+0x38/0xe0
[  556.132063]  generic_shutdown_super+0x2e/0x1c0
[  556.132747]  kill_block_super+0x29/0x80
[  556.133338]  deactivate_locked_super+0x7a/0x100
[  556.134034]  deactivate_super+0x9d/0xb0
[  556.134627]  cleanup_mnt+0x67/0x100
[  556.135173]  __cleanup_mnt+0x16/0x20
[  556.135731]  task_work_run+0xdb/0x110
[  556.136306]  exit_to_usermode_loop+0x197/0x1b0
[  556.136991]  do_syscall_64+0x3ce/0x430
[  556.137571]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
...
[  556.378140] VFS: Busy inodes after unmount of sdb. Self-destruct in 5 seconds.  Have a nice day...

After check the code, there may some bug need to fix:
1. We need to call iput once ovl_check_metacopy_xattr fail.
2. We need to call unlock_new_inode or the above iput(also with iput in
   ovl_create_object) will trigger the a WARN_ON since  the I_NEW still
   exists.
3. We should move the init for upperdentry to the place below
   ovl_check_metacopy_xattr. Or the dentry reference will decrease to
   -1(error path in ovl_create_upper will inc, ovl_destroy_inode too).

Fixes: 9d3dfea3d35a ("ovl: Modify ovl_lookup() and friends to lookup metacopy dentry")
Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 fs/overlayfs/inode.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 981f11ec51bc..8f59e89e14e8 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -959,7 +959,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 	int fsid = bylower ? lowerpath->layer->fsid : 0;
 	bool is_dir, metacopy = false;
 	unsigned long ino = 0;
-	int err = oip->newinode ? -EEXIST : -ENOMEM;
+	int err = 0;
 
 	if (!realinode)
 		realinode = d_inode(lowerdentry);
@@ -975,8 +975,11 @@ struct inode *ovl_get_inode(struct super_block *sb,
 		unsigned int nlink = is_dir ? 1 : realinode->i_nlink;
 
 		inode = ovl_iget5(sb, oip->newinode, key);
-		if (!inode)
+		if (!inode) {
+			err = oip->newinode ? -EEXIST : -ENOMEM;
 			goto out_err;
+		}
+
 		if (!(inode->i_state & I_NEW)) {
 			/*
 			 * Verify that the underlying files stored in the inode
@@ -984,7 +987,6 @@ struct inode *ovl_get_inode(struct super_block *sb,
 			 */
 			if (!ovl_verify_inode(inode, lowerdentry, upperdentry,
 					      true)) {
-				iput(inode);
 				err = -ESTALE;
 				goto out_err;
 			}
@@ -1009,8 +1011,6 @@ struct inode *ovl_get_inode(struct super_block *sb,
 		ino = realinode->i_ino;
 		fsid = lowerpath->layer->fsid;
 	}
-	ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev);
-	ovl_inode_init(inode, oip, ino, fsid);
 
 	if (upperdentry && ovl_is_impuredir(upperdentry))
 		ovl_set_flag(OVL_IMPURE, inode);
@@ -1027,6 +1027,8 @@ struct inode *ovl_get_inode(struct super_block *sb,
 			ovl_set_flag(OVL_UPPERDATA, inode);
 	}
 
+	ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev);
+	ovl_inode_init(inode, oip, ino, fsid);
 	OVL_I(inode)->redirect = oip->redirect;
 
 	if (bylower)
@@ -1040,13 +1042,20 @@ struct inode *ovl_get_inode(struct super_block *sb,
 		}
 	}
 
-	if (inode->i_state & I_NEW)
+clear_new:
+	if (inode && (inode->i_state & I_NEW))
 		unlock_new_inode(inode);
+	if (err < 0) {
+		/* Or the iput show be called by ovl_create_object. */
+		if (inode && (inode != oip->newinode))
+			iput(inode);
+
+		inode = ERR_PTR(err);
+	}
 out:
 	return inode;
 
 out_err:
 	pr_warn_ratelimited("failed to get inode (%i)\n", err);
-	inode = ERR_PTR(err);
-	goto out;
+	goto clear_new;
 }
-- 
2.21.3

