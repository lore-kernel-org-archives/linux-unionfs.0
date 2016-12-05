From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Overlayfs snapshots pre announce
Date: Mon, 5 Dec 2016 15:39:48 +0200
Message-ID: <CAOQ4uxh-ZNDcv7sAxX-yaCN=_LLK6qRWpA6w3LScsL6K5S0vWA@mail.gmail.com>
References: <CAOQ4uxjXpd_Fy3vBfzcXZYudPoZyXkrLEofLNQ0YPB6HeD9ZgA@mail.gmail.com>
 <CAJfpegsLuy5DjeGEeEs3=RgBkWuku9PSesN1Dk=5pKtS_zHdkg@mail.gmail.com>
 <CAJfpegtJ7pZNZA3op7iZwCPynYcSCGB6EZ3rZrmdc3zSKucdpA@mail.gmail.com> <CAOQ4uxi1-aC8YiBSxSvCzu7-8TJRGjwAn6DBgV3wWF+Vpwf5Ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f169.google.com ([209.85.210.169]:35056 "EHLO
        mail-wj0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751096AbcLENkV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 5 Dec 2016 08:40:21 -0500
Received: by mail-wj0-f169.google.com with SMTP id v7so290462343wjy.2
        for <linux-unionfs@vger.kernel.org>; Mon, 05 Dec 2016 05:39:50 -0800 (PST)
In-Reply-To: <CAOQ4uxi1-aC8YiBSxSvCzu7-8TJRGjwAn6DBgV3wWF+Vpwf5Ww@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Dec 2, 2016 at 4:47 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Dec 2, 2016 at 4:34 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
...
>> Okay, so doing multiple snapshots on the fly would work something like this:
>>
>> - there are SNAP{1..N} and a MASTER branch
>> - view of snapshot(i) is an overlay of (from bottom up) MASTER;
>> SNAP{N}; ...; SNAP{i}
>>
>> Modification of master would always go to the latest snapshot branch (SNAP{N}).
>>
>
>
> Yes, something like that for API, my initial thought is:
>
> mount -t snapshot -o upperdir=/lower none /mnt
>
> ...take snapshot 0:
> mkdir -p 0/upper 0/work 0/snapshot
> mount -t overlay -o lowerdir=/lower,upperdir=0/upper,workdir=0/work
> none 0/snapshot
> mount -t snapshot -o remount,snapshot=0/snapshot none /mnt
>
> And something along the same lines for rotating to a new 1/snapshot.
>
> Once the active snapshot is 1/snapshot, to access the content of snapshot 0,
> need to remount it as follows:
>
> umount 0/snapshot
> mount -t overlay -o lowerdir=0/upper:1/snapshot none 0/snapshot
>
>> The big change to overlayfs is to allow splitting the bottom layer.
>>
>
> In my view, it is less important to rotate the snapshot view without umount,
> because I see the snapshots as a means for restore and not a live mount
> that must be kept mounted at all times.
>
> I do need, however, as you can see to allow a single level of stacking
> for overlayfs
> over overlayfs as the underlying lowermost ro layer.
> That is enough to serve any number of readonly snapshots, e.g:
> mount -t overlay -o lowerdir=0/upper,1/upper,2/upper:3/snapshot none 0/snapshot
>

FYI, I implemented ./run --sn=N test
for recycling N snapshot as described above.

3 directory rename tests (rename-move-dir, rename-pop-dir,
rename-new-pop-dir) fail on snapshot consistency after 1 recycle
due to a problem I failed to anticipate - redirect by file handle skips
all middle layers and goes directly to master.
With single snapshot that it correct, but with more than 1 snapshot,
it is not.

Essentially, the problem of following redirect from SNAP(N) to SNAP(N-1)
is equivalent the problem of exporting a stable file handle from overlayfs,
so it can be NFS exported. The file handle may be created from lower inode
and should not become stale after copy up, so there should be a lookup
method to find an upper inode with redirect to the lower file handle.
If a solution is found, it could be used to optimize constant ino readdir.
The only thing I can think of is a map of "lower fh"->"upper fh" in the root
of every layer, that is updated on every copy up.
This idea is hard to chew on, so would be glad to know if you have other ideas.

Amir.
