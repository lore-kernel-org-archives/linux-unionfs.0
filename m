From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 05/15] ovl: store the file type in ovl_lookup_data
Date: Mon,  1 May 2017 16:41:56 +0300
Message-ID: <1493646126-10101-6-git-send-email-amir73il@gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36285 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1035879AbdEANmI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 May 2017 09:42:08 -0400
In-Reply-To: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

d.is_dir is used to stop layers lookup when finding non-dir under
dir entry.

Instead of storing a boolean d.is_dir in ovl_lookup_data, store
the upper inode file type in d.mode and stop layers lookup on any
file type change.

The d.mode generalization is needed for lookup of non-dir copy up
origin.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index e6de13d..7c2b038 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -17,7 +17,7 @@
 
 struct ovl_lookup_data {
 	struct qstr name;
-	bool is_dir;
+	umode_t mode;
 	bool opaque;
 	bool stop;
 	bool last;
@@ -101,6 +101,7 @@ static int ovl_lookup_data(struct dentry *this, struct ovl_lookup_data *d,
 			   size_t prelen, const char *post,
 			   struct dentry **ret)
 {
+	mode_t mode;
 	int err;
 
 	if (!this->d_inode)
@@ -116,14 +117,18 @@ static int ovl_lookup_data(struct dentry *this, struct ovl_lookup_data *d,
 		d->stop = d->opaque = true;
 		goto put_and_out;
 	}
+	/* Stop lookup in lower layers on file type change */
+	mode = this->d_inode->i_mode & S_IFMT;
+	if (d->mode && d->mode != mode) {
+		d->stop = true;
+		goto put_and_out;
+	}
+	d->mode = mode;
 	/* Stop lookup in lower layers on non-dir */
 	if (!d_can_lookup(this)) {
 		d->stop = true;
-		if (d->is_dir)
-			goto put_and_out;
 		goto out;
 	}
-	d->is_dir = true;
 	/* Stop lookup in lower layers on opaque dir */
 	if (!d->last && ovl_is_opaquedir(this)) {
 		d->stop = d->opaque = true;
@@ -249,7 +254,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	int err;
 	struct ovl_lookup_data d = {
 		.name = dentry->d_name,
-		.is_dir = false,
+		.mode = 0,
 		.opaque = false,
 		.stop = false,
 		.last = !poe->numlower,
-- 
2.7.4
