From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v4 4/5] fsck.overlay: add merge and redirect subdir count
Date: Thu, 18 Jan 2018 09:13:34 +0200
Message-ID: <CAOQ4uxjcFGAGC-CRpQ8Stu1daXtHi8vkn701YSPNymVe2qfOUw@mail.gmail.com>
References: <20180118035056.17358-1-yi.zhang@huawei.com> <20180118035056.17358-5-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20180118035056.17358-5-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com, "zhangyi (F)" <yizhang089@gmail.com>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Jan 18, 2018 at 5:50 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Count merge and redirect subdir in a directory in scan pass two,
> will be use for impure xattr check.
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
>  check.c | 33 +++++++++++++++++++++++++++++++++
>  lib.c   |  4 ++++
>  lib.h   |  3 +++
>  3 files changed, 40 insertions(+)
>
> diff --git a/check.c b/check.c
> index e46aea7..f0b3ff4 100644
> --- a/check.c
> +++ b/check.c
> @@ -721,6 +721,38 @@ static int ovl_count_origin(struct scan_ctx *sctx)
>         return 0;
>  }
>
> +static inline bool ovl_is_merge(int dirfd, const char *pathname,
> +                               int dirtype, int stack)
> +{
> +       struct ovl_lookup_data od = {0};
> +
> +       if (ovl_is_opaque(dirfd, pathname))
> +               return false;
> +       if (ovl_lookup_lower(pathname, dirtype, stack, &od))
> +               return false;
> +       if (od.exist && is_dir(&od.st))
> +               return true;
> +
> +       return false;
> +}
> +
> +/* Count merge dir and redirect dir in a specified directory */
> +static int ovl_count_unreal(struct scan_ctx *sctx)

I am amused by this name :)
FYI, the legacy term used for a directory that is NOT a merge directory
is "pure", such as "pure upper" or "pure lower".

Confusingly, the "impure dir" term is not exactly the opposite
of the legacy "pure dir" term, but really is a shortcut for
"dir that contains non pure entries".
We could have called the xattr "impurities", but we (I) didn't.

So, basically, merge and redirect dir are "impurities",
which make the parent dir "impure".

See for example:
void ovl_dentry_version_inc(struct dentry *dentry, bool impurity)

'impurity' refers to merge/redirect children of parent,
kind of like this scan function, so I propose either:
ovl_count_impurities()
OR
ovl_count_impure()

I realize that there is overlap in the term with ovl_count_origin(),
which also counts impurities, but still..

> +{
> +       struct scan_dir_data *parent = sctx->dirdata;
> +
> +       if (!parent)
> +               return 0;
> +
> +       if (ovl_is_redirect(sctx->dirfd, sctx->pathname))
> +               parent->redirects++;
> +       if (!ovl_is_origin(sctx->dirfd, sctx->pathname) &&
> +           ovl_is_merge(sctx->dirfd, sctx->pathname,
> +                        sctx->dirtype, sctx->stack))
> +               parent->mergedirs++;
> +
> +       return 0;
> +}
>
>  /*
>   * Scan Pass:
> @@ -745,6 +777,7 @@ static struct scan_operations ovl_scan_ops[OVL_SCAN_PASS][2] = {
>                 [OVL_UPPER] = {
>                         .whiteout = ovl_check_whiteout,
>                         .origin = ovl_count_origin,
> +                       .unreal = ovl_count_unreal,
>                 },
>                 [OVL_LOWER] = {
>                         .whiteout = ovl_check_whiteout,
> diff --git a/lib.c b/lib.c
> index dff3426..03bd8eb 100644
> --- a/lib.c
> +++ b/lib.c
> @@ -244,6 +244,10 @@ int scan_dir(struct scan_ctx *sctx, struct scan_operations *sop)
>                         if (ret)
>                                 goto out;
>
> +                       ret = scan_check_entry(sop->unreal, sctx);
> +                       if (ret)
> +                               goto out;
> +
>                         /* Save current dir data and create new one for subdir */
>                         ftsent->fts_pointer = sctx->dirdata;
>                         sctx->dirdata = smalloc(sizeof(struct scan_dir_data));
> diff --git a/lib.h b/lib.h
> index 450a4cb..60e620e 100644
> --- a/lib.h
> +++ b/lib.h
> @@ -60,6 +60,8 @@
>  /* Directories scan data structs */
>  struct scan_dir_data {
>         int origins;            /* origin number in this directory (no iterate) */
> +       int mergedirs;          /* merge subdir number in this directory (no iterate) */
> +       int redirects;          /* redirect subdir number in this directory (no iterate) */
>  };
>
>  struct scan_ctx {
> @@ -86,6 +88,7 @@ struct scan_operations {
>         int (*whiteout)(struct scan_ctx *);
>         int (*redirect)(struct scan_ctx *);
>         int (*origin)(struct scan_ctx *);
> +       int (*unreal)(struct scan_ctx *);
>  };
>
>  static inline void set_inconsistency(int *status)
> --
> 2.9.5
>
