From: Jeff Layton <jlayton@poochiereds.net>
Subject: Re: overlayfs NFS export
Date: Fri, 07 Apr 2017 12:47:10 -0400
Message-ID: <1491583630.2745.23.camel@poochiereds.net>
References: <CAOQ4uxhpKFhksVJTgWyy5YRzunLiQjf9TTgFO_EfBSdWvBfxWg@mail.gmail.com>
         <1491577054.10609.1.camel@primarydata.com>
         <CAJfpegu5hkHM7z4UWhoNhoXBJ9ZmmA8EpAaoThxRe45cCSDeAQ@mail.gmail.com>
         <CAOQ4uxgnvfZUdWfTsPMfjsvht9tEZi04GVyg=VzUNAWHyD=g_A@mail.gmail.com>
         <1491580705.12269.3.camel@primarydata.com>
         <CAOQ4uxg9MwAffRcwavhRJy+TO9LS=tNKmuy3QHyio5yHGJRN0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:36313 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934330AbdDGQrO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Apr 2017 12:47:14 -0400
Received: by mail-qk0-f170.google.com with SMTP id p22so67529473qka.3
        for <linux-unionfs@vger.kernel.org>; Fri, 07 Apr 2017 09:47:13 -0700 (PDT)
In-Reply-To: <CAOQ4uxg9MwAffRcwavhRJy+TO9LS=tNKmuy3QHyio5yHGJRN0A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Trond Myklebust <trondmy@primarydata.com>
Cc: "miklos@szeredi.hu" <miklos@szeredi.hu>, "bfields@fieldses.org" <bfields@fieldses.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

On Fri, 2017-04-07 at 19:10 +0300, Amir Goldstein wrote:
> On Fri, Apr 7, 2017 at 6:58 PM, Trond Myklebust <trondmy@primarydata.com> wrote:
> > On Fri, 2017-04-07 at 18:45 +0300, Amir Goldstein wrote:
> > > On Fri, Apr 7, 2017 at 6:28 PM, Miklos Szeredi <miklos@szeredi.hu>
> > > wrote:
> > > > On Fri, Apr 7, 2017 at 4:57 PM, Trond Myklebust <trondmy@primarydat
> > > > a.com> wrote:
> > > > 
> > > > > What is the problem you are trying to solve?
> > > > 
> > > > The problem is getting a persistent file handle for overlayfs
> > > > files.
> > > 
> > > That is only part of the problem and the point I was trying to
> > > explore is that we don't need to solve it at all (see below).
> > 
> > You don't, if you are willing to live with non-POSIX semantics.
> > Otherwise you do.
> > 
> > > 
> > > The other part of the problem is getting a persistent handle for
> > > overlayfs directories.
> > > 
> > > Why this second problem is hard is too difficult to explain to
> > > non-overlayfs folks, but Miklos and I started playing around with an
> > > idea.
> > > 
> > > > 
> > > > One idea suggested by Viro is to create a dummy inode on the upper
> > > > layer whenever we look up a dentry in the overlay filesystem.  Then
> > > > we
> > > 
> > > So that idea is not relevant for directories (I think)
> > > 
> > > > have an inode number reserved for the file if it needs to be copied
> > > > up. This solves the file handle problem, since we can generate a
> > > > path
> > > > from the file handle and from there get the original lower layer
> > > > file
> > > > (assumes the file handle has the parent handle encoded as
> > > > well).  If
> > > 
> > > Apparently, that is not the case with knfsd, but it doesn't matter
> > > for directory handles which can always be reconnceted.
> > > 
> > > > the file is copied up, the file is no longer assiciated with the
> > > > lower
> > > > layer, we just need to use the upper inode, this works too.  And
> > > > also
> > > > files created on the upper work fine.
> > > > 
> > > > The only little problem is that we are creating lots of inodes on
> > > > disk
> > > > and memory that until now we haven't.  Currently overlayfs only
> > > > modifies upper layer if there's a good reason to believe that there
> > > > is
> > > > really going to be modification (e.g. when file is opened for
> > > > write).
> > > > 
> > > > The alternative is generate file handle from lower file (if on
> > > > lower)
> > > > and from upper file (if on upper).   The issue is if the file is
> > > > copied up and goes from lower to upper.  In that case we need to
> > > > find
> > > > the upper file from the handle generated from the lower
> > > > file.   This
> > > 
> > > So why do we really need to find the upper in that case?
> > > If we follow my idea, then NFS read request with lower handle
> > > may be served from lower inode and NFS write request with a
> > > lower handle will get ESTALE and will try to lookup by path
> > > (I suppose?).
> > > 
> > 
> > The client will never try to recover from an ESTALE error that is
> > returned on a file it has already opened. That would cause data
> > corruption if the user were to do something like 'rm foo; touch foo' on
> > the server; writes that were intended for the old file would suddenly
> > be written to the new one in violation of POSIX I/O rules.
> > 
> > 
> > IOW: In the case where WRITE returns ESTALE, that error will result in
> > the client returning EIO to the application on the next write() or
> > fsync() or close(). That error will persist; a retry will not clear
> > it.
> > 
> 
> The most important point to understand is this:
> 
> If server opens a file for write it will trigger a copy up
> and the file handle returned will be persistent and final.
> 
> The only problem is that when server opens a file for
> read *before* it opens the same file for write, the returned
> handle would be different, because first open for write
> creates a new file and the old file remains a zombie
> (as far as nfsd is concerned) only nfsd is able to to access
> the old file and only for read.

Once a copy-up occurs, then I expect it'd look to the client like the
file had been renamed-over. You're getting back a different dentry/inode
pair on lookup, right? Eventually the client will revalidate the parent
directory inode, see that something has changed and redo the lookup for
the thing. New opens would go to the copied-up inode after that point.

In any case, nfsd will usually only hold the r/o file open if some
client was holding that file open. So, it sounds like you'll end up
projecting that weird overlayfs "read open before write open" corner
case across the wire, but it would otherwise "work".
-- 
Jeff Layton <jlayton@poochiereds.net>

[1] Side question: does the parent directory's mtime get updated when
there is a copy-up? The client might not notice that its dentries are
now invalid afterward unless it does.
