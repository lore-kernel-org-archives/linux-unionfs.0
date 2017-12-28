From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 2/6] fsck.overlay: add -n -p and -y options
Date: Thu, 28 Dec 2017 15:52:34 +0200
Message-ID: <CAOQ4uxhV0fTrQiBy2OoJW+GAZxyCq+_5=Kk_FzDT3d+jWDeUHw@mail.gmail.com>
References: <20171228114023.43999-1-yi.zhang@huawei.com> <20171228114023.43999-3-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:39906 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753293AbdL1Nwg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Dec 2017 08:52:36 -0500
In-Reply-To: <20171228114023.43999-3-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com

On Thu, Dec 28, 2017 at 1:40 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Add -n -p and -y options to make it official as fsck utilities.
>
> -p, automatic repair (no questions)
> -n, make no changes to the filesystem
> -y, assume "yes" to all questions
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

Looks ok.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  README.md |  6 ++++--
>  fsck.c    | 36 ++++++++++++++++++++++++++++++------
>  lib.c     |  3 ++-
>  lib.h     |  6 +++++-
>  4 files changed, 41 insertions(+), 10 deletions(-)
>
> diff --git a/README.md b/README.md
> index c2acb65..458a815 100644
> --- a/README.md
> +++ b/README.md
> @@ -44,14 +44,16 @@ Usage
>
>  2. Run fsck.overlay program:
>     Usage:
> -   fsck.overlay [-l lowerdir] [-u upperdir] [-w workdir] [-avhV]
> +   fsck.overlay [-l lowerdir] [-u upperdir] [-w workdir] [-pnyvhV]
>
>     Options:
>     -l, --lowerdir=LOWERDIR   specify lower directories of overlayfs,
>                               multiple lower use ':' as separator.
>     -u, --upperdir=UPPERDIR   specify upper directory of overlayfs
>     -w, --workdir=WORKDIR     specify work directory of overlayfs
> -   -a, --auto                repair automatically (no questions)
> +   -p,                       automatic repair (no questions)
> +   -n,                       make no changes to the filesystem
> +   -y,                       assume "yes" to all questions
>     -v, --verbose             print more messages of overlayfs
>     -h, --help                display this usage of overlayfs
>     -V, --version             display version information
> diff --git a/fsck.c b/fsck.c
> index d4e861a..44211f7 100644
> --- a/fsck.c
> +++ b/fsck.c
> @@ -62,13 +62,15 @@ static void ovl_clean_lowerdirs(void)
>  static void usage(void)
>  {
>         print_info(_("Usage:\n\t%s [-l lowerdir] [-u upperdir] [-w workdir] "
> -                   "[-avhV]\n\n"), program_name);
> +                   "[-pnyvhV]\n\n"), program_name);
>         print_info(_("Options:\n"
>                     "-l, --lowerdir=LOWERDIR   specify lower directories of overlayfs,\n"
>                     "                          multiple lower use ':' as separator\n"
>                     "-u, --upperdir=UPPERDIR   specify upper directory of overlayfs\n"
>                     "-w, --workdir=WORKDIR     specify work directory of overlayfs\n"
> -                   "-a, --auto                repair automatically (no questions)\n"
> +                   "-p,                       automatic repair (no questions)\n"
> +                   "-n,                       make no changes to the filesystem\n"
> +                   "-y,                       assume \"yes\" to all questions\n"
>                     "-v, --verbose             print more messages of overlayfs\n"
>                     "-h, --help                display this usage of overlayfs\n"
>                     "-V, --version             display version information\n"));
> @@ -81,19 +83,19 @@ static void parse_options(int argc, char *argv[])
>         int c;
>         int ret = 0;
>         bool show_usage = false;
> +       bool opt_conflict = false;
>
>         struct option long_options[] = {
>                 {"lowerdir", required_argument, NULL, 'l'},
>                 {"upperdir", required_argument, NULL, 'u'},
>                 {"workdir", required_argument, NULL, 'w'},
> -               {"auto", no_argument, NULL, 'a'},
>                 {"verbose", no_argument, NULL, 'v'},
>                 {"version", no_argument, NULL, 'V'},
>                 {"help", no_argument, NULL, 'h'},
>                 {NULL, 0, NULL, 0}
>         };
>
> -       while ((c = getopt_long(argc, argv, "l:u:w:avVh", long_options, NULL)) != -1) {
> +       while ((c = getopt_long(argc, argv, "l:u:w:apnyvVh", long_options, NULL)) != -1) {
>                 switch (c) {
>                 case 'l':
>                         lowertemp = strdup(optarg);
> @@ -119,7 +121,23 @@ static void parse_options(int argc, char *argv[])
>                         }
>                         break;
>                 case 'a':
> -                       flags |= FL_AUTO;
> +               case 'p':
> +                       if (flags & (FL_OPT_YES | FL_OPT_NO))
> +                               opt_conflict = true;
> +                       else
> +                               flags |= FL_OPT_AUTO;
> +                       break;
> +               case 'n':
> +                       if (flags & (FL_OPT_YES | FL_OPT_AUTO))
> +                               opt_conflict = true;
> +                       else
> +                               flags |= FL_OPT_NO;
> +                       break;
> +               case 'y':
> +                       if (flags & (FL_OPT_NO | FL_OPT_AUTO))
> +                               opt_conflict = true;
> +                       else
> +                               flags |= FL_OPT_YES;
>                         break;
>                 case 'v':
>                         flags |= FL_VERBOSE;
> @@ -143,6 +161,12 @@ static void parse_options(int argc, char *argv[])
>                 goto err_out;
>         }
>
> +       if (opt_conflict) {
> +               print_info(_("Only one of the options -p/-a, -n or -y can be specified!\n\n"));
> +               show_usage = true;
> +               goto err_out;
> +       }
> +
>         return;
>
>  err_out:
> @@ -177,7 +201,7 @@ int main(int argc, char *argv[])
>         /* Ensure overlay filesystem not mounted */
>         if ((err = ovl_check_mount(&mounted)))
>                 goto out;
> -       if (mounted) {
> +       if (mounted && !(flags & FL_OPT_NO)) {
>                 set_st_abort(&status);
>                 goto out;
>         }
> diff --git a/lib.c b/lib.c
> index 271cafd..497d357 100644
> --- a/lib.c
> +++ b/lib.c
> @@ -59,7 +59,8 @@ static int ask_yn(const char *question, int def)
>  /* Ask user */
>  int ask_question(const char *question, int def)
>  {
> -       if (flags & FL_AUTO) {
> +       if (flags & FL_OPT_MASK) {
> +               def = (flags & FL_OPT_YES) ? 1 : (flags & FL_OPT_NO) ? 0 : def;
>                 print_info(_("%s? %s\n"), question, def ? _("y") : _("n"));
>                 return def;
>         }
> diff --git a/lib.h b/lib.h
> index 235719c..5d94836 100644
> --- a/lib.h
> +++ b/lib.h
> @@ -37,7 +37,11 @@
>  #define FL_VERBOSE     (1 << 0)        /* verbose */
>  #define FL_UPPER       (1 << 1)        /* specify upper directory */
>  #define FL_WORK                (1 << 2)        /* specify work directory */
> -#define FL_AUTO                (1 << 3)        /* automactically scan dirs and repair */
> +#define FL_OPT_AUTO    (1 << 3)        /* automactically scan dirs and repair */
> +#define FL_OPT_NO      (1 << 4)        /* no changes to the filesystem */
> +#define FL_OPT_YES     (1 << 5)        /* yes to all questions */
> +#define FL_OPT_MASK    (FL_OPT_AUTO|FL_OPT_NO|FL_OPT_YES)
> +
>
>  /* Scan path type */
>  #define OVL_UPPER      0
> --
> 2.9.5
>
