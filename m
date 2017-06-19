From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [xfstests PATCH] overlay: test whiteout check in impure dir
Date: Mon, 19 Jun 2017 19:27:31 +0800
Message-ID: <ee98b8ea-5e90-a258-5e8e-1b9cb23e0f3a@huawei.com>
References: <1497844419-23824-1-git-send-email-yi.zhang@huawei.com>
 <CAOQ4uxgKAnLBnjF2ynTW-iLbV9m647XhnzquV37xzkBwqG-=5Q@mail.gmail.com>
 <235c78f4-1e0f-8c76-a705-8f4f01318659@huawei.com>
 <20170619102557.GA28689@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:8337 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753891AbdFSL3C (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Jun 2017 07:29:02 -0400
In-Reply-To: <20170619102557.GA28689@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com

On 2017/6/19 18:25, Eryu Guan wrote:
> On Mon, Jun 19, 2017 at 02:28:08PM +0800, zhangyi (F) wrote:
>> On 2017/6/19 13:40, Amir Goldstein Wrote:
>>> On Mon, Jun 19, 2017 at 6:53 AM, zhangyi (F) <yi.zhang@huawei.com> wrote: 
>>>> --- a/tests/overlay/group
>>>> +++ b/tests/overlay/group
>>>> @@ -33,3 +33,4 @@
>>>>  028 auto copyup quick
>>>>  029 auto quick
>>>>  030 auto quick perms
>>>> +031 auto quick
>>>
>>> Maybe add "whiteout"
>>
>> Indeed, I missed this one. Thanks for your suggestion.
> 
> I can add it at commit time if everything works as expected (I haven't
> run the test myself yet, but will do :).
> 

Thanks a lot.

ZhangYi.
