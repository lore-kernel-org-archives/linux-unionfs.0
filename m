From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 2/2] ovl: check POSIX ACL support aginst upper layer
Date: Fri, 11 Dec 2015 17:34:48 +0800
Message-ID: <1449826488-2489-2-git-send-email-guaneryu@gmail.com>
References: <1449826488-2489-1-git-send-email-guaneryu@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36456 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbbLKJfA (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 11 Dec 2015 04:35:00 -0500
Received: by pacdm15 with SMTP id dm15so63037346pac.3
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Dec 2015 01:34:59 -0800 (PST)
In-Reply-To: <1449826488-2489-1-git-send-email-guaneryu@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, Eryu Guan <guaneryu@gmail.com>

Default ACL is not inherited on overlayfs. e.g.

umask 022
mkdir /mnt/overlay/acltestdir
setfacl -d --set u::rwx,g::rwx,o::- /mnt/overlay/acltestdir
mkdir /mnt/overlay/acltestdir/subdir
getfacl -p /mnt/overlay/acltestdir/subdir

subdir should inherit the default acl from acltestdir, which is
u::rwx,g::rwx,o::-, but subdir has mode specified by umask instead.
xfstests generic/314 and generic/319 reveal this issue.

Fix it by setting MS_POSIXACL flag overlayfs superblock to avoid setting
mode according to umask, then moving the POSIX ACL handling to overlayfs.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 fs/overlayfs/dir.c   | 22 ++++++++++++++--------
 fs/overlayfs/super.c |  7 +++++++
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 692ceda..8b763c2 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -387,20 +387,26 @@ static int ovl_create_or_link(struct dentry *dentry, int mode, dev_t rdev,
 {
 	int err;
 	struct inode *inode;
-	struct kstat stat = {
-		.mode = mode,
-		.rdev = rdev,
-	};
+	struct dentry *upperdir;
+	struct kstat stat;
+
+	err = ovl_copy_up(dentry->d_parent);
+	if (err)
+		goto out;
+
+	/* Check POSIX ACL support against upper layer */
+	upperdir = ovl_dentry_upper(dentry->d_parent);
+	if (!IS_POSIXACL(d_inode(upperdir)))
+		mode &= ~current_umask();
+
+	stat.mode = mode;
+	stat.rdev = rdev;
 
 	err = -ENOMEM;
 	inode = ovl_new_inode(dentry->d_sb, mode, dentry->d_fsdata);
 	if (!inode)
 		goto out;
 
-	err = ovl_copy_up(dentry->d_parent);
-	if (err)
-		goto out_iput;
-
 	if (!ovl_dentry_is_opaque(dentry)) {
 		err = ovl_create_upper(dentry, inode, &stat, link, hardlink);
 	} else {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e38ee0f..1cf923c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1024,6 +1024,13 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (!ufs->upper_mnt)
 		sb->s_flags |= MS_RDONLY;
 
+	/*
+	 * Set MS_POSIXACL unconditionally, so file mode won't be set according
+	 * to umask in vfs layer, POSIX ACL support and new file mode will be
+	 * handled in overlayfs.
+	 */
+	sb->s_flags |= MS_POSIXACL;
+
 	if (remote)
 		sb->s_d_op = &ovl_reval_dentry_operations;
 	else
-- 
1.8.3.1
