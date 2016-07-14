From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 6/9] security, overlayfs: Provide hook to correctly label
 newly created files
Date: Thu, 14 Jul 2016 10:29:44 -0400
Message-ID: <50ade62f-fbd1-7d93-727a-6821b869af05@tycho.nsa.gov>
References: <1468421095-22322-1-git-send-email-vgoyal@redhat.com>
 <1468421095-22322-7-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from smtp.nsa.gov ([8.44.101.9]:14546 "EHLO emsm-gh1-uea11.nsa.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbcGNO2F (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 14 Jul 2016 10:28:05 -0400
In-Reply-To: <1468421095-22322-7-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>, miklos@szeredi.hu, pmoore@redhat.com, casey@schaufler-ca.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: dwalsh@redhat.com, dhowells@redhat.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org

On 07/13/2016 10:44 AM, Vivek Goyal wrote:
> During a new file creation we need to make sure new file is created with the
> right label. New file is created in upper/ so effectively file should get
> label as if task had created file in upper/.
> 
> We switched to mounter's creds for actual file creation. Also if there is a
> whiteout present, then file will be created in work/ dir first and then
> renamed in upper. In none of the cases file will be labeled as we want it to
> be.
> 
> This patch introduces a new hook dentry_create_files_as(), which determines
> the label/context dentry will get if it had been created by task in upper
> and modify passed set of creds appropriately. Caller makes use of these new
> creds for file creation.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Stephen Smalley <sds@tycho.nsa.gov>

> ---
>  fs/overlayfs/dir.c        | 10 ++++++++++
>  include/linux/lsm_hooks.h | 15 +++++++++++++++
>  include/linux/security.h  | 12 ++++++++++++
>  security/security.c       | 11 +++++++++++
>  4 files changed, 48 insertions(+)
> 
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 4cdeb74..f94872f 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -433,6 +433,15 @@ static int ovl_create_or_link(struct dentry *dentry, int mode, dev_t rdev,
>  	if (override_cred) {
>  		override_cred->fsuid = inode->i_uid;
>  		override_cred->fsgid = inode->i_gid;
> +		if (!hardlink) {
> +			err = security_dentry_create_files_as(dentry,
> +					mode, &dentry->d_name, old_cred,
> +					override_cred);
> +			if (err) {
> +				put_cred(override_cred);
> +				goto out_revert_creds;
> +			}
> +		}
>  		put_cred(override_creds(override_cred));
>  		put_cred(override_cred);
>  
> @@ -443,6 +452,7 @@ static int ovl_create_or_link(struct dentry *dentry, int mode, dev_t rdev,
>  			err = ovl_create_over_whiteout(dentry, inode, &stat,
>  							link, hardlink);
>  	}
> +out_revert_creds:
>  	revert_creds(old_cred);
>  	if (!err) {
>  		struct inode *realinode = d_inode(ovl_dentry_upper(dentry));
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 84caead..95745fe 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -151,6 +151,16 @@
>   *	@name name of the last path component used to create file
>   *	@ctx pointer to place the pointer to the resulting context in.
>   *	@ctxlen point to place the length of the resulting context.
> + * @dentry_create_files_as:
> + *	Compute a context for a dentry as the inode is not yet available
> + *	and set that context in passed in creds so that new files are
> + *	created using that context. Context is calculated using the
> + *	passed in creds and not the creds of the caller.
> + *	@dentry dentry to use in calculating the context.
> + *	@mode mode used to determine resource type.
> + *	@name name of the last path component used to create file
> + * 	@old creds which should be used for context calculation
> + * 	@new creds to modify
>   *
>   *
>   * Security hooks for inode operations.
> @@ -1375,6 +1385,10 @@ union security_list_options {
>  	int (*dentry_init_security)(struct dentry *dentry, int mode,
>  					struct qstr *name, void **ctx,
>  					u32 *ctxlen);
> +	int (*dentry_create_files_as)(struct dentry *dentry, int mode,
> +					struct qstr *name,
> +					const struct cred *old,
> +					struct cred *new);
>  
>  
>  #ifdef CONFIG_SECURITY_PATH
> @@ -1675,6 +1689,7 @@ struct security_hook_heads {
>  	struct list_head sb_clone_mnt_opts;
>  	struct list_head sb_parse_opts_str;
>  	struct list_head dentry_init_security;
> +	struct list_head dentry_create_files_as;
>  #ifdef CONFIG_SECURITY_PATH
>  	struct list_head path_unlink;
>  	struct list_head path_mkdir;
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 4a3b8bc..1eb03dc 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -242,6 +242,10 @@ int security_sb_parse_opts_str(char *options, struct security_mnt_opts *opts);
>  int security_dentry_init_security(struct dentry *dentry, int mode,
>  					struct qstr *name, void **ctx,
>  					u32 *ctxlen);
> +int security_dentry_create_files_as(struct dentry *dentry, int mode,
> +					struct qstr *name,
> +					const struct cred *old,
> +					struct cred *new);
>  
>  int security_inode_alloc(struct inode *inode);
>  void security_inode_free(struct inode *inode);
> @@ -600,6 +604,14 @@ static inline int security_dentry_init_security(struct dentry *dentry,
>  	return -EOPNOTSUPP;
>  }
>  
> +static inline int security_dentry_create_files_as(struct dentry *dentry,
> +						  int mode, struct qstr *name,
> +						  const struct cred *old,
> +						  struct cred *new)
> +{
> +	return 0;
> +}
> +
>  
>  static inline int security_inode_init_security(struct inode *inode,
>  						struct inode *dir,
> diff --git a/security/security.c b/security/security.c
> index 3321e31..38747d1 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -364,6 +364,15 @@ int security_dentry_init_security(struct dentry *dentry, int mode,
>  }
>  EXPORT_SYMBOL(security_dentry_init_security);
>  
> +int security_dentry_create_files_as(struct dentry *dentry, int mode,
> +					struct qstr *name,
> +					const struct cred *old, struct cred *new)
> +{
> +	return call_int_hook(dentry_create_files_as, 0, dentry, mode,
> +				name, old, new);
> +}
> +EXPORT_SYMBOL(security_dentry_create_files_as);
> +
>  int security_inode_init_security(struct inode *inode, struct inode *dir,
>  				 const struct qstr *qstr,
>  				 const initxattrs initxattrs, void *fs_data)
> @@ -1614,6 +1623,8 @@ struct security_hook_heads security_hook_heads = {
>  		LIST_HEAD_INIT(security_hook_heads.sb_parse_opts_str),
>  	.dentry_init_security =
>  		LIST_HEAD_INIT(security_hook_heads.dentry_init_security),
> +	.dentry_create_files_as =
> +		LIST_HEAD_INIT(security_hook_heads.dentry_create_files_as),
>  #ifdef CONFIG_SECURITY_PATH
>  	.path_unlink =	LIST_HEAD_INIT(security_hook_heads.path_unlink),
>  	.path_mkdir =	LIST_HEAD_INIT(security_hook_heads.path_mkdir),
> 
