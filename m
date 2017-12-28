From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 4/6] fsck.overlay: correct redirect xattr check
Date: Thu, 28 Dec 2017 16:22:03 +0200
Message-ID: <CAOQ4uxh89i3=TaYsAvQv7YvF0_auW3LYOf5PLtLHJkYo9kCHRQ@mail.gmail.com>
References: <20171228114023.43999-1-yi.zhang@huawei.com> <20171228114023.43999-5-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f178.google.com ([209.85.213.178]:47042 "EHLO
        mail-yb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753354AbdL1OWF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Dec 2017 09:22:05 -0500
In-Reply-To: <20171228114023.43999-5-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com

On Thu, Dec 28, 2017 at 1:40 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> When we found a valid redirect xattr and the lower origin targed was
> covered by a directory, it could be 1) an another redirect directory,
> or 2) an opaque directory created after rename in overlayfs or 3) a
> general directory created in the underlying directory when overlay is
> offline. Currently, we only handled case 2, this patch cover the other
> two cases.
>
> This patch ask user if we find a covering directory whitout opaque
> and another redirect xattr.
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
>  README.md | 31 ++++++++++++++-------
>  check.c   | 94 ++++++++++++++++++++++++++++++++++++++++++++++-----------------
>  2 files changed, 90 insertions(+), 35 deletions(-)
>
> diff --git a/README.md b/README.md
> index a8d0b1c..2e6146f 100644
> --- a/README.md
> +++ b/README.md
> @@ -25,16 +25,27 @@ If an redirect directory is found, the following must be met:
>
>  1) The directory path pointed by redirect xattr should exist in one of lower
>     layers.
> -2) The origin directory should be redirected only once in one layer, which means
> -   there is only one redirect xattr point to this origin directory in the
> -   specified layer.
> -3) A whiteout or an opaque directory with the same name to origin should exist
> -   in the same directory as the redirect directory.
> -
> -If not, 1) The redirect xattr is invalid and need to remove 2) One of the
> -redirect xattr is redundant but not sure which one is, ask user or warn in
> -auto mode 3) Create a whiteout device or set opaque xattr to an existing
> -directory if the parent directory was meregd or remove xattr if not.
> +2) The origin directory should be redirected only once in one layer, which
> +   means there is only one redirect xattr point to this origin directory in
> +   the specified layer.
> +3) There must be something with the same name to the rename origin in its
> +   origin place, maybe a whiteout/file or a(an) opaque/redirect directory
> +   covering the lower target, maybe a new created directory merging with
> +   lower origin directory.
> +
> +If not,
> +1) The redirect xattr is invalid and need to remove.
> +2) One of the redirect xattr is redundant but not sure which one is, ask user
> +   or warn in auto mode.
> +3) Create a whiteout device if there nothing exists in its place. If the lower
> +   targed was covered by a directory which is not an another redirect directory,
> +   it could be created after rename in overlayfs or created in underlying
> +   directory when overlay is offline, not sure this directory is merged or not,
> +   ask user by default.
> +
> +If an invalid redirect xattr was removed by fsck and there is a corresponding
> +lower directory with the same name exists, not sure this directory is merged
> +or not, ask user to make a decision.
>
>  Usage
>  =====
> diff --git a/check.c b/check.c
> index 0b5d49b..6db41cd 100644
> --- a/check.c
> +++ b/check.c
> @@ -152,12 +152,29 @@ static inline int ovl_create_whiteout(const char *pathname)
>         return ret;
>  }
>
> -static inline int ovl_ask_invalid(const char *question, const char *pathname,
> -                                 int action)
> +static inline bool ovl_is_redirect(const char *pathname)
> +{
> +       bool exist = false;
> +       ssize_t ret;
> +
> +       ret = get_xattr(pathname, OVL_REDIRECT_XATTR, NULL, &exist);
> +       return ret ? false : exist;
> +}
> +
> +static inline int ovl_ask_action(const char *description, const char *pathname,
> +                                const char *question, int action)
> +{
> +       print_info(_("%s: %s "), description, pathname);
> +
> +       return ask_question(question, action);
> +}
> +
> +static inline int ovl_ask_question(const char *question, const char *pathname,
> +                                  int action)
>  {
>         print_info(_("%s: %s "), question, pathname);
>
> -       return ask_question("Remove", action);
> +       return ask_question("", action);
>  }
>
>  /*
> @@ -233,7 +250,7 @@ remove:
>         sctx->i_whiteouts++;
>
>         /* Remove orphan whiteout directly or ask user */
> -       if (!ovl_ask_invalid("Orphan whiteout", pathname, 1))
> +       if (!ovl_ask_action("Orphan whiteout", pathname, "Remove", 1))
>                 return 0;
>
>         ret = unlink(pathname);
> @@ -323,15 +340,21 @@ static void ovl_redirect_free(void)
>   * 2) Count how many directories the origin directory was redirected by.
>   *    If more than one in the same layer, there must be some inconsistency
>   *    but not sure which one is invalid, ask user or warn in auto mode.
> - * 3) Check and fix the missing whiteout or opaque in redierct parent dir.
> + * 3) Check and fix the missing whiteout that covering the redirect lower
> + *    target. If the lower targed was covered by a directory which is not
> + *    an another redirect directory, it could be created after rename in
> + *    overlayfs or created in underlying directory when overlay is offline,
> + *    check opaque xattr and ask user by default.
> + * 4) When an invalid redirect xattr is removed, and the lower layers have
> + *    directory with same name, not sure this is a merged directory, ask
> + *    user by default.
>   */
>  static int ovl_check_redirect(struct scan_ctx *sctx)
>  {
>         const char *pathname = sctx->pathname;
>         struct ovl_lower_check chk = {0};
> -       char redirect_rpath[PATH_MAX];
>         struct stat rst;
> -       char *redirect = NULL;
> +       char *redirect = NULL, *cover_path = NULL;
>         int start;
>         int ret = 0;
>
> @@ -345,8 +368,10 @@ static int ovl_check_redirect(struct scan_ctx *sctx)
>         sctx->t_redirects++;
>
>         /* Redirect dir in last lower dir ? */
> -       if (sctx->dirtype == OVL_LOWER && sctx->num == lower_num-1)
> +       if (sctx->dirtype == OVL_LOWER && sctx->num == lower_num-1) {
> +               start = lower_num;
>                 goto remove;
> +       }
>
>         /* Scan lower directories to check redirect dir exist or not */
>         start = (sctx->dirtype == OVL_LOWER) ? sctx->num + 1 : 0;
> @@ -359,14 +384,14 @@ static int ovl_check_redirect(struct scan_ctx *sctx)
>                 /* Check duplicate in same layer */
>                 if (ovl_redirect_entry_find(chk.path, sctx->dirtype,
>                                             sctx->num, &tmp)) {
> -                       print_info("Duplicate redirect directories found:\n");
> -                       print_info("origin:%s current:%s last:%s\n",
> -                                  chk.path, pathname, tmp);
> +                       print_info("Duplicate redirect directory found:%s\n", pathname);
> +                       print_info("Origin:%s Previous:%s\n", chk.path, tmp);
>
>                         sctx->i_redirects++;
>
>                         /* Don't remove in auto mode */
> -                       if (ovl_ask_invalid("Duplicate redirect xattr", pathname, 0))
> +                       if (ovl_ask_action("Duplicate redirect xattr", pathname,
> +                                          "Remove", 0))
>                                 goto remove_d;
>                 }
>
> @@ -374,25 +399,32 @@ static int ovl_check_redirect(struct scan_ctx *sctx)
>                                        sctx->num, chk.path);
>
>                 /* Check and fix whiteout or opaque dir */
> -               path_pack(redirect_rpath, sizeof(redirect_rpath),
> -                         sctx->dirname, redirect);
> -               if (lstat(redirect_rpath, &rst) != 0) {
> +               cover_path = path_pack(cover_path, 0, sctx->dirname, redirect);
> +               if (lstat(cover_path, &rst) != 0) {
>                         if (errno != ENOENT && errno != ENOTDIR) {
>                                 print_err(_("Cannot stat %s: %s\n"),
> -                                           redirect_rpath, strerror(errno));
> +                                           cover_path, strerror(errno));
>                                 goto out;
>                         }
>
>                         /* Found nothing, create a whiteout */
> -                       if ((ret = ovl_create_whiteout(redirect_rpath)))
> +                       if ((ret = ovl_create_whiteout(cover_path)))
>                                 goto out;
>
>                         sctx->t_whiteouts++;
>
> -               } else if (is_dir(&rst) && !ovl_is_opaque(redirect_rpath)) {
> -                       /* Found a directory but not opaqued, fix opaque xattr */
> -                       if ((ret = ovl_set_opaque(redirect_rpath)))
> -                               goto out;
> +               } else if (is_dir(&rst) && !ovl_is_opaque(cover_path) &&
> +                          !ovl_is_redirect(cover_path)) {
> +
> +                       /*
> +                        * Found a directory but not opaqued and not even
> +                        * an another redirected directory, maybe created
> +                        * when overlayfs is offline, ask user to add the
> +                        * opaque xattr if this is not a merged dir.
> +                        */
> +                       if (!ovl_ask_question("Is merged dir", cover_path, 1))

I am not sure what user will understand from this question,
but maybe I don't see the full flow of info/questions in my mind.
Anyway, if I am not mistaken, you seem to hold the opinion that
default behavior if user says (-y := fix it I don't care how) should be
to set the opaque xattr. If you agree, then you should ask:
    if (ovl_ask_question("Should set opaque dir", cover_path, 1))


> +                               if ((ret = ovl_set_opaque(cover_path)))
> +                                       goto out;
>                 }
>
>                 goto out;
> @@ -402,13 +434,25 @@ remove:
>         sctx->i_redirects++;
>
>         /* Remove redirect xattr or ask user */
> -       if (!ovl_ask_invalid("Invalid redirect xattr", pathname, 1))
> +       if (!ovl_ask_action("Invalid redirect xattr", pathname, "Remove", 1))
>                 goto out;
>  remove_d:
> -       ret = ovl_remove_redirect(pathname);
> -       if (!ret)
> -               sctx->i_redirects--;
> +       if ((ret = ovl_remove_redirect(pathname)))
> +               goto out;
> +
> +       sctx->i_redirects--;
> +
> +       /* If lower directory exist, ask user to add opaque xattr to cover it */
> +       if (start < lower_num) {
> +               if ((ret = ovl_check_lower(path_pick(pathname, sctx->dirlen),
> +                                          start, &chk, false)))
> +                       goto out;
> +               if (chk.exist && is_dir(&chk.st) &&
> +                   !ovl_ask_question("Is merged dir", pathname, 1))
> +                       ret = ovl_set_opaque(pathname);

Same here. Better that fsck -y will set opaque right?
So flip the question to "Should set opaque dir"

> +       }
>  out:
> +       free(cover_path);
>         free(redirect);
>         return ret;
>  }
> --
> 2.9.5
>
