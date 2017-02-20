From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH 4/9] vfs: intercept reads to overlay files
Date: Mon, 20 Feb 2017 15:47:03 +0800
Message-ID: <f50a5892-eccf-0865-96ad-337114a6944e@huawei.com>
References: <1487347778-18596-1-git-send-email-mszeredi@redhat.com>
 <1487347778-18596-5-git-send-email-mszeredi@redhat.com>
 <D39694FF47DA2A43B120BF3DF6163E7A10CD2335@DGGEMA504-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <D39694FF47DA2A43B120BF3DF6163E7A10CD2335@DGGEMA504-MBX.china.huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mszeredi@redhat.com
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, miaoxie@huawei.com
List-Id: linux-unionfs@vger.kernel.org

On 2017/2/18 00:10, Miklos Szeredi wrote:
> diff --git a/fs/open.c b/fs/open.c
> index 9921f70bc5ca..4916ccff29f5 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -762,6 +762,8 @@ static int do_dentry_open(struct file *f,
>  	if ((f->f_mode & FMODE_WRITE) &&
>  	     likely(f->f_op->write || f->f_op->write_iter))
>  		f->f_mode |= FMODE_CAN_WRITE;
> +	if (unlikely(d_inode(f->f_path.dentry) != inode))
> +		f->f_mode |= FMODE_OVERLAY;

Can we just add flag to the "readonly && not copied" file, not all overlayfs files?
Beacuse we just want to check the ro file before copied-up.

>  	f->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
>  
> diff --git a/fs/overlay_util.c b/fs/overlay_util.c new file mode 100644 index 000000000000..0daff19bad0b
> --- /dev/null
> +++ b/fs/overlay_util.c
> @@ -0,0 +1,39 @@
> +/*
> + * Copyright (C) 2017 Red Hat, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify 
> +it
> + * under the terms of the GNU General Public License version 2 as 
> +published by
> + * the Free Software Foundation.
> + */
> +#if IS_ENABLED(CONFIG_OVERLAY_FS)
> +
> +#include <linux/overlay_util.h>
> +#include <linux/fs.h>
> +#include <linux/file.h>
> +#include "internal.h"
> +
> +static bool overlay_file_consistent(struct file *file) {
> +	return d_real_inode(file->f_path.dentry) == file_inode(file); }
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
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(overlay_read_iter);

Can we try to replace the old file with the new file, and then clear the f_mode flag we added?
If so, we can avoid opening file for each reading call and avoid copied file consistency check.

Thanks.

zhangyi
