Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1523932965-25792-3-git-send-email-cgxu519@gmx.com>
References: <1523932965-25792-1-git-send-email-cgxu519@gmx.com> <1523932965-25792-3-git-send-email-cgxu519@gmx.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 17 Apr 2018 13:41:37 +0300
Message-ID: <CAOQ4uxinZnZG4teKWgdXfFp_9nYgC=TOgsMLq=qruAY2CS91Pw@mail.gmail.com>
Subject: Re: [PATCH 3/3] ovl: introduce a dedicated cache pool for ovl_entry
Content-Type: text/plain; charset="UTF-8"
To: Chengguang Xu <cgxu519@gmx.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Apr 17, 2018 at 5:42 AM, Chengguang Xu <cgxu519@gmx.com> wrote:
> Introduce a dedicated cache pool for ovl_entry to optimize
> memory allocation adn deallocation.
>
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> ---
>  fs/overlayfs/export.c    | 11 +++++++----
>  fs/overlayfs/namei.c     |  7 +++++--
>  fs/overlayfs/overlayfs.h |  4 ++++
>  fs/overlayfs/ovl_entry.h |  9 +++++----
>  fs/overlayfs/super.c     | 38 +++++++++++++++++++++++++++++---------
>  fs/overlayfs/util.c      | 28 ++++++++++++++++++++++++----
>  6 files changed, 74 insertions(+), 23 deletions(-)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index f2ba5fb..b1047ae 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -321,8 +321,8 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
>                         goto nomem;
>
>                 if (lower) {
> -                       oe->lowerstack->dentry = dget(lower);
> -                       oe->lowerstack->layer = lowerpath->layer;
> +                       oe->lowerstack.dentry = dget(lower);
> +                       oe->lowerstack.layer = lowerpath->layer;
>                 }
>                 dentry->d_fsdata = oe;
>                 if (upper_alias)
> @@ -346,9 +346,12 @@ static struct dentry *ovl_dentry_real_at(struct dentry *dentry, int idx)
>         if (!idx)
>                 return ovl_dentry_upper(dentry);
>
> +       if (oe->numlower == 1 && oe->lowerstack.layer->idx == idx)
> +               return oe->lowerstack.dentry;
> +
>         for (i = 0; i < oe->numlower; i++) {
> -               if (oe->lowerstack[i].layer->idx == idx)
> -                       return oe->lowerstack[i].dentry;
> +               if (oe->lowerstacks[i].layer->idx == idx)
> +                       return oe->lowerstacks[i].dentry;
>         }
>
>         return NULL;
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index eb3ec6c..51fd914 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -994,7 +994,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>         if (!oe)
>                 goto out_put;
>
> -       memcpy(oe->lowerstack, stack, sizeof(struct ovl_path) * ctr);
> +       if (oe->numlower == 1)
> +               memcpy(&oe->lowerstack, stack, sizeof(struct ovl_path));
> +       else
> +               memcpy(oe->lowerstacks, stack, sizeof(struct ovl_path) * ctr);
>         dentry->d_fsdata = oe;
>
>         if (upperopaque)
> @@ -1028,7 +1031,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>
>  out_free_oe:
>         dentry->d_fsdata = NULL;
> -       kfree(oe);
> +       ovl_free_entry(oe);
>  out_put:
>         dput(index);
>         for (i = 0; i < ctr; i++)
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 8039602..a104e02 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -207,6 +207,7 @@ static inline struct dentry *ovl_do_tmpfile(struct dentry *dentry, umode_t mode)
>  bool ovl_index_all(struct super_block *sb);
>  bool ovl_verify_lower(struct super_block *sb);
>  struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
> +void ovl_free_entry(struct ovl_entry *oe);
>  bool ovl_dentry_remote(struct dentry *dentry);
>  bool ovl_dentry_weird(struct dentry *dentry);
>  enum ovl_path_type ovl_path_type(struct dentry *dentry);
> @@ -378,3 +379,6 @@ int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
>
>  /* export.c */
>  extern const struct export_operations ovl_export_operations;
> +
> +/* super.c */
> +extern struct kmem_cache *ovl_entry_cachep;
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 41655a7..3ed8ab4 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -71,13 +71,14 @@ struct ovl_fs {
>  /* private information held for every overlayfs dentry */
>  struct ovl_entry {
>         union {
> -               struct {
> -                       unsigned long flags;
> -               };
> +               unsigned long flags;
>                 struct rcu_head rcu;
>         };
>         unsigned numlower;
> -       struct ovl_path lowerstack[];
> +       union {
> +               struct ovl_path lowerstack;
> +               struct ovl_path *lowerstacks;
> +       };

1. The names are not representative to what they stand for
'stack' is something containing many items already, so you
want 'lowerpath' (numlower == 1) and 'lowerstack' (numlower > 1).

2. I suggested a different approach, not sure if it is better.
I will repeat it in case you did not understand me:

       struct ovl_path lowerstack[1];

this approach requires no union and most of the code that does
if (numlower == 1) can be removed.
Only need special casing alloc and free (see below).

>  };
>
>  struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 38c1dd1..6327497 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -60,8 +60,11 @@ static void ovl_entry_stack_free(struct ovl_entry *oe)
>  {
>         unsigned int i;
>
> -       for (i = 0; i < oe->numlower; i++)
> -               dput(oe->lowerstack[i].dentry);
> +       if (oe->numlower == 1)
> +               dput(oe->lowerstack.dentry);
> +       else
> +               for (i = 0; i < oe->numlower; i++)
> +                       dput(oe->lowerstacks[i].dentry);

No special casing here.

>  }
>
>  static void ovl_dentry_release(struct dentry *dentry)
> @@ -191,6 +194,7 @@ static int ovl_dentry_weak_revalidate(struct dentry *dentry, unsigned int flags)
>  };
>
>  static struct kmem_cache *ovl_inode_cachep;
> +struct kmem_cache *ovl_entry_cachep;
>
>  static struct inode *ovl_alloc_inode(struct super_block *sb)
>  {
> @@ -1332,9 +1336,14 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
>         if (!oe)
>                 goto out_err;
>
> -       for (i = 0; i < numlower; i++) {
> -               oe->lowerstack[i].dentry = dget(stack[i].dentry);
> -               oe->lowerstack[i].layer = &ofs->lower_layers[i];
> +       if (numlower == 1) {
> +               oe->lowerstack.dentry = stack[0].dentry;
> +               oe->lowerstack.layer = &ofs->lower_layers[0];
> +       } else {
> +               for (i = 0; i < numlower; i++) {
> +                       oe->lowerstacks[i].dentry = dget(stack[i].dentry);
> +                       oe->lowerstacks[i].layer = &ofs->lower_layers[i];
> +               }

No special casing here.

>         }
>
>         if (remote)
> @@ -1515,20 +1524,31 @@ static void ovl_inode_init_once(void *foo)
>
>  static int __init ovl_init(void)
>  {
> -       int err;
> +       int err = -ENOMEM;
>
>         ovl_inode_cachep = kmem_cache_create("ovl_inode",
>                                              sizeof(struct ovl_inode), 0,
>                                              (SLAB_RECLAIM_ACCOUNT|
>                                               SLAB_MEM_SPREAD|SLAB_ACCOUNT),
>                                              ovl_inode_init_once);
> -       if (ovl_inode_cachep == NULL)
> -               return -ENOMEM;
> +       if (!ovl_inode_cachep)
> +               return err;
> +
> +       ovl_entry_cachep = KMEM_CACHE(ovl_entry,
> +                               SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
> +       if (!ovl_entry_cachep)
> +               goto bad_entry_cachep;
>
>         err = register_filesystem(&ovl_fs_type);
>         if (err)
> -               kmem_cache_destroy(ovl_inode_cachep);
> +               goto err_out;
>
> +       return 0;
> +
> +err_out:
> +       kmem_cache_destroy(ovl_entry_cachep);
> +bad_entry_cachep:
> +       kmem_cache_destroy(ovl_inode_cachep);
>         return err;
>  }
>
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index a3459e6..7d4ff3e 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -95,13 +95,30 @@ bool ovl_verify_lower(struct super_block *sb)
>         return ofs->config.nfs_export && ofs->config.index;
>  }
>
> +void ovl_free_entry(struct ovl_entry *oe)
> +{
> +       if (oe->numlower > 1)
> +               kfree(oe->lowerstacks);
> +

      if (oe->numlower > 1)
              kfree(oe);
      else

> +       kmem_cache_free(ovl_entry_cachep, oe);
> +}
> +
>  struct ovl_entry *ovl_alloc_entry(unsigned int numlower)
>  {
> -       size_t size = offsetof(struct ovl_entry, lowerstack[numlower]);
> -       struct ovl_entry *oe = kzalloc(size, GFP_KERNEL);
> +       size_t size = sizeof(struct ovl_path) * numlower;
> +       struct ovl_entry *oe;
>
> -       if (oe)
> +       oe = kmem_cache_zalloc(ovl_entry_cachep, GFP_KERNEL);

    if (numlower > 1) {
       size = offsetof(struct ovl_entry, lowerstack[numlower]);
       oe = kzalloc(size, GFP_KERNEL);
   } else {
       oe = kmem_cache_zalloc(ovl_entry_cachep, GFP_KERNEL);
   }

> +       if (oe) {
>                 oe->numlower = numlower;
> +               if (numlower > 1) {
> +                       oe->lowerstacks = kzalloc(size, GFP_KERNEL);
> +                       if (!oe->lowerstacks) {
> +                               kmem_cache_free(ovl_entry_cachep, oe);
> +                               oe = NULL;
> +                       }
> +               }
> +       }
>
>         return oe;
>  }
> @@ -186,7 +203,10 @@ struct ovl_path *__ovl_path_lower(struct ovl_entry *oe, int layer)
>         if (layer > oe->numlower)
>                 return NULL;
>
> -       return &oe->lowerstack[layer - 1];
> +       if (layer == 1 && oe->numlower == 1)
> +               return &oe->lowerstack;
> +       else
> +               return &oe->lowerstacks[layer - 1];
>  }
>

No special casing here.

Thanks,
Amir.
