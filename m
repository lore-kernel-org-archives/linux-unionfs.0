From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 1/2] ovl: mark upper dir with type origin entries "impure"
Date: Tue, 16 May 2017 11:29:09 +0200
Message-ID: <CAJfpegt0oTba6SMDyLDQAguKuoHGsBV9MFSUheJoGyTM6e6nkA@mail.gmail.com>
References: <1494510147-18658-1-git-send-email-amir73il@gmail.com> <1494510147-18658-2-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:32813 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751537AbdEPJ3K (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 May 2017 05:29:10 -0400
Received: by mail-oi0-f66.google.com with SMTP id h4so2460380oib.0
        for <linux-unionfs@vger.kernel.org>; Tue, 16 May 2017 02:29:10 -0700 (PDT)
In-Reply-To: <1494510147-18658-2-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, May 11, 2017 at 3:42 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> When moving a merge dir or non-dir with copy up origin into
> a non-merge upper dir (a.k.a pure upper dir), we are marking
> the target parent dir "impure". ovl_iterate() iterates pure
> upper dirs directly, because there is no need to filter out
> whiteouts and merge dir content with lower dir. But for the
> case of an "impure" upper dir, ovl_iterate() will not be able
> to iterate the real upper dir directly, because it will need
> to lookup the origin inode and use it to fill d_ino.

Applied, thanks.

Miklos

>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/dir.c       | 41 ++++++++++++++++++++++++++++++++++++++++-
>  fs/overlayfs/namei.c     | 18 ++++++++++++++++--
>  fs/overlayfs/overlayfs.h |  3 +++
>  fs/overlayfs/ovl_entry.h |  1 +
>  fs/overlayfs/util.c      | 15 +++++++++++++++
>  5 files changed, 75 insertions(+), 3 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 723b98b..205e491 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -138,6 +138,17 @@ static int ovl_set_opaque(struct dentry *dentry, struct dentry *upperdentry)
>         return err;
>  }
>
> +static int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry)
> +{
> +       int err;
> +
> +       err = ovl_do_setxattr(upperdentry, OVL_XATTR_IMPURE, "y", 1, 0);
> +       if (!err)
> +               ovl_dentry_set_impure(dentry);
> +
> +       return err;
> +}
> +
>  /* Common operations required to be done after creation of file on upper */
>  static void ovl_instantiate(struct dentry *dentry, struct inode *inode,
>                             struct dentry *newdentry, bool hardlink)
> @@ -162,6 +173,11 @@ static bool ovl_type_merge(struct dentry *dentry)
>         return OVL_TYPE_MERGE(ovl_path_type(dentry));
>  }
>
> +static bool ovl_type_origin(struct dentry *dentry)
> +{
> +       return OVL_TYPE_ORIGIN(ovl_path_type(dentry));
> +}
> +
>  static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
>                             struct cattr *attr, struct dentry *hardlink)
>  {
> @@ -943,6 +959,30 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
>         old_upperdir = ovl_dentry_upper(old->d_parent);
>         new_upperdir = ovl_dentry_upper(new->d_parent);
>
> +       if (ovl_same_sb(old->d_sb) && !samedir) {
> +               /*
> +                * When moving a merge dir or non-dir with copy up origin into
> +                * a non-merge upper dir (a.k.a pure upper dir), we are making
> +                * the target parent dir "impure". ovl_iterate() iterates pure
> +                * upper dirs directly, because there is no need to filter out
> +                * whiteouts and merge dir content with lower dir. But for the
> +                * case of an "impure" upper dir, ovl_iterate() cannot iterate
> +                * the real directory directly, because it looks for the inode
> +                * numbers to fill d_ino in the entries origin inode.
> +                */
> +               if (ovl_type_origin(old) && !ovl_type_merge(new->d_parent)) {
> +                       err = ovl_set_impure(new->d_parent, new_upperdir);
> +                       if (err)
> +                               goto out_dput;
> +               }
> +               if (!overwrite && ovl_type_origin(new) &&
> +                   !ovl_type_merge(old->d_parent)) {
> +                       err = ovl_set_impure(old->d_parent, old_upperdir);
> +                       if (err)
> +                               goto out_dput;
> +               }
> +       }
> +
>         trap = lock_rename(new_upperdir, old_upperdir);
>
>         olddentry = lookup_one_len(old->d_name.name, old_upperdir,
> @@ -1004,7 +1044,6 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
>                 if (err)
>                         goto out_dput;
>         }
> -
>         err = ovl_do_rename(old_upperdir->d_inode, olddentry,
>                             new_upperdir->d_inode, newdentry, flags);
>         if (err)
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index bad0f66..0c72a59 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -167,7 +167,7 @@ static struct dentry *ovl_get_origin(struct dentry *dentry,
>         goto out;
>  }
>
> -static bool ovl_is_opaquedir(struct dentry *dentry)
> +static bool ovl_check_dir_xattr(struct dentry *dentry, const char *name)
>  {
>         int res;
>         char val;
> @@ -175,13 +175,23 @@ static bool ovl_is_opaquedir(struct dentry *dentry)
>         if (!d_is_dir(dentry))
>                 return false;
>
> -       res = vfs_getxattr(dentry, OVL_XATTR_OPAQUE, &val, 1);
> +       res = vfs_getxattr(dentry, name, &val, 1);
>         if (res == 1 && val == 'y')
>                 return true;
>
>         return false;
>  }
>
> +static bool ovl_is_opaquedir(struct dentry *dentry)
> +{
> +       return ovl_check_dir_xattr(dentry, OVL_XATTR_OPAQUE);
> +}
> +
> +static bool ovl_is_impuredir(struct dentry *dentry)
> +{
> +       return ovl_check_dir_xattr(dentry, OVL_XATTR_IMPURE);
> +}
> +
>  static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
>                              const char *name, unsigned int namelen,
>                              size_t prelen, const char *post,
> @@ -351,6 +361,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>         unsigned int ctr = 0;
>         struct inode *inode = NULL;
>         bool upperopaque = false;
> +       bool upperimpure = false;
>         char *upperredirect = NULL;
>         struct dentry *this;
>         unsigned int i;
> @@ -395,6 +406,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                                 poe = roe;
>                 }
>                 upperopaque = d.opaque;
> +               if (upperdentry && d.is_dir)
> +                       upperimpure = ovl_is_impuredir(upperdentry);
>         }
>
>         if (!d.stop && poe->numlower) {
> @@ -463,6 +476,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>
>         revert_creds(old_cred);
>         oe->opaque = upperopaque;
> +       oe->impure = upperimpure;
>         oe->redirect = upperredirect;
>         oe->__upperdentry = upperdentry;
>         memcpy(oe->lowerstack, stack, sizeof(struct path) * ctr);
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index caa36cb..fae52f5 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -24,6 +24,7 @@ enum ovl_path_type {
>  #define OVL_XATTR_OPAQUE OVL_XATTR_PREFIX "opaque"
>  #define OVL_XATTR_REDIRECT OVL_XATTR_PREFIX "redirect"
>  #define OVL_XATTR_ORIGIN OVL_XATTR_PREFIX "origin"
> +#define OVL_XATTR_IMPURE OVL_XATTR_PREFIX "impure"
>
>  /*
>   * The tuple (fh,uuid) is a universal unique identifier for a copy up origin,
> @@ -203,8 +204,10 @@ struct dentry *ovl_dentry_real(struct dentry *dentry);
>  struct ovl_dir_cache *ovl_dir_cache(struct dentry *dentry);
>  void ovl_set_dir_cache(struct dentry *dentry, struct ovl_dir_cache *cache);
>  bool ovl_dentry_is_opaque(struct dentry *dentry);
> +bool ovl_dentry_is_impure(struct dentry *dentry);
>  bool ovl_dentry_is_whiteout(struct dentry *dentry);
>  void ovl_dentry_set_opaque(struct dentry *dentry);
> +void ovl_dentry_set_impure(struct dentry *dentry);
>  bool ovl_redirect_dir(struct super_block *sb);
>  void ovl_clear_redirect_dir(struct super_block *sb);
>  const char *ovl_dentry_get_redirect(struct dentry *dentry);
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index b2023ddb..9b9361f 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -42,6 +42,7 @@ struct ovl_entry {
>                         u64 version;
>                         const char *redirect;
>                         bool opaque;
> +                       bool impure;
>                         bool copying;
>                 };
>                 struct rcu_head rcu;
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index cfdea47..b17a936 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -172,9 +172,17 @@ void ovl_set_dir_cache(struct dentry *dentry, struct ovl_dir_cache *cache)
>  bool ovl_dentry_is_opaque(struct dentry *dentry)
>  {
>         struct ovl_entry *oe = dentry->d_fsdata;
> +
>         return oe->opaque;
>  }
>
> +bool ovl_dentry_is_impure(struct dentry *dentry)
> +{
> +       struct ovl_entry *oe = dentry->d_fsdata;
> +
> +       return oe->impure;
> +}
> +
>  bool ovl_dentry_is_whiteout(struct dentry *dentry)
>  {
>         return !dentry->d_inode && ovl_dentry_is_opaque(dentry);
> @@ -187,6 +195,13 @@ void ovl_dentry_set_opaque(struct dentry *dentry)
>         oe->opaque = true;
>  }
>
> +void ovl_dentry_set_impure(struct dentry *dentry)
> +{
> +       struct ovl_entry *oe = dentry->d_fsdata;
> +
> +       oe->impure = true;
> +}
> +
>  bool ovl_redirect_dir(struct super_block *sb)
>  {
>         struct ovl_fs *ofs = sb->s_fs_info;
> --
> 2.7.4
>
