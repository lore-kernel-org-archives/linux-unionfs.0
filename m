From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] overlayfs update for 4.18
Date: Sun, 10 Jun 2018 23:09:50 -0700
Message-ID: <20180611060950.GA8048@infradead.org>
References: <20180608121330.GG23785@veci.piliscsaba.redhat.com>
 <20180609065208.GA31572@infradead.org>
 <CA+55aFxkUYXHNT+GtUFMSSdnNgYBoQu1tvxiWYNrwTJCLbi_rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxkUYXHNT+GtUFMSSdnNgYBoQu1tvxiWYNrwTJCLbi_rw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-unionfs@vger.kernel.org

On Sat, Jun 09, 2018 at 02:42:20PM -0700, Linus Torvalds wrote:
> And Christoph's copmmentary isn't really helping the situation.
> Christoph, I haven't seen the NAK history, can you elaborate?

Most of the bits just need a bit of refinement I think, instead of
being forced through the overlayfs tree and are generally fine.

The pre_mmap hook I think is a clear no-go.  We've had this tried
multiple times and always rejected it.  Unlike previous uses the
overlayfs use isn't outright broken, but still questionalable
as it will still lead to a copyup that "leaks" if the actual mmap
wasn't successfull.  The whole discussion of how mmap happens,
how we deal with mmap_sem and failures needs a broader discussion
with all MM and VFS folks first.
