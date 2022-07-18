Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8EE3C43334
	for <linux-unionfs@archiver.kernel.org>; Mon, 18 Jul 2022 15:03:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234972AbiGRPDt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 11:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiGRPDs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Jul 2022 11:03:48 -0400
X-Greylist: delayed 90 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 18 Jul 2022 08:03:45 PDT
Received: from omta037.useast.a.cloudfilter.net (omta037.useast.a.cloudfilter.net [44.202.169.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A02240A2
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Jul 2022 08:03:45 -0700 (PDT)
Received: from eig-obgw-5005a.ext.cloudfilter.net ([10.0.29.234])
        by cmsmtp with ESMTP
        id DPQ5otqPzeWDSDSGEoLwKj; Mon, 18 Jul 2022 15:02:14 +0000
Received: from gator3309.hostgator.com ([192.254.250.173])
        by cmsmtp with ESMTP
        id DSGCoSNg61DQvDSGCog3bR; Mon, 18 Jul 2022 15:02:13 +0000
X-Authority-Analysis: v=2.4 cv=Kv9eZEaN c=1 sm=1 tr=0 ts=62d575f5
 a=dOmPygiJvdb+5OUNGItVWg==:117 a=mH/2fUS72G5xRhX6WoQJBg==:17
 a=IkcTkHD0fZMA:10 a=MKtGQD3n3ToA:10 a=1oJP67jkp3AA:10 a=RgO8CyIxsXoA:10
 a=1agXfLV7zN0A:10 a=0NJJaq8bbSYA:10 a=lWuoVP_hAAAA:8 a=NEAV23lmAAAA:8
 a=qyu0ZQsMAABPi5KGwgUA:9 a=QEXdDO2ut3YA:10 a=Cd2r5mmCzboHVgs915Dn:22
Received: from [71.247.229.35] (port=47608 helo=[192.168.1.133])
        by gator3309.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <trapexit@spawn.link>)
        id 1oDSGB-0004cp-GT;
        Mon, 18 Jul 2022 10:02:11 -0500
Message-ID: <0e2af067-6b11-8e61-84c2-c9df25596ffe@spawn.link>
Date:   Mon, 18 Jul 2022 11:02:08 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] [REGRESSION] ovl: Handle ENOSYS when fileattr support is
 missing in lower/upper fs
Content-Language: en-US
To:     =?UTF-8?Q?Christian_Kohlsch=c3=bctter?= 
        <christian@kohlschutter.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
References: <4B9D76D5-C794-4A49-A76F-3D4C10385EE0@kohlschutter.com>
 <CAJfpegs1Kta-HcikDGFt4=fa_LDttCeRmffKhUjWLr=DxzXg-A@mail.gmail.com>
 <83A29F9C-1A91-4753-953A-0C98E8A9832C@kohlschutter.com>
 <CAJfpegv5W0CycWCc2-kcn4=UVqk1hP7KrvBpzXHwW-Nmkjx8zA@mail.gmail.com>
 <FFA26FD1-60EF-457E-B914-E1978CCC7B57@kohlschutter.com>
 <CAJfpeguDAJpLMABsomBFQ=w6Li0=sBW0bFyALv4EJrAmR2BkpQ@mail.gmail.com>
 <A31096BA-C128-4D0B-B27D-C34560844ED0@kohlschutter.com>
 <CAJfpegvBSCQwkCv=5LJDx1LRCN_ztTh9VMvrTbCyt0zf7W2trw@mail.gmail.com>
 <0B8DA307-7E1F-4534-B864-BC2632740C89@kohlschutter.com>
