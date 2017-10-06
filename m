From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH 2/3] ovl: relax same fs constrain for constant st_ino
Date: Fri,  6 Oct 2017 14:55:34 +0530
Message-ID: <20171006092535.15199-2-chandan@linux.vnet.ibm.com>
References: <20171006092535.15199-1-chandan@linux.vnet.ibm.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52792 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751784AbdJFJY7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Oct 2017 05:24:59 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v969OSZW018997
        for <linux-unionfs@vger.kernel.org>; Fri, 6 Oct 2017 05:24:58 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2de6q41btu-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Oct 2017 05:24:58 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 6 Oct 2017 03:24:57 -0600
In-Reply-To: <20171006092535.15199-1-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, amir73il@gmail.com
Cc: miklos@szeredi.hu

From: Amir Goldstein <amir73il@gmail.com>

For the case of all layers not on the same fs, use the copy up
origin st_ino for non-dir, if we know it.

This guaranties constant and system-wide unique st_ino/st_dev
for non-dir across copy up. Like the same fs case, st_ino of
non-dir is also persistent. Unlink the same fs case, st_dev is
not persistent.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 3091cd6..38aabb0 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -82,6 +82,7 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 	struct path realpath;
 	const struct cred *old_cred;
 	bool is_dir = S_ISDIR(dentry->d_inode->i_mode);
+	bool samefs = ovl_same_sb(dentry->d_sb);
 	int err;
 
 	type = ovl_path_real(dentry, &realpath);
@@ -91,16 +92,16 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 		goto out;
 
 	/*
-	 * When all layers are on the same fs, all real inode number are
-	 * unique, so we use the overlay st_dev, which is friendly to du -x.
-	 *
-	 * We also use st_ino of the copy up origin, if we know it.
-	 * This guaranties constant st_dev/st_ino across copy up.
+	 * For non-dir or same fs, we use st_ino of the copy up origin, if we
+	 * know it. This guaranties constant st_dev/st_ino across copy up.
 	 *
 	 * If filesystem supports NFS export ops, this also guaranties
 	 * persistent st_ino across mount cycle.
+	 *
+	 * When all layers are on the same fs, all real inode number are
+	 * unique, so we use the overlay st_dev, which is friendly to du -x.
 	 */
-	if (ovl_same_sb(dentry->d_sb)) {
+	if (!is_dir || samefs) {
 		if (OVL_TYPE_ORIGIN(type)) {
 			struct kstat lowerstat;
 			u32 lowermask = STATX_INO | (!is_dir ? STATX_NLINK : 0);
@@ -111,7 +112,6 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 			if (err)
 				goto out;
 
-			WARN_ON_ONCE(stat->dev != lowerstat.dev);
 			/*
 			 * Lower hardlinks may be broken on copy up to different
 			 * upper files, so we cannot use the lower origin st_ino
@@ -123,22 +123,28 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 			if (is_dir || lowerstat.nlink == 1 ||
 			    ovl_test_flag(OVL_INDEX, d_inode(dentry)))
 				stat->ino = lowerstat.ino;
+
+			if (samefs)
+				WARN_ON_ONCE(stat->dev != lowerstat.dev);
+			else
+				stat->dev = lowerstat.dev;
 		}
-		stat->dev = dentry->d_sb->s_dev;
-	} else if (is_dir) {
+		if (samefs)
+			stat->dev = dentry->d_sb->s_dev;
+		else
+			stat->dev = ovl_get_pseudo_dev(dentry, stat->dev);
+	} else {
 		/*
-		 * If not all layers are on the same fs the pair {real st_ino;
-		 * overlay st_dev} is not unique, so use the non persistent
-		 * overlay st_ino.
-		 *
 		 * Always use the overlay st_dev for directories, so 'find
 		 * -xdev' will scan the entire overlay mount and won't cross the
 		 * overlay mount boundaries.
+		 *
+		 * If not all layers are on the same fs the pair {real st_ino;
+		 * overlay st_dev} is not unique, so use the non persistent
+		 * overlay st_ino for directories.
 		 */
 		stat->dev = dentry->d_sb->s_dev;
 		stat->ino = dentry->d_inode->i_ino;
-	} else {
-		stat->dev = ovl_get_pseudo_dev(dentry, stat->dev);
 	}
 
 	/*
-- 
2.9.5
