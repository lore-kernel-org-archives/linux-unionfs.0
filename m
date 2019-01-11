From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH][V3] overlayfs: During copy up, first copy up data and then
 xattrs
Date: Fri, 11 Jan 2019 13:37:43 -0500
Message-ID: <20190111183743.GC16012@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com
Cc: stable@vger.kernel.org, dwalsh@redhat.com, gscrivan@redhat.com
List-Id: linux-unionfs@vger.kernel.org

If a file with capability set (and hence security.capability xattr) is
written kernel clears security.capability xattr. For overlay, during file
copy up if xattrs are copied up first and then data is, copied up. This
means data copy up will result in clearing of security.capability xattr
file on lower has. And this can result into surprises. If
a lower file has CAP_SETUID, then it should not be cleared over
copy up (if nothing was actually written to file).

This also creates problems with chown logic where it first copies up file
and then tries to clear setuid bit. But by that time security.capability
xattr is already gone (due to data copy up), and caller gets -ENODATA.
This has been reported by Giuseppe here.

https://github.com/containers/libpod/issues/2015#issuecomment-447824842

Fix this by copying up data first and then metadta. This is a regression
which has been introduced by my commit as part of metadata only copy up
patches.

TODO: There will be some corner cases where a file is copied up metadata
      only and later data copy up happens and that will clear
      security.capability xattr. Something needs to be done about that too.

Fixes: bd64e57586d3 ("ovl: During copy up, first copy up metadata and then data")
Cc: <stable@vger.kernel.org> # v4.19+
Reported-by: Giuseppe Scrivano <gscrivan@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

Index: rhvgoyal-linux/fs/overlayfs/copy_up.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/copy_up.c	2019-01-10 17:25:25.594461223 -0500
+++ rhvgoyal-linux/fs/overlayfs/copy_up.c	2019-01-11 10:47:33.657461223 -0500
@@ -443,6 +443,24 @@ static int ovl_copy_up_inode(struct ovl_
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
+		if(WARN_ON(upperpath.dentry != NULL))
+			return -EIO;
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
@@ -459,19 +477,6 @@ static int ovl_copy_up_inode(struct ovl_
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
