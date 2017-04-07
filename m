From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: overlayfs NFS export
Date: Fri, 7 Apr 2017 17:29:53 +0300
Message-ID: <CAOQ4uxhpKFhksVJTgWyy5YRzunLiQjf9TTgFO_EfBSdWvBfxWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:32923 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933865AbdDGOaJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Apr 2017 10:30:09 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>

[changing the subject and adding more NFS guys so they can shoot my
idea down if it is too dumb to live]

On Fri, Apr 7, 2017 at 4:03 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Apr 7, 2017 at 12:47 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>
>> Come to think about it, NFS export of regular file don't need to
>> follow renames at all:
>> - The handle for a regular file is always the handle for the real
>> lower or upper inode
>> - To decode a handle, create an O_TMPFILE style overlay dentry, which
>> is not linked
>>   to any path in overlay, but has the _upperdentry/lowerstack setup
>
> I don't think nfs will allow such a scheme.  NFS3 server is stateless,
> which means there's no open/close in the protocol.   Hence we can't
> copy-up on open(O_WR*) and return a different file handle for writing.
> If client looks up a file currently on lower and we return file handle
> based on lower file, then we must be able to decode that handle after
> the file has been copied up and even after rename.  And this must work
> reliably even if the overlay dentry is no longer in the dcache.
>
> So there's no option, other than to have a reverse mapping somewhere.
>

Either I am missing something or you are.

Consider this scenario:

On server:
- touch a
- ln a b

On NFS client:
- rofd = open("a", O_RDONLY)

On server
- rm a
- reboot

NFS client must be able to continue to work with rofd
even after reboot and even after original file was unlinked.

Furthermore, on server:
- rm b

NFS client must continue to work with rofd even though
NFS server is stateless and even though inode is now
nlink = 0.
That is possible because fs will instantiate a disconnected
dentry when decoding the file handle is there is no dentry
already in cache.

So what I am saying is that when nfsd tries to decode
a handle from overlay mount, and there is no mathcing
overlay dentry in cache (with the lower ino of course)
then we instantiate a new disconnected dentry without
lookup and set its _upperdenry or lowerstack according
to the knowledge that we found the handle in underlying
fs and we checked if it is a decedent of lower_mnt[i] or
upper_mnt.

When NFS client opens a new rwfd it WILL get a different
handle, but it WILL really be a different file then the rofd,
so that sounds like a good thing?

I realize it may sound complicated, but redirect_fh patch
has already all the needed parts in place for this, so the
proof if what I am saying is right or wrong will be in whether
or not I am able to present a working POC...

Amir.
