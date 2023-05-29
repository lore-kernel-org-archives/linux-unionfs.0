Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9199C77B7A
	for <linux-unionfs@archiver.kernel.org>; Mon, 29 May 2023 17:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjE2RwW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 29 May 2023 13:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjE2RwV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 29 May 2023 13:52:21 -0400
X-Greylist: delayed 90 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 29 May 2023 10:52:18 PDT
Received: from alerce.blitiri.com.ar (alerce.blitiri.com.ar [IPv6:2001:bc8:228b:9000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2988191
        for <linux-unionfs@vger.kernel.org>; Mon, 29 May 2023 10:52:17 -0700 (PDT)
Received: from [IPV6:2a02:8109:aa40:4e0:b5c6:9671:3477:8fde]
        by sdfg.com.ar (chasquid) with ESMTPSA
        tls TLS_AES_128_GCM_SHA256
        (over submission+TLS, TLS-1.3, envelope from "rodrigo@sdfg.com.ar")
        ; Mon, 29 May 2023 17:50:41 +0000
Message-ID: <16766416-1176-80d2-241a-ac982fb30ac0@sdfg.com.ar>
Date:   Mon, 29 May 2023 19:50:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: Detaching lower layers (Was: Lazy Loading Layers)
To:     Amir Goldstein <amir73il@gmail.com>,
        Sargun Dhillon <sargun@sargun.me>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
References: <20210125194848.GA12389@ircssh-2.c.rugged-nimbus-611.internal>
 <CAOQ4uxg0BHD8OHWk-b6TrE=SqGJTvp8TuHaLCwC5g9ZL=7W0Ew@mail.gmail.com>
Content-Language: en-US
From:   Rodrigo Campos <rodrigo@sdfg.com.ar>
In-Reply-To: <CAOQ4uxg0BHD8OHWk-b6TrE=SqGJTvp8TuHaLCwC5g9ZL=7W0Ew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 5/29/23 17:15, Amir Goldstein wrote:
> On Mon, Jan 25, 2021 at 9:54 PM Sargun Dhillon <sargun@sargun.me> wrote:
>>
>> One of the projects I'm playing with for containers is lazy-loading of layers.
>> We've found that less than 10% of the files on a layer actually get used, which
>> is an unfortunate waste. It also means in some cases downloading ~100s of MB, or
>> ~1s of GB of files before starting a container workload. This is unfortunate.
>>
>> It would be nice if there was a way to start a container workload, and have
>> it so that if it tries to access and unpopulated (not yet downloaded) part
>> of the filesystem block while trying to be accessed. This is trivial to do
>> if the "lowest" layer is FUSE, where one can just stall in userspace on
>> loads. Unfortunately, AFAIK, there's not a good way to swap out the FUSE
>> filesystem with the "real" filesystem once it's done fully populating,
>> and you have to pay for the full FUSE cost on each read / write.
>>
>> I've tossed around:
>> 1. Mutable lowerdirs and having something like this:
>>
>> layer0 --> Writeable space
>> layer1 --> Real XFS filesystem
>> layer2 --> FUSE FS
>>
>> and if there is a "miss" on layer 1, it will then look it up on
>> layer 2 while layer 1 is being populated. Then the FUSE FS can block.
>> This is neat, but it requires the FUSE FS to always be up, and incurs
>> a userspace bounce on every miss.

Interesting.

I haven't checked the patches yet, but does the patchset "FUSE BPF: A 
Stacked Filesystem Extension for FUSE" help with your use case,  Sargun?



Best,
Rodrigo
