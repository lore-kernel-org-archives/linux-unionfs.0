From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v6 08/15] ovl: Fix ovl_getattr() to get number of blocks from lower
Date: Thu,  9 Nov 2017 15:50:12 -0500
Message-ID: <20171109205019.11409-9-vgoyal@redhat.com>
References: <20171109205019.11409-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48152 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753276AbdKIUub (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Nov 2017 15:50:31 -0500
In-Reply-To: <20171109205019.11409-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com

If an inode has been copied up metadata only, then we need to query the
number of blocks from lower and fill up the stat->st_blocks.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/inode.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 405a8c34471b..7ba19a97a8da 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -76,6 +76,10 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 	bool is_dir = S_ISDIR(dentry->d_inode->i_mode);
 	bool samefs = ovl_same_sb(dentry->d_sb);
 	int err;
+	bool metacopy = false;
+
+	if (ovl_dentry_upper(dentry) && !ovl_has_upperdata(dentry))
+		metacopy = true;
 
 	type = ovl_path_real(dentry, &realpath);
 	old_cred = ovl_override_creds(dentry->d_sb);
@@ -93,7 +97,8 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 	if (!is_dir || samefs) {
 		if (OVL_TYPE_ORIGIN(type)) {
 			struct kstat lowerstat;
-			u32 lowermask = STATX_INO | (!is_dir ? STATX_NLINK : 0);
+			u32 lowermask = STATX_INO | STATX_BLOCKS |
+					(!is_dir ? STATX_NLINK : 0);
 
 			ovl_path_lower(dentry, &realpath);
 			err = vfs_getattr(&realpath, &lowerstat,
@@ -117,6 +122,9 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 				WARN_ON_ONCE(stat->dev != lowerstat.dev);
 			else
 				stat->dev = ovl_get_pseudo_dev(dentry);
+
+			if (metacopy)
+				stat->blocks = lowerstat.blocks;
 		}
 		if (samefs) {
 			/*
-- 
2.13.6
