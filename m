From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 05/11] ovl: lookup redirect by file handle
Date: Thu, 27 Apr 2017 16:53:18 +0300
Message-ID: <CAOQ4uxhQFis+uDL9KbiJ87hNU=QRsjHn6O4LShnt6JJFaOtNuA@mail.gmail.com>
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
 <CAOQ4uxiweaqzR3eT-StgtDFAHBuYhGRvAJE6v=XpH33MevpmoA@mail.gmail.com> <CAJfpegtTJmcLVrLOeQbhu4Q6sM0Mi_FRgr+vStF0k95QsWm5uQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:36833 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934082AbdD0NxU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2017 09:53:20 -0400
In-Reply-To: <CAJfpegtTJmcLVrLOeQbhu4Q6sM0Mi_FRgr+vStF0k95QsWm5uQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

[Adding back CC list after I unintentionally dropped it]

On Thu, Apr 27, 2017 at 4:11 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Apr 27, 2017 at 11:53 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Thu, Apr 27, 2017 at 12:26 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>>> Hmm, this is absurd.  Why are we going to all this trouble to find the
>>> origin inode though decoding the file handle when this thing was meant
>>> to be an *optimization*?  Without redirect, we can look up origin just
>>> like we do for merge dirs.  Way faster than decoding a connected
>>> dentry, which is going to result in a readdir of the parent directory
>>> and whatnot.  The only thing we need is a bool "was this copied" flag.
>>>
>>
>> Yes, that is what happens in non-same-lower-fs case.
>> (overlay.fh is a fancy 4 bytes binary boolean blob)
>>
>>> For moved files, decoding the fh might be an optimization over walking
>>> the redirect, but that depends on a various factors, and it might also
>>> be a lot slower...
>>
>> I think we can safely disable by_fh for non-dirs if redirect is not set.
>> redirect_fh will be a bit more efficient with large numlower, but maybe
>> that is less interesting.
>>
>>> But it's needed for the snapshot case, right?
>>
>> It sure is! but the redirect_fh infrastructure is also needed for the next
>> part of the work of NFS export and preserved hardlinks, although in
>> this case it may be used to follow forward and not backwards.
>>
>> It also makes overlayfs more robust to lower layer changes, so less
>> chance for bugs related to mangled lower fs.
>>
>>>
>>> Am I missing something?
>>>
>>
>> Not really. Without the context of this being the first part of a 2 parts
>> work, the amount of hustle that redirect_fh brings to this series should
>> have raised your eyebrows as it did now.
>>
>> I started with the 'stable inode' series for same-fs only case which
>> provides a lot more than just constant inodes.
>>
>> You commented that we should try harder to do constant inodes
>> for non-samefs case, so I yanked out the parts relevant only to
>> constant inodes and relaxed the samefs constrains.
>>
>> Redirect_fh was left in, because:
>> 1. It was always the basis the large work, so was easier to leave it
>>     like this, then to have patches that add it later.
>> 2. It has some merit for optimization and for some constant inode
>>     cases with hardlinks
>> 3. It serves the full work for this code to be reviewed and tested
>>     soon, which is what is happening now.
>>
>> That said, if you feel strongly about it, I could either:
>> - Yank it out and re-introduce in the next part
>> - Leave it in with redirect_fh disabled by default and enabled
>>   by mount option, so at least people could test it and see how
>>   it performs compared to redirect by path in different workloads.
>>
>> Thoughts?
>
> Maybe you misunderstood.  I wasn't saying we don't need
> overlay.origin. I'm saying that it doesn't make sense to use
> overlay.origin for lookup.
>
> Summing up what we know:
>
>  - for constant inode we need a bool flag indicating that this is a
> copied up file or directory,  with that flag, together with redirect
> for regular files, we can do constant inode for samefs and non-samefs
> case.  That bool flag can be the existence of the overlay.origin xattr
>

Agree.

>  - hardlinks: need to set overlay.redirect  when hardlink is created
> from a copied up file; similar to what we do on rename
>

Partly agree.
1. This is not atomic, because hardlink is not created in workdir.
2. Reverse mapping will take care of this anyway. Remember?
    there is an extra hardlink in workdir/inodes with has overlay.redirect
    set on first alias copy up

