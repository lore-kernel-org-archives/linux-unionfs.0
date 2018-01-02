From: "J . Bruce Fields" <bfields@fieldses.org>
Subject: Re: [RFC][PATCH 2/2] vfs: update overlay inode times on
 lease_get_mtime()
Date: Tue, 2 Jan 2018 17:54:37 -0500
Message-ID: <20180102225437.GA1781@fieldses.org>
References: <1514896009-11468-1-git-send-email-amir73il@gmail.com>
 <1514896009-11468-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:44670 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750745AbeABWyh (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 2 Jan 2018 17:54:37 -0500
Content-Disposition: inline
In-Reply-To: <1514896009-11468-3-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Jan 02, 2018 at 02:26:49PM +0200, Amir Goldstein wrote:
> Instead of looking for all the places that update inode's m_time,
> update overlay inode i_mtime just before nfsd needs to read it.
> 
> The non uptodate mtime issue was found and verified with the
> nfstest_posix test when run over NFS exported overlayfs:
> 
>  $ nfstest_posix --runtest=link,write
>  ...
>  FAIL: link - parent directory st_mtime should be updated
>  FAIL: write - file st_mtime should be updated

Grepping for users of i_mtime in fs/nfsd/....

Looks like we might need something similar for fill_pre_wcc() ?  (And
maybe nfsd4_block_commit_blocks() ?)

I don't think it's necessary for do_nfsd_create(), but it should be
harmless if we want to just make it a rule that nfsd shouldn't be
accessing i_mtime directly.

--b.

> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/inode.c    | 10 ++++++++--
>  fs/internal.h |  1 +
>  fs/locks.c    | 12 +++++++++++-
>  3 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index a252256f4e51..ceb5f5cb9c79 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1595,6 +1595,14 @@ static void update_ovl_d_inode_times(struct dentry *dentry, bool rcu)
>  	}
>  }
>  
> +void update_ovl_inode_times(struct inode *inode)
> +{
> +	struct dentry *alias = d_find_any_alias(inode);
> +
> +	if (alias)
> +		update_ovl_d_inode_times(alias, false);
> +}
> +
>  /*
>   * With relative atime, only update atime if the previous atime is
>   * earlier than either the ctime or mtime or if at least a day has
> @@ -1877,8 +1885,6 @@ int file_update_time(struct file *file)
>  	ret = update_time(inode, &now, sync_it);
>  	__mnt_drop_write_file(file);
>  
> -	update_ovl_d_inode_times(file->f_path.dentry, false);
> -
>  	return ret;
>  }
>  EXPORT_SYMBOL(file_update_time);
> diff --git a/fs/internal.h b/fs/internal.h
> index df262f41a0ef..a631fd49a1ee 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -122,6 +122,7 @@ extern long prune_icache_sb(struct super_block *sb, struct shrink_control *sc);
>  extern void inode_add_lru(struct inode *inode);
>  extern int dentry_needs_remove_privs(struct dentry *dentry);
>  
> +extern void update_ovl_inode_times(struct inode *inode);
>  extern bool __atime_needs_update(const struct path *, struct inode *, bool);
>  static inline bool atime_needs_update_rcu(const struct path *path,
>  					  struct inode *inode)
> diff --git a/fs/locks.c b/fs/locks.c
> index 21b4dfa289ee..e2f604839aaf 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -127,6 +127,7 @@
>  #include <linux/pid_namespace.h>
>  #include <linux/hashtable.h>
>  #include <linux/percpu.h>
> +#include "internal.h"
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/filelock.h>
> @@ -1553,6 +1554,15 @@ int __break_lease(struct inode *inode, unsigned int mode, unsigned int type)
>  
>  EXPORT_SYMBOL(__break_lease);
>  
> +static struct timespec inode_mtime(struct inode *inode)
> +{
> +	/* TODO: use another SB_ flag and/or pass dentry to lease_get_mtime() */
> +	if (unlikely(inode->i_sb->s_flags & MS_NOREMOTELOCK))
> +		update_ovl_inode_times(inode);
> +
> +	return inode->i_mtime;
> +}
> +
>  /**
>   *	lease_get_mtime - get the last modified time of an inode
>   *	@inode: the inode
> @@ -1581,7 +1591,7 @@ void lease_get_mtime(struct inode *inode, struct timespec *time)
>  	if (has_lease)
>  		*time = current_time(inode);
>  	else
> -		*time = inode->i_mtime;
> +		*time = inode_mtime(inode);
>  }
>  
>  EXPORT_SYMBOL(lease_get_mtime);
> -- 
> 2.7.4
