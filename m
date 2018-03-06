Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v12 01/17] ovl: redirect_dir=nofollow can follow redirect for opaque lower
Date: Tue,  6 Mar 2018 15:53:52 -0500
Message-Id: <20180306205408.23383-2-vgoyal@redhat.com>
In-Reply-To: <20180306205408.23383-1-vgoyal@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

redirect_dir=nofollow should not follow a redirect. But in a specific
configuration it can still follow it.  For example try this.

$ mkdir -p lower0 lower1/foo upper work merged
$ touch lower1/foo/lower-file.txt
$ setfattr -n "trusted.overlay.opaque" -v "y" lower1/foo
$ mount -t overlay -o lowerdir=lower1:lower0,workdir=work,upperdir=upper,redirect_dir=on none merged
$ cd merged
$ mv foo foo-renamed
$ umount merged

# mount again. This time with redirect_dir=nofollow
$ mount -t overlay -o lowerdir=lower1:lower0,workdir=work,upperdir=upper,redirect_dir=nofollow none merged
$ ls merged/foo-renamed/
# This lists lower-file.txt, while it should not have.

Basically, we are doing redirect check after we check for d.stop. And
if this is not last lower, and we find an opaque lower, d.stop will be
set.

ovl_lookup_single()
        if (!d->last && ovl_is_opaquedir(this)) {
                d->stop = d->opaque = true;
                goto out;
        }

To fix this, first check redirect is allowed. And after that check if
d.stop has been set or not.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/namei.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index de3e6da1d5a5..70fcfcc684cc 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -913,9 +913,6 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		stack[ctr].layer = lower.layer;
 		ctr++;
 
-		if (d.stop)
-			break;
-
 		/*
 		 * Following redirects can have security consequences: it's like
 		 * a symlink into the lower layer without the permission checks.
@@ -933,6 +930,9 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			goto out_put;
 		}
 
+		if (d.stop)
+			break;
+
 		if (d.redirect && d.redirect[0] == '/' && poe != roe) {
 			poe = roe;
 			/* Find the current layer on the root dentry */
-- 
2.13.6
