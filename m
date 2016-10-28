From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Fri, 28 Oct 2016 17:15:34 +0100
Message-ID: <20161028161534.GM19539@ZenIV.linux.org.uk>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:39692 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756322AbcJ1QPh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 28 Oct 2016 12:15:37 -0400
Content-Disposition: inline
In-Reply-To: <1477380887-21333-4-git-send-email-mszeredi@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, Guillem Jover <guillem@debian.org>, Raphael Hertzog <hertzog@debian.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Oct 25, 2016 at 09:34:47AM +0200, Miklos Szeredi wrote:
> Current code returns EXDEV when a directory would need to be copied up to
> move.  We could copy up the directory tree in this case, but there's
> another solution: point to old lower directory from moved upper directory.
> 
> This is achieved with a "trusted.overlay.redirect" xattr storing the path
> relative to the root of the overlay.  After such attribute has been set,
> the directory can be moved without further actions required.
> 
> This is a backward incompatible feature, old kernels won't be able to
> correctly mount an overlay containing redirected directories.

> +			err = vfs_path_lookup(lowerpath.dentry, lowerpath.mnt,
> +					      redirect, 0, &thispath);
> +
> +			if (err) {
> +				if (err == -ENOENT || err == -ENAMETOOLONG)
> +					this = NULL;
> +			} else {
> +				this = thispath.dentry;
> +				mntput(thispath.mnt);
> +				if (!this->d_inode) {
> +					dput(this);
> +					this = NULL;
> +				} else if (ovl_dentry_weird(this)) {
> +					dput(this);
> +					err = -EREMOTE;
> +				}
> +			}

I'm not happy with that one - you are relying upon the fairly subtle
assertions here.
	1)  Had lowerpath.mnt *not* been a privately cloned one with nothing
mounted on it, you would've been screwed.
	2) Had that thing contained a "jumper" symlink (a-la procfs ones),
you would've been screwed.  Currently only procfs has those, and it would've
been rejected before getting there, but this is brittle and non-obvious.
	3) Any automount point in there (nfs4 referrals, etc.) can
break the assumption that nothing could've been mounted on it.  And _that_
might have not been stepped onto; back when the path had been stored, there'd
been no automount point at all, so we have avoided ovl_dentry_weird() rejects,
and by now nothing on the path had been visited yet, so ovl_dentry_weird()
didn't have a chance to trigger.  Note that calling it on the last dentry
is no good - we might have crossed the automount point in the middle of that
path, so this last dentry might be nice and shiny - and on another filesystem.
So unlike (1) and (2) it's not just a fishy-looking thing that happens to
work for non-local reasons; AFAICS, it's actually a bug.

I'm not sure if vfs_path_lookup() is the right tool here.  It might be
usable for making such a tool, but as it is you are setting one hell of
a trap for yourself...

It might be made to work, if we figure out the right semantics for disabling
symlinks on per-vfsmount basis (and no, the posted nolinks patches are not
it) and mark these private clones with that and with similar "disable
automount traversals" flag (again, needs the right semantics; the area is
convoluted as it is).  But in that case I would strongly recommend adding
an exported wrapper around vfs_path_lookup() that would verify that these
flags *are* set.
