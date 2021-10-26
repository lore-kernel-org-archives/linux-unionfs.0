Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04A7CC433EF
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 Oct 2021 06:13:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2AC360FD7
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 Oct 2021 06:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhJZGP3 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 26 Oct 2021 02:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbhJZGP2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 26 Oct 2021 02:15:28 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28053C061745
        for <linux-unionfs@vger.kernel.org>; Mon, 25 Oct 2021 23:13:05 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id x3so7734409uar.13
        for <linux-unionfs@vger.kernel.org>; Mon, 25 Oct 2021 23:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nextdayvideo-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=b0TjQAayNS/XdSGus03YGpXMFGiCB9kcN10XMwC6wVA=;
        b=hTm4KKQ72dhJFKh8khG3PnC45WYA4kldR26vanFBEa2Knc8gJwjS6NTlR0D4eJPdKI
         xiZqIq6hsHvnR+k9XDwB6aC3teXGOTSluKZkQWLVNdsrGzK6vBmfY3kM9okfLOqnEehp
         KDpZGRfQxvBycnL0fGEP7sqjpmK+P676s3Y+ih3IhUUHXQ3EG+odhoyG6IuCHG+yQPBu
         WXyH1PSoKA+JuH2lS0g5Fzl2tGXpoKABRAlWkP8UAh511PBv1g7Q1g78zvXjFICp0Aqn
         9h4vOE4kN13Nx2NQm/Uyodn5IKXc2wdxvBQiTbtWLuNdtum5vQIDq+jb9LToSwTWkgrm
         X2Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=b0TjQAayNS/XdSGus03YGpXMFGiCB9kcN10XMwC6wVA=;
        b=bGwB2ah3GWU/rAHgR/xrs4E6uEKqne68dDEYEMcc+mtpgfJV8cuOE6nDJil16C4/2M
         JrGexkG5yv/oLyPA2QaOFOvJ296ok5Eqt2GjEjPsuDf/VgTcPky+YG4tsmfedmXInz1C
         qsjOkqEfN0YbeK2VeQCqbh0AOiOSodlGxNbR7oj5lWy9YNsrpfiuHEBEcCA9fGzFXz7j
         MlU6zi7c2cvRYLGd9UCvN9IpyJhz9I3B3iZh45m++CEJHjXt+MkBoB/2G1ksNMtd2e7i
         nkNdr1kr7IGPcD3HKHbgR2bhM4gAveGv2D9qvy8va6wM2Pe0LSjsAPOFRWb73Iu/+wok
         rCvw==
X-Gm-Message-State: AOAM533cNO9I9XIHwD2LdmTK8kQPvcjsw+s/TkkmbLncooHTYntpF337
        YP7ZbuHadB+HYPD5RYOUkd3QorXhsCgPp0pDl8ndHt6uTnI=
X-Google-Smtp-Source: ABdhPJxHtJUyZyq5qSw4uQmP/mRAiF+gDWm6RLRfplaADkx8sv8vg1XHl86pdc8JZ83A9xHshmDU8JKWDcKhB/dyZAQ=
X-Received: by 2002:a05:6102:38ce:: with SMTP id k14mr21231703vst.6.1635228783897;
 Mon, 25 Oct 2021 23:13:03 -0700 (PDT)
MIME-Version: 1.0
From:   Carl Karsten <carl@nextdayvideo.com>
Date:   Tue, 26 Oct 2021 01:12:37 -0500
Message-ID: <CADmzSSj6TCP9xE9q-oOjE_MzfDg_WgtOXCXzW1Z5-ZxPZo4jBQ@mail.gmail.com>
Subject: nfs as lower
To:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

