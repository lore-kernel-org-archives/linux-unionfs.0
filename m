Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:39033 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbeICMLM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 3 Sep 2018 08:11:12 -0400
Received: by mail-oi0-f68.google.com with SMTP id c190-v6so32087034oig.6
        for <linux-unionfs@vger.kernel.org>; Mon, 03 Sep 2018 00:52:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180831055112.GA11179@lkp-sb04>
References: <201808311344.jRhJ1LUF%fengguang.wu@intel.com> <20180831055112.GA11179@lkp-sb04>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Mon, 3 Sep 2018 09:52:14 +0200
Message-ID: <CAOssrKekpbs4Aa0huh79vDvnxdefZzxxHZQw+thduvRW1+4hWw@mail.gmail.com>
Subject: Re: [RFC PATCH miklos-vfs] ovl: ovl_fadvise() can be static
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Amir Goldstein <amir73il@gmail.com>, kbuild-all@01.org, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Aug 31, 2018 at 7:51 AM, kbuild test robot
<fengguang.wu@intel.com> wrote:
>
> Fixes: 53e35e7602b1 ("ovl: add ovl_fadvise()")
> Signed-off-by: kbuild test robot <fengguang.wu@intel.com>
> ---
>  file.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 89f9e97..aeaefd2 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -331,7 +331,7 @@ static long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len
>         return ret;
>  }
>
> -int ovl_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
> +static int ovl_fadvise(struct file *file, loff_t offset, loff_t len, int advice)

Thanks, folded into overlayfs-next.

Miklos
