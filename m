From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v9 13/15] ovl: Do not expose metacopy only upper dentry from d_real()
Date: Wed, 29 Nov 2017 10:54:46 -0500
Message-ID: <20171129155448.32721-14-vgoyal@redhat.com>
References: <20171129155448.32721-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60228 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933563AbdK2Py7 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 29 Nov 2017 10:54:59 -0500
In-Reply-To: <20171129155448.32721-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

d_real() can make a upper metacopy dentry/inode visible to the vfs layer.
This is something new and vfs layer does not know that this inode contains
only metadata and not data. And this could break things.

So to be safe, do not expose metacopy only dentry/inode to vfs using
d_real().

For regular d_real() call (inode == NULL, D_REAL_UPPER not set), if upper
dentry inode is metacopy only and does not have data, return lower dentry.

If d_real() is called with flag D_REAL_UPPER, return upper dentry only if
it has data (flag OVL_UPPERDATA is set).

Similiarly, if d_real(inode=X) is called, a warning is emitted if returned
dentry/inode does not have OVL_UPPERDATA set. This should not happen as
we never made this metacopy inode visible to vfs so nobody should be
calling overlayfs back with inode=metacopy_inode.

I scanned the code and I don't think it breaks any of the existing code.
There are two users of D_REAL_UPPER. may_write_real() and
update_ovl_inode_times().

may_write_real(), will get an NULL dentry if upper inode is metacopy only
and it will return -EPERM. Effectively, we are disallowing modifications
to metacopy only inode from this interface. Though there is opportunity
to improve it. (Allow chattr on metacopy inodes).

update_ovl_inode_times() gets inode mtime and ctime from real inode. It
should not be broken for metacopy inode as well for following reasons.


- For any metadata operations (setattr, acl etc), overlay always calls
  ovl_copyattr() and updates ovl inode mtime and ctime. So there is no
  need to update mtime and ctime in this case. Its already updated.

- For metadata inode, mtime should be same as lower and not change. (data
  can't be modified on metadata inode without copyup).

- For file writes, ctime and mtime will be updated. But in that case
  first data will be copied up and this will not be a metadata inode
  anymore. And furthr call to d_real(D_REAL_UPPER) will return upper
  inode and new mtime and ctime will be obtainable.

So atime updates should work just fine for metacopy inodes.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/super.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 3ff60e6381c4..97dc047ffe79 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -84,8 +84,14 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 	struct dentry *real;
 	int err;
 
-	if (flags & D_REAL_UPPER)
-		return ovl_dentry_upper(dentry);
+	if (flags & D_REAL_UPPER) {
+		real = ovl_dentry_upper(dentry);
+		if (!real)
+			return NULL;
+		if (!ovl_has_upperdata(dentry))
+			return NULL;
+		return real;
+	}
 
 	if (!d_is_reg(dentry)) {
 		if (!inode || inode == d_inode(dentry))
@@ -101,14 +107,21 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 
 	real = ovl_dentry_upper(dentry);
 	if (real && (!inode || inode == d_inode(real))) {
+		bool metacopy = !ovl_has_upperdata(dentry);
 		if (!inode) {
 			err = ovl_check_append_only(d_inode(real), open_flags);
 			if (err)
 				return ERR_PTR(err);
-		}
+
+			if (unlikely(metacopy))
+				goto lower;
+		} else if (unlikely(metacopy))
+			goto bug;
+
 		return real;
 	}
 
+lower:
 	real = ovl_dentry_lower(dentry);
 	if (!real)
 		goto bug;
-- 
2.13.6
