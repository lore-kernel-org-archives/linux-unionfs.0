From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH 04/35] ovl: copy up times
Date: Fri, 13 Apr 2018 11:25:23 +0300
Message-ID: <CAOQ4uxg0+CJaskEVQdGr6+KkWwDvgzdNsrNt1oocnL6VxsDEFA@mail.gmail.com>
References: <20180412150826.20988-1-mszeredi@redhat.com> <20180412150826.20988-5-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412150826.20988-5-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Apr 12, 2018 at 6:07 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:
> Copy up mtime and ctime to overlay inode after times in real object are
> modified.  Be careful not to dirty cachelines when not necessary.
>
> This is in preparation for moving overlay functionality out of the VFS.
>
> This patch shouldn't have any observable effect.
>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/overlayfs/dir.c       |  5 +++++
>  fs/overlayfs/inode.c     |  1 +
>  fs/overlayfs/overlayfs.h |  7 +++++++
>  fs/overlayfs/util.c      | 19 +++++++++++++++++++
>  4 files changed, 32 insertions(+)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 839709c7803a..cd0fa2363723 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -507,6 +507,7 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
>                 else
>                         err = ovl_create_over_whiteout(dentry, inode, attr,
>                                                         hardlink);
> +               ovl_copytimes_with_parent(dentry);
>         }
>  out_revert_creds:
>         revert_creds(old_cred);
> @@ -768,6 +769,7 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
>                         drop_nlink(dentry->d_inode);
>         }
>         ovl_nlink_end(dentry, locked);
> +       ovl_copytimes_with_parent(dentry);
>  out_drop_write:
>         ovl_drop_write(dentry);
>  out:
> @@ -1079,6 +1081,9 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
>         ovl_dentry_version_inc(new->d_parent, ovl_type_origin(old) ||
>                                (d_inode(new) && ovl_type_origin(new)));
>
> +       ovl_copytimes_with_parent(old);
> +       ovl_copytimes_with_parent(new);
> +

All the ovl_copytimes_with_parent() calls you added can be replaced with a
single call in ovl_dentry_version_inc(). Just need to change its name and
pass it the child instead of the parent dentry.

Thanks,
Amir.
