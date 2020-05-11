Return-Path: <SRS0=Fn9a=6Z=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E78C38A2A
	for <linux-unionfs@archiver.kernel.org>; Mon, 11 May 2020 01:32:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B052E208E4
	for <linux-unionfs@archiver.kernel.org>; Mon, 11 May 2020 01:32:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="DNGSEVnN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbgEKBcq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 10 May 2020 21:32:46 -0400
Received: from sender2-of-o52.zoho.com.cn ([163.53.93.247]:21156 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728468AbgEKBcq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 10 May 2020 21:32:46 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1589160742; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=oiS0qQXhKv1u7xj80ZeCsVz54jUouDF91KYU5iAMEIlRLjG8VCihory+xRRWiY/BAsWpfnDw8JJaONVgSlcs1lbPGhVz9Tr4VldPsPv8Tdxjk9LZdMIfVH/1gOvnOOgZK6zbcOJbC8+GkItyJfqb4LBR5q4GcAK8uNV64g83sPY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1589160742; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=T68Hmv5Nulj0S/5rz1p3pjucba51cYTYyJkFDHDTu8E=; 
        b=dhDf9T4HPJT/lw98Lz2EfUo7Lf7u8bI9WvJKZRcNP8csofXeZgwCNRW8vKVk251gruGBffH2qtzLjPFxVEVKGStd66DXdqx3asusJokFKkkVakdY5JYPijJOrOc5nFQFeTeRMLmQ5L7uEJ6qeZ8B0tNHMr2RGq5Ueml0YANGtTI=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1589160742;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=T68Hmv5Nulj0S/5rz1p3pjucba51cYTYyJkFDHDTu8E=;
        b=DNGSEVnNu53H/DnW95BBNzzsX3CaLLftItFYQ83b749AdASLEU3Bun1gJFhqoXVs
        k8YVS4IK0UmJqhr53ZWNNmBXXfAMScSyCEn9lBkgI/HqyQRobsWgb2DVQYjR2DTY/9S
        GtfOtmh1lEB3cHmlLxsNvw3XraElLRCCO0XhNEKE=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1589160740501108.29865526715366; Mon, 11 May 2020 09:32:20 +0800 (CST)
Date:   Mon, 11 May 2020 09:32:20 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Eryu Guan" <guan@eryu.me>
Cc:     "miklos" <miklos@szeredi.hu>, "amir73il" <amir73il@gmail.com>,
        "fstests" <fstests@vger.kernel.org>,
        "linux-unionfs" <linux-unionfs@vger.kernel.org>
Message-ID: <172015c8691.108177c8110122.924760245390345571@mykernel.net>
In-Reply-To: <20200510155037.GB9345@desktop>
References: <20200506101528.27359-1-cgxu519@mykernel.net> <20200510155037.GB9345@desktop>
Subject: Re: [PATCH v4] overlay: test for whiteout inode sharing
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

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E6=97=A5, 2020-05-10 23:50:37 Eryu Guan =
<guan@eryu.me> =E6=92=B0=E5=86=99 ----
 > On Wed, May 06, 2020 at 06:15:28PM +0800, Chengguang Xu wrote:
 > > This is a test for whiteout inode sharing feature.
 > >=20
 > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > > ---
 > > v1->v2:
 > > - Address Amir's comments in v1
 > >=20
 > > v2->v3:
 > > - Address Amir's comments in v2=20
 > >=20
 > > v3->v4:
 > > - Fix test case based on latest kernel patch(removed module param)
 > > https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git/commi=
t/?h=3Doverlayfs-next&id=3D4e49695244661568130bfefcb6143dd1eaa3d8e7
 > >=20
 > >  tests/overlay/073     | 106 +++++++++++++++++++++++++++++++++++++++++=
+
 > >  tests/overlay/073.out |   2 +
 > >  tests/overlay/group   |   1 +
 > >  3 files changed, 109 insertions(+)
 > >  create mode 100755 tests/overlay/073
 > >  create mode 100644 tests/overlay/073.out
 > >=20
 > > diff --git a/tests/overlay/073 b/tests/overlay/073
 > > new file mode 100755
 > > index 00000000..fc847092
 > > --- /dev/null
 > > +++ b/tests/overlay/073
 > > @@ -0,0 +1,106 @@
 > > +#! /bin/bash
 > > +# SPDX-License-Identifier: GPL-2.0
 > > +# Copyright (c) 2020 Chengguang Xu <cgxu519@mykernel.net>.
 > > +# All Rights Reserved.
 > > +#
 > > +# FS QA Test 073
 > > +#
 > > +# Test whiteout inode sharing functionality.
 > > +#
 > > +# A "whiteout" is an object that has special meaning in overlayfs.
 > > +# A whiteout on an upper layer will effectively hide a matching file
 > > +# in the lower layer, making it appear as if the file didn't exist.
 > > +#
 > > +# Whiteout inode sharing means multiple whiteout objects will share
 > > +# one inode in upper layer, without this feature every whiteout objec=
t
 > > +# will consume one inode in upper layer.
 > > +
 > > +seq=3D`basename $0`
 > > +seqres=3D$RESULT_DIR/$seq
 > > +echo "QA output created by $seq"
 > > +
 > > +here=3D`pwd`
 > > +tmp=3D/tmp/$
 > > +status=3D1    # failure is the default!
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
 > > +_supported_fs overlay
 > > +_supported_os Linux
 > > +_require_scratch
 >=20
 > I see no feature detection logic, so test just fails on old kernels
 > without this feature? I tried with v5.7-r4 kernel, test fails because
 > each whiteout file has only one hardlink.
=20
That's true.

Thanks,
cgxu

