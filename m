Return-Path: <vgoyal@redhat.com>
Date: Fri, 29 Mar 2019 11:40:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] ovl: relax WARN_ON() for overlapping layers use case
Message-ID: <20190329154020.GA4104@redhat.com>
References: <20190328153829.729-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328153829.729-1-amir73il@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 28, 2019 at 05:38:29PM +0200, Amir Goldstein wrote:
> This nasty little syzbot repro:
> https://syzkaller.appspot.com/x/repro.syz?x=12c7a94f400000
> 
> Creates overlay mounts where the same directory is both in upper
> and lower layers. Simplified example:
> 
>   mkdir foo work
>   mount -t overlay none foo -o"lowerdir=.,upperdir=foo,workdir=work"
> 
> The repro runs several threads in parallel that attempt to chdir
> into foo and attempt to symlink/rename/exec/mkdir the file bar.
> 
> The repro hits a WARN_ON() I placed in ovl_instantiate(), which
> suggests that an overlay inode already exists in cache and is hashed
> by the pointer of the real upper dentry that ovl_create_real() has
> just created. At the point of the WARN_ON(), for overlay dir inode
> lock is held and upper dir inode lock, so at first, I did not see how
> this was possible.
> 
> On a closer look, I see that after ovl_create_real(), because of the
> overlapping upper and lower layers, a lookup by another thread can
> find the file foo/bar that was just created in upper layer, at overlay
> path foo/foo/bar and hash the an overlay inode with the new real dentry
> as lower dentry. This is possible because the overlay directory
> foo/foo is not locked and the upper dentry foo/bar is in dcache, so
> ovl_lookup() can find it without taking upper dir inode shared lock.

Hi Amir,

Just to understand better this case, so does following fail.

ovl_verify_inode)() {
        if (upperdentry && ovl_inode_upper(inode) != d_inode(upperdentry))
                return false;
}

Because we already found hashed inode (as lower real file), so
ovl_inode_upper(inode) will not be set and ovl_verify_inode() will fail.

> 
> Overlapping layers is considered a wrong setup which would result in
> unexpected behavior, but it shouldn't crash the kernel and it shouldn't
> trigger WARN_ON() either, so relax this WARN_ON() and leave a pr_warn()
> instead to cover all cases of failure to get an overlay inode.

Is this not equivalent of lower layers being modified while overlay
being mounted. If that's the case, then WARN_ON_ONCE() kind of makes
sense to flag the anomaly in underlying layers?

IOW, overlayfs is not crashing. It is just warning for an anomaly it
found due to overlapping layers. And what's wrong with giving the
warning?

> 
> The error returned from failure to insert new inode to cache with
> inode_insert5() was changed to -EEXIST, to distinguish from the error
> -ENOMEM returned on failure to get/allocate inode with iget5_locked().

This is a separate cleanup and not related to this issue, do I
understand it right?

> 
> Reported-by: syzbot+9c69c282adc4edd2b540@syzkaller.appspotmail.com
> Fixes: 01b39dcc9568 ("ovl: use inode_insert5() to hash a newly...")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/dir.c   | 2 +-
>  fs/overlayfs/inode.c | 3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 82c129bfe58d..93872bb50230 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -260,7 +260,7 @@ static int ovl_instantiate(struct dentry *dentry, struct inode *inode,
>  		 * hashed directory inode aliases.
>  		 */
>  		inode = ovl_get_inode(dentry->d_sb, &oip);
> -		if (WARN_ON(IS_ERR(inode)))
> +		if (IS_ERR(inode))
>  			return PTR_ERR(inode);
>  	} else {
>  		WARN_ON(ovl_inode_real(inode) != d_inode(newdentry));
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 3b7ed5d2279c..b48273e846ad 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -832,7 +832,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
>  	int fsid = bylower ? oip->lowerpath->layer->fsid : 0;
>  	bool is_dir, metacopy = false;
>  	unsigned long ino = 0;
> -	int err = -ENOMEM;
> +	int err = oip->newinode ? -EEXIST : -ENOMEM;
>  
>  	if (!realinode)
>  		realinode = d_inode(lowerdentry);
> @@ -917,6 +917,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
>  	return inode;
>  
>  out_err:
> +	pr_warn_ratelimited("overlayfs: failed to get inode (%i)\n", err);
>  	inode = ERR_PTR(err);
>  	goto out;
>  }
> -- 
> 2.17.1
> 
