From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/8] Security: Provide unioned file support
Date: Fri, 19 Jun 2015 09:29:28 +0100
Message-ID: <20150619082928.GJ17109@ZenIV.linux.org.uk>
References: <20150618133215.12722.70352.stgit@warthog.procyon.org.uk>
 <20150619072015.GH17109@ZenIV.linux.org.uk>
 <CAJfpeguZq-1C_hnCcyrW3MCcpP4Bwe+L4gpWaOeJCqa1q8j4Hg@mail.gmail.com>
 <20150619075903.GI17109@ZenIV.linux.org.uk>
 <20150619081128.GA24181@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:53493 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164AbbFSI3e (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 19 Jun 2015 04:29:34 -0400
Content-Disposition: inline
In-Reply-To: <20150619081128.GA24181@tucsk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: David Howells <dhowells@redhat.com>, sds@tycho.nsa.gov, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, linux-security-module@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>

On Fri, Jun 19, 2015 at 10:11:28AM +0200, Miklos Szeredi wrote:
>  drivers/staging/lustre/lustre/llite/file.c |   12 ++++++------
>  fs/9p/vfs_file.c                           |    6 +++---
>  fs/btrfs/file.c                            |    2 +-
>  fs/btrfs/ioctl.c                           |   13 +++++++------
>  fs/ceph/dir.c                              |    6 +++---
>  fs/ceph/file.c                             |    2 +-
>  fs/cifs/file.c                             |    4 ++--
>  fs/cifs/readdir.c                          |    4 ++--
>  fs/configfs/dir.c                          |    8 ++++----
>  fs/configfs/file.c                         |   15 +++++++++------
>  fs/fat/file.c                              |    7 ++++---
>  fs/fuse/dir.c                              |    2 +-
>  fs/hfsplus/ioctl.c                         |    2 +-
>  fs/hostfs/hostfs_kern.c                    |    4 ++--
>  fs/hppfs/hppfs.c                           |    4 ++--
>  fs/kernfs/dir.c                            |    2 +-
>  fs/kernfs/file.c                           |    6 +++---
>  fs/libfs.c                                 |    6 +++---
>  fs/ncpfs/dir.c                             |    4 ++--
>  fs/nfs/dir.c                               |    6 +++---
>  fs/nfs/inode.c                             |    2 +-
>  fs/nfs/nfs4file.c                          |    4 ++--
>  fs/overlayfs/readdir.c                     |   10 +++++-----
>  fs/proc/base.c                             |    6 +++---
>  fs/proc/proc_sysctl.c                      |    2 +-
>  include/linux/fs.h                         |    5 +++++
>  26 files changed, 77 insertions(+), 67 deletions(-)
> 
> --- a/fs/9p/vfs_file.c
> +++ b/fs/9p/vfs_file.c
> @@ -74,7 +74,7 @@ int v9fs_file_open(struct inode *inode,
>  					v9fs_proto_dotu(v9ses));
>  	fid = file->private_data;
>  	if (!fid) {
> -		fid = v9fs_fid_clone(file->f_path.dentry);
> +		fid = v9fs_fid_clone(file_dentry(file));
>  		if (IS_ERR(fid))
>  			return PTR_ERR(fid);
>  
> @@ -100,7 +100,7 @@ int v9fs_file_open(struct inode *inode,
>  		 * because we want write after unlink usecase
>  		 * to work.
>  		 */
> -		fid = v9fs_writeback_fid(file->f_path.dentry);
> +		fid = v9fs_writeback_fid(file_dentry(file));
>  		if (IS_ERR(fid)) {
>  			err = PTR_ERR(fid);
>  			mutex_unlock(&v9inode->v_mutex);
> @@ -515,7 +515,7 @@ v9fs_mmap_file_mmap(struct file *filp, s
>  		 * because we want write after unlink usecase
>  		 * to work.
>  		 */
> -		fid = v9fs_writeback_fid(filp->f_path.dentry);
> +		fid = v9fs_writeback_fid(file_dentry(filp));
>  		if (IS_ERR(fid)) {
>  			retval = PTR_ERR(fid);
>  			mutex_unlock(&v9inode->v_mutex);
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1861,7 +1861,7 @@ static int start_ordered_ops(struct inod
>   */
>  int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  {
> -	struct dentry *dentry = file->f_path.dentry;
> +	struct dentry *dentry = file_dentry(file);
>  	struct inode *inode = d_inode(dentry);

	file_inode(file), please.  And looking at the only other use
of dentry in there...  I don't see anything that would guarantee that
dentry will remain the child of its parent, which btrfs_log_dentry_safe()
seems to assume.

> +static noinline int btrfs_mksubvol(struct file *file,
>  				   char *name, int namelen,
>  				   struct btrfs_root *snap_src,
>  				   u64 *async_transid, bool readonly,
>  				   struct btrfs_qgroup_inherit *inherit)
>  {
> -	struct inode *dir  = d_inode(parent->dentry);
> +	struct dentry *parent = file_dentry(file);
> +	struct inode *dir  = d_inode(parent);

Directory, probably?

> -	dentry = lookup_one_len(name, parent->dentry, namelen);
> +	dentry = lookup_one_len(name, parent, namelen);

... it would better be one.

> @@ -121,7 +121,7 @@ static int __dcache_readdir(struct file
>  			    u32 shared_gen)
>  {
>  	struct ceph_file_info *fi = file->private_data;
> -	struct dentry *parent = file->f_path.dentry;
> +	struct dentry *parent = file_dentry(file);

Directory.  And I would be very surprised if ceph + overlayfs wouldn't
step into some rather nasty things...

>  static int configfs_dir_open(struct inode *inode, struct file *file)
>  {
> -	struct dentry * dentry = file->f_path.dentry;
> +	struct dentry *dentry = file_dentry(file);

Directory, and combination of configfs with overlayfs is *definitely*
a bad idea.

> --- a/fs/fat/file.c
> +++ b/fs/fat/file.c

Unusable with overlayfs due to ->d_hash() issues.

> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -1165,7 +1165,7 @@ static int fuse_direntplus_link(struct f
>  	int err;
>  	struct fuse_entry_out *o = &direntplus->entry_out;
>  	struct fuse_dirent *dirent = &direntplus->dirent;
> -	struct dentry *parent = file->f_path.dentry;
> +	struct dentry *parent = file_dentry(file);

Directory.

> --- a/fs/hfsplus/ioctl.c
> +++ b/fs/hfsplus/ioctl.c

->d_hash()

> --- a/fs/hostfs/hostfs_kern.c
> +++ b/fs/hostfs/hostfs_kern.c
> @@ -284,7 +284,7 @@ static int hostfs_readdir(struct file *f
>  	int error, len;
>  	unsigned int type;
>  
> -	name = dentry_name(file->f_path.dentry);
> +	name = dentry_name(file_dentry(file));

Directory

> --- a/fs/hppfs/hppfs.c
> +++ b/fs/hppfs/hppfs.c

git rm fodder.

> --- a/fs/kernfs/dir.c
> +++ b/fs/kernfs/dir.c

Are you seriously going to allow that as overlayfs layer?

> --- a/fs/ncpfs/dir.c
> +++ b/fs/ncpfs/dir.c
> @@ -417,7 +417,7 @@ ncp_invalidate_dircache_entries(struct d
>  
>  static int ncp_readdir(struct file *file, struct dir_context *ctx)
>  {

Directory (and case sensitivity issues on top of that).

> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -78,7 +78,7 @@ int dcache_dir_open(struct inode *inode,
>  {
>  	static struct qstr cursor_name = QSTR_INIT(".", 1);
>  
> -	file->private_data = d_alloc(file->f_path.dentry, &cursor_name);
> +	file->private_data = d_alloc(file_dentry(file), &cursor_name);

Directory.

... and so on
