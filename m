Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B07F5EB64D9
	for <linux-unionfs@archiver.kernel.org>; Sat, 17 Jun 2023 07:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbjFQHGZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 17 Jun 2023 03:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbjFQHGW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 17 Jun 2023 03:06:22 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4BF199F
        for <linux-unionfs@vger.kernel.org>; Sat, 17 Jun 2023 00:06:20 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id a1e0cc1a2514c-78cee27c08aso591227241.2
        for <linux-unionfs@vger.kernel.org>; Sat, 17 Jun 2023 00:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686985579; x=1689577579;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=acZph09b53WX91vyTl7o+2AsRfRsxmz6oyGwbi7ssOE=;
        b=BxPd7Wm1jSRSB3fE9Aue8cBr6XE1uYi4MyL/kHskCweLCqe/FiQOQ1YT29Ds2SND4S
         Z3Shdbw2d1Gl0Hsjel1rO2rb8Y5E4mDnutITJ6iVhRQJvgaDbjZrtqqSHYfFoPU08t6K
         fFDQ3vhaYaHsTEXreIY/2V5zH1zXWkm+rax0PTBLtpunYAmVGInEe4f+GIupJR7XkhHj
         +8+h1pXU7INnX+sfXzgwshbvCunvLisit+d6PcEKzBTyXAuWwuZf4n6WeND8+xviUjrz
         uYcqZUKkPWlWw2Q5f2112BT7VeX8fXk/NzccDcWXt9OXlh6LwNbduNEW9PJtRAohfpTu
         BOQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686985579; x=1689577579;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=acZph09b53WX91vyTl7o+2AsRfRsxmz6oyGwbi7ssOE=;
        b=YK58ygR8wGY07A8G2UCJKMHh9wJa3MymIZ/62yL+s5vHy4UUOlsM+ZDyh0Pg2QDafH
         TS1pFFWFx7k+Lx81TzIb9RZS+bps6uEy7aBHNyFto8uvuQEWpdPnoaoDj+0hxKnTvLuK
         PqTu8wjCb/IHmTb2XJjOilfuVIA8kVQ+1lDp5c1ohFsdVzvYRSsH4yb/D01Fxfb/UIMK
         DGFhv7+IAtcGHevrOQ7xHy1KKwk/H63g+YyIm1prScTMPyFt419bTgyRlp1aO4msila5
         RiVKI0s1jqVjMT8wXIu3cM8K8zTOXvoUJ/+Gw45r1MKMpNQhxHE+8LSIb5tbWnWdJLsD
         KkSw==
X-Gm-Message-State: AC+VfDw8fBaJZISI+z4b4MNQLMpzNBTpoTap3ywsRV1gGjpKt3Sum20A
        P0UZglGUkFfyvFg2+amtgw9w3OUSYWeGYvmCdWRhDxbK7tM=
X-Google-Smtp-Source: ACHHUZ4q4GbDqNNje6Rhpi9RUW53VuW/9Fr9EKZ3S5+bQ5Xs56l70pQXkh08Bjj3/zsi4Ep7XUYCVQH9WJOcvBJxIuk=
X-Received: by 2002:a67:f050:0:b0:43b:42ee:d426 with SMTP id
 q16-20020a67f050000000b0043b42eed426mr647484vsm.27.1686985578997; Sat, 17 Jun
 2023 00:06:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230616141941.2402664-1-amir73il@gmail.com> <20230616141941.2402664-2-amir73il@gmail.com>
