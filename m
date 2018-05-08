Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180508125043.GA3501@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com> <20180507174102.24086-18-vgoyal@redhat.com>
 <CAOQ4uxiXqKF1Vbg6HitUg6ax_Xy67mKDVS1t+P7pMT_57X=L5g@mail.gmail.com>
 <20180507205937.GB2945@redhat.com> <CAOQ4uxjozJMc6dLoj-tbX06YKYaBN7t5QUq1C0w+apV=Y=K-7w@mail.gmail.com>
 <20180508125043.GA3501@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 8 May 2018 17:14:42 +0300
Message-ID: <CAOQ4uxiwc+8wxom4b_aJwV1VospoADx5U9iqyPpgmJayyFKZSw@mail.gmail.com>
Subject: Re: [PATCH v15 17/30] ovl: Open file with data except for the case of fsync
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, May 8, 2018 at 3:50 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>
[...]
>
> Ok, here is the updated patch. I have not defined quivalent of
> ovl_real_meta_file() as there are no users.
>
>
> Subject: ovl: Open file with data except for the case of fsync
>
> ovl_open() should open file which contains data and not open metacopy
> inode. With the introduction of metacopy inodes, with current implementaion
> we will end up opening metacopy inode as well.
>
> But there can be certain circumstances like ovl_fsync() where we
> want to allow opening a metacopy inode instead.
>
> Hence, change ovl_open_realfile() and ovl_open_real() and add extra
> parameter which specifies whether to allow opening metacopy inode or not.
> If this parameter is false, we look for data inode and open that.
>
> This should allow covering both the cases.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Nice! much shorter. You can add
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

BTW, I have never given that much thought, but I see that you
added Reviewed-by before Signed-off-by in some of the patches
and after SOB in other patches.
Of course it doesn't really matter and there isn't a single convention
in the kernel, but the way I always thought about it is:
You sign-off at the bottom on the complete work including all the tags
may have added.

Feel free to ignore this OCD comment ;-)

> ---
>  fs/overlayfs/file.c |   40 +++++++++++++++++++++++++++++++---------
>  1 file changed, 31 insertions(+), 9 deletions(-)
>
> Index: rhvgoyal-linux/fs/overlayfs/file.c
> ===================================================================
> --- rhvgoyal-linux.orig/fs/overlayfs/file.c     2018-05-07 16:55:02.562350785 -0400
> +++ rhvgoyal-linux/fs/overlayfs/file.c  2018-05-08 08:46:49.994350785 -0400
> @@ -14,22 +14,32 @@
>  #include <linux/uio.h>
>  #include "overlayfs.h"
>
> -static struct file *ovl_open_realfile(const struct file *file)
> +static struct file *ovl_open_realfile(const struct file *file,
> +                                     bool allow_metacopy)
>  {
>         struct inode *inode = file_inode(file);
>         struct inode *upperinode = ovl_inode_upper(inode);
> -       struct inode *realinode = upperinode ?: ovl_inode_lower(inode);
> +       struct inode *realinode;
>         struct file *realfile;
> +       bool upperopen = false;
>         const struct cred *old_cred;
>
> +       if (upperinode && (allow_metacopy || ovl_has_upperdata(inode))) {
> +               realinode = upperinode;
> +               upperopen = true;
> +       } else {
> +               realinode = allow_metacopy ? ovl_inode_lower(inode) :
> +                                ovl_inode_lowerdata(inode);
> +       }
>         old_cred = ovl_override_creds(inode->i_sb);
>         realfile = path_open(&file->f_path, file->f_flags | O_NOATIME,
>                              realinode, current_cred(), false);
>         revert_creds(old_cred);
>
>         pr_debug("open(%p[%pD2/%c], 0%o) -> (%p, 0%o)\n",
> -                file, file, upperinode ? 'u' : 'l', file->f_flags,
> -                realfile, IS_ERR(realfile) ? 0 : realfile->f_flags);
> +                file, file, upperopen ? 'u' : 'l',
> +                file->f_flags, realfile,
> +                IS_ERR(realfile) ? 0 : realfile->f_flags);
>
>         return realfile;
>  }
> @@ -72,17 +82,24 @@ static int ovl_change_flags(struct file
>         return 0;
>  }
>
> -static int ovl_real_fdget(const struct file *file, struct fd *real)
> +static int _ovl_real_fdget(const struct file *file, struct fd *real,
> +                         bool allow_metacopy)
>  {
>         struct inode *inode = file_inode(file);
> +       struct inode *realinode;
>
>         real->flags = 0;
>         real->file = file->private_data;
>
> +       if (allow_metacopy)
> +               realinode = ovl_inode_real(inode);
> +       else
> +               realinode = ovl_inode_realdata(inode);
> +
>         /* Has it been copied up since we'd opened it? */
> -       if (unlikely(file_inode(real->file) != ovl_inode_real(inode))) {
> +       if (unlikely(file_inode(real->file) != realinode)) {
>                 real->flags = FDPUT_FPUT;
> -               real->file = ovl_open_realfile(file);
> +               real->file = ovl_open_realfile(file, allow_metacopy);
>
>                 return PTR_ERR_OR_ZERO(real->file);
>         }
> @@ -94,6 +111,11 @@ static int ovl_real_fdget(const struct f
>         return 0;
>  }
>
> +static int ovl_real_fdget(const struct file *file, struct fd *real)
> +{
> +       return _ovl_real_fdget(file, real, false);
> +}
> +
>  static int ovl_open(struct inode *inode, struct file *file)
>  {
>         struct dentry *dentry = file_dentry(file);
> @@ -107,7 +129,7 @@ static int ovl_open(struct inode *inode,
>         /* No longer need these flags, so don't pass them on to underlying fs */
>         file->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
>
> -       realfile = ovl_open_realfile(file);
> +       realfile = ovl_open_realfile(file, false);
>         if (IS_ERR(realfile))
>                 return PTR_ERR(realfile);
>
> @@ -244,7 +266,7 @@ static int ovl_fsync(struct file *file,
>         const struct cred *old_cred;
>         int ret;
>
> -       ret = ovl_real_fdget(file, &real);
> +       ret = _ovl_real_fdget(file, &real, !datasync);
>         if (ret)
>                 return ret;
>
