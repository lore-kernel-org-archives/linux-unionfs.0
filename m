From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v8 0/9] Overlayfs: constant st_ino/d_ino for non-samefs
Date: Wed, 8 Nov 2017 14:01:44 +0200
Message-ID: <CAOQ4uxjvFVk5xs_zj1Ga4o-0GGStGWfYsNhY8ot+zTeB3HoBNw@mail.gmail.com>
References: <1510073889-11657-1-git-send-email-amir73il@gmail.com> <CAJfpegvBEXgi=P8Sciv+U6VqcjsLJChR1OdwZyZA_PoL3MNTNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:44466 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752191AbdKHMBp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Nov 2017 07:01:45 -0500
Received: by mail-yw0-f196.google.com with SMTP id k11so2075220ywh.1
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Nov 2017 04:01:45 -0800 (PST)
In-Reply-To: <CAJfpegvBEXgi=P8Sciv+U6VqcjsLJChR1OdwZyZA_PoL3MNTNA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Nov 8, 2017 at 12:53 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Nov 7, 2017 at 5:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Miklos,
>>
>> This version provides a solution for some interesting non-samefs cases:
>> - All the ext* family
>> - Many other fs with default encode_fh
>> - xfs that is not huge with overlay 'xino' mount option
>> - tmpfs that is not on a machine with jurassic uptime with 'xino'
>>
>> I tested this with Chandan's upstream overlay/041 xfstest for
>> consistent d_ino in non-samefs setup. Results are:
>> - Test passes for ext4
>> - Test fails for xfs
>> - Test fails for xfs with OVERLAY_MOUNT_OPTIONS=-oxino,
>>   but this is because of a test bug
>> - With the test bug fix available at [2] test passes
>>   with xfs and OVERLAY_MOUNT_OPTIONS=-oxino
>>
>> All the exportfs tests also pass with these changes and
>> either ext4 or xfs with OVERLAY_MOUNT_OPTIONS=-oxino.
>>
>> Changes since v7:
>> - Drop patches for building impure cache for non-samefs subdirs
>> - Dropped patch "update cache version of impure parent on rename"
>>   because it is not relevant to this series
>> - Remap lower inode numbers for 32bit inode file systems
>> - Add mount option 'xino' for opting-in to use high inode bits
>
> I the meantime I went and committed v7 (with the noted changes) and
> based my cleanup for ovl_fill_super() on top of that.  So that's now

Nice cleanup!
I don't like setting of s_d_op inside ovl_get_lowerstack().
IMO should add ufs->remote boolean because it is interesting anyway
and set s_d_op in ovl_fill_super() itself.

> pushed out to overlayfs-next, hopefully not invalidating too much of
> your work.

Not a problem. most of the work on v8 was on the last patches.
I'll send 2 cleanup patches that make get_attr() code a bit cleaner to my taste.

>
> The -oxino patches are interesting, but maybe we should leave them
> brewing for another cycle.  Do you agree?
>

Sure. your call.

> I'll try and look at the other series posted by you and Vivek to see
> what else would fit in to 4.15.

OK. I need to address a small comment by Zhangyi on restoring origin fh.
Will push a fix today.

Thanks,
Amir.
