Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8E6C77B72
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Apr 2023 14:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjDLOVF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 10:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjDLOVE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Apr 2023 10:21:04 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10C7469D
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Apr 2023 07:21:02 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-94771f05e20so419458866b.1
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Apr 2023 07:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1681309261; x=1683901261;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=U6Zk0kV5uyNqCMEgOxEs0anw8Gf7+M8kuxyKuMhLpwQ=;
        b=hLIE+WrwtgDonKJoSaQk5dJPmZ6sLhWQ5wYDvELiinoAinQFYZt3C0cT2ffuN2bT+o
         /SuR/2PULSw3WAW9fuEyU65cN1rz8zcbw6NJPPCoFnIqYK2gKN2UeC3SLCsh8W6+M9Uh
         2Gmp44HuH3QT/0MvCvcSs5knxAwWBzE7AC0Bs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681309261; x=1683901261;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U6Zk0kV5uyNqCMEgOxEs0anw8Gf7+M8kuxyKuMhLpwQ=;
        b=HdF4BNhk6CWDJ/+Pzd7OEjry5Tq4ZWO2lQ53421uL19AI04KmBbxT8VtQOAqftMHvA
         zuuIJGUCCtPjxuec5fer6KDw+86a10h38pwSFrtlv9hiFhTHLmjK1T/JXIJ9WY8w3Yfd
         M1igMhmqOFfuvMNHITlKP8+1/iWGraMsG/kO/PmXaKCQexoHQmE9aHU33mT8iJD1opYX
         6+ukTrPC7Ry40tkK/XjXScVNXfz0L4aK1c3AJ88nk86D8NT5mXpwhM0bmEh7WPTSUnMB
         WfRZ3zOaWPgyxIYutYYHHOgEFNkm4fC3FsRDK8NHtEyVTbJVMDu1qdUFqiKDnC+s2ak3
         /kRA==
X-Gm-Message-State: AAQBX9ebzlVijt0cZLOV1XoWNEzcgxlk+CWBw3Pke8P09WgynjRBe5Ia
        m5PYcg/6xpk7ctxFcry+qZXUmy8GalOkSzzIpRwx0iIQ3+0y59s6x1c=
X-Google-Smtp-Source: AKy350azKneHffXHPOMv4xs6Wn5pR9uUPkQEKNf+69U8NwSWoIRSWp6lLruYSYjvEtVHJ84MEep5dK/tpB2LkxUpdhQ=
X-Received: by 2002:a50:9ec5:0:b0:504:7684:a23c with SMTP id
 a63-20020a509ec5000000b005047684a23cmr3003064edf.8.1681309261311; Wed, 12 Apr
 2023 07:21:01 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1674227308.git.alexl@redhat.com> <5fb32a1297821040edd8c19ce796fc0540101653.camel@redhat.com>
 <CAOQ4uxhGX9NVxwsiBMP0q21ZRot6-UA0nGPp1wGNjgmKBjjBBA@mail.gmail.com>
 <b8601c976d6e5d3eccf6ef489da9768ad72f9571.camel@redhat.com>
 <e840d413-c1a7-d047-1a63-468b42571846@linux.alibaba.com> <2ef122849d6f35712b56ffbcc95805672980e185.camel@redhat.com>
 <8ffa28f5-77f6-6bde-5645-5fb799019bca@linux.alibaba.com> <51d9d1b3-2b2a-9b58-2f7f-f3a56c9e04ac@linux.alibaba.com>
 <071074ad149b189661681aada453995741f75039.camel@redhat.com>
 <0d2ef9d6-3b0e-364d-ec2f-c61b19d638e2@linux.alibaba.com> <de57aefc-30e8-470d-bf61-a1cca6514988@linux.alibaba.com>
 <CAOQ4uxgS+-MxydqgO8+NQfOs9N881bHNbov28uJYX9XpthPPiw@mail.gmail.com>
 <9c8e76a3-a60a-90a2-f726-46db39bc6558@linux.alibaba.com> <02edb5d6-a232-eed6-0338-26f9a63cfdb6@linux.alibaba.com>
 <3d4b17795413a696b373553147935bf1560bb8c0.camel@redhat.com>
 <CAOQ4uxjNmM81mgKOBJeScnmeR9+jG_aWvDWxAx7w_dGh0XHg3Q@mail.gmail.com>
 <5fbca304-369d-aeb8-bc60-fdb333ca7a44@linux.alibaba.com> <CAOQ4uximQZ_DL1atbrCg0bQ8GN8JfrEartxDSP+GB_hFvYQOhg@mail.gmail.com>
 <CAJfpegtRacAoWdhVxCE8gpLVmQege4yz8u11mvXCs2weBBQ4jg@mail.gmail.com>
 <CAOQ4uxiW0=DJpRAu90pJic0qu=pS6f2Eo7v-Uw3pmd0zsvFuuw@mail.gmail.com>
 <CAJfpeguczp-qOWJgsnKqx6CjCJLV49j1BOWs0Yxv93VUsTZ9AQ@mail.gmail.com>
 <CAOQ4uxg=1zSyTBZ-0_q=5PVuqs=4yQiMQJr1tNk7Kytxv=vuvA@mail.gmail.com>
 <CAOQ4uxich227fP7bGSCNqx-JX5h36O-MLwqPoy0r33tuH=z2cA@mail.gmail.com>
 <CAJfpegveZCu4zmyoeeRpqH9TmM60TgYw9cnBJuu+UyOyKJFQwA@mail.gmail.com> <CAOQ4uxjhtwXfqfCeRRp2QW=NaxvVFjo2of1X95gEazV=1-x6wQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxjhtwXfqfCeRRp2QW=NaxvVFjo2of1X95gEazV=1-x6wQ@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 12 Apr 2023 16:20:50 +0200
Message-ID: <CAJfpegtb4q+Oeqq8w6SpajX_YoVeJwkb1Frz+6Urwy6MXwg2sQ@mail.gmail.com>
Subject: Re: Lazy lowerdata lookup and data-only layers (Was: Re: Composefs:)
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Alexander Larsson <alexl@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, 12 Apr 2023 at 16:07, Amir Goldstein <amir73il@gmail.com> wrote:

> To elaborate:
>
> lowerdir="lo1:lo2:lo3::do1:do2:do3" is allowed
>
> :: must have non-zero lower layers on the left side
> and non-zero data-only layers on the right side.

Okay.   Can you please add this to the documentation?

>
> Actually, this feature originates from a request from Alexander to
> respect opaque root dir in lower layers, but I preferred to make this
> change of behavior opt-in so it can be tested by userspace.

Not sure I get that.  Does "opaque root dir" mean that only absolute
redirects can access layers below such a layer?

I guess that's not something that works today.  Or am I mistaken?

I also don't get what you mean by testing in userspace.  Can you ellaborate?

>
> I took it one step further than the opaque root dir request -
> the lookup in data-only is a generic vfs_path_lookup() of an
> absolute path redirect from one of the lowerdirs, with no
> checking of redirect/metacopy/opque xattrs.
>
> And then I only implemented lazy lookup for the lookup
> in those new data-only layers, which made things simpler.

Okay, makes sense.  If someone hits this limitation, then we can
always start thinking about generalizing this feature.

> Please see the patches I just posted for details [1].

Will do.

Thanks,
Miklos
