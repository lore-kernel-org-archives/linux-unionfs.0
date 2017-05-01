From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 04/15] ovl: factor out ovl_lookup_data()
Date: Mon,  1 May 2017 16:41:55 +0300
Message-ID: <1493646126-10101-5-git-send-email-amir73il@gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34312 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1165388AbdEANmG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 May 2017 09:42:06 -0400
In-Reply-To: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Split helper ovl_lookup_data() out of ovl_lookup_single().
The helper takes care of updating the ovl_lookup_data context
according to the dentry that was found in layer.

Decorate ovl_lookup_data() with some more comments.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 45 +++++++++++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index d0a3e4a..e6de13d 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -96,34 +96,27 @@ static bool ovl_is_opaquedir(struct dentry *dentry)
 	return false;
 }
 
-static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
-			     const char *name, unsigned int namelen,
-			     size_t prelen, const char *post,
-			     struct dentry **ret)
+/* Update ovl_lookup_data struct from dentry found in layer */
+static int ovl_lookup_data(struct dentry *this, struct ovl_lookup_data *d,
+			   size_t prelen, const char *post,
+			   struct dentry **ret)
 {
-	struct dentry *this;
 	int err;
 
-	this = lookup_one_len_unlocked(name, base, namelen);
-	if (IS_ERR(this)) {
-		err = PTR_ERR(this);
-		this = NULL;
-		if (err == -ENOENT || err == -ENAMETOOLONG)
-			goto out;
-		goto out_err;
-	}
 	if (!this->d_inode)
 		goto put_and_out;
 
+	/* Don't support traversing automounts and other weirdness */
 	if (ovl_dentry_weird(this)) {
-		/* Don't support traversing automounts and other weirdness */
 		err = -EREMOTE;
 		goto out_err;
 	}
+	/* Stop lookup in lower layers on whiteout */
 	if (ovl_is_whiteout(this)) {
 		d->stop = d->opaque = true;
 		goto put_and_out;
 	}
+	/* Stop lookup in lower layers on non-dir */
 	if (!d_can_lookup(this)) {
 		d->stop = true;
 		if (d->is_dir)
@@ -131,10 +124,15 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 		goto out;
 	}
 	d->is_dir = true;
+	/* Stop lookup in lower layers on opaque dir */
 	if (!d->last && ovl_is_opaquedir(this)) {
 		d->stop = d->opaque = true;
 		goto out;
 	}
+	/*
+	 * Check redirect dir even if d->last, because with redirect_dir,
+	 * a merge dir may have an opaque dir parent.
+	 */
 	err = ovl_check_redirect(this, d, prelen, post);
 	if (err)
 		goto out_err;
@@ -152,6 +150,25 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 	return err;
 }
 
+static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
+			     const char *name, unsigned int namelen,
+			     size_t prelen, const char *post,
+			     struct dentry **ret)
+{
+	struct dentry *this = lookup_one_len_unlocked(name, base, namelen);
+	int err;
+
+	if (IS_ERR(this)) {
+		err = PTR_ERR(this);
+		*ret = NULL;
+		if (err == -ENOENT || err == -ENAMETOOLONG)
+			return 0;
+		return err;
+	}
+
+	return ovl_lookup_data(this, d, prelen, post, ret);
+}
+
 static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
 			    struct dentry **ret)
 {
-- 
2.7.4
