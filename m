From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v8 0/9] Overlayfs: constant st_ino/d_ino for non-samefs
Date: Wed, 8 Nov 2017 15:40:28 +0200
Message-ID: <CAOQ4uxjtTek_79chEiswmhNd4S8SnDzicH6p2_XwS7HfVM5ZjA@mail.gmail.com>
References: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
 <CAJfpegvBEXgi=P8Sciv+U6VqcjsLJChR1OdwZyZA_PoL3MNTNA@mail.gmail.com> <CAOQ4uxjvFVk5xs_zj1Ga4o-0GGStGWfYsNhY8ot+zTeB3HoBNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:43098 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752467AbdKHNk3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Nov 2017 08:40:29 -0500
Received: by mail-yw0-f193.google.com with SMTP id y75so2303561ywg.0
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Nov 2017 05:40:29 -0800 (PST)
In-Reply-To: <CAOQ4uxjvFVk5xs_zj1Ga4o-0GGStGWfYsNhY8ot+zTeB3HoBNw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Nov 8, 2017 at 2:01 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Nov 8, 2017 at 12:53 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Tue, Nov 7, 2017 at 5:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> Miklos,
>>>
>>> This version provides a solution for some interesting non-samefs cases:
>>> - All the ext* family
>>> - Many other fs with default encode_fh
>>> - xfs that is not huge with overlay 'xino' mount option
>>> - tmpfs that is not on a machine with jurassic uptime with 'xino'
>>>
>>> I tested this with Chandan's upstream overlay/041 xfstest for
>>> consistent d_ino in non-samefs setup. Results are:
>>> - Test passes for ext4
>>> - Test fails for xfs
>>> - Test fails for xfs with OVERLAY_MOUNT_OPTIONS=-oxino,
>>>   but this is because of a test bug
>>> - With the test bug fix available at [2] test passes
>>>   with xfs and OVERLAY_MOUNT_OPTIONS=-oxino
>>>
>>> All the exportfs tests also pass with these changes and
>>> either ext4 or xfs with OVERLAY_MOUNT_OPTIONS=-oxino.
>>>
>>> Changes since v7:
>>> - Drop patches for building impure cache for non-samefs subdirs
>>> - Dropped patch "update cache version of impure parent on rename"
>>>   because it is not relevant to this series
>>> - Remap lower inode numbers for 32bit inode file systems
>>> - Add mount option 'xino' for opting-in to use high inode bits
>>
>> I the meantime I went and committed v7 (with the noted changes) and
>> based my cleanup for ovl_fill_super() on top of that.  So that's now
>
> Nice cleanup!
> I don't like setting of s_d_op inside ovl_get_lowerstack().
> IMO should add ufs->remote boolean because it is interesting anyway
> and set s_d_op in ovl_fill_super() itself.
>

Mikos,

ovl_fill_super() cleanup caused 3 regressions with xfstest
check -overlay -g overlay/quick
overlay/011 overlay/035 - mount failures instead of r/o mount
overlay/022 - dentries in use after mount failure:

BUG: Dentry ffff880079fee2f8{i=42ff,n=upper}  still in use (-1)
[unmount of overlay overlay]
BUG: Dentry ffff880079fe0338{i=2008d81,n=upper}  still in use (1)
[unmount of xfs vdf]
BUG: Dentry ffff880079fda700{i=3000100,n=ovl-lower}  still in use (1)
[unmount of xfs vdf]

Another regression caused by tweaking OVL_WHITEOUTS patch:
overlay/038 - A fix to the readdir regression is pushed to:
https://github.com/amir73il/linux/commits/ovl-fixes

>> pushed out to overlayfs-next, hopefully not invalidating too much of
>> your work.
>
> Not a problem. most of the work on v8 was on the last patches.
> I'll send 2 cleanup patches that make get_attr() code a bit cleaner to my taste.
>
>>
>> The -oxino patches are interesting, but maybe we should leave them
>> brewing for another cycle.  Do you agree?
>>
>
> Sure. your call.
>
>> I'll try and look at the other series posted by you and Vivek to see
>> what else would fit in to 4.15.
>
> OK. I need to address a small comment by Zhangyi on restoring origin fh.
> Will push a fix today.
>

Pushed rebased and fixes version to:
https://github.com/amir73il/linux/commits/ovl-whiteouts

Thanks,
Amir.
