Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181024195837.35532-1-olga.kornievskaia@gmail.com> <20181024195837.35532-6-olga.kornievskaia@gmail.com>
In-Reply-To: <20181024195837.35532-6-olga.kornievskaia@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 25 Oct 2018 07:38:20 +0300
Message-ID: <CAOQ4uxg4_eF2_uur7-S=SCc5QzyVUfqRBjr9yYDGLsq5Ai4GXA@mail.gmail.com>
Subject: Re: [PATCH v2 04/13] NFS: add cross file system check for copy_file_range
Content-Type: text/plain; charset="UTF-8"
To: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Cc: trond.myklebust@hammerspace.com, Anna Schumaker <anna.schumaker@netapp.com>, Al Viro <viro@zeniv.linux.org.uk>, Steve French <smfrench@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-cifs@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 24, 2018 at 10:59 PM Olga Kornievskaia
<olga.kornievskaia@gmail.com> wrote:
>
> From: Olga Kornievskaia <kolga@netapp.com>
>
> VFS copy_file_range was relaxed to allow for cross-device copy.
> Add a check to disallow cross file systems copy offload, both
> files are expected to be of NFS type.
>
> Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
> ---
>  fs/nfs/nfs4file.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
> index 4288a6e..7137e7b 100644
> --- a/fs/nfs/nfs4file.c
> +++ b/fs/nfs/nfs4file.c
> @@ -135,6 +135,9 @@ static ssize_t nfs4_copy_file_range(struct file *file_in, loff_t pos_in,
>  {
>         ssize_t ret;
>
> +       if (file_in->f_inode->i_sb->s_type != file_out->f_inode->i_sb->s_type)
> +               return -EXDEV;
> +

You would need to doo  the patches in following order:
1. add same sb check in nfs
2. relax same sb check in vfs
3. implement cross fs copy in nfs
4. relax same sb to same sb type in nfs

Thanks,
Amir.
