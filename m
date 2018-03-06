Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v12 16/17] ovl: Set redirect on upper inode when it is linked
Date: Tue,  6 Mar 2018 15:54:07 -0500
Message-Id: <20180306205408.23383-17-vgoyal@redhat.com>
In-Reply-To: <20180306205408.23383-1-vgoyal@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

When we create a hardlink to a metacopy upper file, first the redirect
on that inode. Path based lookup will not work with newly created link
and redirect will solve that issue.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/dir.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index b955f6fede06..da5c4b8ee919 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -24,6 +24,8 @@ module_param_named(redirect_max, ovl_redirect_max, ushort, 0644);
 MODULE_PARM_DESC(ovl_redirect_max,
 		 "Maximum length of absolute redirect xattr value");
 
+static int ovl_set_redirect(struct dentry *dentry, bool samedir);
+
 int ovl_cleanup(struct inode *wdir, struct dentry *wdentry)
 {
 	int err;
@@ -468,6 +470,9 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 	const struct cred *old_cred;
 	struct cred *override_cred;
 	struct dentry *parent = dentry->d_parent;
+	struct dentry *hardlink_upper;
+
+	hardlink_upper = hardlink ? ovl_dentry_upper(hardlink) : NULL;
 
 	err = ovl_copy_up(parent);
 	if (err)
@@ -502,12 +507,18 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 		put_cred(override_creds(override_cred));
 		put_cred(override_cred);
 
+		if (hardlink && ovl_is_metacopy_dentry(hardlink)) {
+			err = ovl_set_redirect(hardlink, false);
+			if (err)
+				goto out_revert_creds;
+		}
+
 		if (!ovl_dentry_is_whiteout(dentry))
 			err = ovl_create_upper(dentry, inode, attr,
-						hardlink);
+					       hardlink_upper);
 		else
 			err = ovl_create_over_whiteout(dentry, inode, attr,
-							hardlink);
+					               hardlink_upper);
 	}
 out_revert_creds:
 	revert_creds(old_cred);
@@ -602,8 +613,7 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
 	inode = d_inode(old);
 	ihold(inode);
 
-	err = ovl_create_or_link(new, inode, NULL, ovl_dentry_upper(old),
-				 ovl_type_origin(old));
+	err = ovl_create_or_link(new, inode, NULL, old, ovl_type_origin(old));
 	if (err)
 		iput(inode);
 
-- 
2.13.6
