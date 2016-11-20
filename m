From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: fix lookup error handling
Date: Sun, 20 Nov 2016 10:26:40 +0200
Message-ID: <1479630400-22512-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33880 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751515AbcKTI1H (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 20 Nov 2016 03:27:07 -0500
Received: by mail-wm0-f67.google.com with SMTP id g23so17949263wme.1
        for <linux-unionfs@vger.kernel.org>; Sun, 20 Nov 2016 00:27:06 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

In ovl_lookup_single(), if lookup in undelying fs returned an error
that is neither -ENAMETOOLONG nor -ENOENT, PTR_ERR() was returned in
*ret as a valid dentry and function returned 0 for success.

The faulty dentry would then be passed to dput() on umount and cause
a unhandled kernel page fault.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 1f2d155..7977190 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -45,11 +45,12 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 
 	this = lookup_one_len_unlocked(name, base, namelen);
 	if (IS_ERR(this)) {
-		if (PTR_ERR(this) == -ENOENT ||
-		    PTR_ERR(this) == -ENAMETOOLONG) {
+		err = PTR_ERR(this);
+		if (err == -ENOENT || err == -ENAMETOOLONG) {
 			this = NULL;
+			goto out;
 		}
-		goto out;
+		return err;
 	}
 	if (!this->d_inode)
 		goto put_and_out;
-- 
2.7.4
