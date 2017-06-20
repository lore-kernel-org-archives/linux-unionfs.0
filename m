From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: System-wide unique st_dev
Date: Tue, 20 Jun 2017 13:13:36 +0300
Message-ID: <CAOQ4uxhFeRsx+w7s=dDiBsFMZP5OZ2J_rYhT1dLgA-0ephrs-A@mail.gmail.com>
References: <20170619152210.15930-1-chandan@linux.vnet.ibm.com>
 <CAOQ4uxh-x2+csds8S-VJNen8J8W8RcTAfQUuzBQ2zJ2QSJsRNw@mail.gmail.com> <2761461.UuV2ky4quO@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33411 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750979AbdFTKNh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jun 2017 06:13:37 -0400
Received: by mail-oi0-f68.google.com with SMTP id j63so1835692oiy.0
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2017 03:13:36 -0700 (PDT)
In-Reply-To: <2761461.UuV2ky4quO@localhost.localdomain>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Tue, Jun 20, 2017 at 12:39 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> On Monday, June 19, 2017 11:15:37 PM IST Amir Goldstein wrote:
>> On Mon, Jun 19, 2017 at 6:22 PM, Chandan Rajendra
>> <chandan@linux.vnet.ibm.com> wrote:
>> > On an overlayfs instance having lower and upper dirs on the same
>> > filesystem, stat(2) on a file residing on the lower dir will
>>
>> This is not what the patch should do. The patch should deal with !samefs case.
>>
>> > provide st_dev corresponding to the lower filesystem's bdev. Later, After
>> > the lower file is copied-up, stat(2) on the file provides st_dev
>> > corresponding to the overlayfs' pseudo device. Hence we have a mismatch
>> > in the st_dev value that is provided to the userspace.
>>
>> All this is true, but you patch should not be bothering with constant st_dev
>> over copy up. my patches do that.
>> Your patch should provide the pseudo st_dev for lower, which my patch
>> "relax same fs constrain for constant st_ino" needs to be able to use
>> the lower (pseudo) dev as the constant st_dev across copy up.
>
> Ok. But we continue to use overlayfs' anon dev when reporting st_dev for
> directories right?
>

Right... which means I was wrong about reporting the overlay st_dev for
upper non-dir, because this could create st_dev/st_ino collision.
Dir st_ino come from the overlay inode number pool and non-dir st_ino
come from underlying fs.

Easiest is to just return the real st_dev for pure upper, i.e.:

+       if (ofs->upper_mnt && ofs->upper_mnt->mnt_sb->s_dev == dev)
+               return dev;
+

I am not sure that the benefits of allocating a pseudo dev also for upper
layer are worth it. At the end of the day, a pure upper overlay object is
really the same object as the underlying fs object and reporting a
pseudo dev for those objects isn't going to help with du -x, so why bother.

Amir.
