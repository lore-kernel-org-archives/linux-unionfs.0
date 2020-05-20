Return-Path: <SRS0=Uqc0=7C=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B64F0C433E0
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 May 2020 15:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E65F206F1
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 May 2020 15:09:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YL0Emu/w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgETPJf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 20 May 2020 11:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbgETPJe (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 20 May 2020 11:09:34 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC41C061A0E;
        Wed, 20 May 2020 08:09:34 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id v26so2035619vsa.1;
        Wed, 20 May 2020 08:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=Zt0rJdpfwVaRClF7yWcTgjaZat7i1LmocQVlHy92Vww=;
        b=YL0Emu/wsvQdfsRdSjskce3wFjghZ1X3iiiuEM+QcwWQt7Yfkc3Ze2itJ9o9fiOMF6
         hlNm7D/6Dk2eiaLRLdBAeAR2dpQjvDGarltKuKnftsZHj5kRMsjDOFiyIuGG66I8yt4i
         cJx/Mngr8brt4mscu2zcVOg/6DILkwOvTxLkKz8TAcW7ZPtmrRMaJbUbbBdS5z+1dd14
         36tawV8aH+jreQYdNlbomT4zJXo210UXSKPxVU+s1UoIMSN/EdIi+tiWtKS2sn4dddss
         CjMVwWO6f+Tc1BKx4kRcGllWaxY593VyqAdqXC0lYrPd8jVLMynr/gQ4tKXe5+/udryw
         7o4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=Zt0rJdpfwVaRClF7yWcTgjaZat7i1LmocQVlHy92Vww=;
        b=ZTnbIogb3F8mSQvBArjzRplP4L4t0wlWQZnPOeuLVzOLd2CnkuBWZo9Dzoj6YsPSsF
         ghcAt2OR5zAMKlqI8Sfl8SaKW3g3X+HOFdNFIAK5Yc+EtBdsXFfPWyWZ/Q/CrIy1pdtK
         OEUzyf3IX98ZRc2rEPNF9CX1rVjbQ6nKOWAFV4A89DkNZ3A2YRz+Ok0aaABiJQa6Ajfj
         1Ii4L29MKw+03zJdaDrBy0f20GIFAeI/eyNumtmRy8oqRXe30JcAufpus6hssHIp62Cf
         dR0uhNQdjGkc8M7F90rw0MY0M3Gx4WwB5Izcq8SYDg4Ly0fRCzSCnJ7TfY1NtaOWVwMK
         AA/g==
X-Gm-Message-State: AOAM5311NYOkf4GP1rDTHgPpF/hkz33xTBDnL/MEEOWAqcxB/u1nYWrh
        QA/LdXr535ZiFm1XpfWRNFnYajOQxfAwuc6PCeI=
X-Google-Smtp-Source: ABdhPJxTi3+891HtVeZHnTj+GWxC6HiwivP7fwkEFpNOd6ZfuaHisjuxA3/838d0QZiLng4VUDLV+l6V12UmB/w7wF0=
X-Received: by 2002:a67:e297:: with SMTP id g23mr3452571vsf.90.1589987373895;
 Wed, 20 May 2020 08:09:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200519080929.18030-1-cgxu519@mykernel.net>
In-Reply-To: <20200519080929.18030-1-cgxu519@mykernel.net>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Wed, 20 May 2020 16:09:23 +0100
Message-ID: <CAL3q7H4aObeXLuhv05AOyrLU1B_3M81y_ddH1cY0pAEEEO+Law@mail.gmail.com>
Subject: Re: [PATCH v2] generic/597: test data integrity for rdonly remount
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, May 19, 2020 at 9:10 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> This test checks data integrity when remounting from
> rw to ro mode.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
> v1->v2:
> - Add to shutdown greoup.
> - Change case number to 597
>
>  tests/generic/597     | 54 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/597.out |  2 ++
>  tests/generic/group   |  1 +
>  3 files changed, 57 insertions(+)
>  create mode 100755 tests/generic/597
>  create mode 100644 tests/generic/597.out
>
> diff --git a/tests/generic/597 b/tests/generic/597
> new file mode 100755
> index 00000000..d96e750b
> --- /dev/null
> +++ b/tests/generic/597
> @@ -0,0 +1,54 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chengguang Xu <cgxu519@mykernel.net>.
> +# All Rights Reserved.
> +#
> +# FS QA Test 597
> +#
> +# Test data integrity for ro remount.
> +#
> +seq=3D`basename $0`
> +seqres=3D$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=3D`pwd`
> +tmp=3D/tmp/$$
> +status=3D0
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +       cd /
> +       rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_require_fssum
> +_require_scratch
> +_require_scratch_shutdown

Couldn't the test be using dm's flakey instead of shutdown?
As shutdown is not implemented by all filesystems (btrfs for example),
it would allow more coverage.

Thanks.

> +
> +_scratch_mkfs &>/dev/null
> +_scratch_mount
> +
> +localdir=3D$SCRATCH_MNT/dir
> +mkdir $localdir
> +sync
> +
> +# fssum used for comparing checksum of test file(data & metedata),
> +# exclude checking about atime, block structure, open error.
> +$FSSUM_PROG -ugomAcdES -f -w $tmp.fssum $localdir
> +_scratch_remount ro
> +_scratch_shutdown
> +_scratch_cycle_mount
> +$FSSUM_PROG -r $tmp.fssum $localdir
> +
> +exit
> diff --git a/tests/generic/597.out b/tests/generic/597.out
> new file mode 100644
> index 00000000..a847cfe2
> --- /dev/null
> +++ b/tests/generic/597.out
> @@ -0,0 +1,2 @@
> +QA output created by 597
> +OK
> diff --git a/tests/generic/group b/tests/generic/group
> index e82004e8..d68fee9a 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -599,3 +599,4 @@
>  594 auto quick quota
>  595 auto quick encrypt
>  596 auto quick
> +597 auto quick remount shutdown
> --
> 2.20.1
>
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
