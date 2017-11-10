From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v8 0/9] Overlayfs: constant st_ino/d_ino for non-samefs
Date: Fri, 10 Nov 2017 11:24:02 +0200
Message-ID: <CAOQ4uxgVSKpmh+5MhC4Sqv19_sHrfOsmVvn_nVeD9ygDOR6Wkg@mail.gmail.com>
References: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
 <CAJfpegvBEXgi=P8Sciv+U6VqcjsLJChR1OdwZyZA_PoL3MNTNA@mail.gmail.com>
 <CAOQ4uxjvFVk5xs_zj1Ga4o-0GGStGWfYsNhY8ot+zTeB3HoBNw@mail.gmail.com>
 <CAOQ4uxjtTek_79chEiswmhNd4S8SnDzicH6p2_XwS7HfVM5ZjA@mail.gmail.com>
 <CAOQ4uxinxHV_3XEh6dPhenypDQ3=PCOw5yvg2juguK_YtoRacw@mail.gmail.com>
 <CAJfpegujOAJYfbT3CUWy20CyCUQnmDP5=aQLYYrnjV+TU1WnZA@mail.gmail.com> <CAOQ4uxiu-A+_Amwzh69s07DDJ05gaZYV1gQb=8G7eu=s2GFnxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:45663 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbdKJJYD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Nov 2017 04:24:03 -0500
Received: by mail-yw0-f193.google.com with SMTP id c186so5023248ywb.2
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Nov 2017 01:24:03 -0800 (PST)
In-Reply-To: <CAOQ4uxiu-A+_Amwzh69s07DDJ05gaZYV1gQb=8G7eu=s2GFnxw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Nov 9, 2017 at 1:25 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, Nov 9, 2017 at 11:33 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Wed, Nov 8, 2017 at 5:50 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> On Wed, Nov 8, 2017 at 3:40 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>> On Wed, Nov 8, 2017 at 2:01 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>>> On Wed, Nov 8, 2017 at 12:53 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>>>> On Tue, Nov 7, 2017 at 5:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>>>>> Miklos,
>>>>>>>
>>>>>>> This version provides a solution for some interesting non-samefs cases:
>>>>>>> - All the ext* family
>>>>>>> - Many other fs with default encode_fh
>>>>>>> - xfs that is not huge with overlay 'xino' mount option
>>>>>>> - tmpfs that is not on a machine with jurassic uptime with 'xino'
>>>>>>>
>>>>>>> I tested this with Chandan's upstream overlay/041 xfstest for
>>>>>>> consistent d_ino in non-samefs setup. Results are:
>>>>>>> - Test passes for ext4
>>>>>>> - Test fails for xfs
>>>>>>> - Test fails for xfs with OVERLAY_MOUNT_OPTIONS=-oxino,
>>>>>>>   but this is because of a test bug
>>>>>>> - With the test bug fix available at [2] test passes
>>>>>>>   with xfs and OVERLAY_MOUNT_OPTIONS=-oxino
>>>>>>>
>>>>>>> All the exportfs tests also pass with these changes and
>>>>>>> either ext4 or xfs with OVERLAY_MOUNT_OPTIONS=-oxino.
>>>>>>>
>>>>>>> Changes since v7:
>>>>>>> - Drop patches for building impure cache for non-samefs subdirs
>>>>>>> - Dropped patch "update cache version of impure parent on rename"
>>>>>>>   because it is not relevant to this series
>>>>>>> - Remap lower inode numbers for 32bit inode file systems
>>>>>>> - Add mount option 'xino' for opting-in to use high inode bits
>>>>>>
>>>>>> I the meantime I went and committed v7 (with the noted changes) and
>>>>>> based my cleanup for ovl_fill_super() on top of that.  So that's now
>>>>>
>>>>> Nice cleanup!
>>>>> I don't like setting of s_d_op inside ovl_get_lowerstack().
>>>>> IMO should add ufs->remote boolean because it is interesting anyway
>>>>> and set s_d_op in ovl_fill_super() itself.
>>>>>
>>>>
>>>> Mikos,
>>>>
>>>> ovl_fill_super() cleanup caused 3 regressions with xfstest
>>>> check -overlay -g overlay/quick
>>>> overlay/011 overlay/035 - mount failures instead of r/o mount
>>>
>>> Fixed by "fix free of ERR_PTR oe"
>>>
>>>> overlay/022 - dentries in use after mount failure:
>>>>
>>>> BUG: Dentry ffff880079fee2f8{i=42ff,n=upper}  still in use (-1)
>>>> [unmount of overlay overlay]
>>>> BUG: Dentry ffff880079fe0338{i=2008d81,n=upper}  still in use (1)
>>>> [unmount of xfs vdf]
>>>> BUG: Dentry ffff880079fda700{i=3000100,n=ovl-lower}  still in use (1)
>>>> [unmount of xfs vdf]
>>>>
>>>
>>> Fixed by "fix double path_put() on error"
>>>
>>>> Another regression caused by tweaking OVL_WHITEOUTS patch:
>>>> overlay/038 - A fix to the readdir regression is pushed to:
>>>> https://github.com/amir73il/linux/commits/ovl-fixes
>>>
>>> Pushed those 2 fixes and 2 more review bug fixes to ovl-fixes branch.
>>
>> Thanks for testing and looking at the issues.  I've now set up
>> xfstests  as well in my test environment...
>>
>
> You may want to try out Ted's kvm-xfstests if you haven't already.
> I've set it up to also run unionmount testsuite tests from within xfstests:
>
> https://github.com/amir73il/xfstests-bld/commits/overlayfs-devel
>
>> Force pushed branch with fixes to overlayfs-next.
>>
>
> Looks good.
> Will test.
>

Tested. All good.

Did you get a chance to look at the 2 cleanup patches on overlayfs-devel:

3c964f63efcf ovl: factor out ovl_map_dev_ino() helper
8e97d9da4f2f ovl: store layer index in ovl_layer

Do you want me to post them proper?
A variant of them was posted within the v8 series.

BTW, there is a locking order issue for nested overlay I am working on
which I intend to post later today. I hope it can make it to v4.15 as well.

Thanks,
Amir.
