From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v6 14/15] ovl: Introduce read/write barriers around metacopy flag update
Date: Thu,  9 Nov 2017 15:50:18 -0500
Message-ID: <20171109205019.11409-15-vgoyal@redhat.com>
References: <20171109205019.11409-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44810 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753799AbdKIUuc (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Nov 2017 15:50:32 -0500
In-Reply-To: <20171109205019.11409-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com

If a file is copied up metadata only and later when same file is opened
for WRITE, then data copy up takes place. We copy up data, remove METACOPY
xattr and then set the UPPERDATA flag in ovl_entry->flags. While all
these operations happen with oi->lock held, read side of oi->flags is
lockless. That is another thread on another cpu can check if UPPERDATA
flag is set or not.

So this gives us an ordering requirement w.r.t UPPERDATA flag. That is, if
another cpu sees UPPERDATA flag set, then it should be guaranteed that
effects of data copy up and remove xattr operations are also visible.

For example.

	CPU1				CPU2
ovl_d_real()				acquire(oi->lock)
  ovl_copy_up_flags()			 ovl_copy_up_data()
   ovl_dentry_needs_data_copy_up()	 vfs_removexattr()
     ovl_test_flag(OVL_UPPERDATA)        ovl_set_flag(OVK_UPPERDATA)
					release(oi->lock)

Say CPU2 is copying up data and in the end sets UPPERDATA flag. But if
CPU1 perceives the effects of setting UPPERDATA flag but not effects of
preceeding operations, that would be a problem.

Hence this patch introduces smp_wmb() on setting UPPERDATA flag operation
and smp_rmb() on UPPERDATA flag test operation.

May be some other lock or barrier is already covering it. But I am not sure
what that is and is it obvious enough that we will not break it in future.

So hence trying to be safe here and introducing barriers explicitly for
UPPERDATA flag/bit.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/util.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index f70eea77c5c7..81b307c20a8d 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -267,13 +267,26 @@ bool ovl_has_upperdata(struct dentry *dentry) {
 	if (!ovl_should_check_upperdata(dentry))
 		return true;
 
-	return ovl_test_flag(OVL_UPPERDATA, d_inode(dentry));
+	if (!ovl_test_flag(OVL_UPPERDATA, d_inode(dentry)))
+		return false;
+	/*
+	 * Pairs with smp_wmb() in ovl_copy_up_meta_inode_data(). Make sure
+	 * if setting of OVL_UPPERDATA is visible, then effects of writes
+	 * before that are visible too.
+	 */
+	smp_rmb();
+	return true;
 }
 
 void ovl_set_upperdata(struct dentry *dentry) {
 	if (!S_ISREG(d_inode(dentry)->i_mode))
 		return;
-
+	/*
+	 * Pairs with smp_rmb() in ovl_has_upperdata(). Make sure
+	 * if OVL_UPPERDATA flag is visible, then effects of write operations
+	 * before it are visible as well.
+	 */
+	smp_wmb();
 	ovl_set_flag(OVL_UPPERDATA, d_inode(dentry));
 }
 
-- 
2.13.6
