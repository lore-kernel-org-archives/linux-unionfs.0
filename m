From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v10 4/5] overlayfs: internal getxattr operations without
 sepolicy checking
Date: Thu, 25 Jul 2019 14:00:16 +0300
Message-ID: <CAOQ4uxhtASSymEOdh4XByXbxWO2_ZivzqjBrgK7jB3fWXLqr_w@mail.gmail.com>
References: <20190724195719.218307-1-salyzyn@android.com> <20190724195719.218307-5-salyzyn@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190724195719.218307-5-salyzyn@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <salyzyn@android.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kernel-team@android.com, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Jul 24, 2019 at 10:57 PM Mark Salyzyn <salyzyn@android.com> wrote:
>
> Check impure, opaque, origin & meta xattr with no sepolicy audit
> (using __vfs_getxattr) since these operations are internal to
> overlayfs operations and do not disclose any data.  This became
> an issue for credential override off since sys_admin would have
> been required by the caller; whereas would have been inherently
> present for the creator since it performed the mount.
>
> This is a change in operations since we do not check in the new
> ovl_vfs_getxattr function if the credential override is off or
> not.  Reasoning is that the sepolicy check is unnecessary overhead,
> especially since the check can be expensive.

I don't know that this reasoning suffice to skip the sepolicy checks
for overlayfs private xattrs.
Can't sepolicy be defined to allow get access to trusted.overlay.*?

>
> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Amir Goldstein <amir73il@gmail.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Stephen Smalley <sds@tycho.nsa.gov>
> Cc: linux-unionfs@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kernel-team@android.com
> ---
> v10 - added to patch series
> ---
>  fs/overlayfs/namei.c     | 12 +++++++-----
>  fs/overlayfs/overlayfs.h |  2 ++
>  fs/overlayfs/util.c      | 24 +++++++++++++++---------
>  3 files changed, 24 insertions(+), 14 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 9702f0d5309d..fb6c0cd7b65f 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -106,10 +106,11 @@ int ovl_check_fh_len(struct ovl_fh *fh, int fh_len)
>
>  static struct ovl_fh *ovl_get_fh(struct dentry *dentry, const char *name)
>  {
> -       int res, err;
> +       ssize_t res;
> +       int err;
>         struct ovl_fh *fh = NULL;
>
> -       res = vfs_getxattr(dentry, name, NULL, 0);
> +       res = ovl_vfs_getxattr(dentry, name, NULL, 0);
>         if (res < 0) {
>                 if (res == -ENODATA || res == -EOPNOTSUPP)
>                         return NULL;
> @@ -123,7 +124,7 @@ static struct ovl_fh *ovl_get_fh(struct dentry *dentry, const char *name)
>         if (!fh)
>                 return ERR_PTR(-ENOMEM);
>
> -       res = vfs_getxattr(dentry, name, fh, res);
> +       res = ovl_vfs_getxattr(dentry, name, fh, res);
>         if (res < 0)
>                 goto fail;
>
> @@ -141,10 +142,11 @@ static struct ovl_fh *ovl_get_fh(struct dentry *dentry, const char *name)
>         return NULL;
>
>  fail:
> -       pr_warn_ratelimited("overlayfs: failed to get origin (%i)\n", res);
> +       pr_warn_ratelimited("overlayfs: failed to get origin (%zi)\n", res);
>         goto out;
>  invalid:
> -       pr_warn_ratelimited("overlayfs: invalid origin (%*phN)\n", res, fh);
> +       pr_warn_ratelimited("overlayfs: invalid origin (%*phN)\n",
> +                           (int)res, fh);
>         goto out;
>  }
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 73a02a263fbc..82574684a9b6 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -205,6 +205,8 @@ int ovl_want_write(struct dentry *dentry);
>  void ovl_drop_write(struct dentry *dentry);
>  struct dentry *ovl_workdir(struct dentry *dentry);
>  const struct cred *ovl_override_creds(struct super_block *sb);
> +ssize_t ovl_vfs_getxattr(struct dentry *dentry, const char *name, void *buf,
> +                        size_t size);
>  struct super_block *ovl_same_sb(struct super_block *sb);
>  int ovl_can_decode_fh(struct super_block *sb);
>  struct dentry *ovl_indexdir(struct super_block *sb);
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index f5678a3f8350..672459c3cff7 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -40,6 +40,12 @@ const struct cred *ovl_override_creds(struct super_block *sb)
>         return override_creds(ofs->creator_cred);
>  }
>
> +ssize_t ovl_vfs_getxattr(struct dentry *dentry, const char *name, void *buf,
> +                        size_t size)
> +{
> +       return __vfs_getxattr(dentry, d_inode(dentry), name, buf, size);
> +}
> +

When introducing a new ovl_ => vfs_ wrapper, please follow the
ovl_do_XXX helpers
convention in overlayfs.h.

Note that those wrappers do not generally bypass security checks and
you have not
convinced me yet that skipping security checks on the overlayfs
private xattr get
is the right thing to do.

Thanks,
Amir.
