Return-Path: <jlayton@kernel.org>
Message-ID: <7ef50e2c6b11ae80518db75efc35b2f96c9e4d32.camel@kernel.org>
Subject: Re: [PATCH v4 11/11] NFS: replace cross device check in
 copy_file_range
From: Jeff Layton <jlayton@kernel.org>
Date: Sat, 27 Oct 2018 07:08:11 -0400
In-Reply-To: <20181026201057.36899-13-olga.kornievskaia@gmail.com>
References: <20181026201057.36899-1-olga.kornievskaia@gmail.com>
	 <20181026201057.36899-13-olga.kornievskaia@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Olga Kornievskaia <olga.kornievskaia@gmail.com>, trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu
Cc: linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, 2018-10-26 at 16:10 -0400, Olga Kornievskaia wrote:
> From: Olga Kornievskaia <kolga@netapp.com>
> 
> Add a check to disallow cross file systems copy offload, both
> files are expected to be of NFS4.2+ type.
> 
> Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
> ---
>  fs/nfs/nfs4file.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
> index 2f31f30..344e9dd 100644
> --- a/fs/nfs/nfs4file.c
> +++ b/fs/nfs/nfs4file.c
> @@ -139,8 +139,14 @@ static ssize_t nfs4_copy_file_range(struct file *file_in, loff_t pos_in,
>  	nfs4_stateid *cnrs = NULL;
>  	ssize_t ret;
>  
> -	if (file_in->f_inode->i_sb != file_out->f_inode->i_sb)
> +	if (file_in->f_op != &nfs4_file_operations)
>  		return -EXDEV;
> +	else {

nit: you don't really need the "else" here since the previous block
returns

> +		struct nfs_client *c_in =
> +			(NFS_SERVER(file_inode(file_in)))->nfs_client;
> +		if (c_in->cl_minorversion < 2)
> +			return -EXDEV;
> +	}
>  
>  	if (file_inode(file_in) == file_inode(file_out))
>  		return -EINVAL;

Looks fine though.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
