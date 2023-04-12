Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 226D1C77B6F
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Apr 2023 15:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbjDLPmL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 11:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbjDLPmJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Apr 2023 11:42:09 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3384EDC
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Apr 2023 08:41:59 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id x26so1161282uav.3
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Apr 2023 08:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681314118; x=1683906118;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GPBDC6KNxeHU72w8EhpRkZPg3ndSE4YtHkD7z4atMgM=;
        b=dkdUyut4ZCn7rk6CeZuOxMQO8mgus+06ruDC1lH4ZiCQVpBgO859trg+ewQgKgZ+lq
         Nlae1Yw87faZX2xAnbgllzsZbCvlYZgepdpSN7T74aYwNo96Nh1N3RctnmE4QKjs1yk+
         Hmd4ICVRvZSCKpkcS7ofzlYFD8V+77Xs+dCek0eZNntoHv6R4QZPSA3VQK1UF2PmA7Ca
         tDvFMjF3z1eoiADjVdqYsmVCvtl2bomDU3KQTJFl5CzG4wjeVg1SoCO7DYzHJ/ViuTXO
         3xTAD6b7tDfwOqbC+u0pyBv9QNIOZU8lyPMDcMsyQrQpVs8WUQxjDWSmhDEzR4HHdoze
         OntA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681314118; x=1683906118;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GPBDC6KNxeHU72w8EhpRkZPg3ndSE4YtHkD7z4atMgM=;
        b=jJcOxHsLR0g3RPW6TjvSF2nZJdV7wgdE1pwnuoNv0f9gO7Sm3yEiaKtytQt7p1MwWK
         VCUeU47JzBKOqr1lHm2ewiM2E61FYm7Q2C8vy04i9EImT1du2TTzx+/bQKGragHhOZxo
         Kf7ubMdv+5on7/3JljaJlECJF0eB+KqLu+f0cjiWFlFpNklF2WdO0LlI4XqOPLN9aOnG
         gZFm9vzreoAg8Wl0vaMSRiKC/2yUb8qr6NfKBh2Rby69NKr5JD2pVvA8Yz+H83yl3HQ1
         qf8utea/PTU3BEdH7R3SMM2a0HNA91rKYYiF+pYTiUXE/54HajVZ+wsCxMz8AP485BZi
         QGtQ==
X-Gm-Message-State: AAQBX9cxafzFAch61OUbSqzBHQd+SQeBxfgiyaSC2PNbYp2ShTNpsc7t
        aBL/B30zsDP910LvC8jytEM6W/1vcRUV44Mgk0Y=
X-Google-Smtp-Source: AKy350Z52+Ng2SWX0xD3aSTrSzTrm+T9JgSRDr5eD6WjFpKONfyGA3H5kX1d3xSLtJ2Vqg6TDkLt+GRad2HF/swOppI=
X-Received: by 2002:a1f:910b:0:b0:406:6b94:c4fe with SMTP id
 t11-20020a1f910b000000b004066b94c4femr8449690vkd.0.1681314118282; Wed, 12 Apr
 2023 08:41:58 -0700 (PDT)
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
 <CAJfpegveZCu4zmyoeeRpqH9TmM60TgYw9cnBJuu+UyOyKJFQwA@mail.gmail.com>
 <CAOQ4uxjhtwXfqfCeRRp2QW=NaxvVFjo2of1X95gEazV=1-x6wQ@mail.gmail.com> <CAJfpegtb4q+Oeqq8w6SpajX_YoVeJwkb1Frz+6Urwy6MXwg2sQ@mail.gmail.com>
In-Reply-To: <CAJfpegtb4q+Oeqq8w6SpajX_YoVeJwkb1Frz+6Urwy6MXwg2sQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 12 Apr 2023 18:41:47 +0300
Message-ID: <CAOQ4uxj2170q07Fmaxp9=R=cPo_q_Q61ky3TCyzwp2ii6SXpqw@mail.gmail.com>
Subject: Re: Lazy lowerdata lookup and data-only layers (Was: Re: Composefs:)
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Apr 12, 2023 at 5:21=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Wed, 12 Apr 2023 at 16:07, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > To elaborate:
> >
> > lowerdir=3D"lo1:lo2:lo3::do1:do2:do3" is allowed
> >
> > :: must have non-zero lower layers on the left side
> > and non-zero data-only layers on the right side.
>
> Okay.   Can you please add this to the documentation?
>

OK.

> >
> > Actually, this feature originates from a request from Alexander to
> > respect opaque root dir in lower layers, but I preferred to make this
> > change of behavior opt-in so it can be tested by userspace.
>
> Not sure I get that.  Does "opaque root dir" mean that only absolute
> redirects can access layers below such a layer?

Yes, that's what he wanted. to hide the subdirs being redirected to
from the namespace.

>
> I guess that's not something that works today.  Or am I mistaken?

You are not mistaken, it is not working today.

>
> I also don't get what you mean by testing in userspace.  Can you ellabora=
te?
>
> >
> > I took it one step further than the opaque root dir request -
> > the lookup in data-only is a generic vfs_path_lookup() of an
> > absolute path redirect from one of the lowerdirs, with no
> > checking of redirect/metacopy/opque xattrs.
> >
> > And then I only implemented lazy lookup for the lookup
> > in those new data-only layers, which made things simpler.
>
> Okay, makes sense.  If someone hits this limitation, then we can
> always start thinking about generalizing this feature.

Yap, that's what I thought.

Thanks,
Amir.
