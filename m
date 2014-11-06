From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 1/7] Security: Provide copy-up security hooks for unioned
 files
Date: Thu, 06 Nov 2014 09:46:05 -0800
Message-ID: <545BB3DD.1010607@schaufler-ca.com>
References: <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154228.2555.55814.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20141105154228.2555.55814.stgit@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov
Cc: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On 11/5/2014 7:42 AM, David Howells wrote:
> Provide two new security hooks for use with security files that are used when
> a file is copied up between layers:
>
>  (1) security_inode_copy_up().  This is called so that the security label on
>      the destination file can be set appropriately.
>
>  (2) security_inode_copy_up_xattr().  This is called so that each xattr being
>      copied up can be vetted - including modification and discard.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
>  include/linux/security.h |   35 +++++++++++++++++++++++++++++++++++
>  security/capability.c    |   13 +++++++++++++
>  security/security.c      |   13 +++++++++++++
>  3 files changed, 61 insertions(+)
>
> diff --git a/include/linux/security.h b/include/linux/security.h
> index ba96471c11ba..637a24c75d46 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -562,6 +562,24 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
>   *	@inode contains a pointer to the inode.
>   *	@secid contains a pointer to the location where result will be saved.
>   *	In case of failure, @secid will be set to zero.
> + * @inode_copy_up:
> + *	Generate the secid associated with the destination inode when a unioned

NAK.

You can't just deal with the access label, nor can you assume that there
is exactly one. Don't use secids. Secids are a performance problem for
Smack and any LSM that uses blobs directly. I don't see anything in the
code here that involves secids. Why comment on them here?

> + *	file is copied up from a lower layer to the union/overlay layer.
> + *	@src indicates the file that is being copied up.
> + *	@dst indicates the file that has being created by the copy up.
> + *	Returns 0 on success or a negative error code on error.
> + * @inode_copy_up_xattr:
> + *	Filter/modify the xattrs being copied up when a unioned file is copied
> + *	up from a lower layer to the union/overlay layer.
> + *	@src indicates the file that is being copied up.
> + *	@dst indicates the file that has being created by the copy up.
> + *	@name indicates the name of the xattr.
> + *	@value, *@size indicate the payload of the xattr.
> + *	Returns 0 to accept the xattr, 1 to discard the xattr or a negative
> + *	error code to abort the copy up.  The xattr buffer must be at least
> + *	XATTR_SIZE_MAX in capacity and the contents may be modified and *@size
> + *	changed appropriately.

Who is going to call this? How are is the caller going to know all the xattr
names that matter?

> + *
>   *
>   * Security hooks for file operations
>   *
> @@ -1543,6 +1561,9 @@ struct security_operations {
>  	int (*inode_setsecurity) (struct inode *inode, const char *name, const void *value, size_t size, int flags);
>  	int (*inode_listsecurity) (struct inode *inode, char *buffer, size_t buffer_size);
>  	void (*inode_getsecid) (const struct inode *inode, u32 *secid);
> +	int (*inode_copy_up) (struct dentry *src, struct dentry *dst);
> +	int (*inode_copy_up_xattr) (struct dentry *src, struct dentry *dst,
> +				    const char *name, void *value, size_t *size);
>  
>  	int (*file_permission) (struct file *file, int mask);
>  	int (*file_alloc_security) (struct file *file);
> @@ -1823,6 +1844,10 @@ int security_inode_getsecurity(const struct inode *inode, const char *name, void
>  int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
>  int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
>  void security_inode_getsecid(const struct inode *inode, u32 *secid);
> +int security_inode_copy_up(struct dentry *src, struct dentry *dst);
> +int security_inode_copy_up_xattr(struct dentry *src, struct dentry *dst,
> +				 const char *name, void *value, size_t *size);
> +
>  int security_file_permission(struct file *file, int mask);
>  int security_file_alloc(struct file *file);
>  void security_file_free(struct file *file);
> @@ -2264,6 +2289,16 @@ static inline void security_inode_getsecid(const struct inode *inode, u32 *secid
>  	*secid = 0;
>  }
>  
> +static inline int security_inode_copy_up(struct dentry *src, struct dentry *dst)
> +{
> +	return 0;
> +}
> +static inline int security_inode_copy_up_xattr(struct dentry *src, struct dentry *dst,
> +					       const char *name, const void *value, size_t size)
> +{
> +	return 0;
> +}
> +
>  static inline int security_file_permission(struct file *file, int mask)
>  {
>  	return 0;
> diff --git a/security/capability.c b/security/capability.c
> index d68c57a62bcf..6b21615d1500 100644
> --- a/security/capability.c
> +++ b/security/capability.c
> @@ -245,6 +245,17 @@ static void cap_inode_getsecid(const struct inode *inode, u32 *secid)
>  	*secid = 0;
>  }
>  
> +static int cap_inode_copy_up(struct dentry *src, struct dentry *dst)
> +{
> +	return 0;
> +}
> +
> +static int cap_inode_copy_up_xattr(struct dentry *src, struct dentry *dst,
> +				   const char *name, void *value, size_t *size)
> +{
> +	return 0;
> +}
> +

Does this mean that without LSM help no xattrs ever get copied?

>  #ifdef CONFIG_SECURITY_PATH
>  static int cap_path_mknod(struct path *dir, struct dentry *dentry, umode_t mode,
>  			  unsigned int dev)
> @@ -986,6 +997,8 @@ void __init security_fixup_ops(struct security_operations *ops)
>  	set_to_cap_if_null(ops, inode_setsecurity);
>  	set_to_cap_if_null(ops, inode_listsecurity);
>  	set_to_cap_if_null(ops, inode_getsecid);
> +	set_to_cap_if_null(ops, inode_copy_up);
> +	set_to_cap_if_null(ops, inode_copy_up_xattr);
>  #ifdef CONFIG_SECURITY_PATH
>  	set_to_cap_if_null(ops, path_mknod);
>  	set_to_cap_if_null(ops, path_mkdir);
> diff --git a/security/security.c b/security/security.c
> index 18b35c63fc0c..96e2f189ff1e 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -683,6 +683,19 @@ void security_inode_getsecid(const struct inode *inode, u32 *secid)
>  	security_ops->inode_getsecid(inode, secid);
>  }
>  
> +int security_inode_copy_up(struct dentry *src, struct dentry *dst)
> +{
> +	return security_ops->inode_copy_up(src, dst);
> +}
> +EXPORT_SYMBOL(security_inode_copy_up);
> +
> +int security_inode_copy_up_xattr(struct dentry *src, struct dentry *dst,
> +				 const char *name, void *value, size_t *size)
> +{
> +	return security_ops->inode_copy_up_xattr(src, dst, name, value, size);
> +}
> +EXPORT_SYMBOL(security_inode_copy_up_xattr);
> +
>  int security_file_permission(struct file *file, int mask)
>  {
>  	int ret;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

