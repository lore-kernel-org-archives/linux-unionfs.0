Return-Path: <SRS0=W3VS=6O=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 266C2C8300A
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Apr 2020 09:48:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B921C2082E
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Apr 2020 09:48:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="LPDSBD8l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgD3Jsf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 05:48:35 -0400
Received: from sender2-of-o52.zoho.com.cn ([163.53.93.247]:21150 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726378AbgD3Jsf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 30 Apr 2020 05:48:35 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1588240100; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=K3ZBTitxVpt7auBadV3M910oD6eD4npNk91o6a1wl5PBohqX5hWIysc3/8/sv/KwCXIZJGL83V58+FdqZ8kv0TxqA9O5A7uIv1cdbULnwzV8p9I1ZUGi8oCJL8nm4Xd/XBdUeRbeildThRhBT+7rA9K8jr0htKopX1LJct/5Ik0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1588240100; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=dI2PKtESwDX/5rsemmkaZawtNKBmdrx+tGkn711BsHg=; 
        b=lusnvvbDiEb94cFwBSu1bZeXJVix2IAA98xXQU0tajrbzxVFuQa2Bo9EYGJ6Rj75V5c299xwbDs/rPc+/q3iLMeAWH2pT3XGsWHxICF07wGUe8Np0y69wD2C1s/3jD8+6SX0SSSrdX2BNMYPv+/oUynUkqtgIife8wdTfxhsZj8=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1588240100;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=dI2PKtESwDX/5rsemmkaZawtNKBmdrx+tGkn711BsHg=;
        b=LPDSBD8lFBd9nNWylrMsK2BrW9n+nillIyDn5CprUdPDA8QejYI9dFobjQ/IU2tU
        h7kx1ZGXXoAtkq10u0Cd9Bwrlx69n9czYTcD2GYfBiXzUPWqkZHIEwzJQu3ti8vkxYr
        WlL/Vwm5LuAgjKdq3Gb1ik/7ds/gTlWRJrHKOWhI=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1588240098059538.8860218617385; Thu, 30 Apr 2020 17:48:18 +0800 (CST)
Date:   Thu, 30 Apr 2020 17:48:18 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "cgxu519" <cgxu519@mykernel.net>
Cc:     "linux-unionfs" <linux-unionfs@vger.kernel.org>,
        "fstests" <fstests@vger.kernel.org>,
        "amir73il" <amir73il@gmail.com>, "miklos" <miklos@szeredi.hu>,
        "guaneryu" <guaneryu@gmail.com>
Message-ID: <171ca7ca308.ed1c416b1605.5683082771269054301@mykernel.net>
In-Reply-To: <171ca5e76d2.11a198ab91526.7776557945472155733@mykernel.net>
References: <171ca5e76d2.11a198ab91526.7776557945472155733@mykernel.net>
Subject: =?UTF-8?Q?=E5=9B=9E=E5=A4=8D:system_hang_on_a_syncfs_?=
 =?UTF-8?Q?test_with_nfs=5Fexport_enabled?=
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-04-30 17:15:20 Chengguang=
 Xu <cgxu519@mykernel.net> =E6=92=B0=E5=86=99 ----
 > Hi=20
 >=20
 > I'm doing some tests for my new version of syncfs improvement patch and =
I found an=20
 > interesting problem=E2=80=8B when combining dirty data && godown && nfs_=
export.
 >=20
 > My expectation  is  Pass or Fail  all tests listed below, Test2 looks a =
bit strange and in my
 > opinion there is no strong connection between nfs_export/index and dirty=
 data.
 > Any idea?
 >=20
 >=20
 > Test env and step like below:
 >=20
 > Test1:
 > Compile module with nfs_export enabled
 > Run xfstest generic/474   =3D=3D> PASS
 >=20
 > Test2:
 > Compile module with nfs_export enabled
 > Comment syncfs step in the test
 > Run xfstest generic/474   =3D=3D> Hang
 >=20
 > Test3:
 > Compile module with nfs_export disabled
 > Run xfstest generic/474   =3D=3D> PASS
 >=20
 > Test4:
 > Compile module with nfs_export disabled
 > Comment syncfs step in the test
 > Run xfstest generic/474   =3D=3D> FAIL
 >=20

Additional information:

Overlayfs version: latest next branch of miklos tree (5.7-rc2)
Underlying fs: xfs

Thanks,
cgxu




