From: Miklos Szeredi <miklos@szeredi.hu>
Subject: (unknown)
Date: Thu, 14 Jul 2016 16:22:20 +0200
Message-ID: <CAJfpegvnc7CcfAmyNY5wt6u0ExOnr0kNnf+OmFU-Yky-dxoNAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:36248 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbcGNOWW (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 14 Jul 2016 10:22:22 -0400
Received: by mail-oi0-f54.google.com with SMTP id w18so119388722oiw.3
        for <linux-unionfs@vger.kernel.org>; Thu, 14 Jul 2016 07:22:22 -0700 (PDT)
Subject: 
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Andrey Melnikov <temnota.am@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, zhangaihua <zhangaihua1@huawei.com>

On Thu, Jul 14, 2016 at 12:08 PM, Andrey Melnikov <temnota.am@gmail.com> wrote:
> 2016-07-14 12:53 GMT+03:00 Miklos Szeredi <miklos@szeredi.hu>:
>> On Thu, Jul 14, 2016 at 11:42 AM, Andrey Melnikov <temnota.am@gmail.com> wrote:
>>> 2016-07-14 12:23 GMT+03:00 Miklos Szeredi <miklos@szeredi.hu>:
>>>> On Tue, Jul 12, 2016 at 11:01 PM, Andrey Melnikov <temnota.am@gmail.com> wrote:
>>>>> Ping.
>>>>>
>>>>> 2016-06-30 14:04 GMT+03:00 Andrey Jr. Melnikov <temnota.am@gmail.com>:
>>>>>>  Fix overlayfs inotify interaction - use d_real_inode() helper
>>>>>>  to resolve real (underlying) inode. Without this inotify is not functional on
>>>>>>  overlayfs.
>>>>
>>>> Have you tried the alternative patch from Aihua Zhang:
>>>>   https://lkml.org/lkml/2016/7/7/83
>>>
>>> No. My patch add small overhead, lookup inode once when add inotify
>>> watch, this patch - lookup inode on each operation. For what?
>>
>> I'm afraid that your patch won't work for all notifications (like
>> directory modification).
>
> It work with dir's too:

Digging deeper into this...

Both patches appear to fix most of the problems with inotify on
overlayfs. However Aihua's solution looks better for several reasons.

To understand why, we need to look at what the patches do conceptually:

Andrey's patch: when a watch is placed on file on overlayfs it
actually makes inotify watch the real underlying file.  This is only
true for non-directories.  For directories it still watches the
overlay inode.

Aihua's patch: when an event occurs it directs it to the overlay inode
instead of the real underlying inode

The biggest plus for Aihua's patch is that it will work even if the
file was first on the lower layer and then copied up, while the watch
is there.  This is because the  watch is on the overlay inode, which
stays the same through the copy-up.

Other pluses are that it automatically works for fanotify/dnotify as well.

It does have a small performance impact due to the extra pointer
dereference, but that shouldn't be an issue in real life.

I checked the relevant testcases in LTP and inotify04 is still failing
with Aihua's patch, which needs to be looked into.

Thanks,
Miklos
