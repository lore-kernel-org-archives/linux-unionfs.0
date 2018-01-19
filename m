From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 03/17] ovl: decode pure upper file handles
Date: Fri, 19 Jan 2018 13:07:19 +0200
Message-ID: <CAOQ4uxgdww=-R24R4quD4iV0oJ9Wj5WC_-tkvOF_kZgHKa3P5w@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
 <1515086449-26563-4-git-send-email-amir73il@gmail.com> <CAJfpegt=4Mk7B7E9c7CGJHdWZsVFQAqfJ_NbRNQNOpSZFYudrg@mail.gmail.com>
 <CAOQ4uxg34b6TZ6hwPczv_m_HquR6apnPy0gexHezixMedVqUZA@mail.gmail.com>
 <CAJfpegttoV7aPN2sS6RXONh0eFQ9xyoFxZbzVG7UMCcAJ+zjtg@mail.gmail.com>
 <CAOQ4uxhaC3b2N1rNCBgv0MTyBQgWFZKyVV60VWnudb_wY6A98Q@mail.gmail.com>
 <CAJfpeguVZztckNqML_hJRrEXumMMAeB6+Ha2djPrmCbqXz1brw@mail.gmail.com>
 <CAOQ4uxh0EEuhsLxD3M_xngMd14C=hGb8U12yPe=duELwb4yNDQ@mail.gmail.com>
 <CAOQ4uxhHUaorYA5ZAXQrfaOrp6Xa4cabz+ZFRdVBp6Mf-ebb0g@mail.gmail.com>
 <CAOQ4uxhO+oOGWfSnafNO84GYT0_ihNtR_ekna+DH7rzWMZTgwg@mail.gmail.com> <20180119103952.GA24104@veci.piliscsaba.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20180119103952.GA24104@veci.piliscsaba.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Jan 19, 2018 at 12:39 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Jan 19, 2018 at 02:23:35AM +0200, Amir Goldstein wrote:
>> > How is this for an option?
> [...]
>> > +struct dentry *d_obtain_alias_fsdata(struct inode *inode, void **fsdata)
>> > +{
>> > +       return __d_obtain_alias(inode, 1, fsdata);
>> >  }
>> >  EXPORT_SYMBOL(d_obtain_alias);
>
> It would work, but I like this interface better:
>
> +extern struct dentry * d_alloc_anon(struct super_block *);
> +extern struct dentry * d_instantiate_anon(struct dentry *, struct inode *);
>

OK. Thanks for the patch!

