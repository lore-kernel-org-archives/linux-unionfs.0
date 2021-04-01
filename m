Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3259DC433B4
	for <linux-unionfs@archiver.kernel.org>; Thu,  1 Apr 2021 20:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E903B610D0
	for <linux-unionfs@archiver.kernel.org>; Thu,  1 Apr 2021 20:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbhDAU2c (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 1 Apr 2021 16:28:32 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17185 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234201AbhDAU2b (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Apr 2021 16:28:31 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1617280748; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=gsg2HJwGYPHD7qbdYdk6gnlXxcfCxDbrdoiOCsx7vRG0Lhd9zofBuBZdOjtQvKT8xEvzLafTF7LGTp9yjr4m6skW/zhxsQbXLoJBiC7fMraDqLe2Qk+08PSZChJ+eH7baaiwA22q+ZdlshB16M2o+fLnlwEdIGs1A1zJ0TNu6ug=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1617280748; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=ZjsT85TbEMmNvZgW9BOnakQmxGRojaimRBJn4TOhhqs=; 
        b=m4V4oxKs+miXoT2PxUQmLPy9x0yZL54YZCCkYTxOfrMt1j3M/y1yjqk0L+ae8fRyXaW6mdtCX7Uc2KTkfXJvn7OCmztQ4P9AJIjCgFS4LqG1aMnVXtyp0smBy2igLZOEsKJuOcqioEwZC7buA9iiMjFRxK1d7Ia55vT4FI+ncHk=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1617280748;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=ZjsT85TbEMmNvZgW9BOnakQmxGRojaimRBJn4TOhhqs=;
        b=gOdPNh+Kpn1lKNyjPOO6X9vhl3jqgchz3tzIhLo6qJ8TbTE6evvuAlhO69VwRh+Z
        PbBsSUjkthTe002e1j8xvE9wKtXu4KRwmFDygdWvVVFK+OVVR3irdRkulE5WvACc8uq
        6c+UVhfWKCHA4XxlHV9HP8SXyickTubfBDlTu9SI=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1617280745387909.2086762579058; Thu, 1 Apr 2021 20:39:05 +0800 (CST)
Date:   Thu, 01 Apr 2021 20:39:05 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Miklos Szeredi" <miklos@szeredi.hu>
Cc:     "overlayfs" <linux-unionfs@vger.kernel.org>
Message-ID: <1788d71bfa9.1085d20533394.4611084846534174960@mykernel.net>
In-Reply-To: <CAJfpegt_r6rWFMjpLxmQK8saQ=G01RKSd=5+GUCnz_By_27EGg@mail.gmail.com>
References: <20210308111717.2027030-1-cgxu519@mykernel.net>
 <CAJfpeguFdafs65aOgDrJnAh6Tg8bnwP3gP5sUhfsRka5Azctbg@mail.gmail.com> <1788d256770.ff2961df3248.3624659711262801588@mykernel.net> <CAJfpegt_r6rWFMjpLxmQK8saQ=G01RKSd=5+GUCnz_By_27EGg@mail.gmail.com>
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

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2021-04-01 19:31:12 Miklos Sze=
redi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
 > On Thu, Apr 1, 2021 at 1:15 PM Chengguang Xu <cgxu519@mykernel.net> wrot=
e:
 > >
 > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=80, 2021-03-29 23:13:52 Miklo=
s Szeredi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
 > >  > On Mon, Mar 8, 2021 at 12:17 PM Chengguang Xu <cgxu519@mykernel.net=
> wrote:
 > >  > >
 > >  > > Currently copy-up will copy whole lower file to upper
 > >  > > regardless of the data range which is needed for further
 > >  > > operation. This patch avoids unnecessary copy when truncate
 > >  > > size is smaller than the file size.
 > >  >
 > >  > This doesn't look right.   If copy up succeeds, resulting in a
 > >  > truncated file, then we should return success there and then.   Doi=
ng
 > >  > the truncate again and failing (unlikely, but I wouldn't think it
 > >  > impossible) wouldn't be nice.
 > >
 > > Hi Miklos
 > >
 > > I noticed a problem here, if we just return success after copy-up then=
 mtime
 > > keeps the same as lower file. I think doing the truncate again would b=
e better
 > > than manually updating the upper file's mtime. What do you think for t=
his?
 >=20
 > Let's simplify instead:  skip the mtime restore on copy-up.   Not sure
 > how that's handled on O_TRUNC opens, maybe it's relevant to that case
 > too.
 >=20

Currently on O_TRUNC open, copy-up(zero size) triggered by vfs_open() then =
do the truncate(zero size)
operation by handle_truncate() afterwards. mtime will be updated after call=
ing handle_truncate().



Thanks,
Chengguang
