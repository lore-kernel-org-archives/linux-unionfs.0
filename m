Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180223120106.32921-1-yangerkun@huawei.com>
References: <20180223120106.32921-1-yangerkun@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 24 Feb 2018 09:43:32 +0200
Message-ID: <CAOQ4uxj7Bg5vjoCtke=R1D3aG73rNRg_hKJofkJWk0vjfcxyMw@mail.gmail.com>
Subject: Re: [PATCH] fsck.overlay: add ovl_check_origin helper
Content-Type: text/plain; charset="UTF-8"
To: yangerkun <yangerkun@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, "zhangyi (F)" <yi.zhang@huawei.com>, Miao Xie <miaoxie@huawei.com>, zhaohongjiang@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Feb 23, 2018 at 2:01 PM, yangerkun <yangerkun@huawei.com> wrote:
> For origin xattr, use fid in ovl_fh to consume file_handle, and use
> open_by_handle_at to check validity of the origin ovl_fh. In auto mode,
> the invalid origin xattr will remove automatic.
>
> Signed-off-by: yangerkun <yangerkun@huawei.com>
> ---
>  check.c     | 135 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  lib.c       |  10 +++++
>  lib.h       |   4 +-
>  overlayfs.c |  23 +++++++++++
>  overlayfs.h |  33 +++++++++++++++
>  5 files changed, 202 insertions(+), 3 deletions(-)
>
> diff --git a/check.c b/check.c
> index e109620..50c4585 100644
> --- a/check.c
> +++ b/check.c
> @@ -24,6 +24,7 @@
>
>  #include <stdlib.h>
>  #include <stdio.h>
> +#include <stddef.h>
>  #include <string.h>
>  #include <errno.h>
>  #include <unistd.h>
> @@ -169,11 +170,42 @@ static int ovl_get_redirect(int dirfd, const char *pathname,
>         return 0;
>  }
>
> +/*
> + * Get the origin file handle with the pathname, then check the validity of member
> + * in ovl_fh.
> + */
> +static int ovl_get_fh(int dirfd, const char *pathname,
> +                     struct ovl_fh **fh, bool *invalid)
> +{
> +       char *og = NULL;
> +       ssize_t ret;
> +
> +       ret = get_xattr(dirfd, pathname, OVL_ORIGIN_XATTR, &og, NULL);
> +       if (ret <= 0)
> +               return ret;
> +
> +       ret = ovl_check_fh_len((struct ovl_fh *)og, ret);
> +       if (ret) {
> +               free(og);
> +               if (ret == -EINVAL)
> +                       *invalid = true;
> +       } else {
> +               *fh = (struct ovl_fh *)og;
> +       }
> +
> +       return 0;
> +}
> +
>  static inline int ovl_remove_redirect(int dirfd, const char *pathname)
>  {
>         return remove_xattr(dirfd, pathname, OVL_REDIRECT_XATTR);
>  }
>
> +static inline int ovl_remove_origin(int dirfd, const char *pathname)
> +{
> +       return remove_xattr(dirfd, pathname, OVL_ORIGIN_XATTR);
> +}
> +
>  static inline int ovl_create_whiteout(int dirfd, const char *pathname)
>  {
>         if (mknodat(dirfd, pathname, S_IFCHR | WHITEOUT_MOD, makedev(0, 0))) {
> @@ -758,6 +790,97 @@ out:
>  }
>
>  /*
> + * Get origin file handle stored in the xattr, check it's invalid
> + * or not. In auto-mode, invalid origin xattr will be removed directly.
> + */
> +static int ovl_check_origin(struct scan_ctx *sctx)
> +{
> +       struct ovl_fh *fh = NULL;
> +       struct file_handle *fhp = NULL;
> +       struct stat stat;
> +       bool invalid = false;
> +       int i;
> +       int ret;
> +       int fid_len;
> +       int fd;
> +
> +       /* Get origin */
> +       ret = ovl_get_fh(sctx->dirfd, sctx->pathname, &fh, &invalid);
> +       if (ret < 0)
> +               return -1;
> +
> +       /* Cannot get ovl_fh, maybe not set or unrecognized */

Should fsck issue a warning about this?
Separate the case of not set from unrecognized?
At least leave a TODO comment here of what fsck should do in those cases.

> +       if (!fh && !invalid)
> +               return 0;
> +
> +       print_debug(_("File or dir \"%s\" has origin\n"), sctx->pathname);
> +       sctx->t_origins++;
> +
> +       /* ovl_fh is invalid */
> +       if (invalid)
> +               goto remove;
> +
> +       /* Origin file in last lower dir? */
> +       if (sctx->dirtype == OVL_LOWER && sctx->stack == lower_num -1)
> +               goto remove;
> +
> +       fid_len = fh->len - offsetof(struct ovl_fh, fid);
> +       fhp = smalloc(sizeof(struct file_handle) + fid_len);
> +       fhp->handle_bytes = fh->len - offsetof(struct ovl_fh, fid);
> +       fhp->handle_type = fh->type;
> +       memcpy(fhp->f_handle, fh->fid, fid_len);
> +
> +       /* Scan lower directories to check origin xattr's validity */
> +       i = sctx->dirtype == OVL_UPPER ? 0 : sctx->stack + 1;
> +       for (; i < lower_num; i++) {
> +               fd = open_by_handle_at(lowerfd[i], fhp, O_RDONLY);
> +
> +               if (fd == -1) {
> +                       if (errno == ESTALE || errno == ENOENT)

ENOENT from open_by_handle_at() is not relevant to this code.

> +                               continue;
> +
> +                       print_err(_("Error open_by_handle_at %s:%s\n"),
> +                                   sctx->pathname, strerror(errno));
> +                       ret = -1;
> +                       goto out;
> +               }
> +
> +               ret = fstat(fd, &stat);
> +               if (ret) {
> +                       print_err(_("Cannot fstat origin file in %s of %s:%s\n"),
> +                                   lowerdir[i], sctx->pathname, strerror(errno));
> +                       goto out2;
> +               }
> +
> +               if (stat.st_mode != sctx->st->st_mode)
> +                       goto remove;
> +
> +               goto out2;
> +       }
> +
> +remove:
> +       sctx->i_origins++;
> +
> +       /* Remove origin xattr or ask user */
> +       if (!ovl_ask_action("Invalid origin xattr", sctx->pathname, sctx->dirtype,
> +                           sctx->stack, "Remove origin", 1))
> +               goto out;
> +
> +       ret = ovl_remove_origin(sctx->dirfd, sctx->pathname);
> +       if (ret)
> +               goto out;
> +
> +       sctx->i_origins--;
> +       sctx->t_origins--;
> +out2:
> +       close(fd);
> +out:
> +       free(fhp);
> +       free(fh);
> +       return ret;
> +}
> +
> +/*
>   * If a directory has origin target and redirect/merge subdirectories in it,
>   * it may contain copied up targets. In order to avoid 'd_ino' change after
>   * lower target copy-up or rename (which will create a new inode),
> @@ -870,9 +993,11 @@ static struct scan_operations ovl_scan_ops[OVL_SCAN_PASS][2] = {
>                         .whiteout = ovl_check_whiteout,
>                         .impurity = ovl_count_impurity,
>                         .impure = ovl_check_impure,
> +                       .origin = ovl_check_origin,
>                 },
>                 [OVL_LOWER] = {
>                         .whiteout = ovl_check_whiteout,
> +                       .origin = ovl_check_origin,
>                 },
>         }/* Pass Two */
>  };
> @@ -892,11 +1017,12 @@ static void ovl_scan_report(struct scan_ctx *sctx)
>  {
>         if (flags & FL_VERBOSE) {
>                 print_info(_("Scan %d directories, %d files, "
> -                            "%d/%d whiteouts, %d/%d redirect dirs "
> -                            "%d missing impure\n"),
> +                            "%d/%d whiteouts, %d/%d redirect dirs, "
> +                            "%d/%d origins, %d missing impure\n"),
>                              sctx->directories, sctx->files,
>                              sctx->i_whiteouts, sctx->t_whiteouts,
>                              sctx->i_redirects, sctx->t_redirects,
> +                            sctx->i_origins, sctx->t_origins,
>                              sctx->m_impure);
>         }
>  }
> @@ -916,6 +1042,11 @@ static void ovl_scan_check(struct scan_ctx *sctx)
>                              sctx->i_redirects);
>                 incons = true;
>         }
> +       if (sctx->i_origins) {
> +               print_info(_("Invalid origins %d left!\n"),
> +                            sctx->i_origins);
> +               incons = true;
> +       }
>         if (sctx->m_impure) {
>                 print_info(_("Directories %d missing impure xattr!\n"),
>                              sctx->m_impure);
> diff --git a/lib.c b/lib.c
> index 4d9536a..2aee0dc 100644
> --- a/lib.c
> +++ b/lib.c
> @@ -244,6 +244,11 @@ int scan_dir(struct scan_ctx *sctx, struct scan_operations *sop)
>                         ret = scan_check_entry(sop->impurity, sctx);
>                         if (ret)
>                                 goto out;
> +
> +                       /* Check origins */
> +                       ret = scan_check_entry(sop->origin, sctx);
> +                       if (ret)
> +                               goto out;
>                         break;
>                 case FTS_DEFAULT:
>                         /* Check whiteouts */
> @@ -264,6 +269,11 @@ int scan_dir(struct scan_ctx *sctx, struct scan_operations *sop)
>                         if (ret)
>                                 goto out;
>
> +                       /* Check origins */
> +                       ret = scan_check_entry(sop->origin, sctx);
> +                       if (ret)
> +                               goto out;
> +
>                         /* Save current dir data and create new one for subdir */
>                         ftsent->fts_pointer = sctx->dirdata;
>                         sctx->dirdata = smalloc(sizeof(struct scan_dir_data));
> diff --git a/lib.h b/lib.h
> index 880a8c3..5f7fdaa 100644
> --- a/lib.h
> +++ b/lib.h
> @@ -71,7 +71,9 @@ struct scan_ctx {
>         int i_whiteouts;        /* invalid whiteouts */
>         int t_redirects;        /* total redirect dirs */
>         int i_redirects;        /* invalid redirect dirs */
> -       int m_impure;           /* missing inpure dirs */
> +       int t_origins;          /* total origins */
> +       int i_origins;          /* invalid origins */
> +       int m_impure;           /* missing impure dirs */
>
>         const char *pathname;   /* path relative to overlay root */
>         const char *filename;   /* filename */
> diff --git a/overlayfs.c b/overlayfs.c
> index 93b4cad..c2f0840 100644
> --- a/overlayfs.c
> +++ b/overlayfs.c
> @@ -19,6 +19,8 @@
>   */
>
>  #include <stddef.h>
> +#include <errno.h>
> +#include "overlayfs.h"
>
>  /*
>   * Split directories to individual one.
> @@ -70,3 +72,24 @@ char *ovl_next_opt(char **s)
>         *s = NULL;
>         return sbegin;
>  }
> +
> +/*
> + * Check the validity of ovl_fh.
> + */
> +int ovl_check_fh_len(struct ovl_fh *fh, int fh_len)
> +{
> +       if (fh_len < sizeof(struct ovl_fh) || fh_len < fh->len)
> +               return -EINVAL;
> +
> +       if (fh->magic != OVL_FH_MAGIC)
> +               return -EINVAL;
> +
> +       if (fh->version > OVL_FH_VERSION || fh->flags & ~OVL_FH_FLAG_ALL)
> +               return -ENODATA;
> +
> +       if (!(fh->flags & OVL_FH_FLAG_ANY_ENDIAN) &&
> +           (fh->flags & OVL_FH_FLAG_BIG_ENDIAN) != OVL_FH_FLAG_CPU_ENDIAN)
> +               return -ENODATA;
> +

Overlayfs approach to unrecognized ovl_fh on-disk format is very
naiive borderline buggy.
When endian/flags/version check fails, origin is treated as "unknown"
and that is fine as
long as the only implication is change of inode number.
But when checking that origin of upper root matches lower root for
index feature, treating
unrecognized ovl_fh format as unknown will result in overwriting the
root origin and as
far as I can tell, this is a bug.

The situation with fsck.overlayfs is even worse IMO, because running
an old fsck tools
is even more easy to get wrong than mounting an overlayfs with an old kernel.
In general fsck.* tools, like e2fsck, are more prudent about fixing a filesystem
with unknown on-disk format than the kernel about mounting filesystem
with unknown
on-disk format features.

This patch specifically does not seem to do any harm when encountering unknown
on-disk format of ovl_fh, but I think fsck.overlay should take some
extra steps for
safety, before fixing overlayfs with features that fsck.overlay does
not support.

I suggest at least the following safely checks on start of fsck.overlay:
- Check if index dir exists in workdir
- Check if upperdir root has an unrecognized origin xattr format
- Check if index dir root has an unrecognized origin xattr format

If any of the checks above is positive, fsck.overlay should issue a warning
and refuse to fix fielsystem. Running with -n -f is allowed.
See if index dir exists, then removing origin xattr can corrupt the index.
When fsck.overlay gains the knowledge about checking and fixing index,
user would opt-in to checking an overlayfs with index by -o index=on.

Thanks,
Amir.
