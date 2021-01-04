Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD95C433DB
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Jan 2021 03:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F36820DD4
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Jan 2021 03:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbhADDd1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 3 Jan 2021 22:33:27 -0500
Received: from sonic304-20.consmr.mail.ne1.yahoo.com ([66.163.191.146]:40234
        "EHLO sonic304-20.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728081AbhADDd1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 3 Jan 2021 22:33:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verizon.net; s=a2048; t=1609731140; bh=X3lnfpY+6PvMl0YX80wrVh4lYbdMOZqmlH4oMj6TPw0=; h=From:To:Subject:Date:In-Reply-To:References:From:Subject; b=EN1cXlMZBqxKAxHn9MvTD2zTjn3dlZmDkIqSi5YBw94uJ+8kNoWYgtQ3zoBySu3IDR5VUeCVmiNiLgDB9+rEjUrBfu8HLmWIABp+uN4fS6ybF+PfCjnZoOlRud3XbD890f80cyn5y2BRKZHjrUwt6FA5b3FpF5xzkjbT1BVJZgfvPJWbmcEkDdAFQm4NQvxEPTuQZMG7hoHAMMNgiU0mVxCQ9NclIIxVdF8EJCK1QpUyVh8T393A/3CbyDy0wsxD+W961VndtH114jtPzO3pLA1T4Ln1OQfMczzlhyvTfUxcx9gT547pAdvTjCM++Z4JlqqmlW3zDai0/0gXzVPszw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1609731140; bh=eKvMeKcjVkA4XYUFCjZlm/UtmcxPiHSYvB7gs3D/Wvk=; h=From:To:Subject:Date:From:Subject; b=nwhkW8bmAwmAa3v7o7VjhLcfTmAJlxrH/0fHxYKjLfKx/GY6d0FgjqzEM75KPHNUhe7b+ynaMYjiEhuntfHOenExPEC9RENV9V22g3q2/VPg44FnSgpDlKO/UCwQjL5QXc+Fyg9JmTQGiWf4DFv5RqQEBzH8vggjpgHn8b9IKHyR7KysTdKDtWcUtKVYXadpGSOxU2cJ2u3FyLYI6wkquRP60UoWE42KUEPDZAIYgZny9ZkBO9n69MzZakyA2LmJ/FFNKSuDrUABYM6OERUJCK7tVd6jNtgws4c70P2QQRCrYBExSBkg6tGaMNuu81sVz6HipkGrprqq9KAiTQPkRw==
X-YMail-OSG: XSbebdUVM1k34e8AfFrHfKTzOrKzlZgcpVUP_Foqiyu8apEdQZDQziNG3jrf6ds
 9_3jtVRX0o0pinN_Z2KWqXraMr61k67LLWmNCUPbVuq9xMrXxgGfOpUVRaTPXH4HkVekC9eDoCBN
 wVOIfPj2CtjccT4kJcEvhjll_2gD2UsvR4Jc0mwwO9ZtmfdUlAKnQnECAD2PbBa546KDU9Bh67Ww
 lytF2VgI43n9d5UVgW2hVYpXNhepjU63VU4gZZ2Bqe8Rp0mROW6lsXN8.fFTM0en.J5Yhe5cfPqE
 Y5eb22cY2bFnJjHR2SDxtL5hVGE6VP8XRszuVqpXRehPU0_QalePhPfVeO8GE.Z9TR2n6R04NP4T
 gt13681OBKfP1YzSlaD.FWlu6XmMqrNje.19erz5xfQF_20EW5jvimZLIBKIxl8edK63.pfT9NQh
 yGn7pTvSkZO86qqjDpy5ra_YKq.XrB6T17oph1fw2GtoDKuJoUIjKL2JgA.Vg7Wo0_Xh19fw4LoO
 GGgMrZ5.c3W1ywnXdpL9v7EbCX21NcDGdQMNqW5fnj1HCJ1uusatQUN7emSMBOijUPDuZ_YCtGyJ
 LeDyvVIONRa6dvwhEnp9bG.5vZFfo.Ek_BpyKBvVjORUegB7BMrDHP7q9i6paTceJabmK7XtVa.B
 Ar5HtjyhvdKDmPBuHb0_678HHIduFYh6oCfQXFWwXvbclea3CZo3_6bC5b4ZA9UdbrZmh35P4_9W
 Rne9jeVNr2rvir698wmN0irs9fqbArDcXL0fiXimubaW6HHGusrKwEmwr.9t_NzrkxnDa2e3b8Cb
 6bgaEgqclDsMIQSW.2RpH28lB1VEZ7knoBRm0yDUhuzF14BfT0OxsNDEX0pyGeFtPbbDxPb.Yj5Z
 svt7u5WO5VpoBET9jd4f9t5n.XJPvHrRDzVRF6XGuqZrFJFqYmt5LbSBnli3KvMlyqRbvpm2XRtw
 Q56y2Vu4JFT004SvEHkSQixi1sTDuaPFHRHX9UUh9KI_0SdQedIIFcJKIhGNii2CyD1w33BPq6c0
 wGwDhoYvtRHsprQ1vbQhL04GTpmVpzFRkf2KyIt8DYzeAdLYWh52dUny8h5TYoketYvZQmEaLe7S
 MFMCTVDHu63pTEHtVKdDf43NZMtmV_O4HoZCm46zIPfHUqzPgor0wdqUikWXroQd.qGAPSeaGpWn
 oNjDUKctaubJRhaoN4k_YL6oDsUwVY7F7gTvjPiYsxIKlxBCj_.SQYarLh3hF6fUFOgGD5yknIdT
 pAp19uD9u3ac1iagtm7eg55FPKkgKAVDHynT.FK8FLA.J2apGa_UiF_1_3NsgYcvJZ0u1CPz6pjL
 T9GPAhGuiQc3LA5Lp4h.im6v8uWo5UbU_4DhcmlRQIKfHg22uM13xb14tl_hAeVD4EWNUTojkRLi
 i20l0AD2bRpBU4mzmZ43Zfz.XJH38i0V3PBzNFY6qcs5026WvH_8bUXoXo6GUbiHBGyE_pW4lbDE
 hatD95.TrtAeA7t_l94sEtmibuwTP23k0WyoFm4Cic9HC6eAjHCOxrn9l05EsseZRsXw_ilBVn62
 1ZZiIH6IcaoSBzcI6S_sDnmaXKO17gK_dr4zNg7maIECjhpligMTCzVNjwydlN6wl540X5XnkJGa
 XBIoFrHP6zByVImbvJwkdOfjkdRt5MMNgMEDte28IKECiKuyfs3TTTeCeR5YeKnHaIuMG7kjNnTD
 W3gP3BvnRHSs5rCZjXGZKkG_pN0Rq95ky8pPHx497oG1v392KFCFMrfzq0ZFUqTzZWtpqIxCf9Jw
 lr9ztmfcvJCx.ffN.SEXwfqWBkBbE0fSJx0j22c2LXJk2U4JBIN_7EMKczRx8hBdNooeKIgNGLgC
 CH0_uYenbz3YalK39FP7OKWaqelT6UEOlMy5b4dLWURVb4hljCbDiciu4g5hZQrwporF.eC2kCkp
 yVop4URdhT5NhQ20A4o1sKyUuyNH88rL4KhEt8zxVuoMW5m2xa4FABpgudhSegvRwZZI4bpFGkGE
 pvaW1yBIGo2WXDz2M1b2xO7qVmqW14zvX_nA5.7YGbqX4K.dHWu7SG6idNGcGFoJ4FMJx5nIGnN9
 pYfQSqcHMx2KXLID_wjJApUS8Cjesc_oJjOP5p7dFtED_HRhYkfAEmlyUeSTApLXBCShzMIkJZxF
 EzbMtGENBndbZaNDtBgIxz3S6dPhmxNE8qd3GGzPg2MpogxpW6ogSVldPuyhfYr.UStF2R_EjNPU
 RcZIJMuMo9_l7vAOaQKJUzbRaD.8rLOqqsZs67IgiDZw10M0nDDKArQykUMMuAYtpOqrJEHtxHNw
 P8chHkL1_tRxN3wq.ufD5tbopgUCBdlXIwIaVhyTSykQrAZ1J9odXnoUN.P7okYtHzD3uiB3t
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.ne1.yahoo.com with HTTP; Mon, 4 Jan 2021 03:32:20 +0000
Received: by smtp409.mail.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 024eb19a8787a3a6188755f0202f7b02;
          Mon, 04 Jan 2021 03:32:18 +0000 (UTC)
From:   nerdopolis <bluescreen_avenger@verizon.net>
To:     overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: Incorrect Overlayfs documentation
Date:   Sun, 03 Jan 2021 22:32:16 -0500
Message-ID: <2527352.xHhNOModH5@nerdopolis>
In-Reply-To: <CAH2+hP4=9A2fWkJgJhUZps+5gCqZfPSzfNJDXW3FHjDZmk3-vA@mail.gmail.com>
References: <1750303.WlVpaa6DS8.ref@nerdopolis> <CAOQ4uxj3oPfbdCt1bLrSp91O_QD4cqPBxqc6ZVgS3kXXDnDBfg@mail.gmail.com> <CAH2+hP4=9A2fWkJgJhUZps+5gCqZfPSzfNJDXW3FHjDZmk3-vA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: WebService/1.1.17278 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol Apache-HttpAsyncClient/4.1.4 (Java/11.0.8)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Friday, January 1, 2021 10:17:08 PM EST Marco Nelissen wrote:
> On Tue, Jul 28, 2020 at 10:52 PM Amir Goldstein <amir73il@gmail.com> wrote:
> 
> > On Thu, Jul 23, 2020 at 6:51 AM nerdopolis
> > <bluescreen_avenger@verizon.net> wrote:
> > >
> > > On Thursday, July 16, 2020 1:03:52 PM EDT Amir Goldstein wrote:
> > > > On Thu, Jul 16, 2020 at 6:09 AM nerdopolis
> > > > <bluescreen_avenger@verizon.net> wrote:
> > > > >
> > > > > Hi
> > > > >
> > > > > A while back I opened up
> > https://bugzilla.kernel.org/show_bug.cgi?id=195113 describing a
> > documentation problem in
> > > > > https://www.kernel.org/doc/Documentation/filesystems/overlayfs.txt
> > but for whatever reason, it hasn't been seen.
> > > > >
> > > > >
> > > > > The problem is that it says "The lower filesystem can be any
> > filesystem supported by Linux"
> > > > > however, this is not the case, as Linux supports vfat, and vfat
> > doesn't work as a lower filesystem
> > > > >
> > > > > So there's no way to tell what filesystems are applicable for an
> > overlay lowerfs,
> > > > > and I don't think any existing userspace utilities can detect it.
> > > > >
> > > > > Could it be possible for the .txt file to be updated?
> > > > >
> > > >
> > > > The way it works usually in this project is you can submit a patch to
> > fix the
> > > > problem:
> > > > https://www.kernel.org/doc/html/v4.17/process/submitting-patches.html
> > > >
> > > > But if you don't want to go through that process, you can offer a text
> > to
> > > > fix documentation.
> > > >
> > > > But I myself cannot offer anything better than:
> > > > "The lower filesystem can be one of many filesystem supported by
> > Linux".
> > > >
> > > > I don't think that we want to start listing the supported filesystems
> > in
> > > > documentation.
> > > >
> > > > FWIW the description of upper fs isn't uptodate either.
> > > >
> > > > Thanks,
> > > > Amir.
> > > >
> > > >
> > > Hi.
> > >
> > > Yeah, that process might be cumbersome. I guess what you have is good.
> > > Maybe "A wide range of filesystems supported by Linux can be the lower
> > > filesystem, however, not all filesystems that are mountable by Linux
> > have the
> > > features needed for OverlayFS to work"
> > > ?
> > >
> >
> > That sounds good to me.
> >
> > CC the maintainer in case he wants to apply this documentation "patch"
> > himself.
> >
> > Thanks,
> > Amir.
> >
> 
> A documentation patch was submitted for this a few months ago (
> https://github.com/torvalds/linux/commit/58afaf5d605f091abf7491774e34fa29d4a1994c)
> however I think the sentence "A read-only overlay of two read-only
> filesystems may use any filesystem type." should also be removed or
> rewritten, since a read-only vfat fs still can't be used in an overlay as
> far as I can tell.
> 
Yeah, testing on a read-only vfat filesystem as the lowerdir and it doesn't 
work Something to do with dentry's and ovl_dentry_weird. I don't think 
there's any way to determine that with a userspace utility or not.



