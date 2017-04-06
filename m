From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 0/6] ovl: consistent_fd feature
Date: Thu, 6 Apr 2017 17:20:18 +0200
Message-ID: <CAJfpegsidjjP_DPpAGAjUtOZEw70nu5jnoTO5E+yzPkONG4X9A@mail.gmail.com>
References: <1490798166-22310-1-git-send-email-amir73il@gmail.com> <CAOQ4uxgcOD0DEZse2hWRWopDdBPsb+f=XX0SPQirbX_WGmLR-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36655 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933892AbdDFPUU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Apr 2017 11:20:20 -0400
Received: by mail-oi0-f68.google.com with SMTP id b187so7552412oif.3
        for <linux-unionfs@vger.kernel.org>; Thu, 06 Apr 2017 08:20:20 -0700 (PDT)
In-Reply-To: <CAOQ4uxgcOD0DEZse2hWRWopDdBPsb+f=XX0SPQirbX_WGmLR-w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Mar 30, 2017 at 1:34 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Mar 29, 2017 at 5:36 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Mikos,
>>
>> This patch set implement the 'simple' solution we discussed on LSF.
>> For the special case of all overlays on the same fs with clone support,
>> files are copied up on open for read (as O_TMPFILE) and linked to
>> upperdir on first open for write.
>>
>> - Patches 1-2 are the refactoring I sent you earlier.  They are not
>>   strictly needed for the consistent_fd feature - up to you.
>> - Patches 3-4 test 'samefs' and 'cloneup' properties of underlying fs.
>> - Patch 5 copies up open for read (for the special case).
>> - Patch 6 defers linking the tmpfile to first open for write.
>>
>> Some of the design choices for patch 6 are questionable:
>> the storing of tempfile in ovl_dentry_update(),
>> temp dentry is freed only on overlay dentry release.
>> awaiting your feedback about those choises.

My gut feel is that we should throw away the tempfile once all files
referring to the dentry are closed.  Memory pressure on dcache does
not seem like a good way to control the number inodes allocated on
underlying fs.

I'm hoping that this is going to be a temporary solution, because I
think it's unreasonably heavyweight compared to the rareness of the
issue it is solving.  I think this should be emphasized: this is for
the paranoid and it will cause a performance to degrade and resource
use to increase (although it may be an acceptable amount).

I also have a feeling that we must get the inode number from the lower
file in this case or it's going to break things (e.g. the pattern:
stat(), open(), fstat() verify st_dev/st_ino unchanged). Same goes for
atime, although that's a much smaller issue.

Yeah, yeah, copy-up has that issue, but lets remember that copy-up is
a rare event compared to open(O_RDONLY).

And we need to fix the constant inode number issue anyway.

So I thought about the constant inode number thing (for now only for
the samefs case) and here are my ideas:

 - need a database of upper_ino -> lower_ino mapping
 - on copy-up: append new mapping to database
 - on remove: delete mapping from database (since upper_ino might be reused)
 - on readdir and stat: check database and replace st_ino/d_ino if needed

For NFS export and hard-link-copy-up support, just need to extend this
with a reverse mapping.

The interesting questions are:

 - where to keep the database(s)
 - and how to cache them efficiently in the kernel.

I'd refrain from changes in disk format (i.e. those that rely on
backward incompatible features for underlying filesystems).  At least
for the first version.

Simplest solution is to keep mapping in the upper inode itself
(xattr).  Takes care of removal automatically.  Can be cached in
ovl_entry.  Makes readdir() really inefficient... need to cache
whether mapping needed for any directory entries in directory, which
complicates rename.

The other idea is to store the database separately from the upper tree
(this is what aufs does, apparently).  This works for reverse mapping
as well.  Makes all operations (except rename) more complicated.
Keeping whole mapping in kernel memory is prone to resource hogging
and DoS.   Could have a bitmap created by hashing the ino's that are
in the map and setting the bit for those.  Then only reach out to the
disk db if there's a possibility of hit.  Would still need to design
an efficient way to store and access the data in the db (and I have
zero experience with that sort of thing).

Thoughts?

Thanks,
Miklos
