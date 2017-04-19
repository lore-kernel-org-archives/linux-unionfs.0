From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH 00/13] overlayfs stable inodes
Date: Wed, 19 Apr 2017 13:37:44 +0300
Message-ID: <CAOQ4uxh1VmeB1WGuP4sXyzR0oeQ_ux2hd+9vXM=UbsL+cxTwXQ@mail.gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgtiDr9GEgjAsRHLeOo=HTobf-qwZ0bZLyjrhLyNiTt4A@mail.gmail.com> <CAJfpegsQTd8SgHRFcuEJMgjLjNW45vyuUiPPKZLC4bv_OJOmGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35169 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762261AbdDSKhp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Apr 2017 06:37:45 -0400
In-Reply-To: <CAJfpegsQTd8SgHRFcuEJMgjLjNW45vyuUiPPKZLC4bv_OJOmGA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Wed, Apr 19, 2017 at 12:16 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Apr 18, 2017 at 8:37 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>
>> On Mon, Apr 17, 2017 at 2:59 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> > Overlayfs inodes are considered unstable in several aspects,
>> > because on a copy up event:
>> > 1. st_ino can change
>> > 2. st_dev can change
>> > 3. hardlinks are broken
>> > 4. NFS handle would become stale
>> > 5. content of read-only file descriptor would become stale
>> >
>> > This patch set 'stabilizes' overlayfs inodes w.r.t. st_ino/st_dev
>> > and takes some big steps in the direction of stabilizing hardlinks
>> > and NFS handles.
>> >
>>
>> I realized I forgot to mention in the cover letter that stable inodes
>> are only available for the overlay configuration where all layers
>> are on the same underlying fs and that underlying fs support
>> NFS export (I think all eligible upper fs support NFS export anyway).
>
> Hmm,  we could keep inode numbers stable across copy up even if layers
> are on different filesystems:  just need to use a separate st_dev for
> lower layers and keep st_dev and st_inode constant.  The only extra
> thing needed compared to the samefs case is the allocation of dummy
> device numbers for lower layers.  Of course "find -xdev" and the like
> still won't work properly, and we wouldn't be able to provide sane
> d_ino values in readdir.

Not sure that is going to be worth the effort, but we'll see.
Anyway, not sure if you already read far enough into the series,
but the fact that overlay inodes are hashed by stable inode ino
helps solving a lot of the problems with minimal code changes,
so in the grand scheme of things, I think it would be easier to
say: same_fs can give you POSIX. non same_fs cannot.

> But NFS export should actually work, since
> we can encode the device number in the file handle.

That's true.
But it comes down to the question of are there any users for this.
I mean if we provide full POSIX and NFS export to same_fs case,
would it be interesting to provide NFS export and partial
constant inode numbers (not for d_ino) for non same_fs case?

>
> Lets keep things simple for now, so those are just things to keep in
> mind but the actual implementation can wait.
>
> Thanks,
> Miklos
