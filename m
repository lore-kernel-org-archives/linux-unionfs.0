Return-Path: <SRS0=37bb=CM=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C9DC433E2
	for <linux-unionfs@archiver.kernel.org>; Thu,  3 Sep 2020 08:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E3252065F
	for <linux-unionfs@archiver.kernel.org>; Thu,  3 Sep 2020 08:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgICIvx (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 04:51:53 -0400
Received: from relaygw3-21.mclink.it ([195.78.211.241]:57649 "EHLO
        relaygw3-21.mclink.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgICIvw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 3 Sep 2020 04:51:52 -0400
Received: from [172.24.30.45] (HELO cgp-esgout02-rm.mail.irds.it)
  by relaygw3-21.mclink.it (CommuniGate Pro SMTP 6.0.6)
  with ESMTPS id 174858579 for linux-unionfs@vger.kernel.org; Thu, 03 Sep 2020 10:51:50 +0200
X-Envelope-From: <mc5686@mclink.it>
Received: from [192.168.7.128] (host-82-53-147-214.retail.telecomitalia.it [82.53.147.214])
        (Authenticated sender: mc5686)
        by cgp-esgout02-rm.mail.irds.it (Postfix) with ESMTPA id 5C9B541B11;
        Thu,  3 Sep 2020 10:51:43 +0200 (CEST)
Subject: Re: Frequent errors with OverlayFS on root
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Mark Salyzyn <salyzyn@android.com>
References: <d5dc093b-71aa-8656-a4d3-c27c14015d79@mclink.it>
 <CAOQ4uxgHL2H8RBXbovyFNn_GOC9YE2N6L+AZ6XO=qkA2hhLr=w@mail.gmail.com>
 <2da4dd97-d7cb-ce1b-ada7-0152d65ce701@mclink.it>
 <CAOQ4uxjk78aWc4rXd3_4Kr_Hy74AF4Yzk8Dur9VyadeyS33MGg@mail.gmail.com>
 <20200902132921.GA1263242@redhat.com>
 <7862cfc2-03e1-61b8-ae36-96ef5d28915e@mclink.it>
 <20200902202048.GD1263242@redhat.com>
 <8a5fb512-e430-40c1-2266-e90625385e62@mclink.it>
 <CAOQ4uxg9p2w-z9c+WzVjr5CO3xmf2gqK-VrhhUOcbA2uQJiseA@mail.gmail.com>
From:   Mauro Condarelli <mc5686@mclink.it>
Message-ID: <89bc9214-bb3c-49e9-16d1-c630b463c901@mclink.it>
Date:   Thu, 3 Sep 2020 10:51:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxg9p2w-z9c+WzVjr5CO3xmf2gqK-VrhhUOcbA2uQJiseA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Irideos-Libra-ESVA-Information: Please contact Irideos for more information
X-Irideos-Libra-ESVA-ID: 5C9B541B11.A6C7B
X-Irideos-Libra-ESVA: No virus found
X-Irideos-Libra-ESVA-From: mc5686@mclink.it
X-Irideos-Libra-ESVA-Watermark: 1599727904.64204@hy95jeYB4xooNZxqcde8UA
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Thanks Amir,
comments inline below.

On 9/3/20 10:30 AM, Amir Goldstein wrote:
>>> So basically squashfs image will be udpated. I am not sure how this
>>> will work for all the cases. What if application is updated and
>>> it decides to rename its config file from foo.txt to bar.txt. Now
>>> when application is launched, user defaults are lost anyway.
>> I'm in a somewhat middle position.
>>
>> Targets are embedded systems and it wouldn't make any sense
>> to implement a fully flexible update system (deb/rpm/ipkg/...);
>> I just have two "packages": system and application.
>>
>> I *am* the "rootfs (aka: system) image provider".
>>
> FYI, I am not a stakeholder. Just chose the "defending" side, to counter
> Vivek's opinion for the sake of the argument.
I guessed that ;)

> FYI2, overlayfs maintainer as well as Linux maintainer have always
> followed the practice of not breaking existing user workloads, so the
> status quo is playing to your side anyway.
I'm *very* glad to hear this, but if there's any chance this will
change in a foreseeable future I'd want to know it *now*,
changing later would be a disaster (for me, of course).

> I assume, although you did not mention this, that you maintan an
> OpenWRT derivative.
No, that's a fair guess, but I'm actually rolling out a full system
based on Buildroot with current upstreamed u-boot/kernel/apps.

> Just so you know, Android is another "system image provider" project
> whose developers were talking about using overlayfs to provide
> "debug mode", wherein developers can modify system files.
> This is the use case for the proposed override_creds=off feature [1].
>
> I do not know if this mode was deployed on existing phones, but anyway,
> it is not enabled in production mode, so it limits very much the problem
> of conflict resolution.
I'm not sure about what You mean exactly, but I'll try to check it
if You so suggest.

> Thanks,
> Amir.
>
> [1] https://lore.kernel.org/linux-unionfs/20191104215253.141818-1-salyzyn@android.com/
Regards
Mauro
