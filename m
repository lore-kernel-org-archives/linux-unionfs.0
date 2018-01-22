From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v10 17/18] ovl: Do not expose metacopy only upper dentry from d_real()
Date: Mon, 22 Jan 2018 13:40:03 -0500
Message-ID: <20180122184004.26026-18-vgoyal@redhat.com>
References: <20180122184004.26026-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53306 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751209AbeAVSkS (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Jan 2018 13:40:18 -0500
In-Reply-To: <20180122184004.26026-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

d_real() can make a upper metacopy dentry/inode visible to the vfs layer.
This is something new and vfs layer does not know that this inode contains
only metadata and not data. And this could break things.

So to be safe, do not expose metacopy only dentry/inode to vfs using
d_real().

IOW, d_real() will not reuturn metacopy dentry. Instead, it will return
dentry corresponding lower dentry/inode which has file data.

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
  need to update mtime and ctime in this case. Its already updated, hence
  even if d_real(D_REAL_UPPER) returns nil, it should be fine.

- For metadata inode, mtime should be same as lower and not change. (data
  can't be modified on metadata inode without copyup). IOW, mtime of
  ovl dentry should be same as mtime of underlying metadata inode on upper
  always. So there is no need to update it.

- For file writes, ctime and mtime will be updated. But in that case
  first data will be copied up and this will not be a metadata inode
  anymore. And furthr call to d_real(D_REAL_UPPER) will return upper
  inode and new mtime and ctime will be obtainable.

So atime updates should work just fine for metacopy inodes. I think only
corner case is if somehow underlying filesystem changes ctime of upper
metadata inode without overlay knowing about it. Not sure how that
can happen. If somehow is affected by that, then we probably can implement
another flag which will allow caller to get metacopy inode as well.
Something like d_real(D_REAL_UPPER | D_METACOPY). And that should solve
this issue.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/super.c     | 21 +++++++++++++++++----
 fs/overlayfs/util.c      | 15 +++++++++++++++
 3 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index b663a65826a7..c712ab7274f9 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -214,6 +214,7 @@ void ovl_path_lowerdata(struct dentry *dentry, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
 struct dentry *ovl_dentry_lower(struct dentry *dentry);
+struct dentry *ovl_dentry_lowerdata(struct dentry *dentry);
 struct dentry *ovl_dentry_real(struct dentry *dentry);
 struct dentry *ovl_i_dentry_upper(struct inode *inode);
 struct inode *ovl_inode_upper(struct inode *inode);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index a6e3719a599b..f5cacae8269a 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -91,8 +91,14 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
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
@@ -108,15 +114,22 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 
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
 
-	real = ovl_dentry_lower(dentry);
+lower:
+	real = ovl_dentry_lowerdata(dentry);
 	if (!real)
 		goto bug;
 
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 8d6cf8ceb6ff..f57f2cfccbd4 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -175,6 +175,21 @@ struct dentry *ovl_dentry_lower(struct dentry *dentry)
 	return oe->numlower ? oe->lowerstack[0].dentry : NULL;
 }
 
+struct dentry *ovl_dentry_lowerdata(struct dentry *dentry)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+	int i;
+
+	for(i = 0 ; i < oe->numlower; i++) {
+		if (oe->lowerstack[i].metacopy)
+			continue;
+
+		return oe->lowerstack[i].dentry;
+	}
+
+	return NULL;
+}
+
 struct dentry *ovl_dentry_real(struct dentry *dentry)
 {
 	return ovl_dentry_upper(dentry) ?: ovl_dentry_lower(dentry);
-- 
2.13.6
