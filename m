From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 07/15] ovl: lookup copy up origin of non-dir inode
Date: Mon,  1 May 2017 16:41:58 +0300
Message-ID: <1493646126-10101-8-git-send-email-amir73il@gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33283 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162464AbdEANmL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 May 2017 09:42:11 -0400
In-Reply-To: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

When non directory upper has overlay.origin xattr, lookup in lower
layers to find the copy up origin inode.

Until this change, a non-dir dentry could have had oe->numlower == 1
with oe->lowerstack[0] pointing at the copy up origin path right after
copy up, but not when a non-dir dentry was created by ovl_lookup().

After this change, a non-dir dentry could be pointing at a lower dentry
after ovl_lookup(), which may or may not be the copy up origin.

For now, we are not doing anything with this reference, so it is not
significant if this is the actual copy up origin.  Soon, we will verify
that this is the actual copy up origin using file handles.

This is going to be used for persistent inode numbers across copy up.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 6fabbc1..66072b0 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -97,6 +97,13 @@ static bool ovl_is_opaquedir(struct dentry *dentry)
 	return false;
 }
 
+static bool ovl_is_copyup(struct dentry *dentry)
+{
+	int res = vfs_getxattr(dentry, OVL_XATTR_ORIGIN, NULL, 0);
+
+	return res > 0;
+}
+
 /* Update ovl_lookup_data struct from dentry found in layer */
 static int ovl_lookup_data(struct dentry *this, struct ovl_lookup_data *d,
 			   size_t prelen, const char *post,
@@ -125,13 +132,16 @@ static int ovl_lookup_data(struct dentry *this, struct ovl_lookup_data *d,
 		goto put_and_out;
 	}
 	d->mode = mode;
-	/* Stop lookup in lower layers on non-dir */
+	/*
+	 * Stop lookup in lower layers on opaque dir and on non-dir
+	 * which is not upper or has no copy up origin.
+	 */
 	if (!d_can_lookup(this)) {
-		d->stop = true;
-		goto out;
-	}
-	/* Stop lookup in lower layers on opaque dir */
-	if (!d->last && ovl_is_opaquedir(this)) {
+		if (d->idx > 0 || !ovl_is_copyup(this)) {
+			d->stop = true;
+			goto out;
+		}
+	} else if (!d->last && ovl_is_opaquedir(this)) {
 		d->stop = d->opaque = true;
 		goto out;
 	}
-- 
2.7.4
