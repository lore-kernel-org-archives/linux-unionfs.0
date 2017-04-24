From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 12/12] ovl: persistent inode numbers for hardlinks
Date: Mon, 24 Apr 2017 21:40:47 +0300
Message-ID: <1493059247-17120-1-git-send-email-amir73il@gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35707 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968979AbdDXSki (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Apr 2017 14:40:38 -0400
In-Reply-To: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

An upper type non directory dentry that is a copy up target
should have a reference to its lower copy up origin.

There are three ways for an upper type dentry to be instantiated:
1. A lower type dentry that is being copied up
2. An entry that is found in upper dir by ovl_lookup()
3. A negative dentry is hardlinked to an upper type dentry

In the first case, the lower reference is set before copy up.
In the second case, the lower reference is found by ovl_lookup().
In the last case of hardlinked upper dentry, it is not easy to
update the lower reference of the negative dentry.  Instead,
drop the newly hardlinked negative dentry from dcache and let
the next access call ovl_lookup() to find its lower reference.

This makes sure that the inode number reported by stat(2) after
the hardlink is created is the same inode number that will be
reported by stat(2) after mount cycle, which is the inode number
of the lower copy up origin of the hardlink source.

NOTE that this does not fix breaking of lower hardlinks on copy
up, but it will result in stat(2) reporting the same inode number
for all the upper broken hardlinks.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 03854abf7..6ef35e8 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -197,6 +197,9 @@ static void ovl_instantiate(struct dentry *dentry, struct inode *inode,
 		inc_nlink(inode);
 	}
 	d_instantiate(dentry, inode);
+	/* Force lookup of new upper hardlink to find its lower */
+	if (hardlink)
+		d_drop(dentry);
 }
 
 static bool ovl_type_merge(struct dentry *dentry)
-- 
2.7.4
