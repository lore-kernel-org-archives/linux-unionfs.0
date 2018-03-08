Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH] ovl: opaque xattr should overrule redirect xattr
Date: Fri,  9 Mar 2018 00:18:10 +0200
Message-Id: <1520547490-25194-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

opaque xattr and redirect xattr are not expected to be both set on the
same directory, but in case they do, the opaque directive to stop
merging lower dirs should overrule an absolute redirect directive to
escape a pure directory.

This change comes with a cost of removing the optimiaztion for not
checking opaque xattr on lookup in last parent layer.
Instead, it adds an optimization for not checking opaque nor redirect
xattr on lookup in overlay instance lowermost layer.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Vivek,

This is the other change I was talking about.
See if it can help you in any way.
I think this behavior change makes sense, but behavior on this case
is undefined anyway.

Thanks,
Amir.

 fs/overlayfs/namei.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 31ca563b7666..87d8bf2c09c6 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -256,7 +256,9 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 		goto out;
 	}
 	d->is_dir = true;
-	if (!d->last && ovl_is_opaquedir(this)) {
+	if (d->last)
+		goto out;
+	if (ovl_is_opaquedir(this)) {
 		d->stop = d->opaque = true;
 		goto out;
 	}
@@ -823,7 +825,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		.is_dir = false,
 		.opaque = false,
 		.stop = false,
-		.last = !poe->numlower,
+		.last = false,
 		.redirect = NULL,
 	};
 
@@ -881,7 +883,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	for (i = 0; !d.stop && i < poe->numlower; i++) {
 		struct ovl_path lower = poe->lowerstack[i];
 
-		d.last = i == poe->numlower - 1;
+		d.last = lower.layer->idx == roe->numlower;
 		err = ovl_lookup_layer(lower.dentry, &d, &this);
 		if (err)
 			goto out_put;
-- 
2.7.4
