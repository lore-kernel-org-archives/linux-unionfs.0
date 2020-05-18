Return-Path: <SRS0=JhEn=7A=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB0DC433DF
	for <linux-unionfs@archiver.kernel.org>; Mon, 18 May 2020 02:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99EB32070A
	for <linux-unionfs@archiver.kernel.org>; Mon, 18 May 2020 02:36:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="ATYgK529"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgERCg7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 17 May 2020 22:36:59 -0400
Received: from sender2-of-o52.zoho.com.cn ([163.53.93.247]:21149 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726639AbgERCg6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 17 May 2020 22:36:58 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1589769409; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=hC8QOvYQVizMZnnEyV3rksjfjsq/wqnebRn7dArXSqxuhJWceVysYwQ14nR7WFarB289e02Gf3MZC2w3tb0oTl+BYMVa5U2zZvGe4MrPUxwX9Y/wvW41DJQ6GVZf1TJD6TlBCaplmiaHpgb8VmJIdCNDYYUsGPtO3d6fFWK4cIk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1589769409; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=HUW5Y4ugn2/incZJJH/85iYjyOY8Wk2WhKwoPsTQdcI=; 
        b=DA6TzlKnXlg0iFk5Y28aJs+LxNYor1CGkbvPgy1K5ttU8BBcA/TD6LDR+y2e5fjd/Z6oVT1XP0lTysskvH9iMDCbLLe/AAjox/qmGSt6FqHjVVQPCFGseKp5GmF5mDKMMX8DWIMZSmGO5XfVQ1JmZ6q3h6GqKt+O/ZBZv8S6JGI=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1589769409;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=HUW5Y4ugn2/incZJJH/85iYjyOY8Wk2WhKwoPsTQdcI=;
        b=ATYgK529YNfjsA2SU7dy4diLvQC0aiEOlxYts0ewA0MmNXYzWR8m7/YxhC6UJoTg
        9X9cTXjVutBz31QdLQ3fEuxLVpQLbbWFnmDWxKpmFnpH+aDFieAgPjXiAMoW2zeA5k5
        RccVxuOBHDgBbr33h+6n0QPsDYdG1hFzJuHnmcIo=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 158976940492991.06137589965692; Mon, 18 May 2020 10:36:44 +0800 (CST)
Date:   Mon, 18 May 2020 10:36:44 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Eryu Guan" <guan@eryu.me>
Cc:     "guaneryu" <guaneryu@gmail.com>,
        "fstests" <fstests@vger.kernel.org>,
        "linux-unionfs" <linux-unionfs@vger.kernel.org>
Message-ID: <17225a401fd.f5f9e76e17914.3773901501971634787@mykernel.net>
In-Reply-To: <20200517142922.GA2704@desktop>
References: <20200422045210.11017-1-cgxu519@mykernel.net> <20200517142922.GA2704@desktop>
Subject: Re: [PATCH] generic/484: test data integrity for rdonly remount
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

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E6=97=A5, 2020-05-17 22:29:22 Eryu Guan =
<guan@eryu.me> =E6=92=B0=E5=86=99 ----
 > On Wed, Apr 22, 2020 at 12:52:10PM +0800, Chengguang Xu wrote:
 > > This test checks data integrity when remounting from
 > > rw to ro mode.
 > >=20
 > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 >=20
 > The test itself looks fine. I'm just wondering that is there a real bug
 > which is exposed by this test? And what's the purpose of the shutdown?
 > More background info would be great if there's any.
 >=20

The case is  for testing below fix patch in overlayfs but I think maybe it =
is also suitable for other file systems.
https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git/commit/?h=
=3Doverlayfs-next&id=3D399c109d357a7e217cf7ef551e7e234439c68c15

shutdown will avoid effect of async dirty data flushing.=20


 > > ---
 > >  tests/generic/484     | 54 ++++++++++++++++++++++++++++++++++++++++++=
+
 > >  tests/generic/484.out |  2 ++
 > >  tests/generic/group   |  1 +
 > >  3 files changed, 57 insertions(+)
 > >  create mode 100755 tests/generic/484
 > >  create mode 100644 tests/generic/484.out
 > >=20
 > > diff --git a/tests/generic/484 b/tests/generic/484
 > > new file mode 100755
 > > index 00000000..bc640214
 > > --- /dev/null
 > > +++ b/tests/generic/484
 > > @@ -0,0 +1,54 @@
 > > +#! /bin/bash
 > > +# SPDX-License-Identifier: GPL-2.0
 > > +# Copyright (c) 2020 Chengguang Xu <cgxu519@mykernel.net>.
 > > +# All Rights Reserved.
 > > +#
 > > +# FS QA Test 484
 > > +#
 > > +# Test data integrity for ro remount.
 > > +#
 > > +seq=3D`basename $0`
 > > +seqres=3D$RESULT_DIR/$seq
 > > +echo "QA output created by $seq"
 > > +
 > > +here=3D`pwd`
 > > +tmp=3D/tmp/$
 > > +status=3D0
 > > +trap "_cleanup; exit \$status" 0 1 2 3 15
 > > +
 > > +_cleanup()
 > > +{
 > > +    cd /
 > > +    rm -f $tmp.*
 > > +}
 > > +
 > > +# get standard environment, filters and checks
 > > +. ./common/rc
 > > +. ./common/filter
 > > +
 > > +# remove previous $seqres.full before test
 > > +rm -f $seqres.full
 > > +
 > > +# real QA test starts here
 > > +_supported_fs generic
 > > +_supported_os Linux
 > > +_require_fssum
 > > +_require_scratch
 > > +_require_scratch_shutdown
 > > +
 > > +_scratch_mkfs &>/dev/null
 > > +_scratch_mount
 > > +
 > > +localdir=3D$SCRATCH_MNT/dir
 > > +mkdir $localdir
 > > +sync
 > > +
 > > +# fssum used for comparing checksum of test file(data & metedata),
 > > +# exclude checking about atime, block structure, open error.
 > > +$FSSUM_PROG -ugomAcdES -f -w $tmp.fssum $localdir
 > > +_scratch_remount ro
 > > +_scratch_shutdown
 > > +_scratch_cycle_mount
 > > +$FSSUM_PROG -r $tmp.fssum $localdir
 > > +
 > > +exit
 > > diff --git a/tests/generic/484.out b/tests/generic/484.out
 > > new file mode 100644
 > > index 00000000..e33c7815
 > > --- /dev/null
 > > +++ b/tests/generic/484.out
 > > @@ -0,0 +1,2 @@
 > > +QA output created by 484
 > > +OK
 > > diff --git a/tests/generic/group b/tests/generic/group
 > > index 718575ba..cc58ff0d 100644
 > > --- a/tests/generic/group
 > > +++ b/tests/generic/group
 > > @@ -486,6 +486,7 @@
 > >  481 auto quick log metadata
 > >  482 auto metadata replay thin
 > >  483 auto quick log metadata
 > > +484 auto quick remount
 >=20
 > Also in shutdown group.
 >=20

I'll add this in next version.


Thanks,
cgxu
