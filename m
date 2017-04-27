From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 05/11] ovl: lookup redirect by file handle
Date: Thu, 27 Apr 2017 19:08:15 +0300
Message-ID: <CAOQ4uxjkwPwBF7F+Hrf0J_-s1fdCnBPC4wYd04fDtF8wSRaT_Q@mail.gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
 <1493025256-27188-6-git-send-email-amir73il@gmail.com> <CAJfpegtz0emDRTHDrq0CrSZXAcovrLAAsX+-WkPGDRbyZD5vOw@mail.gmail.com>
 <CAOQ4uxhu4LVJ-MAjH6McK31MYZ8__RkjCoK31kqJ-7fA2gu+SA@mail.gmail.com>
 <CAOQ4uxiGwd-h2kJVLKkbyBC9YD_a=19ta1HB0F9KueqL_Pr3XA@mail.gmail.com>
 <CAJfpegssdQ4E=uY3bq8zgXLHZsOQaJXpMWtCZ+V=yVM8vmcw5w@mail.gmail.com>
 <CAOQ4uxgPpnnc5dC+PSuOOWdpnobdKZNzgBzmbeW4Lw6P8_--hg@mail.gmail.com>
 <CAJfpeguaePn++tZBvd-2Z68a_8WGfy7EuWLzODyv60E45C6WSQ@mail.gmail.com>
 <CAOQ4uxiozume+xj4KHiDTwqgWmmXKL+6Ksw1EDWXuZYDFa2KVQ@mail.gmail.com>
 <CAJfpegtv4kN4d7ti5f5p=51aQk8U2UT9xdsvZkYoXWOfQ5BNcQ@mail.gmail.com>
 <CAOQ4uxhi4GReBbBzd8NdCJ+emzMEa1COYAtcaKziMiaZAV96uw@mail.gmail.com>
 <CAOQ4uxiGzp2G3qSC7be3nVnvjYJZuHAmY7Q1Oc+jM+pZWtuHig@mail.gmail.com>
 <CAJfpegtAx_KXb6v0dBAD0AJvLeTCFF1X4rfdAptn0xPqRHiLBQ@mail.gmail.com>
 <CAJfpegt9-w_2wQ_Y94w8AcuHYtzJ1fW6n21=eQPbyYqsNawOpQ@mail.gmail.com>
 <CAOQ4uxiweaqzR3eT-StgtDFAHBuYhGRvAJE6v=XpH33MevpmoA@mail.gmail.com>
 <CAJfpegtTJmcLVrLOeQbhu4Q6sM0Mi_FRgr+vStF0k95QsWm5uQ@mail.gmail.com>
 <CAOQ4uxhQFis+uDL9KbiJ87hNU=QRsjHn6O4LShnt6JJFaOtNuA@mail.gmail.com> <CAJfpegv4kbUU1+t6+ZApQmnzbOEo-qiHOTy3Dj0Zh84zw9JeUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:36955 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934276AbdD0QIR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2017 12:08:17 -0400
In-Reply-To: <CAJfpegv4kbUU1+t6+ZApQmnzbOEo-qiHOTy3Dj0Zh84zw9JeUw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Apr 27, 2017 at 5:46 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Apr 27, 2017 at 3:53 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Thu, Apr 27, 2017 at 4:11 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>>>  - hardlinks: need to set overlay.redirect  when hardlink is created
>>> from a copied up file; similar to what we do on rename
>>>
>>
>> Partly agree.
>> 1. This is not atomic, because hardlink is not created in workdir.
>
> Doesn't matter; we can set overlay.redirect before we do the hardlink.
> If the hardlink fails, we are left with the redirect, but that's not a
> problem.
>

Right...

>> 2. Reverse mapping will take care of this anyway. Remember?
>>     there is an extra hardlink in workdir/inodes with has overlay.redirect
>>     set on first alias copy up
>
> Yeah, but I don't really see why we'd need to set overlay.redirect on
> copy-up.  When reverse mapping (i.e. trying to reconstruct the overlay
> dentry from the lower fh)  we'll just do the same thing as for normal
> lookup: use the path from the upper root to the dentry and look up
> each component in the lower layers (taking into account any
> overlay.redirect encountered).

