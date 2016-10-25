From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 1/3] ovl: check fs features
Date: Tue, 25 Oct 2016 09:34:45 +0200
Message-ID: <1477380887-21333-2-git-send-email-mszeredi@redhat.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38692 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754590AbcJYHex (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 25 Oct 2016 03:34:53 -0400
Received: by mail-wm0-f43.google.com with SMTP id d128so10339052wmf.1
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Oct 2016 00:34:52 -0700 (PDT)
In-Reply-To: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: Guillem Jover <guillem@debian.org>, Raphael Hertzog <hertzog@debian.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org

To allow adding new, backward incompatible features to overlayfs, we need a
way to store the list of features in the overlay.  This is done via
"trusted.overlay.features" xattr on the root of the upper layer (or one of
the lower layers, that previously acted as an upper layer).  It's a comma
separated list of case sensitive strings.

If an overlay has an unknown feature, mount shall return an error.  So
mechanism should only be used for backward incompatible features.

This patch doesn't add any features.  If the "trusted.overlay.features"
xattr contains a non-empty list, then return EINVAL error for the mount.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: <stable@vger.kernel.org>
---
 Documentation/filesystems/overlayfs.txt | 12 ++++++++++
 fs/overlayfs/overlayfs.h                |  1 +
 fs/overlayfs/super.c                    | 41 +++++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+)

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
index 7aeb8e8d80cf..5108425157ac 100644
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -175,6 +175,18 @@ The specified lower directories will be stacked beginning from the
 rightmost one and going left.  In the above example lower1 will be the
 top, lower2 the middle and lower3 the bottom layer.
 
+Filesystem features
+-------------------
+
+Features are enabled via "trusted.overlay.features" xattr on the root of the
+upper layer.  E.g. the following command can be used to enable features "foo"
+and "bar" on the overlay:
+
+  setfattr -n "trusted.overlay.features" -v "foo,bar" /upper
+  mount -t overlay overlay -olowerdir=/lower,upperdir=/upper,\
+workdir=/work /merged
+
+If an overlay has an unknown feature, mount shall return an error.
 
 Non-standard behavior
 ---------------------
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index f6e4d3539a25..d61d5b9d0d91 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -19,6 +19,7 @@ enum ovl_path_type {
 
 #define OVL_XATTR_PREFIX XATTR_TRUSTED_PREFIX "overlay."
 #define OVL_XATTR_OPAQUE OVL_XATTR_PREFIX "opaque"
+#define OVL_XATTR_FEATURES OVL_XATTR_PREFIX "features"
 
 #define OVL_ISUPPER_MASK 1UL
 
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 30263a541fd5..d6dc8d905d00 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -397,6 +397,39 @@ static struct dentry *ovl_workdir_create(struct vfsmount *mnt,
 	goto out_unlock;
 }
 
+static int ovl_check_features(struct dentry *root)
+{
+	int res;
+	char *buf, *tmp, *p;
+
+	res = vfs_getxattr(root, OVL_XATTR_FEATURES, NULL, 0);
+	if (res <= 0) {
+		if (res == -EOPNOTSUPP || res == -ENODATA)
+			res = 0;
+		return res;
+	}
+
+	buf = kmalloc(res + 1, GFP_TEMPORARY);
+	if (!buf)
+		return -ENOMEM;
+
+	res = vfs_getxattr(root, OVL_XATTR_FEATURES, buf, res);
+	if (res <= 0)
+		goto out_free;
+
+	buf[res] = '\0';
+	res = 0;
+	tmp = buf;
+	while ((p = strsep(&tmp, ",")) != NULL) {
+		res = -EINVAL;
+		pr_err("overlayfs: feature '%s' not supported\n", p);
+	}
+out_free:
+	kfree(buf);
+
+	return res;
+}
+
 static void ovl_unescape(char *s)
 {
 	char *d = s;
@@ -471,6 +504,10 @@ static int ovl_lower_dir(const char *name, struct path *path, long *namelen,
 	if (err)
 		goto out;
 
+	err = ovl_check_features(path->dentry);
+	if (err)
+		goto out_put;
+
 	err = vfs_statfs(path, &statfs);
 	if (err) {
 		pr_err("overlayfs: statfs failed on '%s'\n", name);
@@ -693,6 +730,10 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			goto out_put_upperpath;
 		}
 
+		err = ovl_check_features(upperpath.dentry);
+		if (err)
+			goto out_put_upperpath;
+
 		err = ovl_mount_dir(ufs->config.workdir, &workpath);
 		if (err)
 			goto out_put_upperpath;
-- 
2.5.5
