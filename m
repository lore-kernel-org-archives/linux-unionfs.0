Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D8BC77B6E
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Apr 2023 14:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjDLOHL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 10:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjDLOHK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Apr 2023 10:07:10 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF411738
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Apr 2023 07:07:07 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id x26so932437uav.3
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Apr 2023 07:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681308427; x=1683900427;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=85p2tndvkROUxGkBE8d+d0WqA3Tm6Lp9n6Yv+SdkX+k=;
        b=EwQ6Ukx+982beCUddAj8aa5JPDvi9GqvoZLNcO+0/trb2JxCqWja5Ju389+xAJqaTR
         WZ7XrNZ1K5KQ88pulOK6TArcm3tKtcKplXm2nZMVF+DoQg1w3FBrHivZOC8x8Dvkbp8w
         YXuOv49sRHX+UkFmgz3xDvbWThJzJX0c96v8VQgUxo4YuepzR4Mo+Cd2Rew9DAgUJWp6
         lfZBHbnQ/pRHUz1kXS+nJYv8riRWpaDxUNs2q7ow+rIzh9nINtmUqEIn5Wn0CFXykVP4
         JSOiZp+6PKni/HqMExvqNI7tstVXLg7N2iCU4NBXSkWdIrrb/6Q7AXu5nxwH31EWIOrC
         kBsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681308427; x=1683900427;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=85p2tndvkROUxGkBE8d+d0WqA3Tm6Lp9n6Yv+SdkX+k=;
        b=DxWqX0SvNUKV5aG67K6E4P2B1e48aaucs2ofCg0iEP6Sv7lkeOazw3RCPtPT+eT2qn
         LoZM/BbFJwEbkOt4m7qAFH8eDUxcKe7M4jTJc4zyAylKRvWHewx1Q6VN+vQfvzLu0Wta
         +ZTdE7Qo6enx/ohnzoyNnPXSd3o69i0e/rD5gnaF3t9iuVXbgEYsFkVeO3zy4MyY0bxK
         SBNtHLzI1xGEvO+hrBQPbXkH7MrKhHCNUdY19piqgJivCrz5Yf5yCf3ItsFKXXGMdI+l
         7cb1CFhNMFh5tc5Kn6p4wGJymqr1oq/7BgPAOnrWVjsTZoh8MnLwoLbRY9bDseCZub4Z
         rSZg==
X-Gm-Message-State: AAQBX9d1swNzJ/N453DEY9NlQ3vMq8HCN50WPXUxGIwFdbc4cMWtKgPs
        HVOs5+u9bAfSD+euyDwpw8ce2yrvwKAqxSm6XVpCXpn67TY=
X-Google-Smtp-Source: AKy350a5IcZ/kpwwQthljAI4j9Bs21vWIFwa/9qd3QO8MkzU1UOUR24tUxN1RckZKHpzgg1g8BuxWVLPJuhPRUmXZyg=
X-Received: by 2002:ab0:5406:0:b0:68e:33d7:7e6b with SMTP id
 n6-20020ab05406000000b0068e33d77e6bmr3917354uaa.1.1681308424760; Wed, 12 Apr
 2023 07:07:04 -0700 (PDT)
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
 <CAOQ4uxich227fP7bGSCNqx-JX5h36O-MLwqPoy0r33tuH=z2cA@mail.gmail.com> <CAJfpegveZCu4zmyoeeRpqH9TmM60TgYw9cnBJuu+UyOyKJFQwA@mail.gmail.com>
In-Reply-To: <CAJfpegveZCu4zmyoeeRpqH9TmM60TgYw9cnBJuu+UyOyKJFQwA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 12 Apr 2023 17:06:53 +0300
Message-ID: <CAOQ4uxjhtwXfqfCeRRp2QW=NaxvVFjo2of1X95gEazV=1-x6wQ@mail.gmail.com>
Subject: Re: Lazy lowerdata lookup and data-only layers (Was: Re: Composefs:)
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 11, 2023 at 6:50=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Mon, 3 Apr 2023 at 21:00, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > > > >
> > > > > I think lazyfollow could be enabled by default after we hashed ou=
t
> > > > > all the bugs and corner cases and most importantly remove the
> > > > > POC limitation of lower-only overlay.
> > > > >
> > [...]
> > > > >
> > > >
> > > > Lazy follow seems to make sense.  Why does it need to be optional?
> > >
> > > It doesn't.
> > >
> > > > Does it have any advantage to *not* do lazy follow?
> > > >
> > >
> > > Not that I can think of.
> >
> > Miklos,
> >
> > I completed writing the lazy lookup patches [1].
> >
> > It wasn't trivial and the first versions had many traps that took time =
to
> > trip on, so I've made some design choices to make it safer and easier t=
o
> > land an initial improvement that will cater the composefs use case.
> >
> > The main design choice has to do with making lazy lowerdata lookup
> > completely opt-in by defining a new type of data-only layers, such as
> > the content addressable lower layer of composefs.
> > The request for the data-only layers came from Alexander.
> >
> > The current patches only do lazy lookup in data-only layers and the loo=
kup
> > in data-only layers is always lazy.
> >
> > Data-only layers have some other advantages, for example, multiple
> > data-only uuid-less layers are allowed.
> > Please see the text below taken from the patches.
> >
> > What do you think about this direction?
> >
> > Alexander has started to test these patches.
> > If he finds no issues and if you have no objections to the concept,
> > then I will post the patches for wider review.
> >
> >
> > Thanks,
> > Amir.
> >
> > [1] https://github.com/amir73il/linux/commits/ovl-lazy-lowerdata-rc2
> >
> > Data-only lower layers
> > ----------------------
> >
> > With "metacopy" feature enabled, an overlayfs regular file may be a
> > composition of information from up to three different layers:
> >
> >  1) metadata from a file in the upper layer
> >
> >  2) st_ino and st_dev object identifier from a file in a lower layer
> >
> >  3) data from a file in another lower layer (further below)
> >
> > The "lower data" file can be on any lower layer, except from the top mo=
st
> > lower layer.
> >
> > Below the top most lower layer, any number of lower most layers may be
> > defined as "data-only" lower layers, using the double collon ("::") sep=
arator.
> >
> > For example:
> >
> >   mount -t overlay overlay -olowerdir=3D/lower1::/lower2:/lower3 /merge=
d
>
> What are the rules?
>
> Is "do1::do2::lower" allowed?
> Is "do1::lower1:do2::lower2 allowed?
>

To elaborate:

lowerdir=3D"lo1:lo2:lo3::do1:do2:do3" is allowed

:: must have non-zero lower layers on the left side
and non-zero data-only layers on the right side.

Actually, this feature originates from a request from Alexander to
respect opaque root dir in lower layers, but I preferred to make this
change of behavior opt-in so it can be tested by userspace.

I took it one step further than the opaque root dir request -
the lookup in data-only is a generic vfs_path_lookup() of an
absolute path redirect from one of the lowerdirs, with no
checking of redirect/metacopy/opque xattrs.

And then I only implemented lazy lookup for the lookup
in those new data-only layers, which made things simpler.
Please see the patches I just posted for details [1].

Thanks,
Amir.

[1] https://lore.kernel.org/linux-unionfs/20230412135412.1684197-1-amir73il=
@gmail.com/
