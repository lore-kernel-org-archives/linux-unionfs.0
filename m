From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v5 2/4] ovl: allocate anonymous devs for lowerdirs
Date: Tue, 31 Oct 2017 14:43:47 +0100
Message-ID: <CAJfpeguJ2q71MhU2xi2WV_CcVYhmM04cXyDzqGyCRWaBWx3VwA@mail.gmail.com>
References: <1509395247-15180-1-git-send-email-amir73il@gmail.com> <1509395247-15180-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:56994 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753085AbdJaNnu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Oct 2017 09:43:50 -0400
Received: by mail-wr0-f196.google.com with SMTP id r79so15960114wrb.13
        for <linux-unionfs@vger.kernel.org>; Tue, 31 Oct 2017 06:43:49 -0700 (PDT)
In-Reply-To: <1509395247-15180-3-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, zhangyi <yi.zhang@huawei.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Oct 30, 2017 at 9:27 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>
> For stat(2) on lowerdir non-dir entries in non-samefs case, this commit
> provides unique values for st_dev. The unique values are obtained by
> allocating anonymous bdevs for each of the lowerdirs in the overlayfs
> instance.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> [amir: rename to struct ovl_layer lower_layers and struct ovl_path]
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/inode.c     | 18 +++++++++++
>  fs/overlayfs/namei.c     | 52 ++++++++++++++++++-------------
>  fs/overlayfs/overlayfs.h |  4 +--
>  fs/overlayfs/ovl_entry.h | 14 +++++++--
>  fs/overlayfs/readdir.c   |  4 +--
>  fs/overlayfs/super.c     | 80 ++++++++++++++++++++++++++++++------------------
>  fs/overlayfs/util.c      |  7 ++++-
>  7 files changed, 121 insertions(+), 58 deletions(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 50e233ccca53..ec5c3ce91868 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -8,6 +8,7 @@
>   */
>
>  #include <linux/fs.h>
> +#include <linux/mount.h>
>  #include <linux/slab.h>
>  #include <linux/cred.h>
>  #include <linux/xattr.h>
> @@ -15,6 +16,21 @@
>  #include <linux/ratelimit.h>
>  #include "overlayfs.h"
>
> +
> +static dev_t ovl_get_pseudo_dev(struct dentry *dentry, dev_t dev)
> +{
> +       struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
> +       struct ovl_entry *oe = dentry->d_fsdata;
> +
> +       if (ofs->upper_mnt && ofs->upper_mnt->mnt_sb->s_dev == dev)
> +               return dev;

This doesn't feel right. Okay, we may want to check against upper
device number for sanity and WARN if doesn't match, although we can
have all sorts of weirdness with btrfs, for example.   So the logic
should be:

if type is upper then use the dev returned by stat
else return the pseudo dev


> +
> +       if (oe->numlower)
> +               return oe->lowerstack[0].layer->pseudo_dev;
> +
> +       return dev;
> +}
> +
>  int ovl_setattr(struct dentry *dentry, struct iattr *attr)
>  {
>         int err;
> @@ -121,6 +137,8 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>                  */
>                 stat->dev = dentry->d_sb->s_dev;
>                 stat->ino = dentry->d_inode->i_ino;
> +       } else {
> +               stat->dev = ovl_get_pseudo_dev(dentry, stat->dev);
>         }
>
>         /*

The above can be a separate patch.  I.e. split this into:

 1) add ovl_layer infrastructure
 2) use that infrastructure in getattr

1) doesn't change functionality while 2) does.

> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index de2dac98e147..78e965527167 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -285,16 +285,15 @@ static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
>
>
>  static int ovl_check_origin(struct dentry *upperdentry,
> -                           struct path *lowerstack, unsigned int numlower,
> -                           struct path **stackp, unsigned int *ctrp)
> +                           struct ovl_path *lower, unsigned int numlower,
> +                           struct ovl_path **stackp, unsigned int *ctrp)
>  {
>         struct vfsmount *mnt;
>         struct dentry *origin = NULL;
>         int i;
>
> -
>         for (i = 0; i < numlower; i++) {
> -               mnt = lowerstack[i].mnt;
> +               mnt = lower[i].layer->mnt;
>                 origin = ovl_get_origin(upperdentry, mnt);
>                 if (IS_ERR(origin))
>                         return PTR_ERR(origin);
> @@ -308,12 +307,12 @@ static int ovl_check_origin(struct dentry *upperdentry,
>
>         BUG_ON(*ctrp);
>         if (!*stackp)
> -               *stackp = kmalloc(sizeof(struct path), GFP_KERNEL);
> +               *stackp = kmalloc(sizeof(struct ovl_path), GFP_KERNEL);
>         if (!*stackp) {
>                 dput(origin);
>                 return -ENOMEM;
>         }
> -       **stackp = (struct path) { .dentry = origin, .mnt = mnt };
> +       **stackp = (struct ovl_path){.dentry = origin, .layer = lower[i].layer};
>         *ctrp = 1;
>
>         return 0;
> @@ -383,13 +382,13 @@ int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
>   * OVL_XATTR_ORIGIN and that origin file handle can be decoded to lower path.
>   * Return 0 on match, -ESTALE on mismatch or stale origin, < 0 on error.
>   */
> -int ovl_verify_index(struct dentry *index, struct path *lowerstack,
> +int ovl_verify_index(struct dentry *index, struct ovl_path *lower,
>                      unsigned int numlower)
>  {
>         struct ovl_fh *fh = NULL;
>         size_t len;
> -       struct path origin = { };
> -       struct path *stack = &origin;
> +       struct ovl_path origin = { };
> +       struct ovl_path *stack = &origin;
>         unsigned int ctr = 0;
>         int err;
>
> @@ -428,7 +427,7 @@ int ovl_verify_index(struct dentry *index, struct path *lowerstack,
>         if (err)
>                 goto fail;
>
> -       err = ovl_check_origin(index, lowerstack, numlower, &stack, &ctr);
> +       err = ovl_check_origin(index, lower, numlower, &stack, &ctr);
>         if (!err && !ctr)
>                 err = -ESTALE;
>         if (err)
> @@ -570,11 +569,24 @@ int ovl_path_next(int idx, struct dentry *dentry, struct path *path, int *idxp)
>         }
>         BUG_ON(idx > oe->numlower);
>         *idxp = idx;
> -       *path = oe->lowerstack[idx - 1];
> +       path->dentry = oe->lowerstack[idx - 1].dentry;
> +       path->mnt = oe->lowerstack[idx - 1].layer->mnt;
>
>         return (idx < oe->numlower) ? idx + 1 : -1;
>  }
>
> +static int ovl_find_layer(struct ovl_fs *ofs, struct ovl_path *path)
> +{
> +       int i;
> +
> +       for (i = 0; i < ofs->numlower; i++) {
> +               if (ofs->lower_layers[i].mnt == path->layer->mnt)
> +                       break;
> +       }
> +
> +       return i;
> +}
> +
>  struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                           unsigned int flags)
>  {
> @@ -583,7 +595,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>         struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
>         struct ovl_entry *poe = dentry->d_parent->d_fsdata;
>         struct ovl_entry *roe = dentry->d_sb->s_root->d_fsdata;
> -       struct path *stack = NULL;
> +       struct ovl_path *stack = NULL;
>         struct dentry *upperdir, *upperdentry = NULL;
>         struct dentry *index = NULL;
>         unsigned int ctr = 0;
> @@ -648,17 +660,17 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>
>         if (!d.stop && poe->numlower) {
>                 err = -ENOMEM;
> -               stack = kcalloc(ofs->numlower, sizeof(struct path),
> +               stack = kcalloc(ofs->numlower, sizeof(struct ovl_path),
>                                 GFP_KERNEL);
>                 if (!stack)
>                         goto out_put_upper;
>         }
>
>         for (i = 0; !d.stop && i < poe->numlower; i++) {
> -               struct path lowerpath = poe->lowerstack[i];
> +               struct ovl_path lower = poe->lowerstack[i];
>
>                 d.last = i == poe->numlower - 1;
> -               err = ovl_lookup_layer(lowerpath.dentry, &d, &this);
> +               err = ovl_lookup_layer(lower.dentry, &d, &this);
>                 if (err)
>                         goto out_put;
>
> @@ -666,7 +678,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                         continue;
>
>                 stack[ctr].dentry = this;
> -               stack[ctr].mnt = lowerpath.mnt;
> +               stack[ctr].layer = lower.layer;
>                 ctr++;
>
>                 if (d.stop)
> @@ -676,10 +688,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                         poe = roe;
>
>                         /* Find the current layer on the root dentry */
> -                       for (i = 0; i < poe->numlower; i++)
> -                               if (poe->lowerstack[i].mnt == lowerpath.mnt)
> -                                       break;
> -                       if (WARN_ON(i == poe->numlower))
> +                       i = ovl_find_layer(ofs, &lower);
> +                       if (WARN_ON(i == ofs->numlower))
>                                 break;
>                 }
>         }
> @@ -702,7 +712,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 goto out_put;
>
>         oe->opaque = upperopaque;
> -       memcpy(oe->lowerstack, stack, sizeof(struct path) * ctr);
> +       memcpy(oe->lowerstack, stack, sizeof(struct ovl_path) * ctr);
>         dentry->d_fsdata = oe;
>
>         if (upperdentry)
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 73ef1e850635..335e9a052995 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -248,7 +248,7 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
>  /* namei.c */
>  int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
>                       struct dentry *origin, bool is_upper, bool set);
> -int ovl_verify_index(struct dentry *index, struct path *lowerstack,
> +int ovl_verify_index(struct dentry *index, struct ovl_path *lower,
>                      unsigned int numlower);
>  int ovl_get_index_name(struct dentry *origin, struct qstr *name);
>  int ovl_path_next(int idx, struct dentry *dentry, struct path *path, int *idxp);
> @@ -265,7 +265,7 @@ int ovl_check_d_type_supported(struct path *realpath);
>  void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
>                          struct dentry *dentry, int level);
>  int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
> -                        struct path *lowerstack, unsigned int numlower);
> +                        struct ovl_path *lower, unsigned int numlower);
>
>  /* inode.c */
>  int ovl_set_nlink_upper(struct dentry *dentry);
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 25d9b5adcd42..93eb6a044dd2 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -17,11 +17,21 @@ struct ovl_config {
>         bool index;
>  };
>
> +struct ovl_layer {
> +       struct vfsmount *mnt;
> +       dev_t pseudo_dev;
> +};
> +
> +struct ovl_path {
> +       struct ovl_layer *layer;
> +       struct dentry *dentry;
> +};
> +
>  /* private information held for overlayfs's superblock */
>  struct ovl_fs {
>         struct vfsmount *upper_mnt;
>         unsigned numlower;
> -       struct vfsmount **lower_mnt;
> +       struct ovl_layer *lower_layers;
>         /* workbasedir is the path at workdir= mount option */
>         struct dentry *workbasedir;
>         /* workdir is the 'work' directory under workbasedir */
> @@ -52,7 +62,7 @@ struct ovl_entry {
>                 struct rcu_head rcu;
>         };
>         unsigned numlower;
> -       struct path lowerstack[];
> +       struct ovl_path lowerstack[];
>  };
>
>  struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index bcc123c7706c..0ab657f2c1c8 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -1020,7 +1020,7 @@ void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
>  }
>
>  int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
> -                        struct path *lowerstack, unsigned int numlower)
> +                        struct ovl_path *lower, unsigned int numlower)
>  {
>         int err;
>         struct dentry *index = NULL;
> @@ -1055,7 +1055,7 @@ int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
>                         index = NULL;
>                         break;
>                 }
> -               err = ovl_verify_index(index, lowerstack, numlower);
> +               err = ovl_verify_index(index, lower, numlower);
>                 /* Cleanup stale and orphan index entries */
>                 if (err && (err == -ESTALE || err == -ENOENT))
>                         err = ovl_cleanup(dir, index);
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 8702803ba328..323dfd7a0236 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -219,9 +219,11 @@ static void ovl_put_super(struct super_block *sb)
>         if (ufs->upper_mnt && ufs->upperdir_locked)
>                 ovl_inuse_unlock(ufs->upper_mnt->mnt_root);
>         mntput(ufs->upper_mnt);
> -       for (i = 0; i < ufs->numlower; i++)
> -               mntput(ufs->lower_mnt[i]);
> -       kfree(ufs->lower_mnt);
> +       for (i = 0; i < ufs->numlower; i++) {
> +               mntput(ufs->lower_layers[i].mnt);
> +               free_anon_bdev(ufs->lower_layers[i].pseudo_dev);
> +       }
> +       kfree(ufs->lower_layers);
>
>         kfree(ufs->config.lowerdir);
>         kfree(ufs->config.upperdir);
> @@ -1026,24 +1028,35 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>         }
>
>         err = -ENOMEM;
> -       ufs->lower_mnt = kcalloc(numlower, sizeof(struct vfsmount *), GFP_KERNEL);
> -       if (ufs->lower_mnt == NULL)
> +       ufs->lower_layers = kcalloc(numlower, sizeof(struct ovl_layer),
> +                                   GFP_KERNEL);
> +       if (ufs->lower_layers == NULL)
>                 goto out_put_workdir;
>         for (i = 0; i < numlower; i++) {
> -               struct vfsmount *mnt = clone_private_mount(&stack[i]);
> +               struct vfsmount *mnt;
> +               dev_t dev;
> +
> +               err = get_anon_bdev(&dev);
> +               if (err) {
> +                       pr_err("overlayfs: failed to get anonymous bdev for lowerpath\n");
> +                       goto out_put_lower_layers;
> +               }
>
> +               mnt = clone_private_mount(&stack[i]);
>                 err = PTR_ERR(mnt);
>                 if (IS_ERR(mnt)) {
>                         pr_err("overlayfs: failed to clone lowerpath\n");
> -                       goto out_put_lower_mnt;
> +                       free_anon_bdev(dev);
> +                       goto out_put_lower_layers;
>                 }
>                 /*
> -                * Make lower_mnt R/O.  That way fchmod/fchown on lower file
> +                * Make lower layers R/O.  That way fchmod/fchown on lower file
>                  * will fail instead of modifying lower fs.
>                  */
>                 mnt->mnt_flags |= MNT_READONLY | MNT_NOATIME;
>
> -               ufs->lower_mnt[ufs->numlower] = mnt;
> +               ufs->lower_layers[ufs->numlower].mnt = mnt;
> +               ufs->lower_layers[ufs->numlower].pseudo_dev = dev;
>                 ufs->numlower++;
>
>                 /* Check if all lower layers are on same sb */
> @@ -1059,13 +1072,25 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>         else if (ufs->upper_mnt->mnt_sb != ufs->same_sb)
>                 ufs->same_sb = NULL;
>
> +       err = -ENOMEM;
> +       oe = ovl_alloc_entry(numlower);
> +       if (!oe)
> +               goto out_put_lower_layers;
> +
> +       for (i = 0; i < numlower; i++) {
> +               oe->lowerstack[i].dentry = stack[i].dentry;
> +               oe->lowerstack[i].layer = &(ufs->lower_layers[i]);
> +       }
> +
>         if (!(ovl_force_readonly(ufs)) && ufs->config.index) {
>                 /* Verify lower root is upper root origin */
> -               err = ovl_verify_origin(upperpath.dentry, ufs->lower_mnt[0],
> -                                       stack[0].dentry, false, true);
> +               err = ovl_verify_origin(upperpath.dentry,
> +                                       oe->lowerstack[0].layer->mnt,
> +                                       oe->lowerstack[0].dentry,
> +                                       false, true);
>                 if (err) {
>                         pr_err("overlayfs: failed to verify upper root origin\n");
> -                       goto out_put_lower_mnt;
> +                       goto out_free_oe;
>                 }
>
>                 ufs->indexdir = ovl_workdir_create(sb, ufs, workpath.dentry,
> @@ -1081,7 +1106,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>                         if (!err)
>                                 err = ovl_indexdir_cleanup(ufs->indexdir,
>                                                            ufs->upper_mnt,
> -                                                          stack, numlower);
> +                                                          oe->lowerstack,
> +                                                          numlower);
>                 }
>                 if (err || !ufs->indexdir)
>                         pr_warn("overlayfs: try deleting index dir or mounting with '-o index=off' to disable inodes index.\n");
> @@ -1106,11 +1132,6 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>         /* Never override disk quota limits or use reserved space */
>         cap_lower(cred->cap_effective, CAP_SYS_RESOURCE);
>
> -       err = -ENOMEM;
> -       oe = ovl_alloc_entry(numlower);
> -       if (!oe)
> -               goto out_put_cred;
> -
>         sb->s_magic = OVERLAYFS_SUPER_MAGIC;
>         sb->s_op = &ovl_super_operations;
>         sb->s_xattr = ovl_xattr_handlers;
> @@ -1119,11 +1140,12 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>
>         root_dentry = d_make_root(ovl_new_inode(sb, S_IFDIR, 0));
>         if (!root_dentry)
> -               goto out_free_oe;
> +               goto out_put_cred;
>
>         mntput(upperpath.mnt);
>         for (i = 0; i < numlower; i++)
>                 mntput(stack[i].mnt);
> +       kfree(stack);
>         mntput(workpath.mnt);
>         kfree(lowertmp);
>
> @@ -1132,11 +1154,6 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>                 if (ovl_is_impuredir(upperpath.dentry))
>                         ovl_set_flag(OVL_IMPURE, d_inode(root_dentry));
>         }
> -       for (i = 0; i < numlower; i++) {
> -               oe->lowerstack[i].dentry = stack[i].dentry;
> -               oe->lowerstack[i].mnt = ufs->lower_mnt[i];
> -       }
> -       kfree(stack);
>
>         root_dentry->d_fsdata = oe;
>
> @@ -1147,16 +1164,19 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>
>         return 0;
>
> -out_free_oe:
> -       kfree(oe);
>  out_put_cred:
>         put_cred(ufs->creator_cred);
>  out_put_indexdir:
>         dput(ufs->indexdir);
> -out_put_lower_mnt:
> -       for (i = 0; i < ufs->numlower; i++)
> -               mntput(ufs->lower_mnt[i]);
> -       kfree(ufs->lower_mnt);
> +out_free_oe:
> +       kfree(oe);
> +out_put_lower_layers:
> +       for (i = 0; i < ufs->numlower; i++) {
> +               if (ufs->lower_layers[i].mnt)
> +                       free_anon_bdev(ufs->lower_layers[i].pseudo_dev);
> +               mntput(ufs->lower_layers[i].mnt);
> +       }
> +       kfree(ufs->lower_layers);
>  out_put_workdir:
>         dput(ufs->workdir);
>         mntput(ufs->upper_mnt);

I'm not even attempting to review the ovl_fill_super() changes.  We
need to do something about that function (it's my fault for letting it
grow this big and convoluted).  Do you want me to have a go at
cleaning it up?  Or do you feel an urging desire to do so?

Thanks,
Miklos


> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 9158d17bb320..d6bb1c9f5e7a 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -124,7 +124,12 @@ void ovl_path_lower(struct dentry *dentry, struct path *path)
>  {
>         struct ovl_entry *oe = dentry->d_fsdata;
>
> -       *path = oe->numlower ? oe->lowerstack[0] : (struct path) { };
> +       if (oe->numlower) {
> +               path->mnt = oe->lowerstack[0].layer->mnt;
> +               path->dentry = oe->lowerstack[0].dentry;
> +       } else {
> +               *path = (struct path) { };
> +       }
>  }
>
>  enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path)
> --
> 2.7.4
>
