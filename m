From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC][PATCH 1/2] vfs: update overlay inode times on write
Date: Tue, 2 Jan 2018 11:51:01 -0500
Message-ID: <20180102165101.GC15274@redhat.com>
References: <1514896009-11468-1-git-send-email-amir73il@gmail.com>
 <1514896009-11468-2-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46148 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751097AbeABQvD (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 2 Jan 2018 11:51:03 -0500
Content-Disposition: inline
In-Reply-To: <1514896009-11468-2-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Jan 02, 2018 at 02:26:48PM +0200, Amir Goldstein wrote:
> Currently with overlayfs, the real upper inode's i_mtime is updated on
> write, but not overlay vfs inode. The vfs inode's i_mtime is used by nfsd
> to check if nfs client cache is stale, so updating the overlay vfs inode
> i_mtime on write is required for overlayfs NFS export support.
> 
> The non uptodate mtime issue was found and verified with the
> nfstest_posix test when run over NFS exported overlayfs:
> 
>  $ nfstest_posix --runtest=write
>  ...
>  FAIL: write - file st_mtime should be updated
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/inode.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 03102d6ef044..a252256f4e51 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1567,8 +1567,7 @@ EXPORT_SYMBOL(bmap);
>  /*
>   * Update times in overlayed inode from underlying real inode
>   */
> -static void update_ovl_inode_times(struct dentry *dentry, struct inode *inode,
> -			       bool rcu)
> +static void update_ovl_d_inode_times(struct dentry *dentry, bool rcu)
>  {
>  	struct dentry *upperdentry;
>  
> @@ -1585,6 +1584,7 @@ static void update_ovl_inode_times(struct dentry *dentry, struct inode *inode,
>  	 * stale mtime/ctime.
>  	 */
>  	if (upperdentry) {
> +		struct inode *inode = d_inode(dentry);
>  		struct inode *realinode = d_inode(upperdentry);
>  
>  		if ((!timespec_equal(&inode->i_mtime, &realinode->i_mtime) ||
> @@ -1607,7 +1607,8 @@ static int relatime_need_update(const struct path *path, struct inode *inode,
>  	if (!(path->mnt->mnt_flags & MNT_RELATIME))
>  		return 1;
>  
> -	update_ovl_inode_times(path->dentry, inode, rcu);
> +	update_ovl_d_inode_times(path->dentry, rcu);
> +

Hi Amir,

If we update overlay inode mtime, ctime in write path, then do we still
need this call in relatime_need_update() path? I mean what other path
is there where real inode mtime/ctime will be out of sync with overlay
inode mtime/ctime.

Vivek

>  	/*
>  	 * Is mtime younger than atime? If yes, update atime:
>  	 */
> @@ -1876,6 +1877,8 @@ int file_update_time(struct file *file)
>  	ret = update_time(inode, &now, sync_it);
>  	__mnt_drop_write_file(file);
>  
> +	update_ovl_d_inode_times(file->f_path.dentry, false);
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL(file_update_time);
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
