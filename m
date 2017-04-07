From: Jeff Layton <jlayton@poochiereds.net>
Subject: Re: overlayfs NFS export
Date: Fri, 07 Apr 2017 10:53:57 -0400
Message-ID: <1491576837.2745.19.camel@poochiereds.net>
References: <CAOQ4uxhpKFhksVJTgWyy5YRzunLiQjf9TTgFO_EfBSdWvBfxWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:35065 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933650AbdDGOyB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Apr 2017 10:54:01 -0400
Received: by mail-qt0-f179.google.com with SMTP id x35so62603167qtc.2
        for <linux-unionfs@vger.kernel.org>; Fri, 07 Apr 2017 07:54:01 -0700 (PDT)
In-Reply-To: <CAOQ4uxhpKFhksVJTgWyy5YRzunLiQjf9TTgFO_EfBSdWvBfxWg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, "J. Bruce Fields" <bfields@fieldses.org>, Trond Myklebust <trond.myklebust@primarydata.com>

On Fri, 2017-04-07 at 17:29 +0300, Amir Goldstein wrote:
> [changing the subject and adding more NFS guys so they can shoot my
> idea down if it is too dumb to live]
> 
> On Fri, Apr 7, 2017 at 4:03 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > On Fri, Apr 7, 2017 at 12:47 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > 
> > > Come to think about it, NFS export of regular file don't need to
> > > follow renames at all:
> > > - The handle for a regular file is always the handle for the real
> > > lower or upper inode
> > > - To decode a handle, create an O_TMPFILE style overlay dentry, which
> > > is not linked
> > >   to any path in overlay, but has the _upperdentry/lowerstack setup
> > 
> > I don't think nfs will allow such a scheme.  NFS3 server is stateless,
> > which means there's no open/close in the protocol.   Hence we can't
> > copy-up on open(O_WR*) and return a different file handle for writing.
> > If client looks up a file currently on lower and we return file handle
> > based on lower file, then we must be able to decode that handle after
> > the file has been copied up and even after rename.  And this must work
> > reliably even if the overlay dentry is no longer in the dcache.
> > 
> > So there's no option, other than to have a reverse mapping somewhere.
> > 
> 
> Either I am missing something or you are.
> 
> Consider this scenario:
> 
> On server:
> - touch a
> - ln a b
> 
> On NFS client:
> - rofd = open("a", O_RDONLY)
> 
> On server
> - rm a
> - reboot
> 
> NFS client must be able to continue to work with rofd
> even after reboot and even after original file was unlinked.
> 

Sure, it'll still work here. The inode still exists because of "b".

> Furthermore, on server:
> - rm b
> 
> NFS client must continue to work with rofd even though
> NFS server is stateless and even though inode is now
> nlink = 0.

No, at that point the server will probably just kill the inode and
you'll start getting back -ESTALE when you try to use that filehandle.
With NFSv2/3, there is no guarantee that the server will have bothered
to open it after reboot but before you removed it here.

> That is possible because fs will instantiate a disconnected
> dentry when decoding the file handle is there is no dentry
> already in cache.
> 
> So what I am saying is that when nfsd tries to decode
> a handle from overlay mount, and there is no mathcing
> overlay dentry in cache (with the lower ino of course)
> then we instantiate a new disconnected dentry without
> lookup and set its _upperdenry or lowerstack according
> to the knowledge that we found the handle in underlying
> fs and we checked if it is a decedent of lower_mnt[i] or
> upper_mnt.
> 
> When NFS client opens a new rwfd it WILL get a different
> handle, but it WILL really be a different file then the rofd,
> so that sounds like a good thing?
> 

An "open" with NFSv3 is basically a NFS LOOKUP or maybe a GETATTR call.
Again, the protocol is stateless, so in practice we open the inode each
time we service a READ or WRITE RPC.

How is knfsd to know that you want to access the r/o or r/w inode there
and thus give you the right filehandle?

> I realize it may sound complicated, but redirect_fh patch
> has already all the needed parts in place for this, so the
> proof if what I am saying is right or wrong will be in whether
> or not I am able to present a working POC...
> 

Sounds like an interesting experiment either way. It may be simpler to
think about generating some sort of synthetic filehandles that can
dispatch requests to the right inode depending on the context of the
call?

Not sure I understand overlayfs well enough to have that make sense.
-- 
Jeff Layton <jlayton@poochiereds.net>
