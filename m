Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180507174102.24086-11-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com> <20180507174102.24086-11-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 7 May 2018 22:14:06 +0300
Message-ID: <CAOQ4uxhuwQZVt-FXhpUc7vaO4iwRL9sFg=oo=0Aw5=r1XsXoKw@mail.gmail.com>
Subject: Re: [PATCH v15 10/30] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, May 7, 2018 at 8:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> This patch modifies ovl_lookup() and friends to lookup metacopy dentries.
> It also allows for presence of metacopy dentries in lower layer.
>
> During lookup, check for presence of OVL_XATTR_METACOPY and if not present,
> set OVL_UPPERDATA bit in flags.
>
> We don't support metacopy feature with nfs_export. So in nfs_export code,
> we set OVL_UPPERDATA flag set unconditionally if upper inode exists.
>
> Do not follow metacopy origin if we find a metacopy only inode and metacopy
> feature is not enabled for that mount. Like redirect, this can have security
> implications where an attacker could hand craft upper and try to gain
> access to file on lower which it should not have to begin with.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

OK, you may add

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/export.c    |   3 ++
>  fs/overlayfs/inode.c     |  11 ++++-
>  fs/overlayfs/namei.c     | 108 +++++++++++++++++++++++++++++++++++++++++------
>  fs/overlayfs/overlayfs.h |   1 +
>  fs/overlayfs/util.c      |  22 ++++++++++
>  5 files changed, 130 insertions(+), 15 deletions(-)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 0549286cc55e..52a09a9f74b7 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -314,6 +314,9 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
>                 return ERR_CAST(inode);
>         }
>
> +       if (upper)
> +               ovl_set_flag(OVL_UPPERDATA, inode);
> +
>         dentry = d_find_any_alias(inode);
>         if (!dentry) {
>                 dentry = d_alloc_anon(inode->i_sb);
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index c128d5d54d0f..83b276ce0240 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -770,7 +770,7 @@ struct inode *ovl_get_inode(struct ovl_inode_params *oip)
>         bool bylower = ovl_hash_bylower(oip->sb, upperdentry, lowerdentry,
>                                         oip->index);
>         int fsid = bylower ? oip->lowerpath->layer->fsid : 0;
> -       bool is_dir;
> +       bool is_dir, metacopy = false;
>         unsigned long ino = 0;
>         int err = -ENOMEM;
>
> @@ -830,6 +830,15 @@ struct inode *ovl_get_inode(struct ovl_inode_params *oip)
>         if (oip->index)
>                 ovl_set_flag(OVL_INDEX, inode);
>
> +       if (upperdentry) {
> +               err = ovl_check_metacopy_xattr(upperdentry);
> +               if (err < 0)
> +                       goto out_err;
> +               metacopy = err;
> +               if (!metacopy)
> +                       ovl_set_flag(OVL_UPPERDATA, inode);
> +       }
> +
>         OVL_I(inode)->redirect = oip->redirect;
>
>         /* Check for non-merge dir that may have whiteouts */
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 8fd817bf5529..b2ff08985e29 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -24,6 +24,7 @@ struct ovl_lookup_data {
>         bool stop;
>         bool last;
>         char *redirect;
> +       bool metacopy;
>  };
>
>  static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
> @@ -253,19 +254,29 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
>                 goto put_and_out;
>         }
>         if (!d_can_lookup(this)) {
> -               d->stop = true;
> -               if (d->is_dir)
> +               if (d->is_dir) {
> +                       d->stop = true;
>                         goto put_and_out;
> -
> +               }
>                 /*
>                  * NB: handle failure to lookup non-last element when non-dir
>                  * redirects become possible
>                  */
>                 WARN_ON(!last_element);
> +               err = ovl_check_metacopy_xattr(this);
> +               if (err < 0)
> +                       goto out_err;
> +               d->stop = !err;
> +               d->metacopy = !!err;
>                 goto out;
>         }
> -       if (last_element)
> +       if (last_element) {
> +               if (d->metacopy) {
> +                       err = -ESTALE;
> +                       goto out_err;
> +               }
>                 d->is_dir = true;
> +       }
>         if (d->last)
>                 goto out;
>
> @@ -823,7 +834,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>         struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
>         struct ovl_entry *poe = dentry->d_parent->d_fsdata;
>         struct ovl_entry *roe = dentry->d_sb->s_root->d_fsdata;
> -       struct ovl_path *stack = NULL;
> +       struct ovl_path *stack = NULL, *origin_path = NULL;
>         struct dentry *upperdir, *upperdentry = NULL;
>         struct dentry *origin = NULL;
>         struct dentry *index = NULL;
> @@ -834,6 +845,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>         struct dentry *this;
>         unsigned int i;
>         int err;
> +       bool metacopy = false;
>         struct ovl_lookup_data d = {
>                 .name = dentry->d_name,
>                 .is_dir = false,
> @@ -841,6 +853,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 .stop = false,
>                 .last = ofs->config.redirect_follow ? false : !poe->numlower,
>                 .redirect = NULL,
> +               .metacopy = false,
>         };
>
>         if (dentry->d_name.len > ofs->namelen)
> @@ -859,7 +872,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                         goto out;
>                 }
>                 if (upperdentry && !d.is_dir) {
> -                       BUG_ON(!d.stop || d.redirect);
> +                       unsigned int origin_ctr = 0;
> +                       BUG_ON(d.redirect);
>                         /*
>                          * Lookup copy up origin by decoding origin file handle.
>                          * We may get a disconnected dentry, which is fine,
> @@ -870,9 +884,13 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                          * number - it's the same as if we held a reference
>                          * to a dentry in lower layer that was moved under us.
>                          */
> -                       err = ovl_check_origin(ofs, upperdentry, &stack, &ctr);
> +                       err = ovl_check_origin(ofs, upperdentry, &origin_path,
> +                                              &origin_ctr);
>                         if (err)
>                                 goto out_put_upper;
> +
> +                       if (d.metacopy)
> +                               metacopy = true;
>                 }
>
>                 if (d.redirect) {
> @@ -913,7 +931,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                  * If no origin fh is stored in upper of a merge dir, store fh
>                  * of lower dir and set upper parent "impure".
>                  */
> -               if (upperdentry && !ctr && !ofs->noxattr) {
> +               if (upperdentry && !ctr && !ofs->noxattr && d.is_dir) {
>                         err = ovl_fix_origin(dentry, this, upperdentry);
>                         if (err) {
>                                 dput(this);
> @@ -925,18 +943,36 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                  * When "verify_lower" feature is enabled, do not merge with a
>                  * lower dir that does not match a stored origin xattr. In any
>                  * case, only verified origin is used for index lookup.
> +                *
> +                * For non-dir dentry, make sure dentry found by lookup
> +                * matches the origin stored in upper. Otherwise its an
> +                * error.
>                  */
> -               if (upperdentry && !ctr && ovl_verify_lower(dentry->d_sb)) {
> +               if (upperdentry && !ctr &&
> +                   ((d.is_dir && ovl_verify_lower(dentry->d_sb)) ||
> +                    (!d.is_dir && origin_path))) {
>                         err = ovl_verify_origin(upperdentry, this, false);
>                         if (err) {
>                                 dput(this);
> -                               break;
> +                               if (d.is_dir)
> +                                       break;
> +                               goto out_put;
>                         }
> -
> -                       /* Bless lower dir as verified origin */
> +                       /* Bless lower as verified origin */
>                         origin = this;
>                 }
>
> +               if (d.metacopy)
> +                       metacopy = true;
> +               /*
> +                * Do not store intermediate metacopy dentries in chain,
> +                * except top most lower metacopy dentry
> +                */
> +               if (d.metacopy && ctr) {
> +                       dput(this);
> +                       continue;
> +               }
> +
>                 stack[ctr].dentry = this;
>                 stack[ctr].layer = lower.layer;
>                 ctr++;
> @@ -968,13 +1004,49 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 }
>         }
>
> +       if (metacopy) {
> +               /*
> +                * Found a metacopy dentry but did not find corresponding
> +                * data dentry
> +                */
> +               if (d.metacopy) {
> +                       err = -ESTALE;
> +                       goto out_put;
> +               }
> +
> +               err = -EPERM;
> +               if (!ofs->config.metacopy) {
> +                       pr_warn_ratelimited("overlay: refusing to follow"
> +                                           " metacopy origin for (%pd2)\n",
> +                                           dentry);
> +                       goto out_put;
> +               }
> +       } else if (!d.is_dir && upperdentry && !ctr && origin_path) {
> +               if (WARN_ON(stack != NULL)) {
> +                       err = -EIO;
> +                       goto out_put;
> +               }
> +               stack = origin_path;
> +               ctr = 1;
> +               origin_path = NULL;
> +       }
> +
>         /*
>          * Lookup index by lower inode and verify it matches upper inode.
>          * We only trust dir index if we verified that lower dir matches
>          * origin, otherwise dir index entries may be inconsistent and we
> -        * ignore them. Always lookup index of non-dir and non-upper.
> +        * ignore them.
> +        *
> +        * For non-dir upper metacopy dentry, we already set "origin" if we
> +        * verified that lower matched upper origin. If upper origin was
> +        * not present (because lower layer did not support fh encode/decode),
> +        * do not set "origin" and skip looking up index. This case should
> +        * be handled in same way as a non-dir upper without ORIGIN is
> +        * handled.
> +        *
> +        * Always lookup index of non-dir non-metacopy and non-upper.
>          */
> -       if (ctr && (!upperdentry || !d.is_dir))
> +       if (ctr && (!upperdentry || (!d.is_dir && !metacopy)))
>                 origin = stack[0].dentry;
>
>         if (origin && ovl_indexdir(dentry->d_sb) &&
> @@ -1015,6 +1087,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>         }
>
>         revert_creds(old_cred);
> +       if (origin_path) {
> +               dput(origin_path->dentry);
> +               kfree(origin_path);
> +       }
>         dput(index);
>         kfree(stack);
>         kfree(d.redirect);
> @@ -1029,6 +1105,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 dput(stack[i].dentry);
>         kfree(stack);
>  out_put_upper:
> +       if (origin_path) {
> +               dput(origin_path->dentry);
> +               kfree(origin_path);
> +       }
>         dput(upperdentry);
>         kfree(upperredirect);
>  out:
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 2daea529b7eb..e8954fff1c45 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -274,6 +274,7 @@ bool ovl_need_index(struct dentry *dentry);
>  int ovl_nlink_start(struct dentry *dentry, bool *locked);
>  void ovl_nlink_end(struct dentry *dentry, bool locked);
>  int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
> +int ovl_check_metacopy_xattr(struct dentry *dentry);
>
>  static inline bool ovl_is_impuredir(struct dentry *dentry)
>  {
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index f8e3c95711b8..ab9a8fae0f99 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -778,3 +778,25 @@ int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir)
>         pr_err("overlayfs: failed to lock workdir+upperdir\n");
>         return -EIO;
>  }
> +
> +/* err < 0, 0 if no metacopy xattr, 1 if metacopy xattr found */
> +int ovl_check_metacopy_xattr(struct dentry *dentry)
> +{
> +       int res;
> +
> +       /* Only regular files can have metacopy xattr */
> +       if (!S_ISREG(d_inode(dentry)->i_mode))
> +               return 0;
> +
> +       res = vfs_getxattr(dentry, OVL_XATTR_METACOPY, NULL, 0);
> +       if (res < 0) {
> +               if (res == -ENODATA || res == -EOPNOTSUPP)
> +                       return 0;
> +               goto out;
> +       }
> +
> +       return 1;
> +out:
> +       pr_warn_ratelimited("overlayfs: failed to get metacopy (%i)\n", res);
> +       return res;
> +}
> --
> 2.13.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
