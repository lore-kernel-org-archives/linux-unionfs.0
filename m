Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57766 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbfDCUqN (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 Apr 2019 16:46:13 -0400
Date: Wed, 3 Apr 2019 16:46:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] ovl: detect overlapping layers
Message-ID: <20190403204612.GC19929@redhat.com>
References: <20190402193155.27555-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190402193155.27555-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Apr 02, 2019 at 10:31:55PM +0300, Amir Goldstein wrote:
[..]
>  /*
>   * Does overlay inode need to be hashed by lower inode?
>   */
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index efd372312ef1..badf039267a2 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -18,6 +18,7 @@
>  #include "overlayfs.h"
>  
>  struct ovl_lookup_data {
> +	struct super_block *sb;
>  	struct qstr name;
>  	bool is_dir;
>  	bool opaque;
> @@ -244,6 +245,12 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
>  		if (!d->metacopy || d->last)
>  			goto out;
>  	} else {
> +		if (ovl_lookup_trap_inode(d->sb, this)) {
> +			/* Caught in a trap of overlapping layers */
> +			err = -ELOOP;
> +			goto out_err;
> +		}
> +

Hi Amir,

This idea of putting dummy inodes in overlay inode cache hashed by inode
pointer of root inode of underlying layers seems very clever. Cost
of checking overlapping layer also seems to be O(N) and that's good.

So if we want to detect this case of overlapping layers after the mount,
then we have to pay the cost of this trap inode lookup for every dentry
found in upper/lower layer

[..]
> +static int ovl_setup_trap(struct super_block *sb, struct dentry *dir,
> +			  struct inode **ptrap, const char *name)
> +{
> +	struct inode *trap;
> +	int err;
> +
> +	trap = ovl_get_trap_inode(sb, dir);
> +	err = PTR_ERR(trap);
> +	if (IS_ERR(trap)) {
> +		pr_err("overlayfs: conflicting %s path (%i)\n", name, err);
> +		return err;
> +	}
> +

ovl_get_trap_inode() can fail for other reasons like -ENOMEM. Should we
warn about conflicting path only on -EEXIST.

[..]
>  static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>  {
>  	struct path upperpath = { };
> @@ -1457,17 +1552,20 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>  	if (ofs->config.xino != OVL_XINO_OFF)
>  		ofs->xino_bits = BITS_PER_LONG - 32;
>  
> +	/* alloc/destroy_inode needed for setting up traps in inode cache */
> +	sb->s_op = &ovl_super_operations;
> +

Passing super block pointer to routines outside overlay before sb
initializaiton is complete, is it safe?

Thanks
Vivek
