From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 09/16] ovl: lookup non-dir inode copy up origin
Date: Thu, 27 Apr 2017 00:35:11 +0300
Message-ID: <1493242518-15266-10-git-send-email-amir73il@gmail.com>
References: <1493242518-15266-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36423 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030849AbdDZVfa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Apr 2017 17:35:30 -0400
In-Reply-To: <1493242518-15266-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

When non directory upper has overlay.origin.fh xattr, lookup in lower
layers by file handle or by path to find the copy up origin inode.

Until this change, a non-dir dentry could have had oe->numlower == 1
with oe->lowerstack[0] pointing at the copy up origin path, right
after copy up, but not when a non-dir dentry was created by ovl_lookup().

After this change, a non-dir dentry could be pointing at the copy up
origin after ovl_lookup(), as long as the copy up was done by overlayfs
that had redirect_fh support.

Non-dir entries that were copied up by overlayfs without redirect_fh
support will look the same as pure upper non-dir entries.

This is going to be used for persistent inode numbers across copy up.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 970d8158..ad2c784 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -188,15 +188,16 @@ static int ovl_lookup_data(struct dentry *this, struct ovl_lookup_data *d,
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
+	} else {
+		d->is_dir = true;
+		if (!d->last && ovl_is_opaquedir(this)) {
+			d->stop = d->opaque = true;
+			goto out;
+		}
 	}
 	if (d->by_path) {
 		err = ovl_check_redirect(this, d, prelen, post);
@@ -208,6 +209,9 @@ static int ovl_lookup_data(struct dentry *this, struct ovl_lookup_data *d,
 		if (err)
 			goto out_err;
 	}
+	/* No redirect for non-dir means pure upper */
+	if (!d->is_dir)
+		d->stop = !d->fh && !d->redirect;
 out:
 	*ret = this;
 	return 0;
@@ -456,11 +460,11 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	}
 
 	/*
-	 * For now we only support lower by fh in single layer, because
-	 * fallback from lookup by fh to lookup by path in mid layers for
-	 * merge directory is not yet implemented.
+	 * For now we only support lookup by fh in single layer for directory,
+	 * because fallback from lookup by fh to lookup by path in mid layers
+	 * for merge directory is not yet implemented.
 	 */
-	if (!ofs->redirect_fh || ofs->numlower > 1)
+	if (!ofs->redirect_fh || (d.is_dir && ofs->numlower > 1))
 		ovl_reset_redirect_fh(&d);
 
 	if (!d.stop && (poe->numlower || d.fh)) {
@@ -520,7 +524,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		stack[ctr].mnt = lowerpath.mnt;
 		ctr++;
 
-		if (d.stop)
+		/* Do not follow non-dir copy up origin more than once */
+		if (d.stop || !d.is_dir)
 			break;
 
 		if (d.redirect && d.redirect[0] == '/' && poe != roe) {
-- 
2.7.4
