Return-Path: <SRS0=UrPG=A3=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 298CAC433E0
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Jul 2020 03:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D81EB20775
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Jul 2020 03:08:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=verizon.net header.i=@verizon.net header.b="InYcWB0Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgGPDIv (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 23:08:51 -0400
Received: from sonic311-25.consmr.mail.ne1.yahoo.com ([66.163.188.206]:42787
        "EHLO sonic311-25.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726770AbgGPDIv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Jul 2020 23:08:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verizon.net; s=a2048; t=1594868930; bh=TXUiqYtzv4AJri4hhLCwQW13pWvzIwM1ww57SxAY/k0=; h=From:To:Subject:Date:References:From:Subject; b=InYcWB0Zq54DrxvoJKVA7WaTKbgm9jOAOM8DyB9X8yjaLYypSv3jufVKzgqnRZGjwEcj84h1ihMXFeSMe7V9G7YTwBxvq0Y5M5RxycT1XLgXp6+R/yVs5Vqv9QsQW+o5RcFcnAOYmM7Fpk5wQi50SGbQwu/levV2JCeQe4n2qdqv2mTsFzVQ+JbOPwz22/kZFCiwQ7NVmAaXAVYj+rFLeK+8ijBVofrGOZOYQcDMhgJ80E7V+bK4AEf0sgBO5Np9H2REmliOWQF60PrnWCyUXmtAuHq7nCxGUl/pP0yt+i4Qv3D6zE26CfQPODjE839bI4NGTw4bfr/P3HTZl1o/yg==
X-YMail-OSG: dEZpYiwVM1lWAp.YU5TkUVtHWY6PSvA65G2xDYNy0_IR8_pPuAbsxYJk.ke2z.q
 Uf4d4PG5zds_XtIwm8e4kPYCDWSxwGLgAktXSv8EtNGew04vGx_yfEcKXnsTpC_8YCI.S_Bcy081
 w5kIPcVSe4Hq2ieMDADclpW3vejEE7STMrzWUnjXsZB0W.v79.GZZ9Wp9PHF0zZGS5M.JFk0Ws4b
 g1p5iq8a8I061YCDUEUR7b4cBNv6JpWZ6ZWNewzAKZKCOAWrMW6pp42p0QL767IGhL11Zpytvigo
 UMNTDV2znS0lP0lsBL_070OQL_r7ZAPca5FYpAHle72NLSBEi.VYtzf35k9oITWnHRJTmQe_mG_I
 rpPKm_LiRlOA9n756XzXP6N2DAWWQtRBwqbP_c6lNFHpg6Q_hOtEA6UPvsWQJTdWMqbUNWBKC7jU
 3MUci4K1wUUz9VOJgota1ygA3NFHVCsT9VATLecQlhQ8PPkTWKf0yDpZvZBP5dhDp69hb.i9iNpH
 e6D8uoE.xMWaFGh8gTyrxwbVEqE_nu2LfX3nDWJ5CIaUzxMD0tWWz.nrZt4_zpAatEhgo2ZtBMzI
 u51v00ct._FvQi0bjlJsIHSbNuju4N0v2yD8gi8.m3lPBuUliOrHBdigknqa1XP3qG5Guvty1rmK
 9Y3gDw97wxPptXfo0dftIFz_pT4f45fb6v5UmUxHSpNrzrotmpi9Gq1UWopOvAG3lssLosJIcJCp
 KXZF6hEIhcwjnHR4HOe30ArZM1JE53i8FlQdizQufmsX9IgvQhOp._3N2n21.5qDamia4xY7LAme
 .kklBpLWWuHuDHltMVboufCUWwnYpUXGgg2vrT30EpMmxChfZnZAhjFyAQZcHsVZeJFIeugf4vif
 RVWFB_49R5FTgc1g9tG.uuqlG8XJWIX6m5QW94l1D55Xmi0fVE_izMLC4T2aWzzVhl2.MFDYrolJ
 OXaJQgBQ5Sgpbow7t.z8oH9IPVwfiq9BJkpQbmpwoYTlIibU3W8DNQHk8M3xqqZmKwVAcFoy5L9S
 Atq56nWFFGX38WL0CDojLxGUWS6ep67PhPa5EjE1V57FJTroHPt8jr8yjiL4rF8kh1exoOkhQAGl
 2NLe_VwEJrplPwMPgYiA7GuowGRK2Fhpdqo.BW8x0KIsJM1lh7T2sx9iGeVqbghlR3bVSHwp9c_g
 DRwjcYIh16BQhPFTz_MOBVfzkwQ75Pgkicw6JPuoVhNkeXKXufyQDBZy2L9ESjxngFtKTzz3ONfv
 sis1cP02iOvDAo2u1syb.G87WD9eVdlV5i6dho3.oWTjgbnQsXrgOTJc4tFdwYCAJRojMeUCvPBD
 m4iO46ydrYFeoNlp1fYmvhcTCEbTap4fBc5VSTyX2t_d1aVyr7uuyooZTjUNB0hne.DQbhius9lr
 eMdpKBS4CJUhySlaue_eb4GM_O8ou
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ne1.yahoo.com with HTTP; Thu, 16 Jul 2020 03:08:50 +0000
Received: by smtp425.mail.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 437e0f3e5cfa4375a49b01b859a04fb8;
          Thu, 16 Jul 2020 03:08:48 +0000 (UTC)
From:   nerdopolis <bluescreen_avenger@verizon.net>
To:     linux-unionfs@vger.kernel.org
Subject: Incorrect Overlayfs documentation
Date:   Wed, 15 Jul 2020 23:08:47 -0400
Message-ID: <1750303.WlVpaa6DS8@nerdopolis>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
References: <1750303.WlVpaa6DS8.ref@nerdopolis>
X-Mailer: WebService/1.1.16271 hermes_aol Apache-HttpAsyncClient/4.1.4 (Java/11.0.7)
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi

A while back I opened up https://bugzilla.kernel.org/show_bug.cgi?id=195113 describing a documentation problem in
https://www.kernel.org/doc/Documentation/filesystems/overlayfs.txt but for whatever reason, it hasn't been seen.


The problem is that it says "The lower filesystem can be any filesystem supported by Linux"
however, this is not the case, as Linux supports vfat, and vfat doesn't work as a lower filesystem

So there's no way to tell what filesystems are applicable for an overlay lowerfs, 
and I don't think any existing userspace utilities can detect it.

Could it be possible for the .txt file to be updated?

Thanks


