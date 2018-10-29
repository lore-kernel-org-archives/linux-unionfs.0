Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181029174059.38326-1-olga.kornievskaia@gmail.com> <20181029174059.38326-4-olga.kornievskaia@gmail.com>
In-Reply-To: <20181029174059.38326-4-olga.kornievskaia@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 29 Oct 2018 20:11:02 +0200
Message-ID: <CAOQ4uxibDdXdf1WVe5V+vuA=TiJhETq+aSS7jSwBpqYV+MbrdA@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] VFS: generic cross-device copy_file_range()
 support for all filesystems
Content-Type: text/plain; charset="UTF-8"
To: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Cc: trond.myklebust@hammerspace.com, Anna Schumaker <anna.schumaker@netapp.com>, Al Viro <viro@zeniv.linux.org.uk>, Steve French <smfrench@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-cifs@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Oct 29, 2018 at 7:41 PM Olga Kornievskaia
<olga.kornievskaia@gmail.com> wrote:
>
> From: Olga Kornievskaia <kolga@netapp.com>
>
> If a filesystem does not support cross device or cross file system
> type copy offload functionality, then this patch provides a fallback

The flaw in this statement is that in the common case, filesystem that does
not support copy_file_range, doesn't have copy_file_range() file operation,
so in fact, patch [1/12] has already implemented
"generic cross-device copy_file_range() support for most filesystems"
This is why the order of this patch in the series is awkward.
Please see my suggestion in comment to patch [1/12].

> to a page cache based physical data copy. This means the
> copy_file_range() systemcall will never fail with EXDEV, and so in
> future userspace will not need to detect or provide a fallback for
> failed cross-device copies anymore.
>
> Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
> ---
>  fs/read_write.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 7a912e3..cff59bd 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1597,7 +1597,7 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>         if (file_out->f_op->copy_file_range) {
>                 ret = file_out->f_op->copy_file_range(file_in, pos_in, file_out,
>                                                       pos_out, len, flags);
> -               if (ret != -EOPNOTSUPP)
> +               if (ret != -EOPNOTSUPP && ret != -EXDEV)
>                         goto done;
>         }
>
> --
> 1.8.3.1
>