From:   Antonio SJ Musumeci <trapexit@spawn.link>
In-Reply-To: <0B8DA307-7E1F-4534-B864-BC2632740C89@kohlschutter.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator3309.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - spawn.link
X-BWhitelist: no
X-Source-IP: 71.247.229.35
X-Source-L: No
X-Exim-ID: 1oDSGB-0004cp-GT
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.1.133]) [71.247.229.35]:47608
X-Source-Auth: trapexit@spawn.link
X-Email-Count: 3
X-Org:  HG=hgshared;ORG=hostgator;
X-Source-Cap: YmlsZTtiaWxlO2dhdG9yMzMwOS5ob3N0Z2F0b3IuY29t
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfIgSfDchQ9mf8u3J7msppMIUfTQ7sWdSxDui0uwUqx64s0u1N62U5rWwAwyqfcWQ2ymN/ix9K4LR3ckQEfclwZHYwf7yCMwH/ARtmLYki0CA/E7DktrV
 q4iHwwzB9YrCos5C3QqHncwqIrke3hb9HfllLyAWvqICPtA9k0URshAkXAAkp3rmpMSYFgLTfmJq7d+UneG7cFd/4e1OGsjvSgJtMc16pC2PcPhJVdu2ou8V
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 7/18/22 10:25, Christian Kohlschütter wrote:
>> Am 18.07.2022 um 15:13 schrieb Miklos Szeredi <miklos@szeredi.hu>:
>>
>> On Mon, 18 Jul 2022 at 15:03, Christian Kohlschütter
>> <christian@kohlschutter.com> wrote:
>>> Am 18.07.2022 um 14:21 schrieb Miklos Szeredi <miklos@szeredi.hu>:
>>>> On Mon, 18 Jul 2022 at 12:56, Christian Kohlschütter
>>>> <christian@kohlschutter.com> wrote:
>>>>
>>>>> However, users of fuse that have no business with overlayfs suddenly see their ioctl return ENOTTY instead of ENOSYS.
>>>> And returning ENOTTY is the correct behavior.  See this comment in
>>>> <asm-generic/errrno.h>:
>>>>
>>>> /*
>>>> * This error code is special: arch syscall entry code will return
>>>> * -ENOSYS if users try to call a syscall that doesn't exist.  To keep
>>>> * failures of syscalls that really do exist distinguishable from
>>>> * failures due to attempts to use a nonexistent syscall, syscall
>>>> * implementations should refrain from returning -ENOSYS.
>>>> */
>>>> #define ENOSYS 38 /* Invalid system call number */
>>>>
>>>> Thanks,
>>>> Miklos
>>> That ship is sailed since ENOSYS was returned to user-space for the first time.
>>>
>>> It reminds me a bit of Linus' "we do not break userspace" email from 2012 [1, 2], where Linus wrote:
>>>> Applications *do* care about error return values. There's no way in
>>>> hell you can willy-nilly just change them. And if you do change them,
>>>> and applications break, there is no way in hell you can then blame the
>>>> application.
>> Correct.  The question is whether any application would break in this
>> case.  I think not, but you are free to prove otherwise.
>>
>> Thanks,
>> Miklos
> I'm not going to do that since I expect any answer I give would not change your position here. All I know is there is a non-zero chance such programs exist.
>
> If you're willing to go ahead with the fuse change you proposed, I see no purpose in debating with you further since you're the kernel maintainer of both file systems.
> That change "fixes" the problem that I had seen in my setup; I do not know the extent of side effects, but I expect some could surface eventually.
>
> Once you're done fixing fuse, please also talk to the folks over at https://github.com/trapexit/mergerfs who explicitly return ENOSYS upon request. Who knows, maybe someone is audacious enough to try mergerfs as a lower filesystem for overlay?
>
> Alas, I think this a clash between the philosophies of writing robust code versus writing against a personal interpretation of some specification.
> You refer to "asm-generic/errno.h" as the specification and rationale for treating ENOSYS as sacrosanct. Note that the comment says "should refrain from", it doesn't say "must not", and that's why we're in this mess.
>
> It therefore wouldn't hurt to be lenient when a lower filesystem returns an error code known to refer to "unsupported operation", and that's what my original patch to ovl does.
>
> I thought this approach would resonate with you, since you must have been following the same logic when you added the special-case check for "EINVAL" as an exception for ntfs-3g in the commit that most likely triggered the regression ("ovl: fix filattr copy-up failure") 9 months ago.
>
> I honestly wonder why you're risking further breakage, having introduced that regression only recently.
>
> So long,
> Christian

Author of mergerfs here. What are you referring to exactly? It's 
possible I'm forgetting something but  I should only be returning ENOSYS 
in similar cases to libfuse where some function is not supported or when 
wishing to disable xattr calls.

