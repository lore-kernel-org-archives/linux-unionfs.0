From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 02/17] ovl: encode pure upper file handles
Date: Thu, 18 Jan 2018 11:31:09 +0100
Message-ID: <CAJfpegvjkewOAgsvEOhdEdrTn7kEUsP612D4aKCU+ewEzsP-dw@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com> <1515086449-26563-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:34107 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755234AbeARKbL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 Jan 2018 05:31:11 -0500
Received: by mail-qt0-f193.google.com with SMTP id 33so28952416qtv.1
        for <linux-unionfs@vger.kernel.org>; Thu, 18 Jan 2018 02:31:10 -0800 (PST)
In-Reply-To: <1515086449-26563-3-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org

On Thu, Jan 4, 2018 at 6:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Encode overlay file handles as struct ovl_fh containing the file handle
> encoding of the real upper inode.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/Makefile    |  3 +-
>  fs/overlayfs/export.c    | 98 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/overlayfs/overlayfs.h |  6 +++
>  3 files changed, 106 insertions(+), 1 deletion(-)
>  create mode 100644 fs/overlayfs/export.c
>
> diff --git a/fs/overlayfs/Makefile b/fs/overlayfs/Makefile
> index 99373bbc1478..30802347a020 100644
> --- a/fs/overlayfs/Makefile
> +++ b/fs/overlayfs/Makefile
> @@ -4,4 +4,5 @@
>
>  obj-$(CONFIG_OVERLAY_FS) += overlay.o
>
> -overlay-objs := super.o namei.o util.o inode.o dir.o readdir.o copy_up.o
> +overlay-objs := super.o namei.o util.o inode.o dir.o readdir.o copy_up.o \
> +               export.o
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> new file mode 100644
> index 000000000000..58c4f5e8a67e
> --- /dev/null
> +++ b/fs/overlayfs/export.c
> @@ -0,0 +1,98 @@
> +/*
> + * Overlayfs NFS export support.
> + *
> + * Amir Goldstein <amir73il@gmail.com>
> + *
> + * Copyright (C) 2017 CTERA Networks. All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + */
> +
> +#include <linux/fs.h>
> +#include <linux/cred.h>
> +#include <linux/mount.h>
> +#include <linux/namei.h>
> +#include <linux/xattr.h>
> +#include <linux/exportfs.h>
> +#include <linux/ratelimit.h>
> +#include "overlayfs.h"
> +
> +int ovl_d_to_fh(struct dentry *dentry, char *buf, int buflen)

static ...
