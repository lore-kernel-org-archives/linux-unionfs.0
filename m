From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v7 09/14] ovl: A new xattr OVL_XATTR_METACOPY for file on upper
Date: Fri, 17 Nov 2017 18:07:24 +0200
Message-ID: <CAOQ4uxgb0mC2qEAL0AbC7qY-Hv+PcoHMXhfadqojhA=iPHuh1Q@mail.gmail.com>
References: <20171116220335.13448-1-vgoyal@redhat.com> <20171116220335.13448-10-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:40786 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751569AbdKQQHZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Nov 2017 11:07:25 -0500
Received: by mail-yb0-f193.google.com with SMTP id d59so912190ybi.7
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Nov 2017 08:07:25 -0800 (PST)
In-Reply-To: <20171116220335.13448-10-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Nov 17, 2017 at 12:03 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
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
> If a file is copied up metadata only and later when same file is opened
> for WRITE, then data copy up takes place. We copy up data, remove METACOPY
> xattr and then set the UPPERDATA flag in ovl_entry->flags. While all
> these operations happen with oi->lock held, read side of oi->flags can be
> lockless. That is another thread on another cpu can check if UPPERDATA
> flag is set or not.
>
> So this gives us an ordering requirement w.r.t UPPERDATA flag. That is, if
> another cpu sees UPPERDATA flag set, then it should be guaranteed that
> effects of data copy up and remove xattr operations are also visible.
>
> For example.
>
>         CPU1                            CPU2
> ovl_d_real()                            acquire(oi->lock)
>  ovl_open_maybe_copy_up()                ovl_copy_up_data()
>   open_open_need_copy_up()               vfs_removexattr()
>    ovl_already_copied_up()
>     ovl_dentry_needs_data_copy_up()      ovl_set_flag(OVL_UPPERDATA)
>      ovl_test_flag(OVL_UPPERDATA)       release(oi->lock)
>
> Say CPU2 is copying up data and in the end sets UPPERDATA flag. But if
> CPU1 perceives the effects of setting UPPERDATA flag but not the effects
> of preceeding operations (ex. upper that is not fully copied up), it will be
> a problem.
>
> Hence this patch introduces smp_wmb() on setting UPPERDATA flag operation
> and smp_rmb() on UPPERDATA flag test operation.
>
> May be some other lock or barrier is already covering it. But I am not sure
> what that is and is it obvious enough that we will not break it in future.
>
> So hence trying to be safe here and introducing barriers explicitly for
> UPPERDATA flag/bit.
>

Vivek,

I like this version a lot more, but IMO it could still be even simpler.

> Note, we now set OVL_UPPERDATA on all kind of dentires and check
> OVL_UPPERDATA only where it makes sense. If a file is created on upper,
> we set OVL_UPPERDATA. This can be accessed lockless in ovl_d_real()
> path again. This time ordering dependency is w.r.t oe->__upperdata. We
> need to make surr OVL_UPPERDATA is visible before oe->__upperdata is
> visible. Otherwise following code path might try to copy up an upper
> only file.

Why all this explanations?
Just use ovl_set_upperdata() when creating upper and be done with it.
Creating new upper is expensive anyway, so I don't think we should
care about an unneeded smp_wmb() and probably Miklos will know to
tell why it is not needed anyway.

It is very easy to make sure that the  OVL_UPPERDATA is always set
for the pure upper and non regular file cases and then we have no need
for ovl_should_check_upperdata().
Simple is better.

There is just one more thing you need to do before killing
ovl_should_check_upperdata() - set the OVL_UPPERDATA on the root
inode in ovl_fill_super().

