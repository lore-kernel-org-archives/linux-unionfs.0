From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 06/23] ovl: add support for "verify" feature
Date: Tue, 9 Jan 2018 10:16:52 +0100
Message-ID: <CAJfpegvsb66k4hhFQfg5vdMRJyA8kqMypOPwaf=C0DeF+2w5ew@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com> <1515084018-25134-7-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:34360 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbeAIJQx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Jan 2018 04:16:53 -0500
Received: by mail-qt0-f196.google.com with SMTP id 33so16987751qtv.1
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Jan 2018 01:16:53 -0800 (PST)
In-Reply-To: <1515084018-25134-7-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Jan 4, 2018 at 5:40 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Introduce the "verify" config, module and mount options.
>
> If the "verify" feature is enabled then overlay filesystems will use
> the inodes index dir to verify layers consistency.
>
> It is possible to enable consistency verification by default during
> build time with the OVERLAY_FS_VERIFY config option, during runtime
> with the "verify=on" module option or on a filesystem instance basis
> with the "verify=on" mount option.
>
> The "verify" feature will prevent multiple redirects to the same lower
> dir and will prevent broken hardlinks from using the same inode number.
>
> On an overlay filesystem instance with multiple lower layers, "verify"
> feature can only use the index to prevent multiple redirects from upper
> dirs and not from middle layer dirs. Emit a warning about this on mount
> with multiple lower layers and "verify=on".

Could the above go into Documentation/filesystems/overlayfs.txt as well?

Also, the verify feature does have some overhead, which should also be
noted in the documentation.  Do you have some measurements about how
much impact it has on performance?

Thanks,
Miklos


