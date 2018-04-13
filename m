From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH 11/35] ovl: readd read_iter
Date: Fri, 13 Apr 2018 16:35:21 +0300
Message-ID: <CAOQ4uxgzVxjtKZomyxy27uEeZ7mpLNXV71NpQoi51NjP4gtyig@mail.gmail.com>
References: <20180412150826.20988-1-mszeredi@redhat.com> <20180412150826.20988-12-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412150826.20988-12-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Apr 12, 2018 at 6:08 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:
> Implement stacked reading.
>

I couldn't decipher the meaning of "readd" in the subject of this
and other file ops pacthes??

> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/overlayfs/file.c | 56 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 56 insertions(+)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 409b542ff30c..a19429c5965d 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -9,6 +9,7 @@
>  #include <linux/cred.h>
>  #include <linux/file.h>
>  #include <linux/xattr.h>
> +#include <linux/uio.h>
>  #include "overlayfs.h"
>
>  static struct file *ovl_open_realfile(const struct file *file)
> @@ -129,8 +130,63 @@ static loff_t ovl_llseek(struct file *file, loff_t offset, int whence)
>                                         i_size_read(realinode));
>  }
>
> +static void ovl_file_accessed(struct file *file)
> +{
> +       struct inode *inode = file_inode(file);
> +
> +       if ((file->f_flags & O_NOATIME) || !ovl_inode_upper(inode))
> +               return;
> +
> +       ovl_copytimes(inode);
> +       touch_atime(&file->f_path);
> +}
> +
> +static rwf_t ovl_iocb_to_rwf(struct kiocb *iocb)
> +{
> +       int ifl = iocb->ki_flags;
> +       rwf_t flags = 0;
> +
> +       if (ifl & IOCB_NOWAIT)
> +               flags |= RWF_NOWAIT;
> +       if (ifl & IOCB_HIPRI)
> +               flags |= RWF_HIPRI;
> +       if (ifl & IOCB_DSYNC)
> +               flags |= RWF_DSYNC;
> +       if (ifl & IOCB_SYNC)
> +               flags |= RWF_SYNC;
> +
> +       return flags;
> +}
> +
> +static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
> +{
> +       struct file *file = iocb->ki_filp;
> +       struct fd real;
> +       const struct cred *old_cred;
> +       ssize_t ret;
> +
> +       if (!iov_iter_count(iter))
> +               return 0;
> +
> +       ret = ovl_real_file(file, &real);
> +       if (ret)
> +               return ret;
> +
> +       old_cred = ovl_override_creds(file_inode(file)->i_sb);
> +       ret = vfs_iter_read(real.file, iter, &iocb->ki_pos,
> +                           ovl_iocb_to_rwf(iocb));
> +       revert_creds(old_cred);
> +
> +       ovl_file_accessed(file);
> +
> +       fdput(real);

I find it confusing that the name of ovl_real_file() does not suggest it
may take a reference, so this  fdput() looks unbalanced.

All other ovl_XXX_{real,upper,lower} helpers do not take a reference.
Perhaps something along the lines of ovl_file_real_fdget().

Thanks,
Amir.
