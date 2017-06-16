From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [RFC PATCH] ovl:fix rmdir problem on impure dir
Date: Fri, 16 Jun 2017 18:56:47 +0800
Message-ID: <f15ca158-a9ac-cebc-3e4a-456bf900d37f@huawei.com>
References: <1497585310-34952-1-git-send-email-yi.zhang@huawei.com>
 <CAOQ4uxjnVfY+jqgUxrhw0nD6FHUOaqkTynOQX2cm2MaLRd+cOg@mail.gmail.com>
 <3c7e4be9-03dc-ddeb-9460-87e6c0c6ba83@huawei.com>
 <CAOQ4uxhj+s=hSHD-185RCBuvXgggnOfdaYxZmstBWp_hsLCbEQ@mail.gmail.com>
 <CAJfpeguRBifj4D1w4REFN1vHsRzdKTXmj8Mk-BHNnHx9vEQyFw@mail.gmail.com>
 <CAJfpegvKRr5GzH86jxzfSScV+jDKSKr+4R4MLgX_qkADx5Hnug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:8306 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752523AbdFPK5H (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Jun 2017 06:57:07 -0400
In-Reply-To: <CAJfpegvKRr5GzH86jxzfSScV+jDKSKr+4R4MLgX_qkADx5Hnug@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, miaoxie@huawei.com

On 2017/6/16 17:57, Miklos Szeredi wrote:
> On Fri, Jun 16, 2017 at 11:50 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Fri, Jun 16, 2017 at 10:55 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> On Fri, Jun 16, 2017 at 10:39 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>>> On 2017/6/16 14:02, Amir Goldstein Wrote:
>>>>> On Fri, Jun 16, 2017 at 6:55 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>>>>> Hi All:
>>>>>>
>>>>>> I found another problem about impure upper dir which have left
>>>>>> whiteout files. If an "impure && not merged" upper dir have
>>>>>> left whiteout files(last mount created), ovl cannot clear this
>>>>>> dir when we removing it, which may lead to rmdir fail or temp
>>>>>> file left in workdir.
>>
>> Thanks for the report and patch.
>>
>> I think the unlink failures are indicative of a bigger problem,
>> though: we optimize directory reading (and empty checking) based on
>> the MERGE flag.  This results in the whiteout being returned in the
>> directory listing in your test case.
>>
>> Fortunately we now have a way to identify directories that may contain
>> whiteouts: the "overlay.origin" xattr.  So I think we should switch to
>> using that instead of the MERGE flag for deciding whether we can use
>              ^^^^^^^^^
> That should be "in addition to" not "instead of".
> 

I think these have been done by Amir in his patch "ovl: consistent st_ino/d_ino" on June 1.  :)


Thanks,

ZhangYi
