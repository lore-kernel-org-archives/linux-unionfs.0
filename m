Return-Path: <SRS0=N6zz=BC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F5A3C433E5
	for <linux-unionfs@archiver.kernel.org>; Thu, 23 Jul 2020 03:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D85AF206F4
	for <linux-unionfs@archiver.kernel.org>; Thu, 23 Jul 2020 03:51:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=verizon.net header.i=@verizon.net header.b="I2EWsNS8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725843AbgGWDvH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 22 Jul 2020 23:51:07 -0400
Received: from sonic306-22.consmr.mail.ne1.yahoo.com ([66.163.189.84]:43280
        "EHLO sonic306-22.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725774AbgGWDvH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 22 Jul 2020 23:51:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verizon.net; s=a2048; t=1595476266; bh=KRCci0737pdhASY/kiGIUnU1Z3F+MX3oOCl5BiNdxLI=; h=From:To:Subject:Date:In-Reply-To:References:From:Subject; b=I2EWsNS8Mvk/ENjeRgcXPmwg1jkeAs1Zelb6Pq3UjQWNyKEFB6k/eVoA3bqn21BTrrsQR+BF6XP7nBB5+CJLJjnvG1AgdnBDx1j9NeXAduX3i9xwcZ1dfa9j4v9qscrx1klQfRwblUoliYfwuj05qvLqP7dksh8W6XkqoQjGq4cSbzD81uxMMSrHnXfbB4Mc2zJfl4PAjSkQA/pVAMxW1yDrICen0wNCRcT6NP3EUWLZJMG0eqUcGM/RmvEtISr8XtyhOjqDrlf7PcFDnnFKorrJaTCDDliD/yXZC/kevByv/uR6e3gIxYSsOSouEvuGQ8/ZIq66R38MO3AY++/nWQ==
X-YMail-OSG: wjNphMsVM1nqLNEZ.2Mr.bVJLOjtg0eIUUBKDCvKP4R35rg5ecl2Tu2.Wnr.e21
 TXE56f8odaYrz13c.RM.aDVYNX1rYELM_63LSN7FiirMACbj7XKpo0rGruY5BjnIVkhis8bERHjj
 5NJ1Uzn2_nbIGGb2mNluDDUOfeqTDBmeRmFGGdPDkzEs7DeuOEzTA3GExgNlxCAzPLmNGEeama7f
 cBEDQjh1NYPDFVaU9xdlDrK1xSBraChRqrqt5IbhgOUC6v92rm6Al9Wqlcq7lrm20L0oiTlcp3VL
 8Wvw0rFkBoOfr2RD4_6kX45FJ3mrLRObQSgkWeWkwkdEpBQvAT.iM4ff4h6ka1FAzQG0O0Wr9Qbg
 NCCE0NOGw1J75WWMrbKdTs4HGDaAcfnT5UkIZXDN.uMrX3G6D7j9ixHOXH1KY1Mz0Rtxm9afpYvj
 Vi7jO3bgtzWX14ockUJno0FNMoqAgHTfCFXAUCk3Y8hFE8HzUfqAwrlrSKC2bctN6irlym9uqPO2
 nCUgTKXrsrnmNVLGF07Ekb9_GQnedVXYGyT1sLdR2Foi8NiAYA2hJiJN3lu3dzxf0jRS7cD7Exts
 NFrHFHmDxcZrmIaKvhwSH9r9v.DVomOLe8KF8Qmo4GT0VnJXYHMw1qLAVzAh2qn0D_DwYHhWsTjX
 L5XW2CvM5DC4vgD4uG8CYbss7A9.cois6mRdaOKAuZp1WD3QHlUI1P8SrZAN3Hkaem66_ttAfxpj
 .r4PqoTlRlo2OrE1hMTIh7AqT9GcT0Z4y5JYQEA31jw6NmOD6lHgbBTqUaa2TypsrkVH.QGFjzfe
 xw8E.LyTlHNB4yfqODTkXzokGTjbjrEfE9lBBeGpu8bdT9pn4h_4hVCphq1OQNOz3OQqFbAqI8VJ
 sOqPMx.opHzOYyYl4CFcHZcN2XZlrg9mb2FqRN2K_1is6_MmiHdpt0T8i4y3R0iN_el16BpZvldr
 QCrNQs71G29ConMhVXQmRi9YrY08hlXkJ4i0wGuNqtXjYtfDaWn9g8_woJFbXoSGS0NL.qhSWNzz
 7_OL0Mywcml233ouhvZTteDuLkG5yvaPczT_.VUzWmS1.EsfCDvCHMkJCc0kUy73nkMtg73Xi7J9
 9d.gHYkL1ZoWkmIUPKjXzU9rP9PjcDH_fNatkzXOes0g2p.izRB3PH3j2a6IAiakfxjPm2j0.MdX
 AEmULeKEmDk1T_wqeigimMraN0Bs0iX1_MLCxY3sWD7AlWSGGNliF2qwyibq5AWdGWJZKp.yMM4T
 QmzKHLQo4z_oSdZp1jJ0TsLU_i2F69IP8fUof4NsEv_jsr7kFxRcjDhSAGuKgp.SXAgxCZMIyZlU
 CHyKMIfYYN.rJHbG3iQqV79ZPX6kX8uYJX0WANDGUu96ppoSJdxpqsksUvcAPtv6RPpVguw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Thu, 23 Jul 2020 03:51:06 +0000
Received: by smtp421.mail.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 582f652b41e806ec4ae33a0b40dc2454;
          Thu, 23 Jul 2020 03:51:01 +0000 (UTC)
From:   nerdopolis <bluescreen_avenger@verizon.net>
To:     linux-unionfs@vger.kernel.org
Subject: Re: Incorrect Overlayfs documentation
Date:   Wed, 22 Jul 2020 23:50:59 -0400
Message-ID: <7866875.n4lXpxAzLT@nerdopolis>
In-Reply-To: <CAOQ4uxgm8dHd2EQPgD_a7aKwFUQFKGZg9O7K_FsuJGuWH=P8pg@mail.gmail.com>
References: <1750303.WlVpaa6DS8.ref@nerdopolis> <1750303.WlVpaa6DS8@nerdopolis> <CAOQ4uxgm8dHd2EQPgD_a7aKwFUQFKGZg9O7K_FsuJGuWH=P8pg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: WebService/1.1.16271 hermes_aol Apache-HttpAsyncClient/4.1.4 (Java/11.0.7)
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thursday, July 16, 2020 1:03:52 PM EDT Amir Goldstein wrote:
> On Thu, Jul 16, 2020 at 6:09 AM nerdopolis
> <bluescreen_avenger@verizon.net> wrote:
> >
> > Hi
> >
> > A while back I opened up https://bugzilla.kernel.org/show_bug.cgi?id=195113 describing a documentation problem in
> > https://www.kernel.org/doc/Documentation/filesystems/overlayfs.txt but for whatever reason, it hasn't been seen.
> >
> >
> > The problem is that it says "The lower filesystem can be any filesystem supported by Linux"
> > however, this is not the case, as Linux supports vfat, and vfat doesn't work as a lower filesystem
> >
> > So there's no way to tell what filesystems are applicable for an overlay lowerfs,
> > and I don't think any existing userspace utilities can detect it.
> >
> > Could it be possible for the .txt file to be updated?
> >
> 
> The way it works usually in this project is you can submit a patch to fix the
> problem:
> https://www.kernel.org/doc/html/v4.17/process/submitting-patches.html
> 
> But if you don't want to go through that process, you can offer a text to
> fix documentation.
> 
> But I myself cannot offer anything better than:
> "The lower filesystem can be one of many filesystem supported by Linux".
> 
> I don't think that we want to start listing the supported filesystems in
> documentation.
> 
> FWIW the description of upper fs isn't uptodate either.
> 
> Thanks,
> Amir.
> 
> 
Hi.

Yeah, that process might be cumbersome. I guess what you have is good.
Maybe "A wide range of filesystems supported by Linux can be the lower
filesystem, however, not all filesystems that are mountable by Linux have the
features needed for OverlayFS to work"
?

Thanks



