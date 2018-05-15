Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 4/4] ovl: make ovl_create_real() cope with vfs_mkdir() safely
Date: Tue, 15 May 2018 13:26:12 +0300
Message-Id: <1526379972-20923-5-git-send-email-amir73il@gmail.com>
In-Reply-To: <1526379972-20923-1-git-send-email-amir73il@gmail.com>
References: <1526379972-20923-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

From: Al Viro <viro@zeniv.linux.org.uk>

vfs_mkdir() may succeed and leave the dentry passed to it unhashed and
negative.  ovl_create_real() is the last caller breaking when that
happens.

Pass newdentry to ovl_create_real() by ref, so in the case above, if
lookup finds a good dentry, newdentry will be replaced by the positive
hashed one.

[amir: split re-factoring to prep patch
       pass dentry by ref
       factor out helper ovl_create_real_dir()
       add pr_warn() if mkdir succeeds and lookup fails]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c       | 42 +++++++++++++++++++++++++++++++++++++-----
 fs/overlayfs/overlayfs.h |  2 +-
 fs/overlayfs/super.c     |  2 +-
 3 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 45f5f9232e71..a90328c41307 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -114,9 +114,41 @@ int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
 	goto out;
 }
 
-int ovl_create_real(struct inode *dir, struct dentry *newdentry,
+static int ovl_create_real_dir(struct inode *dir, struct dentry **pnewdentry,
+			       umode_t mode)
+{
+	struct dentry *newdentry = *pnewdentry;
+	int err;
+
+	err = ovl_do_mkdir(dir, newdentry, mode, true);
+	/*
+	 * vfs_mkdir() may succeed and leave the dentry passed
+	 * to it unhashed and negative. If that happens, try to
+	 * lookup a new hashed and positive dentry.
+	 */
+	if (!err && unlikely(d_unhashed(newdentry))) {
+		struct dentry *d;
+
+		d = lookup_one_len(newdentry->d_name.name,
+				   newdentry->d_parent,
+				   newdentry->d_name.len);
+		if (IS_ERR(d)) {
+			err = PTR_ERR(d);
+			pr_warn("overlayfs: failed lookup after mkdir (%pd2, err=%i).\n",
+				newdentry, err);
+			return err;
+		}
+		dput(newdentry);
+		*pnewdentry = d;
+	}
+
+	return err;
+}
+
+int ovl_create_real(struct inode *dir, struct dentry **pnewdentry,
 		    struct cattr *attr, struct dentry *hardlink, bool debug)
 {
+	struct dentry *newdentry = *pnewdentry;
 	int err;
 
 	if (newdentry->d_inode)
@@ -131,7 +163,7 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 			break;
 
 		case S_IFDIR:
-			err = ovl_do_mkdir(dir, newdentry, attr->mode, debug);
+			err = ovl_create_real_dir(dir, pnewdentry, attr->mode);
 			break;
 
 		case S_IFCHR:
@@ -150,7 +182,7 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 			err = -EPERM;
 		}
 	}
-	if (!err && WARN_ON(!newdentry->d_inode)) {
+	if (!err && WARN_ON(!d_inode(*pnewdentry))) {
 		/*
 		 * Not quite sure if non-instantiated dentry is legal or not.
 		 * VFS doesn't seem to care so check and warn here.
@@ -171,7 +203,7 @@ struct dentry *ovl_create_temp(struct dentry *workdir, struct cattr *attr,
 	if (IS_ERR(temp))
 		return temp;
 
-	err = ovl_create_real(wdir, temp, attr, hardlink, true);
+	err = ovl_create_real(wdir, &temp, attr, hardlink, true);
 	if (err) {
 		dput(temp);
 		return ERR_PTR(err);
@@ -261,7 +293,7 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 	err = PTR_ERR(newdentry);
 	if (IS_ERR(newdentry))
 		goto out_unlock;
-	err = ovl_create_real(udir, newdentry, attr, hardlink, false);
+	err = ovl_create_real(udir, &newdentry, attr, hardlink, false);
 	if (err)
 		goto out_dput;
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 967183175ef5..a84599268d10 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -378,7 +378,7 @@ struct cattr {
 	umode_t mode;
 	const char *link;
 };
-int ovl_create_real(struct inode *dir, struct dentry *newdentry,
+int ovl_create_real(struct inode *dir, struct dentry **pnewdentry,
 		    struct cattr *attr,
 		    struct dentry *hardlink, bool debug);
 struct dentry *ovl_create_temp(struct dentry *workdir, struct cattr *attr,
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 492d534058ae..d83c0543c03c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -603,7 +603,7 @@ static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
 			goto retry;
 		}
 
-		err = ovl_create_real(dir, work,
+		err = ovl_create_real(dir, &work,
 				      &(struct cattr){.mode = S_IFDIR | 0},
 				      NULL, true);
 		if (err)
-- 
2.7.4
