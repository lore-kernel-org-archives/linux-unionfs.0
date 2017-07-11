From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 08/10] ovl: do not cleanup directory and whiteout index entries
Date: Tue, 11 Jul 2017 15:58:41 +0300
Message-ID: <1499777923-29410-9-git-send-email-amir73il@gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36676 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755693AbdGKM6o (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 11 Jul 2017 08:58:44 -0400
Received: by mail-lf0-f65.google.com with SMTP id f28so14387451lfi.3
        for <linux-unionfs@vger.kernel.org>; Tue, 11 Jul 2017 05:58:44 -0700 (PDT)
In-Reply-To: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Directory index entries are going to be used for looking up
redirected upper dirs by lower dir fh when decoding an overlay
file handle of a merge dir.

Whiteout index entries are going to be used as an indication that
an exported overlay file handle should be treated as stale (i.e.
after unlink of the overlay inode).

We don't know the verification rules for directory and whiteout
index entries, because they have not been implemented yet, so skip
verification of those entries and let newer kernels deal with them.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 9bc0e580a5b3..86f09230a3db 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -397,9 +397,18 @@ int ovl_verify_index(struct dentry *index, struct path *lowerstack,
 	if (!d_inode(index))
 		return 0;
 
-	err = -EISDIR;
-	if (d_is_dir(index))
-		goto fail;
+	/*
+	 * Directory index entries are going to be used for looking up
+	 * redirected upper dirs by lower dir fh when decoding an overlay
+	 * file handle of a merge dir. Whiteout index entries are going to be
+	 * used as an indication that an exported overlay file handle should
+	 * be treated as stale (i.e. after unlink of the overlay inode).
+	 * We don't know the verification rules for directory and whiteout
+	 * index entries, because they have not been implemented yet, so skip
+	 * verification of those entries and let newer kernels deal with them.
+	 */
+	if (d_is_dir(index) || ovl_is_whiteout(index))
+		return 0;
 
 	err = -EINVAL;
 	if (index->d_name.len < sizeof(struct ovl_fh)*2)
-- 
2.7.4
