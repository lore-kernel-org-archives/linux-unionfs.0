From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 10/11] ovl: Introduce read/write barriers around metacopy flag update
Date: Tue, 17 Oct 2017 17:05:57 -0400
Message-ID: <1508274358-17456-11-git-send-email-vgoyal@redhat.com>
References: <1508274358-17456-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40482 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761044AbdJQVG2 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 17:06:28 -0400
In-Reply-To: <1508274358-17456-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com

If a file is copied up metadata only and later when same file is opened
for WRITE, then data copy up takes place. We copy up data, remove METACOPY
xattr and then clear the METACOPY flag from ovl_entry->flags. While all
these operations happen with oi->lock held, read side of oi->flags is
lockless. That is another thread on another cpu can check if METACOPY
flag is clear or not.

So this gives us an ordering requirement w.r.t METACOPY flag. That is, if
another cpu sees METACOPY flag clear, then it should be guaranteed that
effects of data copy up and remove xattr operations are also visible.

For example.

	CPU1				CPU2
ovl_copy_up_flags()			acquire(oi->lock)
 ovl_dentry_needs_data_copy_up()	  ovl_copy_up_data()
   ovl_test_flag(OVL_METACOPY)		  vfs_removexattr()
					  ovl_clear_metacopy_flag()
					release(oi->lock)

Say CPU2 is copying up data and in the end clears metacopy flag. But if
CPU1 perceives the effects of clearing of metacopy flag but not effects of
preceeding operations, that would be a problem.

Hence this patch introduces smp_wmb() on metacopy flag clear operation
and smp_rmb() on metacopy flag test operation.

May be some other lock or barrier is already covering it. But I am not sure
what that is and is it obvious enough that we will not break it in future.

So hence trying to be safe here and introducing barriers explicitly for
metacopy bit.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c |  6 ++++++
 fs/overlayfs/util.c    | 12 ++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 99b7be4ff4fc..200ee3b7d397 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -466,6 +466,12 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
 	if (err)
 		return err;
 
+	/*
+	 * Pairs with smp_rmb() after test_bit(OVL_METACOPY). Make sure
+	 * if OVL_METACOPY flag reset is visible, then all the write
+	 * operations before it are visible as well
+	 */
+	smp_wmb();
 	ovl_clear_flag(OVL_METACOPY, d_inode(c->dentry));
 	return err;
 }
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 91c542d1a39d..6bca9a960c6d 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -228,6 +228,8 @@ void ovl_dentry_set_upper_alias(struct dentry *dentry)
 }
 
 bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags) {
+	bool metacopy;
+
 	if (!S_ISREG(d_inode(dentry)->i_mode))
 		return false;
 
@@ -237,9 +239,15 @@ bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags) {
 	if (!(OPEN_FMODE(flags) & FMODE_WRITE))
 		return false;
 
-	if (!ovl_test_flag(OVL_METACOPY, d_inode(dentry)))
+	metacopy = ovl_test_flag(OVL_METACOPY, d_inode(dentry));
+	/*
+	 * Pairs with smp_wmb() while clearing OVL_METACOPY. Make sure if
+	 * clearing of OVL_METACOPY is visible, then effects of writes
+	 * before that are visible too.
+	 */
+	smp_rmb();
+	if (!metacopy)
 		return false;
-
 	return true;
 }
 
-- 
2.13.5