In-Reply-To: <20230616141941.2402664-2-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 17 Jun 2023 10:06:07 +0300
Message-ID: <CAOQ4uxj4NJSWwrRCfm1O+29z4Ma=3-kpKuuWj4YDdyqBv7dFwg@mail.gmail.com>
Subject: Re: [PATCH 1/2] ovl: store enum redirect_mode in config instead of a string
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jun 16, 2023 at 5:19=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> Do all the logic to set the mode during mount options parsing and
> do not keep the option string around.
>
> This results in a minor change to the string that is displayed
> in show_options() - when CONFIG_OVERLAY_FS_REDIRECT_DIR=3Dy and the user
> mounts with the option "redirect_dir=3Doff", instead of displaying the mo=
de
> "redirect_dir=3Doff" in show_options(), the displayed mode will be either
>  "redirect_dir=3Dfollow" or "redirect_dir=3Dnofollow", depending on the v=
alue
> of CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW.
>
> The displayed mode reflects the effective mode, so mounting overlayfs
> again with the dispalyed redirect_dir option will result in the sam
> effective and displayed mode.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/dir.c       |   2 +-
>  fs/overlayfs/namei.c     |   6 +-
>  fs/overlayfs/overlayfs.h |  20 +++++-
>  fs/overlayfs/ovl_entry.h |   4 +-
>  fs/overlayfs/super.c     | 148 ++++++++++++++++++++++-----------------
>  fs/overlayfs/util.c      |   7 --
>  6 files changed, 107 insertions(+), 80 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 92bdcedfaaec..e7e30a999fac 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -952,7 +952,7 @@ static bool ovl_type_merge_or_lower(struct dentry *de=
ntry)
>
>  static bool ovl_can_move(struct dentry *dentry)
>  {
> -       return ovl_redirect_dir(dentry->d_sb) ||
> +       return ovl_redirect_dir(OVL_FS(dentry->d_sb)) ||
>                 !d_is_dir(dentry) || !ovl_type_merge_or_lower(dentry);
>  }
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 292b8a948f1a..288e3c0ee0e6 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -961,7 +961,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct d=
entry *dentry,
>                 .is_dir =3D false,
>                 .opaque =3D false,
>                 .stop =3D false,
> -               .last =3D ofs->config.redirect_follow ? false : !ovl_numl=
ower(poe),
> +               .last =3D ovl_redirect_follow(ofs) ? false : !ovl_numlowe=
r(poe),
>                 .redirect =3D NULL,
>                 .metacopy =3D false,
>         };
> @@ -1022,7 +1022,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct=
 dentry *dentry,
