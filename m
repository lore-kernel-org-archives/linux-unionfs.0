From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 3/4] ovl: Switch to generic_removexattr
Date: Tue, 23 Aug 2016 13:00:14 +0200
Message-ID: <CAJfpegv1dqA9x+gQVDBywZmerrr1BBQ=B6pOkPduusyr_o=-jA@mail.gmail.com>
References: <1471889194-31218-1-git-send-email-agruenba@redhat.com> <1471889194-31218-4-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35366 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757283AbcHWLMG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 23 Aug 2016 07:12:06 -0400
Received: by mail-oi0-f68.google.com with SMTP id e80so2309493oig.2
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Aug 2016 04:12:06 -0700 (PDT)
In-Reply-To: <1471889194-31218-4-git-send-email-agruenba@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Aug 22, 2016 at 8:06 PM, Andreas Gruenbacher
<agruenba@redhat.com> wrote:
> Commit d837a49b switches from iop->setxattr from ovl_setxattr to
> generic_setxattr, so switch from ovl_removexattr to generic_removexattr
> as well.  As far as permission checking goes, the same rules should
> apply in either case.
>
> While doing that, rename ovl_setxattr to ovl_xattr_set to indicate that
> this is not an iop->setxattr implementation and remove the unused inode
> argument.
>
> Move ovl_other_xattr_set above ovl_own_xattr_set so that they match the
> order of handlers in ovl_xattr_handlers.
>
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/overlayfs/dir.c       |  2 +-
>  fs/overlayfs/inode.c     | 65 ++++++++++++++++--------------------------------
>  fs/overlayfs/overlayfs.h |  6 ++---
>  fs/overlayfs/super.c     | 18 +++++++-------
>  4 files changed, 33 insertions(+), 58 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 12bcd07..7823480 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -952,7 +952,7 @@ const struct inode_operations ovl_dir_inode_operations = {
>         .setxattr       = generic_setxattr,
>         .getxattr       = ovl_getxattr,
>         .listxattr      = ovl_listxattr,
> -       .removexattr    = ovl_removexattr,
> +       .removexattr    = generic_removexattr,
>         .get_acl        = ovl_get_acl,
>         .update_time    = ovl_update_time,
>  };
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 859e42c..4f348ca 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -197,25 +197,38 @@ static bool ovl_is_private_xattr(const char *name)
>                        sizeof(OVL_XATTR_PREFIX) - 1) == 0;
>  }
>
> -int ovl_setxattr(struct dentry *dentry, struct inode *inode,
> -                const char *name, const void *value,
> -                size_t size, int flags)
> +int ovl_xattr_set(struct dentry *dentry, const char *name, const void *value,
> +                 size_t size, int flags)
>  {
>         int err;
> -       struct dentry *upperdentry;
> +       struct path realpath;
> +       enum ovl_path_type type = ovl_path_real(dentry, &realpath);
>         const struct cred *old_cred;
>
>         err = ovl_want_write(dentry);
>         if (err)
>                 goto out;
>
> +       if (!value && !OVL_TYPE_UPPER(type)) {
> +               err = vfs_getxattr(realpath.dentry, name, NULL, 0);
> +               if (err < 0)
> +                       goto out_drop_write;
> +       }
> +
>         err = ovl_copy_up(dentry);
>         if (err)
>                 goto out_drop_write;
>
> -       upperdentry = ovl_dentry_upper(dentry);
> +       if (!OVL_TYPE_UPPER(type))
> +               ovl_path_upper(dentry, &realpath);
> +
>         old_cred = ovl_override_creds(dentry->d_sb);
> -       err = vfs_setxattr(upperdentry, name, value, size, flags);
> +       if (value)
> +               err = vfs_setxattr(realpath.dentry, name, value, size, flags);
> +       else {
> +               BUG_ON(flags != XATTR_REPLACE);
> +               err = vfs_removexattr(realpath.dentry, name);
> +       }

Hmm, setxattr(8) says that a zero length value is permitted and
indeed, setxatt() in fs/xattr.c handles that case, but passes a NULL
value.   At that point it becomes impossible to differentiate the two
cases (and the BUG_ON could trigger too, AFAICS).

Am I missing something?

Thanks,
Miklos
