From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] tmpfs: allow decoding a file handle of an unlinked file
Date: Mon, 13 Nov 2017 08:43:58 +0200
Message-ID: <1510555438-28996-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:50612 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751377AbdKMGnO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Nov 2017 01:43:14 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Hugh Dickins <hughd@google.com>

tmpfs uses the helper d_find_alias() to find a dentry from a decoded
inode, but d_find_alias() skips unhashed dentries, so unlinked files
cannot be decoded from a file handle.

This can be reproduced using xfstests test program open_by_handle:
$ open_by handle -c /tmp/testdir
$ open_by_handle -dk /tmp/testdir
open_by_handle(/tmp/testdir/file000000) returned 116 incorrectly on an
unlinked open file!

To fix this, if d_find_alias() can't find a hashed alias, call
d_find_any_alias() to return an unhashed one.

Cc: Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Al, Miklos,

Can either of you take this patch through your tree?

Thanks,
Amir.

Changes since v1:
- Prefer a hashed alias (James)
- Use existing d_find_any_alias() helper

 mm/shmem.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 07a1d22807be..5d3fa4099f54 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3404,6 +3404,15 @@ static int shmem_match(struct inode *ino, void *vfh)
 	return ino->i_ino == inum && fh[0] == ino->i_generation;
 }
 
+/* Find any alias of inode, but prefer a hashed alias */
+static struct dentry *shmem_find_alias(struct inode *inode)
+{
+	struct dentry *alias = d_find_alias(inode);
+
+	return alias ?: d_find_any_alias(inode);
+}
+
+
 static struct dentry *shmem_fh_to_dentry(struct super_block *sb,
 		struct fid *fid, int fh_len, int fh_type)
 {
@@ -3420,7 +3429,7 @@ static struct dentry *shmem_fh_to_dentry(struct super_block *sb,
 	inode = ilookup5(sb, (unsigned long)(inum + fid->raw[0]),
 			shmem_match, fid->raw);
 	if (inode) {
-		dentry = d_find_alias(inode);
+		dentry = shmem_find_alias(inode);
 		iput(inode);
 	}
 
-- 
2.7.4
