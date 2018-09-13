Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from pb-smtp20.pobox.com ([173.228.157.52]:52595 "EHLO
        pb-smtp20.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727600AbeINANQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 13 Sep 2018 20:13:16 -0400
Received: from pb-smtp20.pobox.com (unknown [127.0.0.1])
        by pb-smtp20.pobox.com (Postfix) with ESMTP id 96F9029274
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Sep 2018 14:54:57 -0400 (EDT)
        (envelope-from jdb2@pobox.com)
Received: from pb-smtp20.sea.icgroup.com (unknown [127.0.0.1])
        by pb-smtp20.pobox.com (Postfix) with ESMTP id 8F8AA29273
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Sep 2018 14:54:57 -0400 (EDT)
        (envelope-from jdb2@pobox.com)
Received: from [192.168.1.20] (unknown [73.55.237.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by pb-smtp20.pobox.com (Postfix) with ESMTPSA id 8D0D029272
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Sep 2018 14:54:54 -0400 (EDT)
        (envelope-from jdb2@pobox.com)
Subject: Fwd: Re: How to access "upper" directory of overlayfs programatically
References: <5B9AA5EC.8050600@pobox.com>
From: Jonathan Busby <jdb2@pobox.com>
Message-ID: <5B9AB275.7010408@pobox.com>
Date: Thu, 13 Sep 2018 13:54:45 -0500
MIME-Version: 1.0
In-Reply-To: <5B9AA5EC.8050600@pobox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Oops... forgot that I was replying to you personally :)


-------- Forwarded Message --------
Subject: Re: How to access "upper" directory of overlayfs programatically
Date: Thu, 13 Sep 2018 13:01:16 -0500
From: Jonathan Busby <jdb2@pobox.com>
To: Amir Goldstein <amir73il@gmail.com>



On 09/13/2018 12:33 PM, Jonathan Busby wrote:
>
>
> On 09/12/2018 02:48 PM, Amir Goldstein wrote:
>> [changing over to overlayfs list]
>
> Thanks for this! :D I had been searching for an overlayfs mailing list
> but it seems I overlooked unionfs.
>
>>
>> On Wed, Sep 12, 2018 at 8:52 PM Jonathan Busby <jdb2@pobox.com> wrote:
>>>
>>> Hello. I'm new to this list and I don't know if this is the right forum
>>> for my question, but, I've asked this same question on many forums and
>>> never received an answer -- please don't flame me.
>>>
>>> I have a Debian based Linux live system which is running out of RAM and
>>> was booted without the "persistent" boot option, so the capser-rw
>>> filesystem was never created.
>>>
>>> I wish to gain access to the "upper" directory of the overlayfs
>>> filesystem in the casper init scripts initramfs "/cow/upper" filesystem
>>> so that I may programatically save the filesystem, hopefully without
>>> having to re-implement cp.
>>>
>>> I know how to commit the changes of a Debian based live CD session to a
>>> storage device, but only if the live session in question was booted with
>>> the "persistent" option.
>>>
>>> I've looked at the overlayfs source code but I still can't figure out
>>> how to accomplish what I want.
>>>
>>> I'm sorry if this is  stupid question -- hopefully it's not.
>>>
>>
>> I don't think the programmable API you think of exists, but maybe
>> you can get access to upper dir as admin user.
>>
>> Please share the init scripts responsible for the mounts at live CD boot
>> and the content of /proc/self/mountinfo
>
> The contents of /proc/self/mountinfo are can be found here :
>
> https://pastebin.com/raw/9uQdJ66w
>
> The init scripts responsible for the live CD mounts can be found here :
>
> https://www.dropbox.com/s/j4zqsn8avxrv6zf/initrd-scripts.tar.gz?dl=0
>
> Thanks,
>
> Jonathan
>
>>
>> Thanks,
>> Amir.
>>

I forgot to mention that the init scripts that handle mounting the
overlayfs chroot are located in the /scripts/casper directory, and the
main script is just called "casper".

Regards,

Jonathan