> And full patch:
>
> diff --git a/fs/dcache.c b/fs/dcache.c
> index b5d5ea984ac4..15dc32178813 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1699,9 +1699,15 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
>  }
>  EXPORT_SYMBOL(d_alloc);
>
> +struct dentry *d_alloc_anon(struct super_block *sb)
> +{
> +       return __d_alloc(sb, NULL);
> +}
> +EXPORT_SYMBOL(d_alloc_anon);
> +
>  struct dentry *d_alloc_cursor(struct dentry * parent)
>  {
> -       struct dentry *dentry = __d_alloc(parent->d_sb, NULL);
> +       struct dentry *dentry = d_alloc_anon(parent->d_sb);
>         if (dentry) {
>                 dentry->d_flags |= DCACHE_RCUACCESS | DCACHE_DENTRY_CURSOR;
>                 dentry->d_parent = dget(parent);
> @@ -1887,7 +1893,7 @@ struct dentry *d_make_root(struct inode *root_inode)
>         struct dentry *res = NULL;
>
>         if (root_inode) {
> -               res = __d_alloc(root_inode->i_sb, NULL);
> +               res = d_alloc_anon(root_inode->i_sb);
>                 if (res)
>                         d_instantiate(res, root_inode);
>                 else
> @@ -1926,33 +1932,18 @@ struct dentry *d_find_any_alias(struct inode *inode)
>  }
>  EXPORT_SYMBOL(d_find_any_alias);
>
> -static struct dentry *__d_obtain_alias(struct inode *inode, int disconnected)
> +static struct dentry *__d_instantiate_anon(struct dentry *dentry,
> +                                          struct inode *inode,
> +                                          bool disconnected)
>  {
> -       struct dentry *tmp;
>         struct dentry *res;
> -       unsigned add_flags;
> -
> -       if (!inode)
> -               return ERR_PTR(-ESTALE);
> -       if (IS_ERR(inode))
> -               return ERR_CAST(inode);
> -
> -       res = d_find_any_alias(inode);
> -       if (res)
> -               goto out_iput;
>
> -       tmp = __d_alloc(inode->i_sb, NULL);
> -       if (!tmp) {
> -               res = ERR_PTR(-ENOMEM);
> -               goto out_iput;
> -       }
> -
> -       security_d_instantiate(tmp, inode);
> +       security_d_instantiate(dentry, inode);
>         spin_lock(&inode->i_lock);
>         res = __d_find_any_alias(inode);
>         if (res) {
>                 spin_unlock(&inode->i_lock);
> -               dput(tmp);
> +               dput(dentry);
>                 goto out_iput;
>         }
>
> @@ -1962,22 +1953,56 @@ static struct dentry *__d_obtain_alias(struct inode *inode, int disconnected)
>         if (disconnected)
>                 add_flags |= DCACHE_DISCONNECTED;
>
> -       spin_lock(&tmp->d_lock);
> -       __d_set_inode_and_type(tmp, inode, add_flags);
> -       hlist_add_head(&tmp->d_u.d_alias, &inode->i_dentry);
> -       hlist_bl_lock(&tmp->d_sb->s_anon);
> -       hlist_bl_add_head(&tmp->d_hash, &tmp->d_sb->s_anon);
> -       hlist_bl_unlock(&tmp->d_sb->s_anon);
> -       spin_unlock(&tmp->d_lock);
> +       spin_lock(&dentry->d_lock);
> +       __d_set_inode_and_type(dentry, inode, add_flags);
> +       hlist_add_head(&dentry->d_u.d_alias, &inode->i_dentry);
> +       hlist_bl_lock(&dentry->d_sb->s_anon);
> +       hlist_bl_add_head(&dentry->d_hash, &dentry->d_sb->s_anon);
> +       hlist_bl_unlock(&dentry->d_sb->s_anon);
> +       spin_unlock(&dentry->d_lock);
>         spin_unlock(&inode->i_lock);
>
> -       return tmp;
> +       return dentry;
>
>   out_iput:
>         iput(inode);
>         return res;
>  }
>
> +struct dentry *d_instantiate_anon(struct dentry *dentry, struct inode *inode)
> +{
> +       return __d_instantiate_anon(dentry, inode, true);
> +}
> +EXPORT_SYMBOL(d_instantiate_anon);
> +
> +static struct dentry *__d_obtain_alias(struct inode *inode, bool disconnected)
> +{
> +       struct dentry *tmp;
> +       struct dentry *res;
> +       unsigned add_flags;
> +
> +       if (!inode)
> +               return ERR_PTR(-ESTALE);
> +       if (IS_ERR(inode))
> +               return ERR_CAST(inode);
> +
> +       res = d_find_any_alias(inode);
> +       if (res)
> +               goto out_iput;
> +
> +       tmp = d_alloc_anon(inode->i_sb);
> +       if (!tmp) {
> +               res = ERR_PTR(-ENOMEM);
> +               goto out_iput;
> +       }
> +
> +       return __d_instantiate_anon(tmp, inode, disconnected);
> +
> +out_iput:
> +       iput(inode);
> +       return res;
> +}
> +
>  /**
>   * d_obtain_alias - find or allocate a DISCONNECTED dentry for a given inode
>   * @inode: inode to allocate the dentry for
> @@ -1998,7 +2023,7 @@ static struct dentry *__d_obtain_alias(struct inode *inode, int disconnected)
>   */
>  struct dentry *d_obtain_alias(struct inode *inode)
>  {
> -       return __d_obtain_alias(inode, 1);
> +       return __d_obtain_alias(inode, true);
>  }
>  EXPORT_SYMBOL(d_obtain_alias);
>
> @@ -2019,7 +2044,7 @@ EXPORT_SYMBOL(d_obtain_alias);
>   */
>  struct dentry *d_obtain_root(struct inode *inode)
>  {
> -       return __d_obtain_alias(inode, 0);
> +       return __d_obtain_alias(inode, false);
>  }
>  EXPORT_SYMBOL(d_obtain_root);
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 25461781c103..7477f28cb99b 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -184,28 +184,32 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
>                 return ERR_CAST(inode);
>         }
>
> -       dentry = d_obtain_alias(inode);
> -       if (IS_ERR(dentry) || dentry->d_fsdata)
> -               return dentry;
> -
> -       oe = ovl_alloc_entry(!!lower);
> -       if (!oe) {
> -               dput(dentry);
> -               return ERR_PTR(-ENOMEM);
> -       }
> +       if (index)
> +               ovl_set_flag(OVL_INDEX, inode);
>
> -       dentry->d_fsdata = oe;
> -       if (upper_alias)
> -               ovl_dentry_set_upper_alias(dentry);
> -       if (lower) {
> -               oe->lowerstack->dentry = dget(lower);
> -               oe->lowerstack->layer = lowerpath->layer;
> +       dentry = d_find_any_alias(inode);
> +       if (!dentry) {
> +               dentry = d_alloc_anon(inode->i_sb);
> +               if (!dentry)
> +                       goto nomem;
> +               oe = ovl_alloc_entry(lower ? 1 : 0);
> +               if (!oe)
> +                       goto nomem;
> +               if (lower) {
> +                       oe->lowerstack->dentry = dget(lower);
> +                       oe->lowerstack->layer = lowerpath->layer;
> +               }
> +               dentry->d_fsdata = oe;
> +               if (upper_alias)
> +                       ovl_dentry_set_upper_alias(dentry);
>         }
>
> -       if (index)
> -               ovl_set_flag(OVL_INDEX, inode);
> +       return d_instantiate_anon(dentry, inode);
>
> -       return dentry;
> +nomem:
> +       iput(inode);
> +       dput(dentry);
> +       return ERR_PTR(-ENOMEM);
>  }
>
>  /* Get the upper or lower dentry in stach whose on layer @idx */
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index 65cd8ab60b7a..82a99d366aec 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -227,6 +227,7 @@ extern seqlock_t rename_lock;
>   */
>  extern void d_instantiate(struct dentry *, struct inode *);
>  extern struct dentry * d_instantiate_unique(struct dentry *, struct inode *);
> +extern struct dentry * d_instantiate_anon(struct dentry *, struct inode *);
>  extern int d_instantiate_no_diralias(struct dentry *, struct inode *);
>  extern void __d_drop(struct dentry *dentry);
>  extern void d_drop(struct dentry *dentry);
> @@ -235,6 +236,7 @@ extern void d_set_d_op(struct dentry *dentry, const struct dentry_operations *op
>
>  /* allocate/de-allocate */
>  extern struct dentry * d_alloc(struct dentry *, const struct qstr *);
> +extern struct dentry * d_alloc_anon(struct super_block *);
>  extern struct dentry * d_alloc_pseudo(struct super_block *, const struct qstr *);
>  extern struct dentry * d_alloc_parallel(struct dentry *, const struct qstr *,
>                                         wait_queue_head_t *);
>
