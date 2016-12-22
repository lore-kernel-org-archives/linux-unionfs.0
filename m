From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 3/4] ovl: use RENAME_DT_UNKNOWN to optimize stable d_inode
Date: Thu, 22 Dec 2016 19:25:34 +0200
Message-ID: <1482427535-12801-4-git-send-email-amir73il@gmail.com>
References: <1482427535-12801-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34118 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941660AbcLVRZ7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Dec 2016 12:25:59 -0500
Received: by mail-wm0-f65.google.com with SMTP id g23so37393688wme.1
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Dec 2016 09:25:58 -0800 (PST)
In-Reply-To: <1482427535-12801-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Try to use the new vfs rename flag RENAME_DT_UNKNOWN, to request
from underlying file system to mark copy up directory entries as
DT_UNKNOWN instead of their actual file type.

When copy ups are classified as DT_UNKNOWN, ovl_dir_read_merged() can
distinguish between copy up to opaque objects without having to check
the extended attribute trusted.overlay.inode on the iterated entries.

This will allow to know if upper d_inode value needs to be substitued
with lower d_inode value.

Because this is only done for optimization, it is not a problem
if file system does not respect the new RENAME_DT_UNKNOWN flag, which
is most likely the case, so we retry the rename without the flag.

This patch does not implement the actual optimization.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 8 +++++++-
 fs/overlayfs/overlayfs.h | 5 +++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index f57043d..bcbcef5 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -298,7 +298,13 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 	if (err)
 		goto out_cleanup;
 
-	err = ovl_do_rename(wdir, newdentry, udir, upper, 0);
+	/*
+	 * Mark copy up objects in upper as DT_UNKNOWN, so it easy to
+	 * distinguish them from opaque objects in iterate_dir().
+	 * File system repair tools may re-classify the file type
+	 * and that will break optimization, but not functionality.
+	 */
+	err = ovl_do_rename(wdir, newdentry, udir, upper, RENAME_DT_UNKNOWN);
 	if (err)
 		goto out_cleanup;
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 8af450b..54162c0 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -113,6 +113,11 @@ static inline int ovl_do_rename(struct inode *olddir, struct dentry *olddentry,
 
 	err = vfs_rename(olddir, olddentry, newdir, newdentry, NULL, flags);
 
+	/* retry without RENAME_VFS_DTYPE if fs does not support it */
+	if (err == -EINVAL && (flags & RENAME_VFS_DTYPE))
+		err = vfs_rename(olddir, olddentry, newdir, newdentry, NULL,
+				 flags & RENAME_UAPI_MASK);
+
 	if (err) {
 		pr_debug("...rename(%pd2, %pd2, ...) = %i\n",
 			 olddentry, newdentry, err);
-- 
2.7.4
