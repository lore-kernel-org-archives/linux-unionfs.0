Return-Path: <SRS0=37bb=CM=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 344EBC433E7
	for <linux-unionfs@archiver.kernel.org>; Thu,  3 Sep 2020 09:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFFB7206C0
	for <linux-unionfs@archiver.kernel.org>; Thu,  3 Sep 2020 09:24:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgICJYa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 05:24:30 -0400
Received: from relaygw1-21.mclink.it ([195.78.211.229]:33201 "EHLO
        relaygw1-21.mclink.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbgICJYa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 3 Sep 2020 05:24:30 -0400
Received: from [172.24.30.44] (HELO cgp-esgout01-rm.mail.irds.it)
  by relaygw1-21.mclink.it (CommuniGate Pro SMTP 6.0.2)
  with ESMTPS id 188435475 for linux-unionfs@vger.kernel.org; Thu, 03 Sep 2020 11:24:27 +0200
X-Envelope-From: <mc5686@mclink.it>
Received: from [192.168.7.128] (host-82-53-147-214.retail.telecomitalia.it [82.53.147.214])
        (Authenticated sender: mc5686)
        by cgp-esgout01-rm.mail.irds.it (Postfix) with ESMTPA id C6A6141B87;
        Thu,  3 Sep 2020 11:24:17 +0200 (CEST)
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
 <89bc9214-bb3c-49e9-16d1-c630b463c901@mclink.it>
 <CAOQ4uxjQW8YcagfLn+8Eh4NuQ-45R5HYbLdmNpZL=q4_k_vT3w@mail.gmail.com>
From:   Mauro Condarelli <mc5686@mclink.it>
Message-ID: <7b418869-b68d-fb34-af12-b70fd7877be5@mclink.it>
Date:   Thu, 3 Sep 2020 11:24:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjQW8YcagfLn+8Eh4NuQ-45R5HYbLdmNpZL=q4_k_vT3w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Irideos-Libra-ESVA-Information: Please contact Irideos for more information
X-Irideos-Libra-ESVA-ID: C6A6141B87.A7F89
X-Irideos-Libra-ESVA: No virus found
X-Irideos-Libra-ESVA-From: mc5686@mclink.it
X-Irideos-Libra-ESVA-Watermark: 1599729858.91182@dpEzIDhQ4Mu43XPZUwN31w
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org



On 9/3/20 11:00 AM, Amir Goldstein wrote:
>>> Just so you know, Android is another "system image provider" project
>>> whose developers were talking about using overlayfs to provide
>>> "debug mode", wherein developers can modify system files.
>>> This is the use case for the proposed override_creds=off feature [1].
>>>
>>> I do not know if this mode was deployed on existing phones, but anyway,
>>> it is not enabled in production mode, so it limits very much the problem
>>> of conflict resolution.
>> I'm not sure about what You mean exactly, but I'll try to check it
>> if You so suggest.
>>
> There is nothing for you to check.
> Only informing you of another user that may be doing the same thing that
> you do and expects it to continue working.
>
> FWIW, if Android *are* using overlayfs like this they should encounter
> the same problem you encountered and the upstream fix will not solve it....
>
> Thanks,
> Amir.
FYI: using OverlayFS this way and for this use-case was suggested
by SWUpdate maintainer (Stefano Babic) so I guess there are other
people relying on "correct" behavior around the world .

Regards
Mauro

