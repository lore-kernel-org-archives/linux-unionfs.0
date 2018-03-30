Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180329193854.13814-11-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com> <20180329193854.13814-11-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 30 Mar 2018 08:49:26 +0300
Message-ID: <CAOQ4uxiO8fRn6TB54SANB4cp4uURDJ6wQVNT8mF29nH67F7M+A@mail.gmail.com>
Subject: Re: [PATCH v13 10/28] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
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
> ---
>  fs/overlayfs/export.c    |  3 ++
>  fs/overlayfs/inode.c     |  6 +++-
>  fs/overlayfs/namei.c     | 90 ++++++++++++++++++++++++++++++++++++++++++------
>  fs/overlayfs/overlayfs.h |  1 +
>  fs/overlayfs/util.c      | 22 ++++++++++++
>  5 files changed, 110 insertions(+), 12 deletions(-)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index e668329f7361..1c233096e59c 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -311,6 +311,9 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
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
> index 3991a890b464..e1dbfed0c449 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -677,7 +677,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
>         struct inode *realinode = upperdentry ? d_inode(upperdentry) : NULL;
>         struct inode *inode;
>         bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry, index);
> -       bool is_dir;
> +       bool is_dir, metacopy = false;
>
>         if (!realinode)
>                 realinode = d_inode(lowerdentry);
> @@ -732,6 +732,10 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
>         if (index)
>                 ovl_set_flag(OVL_INDEX, inode);
>
> +       metacopy = ovl_check_metacopy_xattr(upperdentry ?: lowerdentry);

No reason to check metacopy on lowerdentry.

> +       if (upperdentry && !metacopy)
> +               ovl_set_flag(OVL_UPPERDATA, inode);
> +
>         OVL_I(inode)->redirect = redirect;
>
>         /* Check for non-merge dir that may have whiteouts */
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 0b325e65864c..1dba89e9543f 100644
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
> @@ -252,9 +253,13 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
>                 goto put_and_out;
>         }
>         if (!d_can_lookup(this)) {
> -               d->stop = true;

upper was a dir. You look in lower and find a non-dir. you need to stop
going to next layer. goto put_and_out won't do that.

Similarly, you need to handle the case where dir is found below
non-dir with metacopy.

>                 if (d->is_dir)
>                         goto put_and_out;
> +               err = ovl_check_metacopy_xattr(this);
> +               if (err < 0)
> +                       goto out_err;
> +               d->stop = !err;
> +               d->metacopy = !!err;
>                 goto out;
>         }
>         if (last_element)
> @@ -815,7 +820,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>         struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
>         struct ovl_entry *poe = dentry->d_parent->d_fsdata;
>         struct ovl_entry *roe = dentry->d_sb->s_root->d_fsdata;
> -       struct ovl_path *stack = NULL;
> +       struct ovl_path *stack = NULL, *origin_path = NULL;
>         struct dentry *upperdir, *upperdentry = NULL;
>         struct dentry *origin = NULL;
>         struct dentry *index = NULL;
> @@ -826,6 +831,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>         struct dentry *this;
>         unsigned int i;
>         int err;
> +       bool metacopy = false;
>         struct ovl_lookup_data d = {
>                 .name = dentry->d_name,
>                 .is_dir = false,
> @@ -833,6 +839,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 .stop = false,
>                 .last = ofs->config.redirect_follow ? false : !poe->numlower,
>                 .redirect = NULL,
> +               .metacopy = false,
>         };
>
>         if (dentry->d_name.len > ofs->namelen)
> @@ -851,7 +858,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                         goto out;
>                 }
>                 if (upperdentry && !d.is_dir) {
> -                       BUG_ON(!d.stop || d.redirect);
> +                       unsigned int origin_ctr = 0;
> +                       BUG_ON(d.redirect);
>                         /*
>                          * Lookup copy up origin by decoding origin file handle.
>                          * We may get a disconnected dentry, which is fine,
> @@ -862,16 +870,20 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
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
>                         err = -ENOMEM;
>                         upperredirect = kstrdup(d.redirect, GFP_KERNEL);
>                         if (!upperredirect)
> -                               goto out_put_upper;
> +                               goto out_put_origin;
>                         if (d.redirect[0] == '/')
>                                 poe = roe;
>                 }
> @@ -883,7 +895,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 stack = kcalloc(ofs->numlower, sizeof(struct ovl_path),
>                                 GFP_KERNEL);
>                 if (!stack)
> -                       goto out_put_upper;
> +                       goto out_put_origin;
>         }
>
>         for (i = 0; !d.stop && i < poe->numlower; i++) {
> @@ -905,7 +917,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                  * If no origin fh is stored in upper of a merge dir, store fh
>                  * of lower dir and set upper parent "impure".
>                  */
> -               if (upperdentry && !ctr && !ofs->noxattr) {
> +               if (upperdentry && !ctr && !ofs->noxattr && d.is_dir) {
>                         err = ovl_fix_origin(dentry, this, upperdentry);
>                         if (err) {
>                                 dput(this);
> @@ -917,16 +929,35 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
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
>                         /* Bless lower dir as verified origin */
> -                       origin = this;
> +                       if (d.is_dir)
> +                               origin = this;

It's ok to bless verified non-dir as well.
It is going to be blesses anyway, just above index lookup if ctr > 0.

> +               }
> +
> +               if (d.metacopy)
> +                       metacopy = true;
> +               /*
> +                * Do not store intermediate metacopy dentries in chain,
> +                * except top most lower metacopy dentry
> +                */
> +               if (d.metacopy && ctr) {
> +                       dput(this);
> +                       continue;
>                 }
>
>                 stack[ctr].dentry = this;
> @@ -960,6 +991,34 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 }
>         }
>
> +       if (metacopy) {
> +               BUG_ON(d.is_dir);

Yeh, I think that is really a bug, because you need to detect
the case of dir in lower layer under metacopy in upper layer
and do something about it.

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
> @@ -1006,6 +1065,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
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
> @@ -1019,6 +1082,11 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>         for (i = 0; i < ctr; i++)
>                 dput(stack[i].dentry);
>         kfree(stack);
> +out_put_origin:
> +       if (origin_path) {
> +               dput(origin_path->dentry);
> +               kfree(origin_path);
> +       }

There is no need for the new goto label.
Just add this in existing out_put_upper label.

Thanks,
Amir,
