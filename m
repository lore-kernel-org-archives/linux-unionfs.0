Return-Path: <SRS0=sqyI=56=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB82C2BBFD
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Apr 2020 06:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DE9C2072D
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Apr 2020 06:16:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EAuyxazM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405841AbgDNGQk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Apr 2020 02:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405829AbgDNGQj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Apr 2020 02:16:39 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820FFC0A3BDC;
        Mon, 13 Apr 2020 23:16:39 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id w20so12033375iob.2;
        Mon, 13 Apr 2020 23:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gzajVXyP1feqf6gT0AB28vMkplvB3wMCWtdNsfa+JMU=;
        b=EAuyxazMvkaFSdqWUgtiPN/+LE2ptNSxv1rAxmEQ7INyliHaxbLNfC28bjy0EMxAqx
         q89PDmqcbo71OHD/yup3aSHIr/WgCmFD+OUE8XPW1aU+HSW+fd/NlfEOyfm0PQhSDMrH
         omy3F/j5Pt0VliWI1aBFYzRRb/gF+NC5NS6DzxbfcO+MJrooo3U2L++hYyfhwGEMOpAF
         VvnezL00B4dSDoEFHw5RngyV//S5Uo+YdR5FUyFDxnfj4C9XkjEZKVIw6X03BTBTR0B5
         DrkBRT4RtgG4GR1DcINzHmnqdYn08BuZ/fzAxxvCvsQ4zYPgz4nIAMV9iPWPEJ+7wffr
         q8ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gzajVXyP1feqf6gT0AB28vMkplvB3wMCWtdNsfa+JMU=;
        b=Cl9Xmz7YbTb09brb3qvpWdZa94e5t2rjzocFqWrhuh7IDtY4qSSK2oD1aKpKfVNry8
         6Un24dbrToBaV4UddBgocD+3OpFmM7aUSAC+HcmCDRU6d+l8DvswOvHvY78YfYBUBnXa
         YFV4GyePgkKseZQfv/qKUR3kSLxQ7Qe7+o5lDF/cqGIMZBommMRULB53F5fucVfA/fuV
         pTsIpJrjOL1b+jl12fHkuHMd/Wcy/ReHo09Qx+veAWQ5B3c8v02O0taaQrbis6slL50o
         hj5hTIOEeF/ag0p4ip7tzMiMSVIpLtNN2g3rIMKg2+iAEbJX7LxEbRU36NXOK/UyhlB6
         6Pgw==
X-Gm-Message-State: AGi0PuZDa5iknT8/EJD0Zebwn/blHi0NPRjQVlIAd29NfD3YV6V+00NL
        13MGf3ZkAqOBOe7/Adz9lQgfCuy+h0CLsJ6LJxo9jA==
X-Google-Smtp-Source: APiQypKFnduKQX6vg/rZ1qvRmeA9I6KYBfX1P1qCpnVdmGT5dfhVjcgvNbzfYw4tayybtu05yEVRMpKtqXfzjSCy1tk=
X-Received: by 2002:a05:6602:2fc4:: with SMTP id v4mr19814917iow.64.1586844998502;
 Mon, 13 Apr 2020 23:16:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200414023105.28261-1-cgxu519@mykernel.net> <CAOQ4uxhP81fkjjVHFkeE-G2eZVvqVz33X2VuBTBqDc8j=t0-NQ@mail.gmail.com>
 <17176ef641f.12080ec416876.975177736351041421@mykernel.net>
In-Reply-To: <17176ef641f.12080ec416876.975177736351041421@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 14 Apr 2020 09:16:26 +0300
Message-ID: <CAOQ4uxi-yO30yr9DTt9VeHkRaQ7S7i5p7M7Azg+VETT=T4HNLA@mail.gmail.com>
Subject: Re: [PATCH v2] overlay/072: test for whiteout inode sharing
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 14, 2020 at 7:25 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=8C, 2020-04-14 11:22:26 Amir Gol=
dstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > On Tue, Apr 14, 2020 at 5:31 AM Chengguang Xu <cgxu519@mykernel.net> w=
rote:
>  > >
>  > > This is a test for whiteout inode sharing feature.
>  > >
>  > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>  > > ---
>  > > v1->v2:
>  > > - Address Amir's comments in v1.
>  >
>  > Looks good. Some nits.
>  > With those fixed you may add:
>  > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>  >
>  >
>  > >
>  > >  common/module         |   9 +++
>  > >  tests/overlay/072     | 148 +++++++++++++++++++++++++++++++++++++++=
+++
>  > >  tests/overlay/072.out |   2 +
>  > >  tests/overlay/group   |   1 +
>  > >  4 files changed, 160 insertions(+)
>  > >  create mode 100755 tests/overlay/072
>  > >  create mode 100644 tests/overlay/072.out
>  > >
>  > > diff --git a/common/module b/common/module
>  > > index 39e4e793..148e8c8f 100644
>  > > --- a/common/module
>  > > +++ b/common/module
>  > > @@ -81,3 +81,12 @@ _get_fs_module_param()
>  > >  {
>  > >         cat /sys/module/${FSTYP}/parameters/${1} 2>/dev/null
>  > >  }
>  > > + # Set the value of a filesystem module parameter
>  > > + # at /sys/module/$FSTYP/parameters/$PARAM
>  > > + #
>  > > + # Usage example:
>  > > + #   _set_fs_module_param param value
>  > > + _set_fs_module_param()
>  > > +{
>  > > +       echo ${2} > /sys/module/${FSTYP}/parameters/${1} 2>/dev/null
>  > > +}
>  > > diff --git a/tests/overlay/072 b/tests/overlay/072
>  > > new file mode 100755
>  > > index 00000000..e1244394
>  > > --- /dev/null
>  > > +++ b/tests/overlay/072
>  > > @@ -0,0 +1,148 @@
>  > > +#! /bin/bash
>  > > +# SPDX-License-Identifier: GPL-2.0
>  > > +# Copyright (c) 2020 Chengguang Xu <cgxu519@mykernel.net>.
>  > > +# All Rights Reserved.
>  > > +#
>  > > +# FS QA Test 072
>  > > +#
>  > > +# This is a test for whiteout inode sharing feature.
>  > > +#
>  > > +seq=3D`basename $0`
>  > > +seqres=3D$RESULT_DIR/$seq
>  > > +echo "QA output created by $seq"
>  > > +
>  > > +here=3D`pwd`
>  > > +tmp=3D/tmp/$
>  > > +status=3D1       # failure is the default!
>  > > +trap "_cleanup; exit \$status" 0 1 2 3 15
>  > > +
>  > > +_cleanup()
>  > > +{
>  > > +       cd /
>  > > +       rm -f $tmp.*
>  > > +       _set_fs_module_param $param_name $orig_param_value
>  >
>  > verify orig_param_value is not empty
>  >
>
> I think if orig_param_value is empty, then test will be "not run" therefo=
re _cleanup() will not be called.
>

_cleanup() is called also on exit 0 so also in case of _notrun

Thanks,
Amir.
