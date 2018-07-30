Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:10179 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726370AbeG3J2M (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 30 Jul 2018 05:28:12 -0400
Subject: Re: [xfstests PATCH 0/3] overlay: enhance fsck.overlay test cases
References: <20180728084242.33918-1-yi.zhang@huawei.com>
 <CAOQ4uxjoDK2Pm53gCv-g1h1RHDfWSeQpR4aFCs2ZgAMJX1M+cw@mail.gmail.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <e032f6a3-7c64-a886-a289-3aff50f3cc27@huawei.com>
Date: Mon, 30 Jul 2018 15:54:14 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjoDK2Pm53gCv-g1h1RHDfWSeQpR4aFCs2ZgAMJX1M+cw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On 2018/7/30 13:56, Amir Goldstein Wrote:
> On Sat, Jul 28, 2018 at 11:42 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> Hi All,
>>
>> These are fsck.overlay program related patch set. The first patch correct
>> the exit code of fsck.overlay in the existing 3 test cases, the second
>> patch introduce a stress case to test stability, and the final patch add
>> some exception cases to test exception handling process of fsck.overlay.
>>
>> The fsck.overlay program also was undate at:
>>
>> https://github.com/hisilicon/overlayfs-progs/tree/next
>>
>> All these three patches have been tested with the new fsck.overlay,
>> please review.
>>
> 
> So if Eryu tests your changes without updating to new fsck.overlay,
> tests will start to fail. Is that the expected behavior?
> 
> Right now it may not be a big nuisance, but you should declare which
> is "the official" version of fsck.overlay to test with xfstest -
> is it next? master?
> Probably best if you ask Eryu to hold back on merging changes not
> compatible with current fsck.overlay master, until the master branch
> is updated and would be useful to ANNOUNCE the overlayfs-progs
> updates to the list with the gist of changes.
> 

Hi Amir,
Thanks for your suggestion. I will update these fsck.overlay changes to
master branch and post an ANNOUNCE email.

I originally wanted to wait for some comments, if any, before I update
these changes to fsck.overlay's master branch. I will follow your
suggested steps next time, and will post patch set before update to master
branch if it deserve to review.

Thanks,
Yi.

