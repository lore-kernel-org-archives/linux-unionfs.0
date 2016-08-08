From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: whiteout of lower dir should't dispaly in merge dir.
Date: Mon, 8 Aug 2016 11:28:11 +0200
Message-ID: <CAJfpegu1tT0ac=t85SurZ1+-9ZH9PzNp6RdVd2fJvMGkGeKrGg@mail.gmail.com>
References: <1470647922-23721-1-git-send-email-zhangaihua1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470647922-23721-1-git-send-email-zhangaihua1@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhang AiHua <zhangaihua1@huawei.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Aug 8, 2016 at 11:18 AM,  <zhangaihua1@huawei.com> wrote:
> From: Aihua Zhang <zhangaihua1@huawei.com>
>
> mount -t overlay overlay -olowerdir=/lower,upperdir=/upper,workdir=/workdir  /merge
> ls /lower/test_dir
> whiteout
>
> ls /merge/test_dir
> whiteout   ------should't display here
>
> this patch fixed it.

Your patch makes the performance of readdir() for the common case
worse for no good reason.  There's no way a whiteout can end up on the
lowest layer, so there's no point in trying to filter one out.

NACK.

Thanks,
Miklos


>
> Signed-off-by: Aihua Zhang <zhangaihua1@huawei.com>
> ---
>  fs/overlayfs/readdir.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index cf37fc7..21cd5a4 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -362,7 +362,7 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
>         if (!ctx->pos)
>                 ovl_dir_reset(file);
>
> -       if (od->is_real)
> +       if ((od->is_real) && (od->is_upper))
>                 return iterate_dir(od->realfile, ctx);
>
>         if (!od->cache) {
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
