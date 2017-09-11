From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: fix false negative ESTALE on lookup
Date: Mon, 11 Sep 2017 16:30:15 +0300
Message-ID: <1505136615-26604-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36105 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750877AbdIKN3s (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 11 Sep 2017 09:29:48 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jordi Pujol <jordipujolp@gmail.com>, linux-unionfs@vger.kernel.org, "# v4 . 13" <stable@vger.kernel.org>

Commit b9ac5c274b8c ("ovl: hash overlay non-dir inodes by copy up
origin") verifies that the origin lower inode stored in the overlayfs
inode matched the inode of a copy up origin dentry found by lookup.

There is a false negative result in that check when lower fs does
not support file handles and copy up origin cannot be followed by
file handle at lookup time.

The false negative happens when finding an overlay inode in cache on
a copied up overlay dentry lookup. The overlay inode still 'remembers'
the copy up origin inode, but the copy up origin dentry is not available
for verification.

Relax the check in case copy up origin dentry is not available.

Fixes: b9ac5c274b8c ("ovl: hash overlay non-dir inodes by copy up...")
Cc: <stable@vger.kernel.org> # v4.13
Reported-by: Jordi Pujol <jordipujolp@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

This is a fix for the v4.13 issue of overlayfs over squashfs
reported by Jordi.

I added run --squashfs option to unionmount-testsuite:
https://github.com/amir73il/unionmount-testsuite/commits/overlayfs-devel

The test 'run --squashfs hard-link' fails on kernel v4.13.

Amir.


 fs/overlayfs/inode.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index aecaadc8f9e7..a619addecafc 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -579,10 +579,13 @@ static int ovl_inode_set(struct inode *inode, void *data)
 static bool ovl_verify_inode(struct inode *inode, struct dentry *lowerdentry,
 			     struct dentry *upperdentry)
 {
-	struct inode *lowerinode = lowerdentry ? d_inode(lowerdentry) : NULL;
-
-	/* Lower (origin) inode must match, even if NULL */
-	if (ovl_inode_lower(inode) != lowerinode)
+	/*
+	 * Allow non-NULL lower inode in ovl_inode even if lowerdentry is NULL.
+	 * This happens when finding a copied up overlay inode for a renamed
+	 * or hardlinked overlay dentry and lower dentry cannot be followed
+	 * by origin because lower fs does not support file handles.
+	 */
+	if (lowerdentry && ovl_inode_lower(inode) != d_inode(lowerdentry))
 		return false;
 
 	/*
-- 
2.7.4
