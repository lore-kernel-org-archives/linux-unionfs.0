Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180306040223.2970-1-yangerkun@huawei.com>
References: <20180306040223.2970-1-yangerkun@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 6 Mar 2018 08:44:59 +0200
Message-ID: <CAOQ4uxi2Ts+=4NhOyTCpoBxsW1_tAuVS3s_reNz0Nuba+AEDUA@mail.gmail.com>
Subject: Re: [PATCH] overlay: ovl_get_inode should treat file and dir as same
 while no upper_mnt
Content-Type: text/plain; charset="UTF-8"
To: yangerkun <yangerkun@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, "zhangyi (F)" <yi.zhang@huawei.com>, Miao Xie <miaoxie@huawei.com>, zhaohongjiang@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Mar 6, 2018 at 6:02 AM, yangerkun <yangerkun@huawei.com> wrote:
>
> When there is no upper_mnt, lower multi hardlink should not construct
> multi inode for overlay since there won't copyup.
>

This doesn't really describe a problem.
AFAIK, the only problem has to do with fsnotify and the fix is already in
overlayfs-next:
764baba80168 ovl: hash non-dir by lower inode for fsnotify

Miklos,

Are you planning to send a pull request soon?

Thanks,
Amir.

> Signed-off-by: yangerkun <yangerkun@huawei.com>
> ---
>  fs/overlayfs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index fcd97b783fa1..fb0a8eff1d8c 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -696,7 +696,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
>          * Hash non-indexed dir by upper inode for NFS export.
>          */
>         is_dir = S_ISDIR(realinode->i_mode);
> -       if (is_dir && (indexed || !sb->s_export_op || !ofs->upper_mnt))
> +       if (!ofs->upper_mnt || (is_dir && !sb->s_export_op))
>                 origin = lowerdentry;
>
>         if (upperdentry || origin) {
> --
> 2.13.6
>
