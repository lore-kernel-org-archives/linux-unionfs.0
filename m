From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [RFC PATCH v3] ovl: fix rmdir problem on impure dir
Date: Mon, 26 Jun 2017 09:28:20 +0800
Message-ID: <bd88159a-05c4-81bd-275a-2afb1f5a9f8a@huawei.com>
References: <1498283869-17623-1-git-send-email-yi.zhang@huawei.com>
 <CAOQ4uxjsc6TiMyNWuoKUk3pNa_jEa3Ov_mfFfB6jvEd+XR9xVQ@mail.gmail.com>
 <CAOQ4uxib18RfpYyMTUoCVLAnNoYhyk0yhq0NE=voPDGzEo8x2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:8795 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751429AbdFZB2e (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 25 Jun 2017 21:28:34 -0400
In-Reply-To: <CAOQ4uxib18RfpYyMTUoCVLAnNoYhyk0yhq0NE=voPDGzEo8x2Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com

On 2017/6/25 15:28, Amir Goldstein Wrote:
> On Sat, Jun 24, 2017 at 6:55 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Sat, Jun 24, 2017 at 8:57 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>> If an "impure && not merged" upper dir have left whiteouts
> 
> 
> The mention of "impure" in commit message and title is
> slightly out of date the with the patch itself.
> An "origin" upper with whiteouts and no copy ups is not
> considered "impure".
> 

I will reedit it, Thank you for your guidance.

Thanks,
ZhangYi.

>>> (last mount created), ovl cannot clear this dir when we
>>> removing it, which may lead to rmdir fail or temp file left
>>> in workdir.
>>>
>>> Simple reproducer:
>>>   mkdir lower upper work merge
>>>   mkdir -p lower/dir
>>>   touch lower/dir/a
>>>   mount -t overlay overlay -olowerdir=lower,upperdir=upper,\
>>>     workdir=work merge
>>>   rm merge/dir/a
>>>   umount merge
>>>   rm -rf lower/*
>>>   touch lower/dir  (*)
>>>   mount -t overlay overlay -olowerdir=lower,upperdir=upper,\
>>>     workdir=work merge
>>>   rm -rf merge/dir
>>>
>>> Syslog dump:
>>>   overlayfs: cleanup of 'work/#7' failed (-39)
>>>
>>> (*): if we are not creat this file, the result is different:
>>>   rm: cannot remove "dir/": Directory not empty
>>>
>>> This patch add explicitly check of OVL_XATTR_ORIGIN, use
>>> (merge || origin) to indicate the dir may have whiteouts.
>>> Finally, check and clean up the dir when deleting it.
>>>
>>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>>>
>>
>> Looks good.
>>
>> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> 
