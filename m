Return-Path: <SRS0=LI0E=CL=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC9AC43461
	for <linux-unionfs@archiver.kernel.org>; Wed,  2 Sep 2020 15:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC193207EA
	for <linux-unionfs@archiver.kernel.org>; Wed,  2 Sep 2020 15:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgIBPeR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 11:34:17 -0400
Received: from relaygw2-23.mclink.it ([195.78.211.237]:60423 "EHLO
        relaygw2-23.mclink.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728490AbgIBPeL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 2 Sep 2020 11:34:11 -0400
Received: from cgp-esgout03-rm.mail.irds.it ([172.24.30.46] verified)
  by relaygw2-23.mclink.it (CommuniGate Pro SMTP 6.0.4)
  with ESMTPS id 177689049 for linux-unionfs@vger.kernel.org; Wed, 02 Sep 2020 17:34:07 +0200
X-Envelope-From: <mc5686@mclink.it>
Received: from [192.168.7.128] (host-82-53-147-214.retail.telecomitalia.it [82.53.147.214])
        (Authenticated sender: mc5686)
        by cgp-esgout03-rm.mail.irds.it (Postfix) with ESMTPA id F206441AFE;
        Wed,  2 Sep 2020 17:33:53 +0200 (CEST)
Subject: Re: Frequent errors with OverlayFS on root
To:     Vivek Goyal <vgoyal@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
References: <d5dc093b-71aa-8656-a4d3-c27c14015d79@mclink.it>
 <CAOQ4uxgHL2H8RBXbovyFNn_GOC9YE2N6L+AZ6XO=qkA2hhLr=w@mail.gmail.com>
 <2da4dd97-d7cb-ce1b-ada7-0152d65ce701@mclink.it>
 <CAOQ4uxjk78aWc4rXd3_4Kr_Hy74AF4Yzk8Dur9VyadeyS33MGg@mail.gmail.com>
 <20200902132921.GA1263242@redhat.com>
From:   Mauro Condarelli <mc5686@mclink.it>
Message-ID: <7862cfc2-03e1-61b8-ae36-96ef5d28915e@mclink.it>
Date:   Wed, 2 Sep 2020 17:33:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200902132921.GA1263242@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Irideos-Libra-ESVA-Information: Please contact Irideos for more information
X-Irideos-Libra-ESVA-ID: F206441AFE.A9897
X-Irideos-Libra-ESVA: No virus found
X-Irideos-Libra-ESVA-From: mc5686@mclink.it
X-Irideos-Libra-ESVA-Watermark: 1599665634.5331@wlOEq/RQGvaIv5vSGcNpzw
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Vivek,
comments inline below.

On 9/2/20 3:29 PM, Vivek Goyal wrote:
> On Wed, Sep 02, 2020 at 06:34:12AM +0300, Amir Goldstein wrote:
>> On Wed, Sep 2, 2020 at 2:37 AM Mauro Condarelli <mc5686@mclink.it> wrote:
>>> Thanks Amir,
>>> comments inline below
>>>
>>> Regards
>>> Mauro
>>>
>>> On 9/1/20 8:43 PM, Amir Goldstein wrote:
>>>
>>> On Tue, Sep 1, 2020 at 9:01 PM Mauro Condarelli <mc5686@mclink.it> wrote:
>>>
>>> Hi,
>>> most likely this is not the right place to ask, please redirect me as needed.
>>>
>>> I'm trying to use OverlayFS to add (limited) write capability to a ReadOnly
>>> rootfs (SquashFS)
>>>
>>> Essentially (actual script is more complex, of course) boot-sequence includes:
>>>
>>> # /dev/mmcblk0p5: ext4 (upper+work+nwwroot+newroot/oldroot)
>>> # /dev/mmcblk0p6: SquashFS mounted on /
>>> mount /dev/mmcblk0p5 /overlay
>>> mount -t overlay overlay -o lowerdir=/,upperdir=/overlay/upper,workdir=/overlay/work  /overlay/newroot
>>> cd /overlay/newroot
>>> pivot_root . oldroot
>>> mount --move oldroot/dev /dev
>>> mount --move oldroot/proc /proc
>>>
>>> This works as expected, but, too often for comfort, some file
>>> (and sometime also directories) become unavailable due to error:
>>>
>>> overlayfs: invalid origin (ssh/sshd_config, ftype=8000, origin ftype=4000).
>>>
>>> File name changes, of course, but rest is fairly constant.
>>>
>>> This always happens when some file is written.
>>> Error persists reboots.
>>> Only way I found to "cure" the system is to go on "upper" and delete the file
>>> thus going back to "lower" version (in this case I should delete "/oldroot/overlay/upper/etc/ssh/sshd_config")
>>>
>>> This is a self-built kernel (Linux vocore 5.7.0 #2 PREEMPT Mon Aug 3 09:19:06 CEST 2020 mips GNU/Linux)
>>> on a custom target based on a SoC (MT7628).
>>>
>>> I am available to do any required test, but I have no idea about where to start.
>>>
>>> Any hint (or redirect) would be greatly appreciated.
>>>
>>> This is probably your problem:
>>> https://lore.kernel.org/linux-unionfs/32532923.JtPX5UtSzP@fgdesktop/
>>>
>>> It surely looks like it is.
>>> I tried to follow the thread, but I'm unsure i grokked it .
>>>
>>> I am using OverlayFS (ext4 over a SquashFS) on rootfs in order to
>>> be able to update the whole system (changing SquashFS) while
>>> retaining customization (essentially tweaks in /etc/, host certificates
>>> and similar stuff) in an embedded target.
>>>
>>> To complicate matters I also have a dual system for fallback in case
>>> of faulty upgrade; this means I can switch from:
>>>   lower=part6, upper=part5, update will go into part7
>>> to
>>>   lower=part7, upper=part5, update will go into part6
>>>
>>> I don't need nfs at all, so exporting OverlayFS is not an issue,
>>> but it's unclear to me if this "lower swapping" is
>>> actually supported as I see:
>>>
>>>>> /me is again wondering what's the use case of modifying lower layer
>>>>> with an existing upper. Is it fair to say, no don't recreate/modify
>>>>> lower layers and use with existing upper.
>>>>>
>>>> It's fine by me to document that this is not supported.
>>> ... which is scary.
>>> Note I do *not* need to modify lower on-the-fly, when I
>>> swap systems, that will happen at reboot.
>> Don't be scared :-)
>> Your reaction is a good answer to Vivek's question above -
>> No, it is not fair to say don't re-create lower and use existing upper
> This seems like a wrong use case to me. So in above example, say
> following happens.
>
> - Mount overlay
> - modify sshd_config (it gets copied up).
> - Lower squahsfs gets updated and /etc/sshd/sshd_config gets updated.
> - Mount overlay and user now sees old copied up sshd_config. (If it
>   works).
>
> Conceptually it is not making much sense to me. What's the point of
> upgrading lower because after mounting overlay you might still see
> old file. And to make it worse, behavior is underministic beacuse
> if file has not been copied up, you will see new file.
It might not make much sense to you, but it's EXACTLY what I need.
This OverlayFS is used *only* for permanent configuration.
Most of the times I'm adding new files (like host certificates and
similar things), but sometimes applications provide "default
configuration" I might need to override.
If/when applications "upgrade their defaults" I definitely do not
want them to override my choices.

> To me, this sounds like a volatile overlay use case. Any changes to
> overlay should be thrown away when lower sqashfs is updated and a
> fresh upper should be set.
I beg to differ.
While You are right in the general case it's possible to end up with
a tangled mess of old/new files none can sort out, your solution
resembles a lot to Alexander "solution" of the gordian knot.

In practice problems can (and will) arise in development
when most of changes are done by hand for testing (so some
unwanted "permanent" change can creep in; in production
there's a well defined flow that should prevent mishap.

Some of those configurations could be handled via other means,
but they are invariably more complex and less adaptable to
"unforeseen" needs/changes (which *will* happen).
> Thanks
> Vivek
Regards
Mauro
