From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 3/8] ovl: Provide a mount option metacopy=on/off for
 metadata copyup
Date: Fri, 6 Oct 2017 22:01:47 +0300
Message-ID: <CAOQ4uxiP+QjNW7P1n0-wK-PEVUYCZR_gLd3_H_ZbhC=B5fQvmg@mail.gmail.com>
References: <1507312037-30909-1-git-send-email-vgoyal@redhat.com> <1507312037-30909-4-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:33461 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751491AbdJFTBt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Oct 2017 15:01:49 -0400
Received: by mail-qt0-f193.google.com with SMTP id x54so8736036qth.0
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Oct 2017 12:01:48 -0700 (PDT)
In-Reply-To: <1507312037-30909-4-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Oct 6, 2017 at 8:47 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> By default metadata only copy up is disabled. Provide a mount option so
> that users can choose one way or other.
>
> Also metadata copyup is conditional on index=on. If index=off and user
> specifies metacopy=on, it goes back to metacopy=off and a warning is
> printed.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/Kconfig     |  9 +++++++++
>  fs/overlayfs/ovl_entry.h |  1 +
>  fs/overlayfs/super.c     | 32 ++++++++++++++++++++++++++++++++
>  3 files changed, 42 insertions(+)
>
> diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
> index cbfc196e5dc5..94d4c61719c8 100644
> --- a/fs/overlayfs/Kconfig
> +++ b/fs/overlayfs/Kconfig
> @@ -43,3 +43,12 @@ config OVERLAY_FS_INDEX
>           outcomes.  However, mounting the same overlay with an old kernel
>           read-write and then mounting it again with a new kernel, will have
>           unexpected results.
> +
> +config OVERLAY_FS_METACOPY
> +       bool "Overlayfs: turn on metadata only copy up feature by default"
> +       depends on OVERLAY_FS
> +       depends on OVERLAY_FS_INDEX
> +       help
> +         If this config option is enabled then overlay filesystems will
> +         copy up only metadata where appropriate and data copy up will
> +         happen when a file is opended for WRITE operation.
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 878a750986dd..a49f61111c79 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -15,6 +15,7 @@ struct ovl_config {
>         bool default_permissions;
>         bool redirect_dir;
>         bool index;
> +       bool metacopy;
>  };
>
>  /* private information held for overlayfs's superblock */
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index fd5ea4facc62..338fb0c3d345 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -39,6 +39,11 @@ module_param_named(index, ovl_index_def, bool, 0644);
>  MODULE_PARM_DESC(ovl_index_def,
>                  "Default to on or off for the inodes index feature");
>
> +static bool ovl_metacopy_def = IS_ENABLED(CONFIG_OVERLAY_FS_METACOPY);
> +module_param_named(metacopy, ovl_metacopy_def, bool, 0644);
> +MODULE_PARM_DESC(ovl_metacopy_def,
> +                "Default to on or off for the metadata only copy up feature");
> +
>  static void ovl_dentry_release(struct dentry *dentry)
>  {
>         struct ovl_entry *oe = dentry->d_fsdata;
> @@ -302,6 +307,9 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>         if (ufs->config.index != ovl_index_def)
>                 seq_printf(m, ",index=%s",
>                            ufs->config.index ? "on" : "off");
> +       if (ufs->config.metacopy != ovl_metacopy_def)
> +               seq_printf(m, ",metacopy=%s",
> +                          ufs->config.metacopy ? "on" : "off");
>         return 0;
>  }
>
> @@ -335,6 +343,8 @@ enum {
>         OPT_REDIRECT_DIR_OFF,
>         OPT_INDEX_ON,
>         OPT_INDEX_OFF,
> +       OPT_METACOPY_ON,
> +       OPT_METACOPY_OFF,
>         OPT_ERR,
>  };
>
> @@ -347,6 +357,8 @@ static const match_table_t ovl_tokens = {
>         {OPT_REDIRECT_DIR_OFF,          "redirect_dir=off"},
>         {OPT_INDEX_ON,                  "index=on"},
>         {OPT_INDEX_OFF,                 "index=off"},
> +       {OPT_METACOPY_ON,               "metacopy=on"},
> +       {OPT_METACOPY_OFF,              "metacopy=off"},
>         {OPT_ERR,                       NULL}
>  };
>
> @@ -427,6 +439,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>                         config->index = false;
>                         break;
>
> +               case OPT_METACOPY_ON:
> +                       config->metacopy = true;
> +                       break;
> +
> +               case OPT_METACOPY_OFF:
> +                       config->metacopy = false;
> +                       break;
> +
>                 default:
>                         pr_err("overlayfs: unrecognized mount option \"%s\" or missing value\n", p);
>                         return -EINVAL;
> @@ -441,6 +461,12 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>                 config->workdir = NULL;
>         }
>
> +       /* As of now metacopy=on is dependent on index=on */
> +       if (config->metacopy && !config->index) {
> +               pr_warn("overlayfs: can not enable metadata only copyup with index=off. Falling back to metacopy=off\n");
> +               config->metacopy = false;
> +       }
> +

There are later places in fill_super where index may be falling back to off
due to missing file handle support in lower fs.
Please move this check to much later to make sure metacopy=on and index=off
cannot co-exists.

Thanks,
Amir.
