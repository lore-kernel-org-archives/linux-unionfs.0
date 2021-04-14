Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 552C8C433B4
	for <linux-unionfs@archiver.kernel.org>; Wed, 14 Apr 2021 05:54:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 342EA60240
	for <linux-unionfs@archiver.kernel.org>; Wed, 14 Apr 2021 05:54:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347928AbhDNFyh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 14 Apr 2021 01:54:37 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25391 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348684AbhDNFy3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Apr 2021 01:54:29 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1618379621; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=JWrYpL54yvUpWcihKq8BSZT+dzoazF5tHwLjCeO3RP3yU9kavkZS5Y+Yhe3DLmYnvJpGuKbYuRUA/M3HT1jVqQ4kKTSzwzRu7vRVFAQwqgcUCU7e0SAomUd6beCHaqJIxkqswfLaW01Bxp4GPZUfb9XAyVoWf6AkgfyBT/qF1Oo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1618379621; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=saV5HRRLXGBnIAHfIYmzYyO3Ux95PQZiiVywwB4lRxo=; 
        b=UHf1/ACnHFvabxsmBzgh1zo1DPLIw54qXmZvC4uHRHKHyzM9T4n2R1n56VhXnMke4rNY7BxY3plUZze0dmikKbwqAWWi/NxLQ9gTpNr//JNjWdwhMGXuOZ4dEqvQBY7vqF/qUXVMLHOJUOiFHnP4jQY6kz16iXzJP2/fZYGqpSs=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1618379621;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=saV5HRRLXGBnIAHfIYmzYyO3Ux95PQZiiVywwB4lRxo=;
        b=UPe7t8yWTJLO69rN0nijaDpMKjqS0+vdUx1xhV96yVGCpgHQMKsQfHR2ocE45CKE
        A81V2gInabT/2oLolkptC0nRUmgBEPNUdfghsy9Yn2WeQOHOtBqfV2/hQB4y/Ue1547
        pOFlGhF70gk9NMK+h/XjdxwfnjCMMKkmNcq3zEIs=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1618379619222470.7144857151626; Wed, 14 Apr 2021 13:53:39 +0800 (CST)
Date:   Wed, 14 Apr 2021 13:53:39 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Miklos Szeredi" <miklos@szeredi.hu>
Cc:     "Jan Kara" <jack@suse.cz>, "Amir Goldstein" <amir73il@gmail.com>,
        "overlayfs" <linux-unionfs@vger.kernel.org>,
        "linux-fsdevel" <linux-fsdevel@vger.kernel.org>
Message-ID: <178cef13b93.fb943b9833019.3856869984346239400@mykernel.net>
In-Reply-To: <CAJfpegvM86YEzvFCdHm4a0h3_yNeqfS94c5hArQj7=fgaBARmA@mail.gmail.com>
References: <20201113065555.147276-1-cgxu519@mykernel.net> <20201113065555.147276-8-cgxu519@mykernel.net>
 <CAJfpegtpD5012YQsmFEbkj__x52N4QrV0jSi=7iZtREqVf3tcA@mail.gmail.com> <178c901d7ad.fdc7d65c21509.6849935952336944935@mykernel.net> <CAJfpegvM86YEzvFCdHm4a0h3_yNeqfS94c5hArQj7=fgaBARmA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 7/9] ovl: cache dirty overlayfs' inode
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=8C, 2021-04-13 16:43:27 Miklos Sze=
redi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
 > On Tue, Apr 13, 2021 at 4:14 AM Chengguang Xu <cgxu519@mykernel.net> wro=
te:
 > >
 > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=94, 2021-04-09 21:50:35 Miklo=
s Szeredi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
 > >  > On Fri, Nov 13, 2020 at 7:57 AM Chengguang Xu <cgxu519@mykernel.net=
> wrote:
 > >  > >
 > >  > > Now drop overlayfs' inode will sync dirty data,
 > >  > > so we change to only drop clean inode.
 > >  >
 > >  > I don't understand what happens here.  Please add more explanation.
 > >
 > > In iput_final(), clean overlayfs inode will directly drop as the same =
as before,
 > > dirty overlayfs inode will keep in the cache to wait writeback to sync=
 dirty data
 > > and then add to lru list to wait reclaim.
 > >
 > > The purpose of doing this is to keep compatible behavior with original=
 one,
 > > because without this series, dropping overlayfs inode will not trigger=
 syncing
 > > underlying dirty inode.
 >=20
 > I get it now.  Can you please update the patch header with this descript=
ion?
 >=20

No problem, I'll update commit log in next version.

Thanks,
Chengguang

