From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] ovl: fix sgid inhertance over whiteout
Date: Thu, 25 Aug 2016 16:15:02 +0800
Message-ID: <1472112902-11767-1-git-send-email-guaneryu@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:35186 "EHLO
        mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753631AbcHYIQe (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 25 Aug 2016 04:16:34 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>

In commit bb0d2b8ad296 ("ovl: fix sgid on directory"), mode of newly
created files & dirs over whiteout was updated to pickup sgid bit. But
it used stat->mode directly, which could not be the correct mode,
because stat->mode could be tailored against umask.

This can be demonstrated by the following script:

umask 022
mkdir -p lower/dir upper work mnt
chown test:test lower/dir
chmod 2775 lower/dir
touch lower/dir/testdir
touch lower/dir/testfile

mount -t overlay -olowerdir=lower,upperdir=upper,workdir=work none mnt
rm -f mnt/dir/testdir
mkdir mnt/dir/testdir
rm -f mnt/dir/testfile
touch mnt/dir/testfile
touch mnt/dir/newfile
ls -l mnt/dir

-rw-r--r--. 1 root test 0 Aug 25 15:45 newfile
drwxrwsrwx. 2 root test 6 Aug 25 15:45 testdir
-rw-rw-rw-. 1 root test 0 Aug 25 15:45 testfile

testdir and testfile are created over whiteout, the modes contain write
permission for group and other, but they shouldn't, like 'newfile'.

Fix it by resetting mode against upperdir inode using
inode_init_owner().

Fixes: bb0d2b8ad296 ("ovl: fix sgid on directory")
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---

A new fstests test case followed to fstests list.

 fs/overlayfs/dir.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 12bcd07..9a5e716 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -370,17 +370,19 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 		goto out_dput2;
 
 	/*
-	 * mode could have been mutilated due to umask (e.g. sgid directory)
+	 * mode could lose sgid bit if upperdir has it set, because workdir has
+	 * no sgid. Reset mode against upperdir.
 	 */
-	if (!hardlink &&
-	    !S_ISLNK(stat->mode) && newdentry->d_inode->i_mode != stat->mode) {
+	if (!hardlink && !S_ISLNK(stat->mode)) {
+		struct inode *newinode = newdentry->d_inode;
 		struct iattr attr = {
 			.ia_valid = ATTR_MODE,
-			.ia_mode = stat->mode,
 		};
-		inode_lock(newdentry->d_inode);
+		inode_init_owner(newinode, udir, newinode->i_mode);
+		attr.ia_mode = newinode->i_mode;
+		inode_lock(newinode);
 		err = notify_change(newdentry, &attr, NULL);
-		inode_unlock(newdentry->d_inode);
+		inode_unlock(newinode);
 		if (err)
 			goto out_cleanup;
 	}
-- 
2.7.4
