From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: [PULL for 3.18] overlay filesystem v24
Date: Tue, 30 Sep 2014 13:54:39 +0900
Message-ID: <27645.1412052879@jrobl>
References: <20140929141457.GB5011@tucsk.piliscsaba.szeredi.hu> <26822.1412028003@warthog.procyon.org.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <26822.1412028003@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org


David Howells:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> > I'd like to propose overlayfs for inclusion into 3.18.
> > 
> > Al, would you mind giving it a review?
> > 
> > Git tree is here:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.current
>
> Tested-by: David Howells <dhowells@redhat.com>

Does it mean overlayfs passed all your unionmount-testsuite? And does
the test suite contain tests for "inode-based" union? For example,
- read(2) may get the obsoleted filedata (fstat(2) for metadata too).
- fcntl(F_SETLK) may be broken by copy-up.
- inotify may not work when it refers to the file before being
  copied-up.
- unnecessary copy-up may happen, for example mmap(MAP_PRIVATE) after
  open(O_RDWR).
- exporting via NFS and fhandle systemcalls will not work.

A few releases ago, OFD file-lock was introduced to improve the
behaviour of POSIX lock. POSIX lock has made users confused and I am
afraid that the similar story will come up because of the "name-based"
union behaviour. Of course the story is not limited to the file-lock.

If I remember correctly, are you the one who consitunes the development
of UnionMount? Is the development totally stopped?
Next paragraph is what I wrote several times.
	AUFS is an "inode-based" stackable filesystem and solved them many years
	ago. But I have to admit that AUFS is big. Yes it is grown up.
	I don't stop including overlayfs into mainline, but if the development
	of UnionMount is really stopped, then I'd ask people to consider merging
	aufs as well as overlayfs.

http://aufs.sf.net

J. R. Okajima
