Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2301C433DB
	for <linux-unionfs@archiver.kernel.org>; Tue, 30 Mar 2021 07:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CD6661481
	for <linux-unionfs@archiver.kernel.org>; Tue, 30 Mar 2021 07:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhC3HS2 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 03:18:28 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25344 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229567AbhC3HSM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 30 Mar 2021 03:18:12 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1617088681; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=ZNBLPL6NIbYlIChOC68SO9DcuCtpFVQZL5TgzCWsI86Fcz68etHGrqVDOt225FwYUS4vNfn0Q1cmlbw2q0su26KCkrUsdfGvhVMSxDGlsxLsqvJbKvR2B1xGzIun2FtyX1ShjNpfYooucOm4M4gvsM8b43152N2Q4U5Zal/AShE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1617088681; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=nDGhaEakdGrAjex6UEUphqY5QqLyRRRgPfH/DHZEiKI=; 
        b=YtM68hWy+TKE9e2FHu3Ig4ZxbGv4A+OZKJhDZx4lwsRNY2B7o5smX0Avm0AtB8O7hJYscpHuyOnmvafIXHmIBfkOBNbdWAAQ+Ritwt0277Lkm0CmkRKAtCydmgWpP+y4GBD5NE437bYt8ZCYpRxmvFPsJ3Ztbx5rw29yK8ZI9WI=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1617088681;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=nDGhaEakdGrAjex6UEUphqY5QqLyRRRgPfH/DHZEiKI=;
        b=PG0sUtLnJzmuSAWBp9NZCRKwnehi1Gf8Z7Edz9ATXG/xUwJZMzPKLH0Zk8x6hc4c
        me7cmTtqiyDWhqCKhbHEq3+Sot4ARayBMd99lmLHADF7OmW31jeO6yU9DD1hPAdSEZJ
        runvuY1JzBakti6S9ZZNkQSJXSmBd3e7oB9whLu0=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1617088679275355.187850231546; Tue, 30 Mar 2021 15:17:59 +0800 (CST)
Date:   Tue, 30 Mar 2021 15:17:59 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Miklos Szeredi" <miklos@szeredi.hu>
Cc:     "overlayfs" <linux-unionfs@vger.kernel.org>
Message-ID: <17881ff0d68.d7a56edc63056.4991029139850978481@mykernel.net>
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
 >=20
 > But need to be careful, because we could possibly have other attribute
 > change requests besides ATTR_SIZE, in which case optimizing the
 > truncate away and returning success wouldn't be correct.

OK, I'll modify in V2.

 >=20
 > Minor issue: this patch doesn't optimize the truncate to zero case.
 > That's not a bug, but I'm curious if that is an oversight or
 > deliberate.
 >=20

I overlooked that case because all our cases use O_TRUNC flag on open time
when truncate to zero size. How about specify O_TRUNC flag when calling
copy-up function for this case?


Thanks,
Chengguang
