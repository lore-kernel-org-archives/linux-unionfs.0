Return-Path: <SRS0=0kBH=DA=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2323C4727E
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Sep 2020 19:47:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A53F206B2
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Sep 2020 19:47:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WVpIc030"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgIWTrW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 15:47:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24293 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726596AbgIWTrV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 23 Sep 2020 15:47:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600890437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jF7iCJU9LH3yVyUZ8Ly1yaJfYHk6VJEotiD9ZFti6tM=;
        b=WVpIc030r1TePQs3NQTOZFvDqhMu1T7ObtpkwSWVa2BVXxnShGDm8X/dugOiXZur7LM00r
        GdNO8cbZODN2eTWS2zP7sy89Q5pRpCsZW2/sbTptTGUBFFtQEMRyw0FwPaLHEpn5CUCccw
        ns8DH01pXQW15LWkksW2PETuu9cmiSY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-zpxGz_EJNcqJkmQKUvYWpA-1; Wed, 23 Sep 2020 15:47:15 -0400
X-MC-Unique: zpxGz_EJNcqJkmQKUvYWpA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEEEF800135;
        Wed, 23 Sep 2020 19:47:13 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-176.rdu2.redhat.com [10.10.116.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9874278823;
        Wed, 23 Sep 2020 19:47:13 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 27B97223B13; Wed, 23 Sep 2020 15:47:13 -0400 (EDT)
Date:   Wed, 23 Sep 2020 15:47:13 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ovl: introduce new "index=nouuid" option for inodes
 index feature
Message-ID: <20200923194713.GD88270@redhat.com>
References: <20200923152308.3389-1-ptikhomirov@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923152308.3389-1-ptikhomirov@virtuozzo.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Sep 23, 2020 at 06:23:08PM +0300, Pavel Tikhomirov wrote:
> This relaxes uuid checks for overlay index feature. It is only possible
> in case there is only one filesystem for all the work/upper/lower
> directories and bare file handles from this backing filesystem are uniq.

Hi Pavel,

Wondering why upper/work has to be on same filesystem as lower for this to
work?

> In case we have multiple filesystems here just fall back to normal
> "index=on".
> 
> This is needed when overlayfs is/was mounted in a container with
> index enabled (e.g.: to be able to resolve inotify watch file handles on
> it to paths in CRIU), and this container is copied and started alongside
> with the original one. This way the "copy" container can't have the same
> uuid on the superblock and mounting the overlayfs from it later would
> fail.
> 
> That is an example of the problem on top of loop+ext4:
> 
> dd if=/dev/zero of=loopbackfile.img bs=100M count=10
> losetup -fP loopbackfile.img
> losetup -a
>   #/dev/loop0: [64768]:35 (/loop-test/loopbackfile.img)
> mkfs.ext4 loopbackfile.img
> mkdir loop-mp
> mount -o loop /dev/loop0 loop-mp
> mkdir loop-mp/{lower,upper,work,merged}
> mount -t overlay overlay -oindex=on,lowerdir=loop-mp/lower,\
> upperdir=loop-mp/upper,workdir=loop-mp/work loop-mp/merged
> umount loop-mp/merged
> umount loop-mp
> e2fsck -f /dev/loop0
> tune2fs -U random /dev/loop0
> 
> mount -o loop /dev/loop0 loop-mp
> mount -t overlay overlay -oindex=on,lowerdir=loop-mp/lower,\
> upperdir=loop-mp/upper,workdir=loop-mp/work loop-mp/merged
>   #mount: /loop-test/loop-mp/merged:
>   #mount(2) system call failed: Stale file handle.
> 
> mount -t overlay overlay -oindex=nouuid,lowerdir=loop-mp/lower,\
> upperdir=loop-mp/upper,workdir=loop-mp/work loop-mp/merged
> 
> If you just change the uuid of the backing filesystem, overlay is not
> mounting any more. In Virtuozzo we copy container disks (ploops) when
> crate the copy of container and we require fs uuid to be uniq for a new
> container.
> 
> v2: in v1 I missed actual uuid check skip - add it
> 
> CC: Amir Goldstein <amir73il@gmail.com>
> CC: Vivek Goyal <vgoyal@redhat.com>
> CC: Miklos Szeredi <miklos@szeredi.hu>
> CC: linux-unionfs@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> ---
>  fs/overlayfs/Kconfig     | 16 +++++++++++
>  fs/overlayfs/export.c    |  6 ++--
>  fs/overlayfs/namei.c     | 35 +++++++++++++++--------
>  fs/overlayfs/overlayfs.h | 23 +++++++++++----
>  fs/overlayfs/ovl_entry.h |  2 +-
>  fs/overlayfs/super.c     | 61 +++++++++++++++++++++++++++++-----------
>  6 files changed, 106 insertions(+), 37 deletions(-)

Please put something in Documentation file to explain this option. Also
explain where it is safe to use and where it is not. I am concerned
about the case where recreating lower can result in file handle resolving
to a different file (as discusse in other thread). I think it would
be nice if we mention it explicitly.

Thanks
Vivek

> 
> diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
> index dd188c7996b3..b00fd44006f9 100644
> --- a/fs/overlayfs/Kconfig
> +++ b/fs/overlayfs/Kconfig
> @@ -61,6 +61,22 @@ config OVERLAY_FS_INDEX
>  
>  	  If unsure, say N.
>  
> +config OVERLAY_FS_INDEX_NOUUID
> +	bool "Overlayfs: relax uuid checks of inodes index feature"
> +	depends on OVERLAY_FS
> +	depends on OVERLAY_FS_INDEX
> +	help
> +	  If this config option is enabled then overlay will skip uuid checks
> +	  for index lower to upper inode map, this only can be done if all
> +	  upper and lower directories are on the same filesystem where basic
> +	  fhandles are uniq.
> +
> +	  It is needed to overcome possible change of uuid on superblock of the
> +	  backing filesystem, e.g. when you copied the virtual disk and mount
> +	  both the copy of the disk and the original one at the same time.
> +
> +	  If unsure, say N.
> +
>  config OVERLAY_FS_NFS_EXPORT
>  	bool "Overlayfs: turn on NFS export feature by default"
>  	depends on OVERLAY_FS
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 0e696f72cf65..d53feb7547d9 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -676,11 +676,12 @@ static struct dentry *ovl_upper_fh_to_d(struct super_block *sb,
>  	struct ovl_fs *ofs = sb->s_fs_info;
>  	struct dentry *dentry;
>  	struct dentry *upper;
> +	bool nouuid = ofs->config.index == OVL_INDEX_NOUUID;
>  
>  	if (!ovl_upper_mnt(ofs))
>  		return ERR_PTR(-EACCES);
>  
> -	upper = ovl_decode_real_fh(fh, ovl_upper_mnt(ofs), true);
> +	upper = ovl_decode_real_fh(fh, ovl_upper_mnt(ofs), true, nouuid);
>  	if (IS_ERR_OR_NULL(upper))
>  		return upper;
>  
> @@ -700,6 +701,7 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
>  	struct dentry *index = NULL;
>  	struct inode *inode;
>  	int err;
> +	bool nouuid = ofs->config.index == OVL_INDEX_NOUUID;
>  
>  	/* First lookup overlay inode in inode cache by origin fh */
>  	err = ovl_check_origin_fh(ofs, fh, false, NULL, &stack);
> @@ -752,7 +754,7 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
>  			goto out_err;
>  	}
>  	if (index) {
> -		err = ovl_verify_origin(index, origin.dentry, false);
> +		err = ovl_verify_origin(index, origin.dentry, false, nouuid);
>  		if (err)
>  			goto out_err;
>  	}
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index f7d4358db637..676170d719f8 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -149,7 +149,7 @@ static struct ovl_fh *ovl_get_fh(struct dentry *dentry, const char *name)
>  }
>  
>  struct dentry *ovl_decode_real_fh(struct ovl_fh *fh, struct vfsmount *mnt,
> -				  bool connected)
> +				  bool connected, bool nouuid)
>  {
>  	struct dentry *real;
>  	int bytes;
> @@ -158,7 +158,7 @@ struct dentry *ovl_decode_real_fh(struct ovl_fh *fh, struct vfsmount *mnt,
>  	 * Make sure that the stored uuid matches the uuid of the lower
>  	 * layer where file handle will be decoded.
>  	 */
> -	if (!uuid_equal(&fh->fb.uuid, &mnt->mnt_sb->s_uuid))
> +	if (!nouuid && !uuid_equal(&fh->fb.uuid, &mnt->mnt_sb->s_uuid))
>  		return NULL;
>  
>  	bytes = (fh->fb.len - offsetof(struct ovl_fb, fid));
> @@ -342,6 +342,7 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
>  {
>  	struct dentry *origin = NULL;
>  	int i;
> +	bool nouuid = ofs->config.index == OVL_INDEX_NOUUID;
>  
>  	for (i = 1; i < ofs->numlayer; i++) {
>  		/*
> @@ -353,7 +354,7 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
>  			continue;
>  
>  		origin = ovl_decode_real_fh(fh, ofs->layers[i].mnt,
> -					    connected);
> +					    connected, nouuid);
>  		if (origin)
>  			break;
>  	}
> @@ -414,7 +415,7 @@ static int ovl_check_origin(struct ovl_fs *ofs, struct dentry *upperdentry,
>   * Return 0 on match, -ESTALE on mismatch, < 0 on error.
>   */
>  static int ovl_verify_fh(struct dentry *dentry, const char *name,
> -			 const struct ovl_fh *fh)
> +			 const struct ovl_fh *fh, bool nouuid)
>  {
>  	struct ovl_fh *ofh = ovl_get_fh(dentry, name);
>  	int err = 0;
> @@ -425,8 +426,14 @@ static int ovl_verify_fh(struct dentry *dentry, const char *name,
>  	if (IS_ERR(ofh))
>  		return PTR_ERR(ofh);
>  
> -	if (fh->fb.len != ofh->fb.len || memcmp(&fh->fb, &ofh->fb, fh->fb.len))
> +	if (fh->fb.len != ofh->fb.len) {
>  		err = -ESTALE;
> +	} else {
> +		if (nouuid && !uuid_equal(&fh->fb.uuid, &ofh->fb.uuid))
> +			ofh->fb.uuid = fh->fb.uuid;
> +		if (memcmp(&fh->fb, &ofh->fb, fh->fb.len))
> +			err = -ESTALE;
> +	}
>  
>  	kfree(ofh);
>  	return err;
> @@ -441,7 +448,8 @@ static int ovl_verify_fh(struct dentry *dentry, const char *name,
>   * Return 0 on match, -ESTALE on mismatch, -ENODATA on no xattr, < 0 on error.
>   */
>  int ovl_verify_set_fh(struct dentry *dentry, const char *name,
> -		      struct dentry *real, bool is_upper, bool set)
> +		      struct dentry *real, bool is_upper, bool set,
> +		      bool nouuid)
>  {
>  	struct inode *inode;
>  	struct ovl_fh *fh;
> @@ -454,7 +462,7 @@ int ovl_verify_set_fh(struct dentry *dentry, const char *name,
>  		goto fail;
>  	}
>  
> -	err = ovl_verify_fh(dentry, name, fh);
> +	err = ovl_verify_fh(dentry, name, fh, nouuid);
>  	if (set && err == -ENODATA)
>  		err = ovl_do_setxattr(dentry, name, fh->buf, fh->fb.len, 0);
>  	if (err)
> @@ -477,6 +485,7 @@ struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index)
>  {
>  	struct ovl_fh *fh;
>  	struct dentry *upper;
> +	bool nouuid = ofs->config.index == OVL_INDEX_NOUUID;
>  
>  	if (!d_is_dir(index))
>  		return dget(index);
> @@ -485,7 +494,7 @@ struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index)
>  	if (IS_ERR_OR_NULL(fh))
>  		return ERR_CAST(fh);
>  
> -	upper = ovl_decode_real_fh(fh, ovl_upper_mnt(ofs), true);
> +	upper = ovl_decode_real_fh(fh, ovl_upper_mnt(ofs), true, nouuid);
>  	kfree(fh);
>  
>  	if (IS_ERR_OR_NULL(upper))
> @@ -514,6 +523,7 @@ int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index)
>  	struct ovl_path *stack = &origin;
>  	struct dentry *upper = NULL;
>  	int err;
> +	bool nouuid = ofs->config.index == OVL_INDEX_NOUUID;
>  
>  	if (!d_inode(index))
>  		return 0;
> @@ -574,7 +584,7 @@ int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index)
>  		goto fail;
>  	}
>  
> -	err = ovl_verify_fh(upper, OVL_XATTR_ORIGIN, fh);
> +	err = ovl_verify_fh(upper, OVL_XATTR_ORIGIN, fh, nouuid);
>  	dput(upper);
>  	if (err)
>  		goto fail;
> @@ -690,6 +700,7 @@ struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
>  	struct qstr name;
>  	bool is_dir = d_is_dir(origin);
>  	int err;
> +	bool nouuid = ofs->config.index == OVL_INDEX_NOUUID;
>  
>  	err = ovl_get_index_name(origin, &name);
>  	if (err)
> @@ -741,7 +752,7 @@ struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
>  		}
>  
>  		/* Verify that dir index 'upper' xattr points to upper dir */
> -		err = ovl_verify_upper(index, upper, false);
> +		err = ovl_verify_upper(index, upper, false, nouuid);
>  		if (err) {
>  			if (err == -ESTALE) {
>  				pr_warn_ratelimited("suspected multiply redirected dir found (upper=%pd2, origin=%pd2, index=%pd2).\n",
> @@ -840,6 +851,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>  		.redirect = NULL,
>  		.metacopy = false,
>  	};
> +	bool nouuid = ofs->config.index == OVL_INDEX_NOUUID;
>  
>  	if (dentry->d_name.len > ofs->namelen)
>  		return ERR_PTR(-ENAMETOOLONG);
> @@ -939,7 +951,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>  		if (upperdentry && !ctr &&
>  		    ((d.is_dir && ovl_verify_lower(dentry->d_sb)) ||
>  		     (!d.is_dir && ofs->config.index && origin_path))) {
> -			err = ovl_verify_origin(upperdentry, this, false);
> +			err = ovl_verify_origin(upperdentry, this, false,
> +						nouuid);
>  			if (err) {
>  				dput(this);
>  				if (d.is_dir)
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 29bc1ec699e7..2aacfa42bb12 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -18,6 +18,12 @@ enum ovl_path_type {
>  	__OVL_PATH_ORIGIN	= (1 << 2),
>  };
>  
> +enum ovl_index_type {
> +	OVL_INDEX_OFF = 0,
> +	OVL_INDEX_ON,
> +	OVL_INDEX_NOUUID,
> +};
> +
>  #define OVL_TYPE_UPPER(type)	((type) & __OVL_PATH_UPPER)
>  #define OVL_TYPE_MERGE(type)	((type) & __OVL_PATH_MERGE)
>  #define OVL_TYPE_ORIGIN(type)	((type) & __OVL_PATH_ORIGIN)
> @@ -362,11 +368,12 @@ static inline int ovl_check_fh_len(struct ovl_fh *fh, int fh_len)
>  }
>  
>  struct dentry *ovl_decode_real_fh(struct ovl_fh *fh, struct vfsmount *mnt,
> -				  bool connected);
> +				  bool connected, bool nouuid);
>  int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
>  			struct dentry *upperdentry, struct ovl_path **stackp);
>  int ovl_verify_set_fh(struct dentry *dentry, const char *name,
> -		      struct dentry *real, bool is_upper, bool set);
> +		      struct dentry *real, bool is_upper, bool set,
> +		      bool nouuid);
>  struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index);
>  int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index);
>  int ovl_get_index_name(struct dentry *origin, struct qstr *name);
> @@ -379,15 +386,19 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>  bool ovl_lower_positive(struct dentry *dentry);
>  
>  static inline int ovl_verify_origin(struct dentry *upper,
> -				    struct dentry *origin, bool set)
> +				    struct dentry *origin, bool set,
> +				    bool nouuid)
>  {
> -	return ovl_verify_set_fh(upper, OVL_XATTR_ORIGIN, origin, false, set);
> +	return ovl_verify_set_fh(upper, OVL_XATTR_ORIGIN, origin, false, set,
> +				 nouuid);
>  }
>  
>  static inline int ovl_verify_upper(struct dentry *index,
> -				    struct dentry *upper, bool set)
> +				   struct dentry *upper, bool set,
> +				   bool nouuid)
>  {
> -	return ovl_verify_set_fh(index, OVL_XATTR_UPPER, upper, true, set);
> +	return ovl_verify_set_fh(index, OVL_XATTR_UPPER, upper, true, set,
> +				 nouuid);
>  }
>  
>  /* readdir.c */
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index b429c80879ee..2fd2cc515ad2 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -13,7 +13,7 @@ struct ovl_config {
>  	bool redirect_dir;
>  	bool redirect_follow;
>  	const char *redirect_mode;
> -	bool index;
> +	int index;
>  	bool nfs_export;
>  	int xino;
>  	bool metacopy;
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 4b38141c2985..d1ed580f24b7 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -38,10 +38,12 @@ module_param_named(redirect_always_follow, ovl_redirect_always_follow,
>  MODULE_PARM_DESC(redirect_always_follow,
>  		 "Follow redirects even if redirect_dir feature is turned off");
>  
> -static bool ovl_index_def = IS_ENABLED(CONFIG_OVERLAY_FS_INDEX);
> -module_param_named(index, ovl_index_def, bool, 0644);
> +static int ovl_index_def = IS_ENABLED(CONFIG_OVERLAY_FS_INDEX_NOUUID) ?
> +			   OVL_INDEX_NOUUID :
> +			   IS_ENABLED(CONFIG_OVERLAY_FS_INDEX);
> +module_param_named(index, ovl_index_def, int, 0644);
>  MODULE_PARM_DESC(index,
> -		 "Default to on or off for the inodes index feature");
> +		 "Default to on, off or nouuid for the inodes index feature");
>  
>  static bool ovl_nfs_export_def = IS_ENABLED(CONFIG_OVERLAY_FS_NFS_EXPORT);
>  module_param_named(nfs_export, ovl_nfs_export_def, bool, 0644);
> @@ -352,8 +354,18 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>  		seq_puts(m, ",default_permissions");
>  	if (strcmp(ofs->config.redirect_mode, ovl_redirect_mode_def()) != 0)
>  		seq_printf(m, ",redirect_dir=%s", ofs->config.redirect_mode);
> -	if (ofs->config.index != ovl_index_def)
> -		seq_printf(m, ",index=%s", ofs->config.index ? "on" : "off");
> +	if (ofs->config.index != ovl_index_def) {
> +		switch (ofs->config.index) {
> +		case OVL_INDEX_OFF:
> +			seq_puts(m, ",index=off");
> +			break;
> +		case OVL_INDEX_NOUUID:
> +			seq_puts(m, ",index=nouuid");
> +			break;
> +		default:
> +			seq_puts(m, ",index=on");
> +		}
> +	}
>  	if (ofs->config.nfs_export != ovl_nfs_export_def)
>  		seq_printf(m, ",nfs_export=%s", ofs->config.nfs_export ?
>  						"on" : "off");
> @@ -404,6 +416,7 @@ enum {
>  	OPT_REDIRECT_DIR,
>  	OPT_INDEX_ON,
>  	OPT_INDEX_OFF,
> +	OPT_INDEX_NOUUID,
>  	OPT_NFS_EXPORT_ON,
>  	OPT_NFS_EXPORT_OFF,
>  	OPT_XINO_ON,
> @@ -422,6 +435,7 @@ static const match_table_t ovl_tokens = {
>  	{OPT_REDIRECT_DIR,		"redirect_dir=%s"},
>  	{OPT_INDEX_ON,			"index=on"},
>  	{OPT_INDEX_OFF,			"index=off"},
> +	{OPT_INDEX_NOUUID,		"index=nouuid"},
>  	{OPT_NFS_EXPORT_ON,		"nfs_export=on"},
>  	{OPT_NFS_EXPORT_OFF,		"nfs_export=off"},
>  	{OPT_XINO_ON,			"xino=on"},
> @@ -532,12 +546,17 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>  			break;
>  
>  		case OPT_INDEX_ON:
> -			config->index = true;
> +			config->index = OVL_INDEX_ON;
>  			index_opt = true;
>  			break;
>  
>  		case OPT_INDEX_OFF:
> -			config->index = false;
> +			config->index = OVL_INDEX_OFF;
> +			index_opt = true;
> +			break;
> +
> +		case OPT_INDEX_NOUUID:
> +			config->index = OVL_INDEX_NOUUID;
>  			index_opt = true;
>  			break;
>  
> @@ -592,7 +611,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>  			pr_info("option \"index=on\" is useless in a non-upper mount, ignore\n");
>  			index_opt = false;
>  		}
> -		config->index = false;
> +		config->index = OVL_INDEX_OFF;
>  	}
>  
>  	err = ovl_parse_redirect_mode(config, config->redirect_mode);
> @@ -644,7 +663,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>  			config->nfs_export = false;
>  		} else {
>  			/* Automatically enable index otherwise. */
> -			config->index = true;
> +			config->index = OVL_INDEX_ON;
>  		}
>  	}
>  
> @@ -859,7 +878,7 @@ static int ovl_lower_dir(const char *name, struct path *path,
>  	fh_type = ovl_can_decode_fh(path->dentry->d_sb);
>  	if ((ofs->config.nfs_export ||
>  	     (ofs->config.index && ofs->config.upperdir)) && !fh_type) {
> -		ofs->config.index = false;
> +		ofs->config.index = OVL_INDEX_OFF;
>  		ofs->config.nfs_export = false;
>  		pr_warn("fs on '%s' does not support file handles, falling back to index=off,nfs_export=off.\n",
>  			name);
> @@ -1259,7 +1278,7 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
>  	err = ovl_do_setxattr(ofs->workdir, OVL_XATTR_OPAQUE, "0", 1, 0);
>  	if (err) {
>  		ofs->noxattr = true;
> -		ofs->config.index = false;
> +		ofs->config.index = OVL_INDEX_OFF;
>  		ofs->config.metacopy = false;
>  		pr_warn("upper fs does not support xattr, falling back to index=off and metacopy=off.\n");
>  		err = 0;
> @@ -1282,7 +1301,7 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
>  	/* Check if upper/work fs supports file handles */
>  	fh_type = ovl_can_decode_fh(ofs->workdir->d_sb);
>  	if (ofs->config.index && !fh_type) {
> -		ofs->config.index = false;
> +		ofs->config.index = OVL_INDEX_OFF;
>  		pr_warn("upper fs does not support file handles, falling back to index=off.\n");
>  	}
>  
> @@ -1348,6 +1367,7 @@ static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
>  {
>  	struct vfsmount *mnt = ovl_upper_mnt(ofs);
>  	int err;
> +	bool nouuid = ofs->config.index == OVL_INDEX_NOUUID;
>  
>  	err = mnt_want_write(mnt);
>  	if (err)
> @@ -1355,7 +1375,7 @@ static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
>  
>  	/* Verify lower root is upper root origin */
>  	err = ovl_verify_origin(upperpath->dentry, oe->lowerstack[0].dentry,
> -				true);
> +				true, nouuid);
>  	if (err) {
>  		pr_err("failed to verify upper root origin\n");
>  		goto out;
> @@ -1385,11 +1405,13 @@ static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
>  		 */
>  		if (ovl_check_origin_xattr(ofs->indexdir)) {
>  			err = ovl_verify_set_fh(ofs->indexdir, OVL_XATTR_ORIGIN,
> -						upperpath->dentry, true, false);
> +						upperpath->dentry, true, false,
> +						nouuid);
>  			if (err)
>  				pr_err("failed to verify index dir 'origin' xattr\n");
>  		}
> -		err = ovl_verify_upper(ofs->indexdir, upperpath->dentry, true);
> +		err = ovl_verify_upper(ofs->indexdir, upperpath->dentry, true,
> +				       nouuid);
>  		if (err)
>  			pr_err("failed to verify index dir 'upper' xattr\n");
>  
> @@ -1458,7 +1480,7 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
>  	if (!ovl_lower_uuid_ok(ofs, &sb->s_uuid)) {
>  		bad_uuid = true;
>  		if (ofs->config.index || ofs->config.nfs_export) {
> -			ofs->config.index = false;
> +			ofs->config.index = OVL_INDEX_OFF;
>  			ofs->config.nfs_export = false;
>  			pr_warn("%s uuid detected in lower fs '%pd2', falling back to index=off,nfs_export=off.\n",
>  				uuid_is_null(&sb->s_uuid) ? "null" :
> @@ -1889,9 +1911,14 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>  	if (err)
>  		goto out_free_oe;
>  
> +	if (ofs->config.index == OVL_INDEX_NOUUID && ofs->numfs > 1) {
> +		pr_warn("The index=nouuid requires a single fs for lower and upper, falling back to index=on.\n");
> +		ofs->config.index = OVL_INDEX_ON;
> +	}
> +
>  	/* Show index=off in /proc/mounts for forced r/o mount */
>  	if (!ofs->indexdir) {
> -		ofs->config.index = false;
> +		ofs->config.index = OVL_INDEX_OFF;
>  		if (ovl_upper_mnt(ofs) && ofs->config.nfs_export) {
>  			pr_warn("NFS export requires an index dir, falling back to nfs_export=off.\n");
>  			ofs->config.nfs_export = false;
> -- 
> 2.26.2
> 

