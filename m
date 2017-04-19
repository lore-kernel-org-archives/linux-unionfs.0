From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC][PATCH 00/13] overlayfs stable inodes
Date: Wed, 19 Apr 2017 15:52:31 +0200
Message-ID: <CAJfpegumzAZbvyWgfYaLtG1L7LF_Ob2zgA55Hz5H5Ctv7DoJ=Q@mail.gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgtiDr9GEgjAsRHLeOo=HTobf-qwZ0bZLyjrhLyNiTt4A@mail.gmail.com>
 <CAJfpegsQTd8SgHRFcuEJMgjLjNW45vyuUiPPKZLC4bv_OJOmGA@mail.gmail.com> <CAOQ4uxh1VmeB1WGuP4sXyzR0oeQ_ux2hd+9vXM=UbsL+cxTwXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35212 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763889AbdDSNwc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Apr 2017 09:52:32 -0400
Received: by mail-oi0-f68.google.com with SMTP id g11so4665518oib.2
        for <linux-unionfs@vger.kernel.org>; Wed, 19 Apr 2017 06:52:32 -0700 (PDT)
In-Reply-To: <CAOQ4uxh1VmeB1WGuP4sXyzR0oeQ_ux2hd+9vXM=UbsL+cxTwXQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Wed, Apr 19, 2017 at 12:37 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Apr 19, 2017 at 12:16 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Tue, Apr 18, 2017 at 8:37 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>
>>> On Mon, Apr 17, 2017 at 2:59 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> > Overlayfs inodes are considered unstable in several aspects,
>>> > because on a copy up event:
>>> > 1. st_ino can change
>>> > 2. st_dev can change
>>> > 3. hardlinks are broken
>>> > 4. NFS handle would become stale
>>> > 5. content of read-only file descriptor would become stale
>>> >
>>> > This patch set 'stabilizes' overlayfs inodes w.r.t. st_ino/st_dev
>>> > and takes some big steps in the direction of stabilizing hardlinks
>>> > and NFS handles.
>>> >
>>>
>>> I realized I forgot to mention in the cover letter that stable inodes
>>> are only available for the overlay configuration where all layers
>>> are on the same underlying fs and that underlying fs support
>>> NFS export (I think all eligible upper fs support NFS export anyway).
>>
>> Hmm,  we could keep inode numbers stable across copy up even if layers
>> are on different filesystems:  just need to use a separate st_dev for
>> lower layers and keep st_dev and st_inode constant.  The only extra
>> thing needed compared to the samefs case is the allocation of dummy
>> device numbers for lower layers.  Of course "find -xdev" and the like
>> still won't work properly, and we wouldn't be able to provide sane
>> d_ino values in readdir.
>
> Not sure that is going to be worth the effort, but we'll see.
> Anyway, not sure if you already read far enough into the series,
> but the fact that overlay inodes are hashed by stable inode ino
> helps solving a lot of the problems with minimal code changes,
> so in the grand scheme of things, I think it would be easier to
> say: same_fs can give you POSIX. non same_fs cannot.

The effort should be small, and the reward is substantially less weird behavior.

In fact I looked and SUSv4
(http://pubs.opengroup.org/onlinepubs/9699919799/) only talks about
"mount point" in the context of directories.  It does *not* require
st_dev to be the as the st_dev of the parent directory for
non-directories.  The only requirement is that st_ino and st_dev
together uniquely identify a file in the system, which is why we need
to generate a dummy st_dev for lower files in this case.  It also
explicitly only talks about directories in the context of "-xdev" and
the like.

So even in the non-samefs case we could stamp it with "POSIX
compliant" because strictly speaking it is.

If that's not enough, I think we *can* do unified ino space even in
most non-samefs cases.  And here's why: look at the inode numbers of
any filesystem; they will always be "small" so we can just partition
the 64 bit ino space between layers and map inode numbers into its own
partition.  This does not work in the general case, and it is a hack.
But it's a very simple hack and it probably works fine. Similar thing
is assumed by the 32bit compat code, which just returns EOVERFLOW if
the ino happens to be too large, which I guess doesn't happen too
often for most filesystems...

Thanks,
Miklos
