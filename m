Return-Path: <SRS0=UrPG=A3=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B31CC433E0
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Jul 2020 20:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1503C20787
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Jul 2020 20:41:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DquSKvtR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgGPUln (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 16:41:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60077 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725926AbgGPUln (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Jul 2020 16:41:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594932100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RGh4RvBxtOML+rbuatPCPne55SW5vXaPWNNSlzfPpcw=;
        b=DquSKvtR8gfaYw2oSutlGOxRKd5EXtgm07IunK9BMZb9slyHJc22XdQOTViO4Gs5qCCTWn
        hOMQ+qRQf/l26AOk6tcX5bgAFYLzvRzfw5+VWxO2SpKi50MjLolLvnOwTCI0EykdD75L61
        Bnb14lAURphqLwGV4QkiaHginGxWp8s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-U5ZEZMgPO0212EUTdUrYXg-1; Thu, 16 Jul 2020 16:41:38 -0400
X-MC-Unique: U5ZEZMgPO0212EUTdUrYXg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E965B1081;
        Thu, 16 Jul 2020 20:41:37 +0000 (UTC)
Received: from horse.redhat.com (ovpn-114-241.rdu2.redhat.com [10.10.114.241])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93FB1710A0;
        Thu, 16 Jul 2020 20:41:34 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 277C7225777; Thu, 16 Jul 2020 16:41:34 -0400 (EDT)
Date:   Thu, 16 Jul 2020 16:41:34 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     linux-unionfs@vger.kernel.org, miklos@szeredi.hu
Cc:     amir73il@gmail.com, gscrivan@redhat.com, pmatilai@redhat.com,
        dwalsh@redhat.com, swhiteho@redhat.com, sandeen@redhat.com
Subject: Re: [RFC PATCH] overlayfs: Provide a mount option "nosync" to skip
 sync
Message-ID: <20200716204134.GF422759@redhat.com>
References: <20200630193708.GB328891@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630193708.GB328891@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 30, 2020 at 03:37:08PM -0400, Vivek Goyal wrote:
> Container folks are complaining that dnf/yum issues too many sync while
> installing packages and this slows down the image build. Build
> requirement is such that they don't care if a node goes down while
> build was still going on. In that case, they will simply throw away
> unfinished layer and start new build. So they don't care about syncing
> intermediate state to the disk and hence don't want to pay the price
> associated with sync.
> 

Hi Miklos,

Ping for this patch. What do you think about this patch. Can this be
merged.

Thanks
Vivek

> So they are asking for an option where they can disable sync on overlay
> mount point completely and user space will do sync management on upper
> layer as needed.
> 
> They primarily seem to have two use cases.
> 
> - For building images, they will mount overlay with nosync and then sync
>   upper layer after unmounting overlay and reuse upper as lower for next
>   layer.
> 
> - For running containers, they don't seem to care about syncing upper
>   layer because if node goes down, they will simply throw away upper
>   layer and create a fresh one.
> 
> So this patch provides a mount option "nosync" which disables all forms
> of sync. Now it is caller's responsibility to manage sync of upper layer
> before it is reused again.
> 
> I am seeing roughly 20% speed up in my VM where I am just installing
> emacs in an image. Installation time drops from 31 seconds to 25 seconds
> when nosync option is used. This is for the case of building on top
> of an image where all packages are already cached. That way I take
> out the network operations latency out of the measurement.
> 
> Giuseppe is also looking to cut down on number of iops done on the
> disk. He is complaining that often in cloud their VMs are throttled
> if they cross the limit. This option can help them where they reduce
> number of iops (by cutting down on frequent sync and writebacks).
> 
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  Documentation/filesystems/overlayfs.rst | 20 ++++++++++++++++++++
>  fs/overlayfs/copy_up.c                  | 12 ++++++++----
>  fs/overlayfs/file.c                     | 11 ++++++++++-
>  fs/overlayfs/ovl_entry.h                |  1 +
>  fs/overlayfs/readdir.c                  |  3 +++
>  fs/overlayfs/super.c                    | 23 ++++++++++++++++++++---
>  6 files changed, 62 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
> index 660dbaf0b9b8..0a42f26a3f0c 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -563,6 +563,26 @@ This verification may cause significant overhead in some cases.
>  Note: the mount options index=off,nfs_export=on are conflicting and will
>  result in an error.
>  
> +Disable sync
> +------------
> +By default, overlay skips sync on files residing on a lower layer.  It
> +is possible to skip sync operations for files on the upper layer as well
> +with the 'nosync' mount option. This option disables all forms of sync
> +from overlay, including the one done at umount/remount and it is
> +user's responsibility to sync upper layer on the file system it
> +is residing.
> +
> +With this option, data loss will happen if overlayfs upper layer is
> +not synced. So use this option very carefully. This is only for the
> +use cases where users discard upper layer if they could not sync it
> +successfully.
> +
> +Typically workflow will be.
> +
> +- mount overlay
> +- Do bunch of operations
> +- unmount overlay
> +- sync filesystem container upper layer
>  
>  Testsuite
>  ---------
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 79dd052c7dbf..5431a89bbd8a 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -128,7 +128,8 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
>  	return error;
>  }
>  
> -static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
> +static int ovl_copy_up_data(struct ovl_fs *ofs, struct path *old,
> +			    struct path *new, loff_t len)
>  {
>  	struct file *old_file;
>  	struct file *new_file;
> @@ -218,7 +219,7 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
>  		len -= bytes;
>  	}
>  out:
> -	if (!error)
> +	if (!error && !ofs->config.nosync)
>  		error = vfs_fsync(new_file, 0);
>  	fput(new_file);
>  out_fput:
> @@ -484,6 +485,7 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
>  
>  static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
>  {
> +	struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
>  	int err;
>  
>  	/*
> @@ -499,7 +501,8 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
>  		upperpath.dentry = temp;
>  
>  		ovl_path_lowerdata(c->dentry, &datapath);
> -		err = ovl_copy_up_data(&datapath, &upperpath, c->stat.size);
> +		err = ovl_copy_up_data(ofs, &datapath, &upperpath,
> +				       c->stat.size);
>  		if (err)
>  			return err;
>  	}
> @@ -784,6 +787,7 @@ static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
>  /* Copy up data of an inode which was copied up metadata only in the past. */
>  static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
>  {
> +	struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
>  	struct path upperpath, datapath;
>  	int err;
>  	char *capability = NULL;
> @@ -804,7 +808,7 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
>  			goto out;
>  	}
>  
> -	err = ovl_copy_up_data(&datapath, &upperpath, c->stat.size);
> +	err = ovl_copy_up_data(ofs, &datapath, &upperpath, c->stat.size);
>  	if (err)
>  		goto out_free;
>  
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 01820e654a21..a361890a8d05 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -329,6 +329,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>  	struct fd real;
>  	const struct cred *old_cred;
>  	ssize_t ret;
> +	int ifl = iocb->ki_flags;
>  
>  	if (!iov_iter_count(iter))
>  		return 0;
> @@ -344,11 +345,14 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>  	if (ret)
>  		goto out_unlock;
>  
> +	if (OVL_FS(inode->i_sb)->config.nosync)
> +		ifl &= ~(IOCB_DSYNC | IOCB_SYNC);
> +
>  	old_cred = ovl_override_creds(file_inode(file)->i_sb);
>  	if (is_sync_kiocb(iocb)) {
>  		file_start_write(real.file);
>  		ret = vfs_iter_write(real.file, iter, &iocb->ki_pos,
> -				     ovl_iocb_to_rwf(iocb->ki_flags));
> +				     ovl_iocb_to_rwf(ifl));
>  		file_end_write(real.file);
>  		/* Update size */
>  		ovl_copyattr(ovl_inode_real(inode), inode);
> @@ -368,6 +372,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>  		real.flags = 0;
>  		aio_req->orig_iocb = iocb;
>  		kiocb_clone(&aio_req->iocb, iocb, real.file);
> +		aio_req->iocb.ki_flags = ifl;
>  		aio_req->iocb.ki_complete = ovl_aio_rw_complete;
>  		ret = vfs_iocb_iter_write(real.file, &aio_req->iocb, iter);
>  		if (ret != -EIOCBQUEUED)
> @@ -430,6 +435,10 @@ static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>  	struct fd real;
>  	const struct cred *old_cred;
>  	int ret;
> +	struct ovl_fs *ofs = OVL_FS(file_inode(file)->i_sb);
> +
> +	if (ofs->config.nosync)
> +		return 0;
>  
>  	ret = ovl_real_fdget_meta(file, &real, !datasync);
>  	if (ret)
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index b429c80879ee..034a8d9897e0 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -17,6 +17,7 @@ struct ovl_config {
>  	bool nfs_export;
>  	int xino;
>  	bool metacopy;
> +	bool nosync;
>  };
>  
>  struct ovl_sb {
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 6918b98faeb6..9e93db028dbf 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -863,6 +863,9 @@ static int ovl_dir_fsync(struct file *file, loff_t start, loff_t end,
>  	if (!OVL_TYPE_UPPER(ovl_path_type(dentry)))
>  		return 0;
>  
> +	if (OVL_FS(dentry->d_sb)->config.nosync)
> +		return 0;
> +
>  	/*
>  	 * Need to check if we started out being a lower dir, but got copied up
>  	 */
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 91476bc422f9..c28ab39b5c70 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -264,6 +264,8 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
>  	if (!ovl_upper_mnt(ofs))
>  		return 0;
>  
> +	if (ofs->config.nosync)
> +		return 0;
>  	/*
>  	 * Not called for sync(2) call or an emergency sync (SB_I_SKIP_SYNC).
>  	 * All the super blocks will be iterated, including upper_sb.
> @@ -362,6 +364,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>  	if (ofs->config.metacopy != ovl_metacopy_def)
>  		seq_printf(m, ",metacopy=%s",
>  			   ofs->config.metacopy ? "on" : "off");
> +	if (ofs->config.nosync)
> +		seq_puts(m, ",nosync");
>  	return 0;
>  }
>  
> @@ -376,9 +380,11 @@ static int ovl_remount(struct super_block *sb, int *flags, char *data)
>  
>  	if (*flags & SB_RDONLY && !sb_rdonly(sb)) {
>  		upper_sb = ovl_upper_mnt(ofs)->mnt_sb;
> -		down_read(&upper_sb->s_umount);
> -		ret = sync_filesystem(upper_sb);
> -		up_read(&upper_sb->s_umount);
> +		if (!ofs->config.nosync) {
> +			down_read(&upper_sb->s_umount);
> +			ret = sync_filesystem(upper_sb);
> +			up_read(&upper_sb->s_umount);
> +		}
>  	}
>  
>  	return ret;
> @@ -411,6 +417,7 @@ enum {
>  	OPT_XINO_AUTO,
>  	OPT_METACOPY_ON,
>  	OPT_METACOPY_OFF,
> +	OPT_NOSYNC,
>  	OPT_ERR,
>  };
>  
> @@ -429,6 +436,7 @@ static const match_table_t ovl_tokens = {
>  	{OPT_XINO_AUTO,			"xino=auto"},
>  	{OPT_METACOPY_ON,		"metacopy=on"},
>  	{OPT_METACOPY_OFF,		"metacopy=off"},
> +	{OPT_NOSYNC,			"nosync"},
>  	{OPT_ERR,			NULL}
>  };
>  
> @@ -573,6 +581,10 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>  			metacopy_opt = true;
>  			break;
>  
> +		case OPT_NOSYNC:
> +			config->nosync = true;
> +			break;
> +
>  		default:
>  			pr_err("unrecognized mount option \"%s\" or missing value\n",
>  					p);
> @@ -588,6 +600,11 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>  		config->workdir = NULL;
>  	}
>  
> +	if (!config->upperdir && config->nosync) {
> +		pr_info("option nosync is meaningless in a non-upper mount, ignoring it.\n");
> +		config->nosync = false;
> +	}
> +
>  	err = ovl_parse_redirect_mode(config, config->redirect_mode);
>  	if (err)
>  		return err;
> -- 
> 2.25.4
> 

