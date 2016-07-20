From: Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [RFC PATCH] locks: fix file locking on overlayfs
Date: Wed, 20 Jul 2016 06:08:39 +0200
Message-ID: <CAOssrKe-qTrVNXc=qfySZCVMy4avP1cpxCDUtFU1jL598rh6OQ@mail.gmail.com>
References: <1468931264-25837-1-git-send-email-mszeredi@redhat.com> <1468951311.7655.20.camel@poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1468951311.7655.20.camel@poochiereds.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Layton <jlayton@poochiereds.net>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jul 19, 2016 at 8:01 PM, Jeff Layton <jlayton@poochiereds.net> wrote:
> On Tue, 2016-07-19 at 14:27 +0200, Miklos Szeredi wrote:

>> > diff --git a/mm/mmap.c b/mm/mmap.c
>> index de2c1769cc68..a023caff19d5 100644
>> --- a/mm/mmap.c
>> +++ b/mm/mmap.c
>> @@ -126,7 +126,7 @@ static void __remove_shared_vm_struct(struct vm_area_struct *vma,
>> >             struct file *file, struct address_space *mapping)
>>  {
>> >     if (vma->vm_flags & VM_DENYWRITE)
>> > -           atomic_inc(&file_inode(file)->i_writecount);
>> > +           atomic_inc(&locks_inode(file)->i_writecount);
>> >     if (vma->vm_flags & VM_SHARED)
>> >             mapping_unmap_writable(mapping);
>> >
>
> Not sure about this bit with the i_writecount, as it's used for other
> things besides file locking. Could this cause problems when accessing
> the writable layer while the overlay is active? ISTR that the openwrt
> backup instructions have you do exactly that when overlayfs is used.

Hmm,  We could get write access on upper layer only.  That's trivial
for open (it was done that way previously) but needs some thought for
truncate(2).

What we want for truncate is copy up to happen before
get_write_access().  It's simple enough with

  get_write_access(d_inode(d_real(dentry, NULL, O_WRONLY)));

plus error handling.  Problem with this is if something fails after
that, then copy-up was done needlessly.  E.g. if break_lease() was
interrupted.  Probably not a big deal in practice.

The other thing is what happens if there's a denywrite on a lower file
that is then opened for write or truncated.  With the current patch
get_write_access() wil fail.  With the above modification it will
succeed.  Either behavior is acceptable, considering that the copy-up
does actually create a different file, so the old, denywrite mapping
won't be touched.

So I'm inclined to go with this approach to prevent issues with access
to underlying layers while overlay is active.

Thanks,
Miklos