>
> This is going to be used for NFS export.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/Kconfig     | 18 ++++++++++++++++++
>  fs/overlayfs/overlayfs.h |  1 +
>  fs/overlayfs/ovl_entry.h |  1 +
>  fs/overlayfs/super.c     | 49 +++++++++++++++++++++++++++++++++++++++++-------
>  fs/overlayfs/util.c      |  7 +++++++
>  5 files changed, 69 insertions(+), 7 deletions(-)
>
> diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
> index 5ac415466861..0e4764ed4e23 100644
> --- a/fs/overlayfs/Kconfig
> +++ b/fs/overlayfs/Kconfig
> @@ -53,3 +53,21 @@ config OVERLAY_FS_INDEX
>           outcomes.  However, mounting the same overlay with an old kernel
>           read-write and then mounting it again with a new kernel, will have
>           unexpected results.
> +
> +config OVERLAY_FS_VERIFY
> +       bool "Overlayfs: turn on verify feature by default"
> +       depends on OVERLAY_FS
> +       depends on OVERLAY_FS_INDEX
> +       help
> +         If this config option is enabled then overlay filesystems will use
> +         the inodes index dir to verify layers consistency by default.
> +         In this case, it is still possible to turn off consistency
> +         verification globally with the "verify=off" module option or on a
> +         filesystem instance basis with the "verify=off" mount option.
> +
> +         The verify feature prevents multiple redirects to the same lower dir
> +         and prevents broken hardlinks from using the same inode number.
> +
> +         Note, that verify feature is not backward compatible.  That is,
> +         mounting an overlay with verification index entries on a kernel
> +         that doesn't support this feature will have unexpected results.
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index d55afb6646b0..379bb349acc4 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -194,6 +194,7 @@ const struct cred *ovl_override_creds(struct super_block *sb);
>  struct super_block *ovl_same_sb(struct super_block *sb);
>  bool ovl_can_decode_fh(struct super_block *sb);
>  struct dentry *ovl_indexdir(struct super_block *sb);
> +bool ovl_verify(struct super_block *sb);
>  struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
>  bool ovl_dentry_remote(struct dentry *dentry);
>  bool ovl_dentry_weird(struct dentry *dentry);
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 608e48755070..c886ed743a8a 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -17,6 +17,7 @@ struct ovl_config {
>         bool redirect_follow;
>         const char *redirect_mode;
>         bool index;
> +       bool verify;
>  };
>
>  struct ovl_layer {
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 994d35628acf..96136528861f 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -45,6 +45,11 @@ module_param_named(index, ovl_index_def, bool, 0644);
>  MODULE_PARM_DESC(ovl_index_def,
>                  "Default to on or off for the inodes index feature");
>
> +static bool ovl_verify_def = IS_ENABLED(CONFIG_OVERLAY_FS_VERIFY);
> +module_param_named(verify, ovl_verify_def, bool, 0644);
> +MODULE_PARM_DESC(ovl_verify_def,
> +                "Default to on or off for the verify feature");
> +
>  static void ovl_entry_stack_free(struct ovl_entry *oe)
>  {
>         unsigned int i;
> @@ -341,6 +346,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>                 seq_printf(m, ",redirect_dir=%s", ofs->config.redirect_mode);
>         if (ofs->config.index != ovl_index_def)
>                 seq_printf(m, ",index=%s", ofs->config.index ? "on" : "off");
> +       if (ofs->config.verify != ovl_verify_def)
> +               seq_printf(m, ",verify=%s", ofs->config.verify ? "on" : "off");
>         return 0;
>  }
>
> @@ -373,6 +380,8 @@ enum {
>         OPT_REDIRECT_DIR,
>         OPT_INDEX_ON,
>         OPT_INDEX_OFF,
> +       OPT_VERIFY_ON,
> +       OPT_VERIFY_OFF,
>         OPT_ERR,
>  };
>
> @@ -384,6 +393,8 @@ static const match_table_t ovl_tokens = {
>         {OPT_REDIRECT_DIR,              "redirect_dir=%s"},
>         {OPT_INDEX_ON,                  "index=on"},
>         {OPT_INDEX_OFF,                 "index=off"},
> +       {OPT_VERIFY_ON,                 "verify=on"},
> +       {OPT_VERIFY_OFF,                "verify=off"},
>         {OPT_ERR,                       NULL}
>  };
>
> @@ -487,7 +498,19 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>                         break;
>
>                 case OPT_INDEX_OFF:
> +                       /* verify depends on index */
>                         config->index = false;
> +                       config->verify = false;
> +                       break;
> +
> +               case OPT_VERIFY_ON:
> +                       /* verify depends on index */
> +                       config->index = true;
> +                       config->verify = true;
> +                       break;
> +
> +               case OPT_VERIFY_OFF:
> +                       config->verify = false;
>                         break;
>
>                 default:
> @@ -504,9 +527,11 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>                         kfree(config->workdir);
>                         config->workdir = NULL;
>                 }
> -               if (config->index != ovl_index_def) {
> -                       pr_info("overlayfs: option \"index\" is useless in a non-upper mount, ignore\n");
> +               if (config->index != ovl_index_def ||
> +                   config->verify != ovl_verify_def) {
> +                       pr_info("overlayfs: options \"index\" and \"verify\" are useless in a non-upper mount, ignore\n");
>                         config->index = ovl_index_def;
> +                       config->verify = ovl_verify_def;
>                 }
>         }
>
> @@ -707,7 +732,9 @@ static int ovl_lower_dir(const char *name, struct path *path,
>         if (ofs->config.upperdir && ofs->config.index &&
>             !ovl_can_decode_fh(path->dentry->d_sb)) {
>                 ofs->config.index = false;
> -               pr_warn("overlayfs: fs on '%s' does not support file handles, falling back to index=off.\n", name);
> +               ofs->config.verify = false;
> +               pr_warn("overlayfs: fs on '%s' does not support file handles, falling back to index=off,verify=off.\n",
> +                       name);
>         }
>
>         return 0;
> @@ -975,7 +1002,8 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
>         if (err) {
>                 ofs->noxattr = true;
>                 ofs->config.index = false;
> -               pr_warn("overlayfs: upper fs does not support xattr, falling back to index=off.\n");
> +               ofs->config.verify = false;
> +               pr_warn("overlayfs: upper fs does not support xattr, falling back to index=off,verify=off.\n");
>                 err = 0;
>         } else {
>                 vfs_removexattr(ofs->workdir, OVL_XATTR_OPAQUE);
> @@ -985,7 +1013,8 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
>         if (ofs->config.index &&
>             !ovl_can_decode_fh(ofs->workdir->d_sb)) {
>                 ofs->config.index = false;
> -               pr_warn("overlayfs: upper fs does not support file handles, falling back to index=off.\n");
> +               ofs->config.verify = false;
> +               pr_warn("overlayfs: upper fs does not support file handles, falling back to index=off,verify=off.\n");
>         }
>
>  out:
> @@ -1146,6 +1175,8 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
>         } else if (!ofs->config.upperdir && stacklen == 1) {
>                 pr_err("overlayfs: at least 2 lowerdir are needed while upperdir nonexistent\n");
>                 goto out_err;
> +       } else if (ofs->config.verify && ofs->config.upperdir && stacklen > 1) {
> +               pr_warn("overlayfs: option 'verify=on' cannot verify redirects from middle layer dirs\n");
>         }
>
>         err = -ENOMEM;
> @@ -1222,6 +1253,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>                 goto out_err;
>
>         ofs->config.index = ovl_index_def;
> +       /* verify depends on index */
> +       ofs->config.verify = ovl_verify_def && ovl_index_def;
>         err = ovl_parse_opt((char *) data, &ofs->config);
>         if (err)
>                 goto out_err;
> @@ -1276,9 +1309,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>                         sb->s_flags |= SB_RDONLY;
>         }
>
> -       /* Show index=off/on in /proc/mounts for any of the reasons above */
> -       if (!ofs->indexdir)
> +       /* Show index=off,verify=off in /proc/mounts if no indexdir */
> +       if (!ofs->indexdir) {
>                 ofs->config.index = false;
> +               ofs->config.verify = false;
> +       }
>
>         /* Never override disk quota limits or use reserved space */
>         cap_lower(cred->cap_effective, CAP_SYS_RESOURCE);
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index d6bb1c9f5e7a..fb0b561b0568 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -63,6 +63,13 @@ struct dentry *ovl_indexdir(struct super_block *sb)
>         return ofs->indexdir;
>  }
>
> +bool ovl_verify(struct super_block *sb)
> +{
> +       struct ovl_fs *ofs = sb->s_fs_info;
> +
> +       return ofs->config.verify && ofs->config.index;
> +}
> +
>  struct ovl_entry *ovl_alloc_entry(unsigned int numlower)
>  {
>         size_t size = offsetof(struct ovl_entry, lowerstack[numlower]);
> --
> 2.7.4
>
