From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 12/23] ovl: cleanup temp index entries
Date: Tue, 9 Jan 2018 16:25:48 +0100
Message-ID: <CAJfpegtnDY2Y1-7Ap83gyZHw-bdEr6P=7dw+ehP_nA-HmZ5vKA@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com> <1515084018-25134-13-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:33248 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932814AbeAIPZu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Jan 2018 10:25:50 -0500
Received: by mail-qk0-f194.google.com with SMTP id i17so14571016qke.0
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Jan 2018 07:25:49 -0800 (PST)
In-Reply-To: <1515084018-25134-13-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Jan 4, 2018 at 5:40 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> A previous failed attempt to create or whiteout a directory index may leave
> index entries named '#%x' in the index dir.
> Cleanup those temp entries on mount instead of failing the mount.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/namei.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index e53c54ecb7cc..4987d7df1581 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -9,6 +9,7 @@
>
>  #include <linux/fs.h>
>  #include <linux/cred.h>
> +#include <linux/ctype.h>
>  #include <linux/namei.h>
>  #include <linux/xattr.h>
>  #include <linux/ratelimit.h>
> @@ -452,6 +453,24 @@ static struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index)
>         return upper.dentry;
>  }
>
> +/* Is this a leftover from create/whiteout of directory index entry? */
> +static bool ovl_is_temp_index(struct dentry *index)
> +{
> +       const char *p = index->d_name.name;
> +       int len = index->d_name.len;
> +
> +       if (!d_is_dir(index) && !ovl_is_whiteout(index))
> +               return false;
> +
> +       if (*p++ != '#' || len < 2)
> +               return false;

I don't see a point in extensive verification that it's a well formed
temp file name.   Just checking that the first character is "#" should
be enough, no?

Thanks,
Miklos
