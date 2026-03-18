Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE3A35CB76;
	Wed, 18 Mar 2026 10:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773831422; cv=none; b=JInwv8AnwlTU/rrE382QbXoDbxkZ2RWaM34ykibQdikI5Cs0CkNUBiGmgqVVGLkZ0gm5eHfIh1xCynILzExO0n0+S9Rb437I+npYMgHXziePAxueoB7rXmLmCSwOdXACf7HYW1h7h1sIhUpUf2Li3VIoQHddW4V1RXqIEcm64Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773831422; c=relaxed/simple;
	bh=tcfCmK3S2pt4aJtr9Tu11QJn/zIdTDayhGeZCwPth/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QgEKzm/bhK4vjW9sxYYw++HW79WibVhRGyK1Pl9PncmrlgTf4dvkp9JxJof+qkDAFf0baFGJ2F93vrCv5iU7mU64Y9qmZrBB6dyKUDBe9v0fnnWGnVaBFBiCkfbFGZceU/54XzmQir8ZbgyfDh7Ljnj0vaH3HotV9LA6axe6C3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CvrVE8BO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CvrVE8BO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F8EC19421;
	Wed, 18 Mar 2026 10:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773831422;
	bh=tcfCmK3S2pt4aJtr9Tu11QJn/zIdTDayhGeZCwPth/8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CvrVE8BO67At/HSXb+xLo8y2NsLBV9EYFZR+ACUUawr+31v1K37an0KaRws+zwKvR
	 Kr2YB0IM+j+xRIbTrZKVK7igfCqkeyhcfKXmsceKdsm6kW4f3roTHl+K3TN8fONbh8
	 EYzy3DxCiz/0iP528EMFE24tt8n061H8ThnljXvXh+rCCXr+W+lgHs/Sc6D5I8rpr1
	 lKsnnBP++HSeanzGJyfyR1IMGrinKL2Rvx/SBUZSzg0dHBThlGuTGZSi4dyrtEXdHy
	 22+dJSlshfTxtomPmCmdGVKB1M1wdiIbmSaNBk233pCcuv4NxgA/zFW/SybPZgERlw
	 ZkrzFm+JTpStA==
Date: Wed, 18 Mar 2026 11:56:57 +0100
From: Christian Brauner <brauner@kernel.org>
To: Paul Moore <paul@paul-moore.com>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH 1/3] backing_file: store user_path_file
Message-ID: <20260318-einsam-sellerie-2d547dd338ee@brauner>
References: <20260316213606.374109-5-paul@paul-moore.com>
 <20260316213606.374109-6-paul@paul-moore.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260316213606.374109-6-paul@paul-moore.com>

