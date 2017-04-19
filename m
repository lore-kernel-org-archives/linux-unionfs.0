From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Overlayfs reverse mapping
Date: Wed, 19 Apr 2017 15:15:13 +0200
Message-ID: <CAJfpegtWH0P87mYMRB+sLpa0RSOVjvo4Ph1DH8E41UJiyJjiKw@mail.gmail.com>
References: <CAOQ4uxid0C3PLnfopBWAtWkNqyuMkickoUrZzDmj6-bEOWCDcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:36408 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763498AbdDSNPP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Apr 2017 09:15:15 -0400
Received: by mail-oi0-f54.google.com with SMTP id r203so26604200oib.3
        for <linux-unionfs@vger.kernel.org>; Wed, 19 Apr 2017 06:15:15 -0700 (PDT)
In-Reply-To: <CAOQ4uxid0C3PLnfopBWAtWkNqyuMkickoUrZzDmj6-bEOWCDcA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Apr 19, 2017 at 1:34 PM, Amir Goldstein <amir73il@gmail.com> wrote:

> I am contemplating a scheme similar to your suggestion, but instead of
> a shadow directory tree, index forward redirects by stable inode number
> and store upper and lower redirects as xattr, e.g.:
>
> workdir/inodes/#100

Interesting idea.

> contains xattrs:
> overlay.fh - fh of lower inode (whose ino is 100)
> overlay.redirect - path of lower inode (so fh and stale ino can be
> fixed after copying layers)
> overlay.upper - fh of upper inode
> overlay.path - path (*) of upper (so upper fh can be fixed after copying layers)

I get ".redirect" and ".upper" but not the others.  In fact the lower
fh can actually be used to generate the name of the file, so we don't
have to encode lower ino separately into the overlay fh.

And I don't think doing ".path" is worth it.  There's no use case I
can imagine that would need this for NFS export.  As for hard link
consistency, if we really want to do it, we can just detect the stale
".upper" pointer and do it the horribly slow way.  But it's so
unlikely to happen that I don't think anybody would care either way.
So lets just not care for now.

> I am still trying to see if for non-dirs it makes sense for inodes/#100
> to be a hardlink to upper inode.
> It saves the indirection to upper fh and hardlinks would be preserved
> with rsync and tar.

And makes ".upper" and ".path" superfluous. Pity, we can't hard link
directories ;)

> This would require linking temp to inodes/#100 before linking it to
> upper dir and we would need to turn inodes/#100 into a whiteout
> (or truncate it) on ovl_evict_inode() operation.
>
> We need the "inode whiteout" around for a quick indication
> that the NFS handle (of overlay inode 100) became stale.

Yes.  Not sure how much of a problem these would be for "rm -rf" type
of use cases.  Real whiteouts get removed when parent is removed, but
these would stay around forever.   But it's certainly the simplest way
to do it.

Thanks,
Miklos
