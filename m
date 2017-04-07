From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: overlayfs NFS export
Date: Fri, 7 Apr 2017 17:28:39 +0200
Message-ID: <CAJfpegu5hkHM7z4UWhoNhoXBJ9ZmmA8EpAaoThxRe45cCSDeAQ@mail.gmail.com>
References: <CAOQ4uxhpKFhksVJTgWyy5YRzunLiQjf9TTgFO_EfBSdWvBfxWg@mail.gmail.com>
 <1491577054.10609.1.camel@primarydata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1491577054.10609.1.camel@primarydata.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Trond Myklebust <trondmy@primarydata.com>
Cc: "amir73il@gmail.com" <amir73il@gmail.com>, "bfields@fieldses.org" <bfields@fieldses.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "jlayton@poochiereds.net" <jlayton@poochiereds.net>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Apr 7, 2017 at 4:57 PM, Trond Myklebust <trondmy@primarydata.com> wrote:

> What is the problem you are trying to solve?

The problem is getting a persistent file handle for overlayfs files.

One idea suggested by Viro is to create a dummy inode on the upper
layer whenever we look up a dentry in the overlay filesystem.  Then we
have an inode number reserved for the file if it needs to be copied
up. This solves the file handle problem, since we can generate a path
from the file handle and from there get the original lower layer file
(assumes the file handle has the parent handle encoded as well).  If
the file is copied up, the file is no longer assiciated with the lower
layer, we just need to use the upper inode, this works too.  And also
files created on the upper work fine.

The only little problem is that we are creating lots of inodes on disk
and memory that until now we haven't.  Currently overlayfs only
modifies upper layer if there's a good reason to believe that there is
really going to be modification (e.g. when file is opened for write).

The alternative is generate file handle from lower file (if on lower)
and from upper file (if on upper).   The issue is if the file is
copied up and goes from lower to upper.  In that case we need to find
the upper file from the handle generated from the lower file.   This
works as long as the upper file hasn't been renamed, same way we found
the lower from the upper Viro's scheme: generate path from lower file
handle and look up in overlay.  When copied up file is renamed, this
doesn't work anymore, so we need a mapping from lower-handle to
upper-handle.

Thanks,
Miklos
