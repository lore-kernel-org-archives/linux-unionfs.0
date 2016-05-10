From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT PULL] overlayfs fixes for 4.6-rc7
Date: Tue, 10 May 2016 16:27:05 +0100
Message-ID: <20160510152704.GK2694@ZenIV.linux.org.uk>
References: <20160503200403.GB10623@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160503200403.GB10623@veci.piliscsaba.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 03, 2016 at 10:04:03PM +0200, Miklos Szeredi wrote:
> Hi Al,
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next
> 
> This fixes two issues with overlayfs.
> 
> Thanks,
> Miklos
> 
> ---
> Miklos Szeredi (3):
>       vfs: rename: check backing inode being equal
>       vfs: export lookup_hash() to modules
>       ovl: ignore permissions on underlying lookup

	NAK on lookup_hash().  If nothing else, you need either
lookup_one_len_unlocked() or its "we already know hash" variant (assuming it's
worth bothering with).  That locking the parent is potentially a lot costlier
than recalculating the (default) hash function.  Especially in -next, where
lookup_one_len_unlocked() will take the lock shared if it has to take it at
all, but the mainline one also has a good chance to avoid taking the lock.
