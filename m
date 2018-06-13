From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: [PATCH 14/39] ovl: stack file ops
Date: Wed, 13 Jun 2018 20:56:10 +0900
Message-ID: <5299.1528890970@jrobl>
References: <20180529144339.16538-1-mszeredi@redhat.com> <20180529144339.16538-15-mszeredi@redhat.com> <20180610041243.GJ30522@ZenIV.linux.org.uk> <CAJfpegtEGuBqmJ+6Kzd0456o0xyebe3LBk66xWQcuzsenqKVeg@mail.gmail.com> <20180612022926.GY30522@ZenIV.linux.org.uk> <20180612024029.GZ30522@ZenIV.linux.org.uk> <CAJfpegvUkcUw0GXxFesT6V2f27EXW7jkvBpvnG4XB49BPdvjjA@mail.gmail.com> <20180612182423.GA30522@ZenIV.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180612182423.GA30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-unionfs@vger.kernel.org

Al Viro:
> I'd managed to push that particular nest of horrors out of mind ;-/
> Having dug out my notes from back then and grepped around...  The real
> mess is not even /proc/*/maps - it's /proc/*/map_files/* and yes, the
> reasons for that kludge are still valid ;-/
	:::
> Uses of ->vm_file (and rules for those) are too convoluted to untangle
> at the moment.  I still would love to get that straightened out, but
> it's not this cycle fodder, more's the pity...

I don't fully read this thread, but the discussion is related to the
file path printed in /proc/$$/maps?  If so, as just for your
information, here is an approach that aufs took.

In linux-v2.6 era, aufs tried implementing mmap by customzing
address_space ops, but it was not good and failed completing the
implementation.
As wel as overlayfs, aufs has two struct file objects for a single
a regular file.  One is for a virtual aufs' entry, and the other is for
a real layer's entry.  When a user issues mmap(2) for the virtual file,
aufs redirects the request to the real file on the layer internally.  So
the vm_file points to the real file.  It means /proc/$$/maps prints the
unexpected file path.

Aufs added another struct file* vm_prfile in struct vma.  It points to
the virtual aufs file, and /proc/$$/maps prints vm_prfile instead of
vm_file. Of cource, maintaining vm_prfile is important since vma may be
merged or splitted.
Still I don't like this approach, but I don't have another better idea,
also it works for many years.  You can get the patch in
aufs4-standalone.git on sourceforge if you want.


J. R. Okajima
