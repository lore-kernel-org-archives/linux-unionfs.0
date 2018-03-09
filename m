Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v2 3/4] ovl: set d->is_dir and d->opaque for last path element
Date: Fri,  9 Mar 2018 15:44:43 -0500
Message-Id: <20180309204444.13237-4-vgoyal@redhat.com>
In-Reply-To: <20180309204444.13237-1-vgoyal@redhat.com>
References: <20180309204444.13237-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Certain properties in ovl_lookup_data should be set only for the last
element of the path. IOW, of we are calling ovl_lookup_single() for an
absolute redirect, then d->is_dir and d->opaque do not make much sense
for intermediate path elements. Instead set them only if dentry being
lookup is last path element.

As of now we do not seem to be making use of d->opaque if it is set for
a path/dentry in lower. But just define the semantics so that future code
can make use of this assumption.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/namei.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index e27afd8d378a..de08a67405d0 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -220,6 +220,7 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 {
 	struct dentry *this;
 	int err;
+	bool last_element = !post[0];
 
 	this = lookup_one_len_unlocked(name, base, namelen);
 	if (IS_ERR(this)) {
@@ -247,12 +248,15 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 			goto put_and_out;
 		goto out;
 	}
-	d->is_dir = true;
+	if (last_element)
+		d->is_dir = true;
 	if (d->last)
 		goto out;
 
 	if (ovl_is_opaquedir(this)) {
-		d->stop = d->opaque = true;
+		d->stop = true;
+		if (last_element)
+			d->opaque = true;
 		goto out;
 	}
 	err = ovl_check_redirect(this, d, prelen, post);
-- 
2.13.6
