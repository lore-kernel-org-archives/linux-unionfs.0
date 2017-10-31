From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 2/7] ovl: no direct iteration for dir with copy up origin
Date: Tue, 31 Oct 2017 14:08:28 +0100
Message-ID: <CAJfpegs0T-PCwQUYCN6Y4nAQw5d2gqu=AWPLoRi0tCTDM32bYg@mail.gmail.com>
References: <1508253833-9866-1-git-send-email-amir73il@gmail.com> <1508253833-9866-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:54989 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751050AbdJaNI3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Oct 2017 09:08:29 -0400
Received: by mail-wr0-f196.google.com with SMTP id o44so15864492wrf.11
        for <linux-unionfs@vger.kernel.org>; Tue, 31 Oct 2017 06:08:29 -0700 (PDT)
In-Reply-To: <1508253833-9866-3-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Tue, Oct 17, 2017 at 5:23 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> If a non-merge dir in an overlay mount has an overlay.origin xattr, it
> means it was once an upper merge dir, which may contain whiteouts and
> then the lower dir was removed under it.
>
> Do not iterate real dir directly in this case to avoid exposing whiteouts.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/readdir.c | 29 +++++++++++++++++++++++++----
>  1 file changed, 25 insertions(+), 4 deletions(-)
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 55623b6635b6..ba44546ad1ed 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -319,21 +319,42 @@ static inline int ovl_dir_read(struct path *realpath,
>         return err;
>  }
>
> +/* Can we iterate real dir directly? */
> +static bool ovl_dir_is_real(struct dentry *dir)
> +{
> +       struct path realpath;
> +       enum ovl_path_type type = ovl_path_real(dir, &realpath);
> +
> +       if (OVL_TYPE_MERGE(type))
> +               return false;
> +
> +       /*
> +        * Non-merge dir may contain whiteouts from a time it was a merge
> +        * upper, before lower dir was removed under it and possibly before
> +        * it was rotated from upper to lower layer.
> +        */
> +       return !ovl_check_origin_xattr(realpath.dentry);

This patch is okay, but I started wondering if
ovl_check_origin_xattr() should cache the "has origin" bit for
directories.   Can be a followup patch, or we can leave it later.
Just thought I'd mention it as something to think about.

Thanks,
Miklos