>  - hardlink un-breaking: need reverse mapping (from lower to overlay);
> not in the scope of this patchset
>

Agree.

>  - NFS export: need reverse mapping; not in the scope of this patchset
>

Agree.

>  - for the snapshotfs case we need a way to keep the overlay in sync
> with a changing lower layer.  It's impossible to atomically update
> overlay.redirect together with the location of the lower file;
> overlay.origin can fix that
>

Correct.

>  - for non-redirect case looking up by overlay.origin is almost surely
> a pessimization
>

Not sure about that.
For directories by fh and by name are probably on par -
At most one lookup of ".." compared to one lookup of d.name.

For non-dir there is a better way that is better than both (see below).

>  - lookup by overlay.origin can work if overlay.redirect would be too
> long to fit in the max xattr len
>

Sure.

>  - for the redirect case looking up by overlay.origin may be faster,
> but may be much slower; hard to determine which to use
>

Here I disagree.
I claim that is always faster to find the lower (disconneccted) dentry
by fh, much faster in fact. See explanation at the bottom.

>  - overlay.origin can be used to verify if the lower path looked up
> with overlay.redirect is indeed the same file/directory that was
> originally copied up.  Not sure if this is useful for anything else
> than the snapshotfs case.
>

Its true. Comparing file handles would be quite easy.

> So my conclusion is that unless we must (snapshotfs, overflow in
> overlay.redirect) we should not be using overlay.origin for looking up
> the lower file.
>

I can live with that. Comparing the lookup result to origin.fh can be
optional based on some 'strict' mount option and resort to lookup by
fh when compare fails.
But we need to reconsider in light of my new suggestion, because
I do believe that finding the lower inode of non-dir is always a win
by fh.

> Even for snapshotfs it might make sense to start with plain lookup
> (with out without overlay.redirect) using overlay.origin to verify and
> falling back to lookup by overlay.origin only on mismatch (and
> updating overlay.redirect).
>
> Do you disagree?
>

So I managed to confuse myself about the technical facts of decoding,
because I was used to dealing only with decoding of dir handles
(for snapshots) and just now added decoding of non-dir.

When decoding a directory handle, it is always being connected up to
root. It sounds harsh, but in fact I think it will always be faster or on par
with regular lookup by path, because:
When looking up backwards until the first connected ancestor, filesystem
always has to read the ".." entry.
When looking up forward by path, then filesystem need to read entries
from connected ancestor by name and that is most likely indexed only
worse then the ".." entry of the backwards lookup.

When decoding directories you also want to get a connected dentry and
verifying is_subdir() makes sense.

HOWEVER, and this is big thing that I missed, when decoding a non-dir
we DON'T need to get a connected dentry.
It's perfectly fine to get a disconnected alias and getting a disconnected
alias is always O(1) for the filesystem.
The only thing we really need from this alias is to know its inode number
(and to know that it is still valid).

So if we encode non-connectable fh for non-dir (like knfsd does by default)
then:
1. decoding them will always be faster then any other lookup method
2. we cannot verify is_subdir() - so what?

What's the worse thing that can happen if the decoded entry is not under
the layer anymore? We only use its inode number, and the only thing we
need to know is that it is unique within the lower layers inode namespace
and we don't need is_subdir() for that.

But I just realized something very very bad about non-samefs case.
We must use made up st_dev for lower layers, we can certainly no
longer use the real lower st_dev.
If we do, then we will have 2 files in 2 different overlay mounts,
who have the same lower inode but 2 different upper inodes with
different content and those 2 overlay files will have the same
st_dev/st_ino.

I just found that in my debian based  kvm-xfstests machine, diff
reports 2 broken hardlinks with different content as equal, because
they have the same st_dev/st_ino.

So in conclusion:
1. Encode non-connectable file handles to non-dir
2. Always try to lookup non-dir by fh first - it's O(1)
3. Non-samefs needs fake st_dev before reporting constant inodes
4. Broken hardlinks should NOT report same inode

Urgh this was long!

Do you agree with my analysis of decoding complexity and the conclusions?

Amir.
