From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Overlayfs reverse mapping
Date: Wed, 19 Apr 2017 14:34:03 +0300
Message-ID: <CAOQ4uxid0C3PLnfopBWAtWkNqyuMkickoUrZzDmj6-bEOWCDcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:36067 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760702AbdDSLeE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Apr 2017 07:34:04 -0400
Received: by mail-oi0-f53.google.com with SMTP id r203so23660138oib.3
        for <linux-unionfs@vger.kernel.org>; Wed, 19 Apr 2017 04:34:04 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

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
> One more idea:  do it out-of-band (e.g. under workdir) but do it as a
> plain directory tree shadowing the lower trees that contains the
> forward redirect information.  It spares us the implementation of the
> database, since the filesystem does it for us.  Yes, it can get out of
> sync with the overlay, but so can any mapping in-band or out-of-band.
>

Miklos,

I started looking into reverse mapping (to compliment the stable inode work)

I am contemplating a scheme similar to your suggestion, but instead of
a shadow directory tree, index forward redirects by stable inode number
and store upper and lower redirects as xattr, e.g.:

workdir/inodes/#100

contains xattrs:
overlay.fh - fh of lower inode (whose ino is 100)
overlay.redirect - path of lower inode (so fh and stale ino can be
fixed after copying layers)
overlay.upper - fh of upper inode
overlay.path - path (*) of upper (so upper fh can be fixed after copying layers)

(*) upper path can get out of sync with upper fh in case
     of crash during rename. on mount, if upper fh is valid,
     path should be fixed.

I am still trying to see if for non-dirs it makes sense for inodes/#100
to be a hardlink to upper inode.
It saves the indirection to upper fh and hardlinks would be preserved
with rsync and tar.

This would require linking temp to inodes/#100 before linking it to
upper dir and we would need to turn inodes/#100 into a whiteout
(or truncate it) on ovl_evict_inode() operation.

We need the "inode whiteout" around for a quick indication
that the NFS handle (of overlay inode 100) became stale.
We can also deduce that the handle became stale by looking up
the lower path in overlay and getting a negative dentry or one
with lower dentry that doesn't point to inode 100, but the
"inode whiteout" make this case easier to handle.

If you see any major flaw in this design please shout.

Thanks,
Amir.
