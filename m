From: Daniel Axtens <dja@axtens.net>
Subject: Re: 45aebeaf4f67 "ovl: Ensure upper filesystem supports d_type" breaking Docker
Date: Wed, 18 May 2016 08:39:08 +1000
Message-ID: <87k2is71ir.fsf@gamma.ozlabs.ibm.com>
References: <87d1ombix6.fsf@gamma.ozlabs.ibm.com> <20160516130727.GA26411@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:32968 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbcEQWjP (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 17 May 2016 18:39:15 -0400
Received: by mail-pf0-f193.google.com with SMTP id y7so3117278pfb.0
        for <linux-unionfs@vger.kernel.org>; Tue, 17 May 2016 15:39:15 -0700 (PDT)
In-Reply-To: <20160516130727.GA26411@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, mpe@ellerman.id.au, mszeredi@redhat.com, dchinner@redhat.com

Hi Vivek,

Sorry for the delay in getting back to you.


> What't the underlying fs you are using. overlayfs requires underlying
> filesystem to support d_type and there were cases where xfs was
> built with ftype=0 and in that case xfs does not support d_type. That
> means it led to issues like whiteouts not being recognized and being
> left behind during various operations.

I'm using ext4 as the backing filesystem for Docker.

However, if I manually mount an overlay directly on the ext4 fs, it
works just fine.

Therefore, I suspect the problem arises through some magic Docker is
doing. I think it is layering overlays and may be doing that in some
weird way.

I'm hopefully going to get some more time to spend on this problem (and
on that machine) today. As soon as I can unpick what Docker is doing
I'll post more details.

Regards,
Daniel

>
> So it became clear that we need a check at mount time to make sure
> d_type is supported otherwise error out. This will require users to
> do mkfs.xfs with ftype=1 to make progress.
>
> I think new defaults for mkfs.xfs are such that ftype=1 is set. I am
> not sure which version that change was made in.
>
> Thanks
> Vivek
>
>> Reverting 45aebeaf4f67 ("ovl: Ensure upper filesystem supports d_type")
>> fixes the issue for me. I haven't investigated the root cause yet - at a
>> guess I'd say either Docker's layering system, or some weird interaction
>> with namespacing, maybe? I'll have a look when I get a spare moment.
>> 
>> For reference, I'm using docker 1.11.0-dev.
>> 
>> Regards,
>> Daniel Axtens
