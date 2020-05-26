Return-Path: <SRS0=uZ0x=7I=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 527EEC433DF
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 May 2020 07:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E58D920776
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 May 2020 07:50:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="PCPNBazK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730479AbgEZHuv (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 26 May 2020 03:50:51 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17118 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726048AbgEZHuv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 26 May 2020 03:50:51 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1590479416; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=MTuE4Rs1tQtiot89RiJjUBrRDzEmvv9OKCY9V000pgzNvaZSbjE6tESVGr3W9onJtb2o0SKQAn2d0eweDAyqIbaPlVHb6IHpCYj+VP1D+R6KTUBHeLHtkAELYi7fR6untw2OS5+FByQvvJWMTOnKGThvuwnU26DkNHl3WKUkkjs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1590479416; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=8NTma5VfytGC4zcpjaTjYBOV5JMI4Snfh6UvxAVZX5M=; 
        b=l6r5iITYPn6zW9K+GlLu/tsXWltg0WQqf0ZPubPIO94we4/IxkfS0Ovd1jyaRDPuBwuHaYEpDNZRmbv6KX/971kI+3N8wYVLiNr90StRxnlclG7sp4Tv+Dvx8P2VogxGBipYyjTHDdYZ16KqkCOqCo3U91PGI1435Qbv80IhWWY=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1590479416;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=8NTma5VfytGC4zcpjaTjYBOV5JMI4Snfh6UvxAVZX5M=;
        b=PCPNBazKRkHNQs13Cz/AXT4SNkc8NFLASLLzod1t4+lyO/wQwVWs3tFJTkBNTy9s
        vmDiqS0MthvmBx0IOfrQxScWKRJkFZ/fLFiW9Zy99TWqdzzxOtPsxKADhNm1NaNCVgh
        BqDGKbrq2NURapKqHm1uL0UP6Csl4B0BL4y/nGW4=
Received: from [192.168.166.138] (218.18.229.179 [218.18.229.179]) by mx.zoho.com.cn
        with SMTPS id 1590479414462648.3955911726931; Tue, 26 May 2020 15:50:14 +0800 (CST)
Subject: Re: [PATCH v12] ovl: improve syncfs efficiency
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Sargun Dhillon <sargun@sargun.me>
References: <20200506095307.23742-1-cgxu519@mykernel.net>
 <4bc73729-5d85-36b7-0768-ae5952ae05e9@mykernel.net>
 <CAOQ4uxi4coKOoYar7Y==i=P21j5r8fi_0op+BZR-VQ1w5CMUew@mail.gmail.com>
From:   cgxu <cgxu519@mykernel.net>
Message-ID: <6bce615e-b8ef-e63f-3829-e2b785a02f5d@mykernel.net>
Date:   Tue, 26 May 2020 15:50:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxi4coKOoYar7Y==i=P21j5r8fi_0op+BZR-VQ1w5CMUew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoCNMailClient: External
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org



On 5/20/20 3:24 PM, Amir Goldstein wrote:
> On Wed, May 20, 2020 at 4:02 AM cgxu <cgxu519@mykernel.net> wrote:
>>
>> On 5/6/20 5:53 PM, Chengguang Xu wrote:
>>> Current syncfs(2) syscall on overlayfs just calls sync_filesystem()
>>> on upper_sb to synchronize whole dirty inodes in upper filesystem
>>> regardless of the overlay ownership of the inode. In the use case of
>>> container, when multiple containers using the same underlying upper
>>> filesystem, it has some shortcomings as below.
>>>
>>> (1) Performance
>>> Synchronization is probably heavy because it actually syncs unnecessary
>>> inodes for target overlayfs.
>>>
>>> (2) Interference
>>> Unplanned synchronization will probably impact IO performance of
>>> unrelated container processes on the other overlayfs.
>>>
>>> This patch tries to only sync target dirty upper inodes which are belong
>>> to specific overlayfs instance and wait for completion. By doing this,
>>> it is able to reduce cost of synchronization and will not seriously impact
>>> IO performance of unrelated processes.
>>>
>>> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>>
>> Except explicit sycnfs is triggered by user process, there is also implicit
>> syncfs during umount process of overlayfs instance. Every syncfs will
>> deliver to upper fs and whole dirty data of upper fs syncs to persistent
>> device at same time.
>>
>> In high density container environment, especially for temporary jobs,
>> this is quite unwilling  behavior. Should we provide an option to
>> mitigate this effect for containers which don't care about dirty data?
>>
> 
> This is not the first time this sort of suggestion has been made:
> https://lore.kernel.org/linux-unionfs/4bc73729-5d85-36b7-0768-ae5952ae05e9@mykernel.net/T/#md5fc5d51852016da7e042f5d9e5ef7a6d21ea822

The link above seems just my mail thread in mail list.


> 
> At the time, I proposed to use the SHUTDOWN ioctl as a means
> for containers runtime to communicate careless teardown.
> 
> I've pushed an uptodate version of ovl-shutdown RFC [1].
> It is only lightly tested.
> It does not take care of OVL_SHUTDOWN_FLAGS_NOSYNC, but this
> is trivial. I also think it misses some smp_mb__after_atomic() for
> accessing ofs->goingdown and ofs->creator_cred.
> I did not address my own comments on the API [2].
> And there are no tests at all.
> 
> If this works for your use case, let me know how you want to proceed.
> I could re-post the ioctl and access hook patches, leaving out the actual
> shutdown patch for you to work on.
> You may add some of your own patched, write tests and post v2.
> 

Seems the use case is sightly different with ours, in our use case,
we hope to skip sync behavior in overlayfs layer(sometimes there will be 
still syncing behavior triggered by wirteback of upper lyaer) for 
certain kind of containers(I don't mean all kind of containers).

Optimization of syncfs will mitigate the effect of sync behavior but 
maybe directly skipping dirty date syncing is better for special use case.


Thanks,
cgxu

> 
> [1] https://github.com/amir73il/linux/commits/ovl-shutdown
> [2] https://lore.kernel.org/linux-unionfs/CAOQ4uxiau7N6NtMLzjwPzHa0nMKZWi4nu6AwnQkR0GFnKA4nPg@mail.gmail.com/
> 