>
> ovl_d_real()
>  ovl_open_maybe_copy_up()
>   open_open_need_copy_up()
>    ovl_already_copied_up()
>     ovl_dentry_needs_data_copy_up()
>      ovl_test_flag(OVL_UPPERDATA)
>          <-- OVL_UPPERDATA is not visible yet. copy up file.
>
> I have not introduced any barrier to take care of this. There is already
> a check ovl_should_check_upperdata() to make sure lower dentry is there
> otherwise return false (even if OVL_UPPERDATA is not visible yet).
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/copy_up.c   | 55 +++++++++++++++++++++++++++++++---
>  fs/overlayfs/dir.c       |  1 +
>  fs/overlayfs/overlayfs.h | 10 +++++--
>  fs/overlayfs/util.c      | 78 +++++++++++++++++++++++++++++++++++++++++++++---
>  4 files changed, 134 insertions(+), 10 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index b6fa5830c4c6..3f59b98340f7 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -195,6 +195,16 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
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
> @@ -234,7 +244,7 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
>
>  static bool ovl_open_need_copy_up(struct dentry *dentry, int flags)
>  {
> -       if (ovl_already_copied_up(dentry))
> +       if (ovl_already_copied_up(dentry, flags))
>                 return false;
>
>         if (special_file(d_inode(dentry)->i_mode))
> @@ -486,6 +496,28 @@ static int ovl_get_tmpfile(struct ovl_copy_up_ctx *c, struct dentry **tempp)
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
> +       ovl_set_upperdata(c->dentry);
> +       return err;
> +}
> +
>  static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
>  {
>         int err;
> @@ -519,8 +551,19 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
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
> @@ -552,6 +595,8 @@ static int ovl_copy_up_locked(struct ovl_copy_up_ctx *c)
>         if (err)
>                 goto out_cleanup;
>
> +       if (!c->metacopy)
> +               ovl_set_upperdata(c->dentry);
>         inode = d_inode(c->dentry);
>         ovl_inode_update(inode, newdentry);
>         if (S_ISDIR(inode->i_mode))
> @@ -674,7 +719,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
>         }
>         ovl_do_check_copy_up(ctx.lowerpath.dentry);
>
> -       err = ovl_copy_up_start(dentry);
> +       err = ovl_copy_up_start(dentry, flags);
>         /* err < 0: interrupted, err > 0: raced with another copy-up */
>         if (unlikely(err)) {
>                 if (err > 0)
> @@ -684,6 +729,8 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
>                         err = ovl_do_copy_up(&ctx);
>                 if (!err && !ovl_dentry_has_upper_alias(dentry))
>                         err = ovl_link_up(&ctx);
> +               if (!err && ovl_dentry_needs_data_copy_up_locked(dentry, flags))
> +                       err = ovl_copy_up_meta_inode_data(&ctx);
>                 ovl_copy_up_end(dentry);
>         }
>         do_delayed_call(&done);
> @@ -700,7 +747,7 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
>                 struct dentry *next;
>                 struct dentry *parent;
>
> -               if (ovl_already_copied_up(dentry))
> +               if (ovl_already_copied_up(dentry, flags))
>                         break;
>
>                 next = dget(dentry);
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index e13921824c70..fb3cd73c3693 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -158,6 +158,7 @@ static void ovl_instantiate(struct dentry *dentry, struct inode *inode,
>         ovl_dentry_version_inc(dentry->d_parent, false);
>         ovl_dentry_set_upper_alias(dentry);
>         if (!hardlink) {
> +               ovl_set_flag(OVL_UPPERDATA, inode);

Call ovl_set_upperdata() instead?

>                 ovl_inode_update(inode, newdentry);
>                 ovl_copyattr(newdentry->d_inode, inode);
>         } else {
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 7f9a79b5a2b5..d4890e59b881 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -27,6 +27,7 @@ enum ovl_path_type {
>  #define OVL_XATTR_ORIGIN OVL_XATTR_PREFIX "origin"
>  #define OVL_XATTR_IMPURE OVL_XATTR_PREFIX "impure"
>  #define OVL_XATTR_NLINK OVL_XATTR_PREFIX "nlink"
> +#define OVL_XATTR_METACOPY OVL_XATTR_PREFIX "metacopy"
>
>  enum ovl_flag {
>         /* Pure upper dir that may contain non pure upper entries */
> @@ -34,6 +35,7 @@ enum ovl_flag {
>         /* Non-merge dir that may contain whiteout entries */
>         OVL_WHITEOUTS,
>         OVL_INDEX,
> +       OVL_UPPERDATA,
>  };
>
>  /*
> @@ -215,6 +217,10 @@ bool ovl_dentry_is_whiteout(struct dentry *dentry);
>  void ovl_dentry_set_opaque(struct dentry *dentry);
>  bool ovl_dentry_has_upper_alias(struct dentry *dentry);
>  void ovl_dentry_set_upper_alias(struct dentry *dentry);
> +bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags);
> +bool ovl_dentry_needs_data_copy_up_locked(struct dentry *dentry, int flags);
> +bool ovl_has_upperdata(struct dentry *dentry);
> +void ovl_set_upperdata(struct dentry *dentry);
>  bool ovl_redirect_dir(struct super_block *sb);
>  const char *ovl_dentry_get_redirect(struct dentry *dentry);
>  void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
> @@ -225,9 +231,9 @@ void ovl_dentry_version_inc(struct dentry *dentry, bool impurity);
>  u64 ovl_dentry_version_get(struct dentry *dentry);
>  bool ovl_is_whiteout(struct dentry *dentry);
>  struct file *ovl_path_open(struct path *path, int flags);
> -int ovl_copy_up_start(struct dentry *dentry);
> +int ovl_copy_up_start(struct dentry *dentry, int flags);
>  void ovl_copy_up_end(struct dentry *dentry);
> -bool ovl_already_copied_up(struct dentry *dentry);
> +bool ovl_already_copied_up(struct dentry *dentry, int flags);
>  bool ovl_check_origin_xattr(struct dentry *dentry);
>  bool ovl_check_dir_xattr(struct dentry *dentry, const char *name);
>  int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 572bf46e9f2e..73578bfe9f4b 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -231,6 +231,64 @@ void ovl_dentry_set_upper_alias(struct dentry *dentry)
>         oe->has_upper = true;
>  }
>
> +static bool ovl_should_check_upperdata(struct dentry *dentry) {
> +       if (!S_ISREG(d_inode(dentry)->i_mode))
> +               return false;
> +
> +       if (!ovl_dentry_lower(dentry))
> +               return false;
> +
> +       return true;
> +}
> +
> +bool ovl_has_upperdata(struct dentry *dentry) {
> +       if (!ovl_should_check_upperdata(dentry))
> +               return true;
> +


IMO we don't need this check, but you may leave it as
if (WARN_ON(!ovl_should_check_upperdata(dentry)
after ovl_test_flag() to be on the safe side.


> +       if (!ovl_test_flag(OVL_UPPERDATA, d_inode(dentry)))
> +               return false;
> +       /*
> +        * Pairs with smp_wmb() in ovl_copy_up_meta_inode_data(). Make sure

To be consistent, you should update the comment to say pairs with... in
ovl_set_upperdata(), although it may be useful to leave the information that
the main user of ovl_set_upperdata() is ovl_copy_up_meta_inode_data().

> +        * if setting of OVL_UPPERDATA is visible, then effects of writes
> +        * before that are visible too.
> +        */
> +       smp_rmb();
> +       return true;
> +}
> +
> +void ovl_set_upperdata(struct dentry *dentry) {
> +       /*
> +        * Pairs with smp_rmb() in ovl_has_upperdata(). Make sure
> +        * if OVL_UPPERDATA flag is visible, then effects of write operations
> +        * before it are visible as well.
> +        */
> +       smp_wmb();
> +       ovl_set_flag(OVL_UPPERDATA, d_inode(dentry));
> +}
> +
> +static inline bool open_for_write(int flags)

Need ovl_ namespace prefix
and the name sounds like an action (i.e. a request to open for write)

> +{
> +       if (flags && (OPEN_FMODE(flags) & FMODE_WRITE))

What I meant in previous review is that you make a static inline helper
in overlayfs.h to be used by this and ovl_open_need_copy_up().
Your helper is missing the O_TRUNC test, i.e.

return ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC));

It may sound like we don't *need* to copy up data on O_TRUNC,
but in fact, if we don't call copy up functions, we won't be cleaning the
metacopy xattr/flag on truncate.

The thing is that the result of O_TRUNC|O_RDONLY is not even well
defined by man page ("... Otherwise, the effect of O_TRUNC is unspecified"),
but we shouldn't change the way overlayfs treats this strange combination.

> +               return true;
> +
> +       return false;
> +}
> +
> +/* Caller should hold ovl_entry->locked */

...should hold ovl_inode->lock

Eventually, Miklos may decide that the _locked variants are not needed
and that it is
not expensive to call the lockless variants in locked path, but I am happy we
can see how this looks like. It looks cleaner to me and not over complicated.

Thanks,
Amir.
