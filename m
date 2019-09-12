From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH V2] ovl: Fix dereferencing possible ERR_PTR()
Date: Thu, 12 Sep 2019 09:01:48 +0300
Message-ID: <CAOQ4uxjNK9BQxmNqbx8Hix0yd5op-i17BiqvOmmEmr=3bHtm_A@mail.gmail.com>
References: <1568265511-1622-1-git-send-email-dingxiang@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1568265511-1622-1-git-send-email-dingxiang@cmss.chinamobile.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ding Xiang <dingxiang@cmss.chinamobile.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Sep 12, 2019 at 8:24 AM Ding Xiang
<dingxiang@cmss.chinamobile.com> wrote:
>
> if ovl_encode_real_fh() fails, no memory was allocated
> and the error in the error-valued pointer should be returned.
>
> V1->V2: fix SHA1 length problem
>
> Fixes: 9b6faee07470 ("ovl: check ERR_PTR() return value from ovl_encode_fh()")
> Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
> ---
>  fs/overlayfs/export.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index cb8ec1f..50ade19 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -229,7 +229,7 @@ static int ovl_d_to_fh(struct dentry *dentry, char *buf, int buflen)
>                                 ovl_dentry_upper(dentry), !enc_lower);
>         err = PTR_ERR(fh);
>         if (IS_ERR(fh))
> -               goto fail;
> +               return err;
>

Please fix the code in warning message instead of skipping the warning.

Thanks,
Amir.
