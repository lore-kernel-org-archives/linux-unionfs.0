From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [OpenWrt-Devel] Device tree issues with TL-WDR4900 (mpc85xx) and
 kernel 4.0.1
Date: Mon, 15 Jun 2015 10:20:16 +0200
Message-ID: <CAJfpegvbBWmxouP=vt7e7_W38TGWcbOcHnUOifuzFhOsjhYKag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:34022 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbbFOIUR (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 15 Jun 2015 04:20:17 -0400
Received: by qgf75 with SMTP id 75so24353912qgf.1
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jun 2015 01:20:17 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Roman Yeryomin <leroi.lists@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>, Wojciech Dubowik <Wojciech.Dubowik@neratec.com>, Heiner Kallweit <hkallweit1@gmail.com>, OpenWrt Development List <openwrt-devel@lists.openwrt.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Jun 11, 2015 at 2:01 PM, Miklos Szeredi <mszeredi@suse.cz> wrote:
> On 7 May 2015 at 15:49, Felix Fietkau <nbd@openwrt.org> wrote:
>> On 2015-05-07 08:01, Wojciech Dubowik wrote:
>>> Try to boot with kernel locking enabled. I have seen jffs2 deadlocks on
>>> readdir. As far as I remember
>>> with this patch it went through but I don't know anymore whether I have
>>> changed sth in config.
>>>
>>> Have a look at (search engine...) [PATCH] fs: jffs2: Add setup code for
>>> spi nor flash.
>>>
>>> Even with this patch I got some possible dead lock warnings so it might
>>> be just a partial cure. BTW it's
>>> a bit scary for future use. Looks like jffs2 doesn't get enough care...
>> I believe the locking issues are an overlayfs regression, maybe even
>> the same one as this one (which I fixed years ago):
>> http://linux-fsdevel.vger.kernel.narkive.com/XRtXLDlf/patch-1-2-overlayfs-fix-a-deadlock-in-ovl-dir-read-merged
>>
>> I believe this is the cause of the regression:
>>
>> commit 49c21e1cacd74a8c83407c70ad860c994e606e25
>> Author: Miklos Szeredi <mszeredi@suse.cz>
>> Date:   Sat Dec 13 00:59:42 2014 +0100
>>
>
> I'm working on 4.0 support for ar71xx and found that
> /etc/rc.d/S00sysfixtime is not able to finish it's job after second
> boot after flashing (t.i. after overlayfs is switched to jffs). I've
> run strace and found that find hangs on the very last getdents64 call
> (before calling it succesfully many times on previous
> files/directories).
> I've reverted every change up to
> 49c21e1cacd74a8c83407c70ad860c994e606e25 to overlayfs and it started
> working. Applying 49c21e1cacd74a8c83407c70ad860c994e606e25 back breaks
> it. So this commit is indeed the cause of regression.
>
> Miklos, any ideas how to fix it in current tree? I'm using 4.0.5 now
> but AFAIK there were no more changes to overlayfs.

What's the full mount setup?  (cat /proc/mounts)

Thanks,
Miklos
