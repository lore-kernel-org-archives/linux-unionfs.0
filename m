From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 4/9] vfs: intercept reads to overlay files
Date: Sun, 19 Feb 2017 09:05:56 +0000
Message-ID: <20170219090545.GK29622@ZenIV.linux.org.uk>
References: <1487347778-18596-1-git-send-email-mszeredi@redhat.com>
 <1487347778-18596-5-git-send-email-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:59768 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750801AbdBSJGX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 19 Feb 2017 04:06:23 -0500
Content-Disposition: inline
In-Reply-To: <1487347778-18596-5-git-send-email-mszeredi@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Feb 17, 2017 at 05:09:33PM +0100, Miklos Szeredi wrote:
> ...in order to handle the corner case when the file is copyied up after
> being opened read-only.

> --- /dev/null
> +++ b/fs/overlay_util.c
> @@ -0,0 +1,39 @@
> +/*
> + * Copyright (C) 2017 Red Hat, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + */
> +#if IS_ENABLED(CONFIG_OVERLAY_FS)

This is crap - it should be handled in fs/Makefile, not with IS_ENABLED.

> +#include <linux/overlay_util.h>
> +#include <linux/fs.h>
> +#include <linux/file.h>
> +#include "internal.h"
> +
> +static bool overlay_file_consistent(struct file *file)
> +{
> +	return d_real_inode(file->f_path.dentry) == file_inode(file);
> +}
> +
> +ssize_t overlay_read_iter(struct file *file, struct kiocb *kio,
> +			  struct iov_iter *iter)
> +{
> +	ssize_t ret;
> +
> +	if (likely(overlay_file_consistent(file)))
> +		return file->f_op->read_iter(kio, iter);
> +
> +	file = filp_clone_open(file);
> +	if (IS_ERR(file))
> +		return PTR_ERR(file);
> +
> +	ret = vfs_iter_read(file, iter, &kio->ki_pos);
> +	fput(file);

You do realize that a bunch of such calls will breed arseloads of struct file,
right?  Freeing is delayed...

> +static inline bool is_overlay_file(struct file *file)
> +{
> +	return IS_ENABLED(CONFIG_OVERLAY_FS) && file->f_mode & FMODE_OVERLAY;
> +}
> +
>  static inline ssize_t call_read_iter(struct file *file, struct kiocb *kio,
>  				     struct iov_iter *iter)
>  {
> +	if (unlikely(is_overlay_file(file)))
> +		return overlay_read_iter(file, kio, iter);
> +
>  	return file->f_op->read_iter(kio, iter);
>  }

1) that IS_ENABLED is fairly pointless and it's not obvious that nobody
else will use that flag

2) what that check should include is overlay_file_consistent(), with
no method call in overlay_read_iter().

3) anything that does a plenty of calls of kernel_read() is going to be
very unpleasantly surprised by the effects of that thing.
