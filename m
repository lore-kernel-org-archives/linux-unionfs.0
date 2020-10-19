Return-Path: <SRS0=6I+O=D2=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B18C433DF
	for <linux-unionfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:23:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ABD92225A
	for <linux-unionfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:23:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="gKANIoy/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgJSGXv (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 02:23:51 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25368 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726626AbgJSGXv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Oct 2020 02:23:51 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1603088610; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=rmH4iprO9Emewa10c+7gnnodsYHCKNw7shaMtG4uei9bzUWptfw1I8/tzCJhjPzCfTDJJcRV7b7hbOGAbF/ipQxd31FBK+YEelgn35S9UlFsS794LXeM+nY27xKaEXdnK4QfnjYjdrHREn8GgE9sgnEeaBgLnZgI8UOcR4q5w4A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1603088610; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=Ot6p5PKRwlPKGaS1bI/rWvDEIlHWn8D7OxW7I+utZP0=; 
        b=d6zzQRno9KRhNNO0TcAUAtVoPhRRueTosJIDzFKjzOl7AypZ4Jsvi+wjoG48SLQm5dIqUMU8ogvN97enD7BcahnhSXwfb/Eb0Xoh8vLDP2WLN8BFQGnuwU3fVMML/fKjEVNSr4CxGkR2ZJb+5ujpDEgHw2aYoHjnQxIaae8AJ0g=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1603088610;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=Ot6p5PKRwlPKGaS1bI/rWvDEIlHWn8D7OxW7I+utZP0=;
        b=gKANIoy/qte4Jdqb2KifN4aTSC4svMrQxlO6xECpiKCwcKWpd5HvprPtGym+bIce
        7J/CrosfL7CyC7OUMT/E61awg0NXzCxH0WqvS4/Jb3D99RDXafIVMplJg2mw92ZrpQU
        wfCcBOzcahbPmV0IXVVoE648xmoaYKksYTHIpUhs=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1603088608337412.22111476514215; Mon, 19 Oct 2020 14:23:28 +0800 (CST)
Date:   Mon, 19 Oct 2020 14:23:28 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>
Cc:     "Miklos Szeredi" <miklos@szeredi.hu>,
        "overlayfs" <linux-unionfs@vger.kernel.org>
Message-ID: <1753f86ec4e.11b908e7c48733.2506380417104368548@mykernel.net>
In-Reply-To: <CAOQ4uxha5-88Rzi9D_zy4aDG76qthfQgo3LrR=DmJYgM-vfbEQ@mail.gmail.com>
References: <20201016155745.2876-1-cgxu519@mykernel.net> <CAOQ4uxha5-88Rzi9D_zy4aDG76qthfQgo3LrR=DmJYgM-vfbEQ@mail.gmail.com>
Subject: Re: (RESEND) [PATCH] ovl: stacked file operation for mmap
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E6=97=A5, 2020-10-18 15:53:23 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Fri, Oct 16, 2020 at 7:38 PM Chengguang Xu <cgxu519@mykernel.net> wro=
te:
 > >
 > > Currently only mmap does not behave as stacked file operation,
 > > although in practice there is less change to open a file in
 > > RDONLY mode and take long time to do mmap but the fix looks
 > > reasonable.
 >=20
 > I suppose you do not have a real life use case where this fix
 > is relevant?

Detected by some unexpectedly running test scripts.

 >=20
 > The thing is that this change is not without consequence.
 > It could result in 2 overlapping mmaps on the same RDONLY fd
 > mapping a different file and it can be even more confusing
 > than different fd mapping different files.
 >=20
 > It is not clear which non-standard behavior is preferred, so without
 > any evidence that one strange behavior is preferred over the other
 > I don't think we should change anything.
 >=20
Makes sense.

