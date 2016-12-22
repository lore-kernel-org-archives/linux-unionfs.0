From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 2/4] xfs: support RENAME_VFS_DTYPE flag
Date: Thu, 22 Dec 2016 19:25:33 +0200
Message-ID: <1482427535-12801-3-git-send-email-amir73il@gmail.com>
References: <1482427535-12801-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34101 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941681AbcLVRZ6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Dec 2016 12:25:58 -0500
Received: by mail-wm0-f67.google.com with SMTP id g23so37393583wme.1
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Dec 2016 09:25:57 -0800 (PST)
In-Reply-To: <1482427535-12801-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

If caller provided the target dtype to use and indicated that with
rename() flag RENAME_VFS_DTYPE, use RENAME_DT_MODE(flags) instead
of inode->i_mode to determine the value of dtype to store in the
directory entry.

Adding this functionality to official xfs code will require to add
a new feature flag to xfs directry naming on-disk format.

Without that new feature flag, xfs_repair will report that custom
dtype as a warning and set it back to the dtype value according to mode.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_dir2.c |  1 +
 fs/xfs/xfs_iops.c        | 11 ++++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 984530e..71c6b2b 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -49,6 +49,7 @@ const unsigned char xfs_dtype_to_ftype[DT_MAX] = {
 	[DT_FIFO]   = XFS_DIR3_FT_FIFO,
 	[DT_SOCK]   = XFS_DIR3_FT_SOCK,
 	[DT_LNK]    = XFS_DIR3_FT_SYMLINK,
+	[DT_WHT]    = XFS_DIR3_FT_WHT,
 };
 
 /*
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d2da9ca..8574155 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -394,19 +394,24 @@ xfs_vn_rename(
 	unsigned int	flags)
 {
 	struct inode	*new_inode = d_inode(ndentry);
-	int		omode = 0;
+	int		omode = 0, nmode = 0;
 	struct xfs_name	oname;
 	struct xfs_name	nname;
 
-	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
+	if (flags & ~RENAME_VFS_MASK)
 		return -EINVAL;
 
 	/* if we are exchanging files, we need to set i_mode of both files */
 	if (flags & RENAME_EXCHANGE)
 		omode = d_inode(ndentry)->i_mode;
+	/* if requested, use provided dtype for target */
+	if (flags & RENAME_VFS_DTYPE)
+		nmode = RENAME_DT_MODE(flags);
+	else
+		nmode = d_inode(odentry)->i_mode;
 
 	xfs_dentry_to_name(&oname, odentry, omode);
-	xfs_dentry_to_name(&nname, ndentry, d_inode(odentry)->i_mode);
+	xfs_dentry_to_name(&nname, ndentry, nmode);
 
 	return xfs_rename(XFS_I(odir), &oname, XFS_I(d_inode(odentry)),
 			  XFS_I(ndir), &nname,
-- 
2.7.4
