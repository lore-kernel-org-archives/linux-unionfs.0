From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 07/17] ovl: encode lower file handles
Date: Thu,  4 Jan 2018 19:20:39 +0200
Message-ID: <1515086449-26563-8-git-send-email-amir73il@gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34365 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752320AbeADRUq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 12:20:46 -0500
In-Reply-To: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

For indexed or lower non-dir, encode a non-connectable lower file handle
from origin inode. For indexed or lower dir, when ofs->numlower == 1,
encode a lower file handle from lower dir.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 149cfb5c967e..0b4ad8693b29 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -95,7 +95,6 @@ static int ovl_encode_maybe_copy_up(struct dentry *dentry)
 
 int ovl_d_to_fh(struct dentry *dentry, char *buf, int buflen)
 {
-	struct dentry *upper;
 	struct dentry *origin = ovl_dentry_lower(dentry);
 	struct ovl_fh *fh = NULL;
 	int err;
@@ -112,13 +111,8 @@ int ovl_d_to_fh(struct dentry *dentry, char *buf, int buflen)
 		origin = NULL;
 	}
 
-	upper = ovl_dentry_upper(dentry);
-	err = -EACCES;
-	if (!upper || origin)
-		goto fail;
-
-	/* TODO: encode non pure-upper by origin */
-	fh = ovl_encode_fh(upper, true);
+	/* Encode an upper or origin file handle */
+	fh = ovl_encode_fh(origin ?: ovl_dentry_upper(dentry), !origin);
 
 	err = -EOVERFLOW;
 	if (fh->len > buflen)
-- 
2.7.4
