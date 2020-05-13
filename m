Return-Path: <SRS0=GnLN=63=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4112AC2D0F6
	for <linux-unionfs@archiver.kernel.org>; Wed, 13 May 2020 03:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19A1820718
	for <linux-unionfs@archiver.kernel.org>; Wed, 13 May 2020 03:38:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QMP1kmdn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgEMDiE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 May 2020 23:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725929AbgEMDiE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 May 2020 23:38:04 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902C2C061A0C;
        Tue, 12 May 2020 20:38:04 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id b18so6475386ilf.2;
        Tue, 12 May 2020 20:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0OHnimK3vuRl/SGbtElZxSLq0yA7VOuGRYL4K1cUVwE=;
        b=QMP1kmdnPqNDuo+4GJr7hBJ+Z0liDRDOuAdWd0TQIwKBSlOHX5fKP9MysVcPKQmPhJ
         DwOxvZJ2vE4aFgw43/DEck0MbpYnLGAJcBI/bQ7V3e1YfnfYk4ctjBOgNd+o0sMAu720
         JFkHr0OV1NAnXyNH5pLkrSe9p+Q5QaA7sdIPFk3flFBUQu/V2rb4l3eDCntoxQdMAVWs
         u6pi8QLXUc8dqVOpei399FqVhxT7CesjcGVo77QQCm5PnEVl4bpuSNBGcaslduJKqJqJ
         pFPFSPjV91TRqVkkNxyxL2wxFb0yPEux51vIQWhymJ1sUap1crqCYCIHaBpYw19fRJFV
         +Caw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0OHnimK3vuRl/SGbtElZxSLq0yA7VOuGRYL4K1cUVwE=;
        b=jEXLBPvCsYbjXTmJzdqIj1nnRRLDuAigHcFV1o9WECewRLf51ZwQSzU50z6E6GEBcQ
         RRvby0bq180NzMlv8YtQkwTKMGJmr8WPZnM+V5aMoBeGu6+zflIO/HZ0M8hVta5K2rBb
         Hk9E/h+ih338WTYDvxd1/FpXeFkcMWSKQ3kMonCeGMp4DBPdDtnu9/wSBE3ozGhrH04u
         YeOWU9L9cmOQBsNkgYR0xmE6aV+5Xf4Llpi5L56uKptHaL2br6PCwQBecUsbGlNwO3+r
         MPMJv4o05PJ14qKakX2E7tscmWfbeHhFx1lr2eZyrarIM6RnDOZ6gAXqa2qllJw5Qem9
         d4gw==
X-Gm-Message-State: AGi0Pua6kBMUfoWnsuDc8zLkBYB1UKX9mAuGk5W60cw+sMEYRAE69kOq
        tI9GL55TsCjMJ7HIn5gq/uP/31SI6boTpTjqojQYMw==
X-Google-Smtp-Source: APiQypKnIpqT8hXesY4RU10HZdvdOYU8vcP8LyTXGIiL/8gHW/vfnuJ4VjE1tBiBFIsp0hpx6PCdeqxf8IvZeODfTcU=
X-Received: by 2002:a92:cb01:: with SMTP id s1mr4952894ilo.275.1589341083890;
 Tue, 12 May 2020 20:38:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200506101528.27359-1-cgxu519@mykernel.net> <20200510155037.GB9345@desktop>
 <172015c8691.108177c8110122.924760245390345571@mykernel.net>
 <20200512162532.GD9345@desktop> <CAOQ4uxiFPrMWrhqjPo3PcgKFiKwSKfh7p+f5hM5fZYKr51HEWA@mail.gmail.com>
 <20200513011019.GY47669@e18g06458.et15sqa> <1720c092a68.c8052b8d3001.6829163626760635444@mykernel.net>
In-Reply-To: <1720c092a68.c8052b8d3001.6829163626760635444@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 13 May 2020 06:37:52 +0300
Message-ID: <CAOQ4uxhV4ubSLmwTh9dHg-FWXYHo8uMh8QVNXhmtN=ahBFRoHg@mail.gmail.com>
Subject: Re: [PATCH v4] overlay: test for whiteout inode sharing
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Eryu Guan <eguan@linux.alibaba.com>, Eryu Guan <guan@eryu.me>,
        miklos <miklos@szeredi.hu>, fstests <fstests@vger.kernel.org>,
        linux-unionfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, May 13, 2020 at 6:17 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2020-05-13 09:10:19 Eryu Gua=
n <eguan@linux.alibaba.com> =E6=92=B0=E5=86=99 ----
>  > On Tue, May 12, 2020 at 07:56:35PM +0300, Amir Goldstein wrote:
>  > > > >  > I see no feature detection logic, so test just fails on old k=
ernels
>  > > > >  > without this feature? I tried with v5.7-r4 kernel, test fails=
 because
>  > > > >  > each whiteout file has only one hardlink.
>  > > > >
>  > > > > That's true.
>  > > >
>  > > > I'd like to see it _notrun on old kernels where the feature is not
>  > > > available. But that seems hard to do.. Do you have any better idea=
s?
>  > > >
>  > >
>  > > I've got a few.
>  > > 1. LTP has the concept of require minimum kernel version.
>  > >     This would mean that functionality will be not be tested if feat=
ure
>  > >     is backported to old kernels.
>  > > 2. We could add to overlayfs advertising of supported features, like
>  > >      /sys/fs/ext4/features/, but it already does "advertise" the con=
figurable
>  > >      features at  /sys/module/overlay/parameters/, and we were alrea=
dy
>  > >      asking the question during patch review:
>  > >         /* Is there a reason anyone would want not to share whiteout=
s? */
>  > >         ofs->share_whiteout =3D true;
>  > >      and we left the answer to "later" time.
>  > >
>  > > So a simple solution would be to add the module parameter (without a=
dding
>  > > a mount option), because:
>  > > - It doesn't hurt (?)
>  > > - Somebody may end up using it, for some reason we did not think of
>  > > - We can use it in test to require the feature
>  >
>  > Yeah, I think that works. And I see that ext4 and btrfs both have a
>  > /sys/fs/<fs>/features directory and list supported features there, is
>  > this something overlay could do? Or is this basically the same thing a=
s
>  > what you proposed?
>  >
>
> IMO, for those features which don't need to change module param, maybe fe=
ature list
> is more suitable.
>

I suppose it is more suitable, but since at the moment there is only one(?)
such feature and there is an open question whether it should or should not
be configurable, I myself would have taken the easy path, but Miklos
often has a different perspective on these sort of things...

Thanks,
Amir.
