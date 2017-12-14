From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 08/18] fsck.overlay: fix spelling mistakes
Date: Thu, 14 Dec 2017 11:13:24 +0200
Message-ID: <CAOQ4uxiS-c5p96GbDMx=gT5HPwVi4dLamNCQMZzUv+jP5YEYtQ@mail.gmail.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com> <20171214064747.20999-9-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20171214064747.20999-9-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Miao Xie <miaoxie@huawei.com>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Dec 14, 2017 at 8:47 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

Did you intend to send this patch for review??
You should rebase and squash changes like these even when not posting
for a brand new repository.

> ---
>  check.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
>  mode change 100644 => 100755 check.c
>
> diff --git a/check.c b/check.c
> old mode 100644
> new mode 100755
> index 1d008cd..b26638e
> --- a/check.c
> +++ b/check.c
> @@ -36,9 +36,9 @@ struct ovl_redirect_entry {
>
>         char origin[PATH_MAX];  /* origin directory path */
>
> -       char path[PATH_MAX];    /* redirect directory */
> -       int dirtype;            /* OVL_UPPER or OVL_LOWER */
> -       int dirnum;             /* only valid when dirtype==OVL_LOWER */
> +       char path[PATH_MAX];    /* redirect directory path */
> +       int dirtype;            /* redirect directory layer type: OVL_UPPER or OVL_LOWER */
> +       int dirnum;             /* redirect directory layer num (only valid in OVL_LOWER) */
>  };
>
>  /* Whiteout */
> @@ -307,14 +307,15 @@ static void ovl_redirect_entry_add(const char *path, int dirtype,
>                 for (last = redirect_list; last->next; last = last->next);
>                 last->next = new;
>         }
> -       new->next = NULL;
> +
>         new->dirtype = dirtype;
>         new->dirnum = dirnum;
>         strncpy(new->origin, origin, sizeof(new->origin));
>         strncpy(new->path, path, sizeof(new->path));
> +       new->next = NULL;
>  }
>
> -static bool vol_redirect_entry_find(const char *origin, int dirtype,
> +static bool ovl_redirect_entry_find(const char *origin, int dirtype,
>                                     int dirnum, char **founded)
>  {
>         struct ovl_redirect_entry *entry;
> @@ -342,7 +343,7 @@ static bool vol_redirect_entry_find(const char *origin, int dirtype,
>         return false;
>  }
>
> -static void vol_redirect_free(void)
> +static void ovl_redirect_free(void)
>  {
>         struct ovl_redirect_entry *entry;
>
> @@ -394,10 +395,10 @@ static int ovl_check_redirect(struct scan_ctx *sctx)
>                 char *tmp;
>
>                 /* Check duplicate in same layer */
> -               if (vol_redirect_entry_find(chk.path, sctx->dirtype,
> +               if (ovl_redirect_entry_find(chk.path, sctx->dirtype,
>                                             sctx->num, &tmp)) {
>                         print_info("Duplicate redirect directories found:\n");
> -                       print_info("origin:%s current:%s latest:%s\n",
> +                       print_info("origin:%s current:%s last:%s\n",
>                                    chk.path, pathname, tmp);
>
>                         set_st_inconsistency(&status);
> @@ -448,7 +449,7 @@ static struct scan_operations ovl_scan_ops = {
>  static void ovl_scan_clean(void)
>  {
>         /* Clean redirect entry record */
> -       vol_redirect_free();
> +       ovl_redirect_free();
>  }
>
>  /* Scan upperdir and each lowerdirs, check and fix inconsistency */
> --
> 2.9.5
>
