Return-Path: <SRS0=Dknc=AM=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC8AC433DF
	for <linux-unionfs@archiver.kernel.org>; Wed,  1 Jul 2020 17:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2B5920720
	for <linux-unionfs@archiver.kernel.org>; Wed,  1 Jul 2020 17:57:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DbUga/8G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729871AbgGAR51 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 13:57:27 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44489 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726693AbgGAR51 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 1 Jul 2020 13:57:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593626243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=E4TeMA+61y5nqaJoJ3t8TUTntqCyIMBp5v9x/87j/No=;
        b=DbUga/8GK3leGt7ihIzMbJUS4cVyASzqnV0d2VhZgywKCX+5PMmYVkv+ruoBBht+H6AGTf
        6GICXT4DBBtq89+YG0RkbwYxlgZKBL28IAthrLM5N8AfcTCclz4yn9j80frV/oSDT5ja3r
        DbhqtB7iDpJqigVGA8FA/Z1YsuYGT9Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-HFmbruiYNlC2BKlZDFTh4w-1; Wed, 01 Jul 2020 13:57:21 -0400
X-MC-Unique: HFmbruiYNlC2BKlZDFTh4w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F0828015F4;
        Wed,  1 Jul 2020 17:57:20 +0000 (UTC)
Received: from horse.redhat.com (ovpn-120-30.rdu2.redhat.com [10.10.120.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6BEE60C81;
        Wed,  1 Jul 2020 17:57:16 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 47487220A35; Wed,  1 Jul 2020 13:57:16 -0400 (EDT)
Date:   Wed, 1 Jul 2020 13:57:16 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        miklos@szeredi.hu
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>, pmatilai@redhat.com
Subject: [RFC PATCH v2] overlayfs: Provide mount options sync=off/fs to skip
 sync
Message-ID: <20200701175716.GA384828@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

So this patch provides two mount options "sync=off" and "sync=fs".
First option disables all forms of sync. Now it is caller's responsibility
to throw away upper if system crashes or shuts down and start fresh.

Opption "sync=fs" disables all forms of sync except syncfs/umount/remount.
This is basically useful for image build where we want to persist upper
layer only after operation is complete and upper will be renamed and
reused as lower for next layer build.

With sync=off, I am seeing roughly 20% speed up in my VM where I am just
installing emacs in an image. Installation time drops from 31 seconds to
25 seconds when nosync option is used. This is for the case of building on top
of an image where all packages are already cached. That way I take
out the network operations latency out of the measurement.

With sync=fs, I am seeing roughly 12% speed up.

Giuseppe is also looking to cut down on number of iops done on the
disk. He is complaining that often in cloud their VMs are throttled
if they cross the limit. This option can help them where they reduce
number of iops (by cutting down on frequent sync and writebacks).

Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 Documentation/filesystems/overlayfs.rst | 16 +++++++++++
 fs/overlayfs/copy_up.c                  | 12 +++++---
 fs/overlayfs/file.c                     | 13 ++++++++-
 fs/overlayfs/ovl_entry.h                |  2 ++
 fs/overlayfs/readdir.c                  |  4 +++
 fs/overlayfs/super.c                    | 37 +++++++++++++++++++++++--
 6 files changed, 76 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 660dbaf0b9b8..4e8e44ee31aa 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -563,6 +563,22 @@ This verification may cause significant overhead in some cases.
 Note: the mount options index=off,nfs_export=on are conflicting and will
 result in an error.
 
+Disable sync
+------------
+By default, overlay skips sync on files residing on a lower layer.  It
+is possible to skip sync operations for files on the upper layer as well
+with the "sync=off" and "sync=fs" mount option.
+
+"sync=off" option disables all forms of sync from overlay, including the
+one done at umount/remount. If system crashes or shuts down data, user
+should throw away upper and start fresh.
+
+"sync=fs" option disables all forms of sync except full filesystem
+sync which is done at syncfs/remount/mount time. This is useful for
+use cases like container image build which want upper to persist
+only if operation has finished. If system crashes before image
+layer formation is complete, tools will discard upper and start
+fresh.
 
 Testsuite
 ---------
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 79dd052c7dbf..e576929d619d 100644
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
+	if (!error && (!ofs->config.nosync && !ofs->config.syncfs))
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
index 01820e654a21..2a01fb8ba897 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -329,6 +329,8 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	struct fd real;
 	const struct cred *old_cred;
 	ssize_t ret;
+	int ifl = iocb->ki_flags;
+	struct ovl_fs *ofs;
 
 	if (!iov_iter_count(iter))
 		return 0;
@@ -344,11 +346,15 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	if (ret)
 		goto out_unlock;
 
+	ofs = OVL_FS(inode->i_sb);
+	if (ofs->config.nosync || ofs->config.syncfs)
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
@@ -368,6 +374,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		real.flags = 0;
 		aio_req->orig_iocb = iocb;
 		kiocb_clone(&aio_req->iocb, iocb, real.file);
+		aio_req->iocb.ki_flags = ifl;
 		aio_req->iocb.ki_complete = ovl_aio_rw_complete;
 		ret = vfs_iocb_iter_write(real.file, &aio_req->iocb, iter);
 		if (ret != -EIOCBQUEUED)
@@ -430,6 +437,10 @@ static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	struct fd real;
 	const struct cred *old_cred;
 	int ret;
+	struct ovl_fs *ofs = OVL_FS(file_inode(file)->i_sb);
+
+	if (ofs->config.nosync || ofs->config.syncfs)
+		return 0;
 
 	ret = ovl_real_fdget_meta(file, &real, !datasync);
 	if (ret)
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index b429c80879ee..473508f1a1da 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -17,6 +17,8 @@ struct ovl_config {
 	bool nfs_export;
 	int xino;
 	bool metacopy;
+	bool nosync;
+	bool syncfs;
 };
 
 struct ovl_sb {
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 6918b98faeb6..970319ca1623 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -858,11 +858,15 @@ static int ovl_dir_fsync(struct file *file, loff_t start, loff_t end,
 	struct ovl_dir_file *od = file->private_data;
 	struct dentry *dentry = file->f_path.dentry;
 	struct file *realfile = od->realfile;
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 
 	/* Nothing to sync for lower */
 	if (!OVL_TYPE_UPPER(ovl_path_type(dentry)))
 		return 0;
 
+	if (ofs->config.nosync || ofs->config.syncfs)
+		return 0;
+
 	/*
 	 * Need to check if we started out being a lower dir, but got copied up
 	 */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 91476bc422f9..eb55de2ce149 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -264,6 +264,8 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
 	if (!ovl_upper_mnt(ofs))
 		return 0;
 
+	if (ofs->config.nosync)
+		return 0;
 	/*
 	 * Not called for sync(2) call or an emergency sync (SB_I_SKIP_SYNC).
 	 * All the super blocks will be iterated, including upper_sb.
@@ -362,6 +364,10 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	if (ofs->config.metacopy != ovl_metacopy_def)
 		seq_printf(m, ",metacopy=%s",
 			   ofs->config.metacopy ? "on" : "off");
+	if (ofs->config.nosync)
+		seq_puts(m, ",sync=off");
+	if (ofs->config.syncfs)
+		seq_puts(m, ",sync=fs");
 	return 0;
 }
 
@@ -376,9 +382,11 @@ static int ovl_remount(struct super_block *sb, int *flags, char *data)
 
 	if (*flags & SB_RDONLY && !sb_rdonly(sb)) {
 		upper_sb = ovl_upper_mnt(ofs)->mnt_sb;
-		down_read(&upper_sb->s_umount);
-		ret = sync_filesystem(upper_sb);
-		up_read(&upper_sb->s_umount);
+		if (!ofs->config.nosync) {
+			down_read(&upper_sb->s_umount);
+			ret = sync_filesystem(upper_sb);
+			up_read(&upper_sb->s_umount);
+		}
 	}
 
 	return ret;
@@ -411,6 +419,8 @@ enum {
 	OPT_XINO_AUTO,
 	OPT_METACOPY_ON,
 	OPT_METACOPY_OFF,
+	OPT_SYNC_OFF,
+	OPT_SYNC_FS,
 	OPT_ERR,
 };
 
@@ -429,6 +439,8 @@ static const match_table_t ovl_tokens = {
 	{OPT_XINO_AUTO,			"xino=auto"},
 	{OPT_METACOPY_ON,		"metacopy=on"},
 	{OPT_METACOPY_OFF,		"metacopy=off"},
+	{OPT_SYNC_OFF,			"sync=off"},
+	{OPT_SYNC_FS,			"sync=fs"},
 	{OPT_ERR,			NULL}
 };
 
@@ -573,6 +585,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			metacopy_opt = true;
 			break;
 
+		case OPT_SYNC_OFF:
+			config->nosync = true;
+			break;
+
+		case OPT_SYNC_FS:
+			config->syncfs = true;
+			break;
+
 		default:
 			pr_err("unrecognized mount option \"%s\" or missing value\n",
 					p);
@@ -588,6 +608,17 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 		config->workdir = NULL;
 	}
 
+	if (config->nosync && config->syncfs) {
+		pr_err("conflicting options: sync=off,sync=fs\n");
+		return -EINVAL;
+	}
+
+	if (!config->upperdir && (config->nosync || config->syncfs)) {
+		pr_info("option sync=off/fs is meaningless in a non-upper mount, ignoring it.\n");
+		config->nosync = false;
+		config->syncfs = false;
+	}
+
 	err = ovl_parse_redirect_mode(config, config->redirect_mode);
 	if (err)
 		return err;
-- 
2.25.4

