Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C85C433ED
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Apr 2021 06:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEC25613B0
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Apr 2021 06:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhDVGX6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 22 Apr 2021 02:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbhDVGX6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Apr 2021 02:23:58 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB71C06174A;
        Wed, 21 Apr 2021 23:23:23 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id h141so389062iof.2;
        Wed, 21 Apr 2021 23:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5zV5/GaIVqMX48CMASJpJSc03biltSZDPYPRc41aOkQ=;
        b=FIqatK8YezDGE3BeGToPITkn6jo83dBFosvIkl7xWM4Qe/yU1xyXjWF0ZIeKXmaR6w
         Qc9yTVDAMp3PEiy733npT/MesaxBZIO+KgGdxo2WTIPITG9WINy2Rmopz3P/bO7+M4i6
         djDmgCkUQra8LsoFc5AJHT7N3NPHjNY9MkhsoRtAqyZsm8uet0EDsZ0oPjaHsmWSRTtd
         9ENhg5ecJaQa9wb9nt0vFs2C76wOyaYw67x2h9bx5exXURNV1aRWFcsSkGjIdezo7S3S
         A2OzUfuvEaeE+mDK2msBXNtn4CqjdRrRsjtAPz7QR4zQb6ghV+fkCVnLAucHbM1PW43p
         y8cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5zV5/GaIVqMX48CMASJpJSc03biltSZDPYPRc41aOkQ=;
        b=dmCH6SeHk/ciB09IblvkRfkcZM2nbjOSh2yb2fq0I1WqOd0RhJlMmTgv0VNjo8LfOh
         kDq9FlISQAsXOkhgEiva996/lkpolLQUlSBxMgOSbzOhCj+TZAc+DTHy3qmehoxQvABU
         pbUfTvVkP4pEltEG9NHnmpehkKhIqFQVPhAA2JIDofCQC95zafDQCJ+6WwXt7EF+BVuC
         ebEF6t0QQLw+qY0RBuvSuQnYln49smdqnRDQ0V78hziX/Jl5kG0ktm/WO78gIh/2ZpsG
         5NzBtubB5FGaMYbBUgncfKypf01x1GFJ/yG/GJj6FEmZICofHsbUXV1dH95tDtaY0Fmc
         UnLQ==
X-Gm-Message-State: AOAM531ZDkP1MZDOj6iREQUPOGYG4afJjt/qNfXb0pJt41NByNfacF1D
        I1p/Ma2fMcNe2rIO8zxWbzhL+QWm0nxE1t77itY=
X-Google-Smtp-Source: ABdhPJx4oy4DqE7tiiOnGsLkMiqHr+KaqiO9SK8IQ5ZYYG5PDDVJcsGA1qjOy8QWbTGSN4n2qReMBsURBj7kNK+AQuw=
X-Received: by 2002:a05:6638:2505:: with SMTP id v5mr1856139jat.120.1619072603091;
 Wed, 21 Apr 2021 23:23:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210421092317.68716-1-amir73il@gmail.com> <20210421092317.68716-3-amir73il@gmail.com>
 <CAOQ4uxgX+mV+_AbF8Mc1fSPed37ezL_xONbx+BdqoQDKPsG7pw@mail.gmail.com>
In-Reply-To: <CAOQ4uxgX+mV+_AbF8Mc1fSPed37ezL_xONbx+BdqoQDKPsG7pw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 22 Apr 2021 09:23:12 +0300
Message-ID: <CAOQ4uxh2AQnyxqwLW9gcE818OdiP8yMsmeVmO2KjSESZ-fwBLA@mail.gmail.com>
Subject: Re: [PATCH 2/2] overlay: Test invalidate of readdir cache
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Apr 21, 2021 at 12:33 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Wed, Apr 21, 2021 at 12:23 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > This is a regression test for kernel commit 65cd913ec9d9
> > ("ovl: invalidate readdir cache on changes to dir with origin")
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  tests/overlay/077     | 105 ++++++++++++++++++++++++++++++++++++++++++
> >  tests/overlay/077.out |   2 +
> >  tests/overlay/group   |   1 +
> >  3 files changed, 108 insertions(+)
> >  create mode 100755 tests/overlay/077
> >  create mode 100644 tests/overlay/077.out
> >
> > diff --git a/tests/overlay/077 b/tests/overlay/077
> > new file mode 100755
> > index 00000000..e254aec1
> > --- /dev/null
> > +++ b/tests/overlay/077
> > @@ -0,0 +1,105 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (C) 2021 CTERA Networks. All Rights Reserved.
> > +#
> > +# FS QA Test 077
> > +#
> > +# Test invalidate of readdir cache
> > +#
> > +# This is a regression test for kernel commit 65cd913ec9d9
> > +# ("ovl: invalidate readdir cache on changes to dir with origin")
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1       # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +       cd /
> > +       rm -f $tmp.*
> > +}
> > +
> > +# create test directory and test file, mount overlayfs and remove
> > +# testfile to create a whiteout in upper dir.
> > +create_whiteout()
> > +{
> > +       local lower=$1
> > +       local upper=$2
> > +       local work=$3
> > +       local file=$4
> > +
> > +       mkdir -p $lower/testdir
> > +       touch $lower/testdir/$file
> > +
> > +       _overlay_scratch_mount_dirs $lower $upper $work
> > +
> > +       rm -f $SCRATCH_MNT/testdir/$file
> > +
> > +       $UMOUNT_PROG $SCRATCH_MNT
> > +}
> > +
>
> Oops. Unused leftover.
> A former merge dir does not need to actually have whiteouts for this test...
>

But it would be better for test coverage if the merge dir had copied up
files on first readdir (making it "impure").

And I will also add the "upper impure" test case in V2 posting.

Thanks,
Amir.
