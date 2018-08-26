MIME-Version: 1.0
In-Reply-To: <1535300717-26686-6-git-send-email-amir73il@gmail.com>
References: <1535300717-26686-1-git-send-email-amir73il@gmail.com>
	<1535300717-26686-6-git-send-email-amir73il@gmail.com>
Date: Sun, 26 Aug 2018 21:30:41 +0200
Message-ID: <CAJfpegvwndyAPEbrB2aSRJWkUXLCATEU_4qSbG6C_MzzMo6ybw@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] vfs: fix fadvise64 syscall on an overlayfs file
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Aug 26, 2018 at 6:25 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> For an overlayfs file/inode, gage io is operating on the real underlying
> file, so the readahead hints set by fadvise64() should also be set on the
> real underlying file to take affect.

Hmm, how about making this be an f_op?

Would also fix readahead(2), which can be translated to fadvise(...,
POSIX_FADV_WILLNEED).

And possibly be useful for other filesystems, since there are cases
when things are not done through a_ops, yet the filesystem would
benefit from knowing the intentions of the user.

Thanks,
Miklos

>
> Fixes: d1d04ef8572b ("ovl: stack file ops")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  mm/fadvise.c | 34 ++++++++++++++++++++--------------
>  1 file changed, 20 insertions(+), 14 deletions(-)
>
> diff --git a/mm/fadvise.c b/mm/fadvise.c
> index 2d8376e3c640..d5528343ce77 100644
> --- a/mm/fadvise.c
> +++ b/mm/fadvise.c
> @@ -30,6 +30,7 @@
>  int ksys_fadvise64_64(int fd, loff_t offset, loff_t len, int advice)
>  {
>         struct fd f = fdget(fd);
> +       struct file *file;
>         struct inode *inode;
>         struct address_space *mapping;
>         struct backing_dev_info *bdi;
> @@ -42,13 +43,18 @@ int ksys_fadvise64_64(int fd, loff_t offset, loff_t len, int advice)
>         if (!f.file)
>                 return -EBADF;
>
> -       inode = file_inode(f.file);
> +       /*
> +        * XXX: We need to use file_real() for overlayfs stacked file because
> +        * readahead will be operating on the real underlying file/inode.
> +        */
> +       file = file_real(f.file);
> +       inode = file_inode(file);
>         if (S_ISFIFO(inode->i_mode)) {
>                 ret = -ESPIPE;
>                 goto out;
>         }
>
> -       mapping = f.file->f_mapping;
> +       mapping = file->f_mapping;
>         if (!mapping || len < 0) {
>                 ret = -EINVAL;
>                 goto out;
> @@ -85,21 +91,21 @@ int ksys_fadvise64_64(int fd, loff_t offset, loff_t len, int advice)
>
>         switch (advice) {
>         case POSIX_FADV_NORMAL:
> -               f.file->f_ra.ra_pages = bdi->ra_pages;
> -               spin_lock(&f.file->f_lock);
> -               f.file->f_mode &= ~FMODE_RANDOM;
> -               spin_unlock(&f.file->f_lock);
> +               file->f_ra.ra_pages = bdi->ra_pages;
> +               spin_lock(&file->f_lock);
> +               file->f_mode &= ~FMODE_RANDOM;
> +               spin_unlock(&file->f_lock);
>                 break;
>         case POSIX_FADV_RANDOM:
> -               spin_lock(&f.file->f_lock);
> -               f.file->f_mode |= FMODE_RANDOM;
> -               spin_unlock(&f.file->f_lock);
> +               spin_lock(&file->f_lock);
> +               file->f_mode |= FMODE_RANDOM;
> +               spin_unlock(&file->f_lock);
>                 break;
>         case POSIX_FADV_SEQUENTIAL:
> -               f.file->f_ra.ra_pages = bdi->ra_pages * 2;
> -               spin_lock(&f.file->f_lock);
> -               f.file->f_mode &= ~FMODE_RANDOM;
> -               spin_unlock(&f.file->f_lock);
> +               file->f_ra.ra_pages = bdi->ra_pages * 2;
> +               spin_lock(&file->f_lock);
> +               file->f_mode &= ~FMODE_RANDOM;
> +               spin_unlock(&file->f_lock);
>                 break;
>         case POSIX_FADV_WILLNEED:
>                 /* First and last PARTIAL page! */
> @@ -115,7 +121,7 @@ int ksys_fadvise64_64(int fd, loff_t offset, loff_t len, int advice)
>                  * Ignore return value because fadvise() shall return
>                  * success even if filesystem can't retrieve a hint,
>                  */
> -               force_page_cache_readahead(mapping, f.file, start_index,
> +               force_page_cache_readahead(mapping, file, start_index,
>                                            nrpages);
>                 break;
>         case POSIX_FADV_NOREUSE:
> --
> 2.7.4
>
