From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT PULL] overlayfs update for 4.18
Date: Sun, 10 Jun 2018 06:54:38 +0100
Message-ID: <20180610055326.GR30522@ZenIV.linux.org.uk>
References: <20180608121330.GG23785@veci.piliscsaba.redhat.com>
 <20180609065208.GA31572@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180609065208.GA31572@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Fri, Jun 08, 2018 at 11:52:08PM -0700, Christoph Hellwig wrote:
> On Fri, Jun 08, 2018 at 02:13:30PM +0200, Miklos Szeredi wrote:
> > Hi Linus,
> > 
> > Please pull from:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-update-4.18
> > 
> > This contains two new features:
> > 
> >  1) Stack file operations: this allows removal of several hacks from the
> >     VFS, proper interaction of read-only open files with copy-up,
> >     possibility to implement fs modifying ioctls properly, and others.
> 
> Which includews all kinds of NAKed or at least non-acked VFS changes.

Umm...  The worst of yours had been ->pre_mmap(), right?  He *did* drop that...

> Please get these through Als tree after proper review first.

OK, summary of sort (see fsdevel thread for details):
	* path_open() is dubious; why not simply use vfsmount/dentry from the
right layer when opening an underlying file?  Then it would be vfs_open()...
	* ovl_mmap() is broken, plain and simple.  Failure ends up leaking
a layer struct file *and* doing double fput() on overlayfs one.
	* ovl_mmap() is also trivially DoSable - you can trigger tons and tons
of reopens, each sticking a new (writable layer) struct file into a vma.
We *do* want some scheme avoiding once-per-operations reopens in the
copied-up-after-r/o-open case.  See possible kinda-sorta solution on fsdevel;
I'm not sure I like it, though.

The rest is pretty minor.
