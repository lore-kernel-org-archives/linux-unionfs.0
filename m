From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 11/11] ovl: Put barriers to order oi->__upperdentry and OVL_METACOPY update
Date: Tue, 17 Oct 2017 17:05:58 -0400
Message-ID: <1508274358-17456-12-git-send-email-vgoyal@redhat.com>
References: <1508274358-17456-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761035AbdJQVG2 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 17:06:28 -0400
In-Reply-To: <1508274358-17456-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com

OVL_METACOPY in oi->flags can be accessed in lockless manner. So if a file
is being copied up metadata only, we need to make sure that upperdentry is
visible only after OVL_METACOPY flag has been set. IOW, if oi->__upperdentry
is visble to a cpu, then we also need to make sure any updates to OVL_METACOPY
flags are visible too.

Otherwise it might happen that a file was copied up metadata only but d_real()
might think that this is not a metacopy only dentry and return upper dentry
instead of lower dentry. Something similar might happen on getattr() path. We
might return number of blocks from upper dentry instead of querying lower and
getting number of blocks from there.

There is already a smp_read_barrier_depends(), when we fetch oi->__upperdentry
pointer.

static inline struct dentry *ovl_upperdentry_dereference(struct ovl_inode *oi)
{
        return lockless_dereference(oi->__upperdentry);
}

lockless_deference() has smp_read_barrier_depends().

My understanding is that, this is a data dependency barrier and not a full
read barrier. So it will only make sure that any updates to "dentry" are
visible but there are no guarantees about oi->flags updates. So a data
dependency barrier might not be sufficient.

Hence this patch introduces an extra smp_rmb() explicitly. So following is
the intended pattern.

	CPU1					CPU2

	LOAD oi->__upperdentry			STORE oi->flags
	smp_rmb();				smp_wmb();
	LOAD oi->flags				STORE oi->__upperdentry;

This should make sure that if any oi->__upperdentry is visible to CPU1, then
updates to oi->flags are visible too.

Question1: Should we replace data dependency barrier with full read barrier
in ovl_upperdentry_dereference(), instead?

Question2: Am I overthinking and these barriers are not needed and some
	   other implicity barriers already cover this situation.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/inode.c | 5 +++++
 fs/overlayfs/super.c | 6 ++++++
 fs/overlayfs/util.c  | 6 ++++++
 3 files changed, 17 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index ad30edc0f425..ee623674628e 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -140,6 +140,11 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 	if (!is_dir && ovl_test_flag(OVL_INDEX, d_inode(dentry)))
 		stat->nlink = dentry->d_inode->i_nlink;
 
+	/*
+	 * Pairs with smp_wmb() in ovl_inode_update(). Make sure if upperdenty
+	 * is visible, then any possible udpate to OVL_METACOPY is visible too.
+	 */
+	smp_rmb();
 	if (ovl_test_flag(OVL_METACOPY, d_inode(dentry))) {
 		struct kstat lowerstat;
 
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index fa802c89235a..fc6a78b31739 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -102,6 +102,12 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 			if (err)
 				return ERR_PTR(err);
 
+			/*
+			 * Pairs with smp_wmb() in ovl_inode_update(). Make
+			 * sure if upper dentry is visible, then any updates
+			 * to OVL_METACOPY flags are visible too.
+			 */
+			smp_rmb();
 			if (ovl_test_flag(OVL_METACOPY, d_inode(dentry)))
 				goto lower;
 		}
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 6bca9a960c6d..8567a9d59230 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -239,6 +239,12 @@ bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags) {
 	if (!(OPEN_FMODE(flags) & FMODE_WRITE))
 		return false;
 
+	/*
+	 * This smp_rmb() pairs with smp_wmb() in ovl_inode_update(). Basically
+	 * we are trying to make sure that if upper dentry is visible, then
+	 * make sure OVL_METACOPY flag is visible too.
+	 */
+	smp_rmb();
 	metacopy = ovl_test_flag(OVL_METACOPY, d_inode(dentry));
 	/*
 	 * Pairs with smp_wmb() while clearing OVL_METACOPY. Make sure if
-- 
2.13.5