I was thinking we need overlay.redirect to find a lower alias by path
from any upper alias, so I knew we should have overlay.redirect in the upper
inode, but it's true that we can set it on the first ovl_link() and not at first
copy up time.


>
>>>  - for non-redirect case looking up by overlay.origin is almost surely
>>> a pessimization
>>>
>>
>> Not sure about that.
>> For directories by fh and by name are probably on par -
>> At most one lookup of ".." compared to one lookup of d.name.
>>
>> For non-dir there is a better way that is better than both (see below).
>
> Not that simple (see below).

Not that simple referring to directories (and I agree), but
not referring to non connected non-dir.


>
> Problem is there's more going on than just lookup of "..".  In fact it
> *must* entail the lookup of "name" as well, because that's the way the
> dentry gets connected.  There's an even bigger snag: where do we get
> the name?  There's a ->get_name() export op, but most fs don't define
> it, and the default action is to iterate the parent dir and find the
> one matching our inum.  There goes the performance...
>
> That's why I'm saying it's almost certainly will be slower.  Exception
> might be the cached case, but even there lookup by inum might be
> slower than the super optimized cached path lookup of a few filenames.
> Since we are looking up the overlay dentry, which isn't cached at this
> point, so why would the lower ones be?

Agree for directories, so we should not be looking directory by fh.
It's anyway hard to do for numlayers > 1.
I will see about comparing origin.fh with dir found by path - it may
be the way to go for snapshots.

>
>> When decoding directories you also want to get a connected dentry and
>> verifying is_subdir() makes sense.
>>
>> HOWEVER, and this is big thing that I missed, when decoding a non-dir
>> we DON'T need to get a connected dentry.
>> It's perfectly fine to get a disconnected alias and getting a disconnected
>> alias is always O(1) for the filesystem.
>
> It's O(1) but so is a single component lookup (case without
> overlay.redirect).  In the cold cache cache both will be slow, since
> most of the time will be spent on getting the inode from disk.  In the
> hot cache case, odds are the name lookup will win, since it's the more
> optimized codepath...
>

Correct.

To complete the picture, here is how better lookup by inode than
lookup by redirect path.

Lookup of inode should be always quite fast for filesystem, even with
cold indoe/dentry cache, inodes are easy to find by index, so worse case
is O(1 inode block read from disk at a a known location).

Compared to redirect by path of N elements this is much much better.
O(N synchronic reads of inode blocks and N directory blocks from disk)


>
>>
>> But I just realized something very very bad about non-samefs case.
>> We must use made up st_dev for lower layers, we can certainly no
>> longer use the real lower st_dev.
>> If we do, then we will have 2 files in 2 different overlay mounts,
>> who have the same lower inode but 2 different upper inodes with
>> different content and those 2 overlay files will have the same
>> st_dev/st_ino.
>
> Yeah, I told you about this issue a couple of mails back.
>

Yes you did. I guess I thought you were referring to not all lower
on same sb. Then need a unique st_dev per lower layer because
they don't share the same inode namespace.

I though that 'all lower on same fs' was ok to use the same_lower_sb
as st_dev, as is the case now for lower type entries, but it is not ok.


>>
>> I just found that in my debian based  kvm-xfstests machine, diff
>> reports 2 broken hardlinks with different content as equal, because
>> they have the same st_dev/st_ino.
>>
>> So in conclusion:
>> 1. Encode non-connectable file handles to non-dir
>
> Fine by me.
>
>> 2. Always try to lookup non-dir by fh first - it's O(1)
>
> Well... for simplicity sake, okay.  Probably not a big loss.
>
>> 3. Non-samefs needs fake st_dev before reporting constant inodes
>
> Yes.
>
>> 4. Broken hardlinks should NOT report same inode
>
> Yes.
>

So to list everything for v4 in one place:

5. store uuid together with lower fh inside struct ovl_fh (in overlay.origin)
There does not seem to be a reason to store root fh though for non-dir
and its not relevant for for lookup of dir for snapshot case either (single
lower layer case)

Thanks,
Amir.
