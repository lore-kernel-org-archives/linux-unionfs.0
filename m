Return-Path: <SRS0=BYJY=6D=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18DCC38A30
	for <linux-unionfs@archiver.kernel.org>; Sun, 19 Apr 2020 15:42:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACDB621973
	for <linux-unionfs@archiver.kernel.org>; Sun, 19 Apr 2020 15:42:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Idlx7yJX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbgDSPm5 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 19 Apr 2020 11:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgDSPm4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 19 Apr 2020 11:42:56 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE088C061A0C;
        Sun, 19 Apr 2020 08:42:54 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id u189so2558532ilc.4;
        Sun, 19 Apr 2020 08:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LRM5S6uTpg1Vl8+gbOvW4L9SH5Gg3OLbDNgWN4DaPMk=;
        b=Idlx7yJX3OY2wt1TgTXUZaymC3olvZF7XYBv++FNxfyFMXcXu5qro2X0ICLLXEuBC/
         7yosMiK4tpeuIByxeW5yBF7iFUwmHlp4GLBaMBqd5WAvjESKlGBQv7zTpi44vOQdOcvW
         75OgYK/UyhRJlOIufRtiieWv+eAb97DCQ44N3mHXrnd+C+mZKxFe1Idby8/m+XaGrMMd
         XEnilTMfWdSlpEOyryO83x/9fvErIhpUoPYixIs23etW80/l6cASg5DRIjr8vkHrp6TY
         kcVTzeKGNvcyVVr1GIn6jFY1XOhHwqqksEmyZ58wBHNmFiG9KCTxvMgfBp3lP8P+rOLY
         9lHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LRM5S6uTpg1Vl8+gbOvW4L9SH5Gg3OLbDNgWN4DaPMk=;
        b=W5kKiTJE0x8+ZL534h0TShwy5+pVexSJZBXWxadnnj+N2rm8pzZDg6l1Avp6m8HFui
         lIs+kU+QcceC8LUJ9VYayreFyHCteIS8NqrlIZNzMMlOgq6Y22Om4ef+mQDjtKTMWWFD
         n4n5U3i96m1xaGzleg1JJDIgUsfZtkfstbS6dM8DUkdawtgYMaxM6lypEZPWBV0w2hz4
         LXcGdlTfVNbLs8EB59jRpNNp2EPxE3knyR3tzE7jEx6maikIRXUZ05me2J03Z1/Mpw1P
         3MfcOzNAt1zkHLT6bygy5Cal5+BgfF9liPsi1JAkUBhRCmSrZMPibM6fwA8lda7UpzBb
         qt3A==
X-Gm-Message-State: AGi0PubArivGAx0aIouYw5SJbXjPflem82yn400azFWu2EERS5+Ri753
        kJ45pPdSiBBlNyYnuD3EiIndkcOH9/XQ3/aFyQRJpg==
X-Google-Smtp-Source: APiQypIIVWtdW0bZEyVrQ0Bn1TrTiTOBOFk3kzzD9tzHzo+rqxuxrYHtrE9UuAm8P6xJlHWOS4NZQFWwhEhb3LMcR3Y=
X-Received: by 2002:a92:9e11:: with SMTP id q17mr70693ili.137.1587310973923;
 Sun, 19 Apr 2020 08:42:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200409112223.14496-1-amir73il@gmail.com> <20200419150147.GF388005@desktop>
In-Reply-To: <20200419150147.GF388005@desktop>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 19 Apr 2020 18:42:42 +0300
Message-ID: <CAOQ4uxijb_VBT_HTdTcbgLmZqDp62QEBwQZ9sq8sYjgVJobbkw@mail.gmail.com>
Subject: Re: [PATCH] overlay: another test for dropping nlink below zero
To:     Eryu Guan <guan@eryu.me>
Cc:     Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Apr 19, 2020 at 6:00 PM Eryu Guan <guan@eryu.me> wrote:
>
> On Thu, Apr 09, 2020 at 02:22:23PM +0300, Amir Goldstein wrote:
> > This is a variant on test overlay/034.
> >
> > This variant is mangling upper hardlinks instead of lower hardlinks
> > and does not require the inodes index feature.
> >
> > This is a regression test for kernel commit 83552eacdfc0
> > ("ovl: fix WARN_ON nlink drop to zero")
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Eryu,
> >
> > The kernel fix commit just got merged.
> >
> > Thanks,
> > Amir.
> >
> >  tests/overlay/072     | 85 +++++++++++++++++++++++++++++++++++++++++++
> >  tests/overlay/072.out |  2 +
> >  tests/overlay/group   |  1 +
> >  3 files changed, 88 insertions(+)
> >  create mode 100755 tests/overlay/072
> >  create mode 100644 tests/overlay/072.out
> >
> > diff --git a/tests/overlay/072 b/tests/overlay/072
> > new file mode 100755
> > index 00000000..e9084e5c
> > --- /dev/null
> > +++ b/tests/overlay/072
> > @@ -0,0 +1,85 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (C) 2020 CTERA Networks. All Rights Reserved.
> > +#
> > +# FS QA Test 072
> > +#
> > +# Test overlay nlink when adding upper hardlinks.
> > +#
> > +# nlink of overlay inode could be dropped indefinitely by adding
> > +# unaccounted upper hardlinks underneath a mounted overlay and
> > +# trying to remove them.
> > +#
> > +# This is a variant of test overlay/034 with mangling of upper instead
> > +# of lower hardlinks. Unlike overlay/034, this test does not require the
> > +# inode index feature and will pass whether is it enabled or disabled
> > +# by default.
> > +#
> > +# This is a regression test for kernel commit 83552eacdfc0
> > +# ("ovl: fix WARN_ON nlink drop to zero").
> > +# Without the fix, the test triggers
> > +# WARN_ON(inode->i_nlink == 0) in drop_link().
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +tmp=/tmp/$$
> > +status=1     # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +     cd /
> > +     rm -f $tmp.*
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
> > +
> > +upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> > +
> > +# Remove all files from previous tests
> > +_scratch_mkfs
> > +
> > +# Create lower hardlink
>
> It seems there're some stale comments that are copied from overlay/034,
> above is one of them, should be "Create upper hardlink"
>

Yep. I'll fix those up.

> > +mkdir -p $upperdir
> > +touch $upperdir/0
> > +ln $upperdir/0 $upperdir/1
> > +
> > +_scratch_mount
> > +
> > +# Copy up lower hardlink - overlay inode nlink 2 is copied from lower
> > +touch $SCRATCH_MNT/0
>
> There's no copyup, then do we need this touch at all?

We do not need touch, but we do need something to do the
lookup and read upper nlink before modifying it underneath.

Good points.
I'll send fixed v2.

Thanks,
Amir.
