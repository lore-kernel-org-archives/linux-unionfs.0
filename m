From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 05/11] ovl: lookup redirect by file handle
Date: Tue, 25 Apr 2017 11:10:52 +0300
Message-ID: <CAOQ4uxgEKj3ooYJAow=tTrdP5RYNeyN9eohkjwgogZjru+2taA@mail.gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com> <1493025256-27188-6-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1493025256-27188-6-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Apr 24, 2017 at 12:14 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> When overlay.fh xattr is found in a directory inode, instead of lookup
> of the dentry in next lower layer by name, first try to get it by calling
> exportfs_decode_fh().
>
> On failure to lookup by file handle to lower layer, fall back to lookup
> by name with or without path redirect.
>
> For now we only support following by file handle from upper if there is a
> single lower layer, because fallback from lookup by file hande to lookup
> by path in mid layers is not yet implemented.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/namei.c     | 185 +++++++++++++++++++++++++++++++++++++++++++----
>  fs/overlayfs/overlayfs.h |   1 +
>  fs/overlayfs/util.c      |  14 ++++
>  3 files changed, 186 insertions(+), 14 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index d660177..0d1cc8f 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -9,9 +9,11 @@
>
>  #include <linux/fs.h>
>  #include <linux/cred.h>
> +#include <linux/mount.h>
>  #include <linux/namei.h>
>  #include <linux/xattr.h>
>  #include <linux/ratelimit.h>
> +#include <linux/exportfs.h>
>  #include "overlayfs.h"
>  #include "ovl_entry.h"
>
> @@ -21,7 +23,10 @@ struct ovl_lookup_data {
>         bool opaque;
>         bool stop;
>         bool last;
> -       char *redirect;
> +       bool by_path;           /* redirect by path */
> +       bool by_fh;             /* redirect by file handle */
> +       char *redirect;         /* path to follow */
> +       struct ovl_fh *fh;      /* file handle to follow */
>  };
>
>  static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
> @@ -81,6 +86,42 @@ static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
>         goto err_free;
>  }
>
> +static int ovl_check_redirect_fh(struct dentry *dentry,
> +                                struct ovl_lookup_data *d)
> +{
> +       int res;
> +       void *buf = NULL;
> +
> +       res = vfs_getxattr(dentry, OVL_XATTR_FH, NULL, 0);
> +       if (res < 0) {
> +               if (res == -ENODATA || res == -EOPNOTSUPP)
> +                       return 0;
> +               goto fail;
> +       }
> +       buf = kzalloc(res, GFP_TEMPORARY);
> +       if (!buf)
> +               return -ENOMEM;
> +
> +       if (res == 0)
> +               goto fail;
> +
> +       res = vfs_getxattr(dentry, OVL_XATTR_FH, buf, res);
> +       if (res < 0 || !ovl_redirect_fh_ok(buf, res))
> +               goto fail;
> +
> +       kfree(d->fh);
> +       d->fh = buf;
> +
> +       return 0;
> +
> +err_free:
> +       kfree(buf);
> +       return 0;
> +fail:
> +       pr_warn_ratelimited("overlayfs: failed to get file handle (%i)\n", res);
> +       goto err_free;
> +}
> +
>  static bool ovl_is_opaquedir(struct dentry *dentry)
>  {
>         int res;
> @@ -96,22 +137,81 @@ static bool ovl_is_opaquedir(struct dentry *dentry)
>         return false;
>  }
>
> +/* Check if p1 is connected with a chain of hashed dentries to p2 */
> +static bool ovl_is_lookable(struct dentry *p1, struct dentry *p2)
> +{
> +       struct dentry *p;
> +
> +       for (p = p2; !IS_ROOT(p); p = p->d_parent) {
> +               if (d_unhashed(p))
> +                       return false;
> +               if (p->d_parent == p1)
> +                       return true;
> +       }
> +       return false;
> +}
> +
> +/* Check if dentry is reachable from mnt via path lookup */
> +static int ovl_dentry_under_mnt(void *ctx, struct dentry *dentry)
> +{
> +       struct vfsmount *mnt = ctx;
> +
> +       return ovl_is_lookable(mnt->mnt_root, dentry);
> +}
> +
> +static struct dentry *ovl_lookup_fh(struct vfsmount *mnt,
> +                                   const struct ovl_fh *fh)
> +{
> +       int bytes = (fh->len - offsetof(struct ovl_fh, fid));
> +
> +       /*
> +        * When redirect_fh is disabled, 'invalid' file handles are stored
> +        * to indicate that this entry has been copied up.
> +        */
> +       if (!bytes || (int)fh->type == FILEID_INVALID)
> +               return ERR_PTR(-ESTALE);
> +
> +       /*
> +        * Several layers can be on the same fs and decoded dentry may be in
> +        * either one of those layers. We are looking for a match of dentry
> +        * and mnt to find out to which layer the decoded dentry belongs to.
> +        */
> +       return exportfs_decode_fh(mnt, (struct fid *)fh->fid,
> +                                 bytes >> 2, (int)fh->type,
> +                                 ovl_dentry_under_mnt, mnt);
> +}
> +
>  static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
>                              const char *name, unsigned int namelen,
>                              size_t prelen, const char *post,
> -                            struct dentry **ret)
> +                            struct vfsmount *mnt, struct dentry **ret)
>  {
>         struct dentry *this;
>         int err;
>
> -       this = lookup_one_len_unlocked(name, base, namelen);
> +       /*
> +        * Lookup of upper is with null d->fh.
> +        * Lookup of lower is either by_fh with non-null d->fh
> +        * or by_path with null d->fh.
> +        */
> +       if (d->fh)
> +               this = ovl_lookup_fh(mnt, d->fh);
> +       else
> +               this = lookup_one_len_unlocked(name, base, namelen);
>         if (IS_ERR(this)) {
>                 err = PTR_ERR(this);
>                 this = NULL;
>                 if (err == -ENOENT || err == -ENAMETOOLONG)
>                         goto out;
> +               if (d->fh && err == -ESTALE)
> +                       goto out;
>                 goto out_err;
>         }
> +
> +       /* If found by file handle - don't follow that handle again */
> +       kfree(d->fh);
> +       d->fh = NULL;
> +
>         if (!this->d_inode)
>                 goto put_and_out;
>
> @@ -135,9 +235,18 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
>                 d->stop = d->opaque = true;
>                 goto out;
>         }
> -       err = ovl_check_redirect(this, d, prelen, post);
> -       if (err)
> -               goto out_err;
> +       if (d->last)
> +               goto out;
> +       if (d->by_path) {
> +               err = ovl_check_redirect(this, d, prelen, post);
> +               if (err)
> +                       goto out_err;
> +       }
> +       if (d->by_fh) {
> +               err = ovl_check_redirect_fh(this, d);
> +               if (err)
> +                       goto out_err;
> +       }
>  out:
>         *ret = this;
>         return 0;
> @@ -152,6 +261,12 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
>         return err;
>  }
>
> +static int ovl_lookup_layer_fh(struct path *path, struct ovl_lookup_data *d,
> +                              struct dentry **ret)
> +{
> +       return ovl_lookup_single(path->dentry, d, "", 0, 0, "", path->mnt, ret);
> +}
> +
>  static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
>                             struct dentry **ret)
>  {
> @@ -162,7 +277,7 @@ static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
>
>         if (d->name.name[0] != '/')
>                 return ovl_lookup_single(base, d, d->name.name, d->name.len,
> -                                        0, "", ret);
> +                                        0, "", NULL, ret);
>
>         while (!IS_ERR_OR_NULL(base) && d_can_lookup(base)) {
>                 const char *s = d->name.name + d->name.len - rem;
> @@ -175,7 +290,7 @@ static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
>                         return -EIO;
>
>                 err = ovl_lookup_single(base, d, s, thislen,
> -                                       d->name.len - rem, next, &base);
> +                                       d->name.len - rem, next, NULL, &base);
>                 dput(dentry);
>                 if (err)
>                         return err;
> @@ -220,6 +335,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>         const struct cred *old_cred;
>         struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
>         struct ovl_entry *poe = dentry->d_parent->d_fsdata;
> +       struct ovl_entry *roe = dentry->d_sb->s_root->d_fsdata;
>         struct path *stack = NULL;
>         struct dentry *upperdir, *upperdentry = NULL;
>         unsigned int ctr = 0;
> @@ -235,7 +351,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 .opaque = false,
>                 .stop = false,
>                 .last = !poe->numlower,
> +               .by_path = true,
>                 .redirect = NULL,
> +               .by_fh = true,
> +               .fh = NULL,
>         };
>
>         if (dentry->d_name.len > ofs->namelen)
> @@ -259,13 +378,23 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                         if (!upperredirect)
>                                 goto out_put_upper;
>                         if (d.redirect[0] == '/')
> -                               poe = dentry->d_sb->s_root->d_fsdata;
> +                               poe = roe;
>                 }
>                 if (d.opaque)
>                         type |= __OVL_PATH_OPAQUE;
>         }
>
> -       if (!d.stop && poe->numlower) {
> +       /*
> +        * For now we only support lower by fh in single layer, because
> +        * fallback from lookup by fh to lookup by path in mid layers for
> +        * merge directory is not yet implemented.
> +        */
> +       if (!ofs->redirect_fh || ofs->numlower > 1) {
> +               kfree(d.fh);
> +               d.fh = NULL;
> +       }
> +
> +       if (!d.stop && (poe->numlower || d.fh)) {
>                 err = -ENOMEM;
>                 stack = kcalloc(ofs->numlower, sizeof(struct path),
>                                 GFP_TEMPORARY);
> @@ -273,6 +402,35 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                         goto out_put_upper;
>         }
>
> +       /* Try to lookup lower layers by file handle */
> +       d.by_path = false;
> +       for (i = 0; !d.stop && d.fh && i < roe->numlower; i++) {
> +               struct path lowerpath = poe->lowerstack[i];
> +
> +               d.last = i == poe->numlower - 1;

copy&paste bug: should be s/poe/roe in 2 lines above.
it matters especially when lower files are moved into an opaque dir
I am improving xfstest overlay/017 to cover this case.

> +               err = ovl_lookup_layer_fh(&lowerpath, &d, &this);
> +               if (err)
> +                       goto out_put;
> +
> +               if (!this)
> +                       continue;
> +
> +               stack[ctr].dentry = this;
> +               stack[ctr].mnt = lowerpath.mnt;
> +               ctr++;
> +               /*
> +                * Found by fh - won't lookup by path.
> +                * TODO: set d.redirect to dentry_path(this),
> +                *       so lookup can continue by path.
> +                */
> +               d.stop = true;
> +       }
> +
> +       /* Fallback to lookup lower layers by path */
> +       d.by_path = true;
> +       d.by_fh = false;
> +       kfree(d.fh);
> +       d.fh = NULL;
>         for (i = 0; !d.stop && i < poe->numlower; i++) {
>                 struct path lowerpath = poe->lowerstack[i];
>
> @@ -291,10 +449,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 if (d.stop)
>                         break;
>
> -               if (d.redirect &&
> -                   d.redirect[0] == '/' &&
> -                   poe != dentry->d_sb->s_root->d_fsdata) {
> -                       poe = dentry->d_sb->s_root->d_fsdata;
> +               if (d.redirect && d.redirect[0] == '/' && poe != roe) {
> +                       poe = roe;
>
>                         /* Find the current layer on the root dentry */
>                         for (i = 0; i < poe->numlower; i++)
> @@ -354,6 +510,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>         dput(upperdentry);
>         kfree(upperredirect);
>  out:
> +       kfree(d.fh);
>         kfree(d.redirect);
>         revert_creds(old_cred);
>         return ERR_PTR(err);
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index c3cfbc5..08002ce 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -190,6 +190,7 @@ const char *ovl_dentry_get_redirect(struct dentry *dentry);
>  void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
>  bool ovl_redirect_fh(struct super_block *sb);
>  void ovl_clear_redirect_fh(struct super_block *sb);
> +bool ovl_redirect_fh_ok(const char *redirect, size_t size);
>  void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry);
>  void ovl_inode_init(struct inode *inode, struct inode *realinode,
>                     bool is_upper);
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index b3bc117..dba9753 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -254,6 +254,20 @@ void ovl_clear_redirect_fh(struct super_block *sb)
>         ofs->redirect_fh = false;
>  }
>
> +bool ovl_redirect_fh_ok(const char *redirect, size_t size)
> +{
> +       struct ovl_fh *fh = (void *)redirect;
> +
> +       if (size < sizeof(struct ovl_fh) || size < fh->len)
> +               return false;
> +
> +       if (fh->version > OVL_FH_VERSION ||
> +           fh->magic != OVL_FH_MAGIC)
> +               return false;
> +
> +       return true;
> +}
> +
>  void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry)
>  {
>         struct ovl_entry *oe = dentry->d_fsdata;
> --
> 2.7.4
>
