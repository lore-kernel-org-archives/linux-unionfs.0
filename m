Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:33629 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727844AbeHaS1N (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 31 Aug 2018 14:27:13 -0400
Subject: Re: [PATCH v5 3/3] generic/471: add syncfs test
From: cgxu519 <cgxu519@gmx.com>
References: <1513324055-77618-1-git-send-email-cgxu519@icloud.com>
 <1513324055-77618-3-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxgf=btK-MKed7-8_nmpfO-UnPyVJ4RyTtK1hMQuU8Y=-g@mail.gmail.com>
 <63598ea1-8fd3-1003-a5b1-cb177a9380d8@gmx.com>
Message-ID: <6c2125c0-5a89-4a67-7a2c-2bebe8dd5b7e@gmx.com>
Date: Fri, 31 Aug 2018 22:19:16 +0800
MIME-Version: 1.0
In-Reply-To: <63598ea1-8fd3-1003-a5b1-cb177a9380d8@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Chengguang Xu <cgxu519@icloud.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>


Hi Amir,

It seems godown will cause side effect on ext4/tune2fs, mount an ext4 
filesystem after running godown,
then tune2fs -l <dev> complains like below. so definitely it will not 
pass d_type check.


[root@x201 xfstests-dev]# tune2fs -l /dev/mapper/test-test1
tune2fs 1.44.2 (14-May-2018)
tune2fs: Superblock checksum does not match superblock while trying to 
open /dev/mapper/test-test1
Couldn't find valid filesystem superblock.


Thanks,
Chengguang


On 08/30/2018 11:12 AM, cgxu519 wrote:
> Hi Amir,
>
> I think I tested both xfs/ext4. Let me have a look at the code for 
> detail.
>
>
> Thanks,
>
> Chengguang
>
>
> On 08/26/2018 10:53 PM, Amir Goldstein wrote:
>> On Fri, Dec 15, 2017 at 9:48 AM Chengguang Xu <cgxu519@icloud.com> 
>> wrote:
>>> Inspired by syncfs bug of overlayfs which does not sync dirtyinodes in
>>> underlying filesystem.
>>> Run syncfs and shutdown filesystem(or underlying filesystem of 
>>> overlayfs)
>>> to check syncfs result.
>>>
>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>> ---
>> Hi Chengguang,
>>
>> I just noticed that this test (now generic/474) is skipped for 
>> overlay over ext4
>> for a strange looking reason - it seems that in the overlay_mount() 
>> call from
>> _scratch_cycle_mount() the function hits
>> _notrun "upper fs needs to support d_type".
>>
>> This doesn't happen on my test system with overlay over xfs.
>> Did you happen to test this with overlay over ext4 at the time?
>> Will you have time to look into this?
>>
>> Thanks,
>> Amir.
>
