Return-Path: <SRS0=jUhd=BB=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A1BC433E3
	for <linux-unionfs@archiver.kernel.org>; Wed, 22 Jul 2020 17:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC65320657
	for <linux-unionfs@archiver.kernel.org>; Wed, 22 Jul 2020 17:50:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QXsiITLF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbgGVRud (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 22 Jul 2020 13:50:33 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31847 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728511AbgGVRuc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 22 Jul 2020 13:50:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595440230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=UpYjZ/84Lm4O32MeQQ+4Iiq+8dLDPNb/TrSgqHpBnU4=;
        b=QXsiITLFM++c6jx6hCnyGywsF8Ukrk7u3AjrkhH7HflQJxRpaIUA/oDjzaHDi6BPvR02za
        s8K0wg9gWB13S2AXdtlFghvWwtQBVWgndekC/p7hwqFVSIcxwsKlV5OtATSOzLm9zJrcD5
        Outm4RQ/wx6IVkr9eQVV0Rbqz05X5Ew=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-qNwktyEZPWGbANkfZIU4ig-1; Wed, 22 Jul 2020 13:50:26 -0400
X-MC-Unique: qNwktyEZPWGbANkfZIU4ig-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2929B8017FB;
        Wed, 22 Jul 2020 17:50:25 +0000 (UTC)
Received: from horse.redhat.com (ovpn-118-98.rdu2.redhat.com [10.10.118.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E9D710027A5;
        Wed, 22 Jul 2020 17:50:24 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 1C3742202B4; Wed, 22 Jul 2020 13:50:24 -0400 (EDT)
Date:   Wed, 22 Jul 2020 13:50:24 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     linux-unionfs@vger.kernel.org, miklos@szeredi.hu
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH v5] overlayfs: Provide a mount option "volatile" to skip sync
Message-ID: <20200722175024.GA608248@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
 Documentation/filesystems/overlayfs.rst |  9 +++++++++
 fs/overlayfs/copy_up.c                  | 12 ++++++++----
 fs/overlayfs/file.c                     | 10 +++++++++-
 fs/overlayfs/ovl_entry.h                |  6 ++++++
 fs/overlayfs/readdir.c                  |  3 +++
 fs/overlayfs/super.c                    | 23 ++++++++++++++++++++---
 6 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index fcda5d6ba9ac..d5fc5c94560e 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -563,6 +563,15 @@ This verification may cause significant overhead in some cases.
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
 
 Testsuite
 ---------
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 5e0cde85bd6b..ffb8334fe94d 100644
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
index 4b38141c2985..701fc4ad822c 100644
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
-- 
2.25.4

