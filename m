From: Hou Tao <houtao1@huawei.com>
Subject: [RFC][PATCH v2] overlay: hardlink all whiteout files into a single one
Date: Wed, 31 Jan 2018 19:45:02 +0800
Message-ID: <20180131114502.8827-1-houtao1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:52428 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752377AbeAaLgf (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 06:36:35 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 93FA81948258D
        for <linux-unionfs@vger.kernel.org>; Wed, 31 Jan 2018 19:36:30 +0800 (CST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com

Now each whiteout file will be assigned a new inode. To reduce the
overhead of allocating and freeing inodes in upper fs, creating a
singleton whiteout file under workdir and hardlink all whiteout files
into it.

The effect is obvious: under my VM, the time used for removing the
linux kernel source tree will be reduced from 17s to 10s.

Got the idea from aufs4.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
v2:
    * address the comments from Miklos and Amir: handle -EMLINK and -EXDEV
      when hard-linking whiteout file to the singleton

    * move the singleton whiteout from workbasedir to workdir to simplify
      the lock of inodes

Hi,

Now the singleton whiteout is moved from workbasedir to workdir, so it will
be recreated after each mount. And i'm not sure whether or not it's worth
to make the singleton whiteout persistent (eg., by skipping the removal of
the singleton whiteout during making workdir, swapping it into workbasedir
and swapping it back after the recreate of workdir). Any suggestion ?

Thanks,
Tao
---
 fs/overlayfs/dir.c       | 118 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/overlayfs/overlayfs.h |   1 +
 fs/overlayfs/ovl_entry.h |   5 ++
 fs/overlayfs/super.c     |   5 ++
 4 files changed, 128 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index f9788bc..83aeff9 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -17,6 +17,7 @@
 #include <linux/posix_acl_xattr.h>
 #include <linux/atomic.h>
 #include <linux/ratelimit.h>
+#include <linux/mount.h>
 #include "overlayfs.h"
 
 static unsigned short ovl_redirect_max = 256;
@@ -62,6 +63,111 @@ struct dentry *ovl_lookup_temp(struct dentry *workdir)
 	return temp;
 }
 
+#define OVL_WHITEOUT_FILE_NAME "whiteout"
+
+static int ovl_make_singleton_whiteout_nolock(struct ovl_fs *ofs,
+		struct dentry *dir, const char *name)
+{
+	struct inode *inode = d_inode(dir);
+	struct dentry *whiteout;
+
+	whiteout = lookup_one_len(name, dir, strlen(name));
+	if (IS_ERR(whiteout))
+		return PTR_ERR(whiteout);
+
+	if (ovl_is_whiteout(whiteout)) {
+		ofs->whiteout = whiteout;
+	} else if (!whiteout->d_inode) {
+		if (!ovl_do_whiteout(inode, whiteout))
+			ofs->whiteout = whiteout;
+		else
+			dput(whiteout);
+	} else {
+		dput(whiteout);
+	}
+
+	return 0;
+}
+
+/*
+ * create a new whiteout file under dir if it doesn't exist.
+ * If a non-whiteout file has existed, the singleton whiteout
+ * will not be created.
+ */
+int ovl_make_singleton_whiteout(struct ovl_fs *ofs)
+{
+	int err;
+	struct vfsmount *mnt = ofs->upper_mnt;
+	struct inode *dir = d_inode(ofs->workdir);
+
+	err = mnt_want_write(mnt);
+	if (err)
+		return err;
+
+	inode_lock_nested(dir, I_MUTEX_PARENT);
+
+	err = ovl_make_singleton_whiteout_nolock(ofs, ofs->workdir,
+			OVL_WHITEOUT_FILE_NAME);
+
+	inode_unlock(dir);
+	mnt_drop_write(mnt);
+
+	return err;
+}
+
+static int ovl_link_to_singleton_whiteout(struct ovl_fs *ofs,
+		struct dentry *whiteout, bool *create_instead)
+{
+	int err;
+	struct inode *wdir = d_inode(ofs->workdir);
+	struct dentry *singleton;
+	bool retried = false;
+
+	*create_instead = false;
+retry:
+	singleton = ofs->whiteout;
+	err = ovl_do_link(singleton, wdir, whiteout, false);
+	if (!err) {
+		goto out;
+	} else if (err == -EMLINK && !retried) {
+		/*
+		 * The singleton already has the maximum number of links to it,
+		 * so remove the old one and create a new one
+		 */
+		ofs->whiteout = NULL;
+		err = ovl_do_unlink(wdir, singleton);
+		if (err) {
+			dput(singleton);
+			goto out;
+		}
+		dput(singleton);
+
+		err = ovl_make_singleton_whiteout_nolock(ofs, ofs->workdir,
+				OVL_WHITEOUT_FILE_NAME);
+		if (err)
+			goto out;
+
+		retried = true;
+		if (ofs->whiteout)
+			goto retry;
+		else
+			goto out_fallback;
+	} else if (err == -EXDEV) {
+		/*
+		 * upper fs may have a project id different than singleton,
+		 * so fall back to create whiteout directly
+		 */
+		goto out_fallback;
+	} else {
+		goto out;
+	}
+
+out_fallback:
+	*create_instead = true;
+out:
+	return err;
+}
+
 /* caller holds i_mutex on workdir */
 static struct dentry *ovl_whiteout(struct dentry *workdir,
 				   struct dentry *dentry)
@@ -69,12 +175,22 @@ static struct dentry *ovl_whiteout(struct dentry *workdir,
 	int err;
 	struct dentry *whiteout;
 	struct inode *wdir = workdir->d_inode;
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+	bool create_instead;
 
 	whiteout = ovl_lookup_temp(workdir);
 	if (IS_ERR(whiteout))
 		return whiteout;
 
-	err = ovl_do_whiteout(wdir, whiteout);
+	if (ofs->whiteout)
+		err = ovl_link_to_singleton_whiteout(ofs, whiteout,
+				&create_instead);
+	else
+		create_instead = true;
+
+	if (create_instead)
+		err = ovl_do_whiteout(wdir, whiteout);
+
 	if (err) {
 		dput(whiteout);
 		whiteout = ERR_PTR(err);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index b489099..5f8d94a 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -315,6 +315,7 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		    struct cattr *attr,
 		    struct dentry *hardlink, bool debug);
 int ovl_cleanup(struct inode *dir, struct dentry *dentry);
+int ovl_make_singleton_whiteout(struct ovl_fs *ofs);
 
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 9d0bc03..f93c304 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -40,6 +40,11 @@ struct ovl_fs {
 	struct dentry *workdir;
 	/* index directory listing overlay inodes by origin file handle */
 	struct dentry *indexdir;
+	/*
+	 * the singleton whiteout file under workdir: all newly created
+	 * whiteout files will be linked to it if possible
+	 */
+	struct dentry *whiteout;
 	long namelen;
 	/* pathnames of lower and upper dirs, for show_options */
 	struct ovl_config config;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 76440fe..95937ad 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -223,6 +223,7 @@ static void ovl_free_fs(struct ovl_fs *ofs)
 	unsigned i;
 
 	dput(ofs->indexdir);
+	dput(ofs->whiteout);
 	dput(ofs->workdir);
 	if (ofs->workdir_locked)
 		ovl_inuse_unlock(ofs->workbasedir);
@@ -936,6 +937,10 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 	if (!ofs->workdir)
 		return 0;
 
+	err = ovl_make_singleton_whiteout(ofs);
+	if (err < 0)
+		return err;
+
 	/*
 	 * Upper should support d_type, else whiteouts are visible.  Given
 	 * workdir and upper are on same fs, we can do iterate_dir() on
-- 
2.9.5
