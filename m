Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C909DC433B4
	for <linux-unionfs@archiver.kernel.org>; Thu,  8 Apr 2021 11:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 887D961151
	for <linux-unionfs@archiver.kernel.org>; Thu,  8 Apr 2021 11:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhDHLkT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 8 Apr 2021 07:40:19 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25306 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229751AbhDHLkT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Apr 2021 07:40:19 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1617882000; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=KqQh8uApNT3yqQM2ZDNTWbp+fZyzD0Gw8eHpVBAVgOuIFCyZiweSGKCg5YkGbcY1KD+GEp+9Vd7t8jxhB7+lPUg5w3Rron44FmzaiZoV/wD6KsGOcvUzIuHFLyPuOYKjcn3zaVJKLkCbn7grywrWsJpdNMBEFi4xRf3JT3rLXVY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1617882000; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=J1KZR2gt+MeyXIOa5cokIRqSbwVq5E4XUuBGLU3rfsI=; 
        b=nNgq73BlztzDfzjdOynPmYPzgAYzhWlOFhUJxZqjPZJP0OG8A/1y3tRuBVj0H1e9VmhXjeZ/ZM2xbBY7zYpDEjBPKQ8tL9vX08Z1/0cAJK5FYpJYYb8I4hshYaYH6B810yKEzbxjPKwrrRv48n6xst7UjTh5e2LZXRA+NBYzluA=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1617882000;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=J1KZR2gt+MeyXIOa5cokIRqSbwVq5E4XUuBGLU3rfsI=;
        b=FUHxnfihBe9ScJ3QrJ062vn9gdUEgBxgT/4vwgcaGcjOuLbsDFXWjMJ8O3ccKS77
        HTs+OjvBClVbovk0dzwEBVYgiVf1D+tiLPDexx9JBnhOksTcCNuYGpMhC/0uZFcGxxx
        fkKhCg/q0/eJSiqaOvWEHESVzWJdv3LowFphBhqA=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 161788200016771.73720425654005; Thu, 8 Apr 2021 19:40:00 +0800 (CST)
Date:   Thu, 08 Apr 2021 19:40:00 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Miklos Szeredi" <miklos@szeredi.hu>
Cc:     "linux-unionfs" <linux-unionfs@vger.kernel.org>
Message-ID: <178b1482b24.108404c2418483.4334767487912126386@mykernel.net>
In-Reply-To: <CAJfpegt5vVAtik=SXL26G0Tjh8yzZ6DvD6wLtfbXTinqpkxVeg@mail.gmail.com>
References: <20210408112042.2586996-1-cgxu519@mykernel.net> <178b13dbf0a.c5d5924718458.7870418673694557579@mykernel.net> <CAJfpegt5vVAtik=SXL26G0Tjh8yzZ6DvD6wLtfbXTinqpkxVeg@mail.gmail.com>
Subject: Re: [PATCH] ovl: check VM_DENYWRITE mappings in copy-up
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2021-04-08 19:29:55 Miklos Sze=
redi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
 > On Thu, Apr 8, 2021 at 1:28 PM Chengguang Xu <cgxu519@mykernel.net> wrot=
e:
 > >
 > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2021-04-08 19:20:42 Cheng=
guang Xu <cgxu519@mykernel.net> =E6=92=B0=E5=86=99 ----
 > >  > In overlayfs copy-up, if open flag has O_TRUNC then upper
 > >  > file will truncate to zero size, in this case we should check
 > >  > VM_DENYWRITE mappings to keep compatibility with other filesystems.
 >=20
 > Can you provide a test case for the bug that this is fixing?
 >=20

Execute binary file(keep running until open) in overlayfs which only has lo=
wer && open the binary file with flag O_RDWR|O_TRUNC

Expected result: open fail with -ETXTBSY

Actual result: open success

Thanks,
Chengguang
