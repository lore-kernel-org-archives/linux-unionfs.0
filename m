Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190122050139.19701-1-amir73il@gmail.com>
In-Reply-To: <20190122050139.19701-1-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 1 Mar 2019 11:29:10 +0200
Message-ID: <CAOQ4uxhdgxtL3-tMDSegruCnNdvfLNDJ2p0OcnZrvXtPqiDf8A@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix missing upper fs freeze protection on copy up
 for ioctl
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Jan 22, 2019 at 7:01 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Generalize the helper ovl_open_maybe_copy_up() and use it to copy up
> file with data before FS_IOC_SETFLAGS ioctl.
>
> Fixes: dab5ca8fd9dd ("ovl: add lsattr/chattr support")
> Cc: <stable@vger.kernel.org> # v4.19
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Miklos,

Ping for this bug fix.

Thanks,
Amir.

>  fs/overlayfs/copy_up.c   | 6 +++---
>  fs/overlayfs/file.c      | 5 ++---
>  fs/overlayfs/overlayfs.h | 2 +-
>  3 files changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 48119b23375b..0c0e11d529d0 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -885,14 +885,14 @@ static bool ovl_open_need_copy_up(struct dentry *dentry, int flags)
>         return true;
>  }
>
> -int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags)
> +int ovl_maybe_copy_up(struct dentry *dentry, int flags)
>  {
>         int err = 0;
>
> -       if (ovl_open_need_copy_up(dentry, file_flags)) {
> +       if (ovl_open_need_copy_up(dentry, flags)) {
>                 err = ovl_want_write(dentry);
>                 if (!err) {
> -                       err = ovl_copy_up_flags(dentry, file_flags);
> +                       err = ovl_copy_up_flags(dentry, flags);
>                         ovl_drop_write(dentry);
>                 }
>         }
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 84dd957efa24..50e4407398d8 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -116,11 +116,10 @@ static int ovl_real_fdget(const struct file *file, struct fd *real)
>
>  static int ovl_open(struct inode *inode, struct file *file)
>  {
> -       struct dentry *dentry = file_dentry(file);
>         struct file *realfile;
>         int err;
>
> -       err = ovl_open_maybe_copy_up(dentry, file->f_flags);
> +       err = ovl_maybe_copy_up(file_dentry(file), file->f_flags);
>         if (err)
>                 return err;
>
> @@ -390,7 +389,7 @@ static long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>                 if (ret)
>                         return ret;
>
> -               ret = ovl_copy_up_with_data(file_dentry(file));
> +               ret = ovl_maybe_copy_up(file_dentry(file), O_WRONLY);
>                 if (!ret) {
>                         ret = ovl_real_ioctl(file, cmd, arg);
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 5e45cb3630a0..767eeaf73bf1 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -419,7 +419,7 @@ extern const struct file_operations ovl_file_operations;
>  int ovl_copy_up(struct dentry *dentry);
>  int ovl_copy_up_with_data(struct dentry *dentry);
>  int ovl_copy_up_flags(struct dentry *dentry, int flags);
> -int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
> +int ovl_maybe_copy_up(struct dentry *dentry, int flags);
>  int ovl_copy_xattr(struct dentry *old, struct dentry *new);
>  int ovl_set_attr(struct dentry *upper, struct kstat *stat);
>  struct ovl_fh *ovl_encode_real_fh(struct dentry *real, bool is_upper);
> --
> 2.17.1
>