>         for (i =3D 0; !d.stop && i < ovl_numlower(poe); i++) {
>                 struct ovl_path lower =3D ovl_lowerstack(poe)[i];
>
> -               if (!ofs->config.redirect_follow)
> +               if (!ovl_redirect_follow(ofs))
>                         d.last =3D i =3D=3D ovl_numlower(poe) - 1;
>                 else if (d.is_dir || !ofs->numdatalayer)
>                         d.last =3D lower.layer->idx =3D=3D ovl_numlower(r=
oe);
> @@ -1102,7 +1102,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct=
 dentry *dentry,
>                  * this attack vector when not necessary.
>                  */
>                 err =3D -EPERM;
> -               if (d.redirect && !ofs->config.redirect_follow) {
> +               if (d.redirect && !ovl_redirect_follow(ofs)) {
>                         pr_warn_ratelimited("refusing to follow redirect =
for (%pd2)\n",
>                                             dentry);
>                         goto out_put;
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index fcac4e2c56ab..e689520e3eca 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -57,6 +57,13 @@ enum ovl_entry_flag {
>         OVL_E_CONNECTED,
>  };
>
> +enum {
> +       OVL_REDIRECT_ON,
> +       OVL_REDIRECT_OFF,       /* "off" mode is never used...          *=
/
> +       OVL_REDIRECT_FOLLOW,    /* ...it translates to either "follow"  *=
/
> +       OVL_REDIRECT_NOFOLLOW,  /* ...or "nofollow".                    *=
/
> +};
> +
>  enum {
>         OVL_XINO_OFF,
>         OVL_XINO_AUTO,
> @@ -352,6 +359,16 @@ static inline bool ovl_open_flags_need_copy_up(int f=
lags)
>         return ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC));
>  }
>
> +static inline bool ovl_redirect_follow(struct ovl_fs *ofs)
> +{
> +       return ofs->config.redirect_mode !=3D OVL_REDIRECT_NOFOLLOW;
> +}
> +
> +static inline bool ovl_redirect_dir(struct ovl_fs *ofs)
> +{
> +       return ofs->config.redirect_mode =3D=3D OVL_REDIRECT_ON;
> +}
> +
>  static inline bool ovl_allow_offline_changes(struct ovl_fs *ofs)
>  {
>         /*
> @@ -360,7 +377,7 @@ static inline bool ovl_allow_offline_changes(struct o=
vl_fs *ofs)
>          * are used.
>          */
>         return (!ofs->config.index && !ofs->config.metacopy &&
> -               !ofs->config.redirect_dir && ofs->config.xino !=3D OVL_XI=
NO_ON);
> +               !ovl_redirect_dir(ofs) && ofs->config.xino !=3D OVL_XINO_=
ON);
>  }
>
>
> @@ -421,7 +438,6 @@ bool ovl_dentry_needs_data_copy_up(struct dentry *den=
try, int flags);
>  bool ovl_dentry_needs_data_copy_up_locked(struct dentry *dentry, int fla=
gs);
>  bool ovl_has_upperdata(struct inode *inode);
>  void ovl_set_upperdata(struct inode *inode);
> -bool ovl_redirect_dir(struct super_block *sb);
>  const char *ovl_dentry_get_redirect(struct dentry *dentry);
>  void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect=
);
>  void ovl_inode_update(struct inode *inode, struct dentry *upperdentry);
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index e5207c4bf5b8..0ff12622ac1b 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -10,9 +10,7 @@ struct ovl_config {
>         char *upperdir;
>         char *workdir;
>         bool default_permissions;
> -       bool redirect_dir;
> -       bool redirect_follow;
> -       const char *redirect_mode;
> +       int redirect_mode;
>         bool index;
>         bool uuid;
>         bool nfs_export;
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 14a2ebdc8126..cc7d7d8af711 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -16,6 +16,7 @@
>  #include <linux/posix_acl_xattr.h>
>  #include <linux/exportfs.h>
>  #include <linux/file.h>
> +#include <linux/fs_parser.h>
>  #include "overlayfs.h"
>
>  MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
> @@ -243,7 +244,6 @@ static void ovl_free_fs(struct ovl_fs *ofs)
>         kfree(ofs->config.lowerdir);
>         kfree(ofs->config.upperdir);
>         kfree(ofs->config.workdir);
> -       kfree(ofs->config.redirect_mode);
>         if (ofs->creator_cred)
>                 put_cred(ofs->creator_cred);
>         kfree(ofs);
> @@ -329,17 +329,38 @@ static bool ovl_force_readonly(struct ovl_fs *ofs)
>         return (!ovl_upper_mnt(ofs) || !ofs->workdir);
>  }
>
> -static const char *ovl_redirect_mode_def(void)
> +static const struct constant_table ovl_parameter_redirect_dir[] =3D {
> +       { "on",         OVL_REDIRECT_ON       },
> +       { "off",        OVL_REDIRECT_OFF      },
> +       { "follow",     OVL_REDIRECT_FOLLOW   },
> +       { "nofollow",   OVL_REDIRECT_NOFOLLOW },
> +       {}
> +};
> +
> +static const char *ovl_redirect_mode(struct ovl_config *config)
> +{
> +       return ovl_parameter_redirect_dir[config->redirect_mode].name;
> +}
> +
> +static int ovl_redirect_mode_def(void)
>  {
> -       return ovl_redirect_dir_def ? "on" : "off";
> +       return ovl_redirect_dir_def ? OVL_REDIRECT_ON :
> +               ovl_redirect_always_follow ? OVL_REDIRECT_FOLLOW :
> +                                            OVL_REDIRECT_NOFOLLOW;
>  }
>
> -static const char * const ovl_xino_str[] =3D {
> -       "off",
> -       "auto",
> -       "on",
> +static const struct constant_table ovl_parameter_xino[] =3D {
> +       { "on",         OVL_XINO_ON   },
> +       { "off",        OVL_XINO_OFF  },
> +       { "auto",       OVL_XINO_AUTO },
> +       {}

Bug: this table needs to be in enum order.
I am going to split this change into another patch.

>  };
>
> +static const char *ovl_xino_mode(struct ovl_config *config)
> +{
> +       return ovl_parameter_xino[config->xino].name;
> +}
> +
>  static inline int ovl_xino_def(void)
>  {
>         return ovl_xino_auto_def ? OVL_XINO_AUTO : OVL_XINO_OFF;
> @@ -365,8 +386,9 @@ static int ovl_show_options(struct seq_file *m, struc=
t dentry *dentry)
>         }
>         if (ofs->config.default_permissions)
>                 seq_puts(m, ",default_permissions");
> -       if (strcmp(ofs->config.redirect_mode, ovl_redirect_mode_def()) !=
=3D 0)
> -               seq_printf(m, ",redirect_dir=3D%s", ofs->config.redirect_=
mode);
> +       if (ofs->config.redirect_mode !=3D ovl_redirect_mode_def())
> +               seq_printf(m, ",redirect_dir=3D%s",
> +                          ovl_redirect_mode(&ofs->config));
>         if (ofs->config.index !=3D ovl_index_def)
>                 seq_printf(m, ",index=3D%s", ofs->config.index ? "on" : "=
off");
>         if (!ofs->config.uuid)
> @@ -375,7 +397,7 @@ static int ovl_show_options(struct seq_file *m, struc=
t dentry *dentry)
>                 seq_printf(m, ",nfs_export=3D%s", ofs->config.nfs_export =
?
>                                                 "on" : "off");
>         if (ofs->config.xino !=3D ovl_xino_def() && !ovl_same_fs(sb))
> -               seq_printf(m, ",xino=3D%s", ovl_xino_str[ofs->config.xino=
]);
> +               seq_printf(m, ",xino=3D%s", ovl_xino_mode(&ofs->config));
>         if (ofs->config.metacopy !=3D ovl_metacopy_def)
>                 seq_printf(m, ",metacopy=3D%s",
>                            ofs->config.metacopy ? "on" : "off");
> @@ -424,7 +446,10 @@ enum {
>         OPT_UPPERDIR,
>         OPT_WORKDIR,
>         OPT_DEFAULT_PERMISSIONS,
> -       OPT_REDIRECT_DIR,
> +       OPT_REDIRECT_DIR_ON,
> +       OPT_REDIRECT_DIR_OFF,
> +       OPT_REDIRECT_DIR_FOLLOW,
> +       OPT_REDIRECT_DIR_NOFOLLOW,
>         OPT_INDEX_ON,
>         OPT_INDEX_OFF,
>         OPT_UUID_ON,
> @@ -446,7 +471,10 @@ static const match_table_t ovl_tokens =3D {
>         {OPT_UPPERDIR,                  "upperdir=3D%s"},
>         {OPT_WORKDIR,                   "workdir=3D%s"},
>         {OPT_DEFAULT_PERMISSIONS,       "default_permissions"},
> -       {OPT_REDIRECT_DIR,              "redirect_dir=3D%s"},
> +       {OPT_REDIRECT_DIR_ON,           "redirect_dir=3Don"},
> +       {OPT_REDIRECT_DIR_OFF,          "redirect_dir=3Doff"},
> +       {OPT_REDIRECT_DIR_FOLLOW,       "redirect_dir=3Dfollow"},
> +       {OPT_REDIRECT_DIR_NOFOLLOW,     "redirect_dir=3Dnofollow"},
>         {OPT_INDEX_ON,                  "index=3Don"},
>         {OPT_INDEX_OFF,                 "index=3Doff"},
>         {OPT_USERXATTR,                 "userxattr"},
> @@ -486,40 +514,12 @@ static char *ovl_next_opt(char **s)
>         return sbegin;
>  }
>
> -static int ovl_parse_redirect_mode(struct ovl_config *config, const char=
 *mode)
> -{
> -       if (strcmp(mode, "on") =3D=3D 0) {
> -               config->redirect_dir =3D true;
> -               /*
> -                * Does not make sense to have redirect creation without
> -                * redirect following.
> -                */
> -               config->redirect_follow =3D true;
> -       } else if (strcmp(mode, "follow") =3D=3D 0) {
> -               config->redirect_follow =3D true;
> -       } else if (strcmp(mode, "off") =3D=3D 0) {
> -               if (ovl_redirect_always_follow)
> -                       config->redirect_follow =3D true;
> -       } else if (strcmp(mode, "nofollow") !=3D 0) {
> -               pr_err("bad mount option \"redirect_dir=3D%s\"\n",
> -                      mode);
> -               return -EINVAL;
> -       }
> -
> -       return 0;
> -}
> -
>  static int ovl_parse_opt(char *opt, struct ovl_config *config)
>  {
>         char *p;
> -       int err;
>         bool metacopy_opt =3D false, redirect_opt =3D false;
>         bool nfs_export_opt =3D false, index_opt =3D false;
>
> -       config->redirect_mode =3D kstrdup(ovl_redirect_mode_def(), GFP_KE=
RNEL);
> -       if (!config->redirect_mode)
> -               return -ENOMEM;
> -
>         while ((p =3D ovl_next_opt(&opt)) !=3D NULL) {
>                 int token;
>                 substring_t args[MAX_OPT_ARGS];
> @@ -554,11 +554,25 @@ static int ovl_parse_opt(char *opt, struct ovl_conf=
ig *config)
>                         config->default_permissions =3D true;
>                         break;
>
> -               case OPT_REDIRECT_DIR:
> -                       kfree(config->redirect_mode);
> -                       config->redirect_mode =3D match_strdup(&args[0]);
> -                       if (!config->redirect_mode)
> -                               return -ENOMEM;
> +               case OPT_REDIRECT_DIR_ON:
> +                       config->redirect_mode =3D OVL_REDIRECT_ON;
> +                       redirect_opt =3D true;
> +                       break;
> +
> +               case OPT_REDIRECT_DIR_OFF:
> +                       config->redirect_mode =3D ovl_redirect_always_fol=
low ?
> +                                               OVL_REDIRECT_FOLLOW :
> +                                               OVL_REDIRECT_NOFOLLOW;
> +                       redirect_opt =3D true;
> +                       break;
> +
> +               case OPT_REDIRECT_DIR_FOLLOW:
> +                       config->redirect_mode =3D OVL_REDIRECT_FOLLOW;
> +                       redirect_opt =3D true;
> +                       break;
> +
> +               case OPT_REDIRECT_DIR_NOFOLLOW:
> +                       config->redirect_mode =3D OVL_REDIRECT_NOFOLLOW;
>                         redirect_opt =3D true;
>                         break;
>
> @@ -647,22 +661,18 @@ static int ovl_parse_opt(char *opt, struct ovl_conf=
ig *config)
>                 config->ovl_volatile =3D false;
>         }
>
> -       err =3D ovl_parse_redirect_mode(config, config->redirect_mode);
> -       if (err)
> -               return err;
> -
>         /*
>          * This is to make the logic below simpler.  It doesn't make any =
other
> -        * difference, since config->redirect_dir is only used for upper.
> +        * difference, since redirect_dir=3Don is only used for upper.
>          */
> -       if (!config->upperdir && config->redirect_follow)
> -               config->redirect_dir =3D true;
> +       if (!config->upperdir && config->redirect_mode =3D=3D OVL_REDIREC=
T_FOLLOW)
> +               config->redirect_mode =3D OVL_REDIRECT_ON;
>
>         /* Resolve metacopy -> redirect_dir dependency */
> -       if (config->metacopy && !config->redirect_dir) {
> +       if (config->metacopy && !config->redirect_mode !=3D OVL_REDIRECT_=
ON) {

Typo leftover !config->redirect_mode !=3D

>                 if (metacopy_opt && redirect_opt) {
>                         pr_err("conflicting options: metacopy=3Don,redire=
ct_dir=3D%s\n",
> -                              config->redirect_mode);
> +                              ovl_redirect_mode(config));
>                         return -EINVAL;
>                 }
>                 if (redirect_opt) {
> @@ -671,17 +681,18 @@ static int ovl_parse_opt(char *opt, struct ovl_conf=
ig *config)
>                          * in this conflict.
>                          */
>                         pr_info("disabling metacopy due to redirect_dir=
=3D%s\n",
> -                               config->redirect_mode);
> +                               ovl_redirect_mode(config));
>                         config->metacopy =3D false;
>                 } else {
>                         /* Automatically enable redirect otherwise. */
> -                       config->redirect_follow =3D config->redirect_dir =
=3D true;
> +                       config->redirect_mode =3D OVL_REDIRECT_ON;
>                 }
>         }
>
>         /* Resolve nfs_export -> index dependency */
>         if (config->nfs_export && !config->index) {
> -               if (!config->upperdir && config->redirect_follow) {
> +               if (!config->upperdir &&
> +                   config->redirect_mode !=3D OVL_REDIRECT_NOFOLLOW) {
>                         pr_info("NFS export requires \"redirect_dir=3Dnof=
ollow\" on non-upper mount, falling back to nfs_export=3Doff.\n");
>                         config->nfs_export =3D false;
>                 } else if (nfs_export_opt && index_opt) {
> @@ -726,9 +737,10 @@ static int ovl_parse_opt(char *opt, struct ovl_confi=
g *config)
>
>         /* Resolve userxattr -> !redirect && !metacopy dependency */
>         if (config->userxattr) {
> -               if (config->redirect_follow && redirect_opt) {
> +               if (redirect_opt &&
> +                   config->redirect_mode !=3D OVL_REDIRECT_NOFOLLOW) {
>                         pr_err("conflicting options: userxattr,redirect_d=
ir=3D%s\n",
> -                              config->redirect_mode);
> +                              ovl_redirect_mode(config));
>                         return -EINVAL;
>                 }
>                 if (config->metacopy && metacopy_opt) {
> @@ -741,7 +753,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config=
 *config)
>                  * options must be explicitly enabled if used together wi=
th
>                  * userxattr.
>                  */
> -               config->redirect_dir =3D config->redirect_follow =3D fals=
e;
> +               config->redirect_mode =3D OVL_REDIRECT_NOFOLLOW;
>                 config->metacopy =3D false;
>         }
>
> @@ -1325,10 +1337,17 @@ static int ovl_make_workdir(struct super_block *s=
b, struct ovl_fs *ofs,
>         if (err) {
>                 pr_warn("failed to set xattr on upper\n");
>                 ofs->noxattr =3D true;
> -               if (ofs->config.index || ofs->config.metacopy) {
> -                       ofs->config.index =3D false;
> +               if (ovl_redirect_follow(ofs)) {
> +                       ofs->config.redirect_mode =3D OVL_REDIRECT_NOFOLL=
OW;
> +                       pr_warn("...falling back to redirect_dir=3Dnofoll=
ow.\n");
> +               }
> +               if (ofs->config.metacopy) {
>                         ofs->config.metacopy =3D false;
> -                       pr_warn("...falling back to index=3Doff,metacopy=
=3Doff.\n");
> +                       pr_warn("...falling back to metacopy=3Doff.\n");
> +               }
> +               if (ofs->config.index) {
> +                       ofs->config.index =3D false;
> +                       pr_warn("...falling back to index=3Doff.\n");
>                 }
>                 /*
>                  * xattr support is required for persistent st_ino.
> @@ -1566,7 +1585,7 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const s=
truct path *path)
>                         pr_warn("%s uuid detected in lower fs '%pd2', fal=
ling back to xino=3D%s,index=3Doff,nfs_export=3Doff.\n",
>                                 uuid_is_null(&sb->s_uuid) ? "null" :
>                                                             "conflicting"=
,
> -                               path->dentry, ovl_xino_str[ofs->config.xi=
no]);
> +                               path->dentry, ovl_xino_mode(&ofs->config)=
);
>                 }
>         }
>
> @@ -1957,6 +1976,7 @@ static int ovl_fill_super(struct super_block *sb, v=
oid *data, int silent)
>         /* Is there a reason anyone would want not to share whiteouts? */
>         ofs->share_whiteout =3D true;
>

I don't like that feature share_whiteout is initialized along with configs.
I am going to move it to feature detection code with another patch.

> +       ofs->config.redirect_mode =3D ovl_redirect_mode_def();
>         ofs->config.index =3D ovl_index_def;
>         ofs->config.uuid =3D true;
>         ofs->config.nfs_export =3D ovl_nfs_export_def;

Thanks,
Amir.
