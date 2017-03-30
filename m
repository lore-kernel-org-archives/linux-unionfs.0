From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 5/6] ovl: copy on read with consistent_fd feature
Date: Thu, 30 Mar 2017 14:28:37 +0300
Message-ID: <CAOQ4uxhMLrTxNUuG=iY03-VfcJ4TAXA7xQ9-NLhcLkv=WAUj5w@mail.gmail.com>
References: <1490798166-22310-1-git-send-email-amir73il@gmail.com> <1490798166-22310-6-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35256 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932638AbdC3L2j (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 30 Mar 2017 07:28:39 -0400
Received: by mail-oi0-f66.google.com with SMTP id y7so3364038oiy.2
        for <linux-unionfs@vger.kernel.org>; Thu, 30 Mar 2017 04:28:38 -0700 (PDT)
In-Reply-To: <1490798166-22310-6-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

On Wed, Mar 29, 2017 at 5:36 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Overlayfs copies up a file when the file is opened for write.  Writes
> to the returned file descriptor are not visible to file descriptors
> that were opened for read prior to copy up.
>
> If this config option is enabled then overlay filesystems will default
> to copy up a file that is opened for read to avoid this inconsistency.
> In this case, it is still possible to turn off consistent fd globally
> with the "consistent_fd=off" module option or on a filesystem instance
> basis with the "consistent_fd=off" mount option.
>
> The feature will not be turned on for an overlay mount unless all
> the layers are on the same underlying filesystem and this filesystem
> supports clone.
>
> This introduces a slight change in d_real() semantics. Now d_real()
> may return an error with NULL inode argument also in the zero open
> flags case. vfs API documentation has been updated.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  Documentation/filesystems/vfs.txt | 13 ++++++-------
>  fs/overlayfs/Kconfig              | 18 ++++++++++++++++++
>  fs/overlayfs/inode.c              | 27 ++++++++++++++++-----------
>  fs/overlayfs/overlayfs.h          |  4 +++-
>  fs/overlayfs/ovl_entry.h          |  2 ++
>  fs/overlayfs/super.c              | 37 +++++++++++++++++++++++++++++++++----
>  fs/overlayfs/util.c               |  7 +++++++
>  7 files changed, 85 insertions(+), 23 deletions(-)
>
> diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
> index 5692117..0dd317b 100644
> --- a/Documentation/filesystems/vfs.txt
> +++ b/Documentation/filesystems/vfs.txt
> @@ -1088,22 +1088,21 @@ struct dentry_operations {
>         dentry being transited from.
>
>    d_real: overlay/union type filesystems implement this method to return one of
> -       the underlying dentries hidden by the overlay.  It is used in three
> +       the underlying dentries hidden by the overlay.  It is used in two
>         different modes:
>
>         Called from open it may need to copy-up the file depending on the
> -       supplied open flags.  This mode is selected with a non-zero flags
> -       argument.  In this mode the d_real method can return an error.
> +       supplied open flags.  It returns the upper real dentry if file was
> +       copied up or the topmost real underlying dentry otherwise.
> +       This mode is selected with a NULL inode argument.
> +       In this mode the d_real method can return an error.
>
>         Called from file_dentry() it returns the real dentry matching the inode
>         argument.  The real dentry may be from a lower layer already copied up,
>         but still referenced from the file.  This mode is selected with a
>         non-NULL inode argument.  This will always succeed.
>
> -       With NULL inode and zero flags the topmost real underlying dentry is
> -       returned.  This will always succeed.
> -
> -       This method is never called with both non-NULL inode and non-zero flags.
> +       This method is never called with non-NULL inode and non-zero open flags.
>
>  Each dentry has a pointer to its parent dentry, as well as a hash list
>  of child dentries. Child dentries are basically like files in a
> diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
> index 0daac51..7425862 100644
> --- a/fs/overlayfs/Kconfig
> +++ b/fs/overlayfs/Kconfig
> @@ -22,3 +22,21 @@ config OVERLAY_FS_REDIRECT_DIR
>           Note, that redirects are not backward compatible.  That is, mounting
>           an overlay which has redirects on a kernel that doesn't support this
>           feature will have unexpected results.
> +
> +config OVERLAY_FS_CONSISTENT_FD
> +       bool "Overlayfs: turn on consistent fd feature by default"
> +       depends on OVERLAY_FS
> +       help
> +         Overlayfs copies up a file when the file is opened for write.  Writes
> +          to the returned file descriptor are not visible to file descriptors
> +          that were opened for read prior to copy up.
> +
> +          If this config option is enabled then overlay filesystems will default
> +          to copy up a file that is opened for read to avoid this inconsistency.
> +          In this case, it is still possible to turn off consistent fd globally
> +          with the "consistent_fd=off" module option or on a filesystem instance
> +          basis with the "consistent_fd=off" mount option.
> +
> +          The feature will not be turned on for an overlay mount unless all
> +          the layers are on the same underlying filesystem and this filesystem
> +          supports clone.
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 17b8418..f2f55e1 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -231,7 +231,7 @@ struct posix_acl *ovl_get_acl(struct inode *inode, int type)
>  }
>
>  static bool ovl_open_need_copy_up(int flags, enum ovl_path_type type,
> -                                 struct dentry *realdentry)
> +                                 struct dentry *realdentry, bool rocopyup)
>  {
>         if (OVL_TYPE_UPPER(type))
>                 return false;
> @@ -239,25 +239,30 @@ static bool ovl_open_need_copy_up(int flags, enum ovl_path_type type,
>         if (special_file(realdentry->d_inode->i_mode))
>                 return false;
>
> +       /* Copy up on open for read for consistent fd */
> +       if (rocopyup)
> +               return true;
> +
>         if (!(OPEN_FMODE(flags) & FMODE_WRITE) && !(flags & O_TRUNC))
>                 return false;
>
>         return true;
>  }
>
> -int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags)
> +int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags,
> +                          bool rocopyup)
>  {
>         int err = 0;
>         struct path realpath;
> -       enum ovl_path_type type;
> -
> -       type = ovl_path_real(dentry, &realpath);
> -       if (ovl_open_need_copy_up(file_flags, type, realpath.dentry)) {
> -               err = ovl_want_write(dentry);
> -               if (!err) {
> -                       err = ovl_copy_up_flags(dentry, file_flags);
> -                       ovl_drop_write(dentry);
> -               }
> +       enum ovl_path_type type = ovl_path_real(dentry, &realpath);
> +
> +       if (!ovl_open_need_copy_up(file_flags, type, realpath.dentry, rocopyup))
> +               return 0;
> +
> +       err = ovl_want_write(dentry);
> +       if (!err) {
> +               err = ovl_copy_up_flags(dentry, file_flags);
> +               ovl_drop_write(dentry);
>         }
>
>         return err;
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 079051e..d13ad5f 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -169,6 +169,7 @@ void ovl_set_dir_cache(struct dentry *dentry, struct ovl_dir_cache *cache);
>  bool ovl_dentry_is_opaque(struct dentry *dentry);
>  bool ovl_dentry_is_whiteout(struct dentry *dentry);
>  void ovl_dentry_set_opaque(struct dentry *dentry);
> +bool ovl_consistent_fd(struct super_block *sb);
>  bool ovl_redirect_dir(struct super_block *sb);
>  void ovl_clear_redirect_dir(struct super_block *sb);
>  const char *ovl_dentry_get_redirect(struct dentry *dentry);
> @@ -207,7 +208,8 @@ int ovl_xattr_get(struct dentry *dentry, const char *name,
>                   void *value, size_t size);
>  ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size);
>  struct posix_acl *ovl_get_acl(struct inode *inode, int type);
> -int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
> +int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags,
> +                          bool rocopyup);
>  int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
>  bool ovl_is_private_xattr(const char *name);
>
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index fb1210d..c11a72d 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -14,6 +14,7 @@ struct ovl_config {
>         char *workdir;
>         bool default_permissions;
>         bool redirect_dir;
> +       bool consistent_fd;
>  };
>
>  /* private information held for overlayfs's superblock */
> @@ -30,6 +31,7 @@ struct ovl_fs {
>         bool tmpfile;   /* upper supports O_TMPFILE */
>         bool samefs;    /* all layers on same fs */
>         bool cloneup;   /* can clone from lower to upper */
> +       bool rocopyup;  /* copy up on open for read */
>         wait_queue_head_t copyup_wq;
>  };
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 75b93d6..e5fd53a 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -34,6 +34,11 @@ module_param_named(redirect_dir, ovl_redirect_dir_def, bool, 0644);
>  MODULE_PARM_DESC(ovl_redirect_dir_def,
>                  "Default to on or off for the redirect_dir feature");
>
> +static bool ovl_consistent_fd_def = IS_ENABLED(CONFIG_OVERLAY_FS_CONSISTENT_FD);
> +module_param_named(consistent_fd, ovl_consistent_fd_def, bool, 0644);
> +MODULE_PARM_DESC(ovl_consistent_fd_def,
> +                "Default to on or off for the consistent_fd feature");
> +
>  static void ovl_dentry_release(struct dentry *dentry)
>  {
>         struct ovl_entry *oe = dentry->d_fsdata;
> @@ -54,6 +59,10 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
>                                  unsigned int open_flags)
>  {
>         struct dentry *real;
> +       bool rocopyup = !inode && ovl_consistent_fd(dentry->d_sb);
> +
> +       if (WARN_ON(open_flags && inode))
> +               return dentry;
>
>         if (!d_is_reg(dentry)) {
>                 if (!inode || inode == d_inode(dentry))
> @@ -64,8 +73,8 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
>         if (d_is_negative(dentry))
>                 return dentry;
>
> -       if (open_flags) {
> -               int err = ovl_open_maybe_copy_up(dentry, open_flags);
> +       if (open_flags || rocopyup) {
> +               int err = ovl_open_maybe_copy_up(dentry, open_flags, rocopyup);
>
>                 if (err)
>                         return ERR_PTR(err);
> @@ -227,6 +236,10 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>         if (ufs->config.redirect_dir != ovl_redirect_dir_def)
>                 seq_printf(m, ",redirect_dir=%s",
>                            ufs->config.redirect_dir ? "on" : "off");
> +       if (!(sb->s_flags & MS_RDONLY) &&
> +           ufs->config.consistent_fd != ovl_consistent_fd_def)
> +               seq_printf(m, ",consistent_fd=%s",
> +                          ufs->config.consistent_fd ? "on" : "off");
>         return 0;
>  }
>
> @@ -256,6 +269,8 @@ enum {
>         OPT_DEFAULT_PERMISSIONS,
>         OPT_REDIRECT_DIR_ON,
>         OPT_REDIRECT_DIR_OFF,
> +       OPT_CONSISTENT_FD_ON,
> +       OPT_CONSISTENT_FD_OFF,
>         OPT_ERR,
>  };
>
> @@ -266,6 +281,8 @@ static const match_table_t ovl_tokens = {
>         {OPT_DEFAULT_PERMISSIONS,       "default_permissions"},
>         {OPT_REDIRECT_DIR_ON,           "redirect_dir=on"},
>         {OPT_REDIRECT_DIR_OFF,          "redirect_dir=off"},
> +       {OPT_CONSISTENT_FD_ON,          "consistent_fd=on"},
> +       {OPT_CONSISTENT_FD_OFF,         "consistent_fd=off"},
>         {OPT_ERR,                       NULL}
>  };
>
> @@ -338,6 +355,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>                         config->redirect_dir = false;
>                         break;
>
> +               case OPT_CONSISTENT_FD_ON:
> +                       config->consistent_fd = true;
> +                       break;
> +
> +               case OPT_CONSISTENT_FD_OFF:
> +                       config->consistent_fd = false;
> +                       break;
> +
>                 default:
>                         pr_err("overlayfs: unrecognized mount option \"%s\" or missing value\n", p);
>                         return -EINVAL;
> @@ -732,6 +757,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>
>         init_waitqueue_head(&ufs->copyup_wq);
>         ufs->config.redirect_dir = ovl_redirect_dir_def;
> +       ufs->config.consistent_fd = ovl_consistent_fd_def;
>         err = ovl_parse_opt((char *) data, &ufs->config);
>         if (err)
>                 goto out_free_config;
> @@ -862,11 +888,10 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>                         if (!err)
>                                 pr_warn("overlayfs: upper fs needs to support d_type.\n");
>
> -                       /* Check if upper/work fs supports O_TMPFILE */
> +                       /* Check if upper fs supports O_TMPFILE and clone */
>                         temp = ovl_do_tmpfile(ufs->workdir, S_IFREG | 0);
>                         ufs->tmpfile = !IS_ERR(temp);
>                         if (ufs->tmpfile) {
> -                               /* Check if upper/work supports clone */
>                                 if (temp->d_inode && temp->d_inode->i_fop &&
>                                     temp->d_inode->i_fop->clone_file_range)
>                                         ufs->cloneup = true;
> @@ -910,6 +935,10 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>         if (!ufs->upper_mnt)
>                 sb->s_flags |= MS_RDONLY;
>
> +       /* Copy on read for consistent fd depends on clone support */
> +       if (!ufs->cloneup)

I missed || (sb->s_flags & MS_RDONLY) here. posted patch 7/7 with
fix to ro mount + some other changes.

> +               ufs->config.consistent_fd = false;
> +
>         if (remote)
>                 sb->s_d_op = &ovl_reval_dentry_operations;
>         else
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 159e851..be0a993 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -195,6 +195,13 @@ void ovl_dentry_set_opaque(struct dentry *dentry)
>         oe->__type |= __OVL_PATH_OPAQUE;
>  }
>
> +bool ovl_consistent_fd(struct super_block *sb)
> +{
> +       struct ovl_fs *ofs = sb->s_fs_info;
> +
> +       return ofs->config.consistent_fd;
> +}
> +
>  bool ovl_redirect_dir(struct super_block *sb)
>  {
>         struct ovl_fs *ofs = sb->s_fs_info;
> --
> 2.7.4
>
