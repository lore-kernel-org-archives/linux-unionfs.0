From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: Question about ovl_dentry_weird
Date: Thu, 30 Mar 2017 19:58:49 +0800
Message-ID: <b32b9303-37a6-f798-e529-edee774bcc0b@huawei.com>
References: <f3a67b6a-b8fb-78ab-fadd-504fa5d76a10@huawei.com>
 <CAOQ4uxhvrAefbxcYXv5JfBmKN==8Yo7QKiaFAa6YS8VSfpvf=A@mail.gmail.com>
 <a64cfa4b-f56a-2c30-e621-d28e40056944@huawei.com>
 <CAOQ4uxjCa1XSg_VhirsUj78CAxa5=r=AXnKpOSF09dUU4Wg6=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:4823 "EHLO
        dggrg01-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751217AbdC3L6x (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 30 Mar 2017 07:58:53 -0400
In-Reply-To: <CAOQ4uxjCa1XSg_VhirsUj78CAxa5=r=AXnKpOSF09dUU4Wg6=Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, miaoxie@huawei.com, laiyuanyuan.lai@huawei.com, Miklos Szeredi <miklos@szeredi.hu>



on 2017/3/30 16:52, Amir Goldstein wrote:
> On Thu, Mar 30, 2017 at 11:22 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> On 2017/3/30 15:03, Amir Goldstein wrote:
>>>> Hi:
>>>> Current overlayfs does not support underlying filesystem which have "weird" d_flags (like DCACHE_OP_HASH，
>>>> DCACHE_OP_COMPARE, DCACHE_OP_REVALIDATE, etc). So we cannot support fs have it's own d_hash, d_compare and
>>>> d_revalidate functions.
>>>
>>> Not accurate. d_revalidate() is allowed for lower, but not for upper
>>> (ovl_dentry_remote()).
>>>
>>
>> Thank you for the corrections, I see it in the ovl_lower_dir().
>>
>>>>
>>>> Do you have a TODO plan to support it in a future version ?
>>>>
>>>
>>> Which of the constrains is relevant to your use case? (which of the flags)
>>> Do you need it for lower / upper or both?
>>> Is it a proprietary file system of a known one you need to support?
>>>
>>
>> We want to use d_hash(), d_compare() and d_revalidate() to our own proprietary file system
>> (not a remote fs, not widely used, and it's file name is case-insensitive) for lower
>> and upper both, and we also need to use d_revalidate() to do some special handling.
>>
>> I see there were many other rarely used（?）file systems also use d_hash(), d_compare(),
>> d_revalidate() in kernel(such as hfs, jfs, fat, etc.), they are also not supportted by ovlfs.
>> So I would like to know are these file systems need to support in future ?
>>
> 
> I see you are not the first that requested this feature:
> https://lkml.org/lkml/2014/10/28/1049
> 
> The solution for the general case is (too?) complex.
> 
> However, for the case of all layers on the same fs, where d_hash()
> d_compare() are consistent
> across all layers, I guess this is doable and even not that hard to do.
> 
> The 'samefs' case is an interesting case, because it is commonly used
> by container
> managers (e.g. dockerd).
> 
> I've just posted the first overlayfs feature that depends on 'samefs'
> https://marc.info/?l=linux-unionfs&m=149079818122019&w=2
> and I have plans to develop more features for 'samefs' case (e.g. NFS export).
> 
> I don't mind writing a POC patch for you to test your use case, but I
> will ask you
> to first write a test which mixes case insensitive names in
> lower/upper, so this patch
> can be properly tested.
> An xfstest overlay test is greatly preferred.
> I can test it with overlayfs over vfat.
> 

Thank you for your support. Now we are not make a decision whether to modify the
underlying file system or the overlayfs. If so, we can plan to write and test it.

Thanks,
ZhangYi.
