From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 3/7] security,overlayfs: Provide security hook for copy up
 of xattrs for overlay file
Date: Mon, 11 Jul 2016 11:31:47 -0400
Message-ID: <2277404e-d91a-7190-ccbd-96e668ea95dd@tycho.nsa.gov>
References: <1467994782-26474-1-git-send-email-vgoyal@redhat.com>
 <1467994782-26474-4-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from emsm-gh1-uea10.nsa.gov ([8.44.101.8]:18180 "EHLO
	emsm-gh1-uea10.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030735AbcGKPaQ (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 11 Jul 2016 11:30:16 -0400
In-Reply-To: <1467994782-26474-4-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>, miklos@szeredi.hu, pmoore@redhat.com, casey@schaufler-ca.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: dwalsh@redhat.com, dhowells@redhat.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org

On 07/08/2016 12:19 PM, Vivek Goyal wrote:
> Provide a security hook which is called when xattrs of a file are being
> copied up. This hook is called once for each xattr and LSM can return 0
> to access the xattr, 1 to reject xattr, -EOPNOTSUPP if none of the lsms
> claim to know xattr and a negative error code if something went terribly
> wrong.

0 if the security module wants the xattr to be copied up, 1 if the
security module wants the xattr to be discarded on the copy, -EOPNOTSUPP
if the security module does not handle/manage the xattr, or a -errno
upon an error.

> 
> If 0 or -EOPNOTSUPP is returned, xattr will be copied up, if 1 is returned,
> xattr will not be copied up and if negative error code is returned, copy up
> will be aborted.

Not sure I understand the benefit of the 0 vs -EOPNOTSUPP distinction.

> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/copy_up.c    |  7 +++++++
>  include/linux/lsm_hooks.h | 10 ++++++++++
>  include/linux/security.h  |  6 ++++++
>  security/security.c       |  8 ++++++++
>  4 files changed, 31 insertions(+)
> 
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 8ebea18..68cefb2 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -103,6 +103,13 @@ retry:
>  			goto retry;
>  		}
>  
> +		error = security_inode_copy_up_xattr(name);
> +		if (error < 0 && error != -EOPNOTSUPP)
> +			break;
> +		if (error == 1) {
> +			error = 0;
> +			continue; /* Discard */
> +		}
>  		error = vfs_setxattr(new, name, value, size, 0);
>  		if (error)
>  			break;
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index c1f95be..84caead 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -410,6 +410,14 @@
>   *	@src indicates the union dentry of file that is being copied up.
>   *	@new pointer to pointer to return newly allocated creds.
>   *	Returns 0 on success or a negative error code on error.
> + * @inode_copy_up_xattr:
> + *	Filter the xattrs being copied up when a unioned file is copied
> + *	up from a lower layer to the union/overlay layer.
> + *	@name indicates the name of the xattr.
> + *	Returns 0 to accept the xattr, 1 to discard the xattr, -EOPNOTSUPP if
> + *	security module does not know about attribute or a negative error code
> + *	to abort the copy up. Note that the caller is responsible for reading
> + *	and writing the xattrs as this hook is merely a filter.
>   *
>   * Security hooks for file operations
>   *
> @@ -1435,6 +1443,7 @@ union security_list_options {
>  					size_t buffer_size);
>  	void (*inode_getsecid)(struct inode *inode, u32 *secid);
>  	int (*inode_copy_up) (struct dentry *src, struct cred **new);
> +	int (*inode_copy_up_xattr) (const char *name);
>  
>  	int (*file_permission)(struct file *file, int mask);
>  	int (*file_alloc_security)(struct file *file);
> @@ -1707,6 +1716,7 @@ struct security_hook_heads {
>  	struct list_head inode_listsecurity;
>  	struct list_head inode_getsecid;
>  	struct list_head inode_copy_up;
> +	struct list_head inode_copy_up_xattr;
>  	struct list_head file_permission;
>  	struct list_head file_alloc_security;
>  	struct list_head file_free_security;
> diff --git a/include/linux/security.h b/include/linux/security.h
> index c976d79..08d3191 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -283,6 +283,7 @@ int security_inode_setsecurity(struct inode *inode, const char *name, const void
>  int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
>  void security_inode_getsecid(struct inode *inode, u32 *secid);
>  int security_inode_copy_up(struct dentry *src, struct cred **new);
> +int security_inode_copy_up_xattr(const char *name);
>  int security_file_permission(struct file *file, int mask);
>  int security_file_alloc(struct file *file);
>  void security_file_free(struct file *file);
> @@ -764,6 +765,11 @@ static inline int security_inode_copy_up(struct dentry *src, struct cred **new)
>  	return 0;
>  }
>  
> +static inline int security_inode_copy_up_xattr(const char *name)
> +{
> +	-EOPNOTSUPP;

return?

> +}
> +
>  static inline int security_file_permission(struct file *file, int mask)
>  {
>  	return 0;
> diff --git a/security/security.c b/security/security.c
> index 3d142aa..3321e31 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -733,6 +733,12 @@ int security_inode_copy_up(struct dentry *src, struct cred **new)
>  }
>  EXPORT_SYMBOL(security_inode_copy_up);
>  
> +int security_inode_copy_up_xattr(const char *name)
> +{
> +	return call_int_hook(inode_copy_up_xattr, -EOPNOTSUPP, name);
> +}
> +EXPORT_SYMBOL(security_inode_copy_up_xattr);
> +
>  int security_file_permission(struct file *file, int mask)
>  {
>  	int ret;
> @@ -1671,6 +1677,8 @@ struct security_hook_heads security_hook_heads = {
>  		LIST_HEAD_INIT(security_hook_heads.inode_getsecid),
>  	.inode_copy_up =
>  		LIST_HEAD_INIT(security_hook_heads.inode_copy_up),
> +	.inode_copy_up_xattr =
> +		LIST_HEAD_INIT(security_hook_heads.inode_copy_up_xattr),
>  	.file_permission =
>  		LIST_HEAD_INIT(security_hook_heads.file_permission),
>  	.file_alloc_security =
> 
