From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Question about ovl_dentry_weird
Date: Thu, 30 Mar 2017 11:52:45 +0300
Message-ID: <CAOQ4uxjCa1XSg_VhirsUj78CAxa5=r=AXnKpOSF09dUU4Wg6=Q@mail.gmail.com>
References: <f3a67b6a-b8fb-78ab-fadd-504fa5d76a10@huawei.com>
 <CAOQ4uxhvrAefbxcYXv5JfBmKN==8Yo7QKiaFAa6YS8VSfpvf=A@mail.gmail.com> <a64cfa4b-f56a-2c30-e621-d28e40056944@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:34456 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbdC3Iwr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 30 Mar 2017 04:52:47 -0400
Received: by mail-oi0-f42.google.com with SMTP id o67so24416835oib.1
        for <linux-unionfs@vger.kernel.org>; Thu, 30 Mar 2017 01:52:46 -0700 (PDT)
In-Reply-To: <a64cfa4b-f56a-2c30-e621-d28e40056944@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: linux-unionfs@vger.kernel.org, miaoxie@huawei.com, laiyuanyuan.lai@huawei.com, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Mar 30, 2017 at 11:22 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>
>
> On 2017/3/30 15:03, Amir Goldstein wrote:
>>> Hi:
>>> Current overlayfs does not support underlying filesystem which have "we=
ird" d_flags (like DCACHE_OP_HASH=EF=BC=8C
>>> DCACHE_OP_COMPARE, DCACHE_OP_REVALIDATE, etc). So we cannot support fs =
have it's own d_hash, d_compare and
>>> d_revalidate functions.
>>
>> Not accurate. d_revalidate() is allowed for lower, but not for upper
>> (ovl_dentry_remote()).
>>
>
> Thank you for the corrections, I see it in the ovl_lower_dir().
>
>>>
>>> Do you have a TODO plan to support it in a future version ?
>>>
>>
>> Which of the constrains is relevant to your use case? (which of the flag=
s)
>> Do you need it for lower / upper or both?
>> Is it a proprietary file system of a known one you need to support?
>>
>
> We want to use d_hash(), d_compare() and d_revalidate() to our own propri=
etary file system
> (not a remote fs, not widely used, and it's file name is case-insensitive=
) for lower
> and upper both, and we also need to use d_revalidate() to do some special=
 handling.
>
> I see there were many other rarely used=EF=BC=88?=EF=BC=89file systems al=
so use d_hash(), d_compare(),
> d_revalidate() in kernel(such as hfs, jfs, fat, etc.), they are also not =
supportted by ovlfs.
> So I would like to know are these file systems need to support in future =
?
>

I see you are not the first that requested this feature:
https://lkml.org/lkml/2014/10/28/1049

The solution for the general case is (too?) complex.

However, for the case of all layers on the same fs, where d_hash()
d_compare() are consistent
across all layers, I guess this is doable and even not that hard to do.

The 'samefs' case is an interesting case, because it is commonly used
by container
managers (e.g. dockerd).

I've just posted the first overlayfs feature that depends on 'samefs'
https://marc.info/?l=3Dlinux-unionfs&m=3D149079818122019&w=3D2
and I have plans to develop more features for 'samefs' case (e.g. NFS expor=
t).

I don't mind writing a POC patch for you to test your use case, but I
will ask you
to first write a test which mixes case insensitive names in
lower/upper, so this patch
can be properly tested.
An xfstest overlay test is greatly preferred.
I can test it with overlayfs over vfat.

Thanks,
Amir.
