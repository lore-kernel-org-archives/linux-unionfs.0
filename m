From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v10 01/18] ovl: Do not look for OVL_XATTR_NLINK if index is not there
Date: Mon, 22 Jan 2018 13:39:47 -0500
Message-ID: <20180122184004.26026-2-vgoyal@redhat.com>
References: <20180122184004.26026-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53086 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751240AbeAVSkP (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Jan 2018 13:40:15 -0500
In-Reply-To: <20180122184004.26026-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

Soon, we will be creating OVL_TYPE_ORIGIN entries even for hardlinked
files with index=off. That means, it is possible that there is no
index and hence no OVL_XATTR_NLINK set on upperdentry but lowerdentry
is still there. In that case current implementation gets -ENODATA
from vfs_getxattr)() and it warns and returns fallback. I can get
following warning.

"overlayfs: failed to get index nlink ....."

Pass in index instead of upperdentry in ovl_get_nlink(). That way, if
index is not there, we know that OVL_XATTR_NLINK should not be
present and just return fallback.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/inode.c     | 13 ++++++-------
 fs/overlayfs/overlayfs.h |  2 +-
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 00b6b294272a..903548a6b825 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -543,7 +543,7 @@ int ovl_set_nlink_lower(struct dentry *dentry)
 }
 
 unsigned int ovl_get_nlink(struct dentry *lowerdentry,
-			   struct dentry *upperdentry,
+			   struct dentry *index,
 			   unsigned int fallback)
 {
 	int nlink_diff;
@@ -551,10 +551,10 @@ unsigned int ovl_get_nlink(struct dentry *lowerdentry,
 	char buf[13];
 	int err;
 
-	if (!lowerdentry || !upperdentry || d_inode(lowerdentry)->i_nlink == 1)
+	if (!lowerdentry || !index || d_inode(lowerdentry)->i_nlink == 1)
 		return fallback;
 
-	err = vfs_getxattr(upperdentry, OVL_XATTR_NLINK, &buf, sizeof(buf) - 1);
+	err = vfs_getxattr(index, OVL_XATTR_NLINK, &buf, sizeof(buf) - 1);
 	if (err < 0)
 		goto fail;
 
@@ -567,7 +567,7 @@ unsigned int ovl_get_nlink(struct dentry *lowerdentry,
 	if (err < 0)
 		goto fail;
 
-	nlink = d_inode(buf[0] == 'L' ? lowerdentry : upperdentry)->i_nlink;
+	nlink = d_inode(buf[0] == 'L' ? lowerdentry : index)->i_nlink;
 	nlink += nlink_diff;
 
 	if (nlink <= 0)
@@ -577,7 +577,7 @@ unsigned int ovl_get_nlink(struct dentry *lowerdentry,
 
 fail:
 	pr_warn_ratelimited("overlayfs: failed to get index nlink (%pd2, err=%i)\n",
-			    upperdentry, err);
+			    index, err);
 	return fallback;
 }
 
@@ -670,8 +670,7 @@ struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
 			goto out;
 		}
 
-		nlink = ovl_get_nlink(lowerdentry, upperdentry,
-				      realinode->i_nlink);
+		nlink = ovl_get_nlink(lowerdentry, index, realinode->i_nlink);
 		set_nlink(inode, nlink);
 	} else {
 		inode = new_inode(dentry->d_sb);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index b489099ccd49..edb23f97bd90 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -274,7 +274,7 @@ int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
 int ovl_set_nlink_upper(struct dentry *dentry);
 int ovl_set_nlink_lower(struct dentry *dentry);
 unsigned int ovl_get_nlink(struct dentry *lowerdentry,
-			   struct dentry *upperdentry,
+			   struct dentry *index,
 			   unsigned int fallback);
 int ovl_setattr(struct dentry *dentry, struct iattr *attr);
 int ovl_getattr(const struct path *path, struct kstat *stat,
-- 
2.13.6
