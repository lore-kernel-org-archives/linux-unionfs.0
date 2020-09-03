Return-Path: <SRS0=37bb=CM=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAE89C433E2
	for <linux-unionfs@archiver.kernel.org>; Thu,  3 Sep 2020 07:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B4A720737
	for <linux-unionfs@archiver.kernel.org>; Thu,  3 Sep 2020 07:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgICHZ4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 03:25:56 -0400
Received: from relaygw2-19.mclink.it ([195.78.211.233]:44221 "EHLO
        relaygw2-19.mclink.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgICHZ4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 3 Sep 2020 03:25:56 -0400
Received: from cgp-esgout02-rm.mail.irds.it ([172.24.30.45] verified)
  by relaygw2-19.mclink.it (CommuniGate Pro SMTP 6.0.4)
  with ESMTPS id 177792520 for linux-unionfs@vger.kernel.org; Thu, 03 Sep 2020 09:25:52 +0200
X-Envelope-From: <mc5686@mclink.it>
Received: from [192.168.7.128] (host-82-53-147-214.retail.telecomitalia.it [82.53.147.214])
        (Authenticated sender: mc5686)
        by cgp-esgout02-rm.mail.irds.it (Postfix) with ESMTPA id 6B51E41B07;
        Thu,  3 Sep 2020 09:25:44 +0200 (CEST)
Subject: Re: Frequent errors with OverlayFS on root
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
References: <d5dc093b-71aa-8656-a4d3-c27c14015d79@mclink.it>
 <CAOQ4uxgHL2H8RBXbovyFNn_GOC9YE2N6L+AZ6XO=qkA2hhLr=w@mail.gmail.com>
 <2da4dd97-d7cb-ce1b-ada7-0152d65ce701@mclink.it>
 <CAOQ4uxjk78aWc4rXd3_4Kr_Hy74AF4Yzk8Dur9VyadeyS33MGg@mail.gmail.com>
 <20200902132921.GA1263242@redhat.com>
 <7862cfc2-03e1-61b8-ae36-96ef5d28915e@mclink.it>
 <20200902202048.GD1263242@redhat.com>
From:   Mauro Condarelli <mc5686@mclink.it>
Message-ID: <8a5fb512-e430-40c1-2266-e90625385e62@mclink.it>
Date:   Thu, 3 Sep 2020 09:25:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200902202048.GD1263242@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Irideos-Libra-ESVA-Information: Please contact Irideos for more information
X-Irideos-Libra-ESVA-ID: 6B51E41B07.A9D7A
X-Irideos-Libra-ESVA: No virus found
X-Irideos-Libra-ESVA-From: mc5686@mclink.it
X-Irideos-Libra-ESVA-Watermark: 1599722746.01902@pvhlHszlCwi4UZeZKcHx+Q
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Vivek,
comments inline below

Regards
Mauro

On 9/2/20 10:20 PM, Vivek Goyal wrote:
> On Wed, Sep 02, 2020 at 05:33:53PM +0200, Mauro Condarelli wrote:
>> Hi Vivek,
>> comments inline below.
>>
>> On 9/2/20 3:29 PM, Vivek Goyal wrote:
>>> On Wed, Sep 02, 2020 at 06:34:12AM +0300, Amir Goldstein wrote:
>>>> On Wed, Sep 2, 2020 at 2:37 AM Mauro Condarelli <mc5686@mclink.it> wrote:
>>>>> Thanks Amir,
>>>>> comments inline below
>>>>>
>>>>> Regards
>>>>> Mauro
>>>>>
>>>>> On 9/1/20 8:43 PM, Amir Goldstein wrote:
>>>>>
>>>>> On Tue, Sep 1, 2020 at 9:01 PM Mauro Condarelli <mc5686@mclink.it> wrote:
>>>>>
>>>>> Hi,
>>>>> most likely this is not the right place to ask, please redirect me as needed.
>>>>>
>>>>> I'm trying to use OverlayFS to add (limited) write capability to a ReadOnly
>>>>> rootfs (SquashFS)
>>>>>
>>>>> Essentially (actual script is more complex, of course) boot-sequence includes:
>>>>>
>>>>> # /dev/mmcblk0p5: ext4 (upper+work+nwwroot+newroot/oldroot)
>>>>> # /dev/mmcblk0p6: SquashFS mounted on /
>>>>> mount /dev/mmcblk0p5 /overlay
>>>>> mount -t overlay overlay -o lowerdir=/,upperdir=/overlay/upper,workdir=/overlay/work  /overlay/newroot
>>>>> cd /overlay/newroot
>>>>> pivot_root . oldroot
>>>>> mount --move oldroot/dev /dev
>>>>> mount --move oldroot/proc /proc
>>>>>
>>>>> This works as expected, but, too often for comfort, some file
>>>>> (and sometime also directories) become unavailable due to error:
>>>>>
>>>>> overlayfs: invalid origin (ssh/sshd_config, ftype=8000, origin ftype=4000).
>>>>>
>>>>> File name changes, of course, but rest is fairly constant.
>>>>>
>>>>> This always happens when some file is written.
>>>>> Error persists reboots.
>>>>> Only way I found to "cure" the system is to go on "upper" and delete the file
>>>>> thus going back to "lower" version (in this case I should delete "/oldroot/overlay/upper/etc/ssh/sshd_config")
>>>>>
>>>>> This is a self-built kernel (Linux vocore 5.7.0 #2 PREEMPT Mon Aug 3 09:19:06 CEST 2020 mips GNU/Linux)
>>>>> on a custom target based on a SoC (MT7628).
>>>>>
>>>>> I am available to do any required test, but I have no idea about where to start.
>>>>>
>>>>> Any hint (or redirect) would be greatly appreciated.
>>>>>
>>>>> This is probably your problem:
>>>>> https://lore.kernel.org/linux-unionfs/32532923.JtPX5UtSzP@fgdesktop/
>>>>>
>>>>> It surely looks like it is.
>>>>> I tried to follow the thread, but I'm unsure i grokked it .
>>>>>
>>>>> I am using OverlayFS (ext4 over a SquashFS) on rootfs in order to
>>>>> be able to update the whole system (changing SquashFS) while
>>>>> retaining customization (essentially tweaks in /etc/, host certificates
>>>>> and similar stuff) in an embedded target.
>>>>>
>>>>> To complicate matters I also have a dual system for fallback in case
>>>>> of faulty upgrade; this means I can switch from:
>>>>>   lower=part6, upper=part5, update will go into part7
>>>>> to
>>>>>   lower=part7, upper=part5, update will go into part6
>>>>>
>>>>> I don't need nfs at all, so exporting OverlayFS is not an issue,
>>>>> but it's unclear to me if this "lower swapping" is
>>>>> actually supported as I see:
>>>>>
>>>>>>> /me is again wondering what's the use case of modifying lower layer
>>>>>>> with an existing upper. Is it fair to say, no don't recreate/modify
>>>>>>> lower layers and use with existing upper.
>>>>>>>
>>>>>> It's fine by me to document that this is not supported.
>>>>> ... which is scary.
>>>>> Note I do *not* need to modify lower on-the-fly, when I
>>>>> swap systems, that will happen at reboot.
>>>> Don't be scared :-)
>>>> Your reaction is a good answer to Vivek's question above -
>>>> No, it is not fair to say don't re-create lower and use existing upper
>>> This seems like a wrong use case to me. So in above example, say
>>> following happens.
>>>
>>> - Mount overlay
>>> - modify sshd_config (it gets copied up).
>>> - Lower squahsfs gets updated and /etc/sshd/sshd_config gets updated.
>>> - Mount overlay and user now sees old copied up sshd_config. (If it
>>>   works).
>>>
>>> Conceptually it is not making much sense to me. What's the point of
>>> upgrading lower because after mounting overlay you might still see
>>> old file. And to make it worse, behavior is underministic beacuse
>>> if file has not been copied up, you will see new file.
>> It might not make much sense to you, but it's EXACTLY what I need.
>> This OverlayFS is used *only* for permanent configuration.
>> Most of the times I'm adding new files (like host certificates and
>> similar things), but sometimes applications provide "default
>> configuration" I might need to override.
>> If/when applications "upgrade their defaults" I definitely do not
>> want them to override my choices.
> Some packages solved that problem by keeping system default
> separate from user default files and over upgrade user files are
> left untouched.
>
> So basically squashfs image will be udpated. I am not sure how this
> will work for all the cases. What if application is updated and
> it decides to rename its config file from foo.txt to bar.txt. Now
> when application is launched, user defaults are lost anyway.
I'm in a somewhat middle position.

Targets are embedded systems and it wouldn't make any sense
to implement a fully flexible update system (deb/rpm/ipkg/...);
I just have two "packages": system and application.

I *am* the "rootfs (aka: system) image provider".

OTOH I'm not responsible for the zillions packages composing a RootFS.
A vast majority of packages provides "default configurations", often
completely commented-out and heavily commented "for reference".
I don't think it would be a good idea to inspect each and all the
packages to remove such "useless" files.

In some instances such configuration I need to override "globally"
(i.e.: for all targets in the same manner) and that's easy because
I can override in generated RootFS (lower SquashFS).

In other instances changes need to be done on a per-target
basis (note: I have ~20k targets to handle in places I cannot
physically reach after installation... I mean: i *can* reach, but it
would be expensive, you don't want to do it if net is still up).

Here I have two cases:
There are "once in the life" configurations that could conceivably
be done at a central point (e.g.: client certificates), but that would
mean to send different update images to each target, a logistic
nightmare.
There are other configs that need to be done at installation
and possibly changed later (e.g.: WiFI setup).
In both cases configurations *must* survive a full upgrade.

> IOW, what is rootfs image provider expecting. Are they expecting
> overlayfs to be there and are they writing applications in backward
> compatible manner. I don't generally boot into such systems so
> I have no idea. 
Bottom line:
I *need* to be able to change "lower" keeping "upper", otherwise
OverlayFS is simply not the right tool for me.
Alternative would be to save all configs somewhere and
restore them after an update, which is highly "inconvenient"
for many reasons, especially in system that may (and will!!)
need to be updated in unforeseeable ways.
Please do *not* enforce cleanup of "upper" on "lower" changes.

> Thanks
> Vivek
Regards
Mauro

