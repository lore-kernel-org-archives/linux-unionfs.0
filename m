From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT PULL] overlayfs update for 4.18
Date: Sun, 10 Jun 2018 00:55:44 +0100
Message-ID: <20180609235544.GI30522@ZenIV.linux.org.uk>
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
Cc: Christoph Hellwig <hch@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Sat, Jun 09, 2018 at 02:42:20PM -0700, Linus Torvalds wrote:
> Hmm.
> 
> So I had held off on pulling this in the hope that it would get more comments.
> 
> I like most of the vfs-level stuff - it gets rid of some of the
> hackery we had for overlayfs.
> 
> It does add some new hackery to replace it (like the file accounting), though.
> 
> And Christoph's copmmentary isn't really helping the situation.
> Christoph, I haven't seen the NAK history, can you elaborate?
> 
> And Al, can you please take a look?

Will post tonight...
