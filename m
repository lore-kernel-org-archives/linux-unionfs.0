From: L A Walsh <lkml@tlinx.org>
Subject: Re: Bug? or normal behavior? if bug, then where? overlay, vfs, xfs,
 or ????
Date: Sun, 05 Nov 2017 01:17:22 -0700
Message-ID: <59FEC912.4000005@tlinx.org>
References: <59FA4499.2030502@tlinx.org> <CAOQ4uxg-bkYnpV146kBgdbgCK9On+=jM1gCe1975J8HKkWxcNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([173.164.175.65]:54364 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750932AbdKEIR2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 5 Nov 2017 03:17:28 -0500
In-Reply-To: <CAOQ4uxg-bkYnpV146kBgdbgCK9On+=jM1gCe1975J8HKkWxcNg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

Amir Goldstein wrote:
>
>   
>> I then created a new xfs file system and mounted it on '/edge';
>>
>>    Ishtar:/edge> xfs_info .
>>    meta-data=/dev/Data/Edge     isize=256    agcount=32,
>>    agsize=16777200 blks     =                   sectsz=4096  attr=2
>>    data     =                   bsize=4096   blocks=536870400, imaxpct=5
>>             =                   sunit=16     swidth=64 blks
>>    naming   =version 2          bsize=4096   ascii-ci=0
>>    log      =internal           bsize=4096   blocks=262143, version=2
>>             =                   sectsz=4096  sunit=1 blks, lazy-count=1
>>    realtime =none               extsz=4096   blocks=0, rtextents=0
>>
>>     
>
> Your problem is that you do not have "ftype" feature in directory
> name format, like this:
>
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
>
> Perhaps you have an old version of mkfs.xfs, not sure when
> ftype=1 became the default format, but you can try to
>   mkfs.xfs -n ftype=1
>   
----  
Ah... no .. last I was told, if you turned on ftype=1,
you had to also pull in crc'ing of all the meta-info.
That has problems -- causes errors where there would be no
problem, and was never tested on mature file systems that were
already fragmented.


Do you know if it was separated from crc32 -- for some inexplicable reason,
if you wanted ftype, then the crc option would be forced on for you.

I didn't want it as I didn't want it to flag errors in metadata that
wasn't crucial and didn't want the speed slowdown.  Sigh.

The problem on crc'ing the meta data, is that there is ALOT more meta
data where detecting it will do more harm than good (like what nanosecond
the file was last changed, for example).  I first ran into it
taking the disk offline when I changed the guid on a newly formatted disk.
That was fixed, but that was a warning shot...   How annoying.


 From what you say, though only the upper layer needs to have the ftype=1.
That's a new filesystem, so shouldn't make that much difference, but the
lower fs's I'd want to use overlays with are older file systems.  But
it sounds like those can remain as they are?

(assuming they don't become upper layers in some multi-layer
scenario)...