On Mon, Mar 16, 2026 at 05:35:56PM -0400, Paul Moore wrote:
> From: Amir Goldstein <amir73il@gmail.com>
> 
> Instead of storing the user_path, store an O_PATH file for the
> user_path with the original user file creds and a security context.
> 
> The user_path_file is only exported as a const pointer and its refcnt
> is initialized to FILE_REF_DEAD, because it is not a refcounted object.
> 
> The only caller of file_ref_init() is now open coded, so the helper
> is removed.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Tested-by: Paul Moore <paul@paul-moore.com> (SELinux)
> Acked-by: Gao Xiang <hsiangkao@linux.alibaba.com> (EROFS)
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> ---
>  fs/backing-file.c            | 20 ++++++++------
>  fs/erofs/ishare.c            |  6 ++--
>  fs/file_table.c              | 53 ++++++++++++++++++++++++++++--------
>  fs/fuse/passthrough.c        |  3 +-
>  fs/internal.h                |  5 ++--
>  fs/overlayfs/dir.c           |  3 +-
>  fs/overlayfs/file.c          |  1 +
>  include/linux/backing-file.h | 29 ++++++++++++++++++--
>  include/linux/file_ref.h     | 10 -------
>  9 files changed, 90 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/backing-file.c b/fs/backing-file.c
> index 45da8600d564..acabeea7efff 100644
> --- a/fs/backing-file.c
> +++ b/fs/backing-file.c
> @@ -11,6 +11,7 @@
>  #include <linux/fs.h>
>  #include <linux/backing-file.h>
>  #include <linux/splice.h>
> +#include <linux/uio.h>
>  #include <linux/mm.h>
>  
>  #include "internal.h"
> @@ -18,9 +19,10 @@
>  /**
>   * backing_file_open - open a backing file for kernel internal use
>   * @user_path:	path that the user reuqested to open
> + * @user_cred:	credentials that the user used for open
>   * @flags:	open flags
>   * @real_path:	path of the backing file
> - * @cred:	credentials for open
> + * @cred:	credentials for open of the backing file
>   *
>   * Open a backing file for a stackable filesystem (e.g., overlayfs).
>   * @user_path may be on the stackable filesystem and @real_path on the
> @@ -29,19 +31,19 @@
>   * returned file into a container structure that also stores the stacked
>   * file's path, which can be retrieved using backing_file_user_path().
>   */
> -struct file *backing_file_open(const struct path *user_path, int flags,
> +struct file *backing_file_open(const struct path *user_path,
> +			       const struct cred *user_cred, int flags,
>  			       const struct path *real_path,
>  			       const struct cred *cred)
>  {
>  	struct file *f;
>  	int error;
>  
> -	f = alloc_empty_backing_file(flags, cred);
> +	f = alloc_empty_backing_file(flags, cred, user_cred);
>  	if (IS_ERR(f))
>  		return f;
>  
> -	path_get(user_path);
> -	backing_file_set_user_path(f, user_path);
> +	backing_file_open_user_path(f, user_path);
>  	error = vfs_open(real_path, f);
>  	if (error) {
>  		fput(f);
> @@ -52,7 +54,8 @@ struct file *backing_file_open(const struct path *user_path, int flags,
>  }
>  EXPORT_SYMBOL_GPL(backing_file_open);
>  
> -struct file *backing_tmpfile_open(const struct path *user_path, int flags,
> +struct file *backing_tmpfile_open(const struct path *user_path,
> +				  const struct cred *user_cred, int flags,
>  				  const struct path *real_parentpath,
>  				  umode_t mode, const struct cred *cred)
>  {
> @@ -60,12 +63,11 @@ struct file *backing_tmpfile_open(const struct path *user_path, int flags,
>  	struct file *f;
>  	int error;
>  
> -	f = alloc_empty_backing_file(flags, cred);
> +	f = alloc_empty_backing_file(flags, cred, user_cred);
>  	if (IS_ERR(f))
>  		return f;
>  
> -	path_get(user_path);
> -	backing_file_set_user_path(f, user_path);
> +	backing_file_open_user_path(f, user_path);
>  	error = vfs_tmpfile(real_idmap, real_parentpath, f, mode);
>  	if (error) {
>  		fput(f);
> diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
> index 829d50d5c717..17a4941d4518 100644
> --- a/fs/erofs/ishare.c
> +++ b/fs/erofs/ishare.c
> @@ -106,15 +106,15 @@ static int erofs_ishare_file_open(struct inode *inode, struct file *file)
>  
>  	if (file->f_flags & O_DIRECT)
>  		return -EINVAL;
> -	realfile = alloc_empty_backing_file(O_RDONLY|O_NOATIME, current_cred());
> +	realfile = alloc_empty_backing_file(O_RDONLY|O_NOATIME, current_cred(),
> +					    file->f_cred);
>  	if (IS_ERR(realfile))
>  		return PTR_ERR(realfile);
>  	ihold(sharedinode);
>  	realfile->f_op = &erofs_file_fops;
>  	realfile->f_inode = sharedinode;
>  	realfile->f_mapping = sharedinode->i_mapping;
> -	path_get(&file->f_path);
> -	backing_file_set_user_path(realfile, &file->f_path);
> +	backing_file_open_user_path(realfile, &file->f_path);
>  
>  	file_ra_state_init(&realfile->f_ra, file->f_mapping);
>  	realfile->private_data = EROFS_I(inode);
> diff --git a/fs/file_table.c b/fs/file_table.c
> index aaa5faaace1e..b7dc94656c44 100644
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -27,6 +27,7 @@
>  #include <linux/task_work.h>
>  #include <linux/swap.h>
>  #include <linux/kmemleak.h>
> +#include <linux/backing-file.h>
>  
>  #include <linux/atomic.h>
>  
> @@ -43,11 +44,11 @@ static struct kmem_cache *bfilp_cachep __ro_after_init;
>  
>  static struct percpu_counter nr_files __cacheline_aligned_in_smp;
>  
> -/* Container for backing file with optional user path */
> +/* Container for backing file with optional user path file */
>  struct backing_file {
>  	struct file file;
>  	union {
> -		struct path user_path;
> +		struct file user_path_file;
>  		freeptr_t bf_freeptr;
>  	};
>  };
> @@ -56,24 +57,44 @@ struct backing_file {
>  
>  const struct path *backing_file_user_path(const struct file *f)
>  {
> -	return &backing_file(f)->user_path;
> +	return &backing_file(f)->user_path_file.f_path;
>  }
>  EXPORT_SYMBOL_GPL(backing_file_user_path);
>  
> -void backing_file_set_user_path(struct file *f, const struct path *path)
> +const struct file *backing_file_user_path_file(const struct file *f)
>  {
> -	backing_file(f)->user_path = *path;
> +	return &backing_file(f)->user_path_file;
> +}
> +EXPORT_SYMBOL_GPL(backing_file_user_path_file);
> +
> +void backing_file_open_user_path(struct file *f, const struct path *path)

I think this is a bad idea. This should return an error but still
WARN_ON(). Just make callers handle that error just like we do
everywhere else.

> +{
> +	/* open an O_PATH file to reference the user path - cannot fail */
> +	WARN_ON(vfs_open(path, &backing_file(f)->user_path_file));
> +}
> +EXPORT_SYMBOL_GPL(backing_file_open_user_path);
> +
> +static void destroy_file(struct file *f)
> +{
> +	security_file_free(f);
> +	put_cred(f->f_cred);

Note that calling destroy_file() in this way bypasses
security_file_release(). Presumably this doesn't matter because no LSM
does a security_alloc_file() for this but it adds a nother wrinkly into
the cleanup path.


>  }
> -EXPORT_SYMBOL_GPL(backing_file_set_user_path);
>  
>  static inline void file_free(struct file *f)
>  {
> -	security_file_free(f);
> +	destroy_file(f);
>  	if (likely(!(f->f_mode & FMODE_NOACCOUNT)))
>  		percpu_counter_dec(&nr_files);
> -	put_cred(f->f_cred);
>  	if (unlikely(f->f_mode & FMODE_BACKING)) {
> -		path_put(backing_file_user_path(f));
> +		struct file *user_path_file = &backing_file(f)->user_path_file;
> +
> +		/*
> +		 * no refcount on the user_path_file - they die together,
> +		 * so __fput() is not called for user_path_file. path_put()
> +		 * is the only relevant cleanup from __fput().
> +		 */
> +		destroy_file(user_path_file);
> +		path_put(&user_path_file->__f_path);
>  		kmem_cache_free(bfilp_cachep, backing_file(f));
>  	} else {
>  		kmem_cache_free(filp_cachep, f);
> @@ -201,7 +222,7 @@ static int init_file(struct file *f, int flags, const struct cred *cred)
>  	 * fget-rcu pattern users need to be able to handle spurious
>  	 * refcount bumps we should reinitialize the reused file first.
>  	 */
> -	file_ref_init(&f->f_ref, 1);
> +	atomic_long_set(&f->f_ref.refcnt, FILE_REF_ONEREF);

No, please don't open-code this. The point is to stop any open-access to
f_ref. And also below you introduce another atomic_long_set() open-coded
call as well. Simply adapt file_ref_init() to not do the -1 subtraction
and use the constants directly.

>  	return 0;
>  }
>  
> @@ -290,7 +311,8 @@ struct file *alloc_empty_file_noaccount(int flags, const struct cred *cred)
>   * This is only for kernel internal use, and the allocate file must not be
>   * installed into file tables or such.
>   */
> -struct file *alloc_empty_backing_file(int flags, const struct cred *cred)
> +struct file *alloc_empty_backing_file(int flags, const struct cred *cred,
> +				      const struct cred *user_cred)
>  {
>  	struct backing_file *ff;
>  	int error;
> @@ -305,6 +327,15 @@ struct file *alloc_empty_backing_file(int flags, const struct cred *cred)
>  		return ERR_PTR(error);
>  	}
>  
> +	error = init_file(&ff->user_path_file, O_PATH, user_cred);
> +	/* user_path_file is not refcounterd - it dies with the backing file */
> +	atomic_long_set(&ff->user_path_file.f_ref.refcnt, FILE_REF_DEAD);

Please massage this and send that patch. I'll stuff it into a stable vfs
branch that both Paul and I can merge. Paul can then send his PR.
