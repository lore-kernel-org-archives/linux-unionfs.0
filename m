Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:57823 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727233AbeH3HNK (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 30 Aug 2018 03:13:10 -0400
Subject: Re: [PATCH v5 3/3] generic/471: add syncfs test
References: <1513324055-77618-1-git-send-email-cgxu519@icloud.com>
 <1513324055-77618-3-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxgf=btK-MKed7-8_nmpfO-UnPyVJ4RyTtK1hMQuU8Y=-g@mail.gmail.com>
From: cgxu519 <cgxu519@gmx.com>
Message-ID: <63598ea1-8fd3-1003-a5b1-cb177a9380d8@gmx.com>
Date: Thu, 30 Aug 2018 11:12:55 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgf=btK-MKed7-8_nmpfO-UnPyVJ4RyTtK1hMQuU8Y=-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Chengguang Xu <cgxu519@icloud.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

Hi Amir,

I think I tested both xfs/ext4. Let me have a look at the code for detail.


Thanks,

Chengguang


On 08/26/2018 10:53 PM, Amir Goldstein wrote:
> On Fri, Dec 15, 2017 at 9:48 AM Chengguang Xu <cgxu519@icloud.com> wrote:
>> Inspired by syncfs bug of overlayfs which does not sync dirtyinodes in
>> underlying filesystem.
>> Run syncfs and shutdown filesystem(or underlying filesystem of overlayfs)
>> to check syncfs result.
>>
>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>> ---
> Hi Chengguang,
>
> I just noticed that this test (now generic/474) is skipped for overlay over ext4
> for a strange looking reason - it seems that in the overlay_mount() call from
> _scratch_cycle_mount() the function hits
> _notrun "upper fs needs to support d_type".
>
> This doesn't happen on my test system with overlay over xfs.
> Did you happen to test this with overlay over ext4 at the time?
> Will you have time to look into this?
>
> Thanks,
> Amir.
