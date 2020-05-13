Return-Path: <SRS0=GnLN=63=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78801CA90AF
	for <linux-unionfs@archiver.kernel.org>; Wed, 13 May 2020 09:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5633C206B8
	for <linux-unionfs@archiver.kernel.org>; Wed, 13 May 2020 09:36:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="ir+tfQ/d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgEMJgI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 13 May 2020 05:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbgEMJgH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 13 May 2020 05:36:07 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837B0C061A0C
        for <linux-unionfs@vger.kernel.org>; Wed, 13 May 2020 02:36:07 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id se13so6961394ejb.9
        for <linux-unionfs@vger.kernel.org>; Wed, 13 May 2020 02:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZhJho//WL289/QlAkaVOAukzg1jzA04H0Le8jcBwrC8=;
        b=ir+tfQ/djAHgQ+vdhDtP8ruwqnFMs/ZWiVOXka1Pc3UyD0peeprWbcP1bUcQ3/+hbU
         JBsgnKiKhk0j7//IEROA7V9MLqNj/fitmGfdKOu5AXDip3k1ehAgC1kVGHfm7j2DivYL
         qQiyZpn/Fq6Tfdb3tC2ueZ7lqVxky1Pl/MYDA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZhJho//WL289/QlAkaVOAukzg1jzA04H0Le8jcBwrC8=;
        b=Z0R8ylGIxHCVP6yzmCQBc55+H9xHPuSOfSKDrLRpyg7LFKVk1GvYAKXqAKyOhenaqc
         06iWdpOlTHlvA5gpXtVItaize7AWwLF2UBsJFODC67s9OEYdxorOC9T/dKbiFm00yHYo
         J/Mb4ikPAVGYXNMSg9yv/n7LhZ6uVVDsr3lnEGSwI8wPZJ3OF+0tM4g5n7m1UHDNbEkT
         stcNtaNW2MKQJJlUeLejxZbm6Ar1iWr769NRU6DYfVC1C9kVxuroemO9zjz++xhtF4aT
         bsdQuGE6iCpGIoPDg6qDKgsGgY5NmfV9dNMdVSmhoF0/2u9FwDcrLIt1poVkKu1RwX+B
         Jqxw==
X-Gm-Message-State: AGi0PuZO3BRRTVVoDYs/EeRrxGjZwm6S9MUBxjrKXG4UdIManN83WoGM
        GLhaTJZS1epE1HFI5s8FpEsLGW+/6EkRFT+C+AavuA==
X-Google-Smtp-Source: APiQypInhD/UQ199nbjOZEthyfDI9lxm8GihO6QtzTwq0fHRRxJ0ieo265FbWiUPfONOQDidTD8Mudcu5i58KTb68NA=
X-Received: by 2002:a17:906:34c4:: with SMTP id h4mr21928916ejb.167.1589362565229;
 Wed, 13 May 2020 02:36:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200506101528.27359-1-cgxu519@mykernel.net> <20200510155037.GB9345@desktop>
 <172015c8691.108177c8110122.924760245390345571@mykernel.net>
 <20200512162532.GD9345@desktop> <CAOQ4uxiFPrMWrhqjPo3PcgKFiKwSKfh7p+f5hM5fZYKr51HEWA@mail.gmail.com>
 <20200513011019.GY47669@e18g06458.et15sqa> <1720c092a68.c8052b8d3001.6829163626760635444@mykernel.net>
 <CAOQ4uxhV4ubSLmwTh9dHg-FWXYHo8uMh8QVNXhmtN=ahBFRoHg@mail.gmail.com>
In-Reply-To: <CAOQ4uxhV4ubSLmwTh9dHg-FWXYHo8uMh8QVNXhmtN=ahBFRoHg@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 13 May 2020 11:35:54 +0200
Message-ID: <CAJfpegttGkTBFgiaUVE549DUwEedb9T9c_dZD32ZJDxdyYpKaQ@mail.gmail.com>
Subject: Re: [PATCH v4] overlay: test for whiteout inode sharing
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Eryu Guan <eguan@linux.alibaba.com>, Eryu Guan <guan@eryu.me>,
        fstests <fstests@vger.kernel.org>,
        linux-unionfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, May 13, 2020 at 5:38 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Wed, May 13, 2020 at 6:17 AM Chengguang Xu <cgxu519@mykernel.net> wrot=
e:
> >
> >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2020-05-13 09:10:19 Eryu G=
uan <eguan@linux.alibaba.com> =E6=92=B0=E5=86=99 ----
> >  > On Tue, May 12, 2020 at 07:56:35PM +0300, Amir Goldstein wrote:
> >  > > > >  > I see no feature detection logic, so test just fails on old=
 kernels
> >  > > > >  > without this feature? I tried with v5.7-r4 kernel, test fai=
ls because
> >  > > > >  > each whiteout file has only one hardlink.
> >  > > > >
> >  > > > > That's true.
> >  > > >
> >  > > > I'd like to see it _notrun on old kernels where the feature is n=
ot
> >  > > > available. But that seems hard to do.. Do you have any better id=
eas?
> >  > > >
> >  > >
> >  > > I've got a few.
> >  > > 1. LTP has the concept of require minimum kernel version.
> >  > >     This would mean that functionality will be not be tested if fe=
ature
> >  > >     is backported to old kernels.
> >  > > 2. We could add to overlayfs advertising of supported features, li=
ke
> >  > >      /sys/fs/ext4/features/, but it already does "advertise" the c=
onfigurable
> >  > >      features at  /sys/module/overlay/parameters/, and we were alr=
eady
> >  > >      asking the question during patch review:
> >  > >         /* Is there a reason anyone would want not to share whiteo=
uts? */
> >  > >         ofs->share_whiteout =3D true;
> >  > >      and we left the answer to "later" time.
> >  > >
> >  > > So a simple solution would be to add the module parameter (without=
 adding
> >  > > a mount option), because:
> >  > > - It doesn't hurt (?)
> >  > > - Somebody may end up using it, for some reason we did not think o=
f
> >  > > - We can use it in test to require the feature
> >  >
> >  > Yeah, I think that works. And I see that ext4 and btrfs both have a
> >  > /sys/fs/<fs>/features directory and list supported features there, i=
s
> >  > this something overlay could do? Or is this basically the same thing=
 as
> >  > what you proposed?
> >  >
> >
> > IMO, for those features which don't need to change module param, maybe =
feature list
> > is more suitable.
> >
>
> I suppose it is more suitable, but since at the moment there is only one(=
?)
> such feature and there is an open question whether it should or should no=
t
> be configurable, I myself would have taken the easy path, but Miklos
> often has a different perspective on these sort of things...

What exactly are we testing?

Hard linked whiteouts are an optimization, not something to be relied
on in any case.  The test should succeed even if overlayfs decides for
some reason not to share the inode.

Thanks,
Miklos
