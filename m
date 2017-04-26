From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 06/16] ovl: factor out ovl_lookup_data()
Date: Thu, 27 Apr 2017 00:35:08 +0300
Message-ID: <1493242518-15266-7-git-send-email-amir73il@gmail.com>
References: <1493242518-15266-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35394 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030837AbdDZVfa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Apr 2017 17:35:30 -0400
In-Reply-To: <1493242518-15266-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Split helper ovl_lookup_data() out of ovl_lookup_single().
The helper takes care of updating the ovl_lookup_data context
according to the dentry that was found in layer.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 17f9372..b965785 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -96,22 +96,13 @@ static bool ovl_is_opaquedir(struct dentry *dentry)
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
 
@@ -152,6 +143,25 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
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
