From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix inconsistent d_ino for merge dir
Date: Sat, 30 Dec 2017 11:51:04 +0200
Message-ID: <CAOQ4uxjt6+UuSbWoACRsFbpstJVuRJGJgby_DqbqJfEJBk6odw@mail.gmail.com>
References: <20171230074915.33685-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:33745 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750886AbdL3JvF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 30 Dec 2017 04:51:05 -0500
Received: by mail-yw0-f193.google.com with SMTP id k80so10067216ywe.0
        for <linux-unionfs@vger.kernel.org>; Sat, 30 Dec 2017 01:51:05 -0800 (PST)
In-Reply-To: <20171230074915.33685-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com

On Sat, Dec 30, 2017 at 9:49 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Current ovl_getattr() (stat(2)) return lower's d_ino for merge
> directory (No any extended attribute) but ovl_iterate()
> (getdents(2)) return upper's d_ino.
>
> This patch correct inconsistent d_ino for this case, change to
> return lower's d_ino in ovl_iterate() for merge dir.
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
>  fs/overlayfs/readdir.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 8c98578..9548712 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -136,6 +136,11 @@ static bool ovl_calc_d_ino(struct ovl_readdir_data *rdd,
>             ovl_test_flag(OVL_IMPURE, d_inode(rdd->dentry)))
>                 return true;
>
> +       /* Recalc d_ino for all dir in merge dir (contains merge subdirs) */
> +       if (p->type == DT_DIR &&
> +           OVL_TYPE_MERGE(ovl_path_type(rdd->dentry)))

Why only subdirs and not files with origin?
This is a partial fix and I think Miklos has rejected a similar fix by Chandan
and said that this should be fixed by a future fsck.overlay (hint hint).
The inconsistency is that the directory contains origin (and merge subdir)
and is not marked "impure". That is what fsck.overlay needs to fix and then
"Recalc d_ino for for all entries if dir is impure (contains copied up entries)"
will do the right thing.

Amir.
