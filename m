From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 1/9] security, overlayfs: provide copy up security hook
 for unioned files
Date: Wed, 13 Jul 2016 10:52:34 -0400
Message-ID: <eecf35d9-707b-5dab-e3e8-273cf221d135@tycho.nsa.gov>
References: <1468421095-22322-1-git-send-email-vgoyal@redhat.com>
 <1468421095-22322-2-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from smtp.nsa.gov ([8.44.101.8]:55328 "EHLO emsm-gh1-uea10.nsa.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbcGMOv1 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 13 Jul 2016 10:51:27 -0400
In-Reply-To: <1468421095-22322-2-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>, miklos@szeredi.hu, pmoore@redhat.com, casey@schaufler-ca.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: dwalsh@redhat.com, dhowells@redhat.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org

On 07/13/2016 10:44 AM, Vivek Goyal wrote:
> Provide a security hook to label new file correctly when a file is copied
> up from lower layer to upper layer of a overlay/union mount.
> 
> This hook can prepare a new set of creds which are suitable for new file
> creation during copy up. Caller will use new creds to create file and then
> revert back to old creds and release new creds.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/copy_up.c    | 18 ++++++++++++++++++
>  include/linux/lsm_hooks.h | 11 +++++++++++
>  include/linux/security.h  |  6 ++++++
>  security/security.c       |  8 ++++++++
>  4 files changed, 43 insertions(+)
> 
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 80aa6f1..8ebea18 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -246,6 +246,8 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
>  	struct dentry *upper = NULL;
>  	umode_t mode = stat->mode;
>  	int err;
> +	const struct cred *old_creds = NULL;
> +	struct cred *new_creds = NULL;
>  
>  	newdentry = ovl_lookup_temp(workdir, dentry);
>  	err = PTR_ERR(newdentry);
> @@ -258,10 +260,26 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
>  	if (IS_ERR(upper))
>  		goto out1;
>  
> +	err = security_inode_copy_up(dentry, &new_creds);
> +	if (err < 0) {
> +		if (new_creds)
> +			put_cred(new_creds);

I think this is a mistake, diverges from how other hooks handle error
conditions (if the hook allocates, the hook or the security
infrastructure is responsible for freeing on error return, not the
caller), and will be prone to double free errors.

> +		goto out2;
> +	}
> +
> +	if (new_creds)
> +		old_creds = override_creds(new_creds);
> +
>  	/* Can't properly set mode on creation because of the umask */
>  	stat->mode &= S_IFMT;
>  	err = ovl_create_real(wdir, newdentry, stat, link, NULL, true);
>  	stat->mode = mode;
> +
> +	if (new_creds) {
> +		revert_creds(old_creds);
> +		put_cred(new_creds);
> +	}
> +
>  	if (err)
>  		goto out2;
>  
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 7ae3976..c1f95be 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -401,6 +401,15 @@
>   *	@inode contains a pointer to the inode.
>   *	@secid contains a pointer to the location where result will be saved.
>   *	In case of failure, @secid will be set to zero.
> + * @inode_copy_up:
> + *	A file is about to be copied up from lower layer to upper layer of
> + *	overlay filesystem. Security module can prepare a set of new creds
> + *	and modify as need be and return new creds. Caller will switch to
> + *	new creds temporarily to create new file and release newly allocated
> + *	creds.
> + *	@src indicates the union dentry of file that is being copied up.
> + *	@new pointer to pointer to return newly allocated creds.
> + *	Returns 0 on success or a negative error code on error.
>   *
>   * Security hooks for file operations
>   *
> @@ -1425,6 +1434,7 @@ union security_list_options {
>  	int (*inode_listsecurity)(struct inode *inode, char *buffer,
>  					size_t buffer_size);
>  	void (*inode_getsecid)(struct inode *inode, u32 *secid);
> +	int (*inode_copy_up) (struct dentry *src, struct cred **new);
>  
>  	int (*file_permission)(struct file *file, int mask);
>  	int (*file_alloc_security)(struct file *file);
> @@ -1696,6 +1706,7 @@ struct security_hook_heads {
>  	struct list_head inode_setsecurity;
>  	struct list_head inode_listsecurity;
>  	struct list_head inode_getsecid;
> +	struct list_head inode_copy_up;
>  	struct list_head file_permission;
>  	struct list_head file_alloc_security;
>  	struct list_head file_free_security;
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 14df373..c976d79 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -282,6 +282,7 @@ int security_inode_getsecurity(struct inode *inode, const char *name, void **buf
>  int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
>  int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
>  void security_inode_getsecid(struct inode *inode, u32 *secid);
> +int security_inode_copy_up(struct dentry *src, struct cred **new);
>  int security_file_permission(struct file *file, int mask);
>  int security_file_alloc(struct file *file);
>  void security_file_free(struct file *file);
> @@ -758,6 +759,11 @@ static inline void security_inode_getsecid(struct inode *inode, u32 *secid)
>  	*secid = 0;
>  }
>  
> +static inline int security_inode_copy_up(struct dentry *src, struct cred **new)
> +{
> +	return 0;
> +}
> +
>  static inline int security_file_permission(struct file *file, int mask)
>  {
>  	return 0;
> diff --git a/security/security.c b/security/security.c
> index 7095693..3d142aa 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -727,6 +727,12 @@ void security_inode_getsecid(struct inode *inode, u32 *secid)
>  	call_void_hook(inode_getsecid, inode, secid);
>  }
>  
> +int security_inode_copy_up(struct dentry *src, struct cred **new)
> +{
> +	return call_int_hook(inode_copy_up, 0, src, new);
> +}
> +EXPORT_SYMBOL(security_inode_copy_up);
> +
>  int security_file_permission(struct file *file, int mask)
>  {
>  	int ret;
> @@ -1663,6 +1669,8 @@ struct security_hook_heads security_hook_heads = {
>  		LIST_HEAD_INIT(security_hook_heads.inode_listsecurity),
>  	.inode_getsecid =
>  		LIST_HEAD_INIT(security_hook_heads.inode_getsecid),
> +	.inode_copy_up =
> +		LIST_HEAD_INIT(security_hook_heads.inode_copy_up),
>  	.file_permission =
>  		LIST_HEAD_INIT(security_hook_heads.file_permission),
>  	.file_alloc_security =
> 
