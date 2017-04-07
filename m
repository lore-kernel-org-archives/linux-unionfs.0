From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: overlayfs NFS export
Date: Fri, 7 Apr 2017 18:26:59 +0300
Message-ID: <CAOQ4uxhqTUtu_+pDTWHPi5iZb_BYxobxyQ7BfyqVdaM6HzMpPw@mail.gmail.com>
References: <CAOQ4uxhpKFhksVJTgWyy5YRzunLiQjf9TTgFO_EfBSdWvBfxWg@mail.gmail.com>
 <1491576837.2745.19.camel@poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:35996 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754686AbdDGP1A (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Apr 2017 11:27:00 -0400
In-Reply-To: <1491576837.2745.19.camel@poochiereds.net>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jeff Layton <jlayton@poochiereds.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, "J. Bruce Fields" <bfields@fieldses.org>, Trond Myklebust <trond.myklebust@primarydata.com>

On Fri, Apr 7, 2017 at 5:53 PM, Jeff Layton <jlayton@poochiereds.net> wrote:
> On Fri, 2017-04-07 at 17:29 +0300, Amir Goldstein wrote:
>> [changing the subject and adding more NFS guys so they can shoot my
>> idea down if it is too dumb to live]
>>
>> On Fri, Apr 7, 2017 at 4:03 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> > On Fri, Apr 7, 2017 at 12:47 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> >
>> > > Come to think about it, NFS export of regular file don't need to
>> > > follow renames at all:
>> > > - The handle for a regular file is always the handle for the real
>> > > lower or upper inode
>> > > - To decode a handle, create an O_TMPFILE style overlay dentry, which
>> > > is not linked
>> > >   to any path in overlay, but has the _upperdentry/lowerstack setup
>> >
>> > I don't think nfs will allow such a scheme.  NFS3 server is stateless,
>> > which means there's no open/close in the protocol.   Hence we can't
>> > copy-up on open(O_WR*) and return a different file handle for writing.
>> > If client looks up a file currently on lower and we return file handle
>> > based on lower file, then we must be able to decode that handle after
>> > the file has been copied up and even after rename.  And this must work
>> > reliably even if the overlay dentry is no longer in the dcache.
>> >
>> > So there's no option, other than to have a reverse mapping somewhere.
>> >
>>
>> Either I am missing something or you are.
>>
>> Consider this scenario:
>>
>> On server:
>> - touch a
>> - ln a b
>>
>> On NFS client:
>> - rofd = open("a", O_RDONLY)
>>
>> On server
>> - rm a
>> - reboot
>>
>> NFS client must be able to continue to work with rofd
>> even after reboot and even after original file was unlinked.
>>
>
> Sure, it'll still work here. The inode still exists because of "b".
>
>> Furthermore, on server:
>> - rm b
>>
>> NFS client must continue to work with rofd even though
>> NFS server is stateless and even though inode is now
>> nlink = 0.
>
> No, at that point the server will probably just kill the inode and
> you'll start getting back -ESTALE when you try to use that filehandle.
> With NFSv2/3, there is no guarantee that the server will have bothered
> to open it after reboot but before you removed it here.
>

Yes, I forgot to say that another process on server keeps the
inode alive.
Just stressing the point that if overlay provides a disconected
dentry to nfsd its not going to be a new thing.

>> That is possible because fs will instantiate a disconnected
>> dentry when decoding the file handle is there is no dentry
>> already in cache.
>>
>> So what I am saying is that when nfsd tries to decode
>> a handle from overlay mount, and there is no mathcing
>> overlay dentry in cache (with the lower ino of course)
>> then we instantiate a new disconnected dentry without
>> lookup and set its _upperdenry or lowerstack according
>> to the knowledge that we found the handle in underlying
>> fs and we checked if it is a decedent of lower_mnt[i] or
>> upper_mnt.
>>
>> When NFS client opens a new rwfd it WILL get a different
>> handle, but it WILL really be a different file then the rofd,
>> so that sounds like a good thing?
>>
>
> An "open" with NFSv3 is basically a NFS LOOKUP or maybe a GETATTR call.
> Again, the protocol is stateless, so in practice we open the inode each
> time we service a READ or WRITE RPC.

Yes, but you open the inode using a filehandle from the client right?
otherwise whats exportfs for?

>
> How is knfsd to know that you want to access the r/o or r/w inode there
> and thus give you the right filehandle?
>

Its not knfsd business to know that.
With overlayfs the first ro handle will have the lower inode
and second rw handle will have the upper inode
trying to open by handle from ro handle will get you
a disconnected overlay dentry pointing to lower inode
and trying to open by handle from rw handle will
get you a disconnected overlay dentry pointing to
upper inode.

Again, with overlayfs those are 2 different files
whose data may not be consistent at all.

This trick does circumvent the locks_inode() helper
that was added to make sure that ro and rw files
lock the same (overlay) object... hmm

>> I realize it may sound complicated, but redirect_fh patch
>> has already all the needed parts in place for this, so the
>> proof if what I am saying is right or wrong will be in whether
>> or not I am able to present a working POC...
>>
>
> Sounds like an interesting experiment either way. It may be simpler to
> think about generating some sort of synthetic filehandles that can
> dispatch requests to the right inode depending on the context of the
> call?

parent ino info is enough to find which layer the handle came from,
but as I understood in LSF, knfsd does not want to get the parent
ino is encoding (for uniqueness of hardlinks), so i need to see about that.

>
> Not sure I understand overlayfs well enough to have that make sense.
> --

Not sure I understand NFS well enough ;-)
trying to bring the two parties a bit closer to understand what
it will take for overlayfs to play well with NFS.

Suppose that NFSv3 is a hard problem for overlayfs,
Is that an option to play well only with NFSv4.
Is there a way for nfsd to query fs exportfs capabilities
and export v4 only? is that a thing?

Amir.
