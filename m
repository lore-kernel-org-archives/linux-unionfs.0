From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: overlayfs NFS export
Date: Fri, 7 Apr 2017 18:58:37 +0300
Message-ID: <CAOQ4uxg1r5yeSntm_nHb0WJqJe-v-yBsTq1TMTj_XcjZVwPiBA@mail.gmail.com>
References: <CAOQ4uxhpKFhksVJTgWyy5YRzunLiQjf9TTgFO_EfBSdWvBfxWg@mail.gmail.com>
 <1491577054.10609.1.camel@primarydata.com> <CAJfpegu5hkHM7z4UWhoNhoXBJ9ZmmA8EpAaoThxRe45cCSDeAQ@mail.gmail.com>
 <1491579981.12269.1.camel@primarydata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:32923 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933105AbdDGP6i (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Apr 2017 11:58:38 -0400
In-Reply-To: <1491579981.12269.1.camel@primarydata.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Trond Myklebust <trondmy@primarydata.com>
Cc: "miklos@szeredi.hu" <miklos@szeredi.hu>, "bfields@fieldses.org" <bfields@fieldses.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "jlayton@poochiereds.net" <jlayton@poochiereds.net>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

On Fri, Apr 7, 2017 at 6:46 PM, Trond Myklebust <trondmy@primarydata.com> wrote:
> On Fri, 2017-04-07 at 17:28 +0200, Miklos Szeredi wrote:
>> On Fri, Apr 7, 2017 at 4:57 PM, Trond Myklebust <trondmy@primarydata.
>> com> wrote:
>>
>> > What is the problem you are trying to solve?
>>
>> The problem is getting a persistent file handle for overlayfs files.
>>
>> One idea suggested by Viro is to create a dummy inode on the upper
>> layer whenever we look up a dentry in the overlay filesystem.  Then
>> we
>> have an inode number reserved for the file if it needs to be copied
>> up. This solves the file handle problem, since we can generate a path
>> from the file handle and from there get the original lower layer file
>> (assumes the file handle has the parent handle encoded as well).  If
>> the file is copied up, the file is no longer assiciated with the
>> lower
>> layer, we just need to use the upper inode, this works too.  And also
>> files created on the upper work fine.
>>
>
> Why do you need the parent directory to be encoded as well? Doesn't
> fh_to_dentry() suffice?
>

Put it simply, you encoded a file /mnt/A/b which is found at
/lower/A/b and when you later come with this handle, you need to
check not only that the original lower inode is not stale (trivial),
but also that there is no new file or whiteout at path /upper/A/b.
so you can do this by converting handle to path and then looking
up same in /upper. everything breaks when upper dirs get renamed...


> The thing is that for all namespace related operations (mkdir(),
> rmdir(), open(O_CREATE), unlink,...) the client will supply the parent
> filehandle, so those operations should not normally suffer.
>
> The only operation that would be a problem is when you have to copy up
> a regular file, but for that case overlayfs needs to generate dentries
> for _all_ hardlinks to that file, in the upper layer, no?

Needs to... but it bloody well doesn't. That's one of the hardest issues.

>
>> The only little problem is that we are creating lots of inodes on
>> disk
>> and memory that until now we haven't.  Currently overlayfs only
>> modifies upper layer if there's a good reason to believe that there
>> is
>> really going to be modification (e.g. when file is opened for write).
>>
>> The alternative is generate file handle from lower file (if on lower)
>> and from upper file (if on upper).   The issue is if the file is
>> copied up and goes from lower to upper.  In that case we need to find
>> the upper file from the handle generated from the lower file.   This
>> works as long as the upper file hasn't been renamed, same way we
>> found
>> the lower from the upper Viro's scheme: generate path from lower file
>> handle and look up in overlay.  When copied up file is renamed, this
>> doesn't work anymore, so we need a mapping from lower-handle to
>> upper-handle.
>>
> Generating filehandles from the namespace is a nightmare. It only works

You mean generating a path from filehandle? or generating a filehandle
with parent so it can be reconnected?

> if you have strict non-POSIX-compatible rules about not being able to
> modify the parent of a subtree if there is a file in use in that
> subtree. You can therefore make it work if the underlying filesystem is
> something like NTFS, but not if you want POSIX semantics.
>

This was overlayfs prior to v4.10. too bad we fixed it ;-)

Amir.
