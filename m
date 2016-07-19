From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [RFC PATCH] locks: fix file locking on overlayfs
Date: Tue, 19 Jul 2016 11:36:02 -0400
Message-ID: <20160719153602.GB3335@fieldses.org>
References: <1468931264-25837-1-git-send-email-mszeredi@redhat.com>
 <20160719140114.GA3335@fieldses.org>
 <CAOssrKdrSbS8=BO2rLPEOip8Cg3NgNbCGX6s_J933hRKYBEEfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOssrKdrSbS8=BO2rLPEOip8Cg3NgNbCGX6s_J933hRKYBEEfg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jul 19, 2016 at 04:46:14PM +0200, Miklos Szeredi wrote:
> On Tue, Jul 19, 2016 at 4:01 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> > On Tue, Jul 19, 2016 at 02:27:44PM +0200, Miklos Szeredi wrote:
> >> This patch allows flock, posix locks, ofd locks and leases to work
> >> correctly on overlayfs.
> >>
> >> Instead of using the underlying inode for storing lock context use the
> >> overlay inode.  This allows locks to be persistent across copy-up.
> >
> > Remind me when the overlay inode is created--is it immediately on any
> > (even read-only) open?
> 
> So basically overlay has three types of inodes:  lower, upper (these
> are called underlying or real inodes) and overlay inode.
> 
> Overlay inode is created on lookup, just like any other filesystem.
> Overlayfs's own lookup then it proceeds to look up underlying dentry
> and stores ref in the overlay dentry.
> 
> Copy-up happens on read-write open (or other modifying operation),
> which creates inode on upper and copies data/metadata from lower inode
> to upper inode.

Thanks for the explanation. So, if I understand correctly:

Locking should look completely normal as long as all locking is done
through the overlay.

Locks may fail to conflict when expected if one of the overlayed layers
is accessed elsewhere somehow--but that's a reasonably easy rule to
document, and consistent with other overlayfs behavior.

--b.
