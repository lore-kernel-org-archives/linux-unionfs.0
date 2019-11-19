Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <1574129643-14664-1-git-send-email-jiufei.xue@linux.alibaba.com> <1574129643-14664-3-git-send-email-jiufei.xue@linux.alibaba.com>
In-Reply-To: <1574129643-14664-3-git-send-email-jiufei.xue@linux.alibaba.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 19 Nov 2019 06:22:09 +0200
Message-ID: <CAOQ4uxhU0NGqX-P4XTJ+kf6sXNCnUCBxgp1u2-aDV5p15Jh+tg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ovl: implement async IO routines
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Nov 19, 2019 at 4:14 AM Jiufei Xue <jiufei.xue@linux.alibaba.com> w=
rote:
>
> A performance regression is observed since linux v4.19 when we do aio
> test using fio with iodepth 128 on overlayfs. And we found that queue
> depth of the device is always 1 which is unexpected.
>
> After investigation, it is found that commit 16914e6fc7
> (=E2=80=9Covl: add ovl_read_iter()=E2=80=9D) and commit 2a92e07edc
> (=E2=80=9Covl: add ovl_write_iter()=E2=80=9D) use do_iter_readv_writev() =
to submit
> requests to real filesystem. Async IOs are converted to sync IOs here
> and cause performance regression.
>
> So implement async IO for stacked reading and writing.
>
> Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
> ---
>  fs/overlayfs/file.c      | 97 +++++++++++++++++++++++++++++++++++++++++-=
------
>  fs/overlayfs/overlayfs.h |  2 +
>  fs/overlayfs/super.c     | 12 +++++-
>  3 files changed, 95 insertions(+), 16 deletions(-)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index e235a63..07d94e7 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -11,6 +11,14 @@
>  #include <linux/uaccess.h>
>  #include "overlayfs.h"
>
> +struct ovl_aio_req {
> +       struct kiocb iocb;
> +       struct kiocb *orig_iocb;
> +       struct fd fd;
> +};
> +
> +static struct kmem_cache *ovl_aio_request_cachep;
> +
>  static char ovl_whatisit(struct inode *inode, struct inode *realinode)
>  {
>         if (realinode !=3D ovl_inode_upper(inode))
> @@ -225,6 +233,21 @@ static rwf_t ovl_iocb_to_rwf(struct kiocb *iocb)
>         return flags;
>  }
>
> +static void ovl_aio_rw_complete(struct kiocb *iocb, long res, long res2)
> +{
> +       struct ovl_aio_req *aio_req =3D container_of(iocb, struct ovl_aio=
_req, iocb);
> +       struct kiocb *orig_iocb =3D aio_req->orig_iocb;
> +
> +       if (iocb->ki_flags & IOCB_WRITE)
> +               file_end_write(iocb->ki_filp);
> +
> +       orig_iocb->ki_pos =3D iocb->ki_pos;
> +       orig_iocb->ki_complete(orig_iocb, res, res2);
> +
> +       fdput(aio_req->fd);
> +       kmem_cache_free(ovl_aio_request_cachep, aio_req);
> +}
> +
>  static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
>  {
>         struct file *file =3D iocb->ki_filp;
> @@ -240,14 +263,28 @@ static ssize_t ovl_read_iter(struct kiocb *iocb, st=
ruct iov_iter *iter)
>                 return ret;
>
>         old_cred =3D ovl_override_creds(file_inode(file)->i_sb);
> -       ret =3D vfs_iter_read(real.file, iter, &iocb->ki_pos,
> -                           ovl_iocb_to_rwf(iocb));
> +       if (is_sync_kiocb(iocb)) {
> +               ret =3D vfs_iter_read(real.file, iter, &iocb->ki_pos,
> +                                   ovl_iocb_to_rwf(iocb));
> +               ovl_file_accessed(file);
> +               fdput(real);
> +       } else {
> +               struct ovl_aio_req *aio_req =3D kmem_cache_alloc(ovl_aio_=
request_cachep,
> +                                                              GFP_NOFS);
> +               aio_req->fd =3D real;
> +               aio_req->orig_iocb =3D iocb;
> +               kiocb_clone(&aio_req->iocb, iocb, real.file);
> +               aio_req->iocb.ki_complete =3D ovl_aio_rw_complete;
> +               ret =3D vfs_iocb_iter_read(real.file, &aio_req->iocb, ite=
r);
> +               ovl_file_accessed(file);

That should be done in completion/error

> +               if (ret !=3D -EIOCBQUEUED) {
> +                       iocb->ki_pos =3D aio_req->iocb.ki_pos;
> +                       fdput(real);
> +                       kmem_cache_free(ovl_aio_request_cachep, aio_req);
> +               }

Suggest cleanup helper for completion/error


> +       }
>         revert_creds(old_cred);
>
> -       ovl_file_accessed(file);
> -
> -       fdput(real);
> -
>         return ret;
>  }
>
> @@ -275,16 +312,32 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, s=
truct iov_iter *iter)
>
>         old_cred =3D ovl_override_creds(file_inode(file)->i_sb);
>         file_start_write(real.file);
> -       ret =3D vfs_iter_write(real.file, iter, &iocb->ki_pos,
> -                            ovl_iocb_to_rwf(iocb));
> -       file_end_write(real.file);
> +       if (is_sync_kiocb(iocb)) {
> +               ret =3D vfs_iter_write(real.file, iter, &iocb->ki_pos,
> +                                    ovl_iocb_to_rwf(iocb));
> +               file_end_write(real.file);
> +               /* Update size */
> +               ovl_copyattr(ovl_inode_real(inode), inode);
> +               fdput(real);
> +       } else {
> +               struct ovl_aio_req *aio_req =3D kmem_cache_alloc(ovl_aio_=
request_cachep,
> +                                                              GFP_NOFS);
> +               aio_req->fd =3D real;
> +               aio_req->orig_iocb =3D iocb;
> +               kiocb_clone(&aio_req->iocb, iocb, real.file);
> +               aio_req->iocb.ki_complete =3D ovl_aio_rw_complete;
> +               ret =3D vfs_iocb_iter_write(real.file, &aio_req->iocb, it=
er);
> +               /* Update size */
> +               ovl_copyattr(ovl_inode_real(inode), inode);

That should be in completion/error

Thanks,
Amir.
