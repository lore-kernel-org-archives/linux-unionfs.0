From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Overlayfs snapshots pre announce
Date: Fri, 2 Dec 2016 16:47:13 +0200
Message-ID: <CAOQ4uxi1-aC8YiBSxSvCzu7-8TJRGjwAn6DBgV3wWF+Vpwf5Ww@mail.gmail.com>
References: <CAOQ4uxjXpd_Fy3vBfzcXZYudPoZyXkrLEofLNQ0YPB6HeD9ZgA@mail.gmail.com>
 <CAJfpegsLuy5DjeGEeEs3=RgBkWuku9PSesN1Dk=5pKtS_zHdkg@mail.gmail.com> <CAJfpegtJ7pZNZA3op7iZwCPynYcSCGB6EZ3rZrmdc3zSKucdpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f178.google.com ([209.85.210.178]:34433 "EHLO
        mail-wj0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759587AbcLBOrP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Dec 2016 09:47:15 -0500
Received: by mail-wj0-f178.google.com with SMTP id mp19so234453115wjc.1
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Dec 2016 06:47:14 -0800 (PST)
In-Reply-To: <CAJfpegtJ7pZNZA3op7iZwCPynYcSCGB6EZ3rZrmdc3zSKucdpA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Dec 2, 2016 at 4:34 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Dec 2, 2016 at 3:05 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Fri, Dec 2, 2016 at 10:30 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> Hi Miklos,
>>>
>>> Wanted to give you a heads up on upcoming announcement for
>>> overlayfs snapshots POC, just to give you a sense of what's been
>>> driving my recent overlayfs development efforts
>>> and also because I am eager to share the news ;-).
>>
>> Okay, so this is sort of reverse-overlay.  For this to be useful,
>> however, there would have to be a way to make the snapshot *after*
>> /mnt is mounted, no?
>

Yes and no.
First, there could be use cases where the *after* part is not
critical. For example, setup a snapshot mount over directory foo before
an app is going to make changes to directory foo.
This could be useful maybe for the pre install package snapshot.

Second, I do intend to support taking a snapshots on live mount,
which would useful for more use cases. And also taking a new snapshot
and rotating the old one.

That is going to be a lot more challenging then the existing POC
and will require among other thing to support freeze of the snapshot
mount.

> Okay, so doing multiple snapshots on the fly would work something like this:
>
> - there are SNAP{1..N} and a MASTER branch
> - view of snapshot(i) is an overlay of (from bottom up) MASTER;
> SNAP{N}; ...; SNAP{i}
>
> Modification of master would always go to the latest snapshot branch (SNAP{N}).
>


Yes, something like that for API, my initial thought is:

mount -t snapshot -o upperdir=/lower none /mnt

...take snapshot 0:
mkdir -p 0/upper 0/work 0/snapshot
mount -t overlay -o lowerdir=/lower,upperdir=0/upper,workdir=0/work
none 0/snapshot
mount -t snapshot -o remount,snapshot=0/snapshot none /mnt

And something along the same lines for rotating to a new 1/snapshot.

Once the active snapshot is 1/snapshot, to access the content of snapshot 0,
need to remount it as follows:

umount 0/snapshot
mount -t overlay -o lowerdir=0/upper:1/snapshot none 0/snapshot

> The big change to overlayfs is to allow splitting the bottom layer.
>

In my view, it is less important to rotate the snapshot view without umount,
because I see the snapshots as a means for restore and not a live mount
that must be kept mounted at all times.

I do need, however, as you can see to allow a single level of stacking
for overlayfs
over overlayfs as the underlying lowermost ro layer.
That is enough to serve any number of readonly snapshots, e.g:
mount -t overlay -o lowerdir=0/upper,1/upper,2/upper:3/snapshot none 0/snapshot

To that end, I posted a fix for lockdep annotation of stacked
overlayfs instances.
Going to send a v2 soon.

Cheers,
Amir.
