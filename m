Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 082E0C07E9B
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jul 2021 16:12:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD5356023D
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jul 2021 16:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhGTP3F (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jul 2021 11:29:05 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25324 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239998AbhGTPYM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jul 2021 11:24:12 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1626797072; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=rpM0Kzs/gFqGX9s4Pf8UaPqYbCAH/mupcDKOF6qF6ax0Eu4qRwk2UwLyxK9Mz3KnScfx4ZqLOr/9t/dWun7moXgrf0LvUhumTRTtkuJfS9O83LKg3OUJKC43R5c2Kj9rA53R9YPw2kXf3UZ1vHYOvCb4yAZfGPokoTvdtgCHaXA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1626797072; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=x9YsEeW/vI/wOxLh8ITeSXZoLSSIkYQSbjCzlp9F28I=; 
        b=UlecUSLsLZbLS5a52U0jbzlIlhrlQpgAUk/IGWzlWR/VH/QD84vGWYYq4IdpMQet9D3GNl1yqrjv3XGAsYysC7/+Bli1YMJVPtSIwjw2MTJ9FuGZliYCaB8bycMCW2ZTGmBnBChOlj8xlzmUeoYk99DAsVG7Hc5DoJJp6rAhD44=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1626797072;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=x9YsEeW/vI/wOxLh8ITeSXZoLSSIkYQSbjCzlp9F28I=;
        b=CLt9G5uJflFFwfJsajNFFo2DcTewbfR/q4Aqh7UtfGpGTHHr58T4Qmg6l9qwY9nB
        k5Zw5zGyWXKZd8nhj0B7oWW4c/NBwjoDWUBjj/e7PtgIfsiXIHQtaCZhk4PHFbLYNzz
        ENVfommvbVTh7hDpcTCG2c8xK3qRKaEeY3EqcrEU=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1626797070429196.12323891756478; Wed, 21 Jul 2021 00:04:30 +0800 (CST)
Date:   Wed, 21 Jul 2021 00:04:30 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Miklos Szeredi" <miklos@szeredi.hu>
Cc:     "overlayfs" <linux-unionfs@vger.kernel.org>
Message-ID: <17ac4a9585a.fe9d56d860292.2175453677488603990@mykernel.net>
In-Reply-To: <CAJfpegvmMtXPg1qMznuimy27maqGxOtcddR-L0MUfAS6jwhE7Q@mail.gmail.com>
References: <20210424140316.485444-1-cgxu519@mykernel.net> <CAJfpegsT3PaVggkcx+OdoxOCR2hWYeLs1rTr_p3nNMimnknCug@mail.gmail.com>
 <CAJfpegvmBggw3bgumMwDF_V_dgn=gvC+a+8oCgYfZ+Qu55U=vw@mail.gmail.com> <CAJfpegvmMtXPg1qMznuimy27maqGxOtcddR-L0MUfAS6jwhE7Q@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] ovl: skip checking lower file's write permisson
 on truncate
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2021-07-21 00:01:11 Miklos Sze=
redi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
 > On Tue, 20 Jul 2021 at 17:19, Miklos Szeredi <miklos@szeredi.hu> wrote:
 >=20
 > > So on one instance a file on lower gets executed and on another
 > > instance sharing the lower layer the file is truncated.  The truncate
 > > is currently denied due to the negative i_writecount on the lower
 > > file.  Also behavior is inconsistent between open(path, O_TRUNC) and
 > > truncate(path) even though the two should be equivalent.
 > >
 > > Applied with the following description:
 > >
 > [...]
 >=20
 > Also adding the following documentation in the "Non-standard behavior" s=
ection:
 >=20
 > c) If a file residing on a lower layer is being executed, then opening t=
hat
 > file for write or truncating the file will not be denied with ETXTBSY.
 >=20
 > Looked at the POSIX standard and it only documents ETXTBUSY for O_RDWR
 > and O_WRONLY and not for truncate(2) or O_TRUNC.  So strictly speaking
 > this patch doesn't even change the POSIX correctness.
 >=20

Hi Miklos,

Thanks for doing this too.

Thanks,
Chengguang
