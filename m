From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: Question about ovl_dentry_weird
Date: Thu, 30 Mar 2017 16:22:59 +0800
Message-ID: <a64cfa4b-f56a-2c30-e621-d28e40056944@huawei.com>
References: <f3a67b6a-b8fb-78ab-fadd-504fa5d76a10@huawei.com>
 <CAOQ4uxhvrAefbxcYXv5JfBmKN==8Yo7QKiaFAa6YS8VSfpvf=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:4814 "EHLO
        dggrg01-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754330AbdC3IXQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 30 Mar 2017 04:23:16 -0400
In-Reply-To: <CAOQ4uxhvrAefbxcYXv5JfBmKN==8Yo7QKiaFAa6YS8VSfpvf=A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, miaoxie@huawei.com, laiyuanyuan.lai@huawei.com, Miklos Szeredi <miklos@szeredi.hu>



On 2017/3/30 15:03, Amir Goldstein wrote:
>> Hi:
>> Current overlayfs does not support underlying filesystem which have "weird" d_flags (like DCACHE_OP_HASH，
>> DCACHE_OP_COMPARE, DCACHE_OP_REVALIDATE, etc). So we cannot support fs have it's own d_hash, d_compare and
>> d_revalidate functions.
> 
> Not accurate. d_revalidate() is allowed for lower, but not for upper
> (ovl_dentry_remote()).
> 

Thank you for the corrections, I see it in the ovl_lower_dir().

>>
>> Do you have a TODO plan to support it in a future version ?
>>
> 
> Which of the constrains is relevant to your use case? (which of the flags)
> Do you need it for lower / upper or both?
> Is it a proprietary file system of a known one you need to support?
> 

We want to use d_hash(), d_compare() and d_revalidate() to our own proprietary file system
(not a remote fs, not widely used, and it's file name is case-insensitive) for lower
and upper both, and we also need to use d_revalidate() to do some special handling.

I see there were many other rarely used（?）file systems also use d_hash(), d_compare(),
d_revalidate() in kernel(such as hfs, jfs, fat, etc.), they are also not supportted by ovlfs.
So I would like to know are these file systems need to support in future ?

Thanks,
ZhangYi.
