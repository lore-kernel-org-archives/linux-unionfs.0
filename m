Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180329193854.13814-10-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com> <20180329193854.13814-10-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 11 Apr 2018 18:10:03 +0300
Message-ID: <CAOQ4uxi=E=HfUz-tijGL-cErWvzNOxrK+eq-9YBksGw3NoF4Gw@mail.gmail.com>
Subject: Re: [PATCH v13 09/28] ovl: A new xattr OVL_XATTR_METACOPY for file on upper
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Now we will have the capability to have upper inodes which might be only
> metadata copy up and data is still on lower inode. So add a new xattr
> OVL_XATTR_METACOPY to distinguish between two cases.
>
> Presence of OVL_XATTR_METACOPY reflects that file has been copied up
> metadata only and and data will be copied up later from lower origin.
> So this xattr is set when a metadata copy takes place and cleared when
> data copy takes place.
>
> We also use a bit in ovl_inode->flags to cache OVL_UPPERDATA which reflects
> whether ovl inode has data or not (as opposed to metadata only copy up).
>
> If a file is copied up metadata only and later when same file is opened
> for WRITE, then data copy up takes place. We copy up data, remove METACOPY
> xattr and then set the UPPERDATA flag in ovl_inode->flags. While all
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
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/copy_up.c   | 56 ++++++++++++++++++++++++++++++----
>  fs/overlayfs/dir.c       |  1 +
>  fs/overlayfs/overlayfs.h | 18 +++++++++--
>  fs/overlayfs/super.c     |  1 +
>  fs/overlayfs/util.c      | 78 +++++++++++++++++++++++++++++++++++++++++++++---
>  5 files changed, 143 insertions(+), 11 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 8d9af7fdc8a4..9801ae7baa5d 100644
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
> @@ -586,8 +596,18 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
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
>         inode_lock(temp->d_inode);
> -       err = ovl_set_attr(temp, &c->stat);
> +       if (c->metacopy)
> +               err = ovl_set_size(temp, &c->stat);
> +       if (!err)
> +               err = ovl_set_attr(temp, &c->stat);
>         inode_unlock(temp->d_inode);
>
>         return err;
> @@ -625,6 +645,8 @@ static int ovl_copy_up_locked(struct ovl_copy_up_ctx *c)
>         if (err)
>                 goto out_cleanup;
>
> +       if (!c->metacopy)
> +               ovl_set_upperdata(d_inode(c->dentry));
>         inode = d_inode(c->dentry);
>         ovl_inode_update(inode, newdentry);

Following discussion on patch 20/28, I think this should be
    if (!c->metacopy)
            ovl_set_flag(OVL_UPPERDATA, inode);

without the memory barrier, because all the places that
check ovl_has_upperdata check upperdentry first, so the
smp_wmb() in ovl_inode_update() is sufficient and the extra
wmb is really only needed in ovl_copy_up_meta_inode_data().

Right?

Amir.
