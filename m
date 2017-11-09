From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH 2/3] ovl: set origin xattr for merge dir on lookup
Date: Thu, 9 Nov 2017 12:20:14 +0800
Message-ID: <8c8f1b61-ad6e-58b6-0e0f-4b7d5b0887ea@huawei.com>
References: <1510090740-7216-1-git-send-email-amir73il@gmail.com>
 <1510090740-7216-3-git-send-email-amir73il@gmail.com>
 <03198975-d870-d49e-f807-01f3d805d001@huawei.com>
 <CAOQ4uxjfE+vO9TDwHsuCD5Zwj9-7ZF9km-PibnTooK61ShKQJw@mail.gmail.com>
 <CAOQ4uxiD-i+=ZYBQVyXgNXjgas9xrt+SeGn+HaxdRtGhjb+uVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:37376 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751495AbdKIEUk (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Nov 2017 23:20:40 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id EBA8F1D2BF790
        for <linux-unionfs@vger.kernel.org>; Thu,  9 Nov 2017 12:20:25 +0800 (CST)
In-Reply-To: <CAOQ4uxiD-i+=ZYBQVyXgNXjgas9xrt+SeGn+HaxdRtGhjb+uVg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Miao Xie <miaoxie@huawei.com>

On 2017/11/8 21:30, Amir Goldstein Wrote:
> On Wed, Nov 8, 2017 at 10:27 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Wed, Nov 8, 2017 at 8:59 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>> On 2017/11/8 5:38, Amir Goldstein Wrote:
>>>> For old existing merge dirs whose "origin" xattr was not set at copy up
>>>> time, we amend the situation on lookup.
>>>>
>>>> If no origin fh is stored in upper of a merge dir, store fh of upper most
>>>> lower dir or 'null' fh if lower does not support file handles. We do this
>>>> so we can filter out whiteouts in case lower dir is removed offline and
>>>> then upper dir becomes a pure upper in a future mount.
>>>>
>>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>>> ---
> [...]
>>
>>> At the same time, consider the opposite side, all directories move from a base filesystem which 'file
>>> handle' supported to a not supported one. It will trigger NULL pointer crash in ovl_verify_origin_fh()
>>> because fh is NULL but ofh was existed. Following change good ?
>>>
>>> -       if (!ofh)
>>> +       if (!ofh || !fh)
>>>                 return -ENODATA;
>>>
>>
>> Thanks for pointing that out, but change is not good because it looses the
>> information about finding a stored null_fh.
>> If we do want to stick with ovl_null_fh trick, I could pass in &ovl_null_fh
>> instead of NULL, in case of !ovl_can_decode_fh(origin->d_sb).
>> This fixes the NULL pointer crash and I can remove this special case,
> 
> Zhangyi,
> 
> I pushed a fix rebased on overlayfs-next from today to
> https://github.com/amir73il/linux/commits/ovl-whiteouts
> 
> Tested it with xfs and with xfs without uuid (test patch).

Hi Amir:

Sorry for the late, I prefer to use ovl_null_fh too, this patch looks good to me.

> I did not test the migration cases that you listed.

As far as know, docker container migration will tar all things in upper to lower layer,
may be I thought to much and we may no need to deal with this case now.

Thanks,
Yi.

> Please review.
> Thanks,
> Amir.
> 
