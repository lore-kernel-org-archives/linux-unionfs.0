Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A15E2C433EF
	for <linux-unionfs@archiver.kernel.org>; Sat, 26 Feb 2022 18:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbiBZSpT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 26 Feb 2022 13:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbiBZSpT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 26 Feb 2022 13:45:19 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AEF1E6EB4;
        Sat, 26 Feb 2022 10:44:44 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id d7so6940740ilf.8;
        Sat, 26 Feb 2022 10:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=veVD4InLLdEeyOHVtYYrTzN/uzgqlu391hrjbiGqkKk=;
        b=M0LlF9U2uwglFn8sR6OOp00cGfJJPtmnKi2R5r0Rg7zD8ey3tYY5NZw3dqtAI3qPkx
         vKovA94Li5cc0mBP8uWcub1vdFTGu+wZO96UMgoJkNJWl/OkKo2FKvZiO0OeRPTVdY+r
         bfRjutsOP4ql1EZACpA7GWV0RSdN+mYf/IRc6zlIeYAnuLOcJDbw6wOuHDsIY1ootuAj
         suUWs5mfUUj9EuRSHr0bb8DyL44CHImrdQn8pkw26oez7KdKlkd3ind8hJteX4svAwTY
         cvzaSvtDmH9wzqPHo2r+rCkdLx2RaMPa3aLQl0xM3VxABkwrKIfwCPrcm1iJHM0YrMwO
         6eJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=veVD4InLLdEeyOHVtYYrTzN/uzgqlu391hrjbiGqkKk=;
        b=6p/TuQsWIawHQ7IHTxka1C9UBROBsEiRM1i6F5jwqkMnzp0Z5Q3CsUeyDvaCgy5Ab6
         0ZNqfqUBVlXEgjgaJgyAU3ln7H9q9Rhmnza9Vo+lsK2lXuuFjzBgKrDzMR6aUhhQO+nY
         3zgGDHZkvndv12DmIMTj9HJOC1oAN8gglyvDMTXGBf/P1Z1mlQgczLsMTF9vSTU0hIja
         v3CORQPnsEnByodHXPrpJD3Gl2wsNfdkVEfxeB2k8uW3QI1Nh+0AisbVJ1FRklqfOH8T
         XUawtxjCvbRtCC2VKQVwwVTV8tBOdECxMF07mGmAetOkdJPkEplEpDVo6EFyEJ7xrkF+
         urgg==
X-Gm-Message-State: AOAM5317IXrakp11t3NkgT2xAJn8EElvoC3oVdCFmb1XtNN4YZ8PZxu4
        KF9W1ljm8aS5tYSBPzMBQgoVhbAn0/SZDQGpNCA=
X-Google-Smtp-Source: ABdhPJyfM8qcnwUwFPuBOWxf/nhdzSze6OhLMSC5D5CKuxNSnob61/Qq/zKpXX0h8tSuMp8c0doNFagZbAp0QYLfGHg=
X-Received: by 2002:a05:6e02:214a:b0:2bf:a442:cbff with SMTP id
 d10-20020a056e02214a00b002bfa442cbffmr11987525ilv.107.1645901083747; Sat, 26
 Feb 2022 10:44:43 -0800 (PST)
MIME-Version: 1.0
References: <20220226152520.289069-1-cgxu519@mykernel.net>
In-Reply-To: <20220226152520.289069-1-cgxu519@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 26 Feb 2022 20:44:32 +0200
Message-ID: <CAOQ4uxjs83s7YdMFLTYOA2BOODme4XSymQHzDQ4DEgG4zQ7ykw@mail.gmail.com>
Subject: Re: [PATCH] overlay/079: test for parent directory consistancy in copy-up
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Feb 26, 2022 at 8:15 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Make sure the change for parent direcotry get synced in copy-up.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  tests/overlay/079     | 50 +++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/079.out |  2 ++
>  2 files changed, 52 insertions(+)
>  create mode 100755 tests/overlay/079
>  create mode 100644 tests/overlay/079.out
>
> diff --git a/tests/overlay/079 b/tests/overlay/079
> new file mode 100755
> index 00000000..c542cfc9
> --- /dev/null
> +++ b/tests/overlay/079
> @@ -0,0 +1,50 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Chengguang Xu <cgxu519@mykernel.net>.
> +# All Rights Reserved.
> +#
> +# FS QA Test 079
> +#
> +# Test copy up consistency for parent directory.
> +#
> +. ./common/preamble
> +_begin_fstest copyup quick
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs overlay
> +_require_scratch
> +#_require_command "$FLOCK_PROG" flock
> +_require_scratch_shutdown
> +
> +
> +# Remove all files from previous tests
> +_scratch_mkfs
> +
> +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> +upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> +mkdir -p $lowerdir/foo_dir
> +echo a > /tmp/foo
> +echo a > $lowerdir/foo_dir/foo
> +
> +# Mounting overlay
> +_scratch_mount
> +
> +touch $SCRATCH_MNT/foo_dir/foo
> +_scratch_shutdown
> +_scratch_cycle_mount
> +
> +echo "Silence is golden"
> +diff /tmp/foo $upperdir/foo_dir/foo
> +

NACK.

Absolutely no reason for us to guarantee that file is copied up
if the user did not request explicit sync on the file or the directory.

Really, what is driving you to make this change and test?
If it is a real world use case, then please encode the real use case
in the form of a test.

Thanks,
Amir.
