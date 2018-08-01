Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180731093727.26855-10-yi.zhang@huawei.com>
References: <20180731093727.26855-1-yi.zhang@huawei.com> <20180731093727.26855-10-yi.zhang@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 1 Aug 2018 14:30:51 +0300
Message-ID: <CAOQ4uxgecg_TuCkQrtY7Oj-vL34Mdj-FBsMgQByaKfNWZKFkkQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 9/9] ovl: check redirect_dir feature when detect
 redirect xattr on dir
Content-Type: text/plain; charset="UTF-8"
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Jul 31, 2018 at 12:37 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> After we introduce the fsck.overlay program, we could check and fix
> the inconsistency of feature set xattr, so it's a good opportunity
> check the redirect dir feature when we detect redirect xattr on
> directory in the underlying layer. If the feature is necessary
> (OVL_FS_V2 for all layers and OVL_FS_UPPER_V2 for upper layer) but
> the redirect dir feature is missing, the feature set is inconsistent
> and fsck.overlay is required.
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
