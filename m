From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [ANNOUNCE] fsck.overlayfs: update master branch
Date: Thu, 1 Feb 2018 12:16:21 +0800
Message-ID: <2b05eb7b-63f2-39c9-1009-7199e94de7fe@huawei.com>
References: <19ac0eea-d57f-169b-503b-ad734b30a495@huawei.com>
 <CAOQ4uxjk8F-a4s7JdcFJXWeU9+VD-b3dddagQjVWEg0F=+5ftg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:46336 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751324AbeBAERE (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 23:17:04 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 537681C561613
        for <linux-unionfs@vger.kernel.org>; Thu,  1 Feb 2018 12:16:51 +0800 (CST)
In-Reply-To: <CAOQ4uxjk8F-a4s7JdcFJXWeU9+VD-b3dddagQjVWEg0F=+5ftg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>

On 2018/2/1 4:23, Amir Goldstein Wrote:
> On Wed, Jan 31, 2018 at 12:23 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> Hi All,
>>
>> The master branch on my overlayfs-progs [1] has been updated.
>>
>> No feature add, just handle comments form Amir in last iterations and
>> fix some bugs:
>> - Improve header comments for many functions, these becomes more readable.
> 
> Looking very good!
> FYI the "header comment" which I requested, are the comment on the top of
> the file. But hey I'm not complaining ;-)
> 
>> - Fix some path manipulation bugs in path.c.
> 
> Sigh. Too bad you couldn't find a path manipulation library for joinpath()
> and basename2(). Things like that should really never be re-implemented.
> If you really have to implement them or really want to, then you should
> write simple unit tests that run on 'make test' to verify that your helpers
> do what you claim they do for all the listed inputs, because right now,
> I doubt that you have good test coverage for complex path composing
> just from running fsck.overlay itself.
> 

Sorry, I didn't found such functions in C library (glibc), so have to re-implement it.
I have already test all listed inputs (not post it), maybe I can post it latter.

Thanks,
Yi.

>> - Improve impurities check.
>> - Split out functions and constants from kernel into overlayfs.c/.h.
>> - Update README, split out and detail TODO list.
>>
> 
> Looks good!
> 
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
