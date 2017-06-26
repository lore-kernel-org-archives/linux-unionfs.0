From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH] ovl: no direct iteration for dir with copy up origin
Date: Mon, 26 Jun 2017 15:58:40 +0800
Message-ID: <521869b4-d075-f103-bd65-32bb548f71ad@huawei.com>
References: <1498400069-12840-1-git-send-email-amir73il@gmail.com>
 <cde690a2-9288-9f5a-62a6-17f8e6b96fbb@huawei.com>
 <CAOQ4uxgJNCEYKotHg5MMeek6CM5PdbinWE-AUa_NwfTarxxiog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([45.249.212.189]:8381 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751367AbdFZH7Y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 26 Jun 2017 03:59:24 -0400
In-Reply-To: <CAOQ4uxgJNCEYKotHg5MMeek6CM5PdbinWE-AUa_NwfTarxxiog@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On 2017/6/26 13:31, Amir Goldstein Wrote:
> On Mon, Jun 26, 2017 at 4:22 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> On 2017/6/25 22:14, Amir Goldstein Wrote:
>>> If a non-merge dir in an overlay mount has an overlay.origin xattr, it
>>> means it was once an upper merge dir, which may contain whiteouts and
>>> then the lower dir was removed under it.
>>>
>>> Do not iterate real dir directly in this case to avoid exposing whiteouts.
>>>
>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>> ---
>>>  fs/overlayfs/readdir.c | 29 +++++++++++++++++++++++++----
>>>  1 file changed, 25 insertions(+), 4 deletions(-)
>>>
>>> Yi,
>>>
>>> You missed a very big spot and so did I in review.
>>> Your patch doen't hide whiteouts from readdir and it doesn't
>>> even pass you own xfstest...
>>>
>>> Anyway, here are the missing parts picked from my impure readdir
>>> patch.
>>>
>>
>> Hi Amir,
>>
>> Yes, I missed whiteouts check in readdir because I saw your readdir
>> patch has already fix it, so my xfstest test this case. Do you
>> think we should merge this two patch ?
>>
> 
> Yes, only two problems with my readdir patch:
> 1. Miklos rejected it (for now)
> 2. It only complements your V2 patch (impure), not your V3 patch (origin)
> 

Indeed, thanks for this patch.

> So we need those two patches, it's fine if they stay separate because
> they fix two related, but distinguished problems (expose whiteouts and rmdir).
> 
> I just want to highlight that I did not test the lower layer with origin case,
> not sure if you did? There were bugs related to unexpected overlay objects
> in lower layer in the past, see xfstest overlay/014 for example test.
> 

I tested the lower layer with origin case baseed on these two patches, there
is no problem, whiteouts are not exposed and rmdir/rename execute successfully.

> So if you can, please post a patch to extend test overlay/031 to mount
> the "origin"  with whiteout dir as lower layer and repeat the "ls" and
> "rmdir" tests.
> 

Okay, I am glad to post it, thanks.

Thanks,
ZhangYi.
