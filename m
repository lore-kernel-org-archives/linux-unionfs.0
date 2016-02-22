From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] overlayfs: Ensure upper filesystem supports d_type
Date: Mon, 22 Feb 2016 09:28:34 -0500
Message-ID: <20160222142834.GA18393@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289AbcBVO2f (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 22 Feb 2016 09:28:35 -0500
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, miklos@szeredi.hu, David Howells <dhowells@redhat.com>, Dave Chinner <david@fromorbit.com>

During mount, make sure upper fs supports d_type otherwise error out.

In some instances xfs has been created with ftype=0 and there if a file
on lower fs is removed, overlay leaves a whiteout in upper fs but that
whiteout does not get filtered out and is visible to overlayfs users.

And reason it does not get filtered out because upper filesystem does
not report file type of whiteout as DT_CHR during iterate_dir().

So it seems to be a requirement that upper filesystem support d_type for
overlayfs to work properly. Do this check during mount and fail if d_type
is not supported.

Suggested-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/overlayfs.h |    1 +
 fs/overlayfs/readdir.c   |   37 +++++++++++++++++++++++++++++++++++++
 fs/overlayfs/super.c     |   15 +++++++++++++++
 3 files changed, 53 insertions(+)

Index: rhvgoyal-linux/fs/overlayfs/readdir.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/readdir.c	2016-02-19 16:10:09.440000000 +0000
+++ rhvgoyal-linux/fs/overlayfs/readdir.c	2016-02-22 14:09:30.745000000 +0000
@@ -43,6 +43,7 @@ struct ovl_readdir_data {
 	struct ovl_cache_entry *first_maybe_whiteout;
 	int count;
 	int err;
+	bool d_type_supported;
 };
 
 struct ovl_dir_file {
@@ -577,3 +578,39 @@ void ovl_cleanup_whiteouts(struct dentry
 	}
 	inode_unlock(upper->d_inode);
 }
+
+static int ovl_check_d_type(struct dir_context *ctx, const char *name,
+			  int namelen, loff_t offset, u64 ino,
+			  unsigned int d_type)
+{
+	struct ovl_readdir_data *rdd =
+		container_of(ctx, struct ovl_readdir_data, ctx);
+
+	/* Even if d_type is not supported, DT_DIR is returned for . and .. */
+	if (!strncmp(name, ".", namelen) || !strncmp(name, "..", namelen))
+		return 0;
+
+	if (d_type != DT_UNKNOWN)
+		rdd->d_type_supported = true;
+
+	return 0;
+}
+
+/*
+ * Returns 1 if d_type is supported, 0 not supported/unknown. Negative values
+ * if error is encountered.
+ */
+int ovl_check_d_type_supported(struct path *realpath)
+{
+	int err;
+	struct ovl_readdir_data rdd = {
+		.ctx.actor = ovl_check_d_type,
+		.d_type_supported = false,
+	};
+
+	err = ovl_dir_read(realpath, &rdd);
+	if (err)
+		return err;
+
+	return rdd.d_type_supported;
+}
Index: rhvgoyal-linux/fs/overlayfs/overlayfs.h
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/overlayfs.h	2016-02-19 16:10:09.440000000 +0000
+++ rhvgoyal-linux/fs/overlayfs/overlayfs.h	2016-02-22 14:09:30.746000000 +0000
@@ -166,6 +166,7 @@ extern const struct file_operations ovl_
 int ovl_check_empty_dir(struct dentry *dentry, struct list_head *list);
 void ovl_cleanup_whiteouts(struct dentry *upper, struct list_head *list);
 void ovl_cache_free(struct list_head *list);
+int ovl_check_d_type_supported(struct path *realpath);
 
 /* inode.c */
 int ovl_setattr(struct dentry *dentry, struct iattr *attr);
Index: rhvgoyal-linux/fs/overlayfs/super.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/super.c	2016-02-19 16:10:09.440000000 +0000
+++ rhvgoyal-linux/fs/overlayfs/super.c	2016-02-22 14:09:30.746000000 +0000
@@ -1025,6 +1025,21 @@ static int ovl_fill_super(struct super_b
 			sb->s_flags |= MS_RDONLY;
 			ufs->workdir = NULL;
 		}
+
+		/*
+		 * Upper should support d_type, else whiteouts are visible.
+		 * Given workdir and upper are on same fs, we can do
+		 * iterate_dir() on workdir.
+		 */
+		err = ovl_check_d_type_supported(&workpath);
+		if (err < 0)
+			goto out_put_workdir;
+
+		if (!err) {
+			pr_err("overlayfs: upper fs needs to support d_type.\n");
+			err = -EINVAL;
+			goto out_put_workdir;
+		}
 	}
 
 	err = -ENOMEM;
