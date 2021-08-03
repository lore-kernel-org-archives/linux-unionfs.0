Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3112FC432BE
	for <linux-unionfs@archiver.kernel.org>; Tue,  3 Aug 2021 07:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B0616056B
	for <linux-unionfs@archiver.kernel.org>; Tue,  3 Aug 2021 07:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbhHCHV0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 3 Aug 2021 03:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbhHCHVZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 3 Aug 2021 03:21:25 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390D4C06175F;
        Tue,  3 Aug 2021 00:21:14 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id y1so37932iod.10;
        Tue, 03 Aug 2021 00:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aKbVu1RkR2/sVcH5KhC6L5RB83nrqR872+rjX/KtzRM=;
        b=QRfp3WGZe8RSlY/qW7bVC+8tfyBPOTIZ4W4BTbyIkg5fDd01dGF2bcEJF+AWNXF0DN
         YFLL6i/ik2cxAhSGlupLY0UbeWIxnvixGqM4NcjAG7WFee98UcXnL+zS+tOJ2MV574iM
         ci/yBlXlxt2iiVfIrFyKlwczf7JUPF7s2/vKt3MN3lO3+qncZ4Vy8c0wEKQ00OWgRHqv
         Ex6yzb/jPxRoSarIDf7AgbtPVU+b5BAT/JmfEh9Vg0pnM2OVzFLRgfM67PhyrzIM52B0
         vSMlylKa9Fbtf65o3UxeNr6aKfLUCHzT7Uim0T5Y+DGSlXbR6/nZskXl+lqtb9WfNQ1Q
         iyVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aKbVu1RkR2/sVcH5KhC6L5RB83nrqR872+rjX/KtzRM=;
        b=SkHRWIVO0kuwDX9dYg3DgZpV3uye7WbVmjrex9B60cwNdcCYSu+h0yOuBbD6tDKcSK
         DiWIKs3PFetVFgjDKYvGM9WN+Vv1hbj594Fo1wLBsRXVu6IcthpfmGdi0RW1kSqlw0iG
         E+VxX9Whxh/RM6TSxrk8rT/WyuUzo7QZH+GifcObq34vUxFr4H9A0s7t1iU2mK9Itp3x
         +mEOYTStN/tRhwptZ9wITWHbw+6rsxBHRWuerWYXfs6cPbVtleAWv2YwmdI6ZZmD8Hfr
         XW0sHVhPUIbyrBTFbLsBAlXLE9w1oBSzR9ZsW3dZ/5QhbCRukIuXZ4PWCrZ2soDnXkPo
         /Ecg==
X-Gm-Message-State: AOAM5305ueG9mN0BQE2IeXhSKKpztWnQcMzcux8HfxHw+M3bBCL0HpT8
        VProHNEk3BKRPwknRqRDKpgPozRwwJsIPD/AkhTCGtxmPxc=
X-Google-Smtp-Source: ABdhPJxGdmuFILTa2kbk3dBI8BQGMIEaEwkmXdLGOzYYwks3QuFhkBdcfXdWP7VJeAIbTfI2XkEu41uDRn43/uobO+Q=
X-Received: by 2002:a5d:8b03:: with SMTP id k3mr187018ion.203.1627975273673;
 Tue, 03 Aug 2021 00:21:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210722164634.394499-1-amir73il@gmail.com> <20210802230727.GC3601425@magnolia>
In-Reply-To: <20210802230727.GC3601425@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 3 Aug 2021 10:21:02 +0300
Message-ID: <CAOQ4uxgC6R9rAEM8YfJ83SN2UN_Z9gKY3_CTdDaYayC7SoNe4Q@mail.gmail.com>
Subject: Re: [PATCH] overlay: add test for copy up of lower file attributes
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Aug 3, 2021 at 2:07 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Thu, Jul 22, 2021 at 07:46:34PM +0300, Amir Goldstein wrote:
> > Overlayfs copies up a subset of lower file attributes since kernel
> > commits:
> > 173ff5c9ec37 ("ovl: consistent behavior for immutable/append-only inodes")
> > 2e3f6e87c2b0 ("ovl: copy up sync/noatime fileattr flags")
> >
> > This test verifies this functionality works correctly and that it
> > survives power failure and/or mount cycle.
>
> Just out of curiosity -- is this supposed to succeed with a 5.14-rc4
> kernel?

No. The documented fix commits are in linux-next.
Looks like they are heading for 5.15-rc1.

> I noticed a massive regression with this week's fstests,
> probably because something didn't get cleaned up properly:
>
> --- overlay/078.out
> +++ overlay/078.out.bad
> @@ -1,2 +1,17 @@
>  QA output created by 078
>  Silence is golden
> +Before copy up: -------A-------------- /opt/ovl-mnt/testfile
> +After  copy up: ---------------------- /opt/ovl-mnt/testfile
> +Before copy up: -------A-------------- /opt/ovl-mnt/testfile
> +After  copy up: ---------------------- /opt/ovl-mnt/testfile
> +Before copy up: --S----A-------------- /opt/ovl-mnt/testfile
> +After  copy up: ---------------------- /opt/ovl-mnt/testfile
> +Before copy up: --S----A-------------- /opt/ovl-mnt/testfile
> +After  copy up: ---------------------- /opt/ovl-mnt/testfile
> +Before copy up: --S--a-A-------------- /opt/ovl-mnt/testfile
> +After  copy up: ---------------------- /opt/ovl-mnt/testfile
> +Before copy up: --S--a-A-------------- /opt/ovl-mnt/testfile
> +After  copy up: ---------------------- /opt/ovl-mnt/testfile
> +rm: cannot remove '/opt/ovl-upper/testfile': Operation not permitted
> +rm: cannot remove
> '/opt/ovl-work/index/00fb2100812f1a30dc474847dbad5281308293ece9030e00020000000054816fd1':

I'm curious, are you running with non-default mount/config options
on purpose? i.e. index=on or nfs_export=on?

> Operation not permitted
> +Write unexpectedly returned 0 for file with attribute 'i'

Oops, sorry. The problem is even sooner than _cleanup().
I hadn't noticed it because the head snippet of 078.out.bad was expected
and I did not look past it.

>
> and then the tests after it (e.g. generic/030) fail with:
>
> +mount: /opt/ovl-mnt: mount(2) system call failed: Stale file handle.
> +mount failed
> +(see /var/tmp/fstests/generic/030.full for details)
>

And I hadn't noticed that because overlay/078 is the last test to reuse
/opt/ovl-upper/ and kvm-xfstests zaps the base fs before every run.

Posted a fix.
Sorry for the trouble.

Thanks,
Amir.
