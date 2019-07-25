From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] fs: overlayfs: Fix a possible null-pointer dereference in ovl_free_fs()
Date: Thu, 25 Jul 2019 16:03:54 +0300
Message-ID: <CAOQ4uxg1f3rgnc4sitF82FMftROHkubk+3s9=v1Bf47m-zVYBw@mail.gmail.com>
References: <20190725085732.15674-1-baijiaju1990@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190725085732.15674-1-baijiaju1990@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Jul 25, 2019 at 3:48 PM Jia-Ju Bai <baijiaju1990@gmail.com> wrote:
>
> In ovl_fill_super(), there is an if statement on line 1607 to check
> whether ofs->upper_mnt is NULL:
>     if (!ofs->upper_mnt)
>
> When ofs->upper_mnt is NULL and d_make_root() on line 1654 fails,
> ovl_free_fs() on line 1683 is executed.
> In ovl_free_fs(), ofs->upper_mnt is used on line 224:
>     ovl_inuse_unlock(ofs->upper_mnt->mnt_root);
>
> Thus, a possible null-pointer dereference may occur.
>
> To fix this bug, ofs->upper_mnt is checked before being used in
> ovl_free_fs().
>
> This bug is found by a static analysis tool STCheck written by us.
>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  fs/overlayfs/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index b368e2e102fa..1d7c3d280834 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -220,7 +220,7 @@ static void ovl_free_fs(struct ovl_fs *ofs)
>         if (ofs->workdir_locked)
>                 ovl_inuse_unlock(ofs->workbasedir);
>         dput(ofs->workbasedir);
> -       if (ofs->upperdir_locked)
> +       if (ofs->upperdir_locked && ofs->upper_mnt)
>                 ovl_inuse_unlock(ofs->upper_mnt->mnt_root);
>         mntput(ofs->upper_mnt);
>         for (i = 0; i < ofs->numlower; i++) {
> --

Can you teach STCheck to know that if upperdir_locked is only set this way:
        ofs->upper_mnt = upper_mnt;

        err = -EBUSY;
        if (ovl_inuse_trylock(ofs->upper_mnt->mnt_root)) {
                ofs->upperdir_locked = true;

Then upperdir_locked implies ofs->upper_mnt != NULL?

Whether or not this patch should be applied is not my call,
but the title "possible null-pointer dereference" is certainly not true.

Thanks,
Amir.
