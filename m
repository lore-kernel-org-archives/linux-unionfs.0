From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 0/6] ovl: consistent_fd feature
Date: Thu, 6 Apr 2017 19:25:31 +0300
Message-ID: <CAOQ4uxispHXxq8qO9GHEyQm9nLWUiG9CfMzP59hffYM5OPB4DA@mail.gmail.com>
References: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgcOD0DEZse2hWRWopDdBPsb+f=XX0SPQirbX_WGmLR-w@mail.gmail.com>
 <CAJfpegsidjjP_DPpAGAjUtOZEw70nu5jnoTO5E+yzPkONG4X9A@mail.gmail.com> <CAJfpegugsV8Lzwwiz5BncAnTVc2tPdYcG7eGrVhChcfc6CtBfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35231 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933197AbdDFQZc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Apr 2017 12:25:32 -0400
Received: by mail-oi0-f66.google.com with SMTP id d2so7836540oig.2
        for <linux-unionfs@vger.kernel.org>; Thu, 06 Apr 2017 09:25:32 -0700 (PDT)
In-Reply-To: <CAJfpegugsV8Lzwwiz5BncAnTVc2tPdYcG7eGrVhChcfc6CtBfw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Apr 6, 2017 at 6:37 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Apr 6, 2017 at 5:20 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Thu, Mar 30, 2017 at 1:34 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>
>> Simplest solution is to keep mapping in the upper inode itself
>> (xattr).  Takes care of removal automatically.  Can be cached in
>> ovl_entry.  Makes readdir() really inefficient... need to cache
>> whether mapping needed for any directory entries in directory, which
>> complicates rename.

This feels right.
We anyway store a lot of cache per directory dentry, the extra mapping
doesn't sound so bad.
rename is heavy anyway ;-)
And its got the sb wide lock so we don't have to worry about that stuff...

>>
>> The other idea is to store the database separately from the upper tree
>> (this is what aufs does, apparently).  This works for reverse mapping
>> as well.  Makes all operations (except rename) more complicated.

This feels wrong.
Makes me not want to look at this future code...

>> Keeping whole mapping in kernel memory is prone to resource hogging
>> and DoS.   Could have a bitmap created by hashing the ino's that are
>> in the map and setting the bit for those.  Then only reach out to the
>> disk db if there's a possibility of hit.  Would still need to design
>> an efficient way to store and access the data in the db (and I have
>> zero experience with that sort of thing).
>
> Hmm, could actually combine the two ideas:
>
> Store mapping just in upper inode, walk upper tree on mount and fill
> in bitmap.  Update bitmap as we go.
>

Right. You only need a local directory mapping at readdir time, so
only need to scan that dir inodes into the dir_cache.
Instead of invalidating the entire dir cache on every dir operation,
we can try to do something more subtle, so most of the inode mapping
would be preserved.

> Reverse mapping still needs out-of-band solution, since walking the
> whole upper tree each time we need to find a reverse map doesn't look
> like a good solution.
>

Yes. but remember the optimization we talked about in LSF:

At least for userspace NFS daemon that need to use the open_by_handle_at()
API, with a handle it got from name_to_handle_at(), the handle contains
the parent inode and it is possible to reconstruct the path from the handle.

This means that short of redirected directories and hardlinked files, you get
get lower path from handle and then look up the same path in overlay mount
to restore the original dentry.

So you never need reverse mapping for directories that were not redirected.
As for files that are not hardlinks for which kernel nfsd holds a handle without
parent inode... need to see how bad it could be if nfsd used a non unique
handle (which includes parent ino), but had a compare_handle() op from fs
to canonalize the handles.

If restricting reverse mapping to just redirected dirs and hardlinked files
that becomes something that can live in memory (??) and the cost of keeping
a persistent store may be simple enough.

I am thinking linked list of redirect_fh stored in upper inodes (of copy up
hardlinks and redirected dirs). Loading the list at mount is just
traversing the list
and chaining all inodes in memory.
upper remove may need to update one (prev) inode and copy up (or redirect)
may need to update one (tail) inode.
