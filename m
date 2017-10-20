From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: handle ENOENT on index lookup
Date: Fri, 20 Oct 2017 14:01:10 +0300
Message-ID: <1508497270-27971-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:56808 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752786AbdJTLA3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 20 Oct 2017 07:00:29 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, "# v4 . 13" <stable@vger.kernel.org>

Fixes: 359f392ca53e ("ovl: lookup index entry for copy up origin")
Cc: <stable@vger.kernel.org> # v4.13
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 4 ++++
 1 file changed, 4 insertions(+)

Miklos,

This is a complimentary/fixup patch to the patch currently at the tip of
overlayfs-next. I did not run into ENOENT in my tests, but it seems that
all other places in overlayfs that call lookup_one_len_unlocked() check
the ENOENT return value and treat it the same as negative dentry.

I suppose this could be expected from some file systems?

Amir.

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 49441e8be722..a824e6b157f9 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -507,6 +507,10 @@ static struct dentry *ovl_lookup_index(struct dentry *dentry,
 	index = lookup_one_len_unlocked(name.name, ofs->indexdir, name.len);
 	if (IS_ERR(index)) {
 		err = PTR_ERR(index);
+		if (err == -ENOENT) {
+			index = NULL;
+			goto out;
+		}
 		pr_warn_ratelimited("overlayfs: failed inode index lookup (ino=%lu, key=%*s, err=%i);\n"
 				    "overlayfs: mount with '-o index=off' to disable inodes index.\n",
 				    d_inode(origin)->i_ino, name.len, name.name,
-- 
2.7.4
