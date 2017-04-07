From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: overlayfs NFS export
Date: Fri, 7 Apr 2017 18:45:57 +0300
Message-ID: <CAOQ4uxgnvfZUdWfTsPMfjsvht9tEZi04GVyg=VzUNAWHyD=g_A@mail.gmail.com>
References: <CAOQ4uxhpKFhksVJTgWyy5YRzunLiQjf9TTgFO_EfBSdWvBfxWg@mail.gmail.com>
 <1491577054.10609.1.camel@primarydata.com> <CAJfpegu5hkHM7z4UWhoNhoXBJ9ZmmA8EpAaoThxRe45cCSDeAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:35893 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755599AbdDGPp6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Apr 2017 11:45:58 -0400
In-Reply-To: <CAJfpegu5hkHM7z4UWhoNhoXBJ9ZmmA8EpAaoThxRe45cCSDeAQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Trond Myklebust <trondmy@primarydata.com>, "bfields@fieldses.org" <bfields@fieldses.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "jlayton@poochiereds.net" <jlayton@poochiereds.net>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

On Fri, Apr 7, 2017 at 6:28 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Apr 7, 2017 at 4:57 PM, Trond Myklebust <trondmy@primarydata.com> wrote:
>
>> What is the problem you are trying to solve?
>
> The problem is getting a persistent file handle for overlayfs files.

That is only part of the problem and the point I was trying to
explore is that we don't need to solve it at all (see below).

The other part of the problem is getting a persistent handle for
overlayfs directories.

Why this second problem is hard is too difficult to explain to
non-overlayfs folks, but Miklos and I started playing around with an idea.

>
> One idea suggested by Viro is to create a dummy inode on the upper
> layer whenever we look up a dentry in the overlay filesystem.  Then we

So that idea is not relevant for directories (I think)

> have an inode number reserved for the file if it needs to be copied
> up. This solves the file handle problem, since we can generate a path
> from the file handle and from there get the original lower layer file
> (assumes the file handle has the parent handle encoded as well).  If

Apparently, that is not the case with knfsd, but it doesn't matter
for directory handles which can always be reconnceted.

> the file is copied up, the file is no longer assiciated with the lower
> layer, we just need to use the upper inode, this works too.  And also
> files created on the upper work fine.
>
> The only little problem is that we are creating lots of inodes on disk
> and memory that until now we haven't.  Currently overlayfs only
> modifies upper layer if there's a good reason to believe that there is
> really going to be modification (e.g. when file is opened for write).
>
> The alternative is generate file handle from lower file (if on lower)
> and from upper file (if on upper).   The issue is if the file is
> copied up and goes from lower to upper.  In that case we need to find
> the upper file from the handle generated from the lower file.   This

So why do we really need to find the upper in that case?
If we follow my idea, then NFS read request with lower handle
may be served from lower inode and NFS write request with a
lower handle will get ESTALE and will try to lookup by path
(I suppose?).
That's probably more consistent then what local processes get
from overlayfs.

I realize I don't have all the pieces in my head yet... still trying
to collect them on the go.

Thanks for your patience guys,
Amir.
