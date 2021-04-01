Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB83C433ED
	for <linux-unionfs@archiver.kernel.org>; Thu,  1 Apr 2021 19:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2266160C3D
	for <linux-unionfs@archiver.kernel.org>; Thu,  1 Apr 2021 19:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235115AbhDATIG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 1 Apr 2021 15:08:06 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17184 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237029AbhDATGK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Apr 2021 15:06:10 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1617275744; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=GscmV52/HOGHSOmpqdPDh1Nc18wJKyiXyOboUs0L8D95B319B72EC9+R6qSRkmM3bKK7WgKv2M/P+ryZ2YhPC3iPwvgOf37pnakuQ1vSq0OLS3co6o6eW6dvX3HGZACFFpEDS3xJppQpxYINTnCIDwf7bOQqNg7e4wAdn+GIU7w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1617275744; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=TmcRNZvXx9uSUs2zbqJSWsAE2VIxg2LSl2evwr2bzys=; 
        b=ZAMOAIFeGfZhu/Qn6++XmG1N8btUkQEir9n5YGL08I+rzh9zUNnrVfur0zb5kURbpVBrkzRI5/OM/H7Ebz5bP1XKrHaG/LAir7gIiQDiJ0aBeV2vbYlSBYEnmZImZRJxjTxIEqLvBfUyO2sEthgcwKvVlo8lw1PEzJML0xsL5EE=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1617275744;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=TmcRNZvXx9uSUs2zbqJSWsAE2VIxg2LSl2evwr2bzys=;
        b=G0wPyoCAd5rwI1OxGbVkx4EbaJ/AWWpUQR1/DhH9EB/LlUqiff+ghJmLva5jlzJp
        lRJDXEy43aXKtA/4IbeNriJ/b8LKEVTL5KwBqRDHEkcXjwEwqZKbFMgT0XidlXGiemU
        PJJV1FqAnhAQBrB7jci5/H/JTxLlUGXdVzLyv9ao=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1617275742068810.4826500911768; Thu, 1 Apr 2021 19:15:42 +0800 (CST)
Date:   Thu, 01 Apr 2021 19:15:42 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Miklos Szeredi" <miklos@szeredi.hu>
Cc:     "overlayfs" <linux-unionfs@vger.kernel.org>
Message-ID: <1788d256770.ff2961df3248.3624659711262801588@mykernel.net>
In-Reply-To: <CAJfpeguFdafs65aOgDrJnAh6Tg8bnwP3gP5sUhfsRka5Azctbg@mail.gmail.com>
References: <20210308111717.2027030-1-cgxu519@mykernel.net> <CAJfpeguFdafs65aOgDrJnAh6Tg8bnwP3gP5sUhfsRka5Azctbg@mail.gmail.com>
Subject: Re: [PATCH] ovl: copy-up optimization for truncate
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=80, 2021-03-29 23:13:52 Miklos Sze=
redi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
 > On Mon, Mar 8, 2021 at 12:17 PM Chengguang Xu <cgxu519@mykernel.net> wro=
te:
 > >
 > > Currently copy-up will copy whole lower file to upper
 > > regardless of the data range which is needed for further
 > > operation. This patch avoids unnecessary copy when truncate
 > > size is smaller than the file size.
 >=20
 > This doesn't look right.   If copy up succeeds, resulting in a
 > truncated file, then we should return success there and then.   Doing
 > the truncate again and failing (unlikely, but I wouldn't think it
 > impossible) wouldn't be nice.

Hi Miklos

I noticed a problem here, if we just return success after copy-up then mtim=
e
keeps the same as lower file. I think doing the truncate again would be bet=
ter
than manually updating the upper file's mtime. What do you think for this?

Thanks,
Chengguang

