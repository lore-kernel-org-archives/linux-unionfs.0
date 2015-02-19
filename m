From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT PULL] multi-layer support for overlay filesystem
Date: Thu, 19 Feb 2015 07:42:04 +0000
Message-ID: <20150219074203.GR29656@ZenIV.linux.org.uk>
References: <20150211093039.GA6817@tucsk.suse.de>
 <20150218105903.GA5986@tucsk.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150218105903.GA5986@tucsk.suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Feb 18, 2015 at 11:59:03AM +0100, Miklos Szeredi wrote:
> On Wed, Feb 11, 2015 at 10:30:39AM +0100, Miklos Szeredi wrote:
> > Al,
> > 
> > Please pull from
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next
> > 
> > This adds support for multiple read-only layers to overlayfs.  It also makes the
> > writable upper layer optional.
> > 
> > This is a highly requested feature and has been in -next for the last cycle.
> 
> Ping.

Pong.  I'm still looking through a large pile of assorted stuff, that pull
request sitting in the queue.  Should be done with that tomorrow (as in "pull
or reply with last-minute-found $SOMETHING_DIRE"; FWIW, the last time I looked
at multilayer stuff was a couple of weeks ago and nothing dire had been spotted,
so the former is more likely).

ObSomethingDire^H^H^H^HOddElsewhere: what happens if libfuse
fuse_lowlevel_notify_store() is called with SPLICE_F_MOVE in flags on an
inode that happens to be mmaped with MAP_SHARED?  Cache coherency isn't the
main concern; I'm looking at
        /*
         * This is a new and locked page, it shouldn't be mapped or
         * have any special flags on it
         */
        if (WARN_ON(page_mapped(oldpage)))
                goto out_fallback_unlock;
        if (WARN_ON(page_has_private(oldpage)))
                goto out_fallback_unlock;
        if (WARN_ON(PageDirty(oldpage) || PageWriteback(oldpage)))
                goto out_fallback_unlock;
        if (WARN_ON(PageMlocked(oldpage)))
                goto out_fallback_unlock;
in fuse_try_move_page() and I don't see anything to prevent those
WARN_ON getting triggered in that case.  The call chain is
fuse_try_move_page() <- fuse_copy_page() <- fuse_notify_store() <-
fuse_notify() <- fuse_dev_do_write() <- fuse_dev_splice_write(),
oldpage is obtained by
                page = find_or_create_page(mapping, index,
                                           mapping_gfp_mask(mapping));
in the loop in fuse_notify_store() and that ought to be able to pick
the pages present in MAP_SHARED mappings...

What am I missing here?  FWIW, I'd been trying to resurrect SPLICE_F_MOVE
for local filesystems, and with FUSE being the only place in the kernel
still trying to support it...
