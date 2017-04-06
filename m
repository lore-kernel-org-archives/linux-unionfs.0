From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 0/6] ovl: consistent_fd feature
Date: Thu, 6 Apr 2017 19:46:50 +0300
Message-ID: <CAOQ4uxhyBeMxVCrj44Nz1L=Cy5NmqJdNCp4XV==6m6jJCv9YiQ@mail.gmail.com>
References: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgcOD0DEZse2hWRWopDdBPsb+f=XX0SPQirbX_WGmLR-w@mail.gmail.com> <CAJfpegsidjjP_DPpAGAjUtOZEw70nu5jnoTO5E+yzPkONG4X9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35701 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754821AbdDFQqv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Apr 2017 12:46:51 -0400
Received: by mail-oi0-f67.google.com with SMTP id d2so7932432oig.2
        for <linux-unionfs@vger.kernel.org>; Thu, 06 Apr 2017 09:46:51 -0700 (PDT)
In-Reply-To: <CAJfpegsidjjP_DPpAGAjUtOZEw70nu5jnoTO5E+yzPkONG4X9A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Apr 6, 2017 at 6:20 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Mar 30, 2017 at 1:34 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Wed, Mar 29, 2017 at 5:36 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> Mikos,
>>>
>>> This patch set implement the 'simple' solution we discussed on LSF.
>>> For the special case of all overlays on the same fs with clone support,
>>> files are copied up on open for read (as O_TMPFILE) and linked to
>>> upperdir on first open for write.
>>>
>>> - Patches 1-2 are the refactoring I sent you earlier.  They are not
>>>   strictly needed for the consistent_fd feature - up to you.
>>> - Patches 3-4 test 'samefs' and 'cloneup' properties of underlying fs.
>>> - Patch 5 copies up open for read (for the special case).
>>> - Patch 6 defers linking the tmpfile to first open for write.
>>>
>>> Some of the design choices for patch 6 are questionable:
>>> the storing of tempfile in ovl_dentry_update(),
>>> temp dentry is freed only on overlay dentry release.
>>> awaiting your feedback about those choises.
>
> My gut feel is that we should throw away the tempfile once all files
> referring to the dentry are closed.  Memory pressure on dcache does
> not seem like a good way to control the number inodes allocated on
> underlying fs.
>

:-/ mmm but doing that would make the second open for read overhead
so much worse.
And not only the open itself, all temp inode pages that the first reader
read are going away leaving nothing around for the second reader.

> I'm hoping that this is going to be a temporary solution, because I
> think it's unreasonably heavyweight compared to the rareness of the
> issue it is solving.  I think this should be emphasized: this is for
> the paranoid and it will cause a performance to degrade and resource
> use to increase (although it may be an acceptable amount).
>

I agree its a big cost to pay when overlayfs is used to share
lower with many containers.
But maybe not so much for a single "development container"
use case.
If I am running a docker image and never access the lower
except though overlayfs from my single container, then I have
one copy of inode in cache one copy of the inode pages in cache.
Considering that for sane development I need all my dentries in
cache anyway, then I think that the cost of clone when dentry remains
in cache is really not that bad and the cost of an extra
allocated inode is something that modern fs (xfs, btrfs) can live with.

But of course it must be an opt-in feature...

> I also have a feeling that we must get the inode number from the lower
> file in this case or it's going to break things (e.g. the pattern:
> stat(), open(), fstat() verify st_dev/st_ino unchanged). Same goes for
> atime, although that's a much smaller issue.
>

Then how about the demo patch I sent (rocopyup on getattr).
It deals with the pattern above, but it breaks the pattern:

stat(), drop caches, stat()...

I believe that for the known issues with tar the first pattern is more important
Do you know which applications would suffer from second pattern?

> Yeah, yeah, copy-up has that issue, but lets remember that copy-up is
> a rare event compared to open(O_RDONLY).
>
> And we need to fix the constant inode number issue anyway.
>

Yes, but do you think we should delay consistent_fd until we have a full
solution for constant_ino?
Do you think it is acceptable to fix only stat (to return lower ino) and leave
readdir d_ino for later?

Thanks,
Amir.
