From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2] ovl: drop CAP_SYS_RESOURCE from saved mounter's
 credentials
Date: Tue, 10 Jan 2017 14:17:21 -0500
Message-ID: <20170110191721.GF23108@redhat.com>
References: <148404760886.4400.14907571208759802396.stgit@buzz>
 <148407302133.16047.411379729888561193.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <148407302133.16047.411379729888561193.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jan 10, 2017 at 09:30:21PM +0300, Konstantin Khlebnikov wrote:
> If overlay was mounted by root then quota set for upper layer does not work
> because overlay now always use mounter's credentials for operations.
> Also overlay might deplete reserved space and inodes in ext4.
> 
> This patch drops capability SYS_RESOURCE from saved credentials.
> This affects creation new files, whiteouts, and copy-up operations.
> 

I am not an expert in this area, but I thought previous patch was
better. I am not sure why overlay internal operations should be
done without CAP_SYS_RESOURCES when caller has CAP_SYS_RESOURCES. That
might be counter-intuitive.

If some task is allowed to bypass quota limitations on a file system
then same should be true when task is working on overlay.

Similary if a task is allowed to use reserved space on filesystem, then same
task should be allowed to use reserved space on underlying filesystem
when doing overlay.  It should not be overlay's job to prevent that?

May be it is just me....

Vivek


> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Fixes: 1175b6b8d963 ("ovl: do operations on underlying file system in mounter's context")
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/overlayfs/super.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 20f48abbb82f..8dba982e1af5 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -701,6 +701,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>  	unsigned int stacklen = 0;
>  	unsigned int i;
>  	bool remote = false;
> +	struct cred *cred;
>  	int err;
>  
>  	err = -ENOMEM;
> @@ -870,10 +871,14 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>  	else
>  		sb->s_d_op = &ovl_dentry_operations;
>  
> -	ufs->creator_cred = prepare_creds();
> -	if (!ufs->creator_cred)
> +	cred = prepare_creds();
> +	if (!cred)
>  		goto out_put_lower_mnt;
>  
> +	/* Never override disk quota limits or use reserved space */
> +	cap_lower(cred->cap_effective, CAP_SYS_RESOURCE);
> +	ufs->creator_cred = cred;
> +
>  	err = -ENOMEM;
>  	oe = ovl_alloc_entry(numlower);
>  	if (!oe)
