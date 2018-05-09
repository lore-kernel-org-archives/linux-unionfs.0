Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:41898 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753107AbeEIFrC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 9 May 2018 01:47:02 -0400
MIME-Version: 1.0
In-Reply-To: <20180508212405.15297-4-rgoldwyn@suse.de>
References: <20180508212405.15297-1-rgoldwyn@suse.de> <20180508212405.15297-4-rgoldwyn@suse.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 9 May 2018 08:47:01 +0300
Message-ID: <CAOQ4uxjvpmNEWHF3-AK9XUtQk=PpLhVT_jLEV4gxFCy6H2yR1w@mail.gmail.com>
Subject: Re: [PATCH 3/4] copy_file_range: splice with holes
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Steve French <smfrench@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, May 9, 2018 at 12:24 AM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>
> copy_file_range calls do_splice_direct() if fs->clone_file_range
> or fs->copy_file_range() is not available. However, do_splice_direct()
> converts holes to zeros. Detect holes in the file_in range, and
> create them in the corresponding file_out range.
>
> If there is already data present at the offset in file_out, attempt
> to punch a hole there. If the operation is not supported, fall
> back to performing splice on the whole range.
>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

but..

> ---
>  fs/read_write.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 55 insertions(+), 5 deletions(-)
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 2c9e7a5ea806..5df9d6e8ebee 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -20,6 +20,7 @@
>  #include <linux/compat.h>
>  #include <linux/mount.h>
>  #include <linux/fs.h>
> +#include <linux/falloc.h>
>  #include "internal.h"
>
>  #include <linux/uaccess.h>
> @@ -1541,14 +1542,15 @@ COMPAT_SYSCALL_DEFINE4(sendfile64, int, out_fd, int, in_fd,
>  }
>  #endif
>
> -ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
> +static ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,

Either make it static to begin with or non static and exported to begin with.

Thanks,
Amir.
