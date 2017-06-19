From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [xfstests PATCH] overlay: test whiteout check in impure dir
Date: Mon, 19 Jun 2017 14:28:08 +0800
Message-ID: <235c78f4-1e0f-8c76-a705-8f4f01318659@huawei.com>
References: <1497844419-23824-1-git-send-email-yi.zhang@huawei.com>
 <CAOQ4uxgKAnLBnjF2ynTW-iLbV9m647XhnzquV37xzkBwqG-=5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([45.249.212.189]:7887 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752531AbdFSG22 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Jun 2017 02:28:28 -0400
In-Reply-To: <CAOQ4uxgKAnLBnjF2ynTW-iLbV9m647XhnzquV37xzkBwqG-=5Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com

On 2017/6/19 13:40, Amir Goldstein Wrote:
> On Mon, Jun 19, 2017 at 6:53 AM, zhangyi (F) <yi.zhang@huawei.com> wrote: 
>> --- a/tests/overlay/group
>> +++ b/tests/overlay/group
>> @@ -33,3 +33,4 @@
>>  028 auto copyup quick
>>  029 auto quick
>>  030 auto quick perms
>> +031 auto quick
> 
> Maybe add "whiteout"

Indeed, I missed this one. Thanks for your suggestion.


Thanks,

ZhangYi
