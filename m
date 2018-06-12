From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 14/39] ovl: stack file ops
Date: Tue, 12 Jun 2018 03:29:26 +0100
Message-ID: <20180612022926.GY30522@ZenIV.linux.org.uk>
References: <20180529144339.16538-1-mszeredi@redhat.com>
 <20180529144339.16538-15-mszeredi@redhat.com>
 <20180610041243.GJ30522@ZenIV.linux.org.uk>
 <CAJfpegtEGuBqmJ+6Kzd0456o0xyebe3LBk66xWQcuzsenqKVeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJfpegtEGuBqmJ+6Kzd0456o0xyebe3LBk66xWQcuzsenqKVeg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jun 11, 2018 at 09:09:04AM +0200, Miklos Szeredi wrote:

[context: opening files in layers with unholy mix of overlayfs
->f_path and layer's ->f_inode/->f_op]

> I'd really like to get there some time but...
> 
> List of basic requirements:
> 
>  - Private mmap of overlay file shares page cache with lower file (and
> hence with all other overlays using the same lower file).
> 
>  - /proc/PID/maps shows correct path.
> 
> Thought about setting f_mapping/i_mapping of overlay file to that of
> underlying file.  But that breaks when doing a copy-up.  We can't just
> go and change those mapping pointers, assumption is that those remain
> constant (we'd need READ_ONCE() for all cases where we use the mapping
> more than once).  It's probably doable, but it's a large and fragile
> change.

We are really asking for trouble here - anything with e.g. ->read_iter()
using dentry will get in trouble with that kind of games.  Consider something
like

foo_read_iter(struct kiocb *iocb, struct iov_iter *to)
{
	struct file *file = iocb->ki_filp;
	struct foo_data *p = file->f_path.dentry->d_fsdata;
	...
}

which will work just fine for files on foofs, where we have ->d_fsdata set
on lookup.  Now, try to use foofs as a layer; suddenly, you get foofs
files with ->f_path.dentry being *overlayfs* dentry, with ->d_fsdata
being nothing like struct foo_data *.

Better yet, consider

foo_open(struct inode *inode, struct file *file)
{
	struct dentry *dentry = file->f_path.dentry;
	...
	foo_add_splat(dentry, splat);
	...
}
where foo_add_splat() inserts struct foo_splat into an hlist starting
in dentry->d_fsdata.  That's not a pure theory - we *do* have ->open()
instances doing things of that sort.  That'll bugger overlayfs quite
badly, not to mention that foofs methods won't be happy with overlayfs
dentries.

It might (or might not) work for the filesystems you'd been testing
on, but it's a lot of trouble waiting to happen.  Hell, try and use
ecryptfs as lower layer, see how fast it'll blow up.  Sure, it's
a dumb testcase, but I don't see how to check if something more
realistic is trouble-free.

I'd been trying to come up with some way to salvage that kludge of yours,
but I don't see any solutions.  We don't have good proxies for "this
filesystem might be unsafe as lower layer" ;-/

Frankly, it might be saner and safer to teach procfs (and similar
places) to do more than just use ->vm_file->f_path.  _That_ at least
is much more local in impact.
