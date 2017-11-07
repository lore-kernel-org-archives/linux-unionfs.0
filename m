From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] tmpfs: allow decoding a file handle of an unlinked file
Date: Tue,  7 Nov 2017 22:50:01 +0200
Message-ID: <1510087801-20663-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:45853 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932298AbdKGUtT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 15:49:19 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>

tmpfs uses the helper d_find_alias() to find a dentry from a decoded
inode, but d_find_alias() skips unhashed dentries, so unlinked files
cannot be decoded from a file handle.

This can be reproduced using xfstests test program open_by_handle:
$ open_by handle -c /tmp/testdir
$ open_by_handle -dk /tmp/testdir
open_by_handle(/tmp/testdir/file000000) returned 116 incorrectly on an
unlinked open file!

To fix this, use a variant of d_find_alias() that returns any alias,
even an unhashed one.

Cc: Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 mm/shmem.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

Miklos,

Please see if that patch looks correct.

Bruce and Jeff indicated that the current tmpfs behavior is not desirable
for nfsd. It may be uncommon to export a tmpfs, but it is going to become
a lot more common when exporting an overlayfs with upper tmpfs.

Thanks,
Amir.

diff --git a/mm/shmem.c b/mm/shmem.c
index 07a1d22807be..f7c555ebf0f2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3404,6 +3404,26 @@ static int shmem_match(struct inode *ino, void *vfh)
 	return ino->i_ino == inum && fh[0] == ino->i_generation;
 }
 
+/* Find any alias of inode, even an unhashed one */
+static struct dentry *shmem_find_alias(struct inode *inode)
+{
+	struct dentry *alias;
+
+	spin_lock(&inode->i_lock);
+	hlist_for_each_entry(alias, &inode->i_dentry, d_u.d_alias) {
+		dget(alias);
+		if (alias->d_inode == inode) {
+			spin_unlock(&inode->i_lock);
+			return alias;
+		}
+		dput(alias);
+	}
+	spin_unlock(&inode->i_lock);
+
+	return NULL;
+}
+
+
 static struct dentry *shmem_fh_to_dentry(struct super_block *sb,
 		struct fid *fid, int fh_len, int fh_type)
 {
@@ -3420,7 +3440,7 @@ static struct dentry *shmem_fh_to_dentry(struct super_block *sb,
 	inode = ilookup5(sb, (unsigned long)(inum + fid->raw[0]),
 			shmem_match, fid->raw);
 	if (inode) {
-		dentry = d_find_alias(inode);
+		dentry = shmem_find_alias(inode);
 		iput(inode);
 	}
 
-- 
2.7.4
