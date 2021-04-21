Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F84C433B4
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Apr 2021 09:33:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8C726143D
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Apr 2021 09:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238277AbhDUJe0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 05:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238079AbhDUJe0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Apr 2021 05:34:26 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFDDC06174A;
        Wed, 21 Apr 2021 02:33:53 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id h141so33034935iof.2;
        Wed, 21 Apr 2021 02:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/RY5d9E7SDYx339Y6sbe3sOQtAM3leSPsyHyjMz/clo=;
        b=Qw1D2HUH77mxRogJRTWxGN8KDcflut4/EMSW5rn+PBMm1et/2v2vjaspT1Qc0/KjSg
         OTXSNoKHhJ71e84FTS5UHC1zsba27wHxTmLdjkyCOHbPkzx9I4fjq4mHxt7pw4qeHgKQ
         pAR65jZqEiRyfc9JlIYzWwIUeslv9mvaH66/xNrQJN/XSqfb1RszDzyACIwGBK4scemr
         KWf2fO175mOVYaE8B7ehsXEAjmsLsaWwfVFLKd2m6FT3GcHBq/TshTUhHQcBWTVheQ6M
         6PMD/13TfRLl3KQUmsqvp47Y/D5hGEmJJwyOfLZCLUh23vlaccoeFs8fgr+L7tFg8o+P
         SRJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/RY5d9E7SDYx339Y6sbe3sOQtAM3leSPsyHyjMz/clo=;
        b=CkFE74B/kK5Yl2D4uIoTS11N3sfD+9Ua4jgeMZf69fp37X8ueKWTm2gVdfYbtVwAq2
         Vzyo+hD8QOACh+Dwb825ar5AEOlPDirMl44dBw9whW36eu9vXd1aIrkcl+aD8TL5OaU2
         2t8sbOXaAwA6tlu8NaplAOoG94S3dgWbGd8NWeeVlMmdgsf3T4f1QO6+ROEL0X/pbFBl
         Oh3fxuRvKFC8c4/Y4ez5WfqnWYD+X5cIJ1HOB8q71e2B+XRmTZuOrX+gLOw3rXMwKCgO
         i/MMoOodQAcBY5b2RkFruURgSNts5URp8Fnk0U6HH3uE2cp1Tqft1wHTkVvj4jOoNhxZ
         pBKA==
X-Gm-Message-State: AOAM530LANP5HHmeq/Tgs28X1zkseoggEPzycoUV55uEEfKpQ/0ny2Wr
        pq1jjfB4fLr6XDkwzXgA44woX/geYKYAsExWbxc=
X-Google-Smtp-Source: ABdhPJxlrVMViBS5W4Flo1xUu4VzGad5gTUjlIjWwN8zZe3lHerlu/y7rTnQ/yJ+rif/QCO7xlgsl+oK7Sj9t9HIZ5I=
X-Received: by 2002:a02:9109:: with SMTP id a9mr22645371jag.93.1618997632864;
 Wed, 21 Apr 2021 02:33:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210421092317.68716-1-amir73il@gmail.com> <20210421092317.68716-3-amir73il@gmail.com>
In-Reply-To: <20210421092317.68716-3-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 21 Apr 2021 12:33:42 +0300
Message-ID: <CAOQ4uxgX+mV+_AbF8Mc1fSPed37ezL_xONbx+BdqoQDKPsG7pw@mail.gmail.com>
Subject: Re: [PATCH 2/2] overlay: Test invalidate of readdir cache
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Apr 21, 2021 at 12:23 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> This is a regression test for kernel commit 65cd913ec9d9
> ("ovl: invalidate readdir cache on changes to dir with origin")
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  tests/overlay/077     | 105 ++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/077.out |   2 +
>  tests/overlay/group   |   1 +
>  3 files changed, 108 insertions(+)
>  create mode 100755 tests/overlay/077
>  create mode 100644 tests/overlay/077.out
>
> diff --git a/tests/overlay/077 b/tests/overlay/077
> new file mode 100755
> index 00000000..e254aec1
> --- /dev/null
> +++ b/tests/overlay/077
> @@ -0,0 +1,105 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2021 CTERA Networks. All Rights Reserved.
> +#
> +# FS QA Test 077
> +#
> +# Test invalidate of readdir cache
> +#
> +# This is a regression test for kernel commit 65cd913ec9d9
> +# ("ovl: invalidate readdir cache on changes to dir with origin")
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1       # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +       cd /
> +       rm -f $tmp.*
> +}
> +
> +# create test directory and test file, mount overlayfs and remove
> +# testfile to create a whiteout in upper dir.
> +create_whiteout()
> +{
> +       local lower=$1
> +       local upper=$2
> +       local work=$3
> +       local file=$4
> +
> +       mkdir -p $lower/testdir
> +       touch $lower/testdir/$file
> +
> +       _overlay_scratch_mount_dirs $lower $upper $work
> +
> +       rm -f $SCRATCH_MNT/testdir/$file
> +
> +       $UMOUNT_PROG $SCRATCH_MNT
> +}
> +

Oops. Unused leftover.
A former merge dir does not need to actually have whiteouts for this test...

Thanks,
Amir.
