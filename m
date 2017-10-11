From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 3/9] ovl: Provide a mount option metacopy=on/off for
 metadata copyup
Date: Wed, 11 Oct 2017 04:36:46 +0300
Message-ID: <CAOQ4uxiU6BNrwKnfx1ToY4ZARV8X4S6HRNmfhCmaON=+46B7bg@mail.gmail.com>
References: <1507649544-4539-1-git-send-email-vgoyal@redhat.com> <1507649544-4539-4-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:37351 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751156AbdJKBgr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 10 Oct 2017 21:36:47 -0400
Received: by mail-qt0-f193.google.com with SMTP id 32so509357qtp.4
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Oct 2017 18:36:47 -0700 (PDT)
In-Reply-To: <1507649544-4539-4-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, "Eric W. Biederman" <ebiederm@xmission.com>

On Tue, Oct 10, 2017 at 6:32 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> By default metadata only copy up is disabled. Provide a mount option so
> that users can choose one way or other.
>
> Also metadata copyup is conditional on index=on. If index=off and user
> specifies metacopy=on, it goes back to metacopy=off and a warning is
> printed.
>

So this commit does not explain why the features are dependent
And when I think about it again, they should not be dependent.

I had several arguments for having metacopy rely on index, but
You shot down the idea to index all regular files for performance
Of index cleanup on mount.

Now the only remaining reason is not setting same origin for
Broken upper hardlinks when index is off, the solution should
Be to not metacopy lower hardlinks when index is off.
IMO it's a minor trade-off for keeping the features independent.

> Also provide a kernel config and module option to enable/disable
> metacopy feature.
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
> index 25d9b5adcd42..6806f0b0fbc2 100644
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
> index 092d150643c1..6f4c32e49298 100644
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
> @@ -303,6 +308,9 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>         if (ufs->config.index != ovl_index_def)
>                 seq_printf(m, ",index=%s",
>                            ufs->config.index ? "on" : "off");
> +       if (ufs->config.metacopy != ovl_metacopy_def)
> +               seq_printf(m, ",metacopy=%s",
> +                          ufs->config.metacopy ? "on" : "off");
>         return 0;
>  }
>
> @@ -336,6 +344,8 @@ enum {
>         OPT_REDIRECT_DIR_OFF,
>         OPT_INDEX_ON,
>         OPT_INDEX_OFF,
> +       OPT_METACOPY_ON,
> +       OPT_METACOPY_OFF,
>         OPT_ERR,
>  };
>
> @@ -348,6 +358,8 @@ static const match_table_t ovl_tokens = {
>         {OPT_REDIRECT_DIR_OFF,          "redirect_dir=off"},
>         {OPT_INDEX_ON,                  "index=on"},
>         {OPT_INDEX_OFF,                 "index=off"},
> +       {OPT_METACOPY_ON,               "metacopy=on"},
> +       {OPT_METACOPY_OFF,              "metacopy=off"},
>         {OPT_ERR,                       NULL}
>  };
>
> @@ -428,6 +440,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
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
> @@ -847,6 +867,12 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>
>         ufs->config.redirect_dir = ovl_redirect_dir_def;
>         ufs->config.index = ovl_index_def;
> +       if (ovl_metacopy_def && !ovl_index_def) {
> +               pr_warn("overlayfs: metadata copy up can not be enabled by default as index feature is not enabled by default.\n");
> +               ovl_metacopy_def = false;
> +       }
> +       ufs->config.metacopy = ovl_metacopy_def;
> +
>         err = ovl_parse_opt((char *) data, &ufs->config);
>         if (err)
>                 goto out_free_config;
> @@ -1091,6 +1117,12 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>         if (!ufs->indexdir)
>                 ufs->config.index = false;
>
> +       /* As of now metacopy=on is dependent on index=on */
> +       if (ufs->config.metacopy && !ufs->config.index) {
> +               pr_warn("overlayfs: can not enable metadata only copyup with index=off. Falling back to metacopy=off\n");
> +               ufs->config.metacopy = false;
> +       }
> +
>         if (remote)
>                 sb->s_d_op = &ovl_reval_dentry_operations;
>         else
> --
> 2.13.5
>
