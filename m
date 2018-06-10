From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 14/39] ovl: stack file ops
Date: Sun, 10 Jun 2018 05:13:00 +0100
Message-ID: <20180610041243.GJ30522@ZenIV.linux.org.uk>
References: <20180529144339.16538-1-mszeredi@redhat.com>
 <20180529144339.16538-15-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529144339.16538-15-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 29, 2018 at 04:43:14PM +0200, Miklos Szeredi wrote:
> Implement file operations on a regular overlay file.  The underlying file
> is opened separately and cached in ->private_data.
> 
> It might be worth making an exception for such files when accounting in
> nr_file to confirm to userspace expectations.  We are only adding a small
> overhead (248bytes for the struct file) since the real inode and dentry are
> pinned by overlayfs anyway.
> 
> This patch doesn't have any effect, since the vfs will use d_real() to find
> the real underlying file to open.  The patch at the end of the series will
> actually enable this functionality.

> +static struct file *ovl_open_realfile(const struct file *file)
> +{
> +	struct inode *inode = file_inode(file);
> +	struct inode *upperinode = ovl_inode_upper(inode);
> +	struct inode *realinode = upperinode ?: ovl_inode_lower(inode);
> +	struct file *realfile;
> +	const struct cred *old_cred;
> +
> +	old_cred = ovl_override_creds(inode->i_sb);
> +	realfile = path_open(&file->f_path, file->f_flags | O_NOATIME,
> +			     realinode, current_cred(), false);
> +	revert_creds(old_cred);
> +
> +	pr_debug("open(%p[%pD2/%c], 0%o) -> (%p, 0%o)\n",
> +		 file, file, upperinode ? 'u' : 'l', file->f_flags,
> +		 realfile, IS_ERR(realfile) ? 0 : realfile->f_flags);
> +
> +	return realfile;
> +}

IDGI.  OK, you open a file in the layer you want; good, but why the hell do you
*not* use the dentry/vfsmount from the same layer?

IOW, why does your path_open() get an explicit inode argument at all?  With the
rest of the work done in that series it looks like you should be able to use
vfs_open() instead...  Sure, for ovlfs file you want ->f_path on overlayfs and
not in a layer, but why do the same for those?

And why bother with override_creds at all?  What's wrong with simply passing
->creator_cred to path_open()/vfs_open()/whatnot?
