From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 2/3] ovl: set origin xattr for merge dir on lookup
Date: Wed, 8 Nov 2017 15:30:52 +0200
Message-ID: <CAOQ4uxiD-i+=ZYBQVyXgNXjgas9xrt+SeGn+HaxdRtGhjb+uVg@mail.gmail.com>
References: <1510090740-7216-1-git-send-email-amir73il@gmail.com>
 <1510090740-7216-3-git-send-email-amir73il@gmail.com> <03198975-d870-d49e-f807-01f3d805d001@huawei.com>
 <CAOQ4uxjfE+vO9TDwHsuCD5Zwj9-7ZF9km-PibnTooK61ShKQJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:54307 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752519AbdKHNax (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Nov 2017 08:30:53 -0500
Received: by mail-yw0-f196.google.com with SMTP id w5so2248916ywg.11
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Nov 2017 05:30:53 -0800 (PST)
In-Reply-To: <CAOQ4uxjfE+vO9TDwHsuCD5Zwj9-7ZF9km-PibnTooK61ShKQJw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Miao Xie <miaoxie@huawei.com>

On Wed, Nov 8, 2017 at 10:27 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Nov 8, 2017 at 8:59 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> On 2017/11/8 5:38, Amir Goldstein Wrote:
>>> For old existing merge dirs whose "origin" xattr was not set at copy up
>>> time, we amend the situation on lookup.
>>>
>>> If no origin fh is stored in upper of a merge dir, store fh of upper most
>>> lower dir or 'null' fh if lower does not support file handles. We do this
>>> so we can filter out whiteouts in case lower dir is removed offline and
>>> then upper dir becomes a pure upper in a future mount.
>>>
>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>> ---
[...]
>
>> At the same time, consider the opposite side, all directories move from a base filesystem which 'file
>> handle' supported to a not supported one. It will trigger NULL pointer crash in ovl_verify_origin_fh()
>> because fh is NULL but ofh was existed. Following change good ?
>>
>> -       if (!ofh)
>> +       if (!ofh || !fh)
>>                 return -ENODATA;
>>
>
> Thanks for pointing that out, but change is not good because it looses the
> information about finding a stored null_fh.
> If we do want to stick with ovl_null_fh trick, I could pass in &ovl_null_fh
> instead of NULL, in case of !ovl_can_decode_fh(origin->d_sb).
> This fixes the NULL pointer crash and I can remove this special case,

Zhangyi,

I pushed a fix rebased on overlayfs-next from today to
https://github.com/amir73il/linux/commits/ovl-whiteouts

Tested it with xfs and with xfs without uuid (test patch).
I did not test the migration cases that you listed.

Please review.
Thanks,
Amir.
