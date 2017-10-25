From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 11/13] ovl: Introduce read/write barriers around metacopy flag update
Date: Wed, 25 Oct 2017 15:09:33 -0400
Message-ID: <1508958575-14086-12-git-send-email-vgoyal@redhat.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13984 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932367AbdJYTJn (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 25 Oct 2017 15:09:43 -0400
In-Reply-To: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com

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
ovl_copy_up_flags()			acquire(oi->lock)
 ovl_dentry_needs_data_copy_up()	  ovl_copy_up_data()
   ovl_test_flag(OVL_UPPERDATA)		  vfs_removexattr()
					  ovl_set_flag(OVL_UPPERDATA)
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
 fs/overlayfs/copy_up.c |  7 ++++++-
 fs/overlayfs/super.c   | 13 ++++++++++---
 fs/overlayfs/util.c    | 11 ++++++++++-
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index a6cda02..4876ae4 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -466,7 +466,12 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
 	err= vfs_removexattr(upperpath.dentry, OVL_XATTR_METACOPY);
 	if (err)
 		return err;
-
+	/*
+	 * Pairs with smp_rmb() in ovl_dentry_needs_data_copy_up(). Make sure
+	 * if OVL_UPPERDATA flag is visible, then all the write operations
+	 * before it are visible as well.
+	 */
+	smp_wmb();
 	ovl_set_flag(OVL_UPPERDATA, d_inode(c->dentry));
 	return err;
 }
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 4cf1f98..e97dccb 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -102,9 +102,16 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 			if (err)
 				return ERR_PTR(err);
 
-			if (ovl_dentry_check_upperdata(dentry) &&
-			    !ovl_test_flag(OVL_UPPERDATA, d_inode(dentry)))
-				goto lower;
+			if (ovl_dentry_check_upperdata(dentry)) {
+				if (!ovl_test_flag(OVL_UPPERDATA,
+				    d_inode(dentry)))
+					goto lower;
+				/*
+				 * Pairs with smp_wmb in
+				 * ovl_copy_up_meta_inode_data()
+				 */
+				smp_rmb();
+			}
 		}
 		return real;
 	}
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index ef720a9..d0f3bf7 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -238,6 +238,8 @@ bool ovl_dentry_check_upperdata(struct dentry *dentry) {
 }
 
 bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags) {
+	bool upperdata;
+
 	if (!ovl_dentry_check_upperdata(dentry))
 		return false;
 
@@ -250,7 +252,14 @@ bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags) {
 	if (!(OPEN_FMODE(flags) & FMODE_WRITE))
 		return false;
 
-	if (likely(ovl_test_flag(OVL_UPPERDATA, d_inode(dentry))))
+	upperdata = ovl_test_flag(OVL_UPPERDATA, d_inode(dentry));
+	/*
+	 * Pairs with smp_wmb() in ovl_copy_up_meta_inode_data(). Make sure
+	 * if setting of OVL_UPPERDATA is visible, then effects of writes
+	 * before that are visible too.
+	 */
+	smp_rmb();
+	if (upperdata)
 		return false;
 
 	return true;
-- 
2.5.5
