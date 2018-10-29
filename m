Return-Path: <olga.kornievskaia@gmail.com>
MIME-Version: 1.0
References: <20181029174059.38326-1-olga.kornievskaia@gmail.com> <20181029174059.38326-14-olga.kornievskaia@gmail.com>
In-Reply-To: <20181029174059.38326-14-olga.kornievskaia@gmail.com>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Date: Mon, 29 Oct 2018 13:46:12 -0400
Message-ID: <CAN-5tyEuxrsJYEaWPoY63FKHZN7ZPSrmNwqOoZMo52yU_MHLQA@mail.gmail.com>
Subject: Re: [PATCH v5 12/12] NFS: replace cross device check in copy_file_range
Content-Type: text/plain; charset="UTF-8"
To: trond.myklebust@hammerspace.com, Anna Schumaker <anna.schumaker@netapp.com>, viro@zeniv.linux.org.uk, Steve French <smfrench@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-nfs <linux-nfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Please note this is PATCH v5 (it got added to the thread of PATCH v4).

On Mon, Oct 29, 2018 at 1:41 PM Olga Kornievskaia
<olga.kornievskaia@gmail.com> wrote:
>
> From: Olga Kornievskaia <kolga@netapp.com>
>
> Add a check to disallow cross file systems copy offload, both
> files are expected to be of NFS4.2+ type.
>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> Reviewed-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
> ---
>  fs/nfs/nfs4file.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
> index 989f174..fde4465 100644
> --- a/fs/nfs/nfs4file.c
> +++ b/fs/nfs/nfs4file.c
> @@ -138,11 +138,16 @@ static ssize_t nfs4_copy_file_range(struct file *file_in, loff_t pos_in,
>         struct nl4_server *nss = NULL;
>         nfs4_stateid *cnrs = NULL;
>         ssize_t ret;
> +       struct nfs_client *c_in;
>
>         if (pos_in >= i_size_read(file_inode(file_in)))
>                 return -EINVAL;
>
> -       if (file_inode(file_in)->i_sb != file_inode(file_out)->i_sb)
> +       if (file_in->f_op != &nfs4_file_operations)
> +               return -EXDEV;
> +
> +       c_in = (NFS_SERVER(file_inode(file_in)))->nfs_client;
> +       if (c_in->cl_minorversion < 2)
>                 return -EXDEV;
>
>         if (file_inode(file_in) == file_inode(file_out))
> --
> 1.8.3.1
>
