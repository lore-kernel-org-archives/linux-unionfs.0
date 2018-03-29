Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v13 26/28] ovl: Re-check redirect xattr during inode initialization
Date: Thu, 29 Mar 2018 15:38:52 -0400
Message-Id: <20180329193854.13814-27-vgoyal@redhat.com>
In-Reply-To: <20180329193854.13814-1-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

So far redirect could be placed on directories only and now it can be
placed on regular files as well. Also it could be completely removed
when a metacopy copy up file's data is copied up. That means if a redirect
is present during ovl_lookup(), it could be gone by the time ovl_get_inode()
happens.

Or it is possible that ovl_lookup() does not see a redirect and a rename
is taking place on a hard link and that places a redirect. And by the
time ovl_lookup() calls ovl_get_inode(), it sets ovl_inode->redirect = NULL
(Assume inode got flushed out of cache and was allocated new).

IOW, because we check and process redirect without locks in ovl_lookup(),
many possibilities open up for regular files. So for such cases, do not
use the redirect provided by the caller. Instead query it and install
in ovl_inode->redirect.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/inode.c     | 19 ++++++++++++++++++-
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 42 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 3dccfa1ee123..6a0c85699024 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -694,6 +694,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 	bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry, index);
 	bool is_dir, metacopy = false;
 	int err = -ENOMEM;
+	char *new_redirect = NULL;
 
 	if (!realinode)
 		realinode = d_inode(lowerdentry);
@@ -754,7 +755,18 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 	if (upperdentry && !metacopy)
 		ovl_set_flag(OVL_UPPERDATA, inode);
 
-	OVL_I(inode)->redirect = redirect;
+	if (!metacopy) {
+		OVL_I(inode)->redirect = redirect;
+		redirect = NULL;
+	} else if (upperdentry) {
+		new_redirect = ovl_get_redirect_xattr(upperdentry);
+		if (IS_ERR(new_redirect)) {
+			err = PTR_ERR(new_redirect);
+			goto out_err_inode;
+		}
+		OVL_I(inode)->redirect = new_redirect;
+		new_redirect = NULL;
+	}
 
 	/* Check for non-merge dir that may have whiteouts */
 	if (is_dir) {
@@ -764,11 +776,16 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 		}
 	}
 
+	kfree(redirect);
 	if (inode->i_state & I_NEW)
 		unlock_new_inode(inode);
 out:
 	return inode;
 
+out_err_inode:
+	if (inode->i_state & I_NEW)
+		unlock_new_inode(inode);
+	iput(inode);
 out_err:
 	inode = ERR_PTR(err);
 	goto out;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 429713653b3b..a3bee7619fbb 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -279,6 +279,7 @@ void ovl_nlink_end_locked(struct dentry *dentry);
 int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
 int ovl_check_metacopy_xattr(struct dentry *dentry);
 bool ovl_is_metacopy_dentry(struct dentry *dentry);
+char *ovl_get_redirect_xattr(struct dentry *dentry);
 
 static inline bool ovl_is_impuredir(struct dentry *dentry)
 {
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 961d65bd25c9..3d090b6f9fc2 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -833,3 +833,45 @@ bool ovl_is_metacopy_dentry(struct dentry *dentry)
 
 	return (oe->numlower > 1);
 }
+
+char *ovl_get_redirect_xattr(struct dentry *dentry)
+{
+	int res;
+	char *s, *next, *buf = NULL;
+
+	res = vfs_getxattr(dentry, OVL_XATTR_REDIRECT, NULL, 0);
+	if (res < 0) {
+		if (res == -ENODATA || res == -EOPNOTSUPP)
+			return NULL;
+		return ERR_PTR(res);
+	}
+
+	buf = kzalloc(res + 1, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	res = vfs_getxattr(dentry, OVL_XATTR_REDIRECT, buf, res);
+	if (res < 0) {
+		kfree(buf);
+		return ERR_PTR(res);
+        }
+	if (res == 0)
+		goto invalid;
+
+	if (buf[0] == '/') {
+		for (s = buf; *s++ == '/'; s = next) {
+			next = strchrnul(s, '/');
+			if (s == next)
+				goto invalid;
+		}
+	} else {
+		if (strchr(buf, '/') != NULL)
+			goto invalid;
+	}
+
+	return buf;
+invalid:
+	pr_warn_ratelimited("overlayfs: invalid redirect (%s)\n", buf);
+	kfree(buf);
+	return ERR_PTR(-EINVAL);
+}
-- 
2.13.6
