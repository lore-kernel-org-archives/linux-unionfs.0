Return-Path: <SRS0=sqyI=56=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3DBC2BB1D
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Apr 2020 04:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E071206A2
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Apr 2020 04:25:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="dVqLlLsS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405336AbgDNEZt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Apr 2020 00:25:49 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25388 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728978AbgDNEZt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Apr 2020 00:25:49 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1586838334; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=jne9BFWbV6px3FV0EuZUUnHNarRlNcP+pDMer1g1azu/FsuGdJn8lwsjBVeE9xqjpb2p+VOiKNiXYOGRhkmG4IKebz7o2AmNjPmpDdrtkgWqP8hoTjWoB1GhCmVS3Jam2Yxm4ugT2d1r0JmkumtK+LxCWL2JVlgkXXooy0hFHC8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1586838334; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=tFVCHF5X9F3V0C5fiRXjBWEx2fetbF6Rb9xI9OUDYb4=; 
        b=k4FhBg1YuF2MwY9Bf7A/yaIJwt+MH18SKexKu20uHzXH3BLhAVmf6NZgl3rVXqroids26QQZzXx2j75QClSe+UMSSImVkMnF93wNRlhKGAliGhzYX+5xVrmaWpAu4RvJu87so8yS0U3sREHGM41ybPCs8LtgpQv/lbPEDxHAijo=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1586838334;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=tFVCHF5X9F3V0C5fiRXjBWEx2fetbF6Rb9xI9OUDYb4=;
        b=dVqLlLsSpZWlt8lJQJY5jc7K/InSRTmK5xOJJ4kxLVi9PlKwjmRL2sY/d/SDpgKB
        Ty615HvS4KBKmebj+DuLq/Gn3kiX2DvRcK4mdftgCq7k8OvXFxt0a2TGzbDOq66tCiZ
        IDQwQBtWEIwXBKgyn5hDTaK5yS6c5VJTpqqeLs00=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1586838332451870.0070962787424; Tue, 14 Apr 2020 12:25:32 +0800 (CST)
Date:   Tue, 14 Apr 2020 12:25:32 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>
Cc:     "Eryu Guan" <guaneryu@gmail.com>,
        "fstests" <fstests@vger.kernel.org>,
        "overlayfs" <linux-unionfs@vger.kernel.org>,
        "Miklos Szeredi" <miklos@szeredi.hu>
Message-ID: <17176ef641f.12080ec416876.975177736351041421@mykernel.net>
In-Reply-To: <CAOQ4uxhP81fkjjVHFkeE-G2eZVvqVz33X2VuBTBqDc8j=t0-NQ@mail.gmail.com>
References: <20200414023105.28261-1-cgxu519@mykernel.net> <CAOQ4uxhP81fkjjVHFkeE-G2eZVvqVz33X2VuBTBqDc8j=t0-NQ@mail.gmail.com>
Subject: Re: [PATCH v2] overlay/072: test for whiteout inode sharing
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

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=8C, 2020-04-14 11:22:26 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Tue, Apr 14, 2020 at 5:31 AM Chengguang Xu <cgxu519@mykernel.net> wro=
te:
 > >
 > > This is a test for whiteout inode sharing feature.
 > >
 > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > > ---
 > > v1->v2:
 > > - Address Amir's comments in v1.
 >=20
 > Looks good. Some nits.
 > With those fixed you may add:
 > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
 >=20
 >=20
 > >
 > >  common/module         |   9 +++
 > >  tests/overlay/072     | 148 +++++++++++++++++++++++++++++++++++++++++=
+
 > >  tests/overlay/072.out |   2 +
 > >  tests/overlay/group   |   1 +
 > >  4 files changed, 160 insertions(+)
 > >  create mode 100755 tests/overlay/072
 > >  create mode 100644 tests/overlay/072.out
 > >
 > > diff --git a/common/module b/common/module
 > > index 39e4e793..148e8c8f 100644
 > > --- a/common/module
 > > +++ b/common/module
 > > @@ -81,3 +81,12 @@ _get_fs_module_param()
 > >  {
 > >         cat /sys/module/${FSTYP}/parameters/${1} 2>/dev/null
 > >  }
 > > + # Set the value of a filesystem module parameter
 > > + # at /sys/module/$FSTYP/parameters/$PARAM
 > > + #
 > > + # Usage example:
 > > + #   _set_fs_module_param param value
 > > + _set_fs_module_param()
 > > +{
 > > +       echo ${2} > /sys/module/${FSTYP}/parameters/${1} 2>/dev/null
 > > +}
 > > diff --git a/tests/overlay/072 b/tests/overlay/072
 > > new file mode 100755
 > > index 00000000..e1244394
 > > --- /dev/null
 > > +++ b/tests/overlay/072
 > > @@ -0,0 +1,148 @@
 > > +#! /bin/bash
 > > +# SPDX-License-Identifier: GPL-2.0
 > > +# Copyright (c) 2020 Chengguang Xu <cgxu519@mykernel.net>.
 > > +# All Rights Reserved.
 > > +#
 > > +# FS QA Test 072
 > > +#
 > > +# This is a test for whiteout inode sharing feature.
 > > +#
 > > +seq=3D`basename $0`
 > > +seqres=3D$RESULT_DIR/$seq
 > > +echo "QA output created by $seq"
 > > +
 > > +here=3D`pwd`
 > > +tmp=3D/tmp/$
 > > +status=3D1       # failure is the default!
 > > +trap "_cleanup; exit \$status" 0 1 2 3 15
 > > +
 > > +_cleanup()
 > > +{
 > > +       cd /
 > > +       rm -f $tmp.*
 > > +       _set_fs_module_param $param_name $orig_param_value
 >=20
 > verify orig_param_value is not empty
 >=20
=20
I think if orig_param_value is empty, then test will be "not run" therefore=
 _cleanup() will not be called.

Thanks,
cgxu


