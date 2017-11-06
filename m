From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v7 8/8] ovl: ovl_iterate_real() for all pure upper/lower
 in non-samefs case
Date: Mon, 6 Nov 2017 10:35:31 +0100
Message-ID: <CAJfpegt8d6iqWfmwdQtjaag47JkvebKrNgn0SvWSegVJ5VZPyA@mail.gmail.com>
References: <1509655091-13630-1-git-send-email-amir73il@gmail.com> <1509655091-13630-9-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:45664 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbdKFJfd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 6 Nov 2017 04:35:33 -0500
Received: by mail-wm0-f66.google.com with SMTP id y80so12309488wmd.0
        for <linux-unionfs@vger.kernel.org>; Mon, 06 Nov 2017 01:35:32 -0800 (PST)
In-Reply-To: <1509655091-13630-9-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Nov 2, 2017 at 9:38 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> For non-samefs case, all directory entries are "impure" because the
> st_ino value returned from stat(2) is not the st_ino value of the
> real inode.
>
> In order to provide the same d_ino values for the directory type entries,
> we never iterate the real dir directly in non-samefs case.
>
> ovl_fill_real() has been modified to return the overlay inode number
> as d_ino of the "." and ".." entries.
>
> Build the impure dir cache for non-samefs case even if there is no
> "impure" xattr on dir, but if real dir has nlink > 2 or nlink == 1,
> which indicates that is has subdirs.
>
> Update non-merge dir cache version on every change in subdir entry
> and reset the dir cache after copy up when directory becomes !is_real.
>

I don't really like this.  Non-samefs d_ino will always be hacky,
whether consistent with st_ino or not (it loses the uniqueness
property of d_ino, that is guaranteed in a normal filesystem).

Spending possibly large amounts of memory and CPU cycles to achieve
consistency is dubious.   Especially since nobody seems to be
complaining about it.

So, I'd just drop 6/8 and 8/8.

And I'm still hoping we can get some infrastructure for partitioning
the ino space (i.e. filesystem can report that it will only use N bits
from the available 64).  This would allow properly solving the
non-samefs case without adding hacks.

Thanks,
Miklos


> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/dir.c       | 17 ++++++++++-------
>  fs/overlayfs/overlayfs.h |  2 +-
>  fs/overlayfs/readdir.c   | 37 +++++++++++++++++++++++++------------
>  fs/overlayfs/util.c      |  9 ++++++---
>  4 files changed, 42 insertions(+), 23 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 26aef3b5f007..f2ba8ab99581 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -155,7 +155,7 @@ static int ovl_set_opaque(struct dentry *dentry, struct dentry *upperdentry)
>  static void ovl_instantiate(struct dentry *dentry, struct inode *inode,
>                             struct dentry *newdentry, bool hardlink)
>  {
> -       ovl_dentry_version_inc(dentry->d_parent, false);
> +       ovl_dentry_version_inc(dentry->d_parent, false, S_ISDIR(inode->i_mode));
>         ovl_dentry_set_upper_alias(dentry);
>         if (!hardlink) {
>                 ovl_inode_update(inode, newdentry);
> @@ -676,7 +676,7 @@ static int ovl_remove_and_whiteout(struct dentry *dentry, bool is_dir)
>         if (flags)
>                 ovl_cleanup(wdir, upper);
>
> -       ovl_dentry_version_inc(dentry->d_parent, true);
> +       ovl_dentry_version_inc(dentry->d_parent, true, is_dir);
>  out_d_drop:
>         d_drop(dentry);
>         dput(whiteout);
> @@ -727,7 +727,8 @@ static int ovl_remove_upper(struct dentry *dentry, bool is_dir)
>                 err = vfs_rmdir(dir, upper);
>         else
>                 err = vfs_unlink(dir, upper, NULL);
> -       ovl_dentry_version_inc(dentry->d_parent, ovl_type_origin(dentry));
> +       ovl_dentry_version_inc(dentry->d_parent, ovl_type_origin(dentry),
> +                              is_dir);
>
>         /*
>          * Keeping this dentry hashed would mean having to release
> @@ -1075,10 +1076,12 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
>                         drop_nlink(d_inode(new));
>         }
>
> -       ovl_dentry_version_inc(old->d_parent, ovl_type_origin(old));
> -       ovl_dentry_version_inc(new->d_parent, ovl_type_origin(old));
> -       if (!overwrite)
> -               ovl_dentry_version_inc(old->d_parent, ovl_type_origin(new));
> +       ovl_dentry_version_inc(old->d_parent, ovl_type_origin(old), is_dir);
> +       ovl_dentry_version_inc(new->d_parent, ovl_type_origin(old), is_dir);
> +       if (!overwrite) {
> +               ovl_dentry_version_inc(old->d_parent, ovl_type_origin(new),
> +                                      new_is_dir);
> +       }
>
>  out_dput:
>         dput(newdentry);
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index cefe5a97d048..17fc4622dfba 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -221,7 +221,7 @@ void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
>  void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
>                     struct dentry *lowerdentry);
>  void ovl_inode_update(struct inode *inode, struct dentry *upperdentry);
> -void ovl_dentry_version_inc(struct dentry *dentry, bool impurity);
> +void ovl_dentry_version_inc(struct dentry *dentry, bool impurity, bool subdir);
>  u64 ovl_dentry_version_get(struct dentry *dentry);
>  bool ovl_is_whiteout(struct dentry *dentry);
>  struct file *ovl_path_open(struct path *path, int flags);
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 4ec95806285e..56320b927c5d 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -344,14 +344,14 @@ static void ovl_dir_reset(struct file *file)
>         struct ovl_dir_file *od = file->private_data;
>         struct ovl_dir_cache *cache = od->cache;
>         struct dentry *dentry = file->f_path.dentry;
> -       bool is_real;
> +       bool is_real = ovl_dir_is_real(dentry);
>
> -       if (cache && ovl_dentry_version_get(dentry) != cache->version) {
> +       if (cache && (ovl_dentry_version_get(dentry) != cache->version ||
> +                     od->is_real != is_real)) {
>                 ovl_cache_put(od, dentry);
>                 od->cache = NULL;
>                 od->cursor = NULL;
>         }
> -       is_real = ovl_dir_is_real(dentry);
>         if (od->is_real != is_real) {
>                 /* is_real can only become false when dir is copied up */
>                 if (WARN_ON(is_real))
> @@ -455,7 +455,6 @@ static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
>   * sure that d_ino will be consistent with st_ino from stat(2).
>   */
>  static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
> -
>  {
>         struct dentry *dir = path->dentry;
>         struct dentry *this = NULL;
> @@ -557,7 +556,7 @@ static int ovl_dir_read_impure(struct path *path,  struct list_head *list,
>
>         INIT_LIST_HEAD(list);
>         *root = RB_ROOT;
> -       ovl_path_upper(path->dentry, &realpath);
> +       ovl_path_real(path->dentry, &realpath);
>
>         err = ovl_dir_read(&realpath, &rdd);
>         if (err)
> @@ -592,6 +591,7 @@ static struct ovl_dir_cache *ovl_cache_get_impure(struct path *path)
>  {
>         int res;
>         struct dentry *dentry = path->dentry;
> +       struct dentry *upper = ovl_dentry_upper(dentry);
>         struct ovl_dir_cache *cache;
>
>         cache = ovl_dir_cache(d_inode(dentry));
> @@ -612,9 +612,9 @@ static struct ovl_dir_cache *ovl_cache_get_impure(struct path *path)
>                 kfree(cache);
>                 return ERR_PTR(res);
>         }
> -       if (list_empty(&cache->entries)) {
> +       if (upper && list_empty(&cache->entries)) {
>                 /* Good oportunity to get rid of an unnecessary "impure" flag */
> -               ovl_do_removexattr(ovl_dentry_upper(dentry), OVL_XATTR_IMPURE);
> +               ovl_do_removexattr(upper, OVL_XATTR_IMPURE);
>                 ovl_clear_flag(OVL_IMPURE, d_inode(dentry));
>                 kfree(cache);
>                 return NULL;
> @@ -631,6 +631,7 @@ struct ovl_readdir_translate {
>         struct ovl_dir_cache *cache;
>         struct dir_context ctx;
>         u64 parent_ino;
> +       u64 current_ino;
>  };
>
>  static int ovl_fill_real(struct dir_context *ctx, const char *name,
> @@ -643,6 +644,8 @@ static int ovl_fill_real(struct dir_context *ctx, const char *name,
>
>         if (rdt->parent_ino && strcmp(name, "..") == 0)
>                 ino = rdt->parent_ino;
> +       else if (rdt->current_ino && namelen == 1 && name[0] == '.')
> +               ino = rdt->current_ino;
>         else if (rdt->cache) {
>                 struct ovl_cache_entry *p;
>
> @@ -659,12 +662,16 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
>         int err;
>         struct ovl_dir_file *od = file->private_data;
>         struct dentry *dir = file->f_path.dentry;
> +       struct inode *realinode = d_inode(od->realfile->f_path.dentry);
>         struct ovl_readdir_translate rdt = {
>                 .ctx.actor = ovl_fill_real,
>                 .orig_ctx = ctx,
>         };
>
> -       if (OVL_TYPE_MERGE(ovl_path_type(dir->d_parent))) {
> +       if (!ovl_same_sb(dir->d_sb)) {
> +               rdt.current_ino = dir->d_inode->i_ino;
> +               rdt.parent_ino = dir->d_parent->d_inode->i_ino;
> +       } else if (OVL_TYPE_MERGE(ovl_path_type(dir->d_parent))) {
>                 struct kstat stat;
>                 struct path statpath = file->f_path;
>
> @@ -677,7 +684,13 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
>                 rdt.parent_ino = stat.ino;
>         }
>
> -       if (ovl_test_flag(OVL_IMPURE, d_inode(dir))) {
> +       /*
> +        * If dir is impure, we need to cache st_ino values of copy up origins.
> +        * For non-samefs, if dir nlink is either 1 (=any) or > 2, then it may
> +        * have subdirs and we need to cache their non persistent st_ino values.
> +        */
> +       if (ovl_test_flag(OVL_IMPURE, d_inode(dir)) ||
> +           (!ovl_same_sb(dir->d_sb) && realinode->i_nlink != 2)) {
>                 rdt.cache = ovl_cache_get_impure(&file->f_path);
>                 if (IS_ERR(rdt.cache))
>                         return PTR_ERR(rdt.cache);
> @@ -703,9 +716,9 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
>                  * dir is impure then need to adjust d_ino for copied up
>                  * entries.
>                  */
> -               if (ovl_same_sb(dentry->d_sb) &&
> -                   (ovl_test_flag(OVL_IMPURE, d_inode(dentry)) ||
> -                    OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent)))) {
> +               if (ovl_test_flag(OVL_IMPURE, d_inode(dentry)) ||
> +                    OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent)) ||
> +                    !ovl_same_sb(dentry->d_sb)) {
>                         return ovl_iterate_real(file, ctx);
>                 }
>                 return iterate_dir(od->realfile, ctx);
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index d6bb1c9f5e7a..b4d729dff66b 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -279,7 +279,7 @@ void ovl_inode_update(struct inode *inode, struct dentry *upperdentry)
>         }
>  }
>
> -void ovl_dentry_version_inc(struct dentry *dentry, bool impurity)
> +void ovl_dentry_version_inc(struct dentry *dentry, bool impurity, bool subdir)
>  {
>         struct inode *inode = d_inode(dentry);
>
> @@ -288,9 +288,12 @@ void ovl_dentry_version_inc(struct dentry *dentry, bool impurity)
>          * Version is used by readdir code to keep cache consistent.  For merge
>          * dirs all changes need to be noted.  For non-merge dirs, cache only
>          * contains impure (ones which have been copied up and have origins)
> -        * entries, so only need to note changes to impure entries.
> +        * entries, so only need to note changes to impure entries.  For
> +        * non-merge dirs in non-samefs case, we need to also note changes for
> +        * all sub-dirs, because we cache all overlay dir inode numbers.
>          */
> -       if (OVL_TYPE_MERGE(ovl_path_type(dentry)) || impurity)
> +       if (OVL_TYPE_MERGE(ovl_path_type(dentry)) || impurity ||
> +           (subdir && !ovl_same_sb(dentry->d_sb)))
>                 OVL_I(inode)->version++;
>  }
>
> --
> 2.7.4
>
