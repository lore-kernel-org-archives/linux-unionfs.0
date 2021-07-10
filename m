Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6FCBC07E95
	for <linux-unionfs@archiver.kernel.org>; Sat, 10 Jul 2021 14:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B101761159
	for <linux-unionfs@archiver.kernel.org>; Sat, 10 Jul 2021 14:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhGJOZT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 10 Jul 2021 10:25:19 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25368 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230325AbhGJOZS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 10 Jul 2021 10:25:18 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1625926938; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=Xe75e6TsuqRCYexZmTI0gl+wV2eg12GbpYNah2uLTrsQ2o+2fDM1VRA0Kftk47lJsh3y7ow/KY3gHQL+JqWjuuqSJ7Nqc38KJTOode5sUtg9gTqUNeJUCGkGPMl152QtuEciL4n1RJ1V6VPC839p82nfnswk1H2kOfRGX8YbRjk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1625926938; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=+0DY3gS8sMa8ymZ+Ly5NmOisLz7m54ROSNqy690pjk8=; 
        b=rnQ9NWWA+aaBmG5Ja55A6aV1aNRjNKe+B5I6MDH4kYQZ9vB7PiPGxlD2wwW5idm5IsZTTgOavjOTwzj3Z5vWqYr0pqsnk/0dSeN+vCU5X7Btx/Z0XsfrerTHxhBK1TZpLRRvMM3biTOoPDCVAA/KmO6DizX5k/eL7DPKGKpkVis=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1625926938;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=+0DY3gS8sMa8ymZ+Ly5NmOisLz7m54ROSNqy690pjk8=;
        b=L9yDTwI6t4r42hMqpJDLRMfCASC+thQkcqCPD24dbSpWKrhC4Deu1NIqlneAuEXH
        9ejbiorYpyyye0rHC6RWjAuiZddVQBN8I6al9TGzEAx4UTFChcSuPfDhOoEgPKJ5vMS
        5JwCdBBbg7c4SQMWT88Gy92KxOBA4HTkPJBkF/v8=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1625926935320809.663752085593; Sat, 10 Jul 2021 22:22:15 +0800 (CST)
Date:   Sat, 10 Jul 2021 22:22:15 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Miklos Szeredi" <miklos@szeredi.hu>
Cc:     "linux-unionfs" <linux-unionfs@vger.kernel.org>
Message-ID: <17a90cc2315.c3a7ce6541048.4732925441481979706@mykernel.net>
In-Reply-To: <CAJfpegsymMB5ni=GDQ+02u1OD-tzONkQy32bzjWyrOYq3VPf8w@mail.gmail.com>
References: <17a34811bb1.ca67d1a36094.7925246580859918166@mykernel.net> <CAJfpegsymMB5ni=GDQ+02u1OD-tzONkQy32bzjWyrOYq3VPf8w@mail.gmail.com>
Subject: Re: Mount failure caused by colon/comma characters in the path of
 lower/upper dirs
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=94, 2021-07-09 22:03:11 Miklos Szer=
edi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
 > On Tue, 22 Jun 2021 at 18:30, Chengguang Xu <cgxu519@mykernel.net> wrote=
:
 > >
 > > Hello,
 > >
 > > Today I got a mount failure report from a docker developer about speci=
al characters in overlayfs lower/upper path.
 > > The root cause is quite straightforward  because overlayfs uses colon/=
comma as seperator of lowerdir layers and module options.
 > > However, Colon/Comma characters are valid for directory name on linux =
so some people(especially container users) hope overlayfs
 > > could correctly recognize and handle those directories.
 > >
 > > Strengthen option parsing seems a right solution for fixing the issue,=
 what do think for this?
 >=20
 > Use backslash as an escape character.  E.g. lower directory named
 > "ab,cd:ef" needs to be passed to mount as "-olowerdir=3Dab\,cd\:ef"
 >=20

Hi Miklos,

Thanks for your advice, it worked well.
Minor fix is "ab,cd:ef" needs to be passed to mount as "-olowerdir=3Dab\\,c=
d\\:ef"


Thanks,
Chengguang

