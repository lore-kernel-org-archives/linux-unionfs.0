Return-Path: <SRS0=xPSr=CF=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D87FC433DF
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Aug 2020 19:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 123F5207CD
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Aug 2020 19:18:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gDLbpfa4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgH0TSw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 15:18:52 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23243 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726266AbgH0TSw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Aug 2020 15:18:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598555930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=/Bp6vxoZLjGxC8oRoZ9tWa7iuyL5aI6VlAZmGlChx2I=;
        b=gDLbpfa4fSsZ2cUmLrqV+gpoa0Oacd3VtqvlVwYawrRHqF9DZbpvQffcoMEnB0uPnuJLM+
        LTVQidz9ZJnKrbmtfV/4j1pDZ4tGUrUaIsPXMupWjoDxFOcv01GvGWUbBwzsMZnVh6ivpU
        9puOcnVP1HdQbpPqQiPsjvmE/K1GxaQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-zpQcIO60PXa9SlGPqTkThA-1; Thu, 27 Aug 2020 15:18:45 -0400
X-MC-Unique: zpQcIO60PXa9SlGPqTkThA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D415A1029D29;
        Thu, 27 Aug 2020 19:18:44 +0000 (UTC)
Received: from horse.redhat.com (ovpn-114-37.rdu2.redhat.com [10.10.114.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5AF585C1D0;
        Thu, 27 Aug 2020 19:18:44 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id DE12D220245; Thu, 27 Aug 2020 15:18:43 -0400 (EDT)
Date:   Thu, 27 Aug 2020 15:18:43 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     linux-unionfs@vger.kernel.org, miklos@szeredi.hu
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>
Subject: [PATCH v6] overlayfs: Provide a mount option "volatile" to skip sync
Message-ID: <20200827191843.GA1098241@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Container folks are complaining that dnf/yum issues too many sync while
installing packages and this slows down the image build. Build
requirement is such that they don't care if a node goes down while
build was still going on. In that case, they will simply throw away
unfinished layer and start new build. So they don't care about syncing
intermediate state to the disk and hence don't want to pay the price
associated with sync.

So they are asking for mount options where they can disable sync on overlay
mount point.

They primarily seem to have two use cases.

- For building images, they will mount overlay with nosync and then sync
  upper layer after unmounting overlay and reuse upper as lower for next
  layer.

- For running containers, they don't seem to care about syncing upper
  layer because if node goes down, they will simply throw away upper
  layer and create a fresh one.

So this patch provides a mount option "volatile" which disables all forms
of sync. Now it is caller's responsibility to throw away upper if
system crashes or shuts down and start fresh.

With "volatile", I am seeing roughly 20% speed up in my VM where I am just
installing emacs in an image. Installation time drops from 31 seconds to
25 seconds when nosync option is used. This is for the case of building on top
of an image where all packages are already cached. That way I take
out the network operations latency out of the measurement.

Giuseppe is also looking to cut down on number of iops done on the
disk. He is complaining that often in cloud their VMs are throttled
if they cross the limit. This option can help them where they reduce
number of iops (by cutting down on frequent sync and writebacks).

Changes from v5:
- Added support to detect that previous overlay was mounted with
  "volatile" option and fail mount. (Miklos and Amir).

Changes from v4:
- Dropped support for sync=fs (Miklos)
- Renamed "sync=off" to "volatile". (Miklos)

Changes from v3:
- Used only enums and dropped bit flags (Amir Goldstein)
- Dropped error when conflicting sync options provided. (Amir Goldstein)

Changes from v2:
- Added helper functions (Amir Goldstein)
- Used enums to keep sync state (Amir Goldstein)

Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 Documentation/filesystems/overlayfs.rst |  17 ++++
 fs/overlayfs/copy_up.c                  |  12 ++-
 fs/overlayfs/file.c                     |  10 +-
 fs/overlayfs/ovl_entry.h                |   6 ++
 fs/overlayfs/readdir.c                  |   3 +
 fs/overlayfs/super.c                    | 128 +++++++++++++++++++++++-
 6 files changed, 168 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 8ea83a51c266..438add193166 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -563,6 +563,23 @@ This verification may cause significant overhead in some cases.
 Note: the mount options index=off,nfs_export=on are conflicting for a
 read-write mount and will result in an error.
 
+Disable sync
+------------
+By default, overlay skips sync on files residing on a lower layer.  It
+is possible to skip sync operations for files on the upper layer as well
+with the "volatile" mount option.
+
+"volatile" mount option disables all forms of sync from overlay, including
+the one done at umount/remount. If system crashes or shuts down, user
+should throw away upper directory and start fresh.
+
+When overlay is mounted with "volatile" option, overlay creates an internal
+file "$workdir/work/incompat/volatile/dirty". During next mount, overlay
+checks for dirty file and refuses to mount if present. This is a strong
+indicator that user should throw away upper and work directories and
+create fresh one. In very limited cases where user knows system has not
+crashed and contents in upperdir are intact, one can remove "dirty" file and
+retry mount.
 
 Testsuite
 ---------
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index d07fb92b7253..9d17e42d184b 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -128,7 +128,8 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
 	return error;
 }
 
-static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
+static int ovl_copy_up_data(struct ovl_fs *ofs, struct path *old,
+			    struct path *new, loff_t len)
 {
 	struct file *old_file;
 	struct file *new_file;
@@ -218,7 +219,7 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 		len -= bytes;
 	}
 out:
-	if (!error)
+	if (!error && ovl_should_sync(ofs))
 		error = vfs_fsync(new_file, 0);
 	fput(new_file);
 out_fput:
@@ -484,6 +485,7 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 
 static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 {
+	struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
 	int err;
 
 	/*
@@ -499,7 +501,8 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 		upperpath.dentry = temp;
 
 		ovl_path_lowerdata(c->dentry, &datapath);
-		err = ovl_copy_up_data(&datapath, &upperpath, c->stat.size);
+		err = ovl_copy_up_data(ofs, &datapath, &upperpath,
+				       c->stat.size);
 		if (err)
 			return err;
 	}
@@ -784,6 +787,7 @@ static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
 /* Copy up data of an inode which was copied up metadata only in the past. */
 static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
 {
+	struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
 	struct path upperpath, datapath;
 	int err;
 	char *capability = NULL;
@@ -804,7 +808,7 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
 			goto out;
 	}
 
-	err = ovl_copy_up_data(&datapath, &upperpath, c->stat.size);
+	err = ovl_copy_up_data(ofs, &datapath, &upperpath, c->stat.size);
 	if (err)
 		goto out_free;
 
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 0d940e29d62b..3582c3ae819c 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -331,6 +331,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	struct fd real;
 	const struct cred *old_cred;
 	ssize_t ret;
+	int ifl = iocb->ki_flags;
 
 	if (!iov_iter_count(iter))
 		return 0;
@@ -346,11 +347,14 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	if (ret)
 		goto out_unlock;
 
+	if (!ovl_should_sync(OVL_FS(inode->i_sb)))
+		ifl &= ~(IOCB_DSYNC | IOCB_SYNC);
+
 	old_cred = ovl_override_creds(file_inode(file)->i_sb);
 	if (is_sync_kiocb(iocb)) {
 		file_start_write(real.file);
 		ret = vfs_iter_write(real.file, iter, &iocb->ki_pos,
-				     ovl_iocb_to_rwf(iocb->ki_flags));
+				     ovl_iocb_to_rwf(ifl));
 		file_end_write(real.file);
 		/* Update size */
 		ovl_copyattr(ovl_inode_real(inode), inode);
@@ -370,6 +374,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		real.flags = 0;
 		aio_req->orig_iocb = iocb;
 		kiocb_clone(&aio_req->iocb, iocb, real.file);
+		aio_req->iocb.ki_flags = ifl;
 		aio_req->iocb.ki_complete = ovl_aio_rw_complete;
 		ret = vfs_iocb_iter_write(real.file, &aio_req->iocb, iter);
 		if (ret != -EIOCBQUEUED)
@@ -433,6 +438,9 @@ static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	const struct cred *old_cred;
 	int ret;
 
+	if (!ovl_should_sync(OVL_FS(file_inode(file)->i_sb)))
+		return 0;
+
 	ret = ovl_real_fdget_meta(file, &real, !datasync);
 	if (ret)
 		return ret;
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index b429c80879ee..1b5a2094df8e 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -17,6 +17,7 @@ struct ovl_config {
 	bool nfs_export;
 	int xino;
 	bool metacopy;
+	bool ovl_volatile;
 };
 
 struct ovl_sb {
@@ -90,6 +91,11 @@ static inline struct ovl_fs *OVL_FS(struct super_block *sb)
 	return (struct ovl_fs *)sb->s_fs_info;
 }
 
+static inline bool ovl_should_sync(struct ovl_fs *ofs)
+{
+	return !ofs->config.ovl_volatile;
+}
+
 /* private information held for every overlayfs dentry */
 struct ovl_entry {
 	union {
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 6918b98faeb6..2065c10ff0d1 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -863,6 +863,9 @@ static int ovl_dir_fsync(struct file *file, loff_t start, loff_t end,
 	if (!OVL_TYPE_UPPER(ovl_path_type(dentry)))
 		return 0;
 
+	if (!ovl_should_sync(OVL_FS(dentry->d_sb)))
+		return 0;
+
 	/*
 	 * Need to check if we started out being a lower dir, but got copied up
 	 */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 4b38141c2985..a1a4965912dc 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -264,6 +264,8 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
 	if (!ovl_upper_mnt(ofs))
 		return 0;
 
+	if (!ovl_should_sync(ofs))
+		return 0;
 	/*
 	 * Not called for sync(2) call or an emergency sync (SB_I_SKIP_SYNC).
 	 * All the super blocks will be iterated, including upper_sb.
@@ -362,6 +364,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	if (ofs->config.metacopy != ovl_metacopy_def)
 		seq_printf(m, ",metacopy=%s",
 			   ofs->config.metacopy ? "on" : "off");
+	if (ofs->config.ovl_volatile)
+		seq_printf(m, ",volatile");
 	return 0;
 }
 
@@ -376,9 +380,11 @@ static int ovl_remount(struct super_block *sb, int *flags, char *data)
 
 	if (*flags & SB_RDONLY && !sb_rdonly(sb)) {
 		upper_sb = ovl_upper_mnt(ofs)->mnt_sb;
-		down_read(&upper_sb->s_umount);
-		ret = sync_filesystem(upper_sb);
-		up_read(&upper_sb->s_umount);
+		if (ovl_should_sync(ofs)) {
+			down_read(&upper_sb->s_umount);
+			ret = sync_filesystem(upper_sb);
+			up_read(&upper_sb->s_umount);
+		}
 	}
 
 	return ret;
@@ -411,6 +417,7 @@ enum {
 	OPT_XINO_AUTO,
 	OPT_METACOPY_ON,
 	OPT_METACOPY_OFF,
+	OPT_VOLATILE,
 	OPT_ERR,
 };
 
@@ -429,6 +436,7 @@ static const match_table_t ovl_tokens = {
 	{OPT_XINO_AUTO,			"xino=auto"},
 	{OPT_METACOPY_ON,		"metacopy=on"},
 	{OPT_METACOPY_OFF,		"metacopy=off"},
+	{OPT_VOLATILE,			"volatile"},
 	{OPT_ERR,			NULL}
 };
 
@@ -573,6 +581,10 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			metacopy_opt = true;
 			break;
 
+		case OPT_VOLATILE:
+			config->ovl_volatile = true;
+			break;
+
 		default:
 			pr_err("unrecognized mount option \"%s\" or missing value\n",
 					p);
@@ -595,6 +607,11 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 		config->index = false;
 	}
 
+	if (!config->upperdir && config->ovl_volatile) {
+		pr_info("option \"volatile\" is meaningless in a non-upper mount, ignoring it.\n");
+		config->ovl_volatile = false;
+	}
+
 	err = ovl_parse_redirect_mode(config, config->redirect_mode);
 	if (err)
 		return err;
@@ -676,6 +693,8 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 
 #define OVL_WORKDIR_NAME "work"
 #define OVL_INDEXDIR_NAME "index"
+#define OVL_VOLATILE_NAME "volatile"
+#define OVL_DIRTY_PATH "work/incompat/volatile/dirty"
 
 static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
 					 const char *name, bool persist)
@@ -1199,6 +1218,89 @@ static int ovl_check_rename_whiteout(struct dentry *workdir)
 	return err;
 }
 
+/*
+ * This function does two things. If "create" is not set, it checks
+ * if dirty file is present or not. If "create" is set, then it
+ * creates dirty file.
+ *
+ * Returns err < 0 in case of error. Returns 1 if dirty file was found.
+ * And returns err == 0 for success. err = 0 means two different
+ * things depending on if "create" was set or not. If "create" was
+ * set, it means dirty file was created successfuly. if "create"
+ * is not set, then it means dirty file was not found.
+ */
+static int ovl_check_create_dirty(struct ovl_fs *ofs, bool create)
+{
+	struct dentry *parent, *child;
+	char *name;
+	int ctr, i, len, err;
+	char *s, *dirty_path;
+
+	dirty_path = kstrdup(OVL_DIRTY_PATH, GFP_KERNEL);
+	if (!dirty_path)
+		return -ENOMEM;
+
+	ctr = 1;
+	for (s = dirty_path;; s++) {
+		if (*s == '/') {
+			*s = '\0';
+			ctr++;
+			continue;
+		}
+		if (!*s)
+			break;
+	}
+
+	err = 0;
+	name = dirty_path;
+	len = strlen(name);
+	parent = ofs->workbasedir;
+	dget(parent);
+	for (i = 1; ; i++) {
+		inode_lock_nested(parent->d_inode, I_MUTEX_PARENT);
+		child = lookup_one_len(name, parent, len);
+		if (IS_ERR(child)) {
+			err = PTR_ERR(child);
+			goto out_unlock;
+		}
+
+		if (!child->d_inode) {
+			unsigned short ftype;
+
+			if (!create)
+				goto out_put_child;
+
+			ftype = (i == ctr) ? S_IFREG : S_IFDIR;
+			child = ovl_create_real(parent->d_inode, child,
+						OVL_CATTR(ftype | 0));
+			if (IS_ERR(child)) {
+				err = PTR_ERR(child);
+				goto out_unlock;
+			}
+		}
+
+		if (i == ctr) {
+			if (!create)
+				err = 1;
+			goto out_put_child;
+		}
+
+		inode_unlock(parent->d_inode);
+		dput(parent);
+		parent = child;
+		name += len + 1;
+		len = strlen(name);
+	}
+
+out_put_child:
+	dput(child);
+out_unlock:
+	inode_unlock(parent->d_inode);
+	dput(parent);
+	kfree(dirty_path);
+	return err;
+}
+
 static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 			    struct path *workpath)
 {
@@ -1213,6 +1315,17 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	if (err)
 		return err;
 
+	/* Check if dirty file is present. If yes, refuse mount */
+	err = ovl_check_create_dirty(ofs, false);
+	if (err < 0)
+		goto out;
+
+	if (err == 1) {
+		pr_err("File %pd/%s exists. This workdir was mounted with overlay option volatile. Preferrably, discard upper layer and workdir and create fresh one. Optionally, if system did not crash and upper layer is intact, remove dirty file and retry.\n", ofs->workbasedir, OVL_DIRTY_PATH);
+		err = -EINVAL;
+		goto out;
+	}
+
 	ofs->workdir = ovl_workdir_create(ofs, OVL_WORKDIR_NAME, false);
 	if (!ofs->workdir)
 		goto out;
@@ -1279,6 +1392,15 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 		goto out;
 	}
 
+	/* For volatile mount, create a dirty file to keep track of it */
+	if (ofs->config.ovl_volatile) {
+		err = ovl_check_create_dirty(ofs, true);
+		if (err < 0) {
+			pr_err("Failed to create dirty file.\n");
+			goto out;
+		}
+	}
+
 	/* Check if upper/work fs supports file handles */
 	fh_type = ovl_can_decode_fh(ofs->workdir->d_sb);
 	if (ofs->config.index && !fh_type) {
-- 
2.25.4

