Return-Path: <vgoyal@redhat.com>
Date: Wed, 19 Dec 2018 13:53:09 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] overlayfs: During copy up, first copy up data and then xattrs
Message-ID: <20181219185309.GA27281@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, gscrivan@redhat.com, Daniel J Walsh <dwalsh@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

If xattrs are copied up first and then data is copied up, it can clear
suid/sgid permissions on copied up file and hence remove security.capability
xattr. And this can result into surprises.

First of all, if a setuid binary on lower is opened for writing (but
nothing is actually written), then copy up should not result in removing
setuid bit.

Also, chown, first copies up file and then tries to clear setuid bit.
But by that time security.capability xattr is already gone (due to
data copy up), and caller gets -ENODATA. This has been reported by
Giuseppe here.

https://github.com/containers/libpod/issues/2015#issuecomment-447824842

Fix this by copying up data first and then metadta. This is a regression
which has been introduced by my commit as part of metadata only copy up
patches.

commit bd64e57586d3722d2fc06093c3d7e3c4adb9e060
Author: Vivek Goyal <vgoyal@redhat.com>
Date:   Fri May 11 11:49:27 2018 -0400

    ovl: During copy up, first copy up metadata and then data

TODO: There will be some corner cases where a file is copied up metadata
      only and later data copy up happens and that will clear setuid/setgid
      bit. Something needs to be done about that too.

Reported-by: Giuseppe Scrivano <gscrivan@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

Index: rhvgoyal-linux-fuse/fs/overlayfs/copy_up.c
===================================================================
--- rhvgoyal-linux-fuse.orig/fs/overlayfs/copy_up.c	2018-12-19 11:31:33.981003615 -0500
+++ rhvgoyal-linux-fuse/fs/overlayfs/copy_up.c	2018-12-19 11:31:38.862003615 -0500
@@ -443,10 +443,26 @@ static int ovl_copy_up_inode(struct ovl_
 {
 	int err;
 
+	/*
+	 * Copy up data first and then xattrs. Writing data after
+	 * xattrs will remove security.capability xattr automatically.
+	 */
+	if (S_ISREG(c->stat.mode) && !c->metacopy) {
+		struct path upperpath, datapath;
+
+		ovl_path_upper(c->dentry, &upperpath);
+		BUG_ON(upperpath.dentry != NULL);
+		upperpath.dentry = temp;
+
+		ovl_path_lowerdata(c->dentry, &datapath);
+		err = ovl_copy_up_data(&datapath, &upperpath, c->stat.size);
+		if (err)
+			return err;
+	}
+
 	err = ovl_copy_xattr(c->lowerpath.dentry, temp);
 	if (err)
 		return err;
-
 	/*
 	 * Store identifier of lower inode in upper inode xattr to
 	 * allow lookup of the copy up origin inode.
@@ -459,19 +475,6 @@ static int ovl_copy_up_inode(struct ovl_
 		if (err)
 			return err;
 	}
-
-	if (S_ISREG(c->stat.mode) && !c->metacopy) {
-		struct path upperpath, datapath;
-
-		ovl_path_upper(c->dentry, &upperpath);
-		BUG_ON(upperpath.dentry != NULL);
-		upperpath.dentry = temp;
-
-		ovl_path_lowerdata(c->dentry, &datapath);
-		err = ovl_copy_up_data(&datapath, &upperpath, c->stat.size);
-		if (err)
-			return err;
-	}
 
 	if (c->metacopy) {
 		err = ovl_check_setxattr(c->dentry, temp, OVL_XATTR_METACOPY,
