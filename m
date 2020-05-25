Return-Path: <SRS0=8c8p=7H=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20CC2C433DF
	for <linux-unionfs@archiver.kernel.org>; Mon, 25 May 2020 03:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F10442075F
	for <linux-unionfs@archiver.kernel.org>; Mon, 25 May 2020 03:40:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FecqcTZE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388450AbgEYDkT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 24 May 2020 23:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388397AbgEYDkT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 24 May 2020 23:40:19 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187CBC061A0E;
        Sun, 24 May 2020 20:40:18 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id d5so7888925ios.9;
        Sun, 24 May 2020 20:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q3fVIOV88vAAmRQiqY/WHaIRKT3gx5qj8oC292P1Pb0=;
        b=FecqcTZEcrKEg9mY9a5pgsumQR5db3xM9IGAKlltUq2KUoi/4HVayZIxmZhKUJA0Yz
         T9oaiaEupb8Ex6z5djqTSWual+LJ5g3ZSd45BTps7Qonq6TxmSqVfjMRhY3GNsiAUtjB
         neM99NSAiw3HUGosKt5AdwDFtg1bcLISYT42Kjsl4PwuaXsSISNVM9+e2TbvN8lGPmCH
         IfokgOK6YdW+N3aGwOJ4WG0vnOAsDALGJyPFyy6ZJIG5I7dt7UbyRHDhzIpKnRJaPML1
         sUw9v6Imd0X39jWIp0CN8U2pL+EmuoyXpcifh5BErgQ8HqqunFY/yhUQEUA8LGqFnMn5
         HXnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q3fVIOV88vAAmRQiqY/WHaIRKT3gx5qj8oC292P1Pb0=;
        b=ntOisCg+PSrhlhkXaZk4sMyQiyrZto7TEmn5tYgqqrm9h4xCgiMzkFHoeEnLEnqjkU
         kTWYBfkKJk00n3DD1Hov2Yt4n/PRHRmcvUyaxEsxfpmkvZmWhuEq9OJ1SLZimr0X77R3
         SqzFb3mJCbvLHONXHBEZRDDO0zbaDBK9jMNmbu7dX8EUT7M3DFeRwAqvKLWR7C+BeawU
         UgWOudj3/cny01kIyrSRleOLbb6LOyRbGblY+TRLgDIUgwa4uV6UsqOQqhxXubo/2HsM
         x1kMd45k8/5nyvA+0z3mio1x/ShKsScti5dqPkOrWwxFhgdi3Srwy9ayjRcdYJ99I4I3
         vPbg==
X-Gm-Message-State: AOAM532pe/PBlvtnK5OuJOykzG4qdVQdODUBQHLjcNb8KEH5vQRrzKIb
        rrwqamQ0uFpDD4YQ9VrhHe9RjgkuVjbHmG/rh8cXpYBR
X-Google-Smtp-Source: ABdhPJyOAnkPYaO0kkeSKd65M7qyc7BlMwrRiry8nlekuYuWcXgkU5jPowu48NRsbFqLsTXrHyda0j7oFRw230tZYhA=
X-Received: by 2002:a02:85a5:: with SMTP id d34mr9641881jai.123.1590378016494;
 Sun, 24 May 2020 20:40:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200519080929.18030-1-cgxu519@mykernel.net> <CAL3q7H4aObeXLuhv05AOyrLU1B_3M81y_ddH1cY0pAEEEO+Law@mail.gmail.com>
 <69537fa5-ebd7-c233-0741-5fc4f9798abd@mykernel.net>
In-Reply-To: <69537fa5-ebd7-c233-0741-5fc4f9798abd@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 25 May 2020 06:40:05 +0300
Message-ID: <CAOQ4uxhQ0kYkPAfarc5BT6hvwGiqGcJd821xcj7eG7mVR1W0QQ@mail.gmail.com>
Subject: Re: [PATCH v2] generic/597: test data integrity for rdonly remount
To:     cgxu <cgxu519@mykernel.net>
Cc:     Filipe Manana <fdmanana@gmail.com>, Eryu Guan <guaneryu@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, May 25, 2020 at 5:25 AM cgxu <cgxu519@mykernel.net> wrote:
>
> On 5/20/20 11:09 PM, Filipe Manana wrote:
> > On Tue, May 19, 2020 at 9:10 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
> >>
> >> This test checks data integrity when remounting from
> >> rw to ro mode.
> >>
> >> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> >> ---
> >> v1->v2:
> >> - Add to shutdown greoup.
> >> - Change case number to 597
> >>
> >>   tests/generic/597     | 54 +++++++++++++++++++++++++++++++++++++++++++
> >>   tests/generic/597.out |  2 ++
> >>   tests/generic/group   |  1 +
> >>   3 files changed, 57 insertions(+)
> >>   create mode 100755 tests/generic/597
> >>   create mode 100644 tests/generic/597.out
> >>
> >> diff --git a/tests/generic/597 b/tests/generic/597
> >> new file mode 100755
> >> index 00000000..d96e750b
> >> --- /dev/null
> >> +++ b/tests/generic/597
> >> @@ -0,0 +1,54 @@
> >> +#! /bin/bash
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +# Copyright (c) 2020 Chengguang Xu <cgxu519@mykernel.net>.
> >> +# All Rights Reserved.
> >> +#
> >> +# FS QA Test 597
> >> +#
> >> +# Test data integrity for ro remount.
> >> +#
> >> +seq=`basename $0`
> >> +seqres=$RESULT_DIR/$seq
> >> +echo "QA output created by $seq"
> >> +
> >> +here=`pwd`
> >> +tmp=/tmp/$$
> >> +status=0
> >> +trap "_cleanup; exit \$status" 0 1 2 3 15
> >> +
> >> +_cleanup()
> >> +{
> >> +       cd /
> >> +       rm -f $tmp.*
> >> +}
> >> +
> >> +# get standard environment, filters and checks
> >> +. ./common/rc
> >> +. ./common/filter
> >> +
> >> +# remove previous $seqres.full before test
> >> +rm -f $seqres.full
> >> +
> >> +# real QA test starts here
> >> +_supported_fs generic
> >> +_supported_os Linux
> >> +_require_fssum
> >> +_require_scratch
> >> +_require_scratch_shutdown
> >
> > Couldn't the test be using dm's flakey instead of shutdown?
> > As shutdown is not implemented by all filesystems (btrfs for example),
> > it would allow more coverage.
> >
>
> Thanks for the suggestion, I tried with dmflakey but unfortunately it
> could not work on overlayfs, a possible solution is that move current
> test case to overlay specific directory and create new test case with
> dmflakey for generic purpose.
>

Or you can create an abstraction for shutdown/dmflakey, because
this test doesn't care which one you use:

_require_scratch_drop
_init_scratch_drop
_mount_scratch_drop
_scratch_drop_and_remount
_cleanup_scratch_drop

But IMO, this could also be done after merging test to increase test
coverage.

Thanks,
Amir.
