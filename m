From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v8 01/15] ovl: Do not look for OVL_XATTR_NLINK if index is not there
Date: Tue, 28 Nov 2017 10:59:45 -0500
Message-ID: <20171128155959.20114-2-vgoyal@redhat.com>
References: <20171128155959.20114-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51980 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754008AbdK1QAM (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 11:00:12 -0500
In-Reply-To: <20171128155959.20114-1-vgoyal@redhat.com>
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

Pass another parameter to function and pass index dentry. If there is
no index dentry, that should mean that we never set OVL_XATTR_NLINK
and just return fallback.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/inode.c     | 6 +++++-
 fs/overlayfs/namei.c     | 2 +-
 fs/overlayfs/overlayfs.h | 1 +
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 00b6b294272a..8dcfe875ace8 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -544,6 +544,7 @@ int ovl_set_nlink_lower(struct dentry *dentry)
 
 unsigned int ovl_get_nlink(struct dentry *lowerdentry,
 			   struct dentry *upperdentry,
+			   struct dentry *index,
 			   unsigned int fallback)
 {
 	int nlink_diff;
@@ -551,6 +552,9 @@ unsigned int ovl_get_nlink(struct dentry *lowerdentry,
 	char buf[13];
 	int err;
 
+	if (!index)
+		return fallback;
+
 	if (!lowerdentry || !upperdentry || d_inode(lowerdentry)->i_nlink == 1)
 		return fallback;
 
@@ -670,7 +674,7 @@ struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
 			goto out;
 		}
 
-		nlink = ovl_get_nlink(lowerdentry, upperdentry,
+		nlink = ovl_get_nlink(lowerdentry, upperdentry, index,
 				      realinode->i_nlink);
 		set_nlink(inode, nlink);
 	} else {
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 5ef69bc09e0c..a11d77361bef 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -435,7 +435,7 @@ int ovl_verify_index(struct dentry *index, struct ovl_path *lower,
 
 	/* Check if index is orphan and don't warn before cleaning it */
 	if (d_inode(index)->i_nlink == 1 &&
-	    ovl_get_nlink(origin.dentry, index, 0) == 0)
+	    ovl_get_nlink(origin.dentry, index, index, 0) == 0)
 		err = -ENOENT;
 
 	dput(origin.dentry);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 13eab09a6b6f..383bbd3b1fd0 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -275,6 +275,7 @@ int ovl_set_nlink_upper(struct dentry *dentry);
 int ovl_set_nlink_lower(struct dentry *dentry);
 unsigned int ovl_get_nlink(struct dentry *lowerdentry,
 			   struct dentry *upperdentry,
+			   struct dentry *index,
 			   unsigned int fallback);
 int ovl_setattr(struct dentry *dentry, struct iattr *attr);
 int ovl_getattr(const struct path *path, struct kstat *stat,
-- 
2.13.6
