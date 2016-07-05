From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/5] security,overlayfs: Provide security hook for copy up
 of xattrs for overlay file
Date: Tue, 5 Jul 2016 13:22:22 -0700
Message-ID: <bc7c8147-465e-791d-ce5a-1a194eb67228@schaufler-ca.com>
References: <1467733854-6314-1-git-send-email-vgoyal@redhat.com>
 <1467733854-6314-3-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from nm2-vm1.bullet.mail.bf1.yahoo.com ([98.139.213.158]:56983 "EHLO
	nm2-vm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751465AbcGEUW2 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 5 Jul 2016 16:22:28 -0400
In-Reply-To: <1467733854-6314-3-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>, miklos@szeredi.hu, sds@tycho.nsa.gov, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: dwalsh@redhat.com, dhowells@redhat.com, pmoore@redhat.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org

On 7/5/2016 8:50 AM, Vivek Goyal wrote:
> Provide a security hook which is called when xattrs of a file are being
> copied up. This hook is called once for each xattr and one can either
> accept or reject xattr. If 0 is returned, xattr will be copied up, if 1
> is returned, xattr will not be copied up and if negative error code
> is returned, copy up will be aborted.
>
> In SELinux, label of lower file is not copied up. File already has been
> set with right label at the time of creation and we don't want to overwrite
> that label.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/copy_up.c    |  8 ++++++++
>  include/linux/lsm_hooks.h | 13 +++++++++++++
>  include/linux/security.h  | 10 ++++++++++
>  security/security.c       |  9 +++++++++
>  security/selinux/hooks.c  | 14 ++++++++++++++
>  5 files changed, 54 insertions(+)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 90dc362..2c31938 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -103,6 +103,14 @@ retry:
>  			goto retry;
>  		}
>  
> +		error = security_inode_copy_up_xattr(old, new,
> +						     name, value, size);
> +		if (error < 0)
> +			break;
> +		if (error == 1) {
> +			error = 0;
> +			continue; /* Discard */
> +		}
>  		error = vfs_setxattr(new, name, value, size, 0);
>  		if (error)
>  			break;
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index fcde9b9..2a8ee8c 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -412,6 +412,16 @@
>   *	@src indicates the union dentry of file that is being copied up.
>   *	@old indicates the pointer to old_cred returned to caller.
>   *	Returns 0 on success or a negative error code on error.
> + * @inode_copy_up_xattr:
> + *	Filter the xattrs being copied up when a unioned file is copied
> + *	up from a lower layer to the union/overlay layer.
> + *	@src indicates the file that is being copied up.
> + *	@dst indicates the file that has being created by the copy up.
> + *	@name indicates the name of the xattr.
> + *	@value, @size indicate the payload of the xattr.
> + *	Returns 0 to accept the xattr, 1 to discard the xattr or a negative
> + *	error code to abort the copy up. Note that the caller is responsible
> + *	for reading and writing the xattrs as this hook is merely a filter.

The return should be -EOPNOTSUPP from security modules that don't
support the attribute "name". This will make it possible to support
multiple modules that provide attributes. (patches pending)

If the only use to which this hook is put is to identify attributes
that should be discarded it's unnecessary overhead to pass the
parameters that are never used.

