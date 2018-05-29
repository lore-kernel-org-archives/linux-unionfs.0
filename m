From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 07/11] ovl: make ovl_create_real() cope with vfs_mkdir() safely
Date: Tue, 29 May 2018 18:29:00 +0300
Message-ID: <CAOQ4uxg6hVd2k5T20N1u72Of9Eb3O_EAasC0MhDoLY3-o2UrGw@mail.gmail.com>
References: <20180529144143.16378-1-mszeredi@redhat.com> <20180529144143.16378-8-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144143.16378-8-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 29, 2018 at 5:41 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:
> From: Amir Goldstein <amir73il@gmail.com>
>
> vfs_mkdir() may succeed and leave the dentry passed to it unhashed and
> negative.  ovl_create_real() is the last caller breaking when that
> happens.
>
> [amir: split re-factoring of ovl_create_temp() to prep patch
>        add comment about unhashed dir after mkdir
>        add pr_warn() if mkdir succeeds and lookup fails]
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/overlayfs/dir.c | 35 +++++++++++++++++++++++++++++++++--
>  1 file changed, 33 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 1b181292a624..b33d37d1a87c 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -114,6 +114,37 @@ int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
>         goto out;
>  }
>
> +static struct dentry *ovl_mkdir_real(struct inode *dir, struct dentry *dentry,
> +                                    umode_t mode)
> +{
> +       int err;
> +
> +       err = ovl_do_mkdir(dir, dentry, mode);
> +       if (err) {
> +               dput(dentry);
> +               return ERR_PTR(err);
> +       }
> +
> +       /*
> +        * vfs_mkdir() may succeed and leave the dentry passed
> +        * to it unhashed and negative. If that happens, try to
> +        * lookup a new hashed and positive dentry.
> +        */
> +       if (unlikely(d_unhashed(dentry))) {
> +               struct dentry *d;
> +
> +               d = lookup_one_len(dentry->d_name.name, dentry->d_parent,
> +                                  dentry->d_name.len);
> +               if (IS_ERR(d)) {
> +                       pr_warn("overlayfs: failed lookup after mkdir (%pd2, err=%i).\n",
> +                               dentry, err);
> +               }
> +               dput(dentry);
> +               dentry = d;
> +       }
> +       return dentry;
> +}
> +
>  struct dentry *ovl_create_real(struct inode *dir, struct dentry *newdentry,
>                                struct ovl_cattr *attr)
>  {
> @@ -135,8 +166,8 @@ struct dentry *ovl_create_real(struct inode *dir, struct dentry *newdentry,
>                         break;
>
>                 case S_IFDIR:
> -                       err = ovl_do_mkdir(dir, newdentry, attr->mode);
> -                       break;
> +                       /* mkdir is special... */
> +                       return ovl_mkdir_real(dir, newdentry, attr->mode);
>

I like your version with the helper.
So do we not care about the WARN_ON below on non-instantiated dentry
for directories? or we don't need it at all?

Thanks,
Amir.
