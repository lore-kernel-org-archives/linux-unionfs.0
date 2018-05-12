Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1526116631-24186-2-git-send-email-amir73il@gmail.com>
References: <1526116631-24186-1-git-send-email-amir73il@gmail.com> <1526116631-24186-2-git-send-email-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 12 May 2018 12:41:56 +0300
Message-ID: <CAOQ4uxj0e9Dej6y3EmZPQPkNzmmhGCfpjQ3xrk4Pu62Uq=cqqg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] ovl: use d_instantiate_new() to instantiate a new dentry
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, May 12, 2018 at 12:17 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Currently, there is a small window where ovl_obtain_alias() can
> race with ovl_instantiate() and create two aliases for an overlay
> directory inode, see Al's explanation in this post:
> https://marc.info/?l=linux-fsdevel&m=152599914515224&w=2
>
> This patch fixes the race, by using the d_instantiate_new() helper.
>
> Another logic change by this patch is that if there is an
> inconcsistency and a new created upper inode apears to already
> exist in icache (hashed by the same real upper inode), we will
> export this error to user instead of silently not hashing the new
> inode.
>
> Backporting only makes sense for v4.16 where NFS export was introduced.
>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: <stable@vger.kernel.org> #v4.16
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/dir.c       | 27 +++++++++++++++++----------
>  fs/overlayfs/inode.c     |  6 ++++++
>  fs/overlayfs/overlayfs.h |  1 +
>  3 files changed, 24 insertions(+), 10 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 47dc980e8b33..c41825a5ed5f 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -183,23 +183,30 @@ static int ovl_set_opaque(struct dentry *dentry, struct dentry *upperdentry)
>  }
>
>  /* Common operations required to be done after creation of file on upper */
> -static void ovl_instantiate(struct dentry *dentry, struct inode *inode,
> -                           struct dentry *newdentry, bool hardlink)
> +static int ovl_instantiate(struct dentry *dentry, struct inode *inode,
> +                          struct dentry *newdentry, bool hardlink)
>  {
>         ovl_dir_modified(dentry->d_parent, false);
> -       ovl_copyattr(d_inode(newdentry), inode);

Miklos,

Note that removal of ovl_copyattr() here (for hardlink case) causes xfstest
overlay/019 to hit WARN_ON in ovl_create_or_link() about 2 minutes into
the test and causes the test to fail.

WARN_ON(!uid_eq(inode->i_uid, realinode->i_uid));
WARN_ON(!gid_eq(inode->i_gid, realinode->i_gid));

This is a stress tests that makes modification to underlying layer
while overlay is mounted, so it is not surprising.

I think the correct solution is to turn those WARN_ON to
pr_warn_ratelimited(). There are many of those fired by the stress test.
Do you agree this is the correct fix?

Thanks,
Amir.


>         ovl_dentry_set_upper_alias(dentry);
>         if (!hardlink) {
> -               ovl_inode_update(inode, newdentry);
> +               int err;
> +
> +               ovl_inode_init(inode, newdentry, NULL);
> +               err = ovl_insert_inode_locked(inode, d_inode(newdentry));
> +               if (err)
> +                       return err;
> +
> +               d_instantiate_new(dentry, inode);
>         } else {
>                 WARN_ON(ovl_inode_real(inode) != d_inode(newdentry));
>                 dput(newdentry);
>                 inc_nlink(inode);
> -       }
> -       d_instantiate(dentry, inode);
> -       /* Force lookup of new upper hardlink to find its lower */
> -       if (hardlink)
> +               d_instantiate(dentry, inode);
> +               /* Force lookup of new upper hardlink to find its lower */
>                 d_drop(dentry);
> +       }
> +
> +       return 0;
>  }
>
>  static bool ovl_type_merge(struct dentry *dentry)
> @@ -238,7 +245,7 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
>                 ovl_set_opaque(dentry, newdentry);
>         }
>
> -       ovl_instantiate(dentry, inode, newdentry, !!hardlink);
> +       err = ovl_instantiate(dentry, inode, newdentry, !!hardlink);
>         newdentry = NULL;
>  out_dput:
>         dput(newdentry);
> @@ -439,7 +446,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
>                 if (err)
>                         goto out_cleanup;
>         }
> -       ovl_instantiate(dentry, inode, newdentry, !!hardlink);
> +       err = ovl_instantiate(dentry, inode, newdentry, !!hardlink);
>         newdentry = NULL;
>  out_dput2:
>         dput(upper);
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 7abcf96e94fc..70c966b1bb5a 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -741,6 +741,12 @@ static bool ovl_verify_inode(struct inode *inode, struct dentry *lowerdentry,
>         return true;
>  }
>
> +int ovl_insert_inode_locked(struct inode *inode, struct inode *realinode)
> +{
> +       return insert_inode_locked4(inode, (unsigned long) realinode,
> +                                   ovl_inode_test, realinode);
> +}
> +
>  struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
>                                bool is_upper)
>  {
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index caaa47cea2aa..dd320be86600 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -343,6 +343,7 @@ int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
>  bool ovl_is_private_xattr(const char *name);
>
>  struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
> +int ovl_insert_inode_locked(struct inode *inode, struct inode *realinode);
>  struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
>                                bool is_upper);
>  struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
> --
> 2.7.4
>
