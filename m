From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 05/13] ovl: lookup stable inode by file handle
Date: Mon, 17 Apr 2017 02:59:35 +0300
Message-ID: <1492387183-18847-6-git-send-email-amir73il@gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34626 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756797AbdDPX7n (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 16 Apr 2017 19:59:43 -0400
In-Reply-To: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

When non directory upper has overlay.fh xattr, lookup that
file handle in lower layers to find the stable inode it refers to.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index fcb7c15..42b6030 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -204,6 +204,9 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 	if (d->fh) {
 		kfree(d->fh);
 		d->fh = NULL;
+		/* Follow once by file handle for non-dir */
+		if (!d->is_dir)
+			d->by_fh = false;
 	}
 
 	if (!this->d_inode)
@@ -219,15 +222,21 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 		goto put_and_out;
 	}
 	if (!d_can_lookup(this)) {
-		d->stop = true;
-		if (d->is_dir)
+		if (d->is_dir) {
+			d->stop = true;
 			goto put_and_out;
-		goto out;
-	}
-	d->is_dir = true;
-	if (!d->last && ovl_is_opaquedir(this)) {
-		d->stop = d->opaque = true;
-		goto out;
+		}
+		/* Lookup stable inode of non-dir by file handle */
+		if (!d->by_fh) {
+			d->stop = true;
+			goto out;
+		}
+	} else {
+		d->is_dir = true;
+		if (!d->last && ovl_is_opaquedir(this)) {
+			d->stop = d->opaque = true;
+			goto out;
+		}
 	}
 	if (d->last)
 		goto out;
@@ -236,6 +245,11 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 		if (err)
 			goto out_err;
 	}
+	/* No redirect fh for non-dir means pure upper */
+	if (!d->is_dir) {
+		d->stop = !d->fh;
+		goto out;
+	}
 	if (d->by_path) {
 		err = ovl_check_redirect(this, d, prelen, post);
 		if (err)
-- 
2.7.4