I am trying to replicate the setup described below,
(from: https://www.spinics.net/lists/linux-unionfs/msg07098.html )
which implies a successful mount, but all of my attempts error with:

mount: /e/merged: wrong fs type, bad option, bad superblock on
overlay, missing codepage or helper program, or other error.
[ 3640.328337] overlayfs: upper fs does not support tmpfile.
[ 3640.333245] overlayfs: upper fs does not support RENAME_WHITEOUT.
[ 3640.333266] overlayfs: upper fs does not support xattr, falling
back to index=off and metacopy=off.
[ 3640.333281] overlayfs: upper fs missing required features.

script and output:

#!/bin/bash -x
for x in a b c d e
do
    umount /$x/merged
    umount /$x/lower
    rm -rf /$x
    mkdir /$x /$x/lower /$x/upper /$x/work /$x/merged
done

mount -t nfs -o vers=3,ro,noatime
10.21.0.1:/srv/nfs/rpi/buster/root/merged /a/lower
mount -t overlay -o
lowerdir=/a/lower,upperdir=/a/upper,workdir=/a/work,default_permissions
overlay /a/merged

mount -t nfs -o ro,noatime 10.21.0.1:/srv/nfs/rpi/buster/root/merged /b/lower
mount -t overlay -o
lowerdir=/b/lower,upperdir=/b/upper,workdir=/b/work,default_permissions
overlay /b/merged

mount -t nfs -o vers=4.1,ro,noatime
10.21.0.1:/srv/nfs/rpi/buster/root/merged /c/lower
mount -t overlay -o
lowerdir=/c/lower,upperdir=/c/upper,workdir=/c/work,default_permissions
overlay /c/merged

mount -t nfs -o vers=3,ro,noatime,noacl
10.21.0.1:/srv/nfs/rpi/buster/root/merged /d/lower
mount -t overlay -o
lowerdir=/d/lower,upperdir=/d/upper,workdir=/d/work,default_permissions
overlay /d/merged

mount -t nfs -o ro,noatime,noacl
10.21.0.1:/srv/nfs/rpi/buster/root/merged /e/lower
mount -t overlay -o
vers=4.1,noacl,noatime,lowerdir=/e/lower,upperdir=/e/upper,workdir=/e/work,default_permissions
overlay /e/merged


+ for x in a b c d e
+ umount /a/merged
umount.nfs: remote share not in 'host:dir' format
umount.nfs: /a/merged: not mounted
+ umount /a/lower
+ rm -rf /a
+ mkdir /a /a/lower /a/upper /a/work /a/merged

(repeat 5 times)

+ mount -t nfs -o vers=3,ro,noatime
10.21.0.1:/srv/nfs/rpi/buster/root/merged /a/lower
+ mount -t overlay -o
lowerdir=/a/lower,upperdir=/a/upper,workdir=/a/work,default_permissions
overlay /a/merged
mount: /a/merged: wrong fs type, bad option, bad superblock on
overlay, missing codepage or helper program, or other error.

+ mount -t nfs -o ro,noatime 10.21.0.1:/srv/nfs/rpi/buster/root/merged /b/lower
+ mount -t overlay -o
lowerdir=/b/lower,upperdir=/b/upper,workdir=/b/work,default_permissions
overlay /b/merged
mount: /b/merged: wrong fs type, bad option, bad superblock on
overlay, missing codepage or helper program, or other error.

+ mount -t nfs -o vers=4.1,ro,noatime
10.21.0.1:/srv/nfs/rpi/buster/root/merged /c/lower
+ mount -t overlay -o
lowerdir=/c/lower,upperdir=/c/upper,workdir=/c/work,default_permissions
overlay /c/merged
mount: /c/merged: wrong fs type, bad option, bad superblock on
overlay, missing codepage or helper program, or other error.

+ mount -t nfs -o vers=3,ro,noatime,noacl
10.21.0.1:/srv/nfs/rpi/buster/root/merged /d/lower
+ mount -t overlay -o
lowerdir=/d/lower,upperdir=/d/upper,workdir=/d/work,default_permissions
overlay /d/merged
mount: /d/merged: wrong fs type, bad option, bad superblock on
overlay, missing codepage or helper program, or other error.

+ mount -t nfs -o ro,noatime,noacl
10.21.0.1:/srv/nfs/rpi/buster/root/merged /e/lower
+ mount -t overlay -o
vers=4.1,noacl,noatime,lowerdir=/e/lower,upperdir=/e/upper,workdir=/e/work,default_permissions
overlay /e/merged
mount: /e/merged: wrong fs type, bad option, bad superblock on
overlay, missing codepage or helper program, or other error.





> Hi,
>
> I'm using overlayfs with NFS v3 as a lower (mounted read-only) and a
> tmpfs as an upper filesystem. This works nicely since several years.
> So I get a writeable directory tree on an nfs client even the nfs was
> mounted ro.
>
> But then I mount the lower filesystem as NFS v4 (4.2) it does not
> work. Is this combination supposed to work?
> I tested this with kernels up to 5.2 yet but still no success.
>
>
> Here's my current test setup:
>
> NFS server kernel 5.2.0-0.bpo.2-amd64 (Debian 10 with newer kernel)
> NFS client kernel 5.2.0-0.bpo.2-amd64 (Debian 10 with newer kernel)
>
> On the NFS server I did once
> # mkdir /files/scratch/t/etc; echo test-buster > /files/scratch/t/etc/test1
>
> /etc/exports: /files/scratch  11.22.33.128/25(async,ro,no_subtree_check,no_root_squash)
>
> I can do more tests if you tell me what I can change.
> Here are the two tests result, one using nfs v3 the other using NFS v4.
>
> P.S.: After more research I think this may be a problem of a
>       filesystem missing xattr support. Do you have any experiences
>       using overlayfs using NFS v4 as lower fs?
>
> Any hints would be appreciated.
>
> regards Thomas
>
>
>
>
>
>
> NFS v3 mount
> ============
> Result: read and write works
>
>
> + mkdir -p /b/lower /a/upper /a/work /b/merged
> + mount -t nfs -overs=3,ro,noatime buster:/files/scratch/t /b/lower
> mount -t overlay -olowerdir=$lower,upperdir=$upper,workdir=$work,default_permissions overlay $merged || exit 88
> + cat /b/merged/etc/test1
> test-buster
> + sleep 3
> echo "write to merged" > $merged/etc/test1
> + echo 'write to merged'
> + sleep 3
> echo "write new file" > $merged/etc/test3
> + echo 'write new file'
>
> both files test1 and test3 exists with corect content.
>
> Here's the journalctl output of the overlayfs debug messages:
> Sep 16 13:45:04 suenner kernel: overlay: mkdir(work/work, 040000) = 0
> Sep 16 13:45:04 suenner kernel: overlay: tmpfile(work/work, 0100000) = 0
> Sep 16 13:45:04 suenner kernel: overlay: setxattr(work/work, "trusted.overlay.opaque", "0", 1, 0x0) = 0
> Sep 16 13:45:04 suenner kernel: overlay: open(00000000b7f8278e[etc/test1/l], 0100000) -> (00000000df256fc7, 0401100000)
> Sep 16 13:45:07 suenner kernel: overlay: setxattr(a/upper, "trusted.overlay.impure", "y", 1, 0x0) = 0
> Sep 16 13:45:07 suenner kernel: overlay: mkdir(work/#7, 040000) = 0
> Sep 16 13:45:07 suenner kernel: [168B blob data]
> Sep 16 13:45:07 suenner kernel: overlay: rename(work/#7, upper/etc, 0x0)
> Sep 16 13:45:07 suenner kernel: overlay: setxattr(upper/etc, "trusted.overlay.impure", "y", 1, 0x0) = 0
> Sep 16 13:45:07 suenner kernel: overlay: tmpfile(work/work, 0100644) = 0
> Sep 16 13:45:07 suenner kernel: [174B blob data]
> Sep 16 13:45:07 suenner kernel: overlay: link(work/#150994, etc/test1) = 0
> Sep 16 13:45:07 suenner kernel: overlay: open(000000001998a069[etc/test1/u], 0100001) -> (0000000009d1ebd4, 0401100001)
> Sep 16 13:45:10 suenner kernel: overlay: create(etc/test3, 0100666) = 0
> Sep 16 13:45:10 suenner kernel: overlay: open(0000000009d1ebd4[etc/test3/u], 0100001) -> (000000001998a069, 0401100001)
>
>
> The mount info
> buster:/files/scratch/t on /b/lower type nfs (ro,noatime,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=11.22.33.211,mountvers=3,mountport=45356,mountproto=udp,local_lock=none,addr=11.22.33.211)
> overlay on /b/merged type overlay (rw,relatime,lowerdir=/b/lower,upperdir=/a/upper,workdir=/a/work,default_permissions)
>
>
> -----------------------------------------------------------------------------------------------
> NFS v4 mount
> ============
> Result: read works, write does not work
>
> + mkdir -p /b/lower /a/upper /a/work /b/merged
> + mount -t nfs -oro,noatime buster:/files/scratch/t /b/lower
> + mount -t overlay -olowerdir=/b/lower,upperdir=/a/upper,workdir=/a/work,default_permissions overlay /b/merged
>
> + cat /b/merged/etc/test1
> test-buster
> + sleep 3
> echo "write to merged" > $merged/etc/test1
> + echo 'write to merged'
> /home/lange/fairesearch/xfai/overlay-test: line 32: /b/merged/etc/test1: Operation not supported
> + sleep 3
> echo "write new file" > $merged/etc/test3
> + echo 'write new file'
> /home/lange/fairesearch/xfai/overlay-test: line 34: /b/merged/etc/test3: Operation not supported
>
>
> Here's the journalctl output of the overlayfs debug messages:
> Sep 16 13:40:57 suenner kernel: overlay: mkdir(work/work, 040000) = 0
> Sep 16 13:40:57 suenner kernel: overlay: tmpfile(work/work, 0100000) = 0
> Sep 16 13:40:57 suenner kernel: overlay: setxattr(work/work, "trusted.overlay.opaque", "0", 1, 0x0) = 0
> Sep 16 13:40:57 suenner kernel: overlay: open(00000000ca5c0310[etc/test1/l], 0100000) -> (0000000023701f29, 0401100000)
> Sep 16 13:41:00 suenner kernel: overlay: setxattr(a/upper, "trusted.overlay.impure", "y", 1, 0x0) = 0
> Sep 16 13:41:00 suenner kernel: overlay: mkdir(work/#3, 040000) = 0
> Sep 16 13:41:00 suenner kernel: overlay: rmdir(work/#3) = 0
> Sep 16 13:41:03 suenner kernel: overlay: mkdir(work/#4, 040000) = 0
> Sep 16 13:41:03 suenner kernel: overlay: rmdir(work/#4) = 0
>
> The mount info:
> buster:/files/scratch/t on /b/lower type nfs4 (ro,noatime,vers=4.2,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=11.22.33.136,local_lock=none,addr=11.22.33.211)
> overlay on /b/merged type overlay (rw,relatime,lowerdir=/b/lower,upperdir=/a/upper,workdir=/a/work,default_permissions)
>
> A manual test writing to the files using strace shows:
> openat(AT_FDCWD, "/b/merged/etc/test1", O_WRONLY|O_CREAT|O_TRUNC, 0666) = -1 EOPNOTSUPP (Operation not supported)
> openat(AT_FDCWD, "/


-- 
Carl K
