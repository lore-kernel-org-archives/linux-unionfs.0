From: L A Walsh <lkml@tlinx.org>
Subject: Bug? or normal behavior? if bug, then where?  overlay, vfs, xfs,
 or ????
Date: Wed, 01 Nov 2017 15:03:05 -0700
Message-ID: <59FA4499.2030502@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([173.164.175.65]:36572 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933341AbdKAWTd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 1 Nov 2017 18:19:33 -0400
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id vA1M35hJ055276
        for <linux-unionfs@vger.kernel.org>; Wed, 1 Nov 2017 15:03:07 -0700
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Trying the overlay fs for first time and am wondering about normal behavior.

After modifying file 'noise' and deleting "file1" in a merged directory, I
get:

    >  ls -lgG
    ls: cannot access 'file1': No such file or directory
    total 26858576
    ?????????? ?          ?            ? file1
    -rwxrwxr-x 1 9167721042 Oct  4 09:45 file2*
    -rwxrwxr-x 1 9167721042 Oct  5 20:09 file3*
    -rwxrwxr-x 1 9167721042 Nov 13  2011 file4*
    -rwxrwxr-x 1        496 Oct 28 15:13 noise*
    -rwxrwxr-x 1        452 Oct  5 20:08 noise.orig*
    drwxrwxr-x 2         18 Oct  4 09:41 src/


I'm a bit concerned about the "white-out" for "file1". 
Is this how it is supposed to appear?  Should I file
a bug in the kernel's bugzilla-db?



How I got here:
My kernel from "uname -a" is:
Linux Ishtar 4.13.9-Isht-Van #1 SMP Thu Oct 26 16:41:08 PDT 2017 x86_64 
GNU/Linux

I used a pre-existing directory "/local/test" as a 'lower':


    >  /bin/ls  -lgGR /local/test
    /local/test:
    total 35811432
    -rwxrwxr-x 1 9167721042 Nov 13  2011 file1
    -rwxrwxr-x 1 9167721042 Oct  4 09:45 file2
    -rwxrwxr-x 1 9167721042 Oct  5 20:09 file3
    -rwxrwxr-x 1 9167721042 Nov 13  2011 file4
    -rwxrwxr-x 1        452 Oct  5 20:08 noise
    -rwxrwxr-x 1        420 Oct  5 19:57 noise.orig
    drwxrwxr-x 2         18 Oct  4 09:41 src

    /local/test/src:
    total 8952856
    -rwxrwxr-x 1 9167721042 Nov 13  2011 file1




in a pre-existing 'xfs' file system:

    >  xfs_info /local/test
    meta-data=/dev/Data/Local    isize=256    agcount=32,
    agsize=12582896 blks     =                   sectsz=4096  attr=2
    data     =                   bsize=4096   blocks=402652672,imaxpct=10
             =                   sunit=16     swidth=16 blks
    naming   =version 2          bsize=4096   ascii-ci=0
    log      =internal           bsize=4096   blocks=32768, version=2
             =                   sectsz=4096  sunit=1 blks, lazy-count=1
    realtime =none               extsz=4096   blocks=0, rtextents=0




I then created a new xfs file system and mounted it on '/edge';

    Ishtar:/edge> xfs_info .
    meta-data=/dev/Data/Edge     isize=256    agcount=32,
    agsize=16777200 blks     =                   sectsz=4096  attr=2
    data     =                   bsize=4096   blocks=536870400, imaxpct=5
             =                   sunit=16     swidth=64 blks
    naming   =version 2          bsize=4096   ascii-ci=0
    log      =internal           bsize=4096   blocks=262143, version=2
             =                   sectsz=4096  sunit=1 blks, lazy-count=1
    realtime =none               extsz=4096   blocks=0, rtextents=0



created directories in it;

    >  cd /edge
    >  mkdir merged overlays overlays/upper work


and mounted an overlay fs on "/edge/merged" with:

    sudo mount -t overlay none -olowerdir=/local/test,\
                                  upperdir=/edge/overlays/upper,\
                                  workdir=/edge/work /edge/merged


After editing 'noise' and removing 'file1', I got the listing
at the top.  The 'file1' in the top listing can't be deleted.
It is only present/visible in the 'merged' directory, but
does seem to make the "overlayfs" unusable for general
purposes, so I'm guessing it's a bug?

Of note: a **likely** Red-Herring, is this RH bug report:

    https://bugzilla.redhat.com/show_bug.cgi?id=1319507

(I say red-herring, as I'm not using RH, and there is
no real data in the bug other than similar symptoms
running over xfs).

BTW -- is the setup in that bug report even "valid"? I.e. using
the same single-underlying file system for all 4 directories?

Thanks!
-linda