>   *
>   * Security hooks for file operations
>   *
> @@ -1437,6 +1447,8 @@ union security_list_options {
>  					size_t buffer_size);
>  	void (*inode_getsecid)(struct inode *inode, u32 *secid);
>  	int (*inode_copy_up) (struct dentry *src, const struct cred **old);
> +	int (*inode_copy_up_xattr) (struct dentry *src, struct dentry *dst,
> +				    const char *name, void *value, size_t size);
>  
>  	int (*file_permission)(struct file *file, int mask);
>  	int (*file_alloc_security)(struct file *file);
> @@ -1709,6 +1721,7 @@ struct security_hook_heads {
>  	struct list_head inode_listsecurity;
>  	struct list_head inode_getsecid;
>  	struct list_head inode_copy_up;
> +	struct list_head inode_copy_up_xattr;
>  	struct list_head file_permission;
>  	struct list_head file_alloc_security;
>  	struct list_head file_free_security;
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 3445df2..663ca15 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -283,6 +283,8 @@ int security_inode_setsecurity(struct inode *inode, const char *name, const void
>  int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
>  void security_inode_getsecid(struct inode *inode, u32 *secid);
>  int security_inode_copy_up(struct dentry *src, const struct cred **old);
> +int security_inode_copy_up_xattr(struct dentry *src, struct dentry *dst,
> +				 const char *name, void *value, size_t size);
>  int security_file_permission(struct file *file, int mask);
>  int security_file_alloc(struct file *file);
>  void security_file_free(struct file *file);
> @@ -764,6 +766,14 @@ static inline int security_inode_copy_up(struct dentry *src, struct dentry *dst)
>  	return 0;
>  }
>  
> +static inline int security_inode_copy_up_xattr(struct dentry *src,
> +					       struct dentry *dst,
> +					       const char *name,
> +					       const void *value, size_t size)
> +{
> +	return 0;
> +}
> +
>  static inline int security_file_permission(struct file *file, int mask)
>  {
>  	return 0;
> diff --git a/security/security.c b/security/security.c
> index 7c1ce29..87712c6 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -733,6 +733,13 @@ int security_inode_copy_up(struct dentry *src, const struct cred **old)
>  }
>  EXPORT_SYMBOL(security_inode_copy_up);
>  
> +int security_inode_copy_up_xattr(struct dentry *src, struct dentry *dst,
> +				 const char *name, void *value, size_t size)
> +{
> +	return call_int_hook(inode_copy_up_xattr, 0, src, dst, name, value, size);
> +}
> +EXPORT_SYMBOL(security_inode_copy_up_xattr);
> +
>  int security_file_permission(struct file *file, int mask)
>  {
>  	int ret;
> @@ -1671,6 +1678,8 @@ struct security_hook_heads security_hook_heads = {
>  		LIST_HEAD_INIT(security_hook_heads.inode_getsecid),
>  	.inode_copy_up =
>  		LIST_HEAD_INIT(security_hook_heads.inode_copy_up),
> +	.inode_copy_up_xattr =
> +		LIST_HEAD_INIT(security_hook_heads.inode_copy_up_xattr),
>  	.file_permission =
>  		LIST_HEAD_INIT(security_hook_heads.file_permission),
>  	.file_alloc_security =
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 1b1a1e5..c68223c 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -3296,6 +3296,19 @@ static int selinux_inode_copy_up(struct dentry *src, const struct cred **old)
>  	return 0;
>  }
>  
> +static int selinux_inode_copy_up_xattr(struct dentry *src, struct dentry *dst,
> +				       const char *name, void *value,
> +				       size_t size)
> +{
> +	/* The copy_up hook above sets the initial context on an inode, but we
> +	 * don't then want to overwrite it by blindly copying all the lower
> +	 * xattrs up.  Instead, we have to filter out SELinux-related xattrs.
> +	 */
> +	if (strcmp(name, XATTR_NAME_SELINUX) == 0)
> +		return 1; /* Discard */
> +	return 0;
> +}
> +
>  /* file security operations */
>  
>  static int selinux_revalidate_file_permission(struct file *file, int mask)
> @@ -6083,6 +6096,7 @@ static struct security_hook_list selinux_hooks[] = {
>  	LSM_HOOK_INIT(inode_listsecurity, selinux_inode_listsecurity),
>  	LSM_HOOK_INIT(inode_getsecid, selinux_inode_getsecid),
>  	LSM_HOOK_INIT(inode_copy_up, selinux_inode_copy_up),
> +	LSM_HOOK_INIT(inode_copy_up_xattr, selinux_inode_copy_up_xattr),
>  
>  	LSM_HOOK_INIT(file_permission, selinux_file_permission),
>  	LSM_HOOK_INIT(file_alloc_security, selinux_file_alloc_security),
