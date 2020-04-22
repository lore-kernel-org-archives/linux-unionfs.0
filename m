Return-Path: <SRS0=lkgI=6G=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F35C55189
	for <linux-unionfs@archiver.kernel.org>; Wed, 22 Apr 2020 08:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF3DE20656
	for <linux-unionfs@archiver.kernel.org>; Wed, 22 Apr 2020 08:14:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="ZZ3SHmwG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725786AbgDVIOC (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 04:14:02 -0400
Received: from [163.53.93.251] ([163.53.93.251]:25380 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1725811AbgDVIOC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 22 Apr 2020 04:14:02 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1587543201; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=G/9v/qyyS8MaWtrt6f+RCY6xrWEgbt/QikOCipZAT/9yuv/P/hKmW1UrizdUmArAXbPwTsrwtYWUxlfLcCg9rUCjgscAHG+8ScPYqTvCyb+VfIGAy1lXgXLk8QdA8B2wMqqh6vjj82xcYEyWWGHVMzdMctsfLxMcbAku3qeLW0A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1587543201; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=OigHnA2voKPOHCjtvCTyFHe/bgbQl4f2p+nbS7FiyDs=; 
        b=MIwZIDk9d61cMs69OyVZEJoNQXcDTy/v3ltmfmrB5uXxGXSzQoFFENS886zIccBEy5KLgo18Cfl5lsYALs4mWEwPAVBOc+OOTWu/Ny3wRFguUltiItB3O4MnPAbeUhr+QToZyybd/3x/kpGSXSsPtqX0j9hzwudM06RL9slCs6c=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1587543201;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=OigHnA2voKPOHCjtvCTyFHe/bgbQl4f2p+nbS7FiyDs=;
        b=ZZ3SHmwGAkABaEkdtwdO30/5Ep9HOfRwCecDnVJ5HflVjZ2LWrW1gRZJD2hGYSCy
        +lCQqiI6ojpeyex9KTdKongg7QbNTQoHWayxJj3wrdf+4OZSwyork5IDaUwWiYFqTyt
        cv+VeVdoZmbOIjMeECiMYZ+zTIgIvajYaae1CDwQ=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 158754319897260.53762878242401; Wed, 22 Apr 2020 16:13:18 +0800 (CST)
Date:   Wed, 22 Apr 2020 16:13:18 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Miklos Szeredi" <miklos@szeredi.hu>
Cc:     "overlayfs" <linux-unionfs@vger.kernel.org>
Message-ID: <171a0f2ccf8.efa2ca517201.9030529562121260568@mykernel.net>
In-Reply-To: <CAJfpegu_t7Zdu2p64aJJ=W=+A6DTddszshk-ODiDjLqWqEwXaQ@mail.gmail.com>
References: <20200422042843.4881-1-cgxu519@mykernel.net> <CAJfpegu_t7Zdu2p64aJJ=W=+A6DTddszshk-ODiDjLqWqEwXaQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: sync dirty data when remounting to ro mode
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

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2020-04-22 15:29:33 Miklos Sze=
redi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
 > On Wed, Apr 22, 2020 at 6:29 AM Chengguang Xu <cgxu519@mykernel.net> wro=
te:
 > >
 > > sync_filesystem() does not sync dirty data for readonly
 > > filesystem during umount, so before changing to readonly
 > > filesystem we should sync dirty data for data integrity.
 >=20
 > Isn't the same true for ->put_super()?
 >=20

Before getting into ->put_super(),  dirty data have been synced through bel=
ow functions,
so I think we don't have to worry about ->put_super().

kill_anon_super()
  generic_shutdown_super()
     sync_filesystem()


Thanks,
cgxu
