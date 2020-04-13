Return-Path: <SRS0=sf8C=55=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 153DFC2BB55
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Apr 2020 01:57:58 +0000 (UTC)
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F0F720709
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Apr 2020 01:57:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="ampbARAo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F0F720709
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=mykernel.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-unionfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgDMB54 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 12 Apr 2020 21:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbgDMB54 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 12 Apr 2020 21:57:56 -0400
Received: from sender2-pp-o92.zoho.com.cn (sender2-pp-o92.zoho.com.cn [163.53.93.251])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316E0C0A3BE0;
        Sun, 12 Apr 2020 18:57:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1586743058; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=aIlliW9W0fKr5EnqbsKTKi50aQNXGi7u8sm34u4HB/Vj7ol1jfKtL3govKD9BERPKZlymdngYsg8piCvv68kHT0MJ51Wx/+qJHLrBBjNqvNnQbjCWjKjq7VG1xIWGCbfNCrISNr6L3y1GGCJjV1doRjYiG0Bzyng5sKE24rSasU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1586743058; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=rwLMhlu7mTyq35ivgUhYINy1wAAph3yfIFSBpqytdxY=; 
        b=WL37xa3ZpdO7o8tc4uIzD/z36jDysum0qMUth3Aoa0byDWnFVMkXeTpCist6JOwzZNMJ+oXc1IYhegRzxkmyXwfmKnASq1DjLbp5wZBjFX2rwU7mz3U10hhkhKxAQIbLKOds8RjXNhj6gRy7V/ql5bcP+9ZoBGkD3OWqH8kZFYU=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1586743058;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=rwLMhlu7mTyq35ivgUhYINy1wAAph3yfIFSBpqytdxY=;
        b=ampbARAoq8mZ+d04SdKWq1rFJ9CshWr6yyfheQp0vrBhDBAYtbamaJFDD9RlQ9CK
        1Ag99QTZj8lIEIS12bsSEb24zh5B5yhVVTzlR0eia9ArDrRJ7apECtQ2+JS00QGsZji
        i9oAKafQBoFezaOgI82L2pK0jFh+XYPmJe6DqJJU=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1586743056885524.5832889150215; Mon, 13 Apr 2020 09:57:36 +0800 (CST)
Date:   Mon, 13 Apr 2020 09:57:36 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>, "Eryu Guan" <guan@eryu.me>
Cc:     "Eryu Guan" <guaneryu@gmail.com>,
        "fstests" <fstests@vger.kernel.org>,
        "overlayfs" <linux-unionfs@vger.kernel.org>,
        "Miklos Szeredi" <miklos@szeredi.hu>
Message-ID: <171714199f2.e3584df34868.1553757472263093422@mykernel.net>
In-Reply-To: <CAOQ4uxgcogXOjT9VGTttkrrbHk3tWm88Qa-MeZ88-kt8uwRmYA@mail.gmail.com>
References: <20200410012059.27210-1-cgxu519@mykernel.net> <20200410012059.27210-2-cgxu519@mykernel.net>
 <20200412112734.GC3923113@desktop> <CAOQ4uxgcogXOjT9VGTttkrrbHk3tWm88Qa-MeZ88-kt8uwRmYA@mail.gmail.com>
Subject: Re: [PATCH 2/2] overlay/072: test for sharing inode with whiteout
 files
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

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E6=97=A5, 2020-04-12 19:34:41 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Sun, Apr 12, 2020 at 2:26 PM Eryu Guan <guan@eryu.me> wrote:
 > >
 > > On Fri, Apr 10, 2020 at 09:20:59AM +0800, Chengguang Xu wrote:
 > > > This is a test for whiteout inode sharing feature.
 > > >
 > > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > > > ---
 > > > Hi Eryu,
 > > >
 > > > Kernel patch of this feature is still in review but I hope to merge
 > >
 > > If this case tests a new & unmerged feature, I'd wait for the kernel
 > > patch land in first, or at least the maintainer of the subsystem of th=
e
 > > kernel acks that the feature will be in kernel, just that the patch
 > > itself needs some improvements at the moment.
 > >
 > > As there were cases that I merged a case that aimed to test a new
 > > feature or a new behavior, but the kernel patch was dropped eventually=
,
 > > and the case became broken.
 > >
 > > > test case first, so that we can check the correctness in a convenien=
t
 > > > way. The test case will carefully check new module param and skip th=
e
 > > > test if the param does not exist.
 > >
 > > Or you could provide a personal repo that contains the case, so kernel
 > > maintainers & reviewers could verify the feature with that repo?
 > >
 >=20
 > FWIW, I am glad the test was posted early for review as a proof of
 > what was tested, but no reason to merge it before the kernel patch.
 > A personal repo link and/or the test in a single patch with the helper
 > should be good enough for reviewers.
 >=20

Hi Eryu, Amir

I got it, I will post V2 with all fixes in a single patch.


Thanks,
cgxu



