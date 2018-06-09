From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] overlayfs update for 4.18
Date: Sat, 9 Jun 2018 14:42:20 -0700
Message-ID: <CA+55aFxkUYXHNT+GtUFMSSdnNgYBoQu1tvxiWYNrwTJCLbi_rw@mail.gmail.com>
References: <20180608121330.GG23785@veci.piliscsaba.redhat.com> <20180609065208.GA31572@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180609065208.GA31572@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-unionfs@vger.kernel.org

Hmm.

So I had held off on pulling this in the hope that it would get more comments.

I like most of the vfs-level stuff - it gets rid of some of the
hackery we had for overlayfs.

It does add some new hackery to replace it (like the file accounting), though.

And Christoph's copmmentary isn't really helping the situation.
Christoph, I haven't seen the NAK history, can you elaborate?

And Al, can you please take a look?

               Linus

On Fri, Jun 8, 2018 at 11:52 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> > This contains two new features:
> >
> >  1) Stack file operations: this allows removal of several hacks from the
> >     VFS, proper interaction of read-only open files with copy-up,
> >     possibility to implement fs modifying ioctls properly, and others.
>
> Which includews all kinds of NAKed or at least non-acked VFS changes.
>
> Please get these through Als tree after proper review first.
