From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 06/17] ovl: copy up before encoding dir file handle when ofs->numlower > 1
Date: Thu,  4 Jan 2018 19:20:38 +0200
Message-ID: <1515086449-26563-7-git-send-email-amir73il@gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34364 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751957AbeADRUp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 12:20:45 -0500
In-Reply-To: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Decoding a merge dir, whose origin's parent may be on a different lower
layer then the overlay parent's origin is not implemented. As a simple
aproximation, we do not encode lower dir file handles when overlay has
multiple lower layers. Instead, we copy up the lower dir first and then
encode an upper dir file handle.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 64 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 919d43aaa387..149cfb5c967e 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -26,13 +26,48 @@
  * copied up before NFS export was enabled. In that case we don't need to worry
  * about staying consistent with pre copy up encoding and we encode an upper
  * file handle.
+ *
+ * The following table summarizes the different file handle encodings used for
+ * different overlay object types with overlay configuration of single and
+ * multiple lower layers:
+ *
+ *  Object type		| Single lower	| Multiple lower
+ * --------------------------------------------------------
+ *  Pure upper		|	U	|	U
+ *  Non-indexed upper	|	U	|	U
+ *  Indexed non-dir	|	L	|	L
+ *  Lower non-dir	|	L	|	L
+ *  Indexed directory	|	L	|	U
+ *  Lower directory	|	L	|	U (*)
+ *
+ * U = upper file handle
+ * L = lower file handle
+ *
+ * The important thing to note is that within the same overlay configuration
+ * an overlay object encoding is invariant to copy up (i.e. Lower->Indexed).
+ *
+ * (*) If decoding an overlay dir from origin is not implemented, we do not
+ * encode by lower inode, because if file gets copied up after we encoded it,
+ * we won't be able to decode the file handle. To mitigate this case, we copy
+ * up the lower dir first and then encode an upper dir file handle.
  */
 static bool ovl_should_encode_origin(struct dentry *dentry)
 {
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+
 	/* Root dentry was born upper */
 	if (dentry == dentry->d_sb->s_root)
 		return false;
 
+	/*
+	 * Decoding a merge dir, whose origin's parent may be on a different
+	 * lower layer then the overlay parent's origin is not implemented.
+	 * As a simple aproximation, we do not encode lower dir file handles
+	 * when overlay has multiple lower layers.
+	 */
+	if (d_is_dir(dentry) && ofs->numlower > 1)
+		return false;
+
 	/* Decoding a non-indexed upper from origin is not implemented */
 	if (ovl_dentry_upper(dentry) &&
 	    !ovl_test_flag(OVL_INDEX, d_inode(dentry)))
@@ -41,16 +76,43 @@ static bool ovl_should_encode_origin(struct dentry *dentry)
 	return true;
 }
 
+static int ovl_encode_maybe_copy_up(struct dentry *dentry)
+{
+	int err;
+
+	if (ovl_dentry_upper(dentry))
+		return 0;
+
+	err = ovl_want_write(dentry);
+	if (err)
+		return err;
+
+	err = ovl_copy_up(dentry);
+
+	ovl_drop_write(dentry);
+	return err;
+}
+
 int ovl_d_to_fh(struct dentry *dentry, char *buf, int buflen)
 {
-	struct dentry *upper = ovl_dentry_upper(dentry);
+	struct dentry *upper;
 	struct dentry *origin = ovl_dentry_lower(dentry);
 	struct ovl_fh *fh = NULL;
 	int err;
 
-	if (!ovl_should_encode_origin(dentry))
+	/*
+	 * If we should not encode a lower dir file handle, copy up and encode
+	 * an upper dir file handle.
+	 */
+	if (!ovl_should_encode_origin(dentry)) {
+		err = ovl_encode_maybe_copy_up(dentry);
+		if (err)
+			goto fail;
+
 		origin = NULL;
+	}
 
+	upper = ovl_dentry_upper(dentry);
 	err = -EACCES;
 	if (!upper || origin)
 		goto fail;
-- 
2.7.4
