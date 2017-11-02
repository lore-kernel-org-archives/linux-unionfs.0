From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Bug? or normal behavior? if bug, then where? overlay, vfs, xfs,
 or ????
Date: Thu, 2 Nov 2017 09:03:40 +0200
Message-ID: <CAOQ4uxg-bkYnpV146kBgdbgCK9On+=jM1gCe1975J8HKkWxcNg@mail.gmail.com>
References: <59FA4499.2030502@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:47526 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754803AbdKBHDm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 2 Nov 2017 03:03:42 -0400
Received: by mail-yw0-f174.google.com with SMTP id u142so3912495ywg.4
        for <linux-unionfs@vger.kernel.org>; Thu, 02 Nov 2017 00:03:42 -0700 (PDT)
In-Reply-To: <59FA4499.2030502@tlinx.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: L A Walsh <lkml@tlinx.org>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Nov 2, 2017 at 12:03 AM, L A Walsh <lkml@tlinx.org> wrote:
> Trying the overlay fs for first time and am wondering about normal behavior.
>

Linda,

Thanks for the detailed report.
This is an overlayfs behavior with certain "old" file systems (see below).

> After modifying file 'noise' and deleting "file1" in a merged directory, I
> get:
>
>    >  ls -lgG
>    ls: cannot access 'file1': No such file or directory
>    total 26858576
>    ?????????? ?          ?            ? file1
>    -rwxrwxr-x 1 9167721042 Oct  4 09:45 file2*
>    -rwxrwxr-x 1 9167721042 Oct  5 20:09 file3*
>    -rwxrwxr-x 1 9167721042 Nov 13  2011 file4*
>    -rwxrwxr-x 1        496 Oct 28 15:13 noise*
>    -rwxrwxr-x 1        452 Oct  5 20:08 noise.orig*
>    drwxrwxr-x 2         18 Oct  4 09:41 src/
>
>
> I'm a bit concerned about the "white-out" for "file1". Is this how it is
> supposed to appear?  Should I file
> a bug in the kernel's bugzilla-db?
>

Whiteout certainly shouldn't appear that way.
The reason it does is that your upper fs does not support
"d_type" (see below).
It's a "known" issue, but don't know where/if it is documented.
I expect if you look in dmesg, you will see this warning:
  "overlayfs: upper fs needs to support d_type."

Somewhat cryptic message - I agree.
For backward compatibility overlayfs mount does not fail, but leaves
an overlay mount with the flaw you described.

It's actually very good that you pointed this out, because I now
realize we should hard enforce d_type support for NFS export.
We also do not check for lower fs d_type support.
That can also expose old whiteouts in certain setups.

..

>
>
> I then created a new xfs file system and mounted it on '/edge';
>
>    Ishtar:/edge> xfs_info .
>    meta-data=/dev/Data/Edge     isize=256    agcount=32,
>    agsize=16777200 blks     =                   sectsz=4096  attr=2
>    data     =                   bsize=4096   blocks=536870400, imaxpct=5
>             =                   sunit=16     swidth=64 blks
>    naming   =version 2          bsize=4096   ascii-ci=0
>    log      =internal           bsize=4096   blocks=262143, version=2
>             =                   sectsz=4096  sunit=1 blks, lazy-count=1
>    realtime =none               extsz=4096   blocks=0, rtextents=0
>

Your problem is that you do not have "ftype" feature in directory
name format, like this:

naming   =version 2              bsize=4096   ascii-ci=0 ftype=1

Perhaps you have an old version of mkfs.xfs, not sure when
ftype=1 became the default format, but you can try to
  mkfs.xfs -n ftype=1
and follow the breadcrumbs from there.

...
>
> BTW -- is the setup in that bug report even "valid"? I.e. using
> the same single-underlying file system for all 4 directories?
>

Yes. Actually your setup uses 2 different file system instances
for lower and upper, which is fine, but it is perfectly valid, quite
common and even has some advantages to use upper/lower
on the same underlying filesystem instance.

The location of the 4th directory (/edge/merged) does not matter.

Amir.
