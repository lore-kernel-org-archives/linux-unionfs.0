From: David Howells <dhowells@redhat.com>
Subject: Re: Can ovl_drop_write() be called earlier in ovl_dentry_open()
Date: Mon, 01 Jun 2015 16:45:03 +0100
Message-ID: <16823.1433173503@warthog.procyon.org.uk>
References: <CAJfpegsuVxOAGenfxeSsQEKZR+_+OfR6uOxm2USGvbAuCWRhvg@mail.gmail.com> <21902.1433166736@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegsuVxOAGenfxeSsQEKZR+_+OfR6uOxm2USGvbAuCWRhvg@mail.gmail.com>
Content-ID: <16822.1433173503.1@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> > In ovl_dentry_open(), ovl_drop_write() is called after vfs_open() - but is
> > this actually necessary?  Can't we just drop it post-copyup?  After all,
> > that's all we wanted the write lock for, right?
> 
> Hmm,  that could result in a race where remount r/o of upper fs comes
> in between copy-up and vfs_open() so copy-up succeeds but the actual
> open fails.  It's harmless, though, and not  very likely.  So I guess
> your patch is OK.

That race is there anyway if there's no copy up, right?

David
