From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v14 4/5] overlayfs: internal getxattr operations without
 sepolicy checking
Date: Wed, 23 Oct 2019 09:39:47 +0300
Message-ID: <CAOQ4uxgWOmV_x5gRZ9tR+u86GE6JoXn-MSxKkvi87e9owMApZw@mail.gmail.com>
References: <20191022204453.97058-1-salyzyn@android.com> <20191022204453.97058-5-salyzyn@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191022204453.97058-5-salyzyn@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <salyzyn@android.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kernel-team@android.com, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Oct 22, 2019 at 11:46 PM Mark Salyzyn <salyzyn@android.com> wrote:
>
> Check impure, opaque, origin & meta xattr with no sepolicy audit
> (using __vfs_getxattr) since these operations are internal to
> overlayfs operations and do not disclose any data.  This became
> an issue for credential override off since sys_admin would have
> been required by the caller; whereas would have been inherently
> present for the creator since it performed the mount.
>
> This is a change in operations since we do not check in the new
> ovl_do_vfs_getxattr function if the credential override is off or
> not.  Reasoning is that the sepolicy check is unnecessary overhead,
> especially since the check can be expensive.
>
> Because for override credentials off, this affects _everyone_ that
> underneath performs private xattr calls without the appropriate
> sepolicy permissions and sys_admin capability.  Providing blanket
> support for sys_admin would be bad for all possible callers.
>
> For the override credentials on, this will affect only the mounter,
> should it lack sepolicy permissions. Not considered a security
> problem since mounting by definition has sys_admin capabilities,
> but sepolicy contexts would still need to be crafted.
>

It sounds reasonable to me, but I am not a "security person".

> It should be noted that there is precedence, __vfs_getxattr is used
> in other filesystems for their own internal trusted xattr management.
>

Urgh! "other" filesystems meaning ecryptfs_getxattr()?
That looks like a loop hole to read any trusted xattr without any
security checks. Not sure its a good example...

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
> Cc: linux-security-module@vger.kernel.org
>
> ---
> v14 - rebase to use xattr_gs_args.
>
> v13 - rebase to use __vfs_getxattr flags option
>
> v12 - rebase
>
> v11 - switch name to ovl_do_vfs_getxattr, fortify comment
>
> v10 - added to patch series
>
> ---
>  fs/overlayfs/namei.c     | 12 +++++++-----
>  fs/overlayfs/overlayfs.h |  2 ++
>  fs/overlayfs/util.c      | 32 +++++++++++++++++++++++---------
>  3 files changed, 32 insertions(+), 14 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 9702f0d5309d..a4a452c489fa 100644
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
> +       res = ovl_do_vfs_getxattr(dentry, name, NULL, 0);
>         if (res < 0) {
>                 if (res == -ENODATA || res == -EOPNOTSUPP)
>                         return NULL;
> @@ -123,7 +124,7 @@ static struct ovl_fh *ovl_get_fh(struct dentry *dentry, const char *name)
>         if (!fh)
>                 return ERR_PTR(-ENOMEM);
>
> -       res = vfs_getxattr(dentry, name, fh, res);
> +       res = ovl_do_vfs_getxattr(dentry, name, fh, res);
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
> index c6a8ec049099..72762642b247 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -205,6 +205,8 @@ int ovl_want_write(struct dentry *dentry);
>  void ovl_drop_write(struct dentry *dentry);
>  struct dentry *ovl_workdir(struct dentry *dentry);
>  const struct cred *ovl_override_creds(struct super_block *sb);
> +ssize_t ovl_do_vfs_getxattr(struct dentry *dentry, const char *name, void *buf,
> +                           size_t size);
>  struct super_block *ovl_same_sb(struct super_block *sb);
>  int ovl_can_decode_fh(struct super_block *sb);
>  struct dentry *ovl_indexdir(struct super_block *sb);
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index f5678a3f8350..bed12aed902c 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -40,6 +40,20 @@ const struct cred *ovl_override_creds(struct super_block *sb)
>         return override_creds(ofs->creator_cred);
>  }
>
> +ssize_t ovl_do_vfs_getxattr(struct dentry *dentry, const char *name, void *buf,
> +                           size_t size)
> +{
> +       struct xattr_gs_args args = {};
> +
> +       args.dentry = dentry;
> +       args.inode = d_inode(dentry);
> +       args.name = name;
> +       args.buffer = buf;
> +       args.size = size;
> +       args.flags = XATTR_NOSECURITY;
> +       return __vfs_getxattr(&args);
> +}
> +

We do not understand each other.
I commented on this several times.
please put the wrapper helper ovl_do_getxattr() in overlayfs.h
next to the other ovl_do_ wrapper helpers and add pr_debug()
as all other wrappers have.

Thanks,
Amir.
