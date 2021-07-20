Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 860AEC636C9
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jul 2021 16:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CD1661001
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jul 2021 16:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbhGTP2d (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jul 2021 11:28:33 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25305 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240447AbhGTPUk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jul 2021 11:20:40 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1626796862; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=eJisLHMkkbTUDdcUcsSXBbPLMbj7VepQC7K+Irkh/bSfLUcThA3E57eRa2fkJ+JeEWiVG1F08wHu3QwhulueROmu1AaprERswFC/Ml6+f2gw6ZaZR3837SU2PpSBJCFT3m/7UT9q0/H6SWetwwfk7lBxgXOlxYtB1QWsSN44wrM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1626796862; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=8fZ9/PZq6fbl74BIhosn3HeelVikMnGH7z6PHny+Sjo=; 
        b=Ia33NRddlWWkPUss7GTtXmKhc64QCWZQrnnpbsYueslN6gfrzQg9eMfzIKcDZSSWPyx9ls/jHuSXpkiWbLrFCvs+o93AO5gYqZ4ygQ+p5wJFuYY4wfUWI6Esz2S7cU4bOwQ9svW6+4IguGSC3ryvIljVB2DQ2ugbOe4fu6m4wMQ=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1626796862;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=8fZ9/PZq6fbl74BIhosn3HeelVikMnGH7z6PHny+Sjo=;
        b=XIKswVEAJLA8X7JmZGnHCf5pUvsKMR1lGEBXGhV+n0Kl4x+M2dqtMZGX1iCY8J14
        nuuBnndV6vqCyag0b4WdJXi9gC2x5R4yA46K0dhvHc5f5zYFlW6FzfAt0yQThCPQTPc
        pp0PtWEC9zvq9nkHBF3sKlxIhiMeQQ/G9nzxkThA=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1626796860813277.46157946990456; Wed, 21 Jul 2021 00:01:00 +0800 (CST)
Date:   Wed, 21 Jul 2021 00:01:00 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Miklos Szeredi" <miklos@szeredi.hu>
Cc:     "overlayfs" <linux-unionfs@vger.kernel.org>
Message-ID: <17ac4a6258a.1113fdbb760287.4207934850282026708@mykernel.net>
In-Reply-To: <CAJfpegvmBggw3bgumMwDF_V_dgn=gvC+a+8oCgYfZ+Qu55U=vw@mail.gmail.com>
References: <20210424140316.485444-1-cgxu519@mykernel.net> <CAJfpegsT3PaVggkcx+OdoxOCR2hWYeLs1rTr_p3nNMimnknCug@mail.gmail.com> <CAJfpegvmBggw3bgumMwDF_V_dgn=gvC+a+8oCgYfZ+Qu55U=vw@mail.gmail.com>
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

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=8C, 2021-07-20 23:19:16 Miklos Sze=
redi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
 > On Tue, 20 Jul 2021 at 16:35, Miklos Szeredi <miklos@szeredi.hu> wrote:
 > >
 > > On Sat, 24 Apr 2021 at 16:04, Chengguang Xu <cgxu519@mykernel.net> wro=
te:
 > > >
 > > > Lower files may be shared in overlayfs so strictly checking write
 > > > perssmion on lower file will cause interferes between different
 > > > overlayfs instances.
 > >
 > > How so?
 > >
 > > i_writecount on lower inode is not modified by overlayfs (at least not
 > > in this codepath).  Which means that there should be no interference
 > > between overlayfs instances sharing a lower directory tree.
 >=20
 > I'm beginning to see what you are worrying about.
 >=20
 > So on one instance a file on lower gets executed and on another
 > instance sharing the lower layer the file is truncated.  The truncate
 > is currently denied due to the negative i_writecount on the lower
 > file.  Also behavior is inconsistent between open(path, O_TRUNC) and
 > truncate(path) even though the two should be equivalent.

Yeah, that's it.
Thanks for applying the patch and supplementary description.

Thanks,
Chengguang
