Return-Path: <SRS0=FJl1=64=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3BDFC433E0
	for <linux-unionfs@archiver.kernel.org>; Thu, 14 May 2020 07:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5356820575
	for <linux-unionfs@archiver.kernel.org>; Thu, 14 May 2020 07:56:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="I1tSoZ6l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgENH4U (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 14 May 2020 03:56:20 -0400
Received: from sender2-of-o52.zoho.com.cn ([163.53.93.247]:21186 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725911AbgENH4T (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 May 2020 03:56:19 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1589442953; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=pGVjwX9opdRDDSOwUs6ouvq/TFZmAaYVrXZpYP0mMDxwe5x5GOlaHOlI89EjQm4Lh/keQUt/ZrNuFMY6hOfmYn63u+2t3dZvEw2Fru7vqPLEdm5v0iQV0RUtjzz+RK6nXjQvQzaXANHjT1XxXlqIM4q3tuBgqgoXjSCisGkc3KI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1589442953; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=wrMXfPBLjgSZ6yRzDQD2sFAT1nm/D9kdJnylqFwsu/k=; 
        b=DDZnyEZAZtbEi1ggvTy6KQIn9VYmX7YmbO8sTq2eFLtfF+uxbn9JpnqStD9KxiqAeAkpd1d9m/gGixmoeScJUsYPTz8+2CDY+G+R7WPuSWu5lw4DHuGLvArAn+NQFWDXOO9HChFdKNB1nkiNtku4MSmXHF1Znsu0Rs+47PhnAZA=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1589442953;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=wrMXfPBLjgSZ6yRzDQD2sFAT1nm/D9kdJnylqFwsu/k=;
        b=I1tSoZ6lH5T2WkZYW8fBg8AWdshhFasc4dzKOQ362zVGgAxYsCSYq15Xq15l62wE
        sLqDGodvqYKD5JsXc36tsaaRV5OOiBkaqkkZiO3y83Y1CdtCBXQK1SYdfrHKi/MkL6F
        NYw02/neLsWZPb+TDfNS59MEcnR3CJOCgs4gBwLk=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1589442949816657.1906318521994; Thu, 14 May 2020 15:55:49 +0800 (CST)
Date:   Thu, 14 May 2020 15:55:49 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>
Cc:     "Eryu Guan" <guaneryu@gmail.com>,
        "Miklos Szeredi" <miklos@szeredi.hu>,
        "linux-unionfs" <linux-unionfs@vger.kernel.org>,
        "fstests" <fstests@vger.kernel.org>
Message-ID: <172122eb2b5.d3d184ba3999.3522413627709473953@mykernel.net>
In-Reply-To: <20200513192338.13584-1-amir73il@gmail.com>
References: <20200513192338.13584-1-amir73il@gmail.com>
Subject: =?UTF-8?Q?=E5=9B=9E=E5=A4=8D:[PATCH_v5]_overlay:_test?=
 =?UTF-8?Q?_for_whiteout_inode_sharing?=
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

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-05-14 03:23:38 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > From: Chengguang Xu <cgxu519@mykernel.net>
 >=20
 > This is a test for whiteout inode sharing feature.
 >=20
 > [Amir] added check for whiteout sharing support
 >        and whiteout of lower dir.
 >=20
 > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
 > ---
 >=20
 > Chengguang,
 >=20
 > I decided to take a stab at Eryu's challenge ;-)
=20
Thanks for doing this, I've also tested in both sharing/non-sharing ENVs an=
d the case worked as expected.=20

Thanks,
cgxu
