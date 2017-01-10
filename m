From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] ovl: do not ignore disk quota if current task is not
 privileged
Date: Tue, 10 Jan 2017 09:46:10 -0500
Message-ID: <20170110144610.GC23108@redhat.com>
References: <148404760886.4400.14907571208759802396.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <148404760886.4400.14907571208759802396.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jan 10, 2017 at 02:26:48PM +0300, Konstantin Khlebnikov wrote:
> If overlay was mounted by root then quota set for upper layer does not work
> because overlay now always use mounter's credentials for operations.
> 
> This patch adds second copy of credentials without CAP_SYS_RESOURCE and
> use it if current task doesn't have this capability in mounter's user-ns.
> This affects creation new files, whiteouts, and copy-up operations.
> 
> Now quota limits are ignored only if both mounter and current task have
> capability CAP_SYS_RESOURCE in root user namespace.

This makes sense to me. I too would like quota to take effect for
containers on overlay.

I will test it. 

Vivek

> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Fixes: 1175b6b8d963 ("ovl: do operations on underlying file system in mounter's context")
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/overlayfs/ovl_entry.h |    2 ++
>  fs/overlayfs/super.c     |   13 ++++++++++++-
>  fs/overlayfs/util.c      |   10 +++++++++-
>  3 files changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index d14bca1850d9..55eb3b08e292 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -27,6 +27,8 @@ struct ovl_fs {
>  	struct ovl_config config;
>  	/* creds of process who forced instantiation of super block */
>  	const struct cred *creator_cred;
> +	/* the same credentials without CAP_SYS_RESOURCE */
> +	const struct cred *creator_cred_unpriv;
>  };
>  
>  /* private information held for every overlayfs dentry */
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 20f48abbb82f..6a15693641e0 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -157,6 +157,7 @@ static void ovl_put_super(struct super_block *sb)
>  	kfree(ufs->config.upperdir);
>  	kfree(ufs->config.workdir);
>  	put_cred(ufs->creator_cred);
> +	put_cred(ufs->creator_cred_unpriv);
>  	kfree(ufs);
>  }
>  
> @@ -701,6 +702,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>  	unsigned int stacklen = 0;
>  	unsigned int i;
>  	bool remote = false;
> +	struct cred *cred;
>  	int err;
>  
>  	err = -ENOMEM;
> @@ -874,10 +876,17 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>  	if (!ufs->creator_cred)
>  		goto out_put_lower_mnt;
>  
> +	cred = prepare_creds();
> +	if (!cred)
> +		goto out_put_cred;
> +
> +	ufs->creator_cred_unpriv = cred;
> +	cap_lower(cred->cap_effective, CAP_SYS_RESOURCE);
> +
>  	err = -ENOMEM;
>  	oe = ovl_alloc_entry(numlower);
>  	if (!oe)
> -		goto out_put_cred;
> +		goto out_put_cred_unpriv;
>  
>  	sb->s_magic = OVERLAYFS_SUPER_MAGIC;
>  	sb->s_op = &ovl_super_operations;
> @@ -914,6 +923,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>  
>  out_free_oe:
>  	kfree(oe);
> +out_put_cred_unpriv:
> +	put_cred(ufs->creator_cred_unpriv);
>  out_put_cred:
>  	put_cred(ufs->creator_cred);
>  out_put_lower_mnt:
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 952286f4826c..92f60096c5da 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -35,8 +35,16 @@ struct dentry *ovl_workdir(struct dentry *dentry)
>  const struct cred *ovl_override_creds(struct super_block *sb)
>  {
>  	struct ovl_fs *ofs = sb->s_fs_info;
> +	const struct cred *cred = ofs->creator_cred;
>  
> -	return override_creds(ofs->creator_cred);
> +	/*
> +	 * Do not override quota inode limit if current task is not
> +	 * capable to do that in mounter's user namespace.
> +	 */
> +	if (!ns_capable_noaudit(cred->user_ns, CAP_SYS_RESOURCE))
> +		cred = ofs->creator_cred_unpriv;
> +
> +	return override_creds(cred);
>  }
>  
>  struct ovl_entry *ovl_alloc_entry(unsigned int numlower)
