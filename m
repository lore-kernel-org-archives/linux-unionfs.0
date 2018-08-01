Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180731093727.26855-2-yi.zhang@huawei.com>
References: <20180731093727.26855-1-yi.zhang@huawei.com> <20180731093727.26855-2-yi.zhang@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 1 Aug 2018 09:48:03 +0300
Message-ID: <CAOQ4uxiCh9RvVQLJog-KuAmSQTRt7YMiQv8tCv_77R_9vFN1Qg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/9] ovl: store ovl upper root path in ovl_fs
Content-Type: text/plain; charset="UTF-8"
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Jul 31, 2018 at 12:37 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Store upper layer's ovl_layer structure and root upper dentry into
> ovl_fs sturcture for the upcoming "feature set" feature. "feature set"
> feature will read upper layer's feature from upper root dentry and save
> feature bit mask into upper layer's ovl_layer structure.
>
> This patch relpace ->upper_mnt to ->upper_layer and add a helper func
> ovl_upper_mnt() to get ->upper_mnt easily.
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---

Looks good.
One minor fix.

> @@ -989,7 +991,14 @@ static int ovl_get_upper(struct ovl_fs *ofs, struct path *upperpath)
>
>         /* Don't inherit atime flags */
>         upper_mnt->mnt_flags &= ~(MNT_NOATIME | MNT_NODIRATIME | MNT_RELATIME);
> -       ofs->upper_mnt = upper_mnt;
> +
> +       err = -ENOMEM;
> +       ofs->upper_layer = kzalloc(sizeof(struct ovl_layer), GFP_KERNEL);
> +       if (ofs->upper_layer == NULL)
> +               goto out;
> +
> +       ofs->upper_layer->mnt = upper_mnt;
> +       ofs->upperdir = dget(upperpath->dentry);
>         err = 0;
>  out:

You need to dput(upper_mnt) in case kzalloc fails. Probably better
to zalloc into local upper_layer var before clone_private_mount(),
kree(upper_layer) on goto out and return 0 instead of fallthough
to out: label on success.

Thanks,
Amir.
