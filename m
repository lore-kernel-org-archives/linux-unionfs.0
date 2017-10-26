From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 07/13] ovl: A new xattr OVL_XATTR_METACOPY for file on upper
Date: Thu, 26 Oct 2017 09:04:17 +0300
Message-ID: <CAOQ4uxjPvaUN_OK2dB0zZT1pru38vSTgPrZr3YihWgoUr4d=qw@mail.gmail.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com> <1508958575-14086-8-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:54033 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbdJZGES (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Oct 2017 02:04:18 -0400
Received: by mail-yw0-f196.google.com with SMTP id q126so1989865ywq.10
        for <linux-unionfs@vger.kernel.org>; Wed, 25 Oct 2017 23:04:18 -0700 (PDT)
In-Reply-To: <1508958575-14086-8-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 25, 2017 at 10:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Now we will have the capability to have upper inodes which might be only
> metadata copy up and data is still on lower inode. So add a new xattr
> OVL_XATTR_METACOPY to distinguish between two cases.
>
> Presence of OVL_XATTR_METACOPY reflects that file has been copied up metadata
> only and and data will be copied up later from lower origin.
> So this xattr is set when a metadata copy takes place and cleared when
> data copy takes place.
>
> We also use a bit in ovl_inode->flags to cache OVL_UPPERDATA which reflects
> whether ovl inode has data or not (as opposed to metadata only copy up).
>
> Note, OVL_UPPERDATA is set only on those upper inodes which can possibly
> be metacopy only inodes. For example, inode should be a regular file and
> there needs to be a lower dentry.

Why? is it not simpler and better for readability to set it in all
cases except metacopy?
Doesn't matter much, but seems to me that code will look better.
That is not to say you don't need a helper "should I check the flag".

>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/copy_up.c   | 55 +++++++++++++++++++++++++++++++++++++++++++++---
>  fs/overlayfs/inode.c     |  3 ++-
>  fs/overlayfs/overlayfs.h |  6 +++++-
>  fs/overlayfs/util.c      | 34 ++++++++++++++++++++++++++++--
>  4 files changed, 91 insertions(+), 7 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 2936284..a6cda02 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -196,6 +196,16 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
>         return error;
>  }
>
> +static int ovl_set_size(struct dentry *upperdentry, struct kstat *stat)
> +{
> +       struct iattr attr = {
> +               .ia_valid = ATTR_SIZE,
> +               .ia_size = stat->size,
> +       };
> +
> +       return notify_change(upperdentry, &attr, NULL);
> +}
> +
>  static int ovl_set_timestamps(struct dentry *upperdentry, struct kstat *stat)
>  {
>         struct iattr attr = {
> @@ -439,6 +449,28 @@ static int ovl_get_tmpfile(struct ovl_copy_up_ctx *c, struct dentry **tempp)
>         goto out;
>  }
>
> +/* Copy up data of an inode which was copied up metadata only in the past. */
> +static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
> +{
> +       struct path upperpath;
> +       int err;
> +
> +       ovl_path_upper(c->dentry, &upperpath);
> +       if (WARN_ON(upperpath.dentry == NULL))
> +               return -EIO;
> +
> +       err = ovl_copy_up_data(&c->lowerpath, &upperpath, c->stat.size);
> +       if (err)
> +               return err;
> +
> +       err= vfs_removexattr(upperpath.dentry, OVL_XATTR_METACOPY);
> +       if (err)
> +               return err;
> +
> +       ovl_set_flag(OVL_UPPERDATA, d_inode(c->dentry));
> +       return err;
> +}
> +
>  static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
>  {
>         int err;
> @@ -474,8 +506,19 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
>                         return err;
>         }
>
> +       if (c->metacopy) {
> +               err = ovl_check_setxattr(c->dentry, temp, OVL_XATTR_METACOPY,
> +                                        NULL, 0, -EOPNOTSUPP);
> +               if (err)
> +                       return err;
> +       }
> +
> +
>         inode_lock(temp->d_inode);
> -       err = ovl_set_attr(temp, &c->stat);
> +       if (c->metacopy)
> +               err = ovl_set_size(temp, &c->stat);
> +       if (!err)
> +               err = ovl_set_attr(temp, &c->stat);
>         inode_unlock(temp->d_inode);
>
>         return err;
> @@ -506,6 +549,8 @@ static int ovl_copy_up_locked(struct ovl_copy_up_ctx *c)
>         if (err)
>                 goto out_cleanup;
>
> +       if (!c->metacopy && S_ISREG(d_inode(c->dentry)->i_mode))
> +               ovl_set_flag(OVL_UPPERDATA, d_inode(c->dentry));
>         ovl_inode_update(d_inode(c->dentry), newdentry);
>  out:
>         dput(temp);
> @@ -632,7 +677,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
>         }
>         ovl_do_check_copy_up(ctx.lowerpath.dentry);
>
> -       err = ovl_copy_up_start(dentry);
> +       err = ovl_copy_up_start(dentry, flags);
>         /* err < 0: interrupted, err > 0: raced with another copy-up */
>         if (unlikely(err)) {
>                 if (err > 0)
> @@ -642,6 +687,8 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
>                         err = ovl_do_copy_up(&ctx);
>                 if (!err && !ovl_dentry_has_upper_alias(dentry))
>                         err = ovl_link_up(&ctx);
> +               if (!err && ovl_dentry_needs_data_copy_up(dentry, flags))
> +                       err = ovl_copy_up_meta_inode_data(&ctx);
>                 ovl_copy_up_end(dentry);
>         }
>         do_delayed_call(&done);
> @@ -672,8 +719,10 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
>                  *      with rename.
>                  */
>                 if (ovl_dentry_upper(dentry) &&
> -                   ovl_dentry_has_upper_alias(dentry))
> +                   ovl_dentry_has_upper_alias(dentry) &&
> +                   !ovl_dentry_needs_data_copy_up(dentry, flags)) {
>                         break;
> +               }
>
>                 next = dget(dentry);
>                 /* find the topmost dentry not yet copied up */
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 321511e..1b4b42c 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -320,7 +320,8 @@ struct posix_acl *ovl_get_acl(struct inode *inode, int type)
>  static bool ovl_open_need_copy_up(struct dentry *dentry, int flags)
>  {
>         if (ovl_dentry_upper(dentry) &&
> -           ovl_dentry_has_upper_alias(dentry))
> +           ovl_dentry_has_upper_alias(dentry) &&
> +           !ovl_dentry_needs_data_copy_up(dentry, flags))
>                 return false;
>
>         if (special_file(d_inode(dentry)->i_mode))
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index d9a0edd..714abf9 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -26,10 +26,12 @@ enum ovl_path_type {
>  #define OVL_XATTR_ORIGIN OVL_XATTR_PREFIX "origin"
>  #define OVL_XATTR_IMPURE OVL_XATTR_PREFIX "impure"
>  #define OVL_XATTR_NLINK OVL_XATTR_PREFIX "nlink"
> +#define OVL_XATTR_METACOPY OVL_XATTR_PREFIX "metacopy"
>
>  enum ovl_flag {
>         OVL_IMPURE,
>         OVL_INDEX,
> +       OVL_UPPERDATA,
>  };
>
>  /*
> @@ -211,6 +213,8 @@ bool ovl_dentry_is_whiteout(struct dentry *dentry);
>  void ovl_dentry_set_opaque(struct dentry *dentry);
>  bool ovl_dentry_has_upper_alias(struct dentry *dentry);
>  void ovl_dentry_set_upper_alias(struct dentry *dentry);
> +bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags);
> +bool ovl_dentry_check_upperdata(struct dentry *dentry);
>  bool ovl_redirect_dir(struct super_block *sb);
>  const char *ovl_dentry_get_redirect(struct dentry *dentry);
>  void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
> @@ -221,7 +225,7 @@ void ovl_dentry_version_inc(struct dentry *dentry, bool impurity);
>  u64 ovl_dentry_version_get(struct dentry *dentry);
>  bool ovl_is_whiteout(struct dentry *dentry);
>  struct file *ovl_path_open(struct path *path, int flags);
> -int ovl_copy_up_start(struct dentry *dentry);
> +int ovl_copy_up_start(struct dentry *dentry, int flags);
>  void ovl_copy_up_end(struct dentry *dentry);
>  bool ovl_check_dir_xattr(struct dentry *dentry, const char *name);
>  int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index a4ce1c9..ef720a9 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -227,6 +227,35 @@ void ovl_dentry_set_upper_alias(struct dentry *dentry)
>         oe->has_upper = true;
>  }
>
> +bool ovl_dentry_check_upperdata(struct dentry *dentry) {

Not a good helper name IMO. it reads to me "check if upperdata is set"
and it should read "should I check upperdata flag"

> +       if (!S_ISREG(d_inode(dentry)->i_mode))
> +               return false;
> +
> +       if (!ovl_dentry_lower(dentry))
> +               return false;
> +
> +       return true;
> +}
> +
> +bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags) {
> +       if (!ovl_dentry_check_upperdata(dentry))
> +               return false;
> +
> +       if (!S_ISREG(d_inode(dentry)->i_mode))
> +               return false;

Isn't this redundant to the helper check?

> +
> +       if (!flags)
> +               return false;
> +
> +       if (!(OPEN_FMODE(flags) & FMODE_WRITE))
> +               return false;
> +
> +       if (likely(ovl_test_flag(OVL_UPPERDATA, d_inode(dentry))))
> +               return false;
> +
> +       return true;
> +}
> +
>  bool ovl_redirect_dir(struct super_block *sb)
>  {
>         struct ovl_fs *ofs = sb->s_fs_info;
> @@ -310,13 +339,14 @@ struct file *ovl_path_open(struct path *path, int flags)
>         return dentry_open(path, flags | O_NOATIME, current_cred());
>  }
>
> -int ovl_copy_up_start(struct dentry *dentry)
> +int ovl_copy_up_start(struct dentry *dentry, int flags)
>  {
>         struct ovl_inode *oi = OVL_I(d_inode(dentry));
>         int err;
>
>         err = mutex_lock_interruptible(&oi->lock);
> -       if (!err && ovl_dentry_has_upper_alias(dentry)) {
> +       if (!err && ovl_dentry_has_upper_alias(dentry) &&
> +           !ovl_dentry_needs_data_copy_up(dentry, flags)) {
>                 err = 1; /* Already copied up */
>                 mutex_unlock(&oi->lock);
>         }
> --
> 2.5.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
