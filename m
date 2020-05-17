Return-Path: <SRS0=O/kl=67=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D52C433DF
	for <linux-unionfs@archiver.kernel.org>; Sun, 17 May 2020 08:46:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89DEC206D5
	for <linux-unionfs@archiver.kernel.org>; Sun, 17 May 2020 08:46:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c5D80Rkf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgEQIqN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 17 May 2020 04:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbgEQIqM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 17 May 2020 04:46:12 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B53C061A0C
        for <linux-unionfs@vger.kernel.org>; Sun, 17 May 2020 01:46:12 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id k18so7369038ion.0
        for <linux-unionfs@vger.kernel.org>; Sun, 17 May 2020 01:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VXfWDMoOGstCJTpCZ/k8c2Zvj3bI6hPYO3aN/o7xNAM=;
        b=c5D80RkfjMYEhLkU8Nmwf7x3UQC6LpZLfmfDqFCY8jbDLsvTPl763YQDQAHmD8AhiQ
         +mVrBn10qsm/VJCPPp2Lt77cTfah+fkYQmA4TZf/9gPTOxm8zhiYU/qMX/lMkDX/QNFr
         idovOEK/eO1N62fGFEKlmCY+3afpkI6860s9qYCJfB2RzrlY8E1XXz8B50ozGAjNs1H4
         VSkAAZA8FP1aIzr4IPOZvKCaQ3aMj0WNLPV7rJdd8cTtsVZdycc3YLNxc2Sb4fCv0gZV
         +IMeJyiafR+bmpxZkTie74fta6ROR1IxagBOOBkJdVCHiAo+jcVIIvj4DlA8U2SvXTq7
         dtZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VXfWDMoOGstCJTpCZ/k8c2Zvj3bI6hPYO3aN/o7xNAM=;
        b=VcYColB8ehtIJIFgMRU6I4Do74dLrvmV08GY+IO9Qs6qsW4rFiPyU4U0X9jcOSyw0C
         nZ5O2xCAbbA0Y1b0WV4Nl6rAtTfoHMi/GS+UEeiQs6HiW6ZSQ0lwnV8U14TiQv/kVUtT
         iuj/8zQQWZrU3PHAXLQkG8fD6O1tn63CplvVq8tpQMCikFmN9NFqyv+0qD9PkIzBgHuk
         kPC/SzrAwtg+OD7neIvxgAzPgnWnC4yd++Ft+SbmW6vRiqzWB2O7S8YEdMmgBMxIfEYW
         WdPDLunIw3eNAe37dOAd/oiF386xWSLZJ7L89OIQSll5UBz1hHRUm77QNV3mqx1MngqT
         pShw==
X-Gm-Message-State: AOAM532vTtksjABimN/hS9QGOtQM64uVmj/a2lhS18DB4gCvjhtf2aRW
        MOeCBYWu7Cx3q7IyxSM8W3SDUYjiAhm1BkJ3DZ6HupGK
X-Google-Smtp-Source: ABdhPJzdsgfY/dxB95HjyRWyno/GM62MF86Hq7S/AvIxTV8TI8NizbUma4gzK0IVy5cijRaVniVhD1pK7Lag1N7x/oE=
X-Received: by 2002:a02:b141:: with SMTP id s1mr10400581jah.123.1589705170532;
 Sun, 17 May 2020 01:46:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200415120134.28154-1-amir73il@gmail.com> <20200415120134.28154-3-amir73il@gmail.com>
 <20200415153032.GC239514@redhat.com> <CAOQ4uxhmxxjGGB3bBoK1OmcAWDsoNi3WdORtH7WDLOcp8=sYSQ@mail.gmail.com>
 <20200415194243.GE239514@redhat.com> <CAOQ4uxjZ4Yd3ZWi+Fe64fVkrD=XMDjF1=C=XN_PNdywbGx_gzQ@mail.gmail.com>
 <20200416125807.GB276932@redhat.com> <CAOQ4uxi=mT2JYGSXro5YW8gTE5256cxauBddYe2HXM=ZfZ=+ZA@mail.gmail.com>
 <CAOQ4uxjvtGLn=SvLXy3KU6uKbonBUznL==OjdVVjjB6sM=-mgg@mail.gmail.com>
 <20200420191453.GA21057@redhat.com> <CAOQ4uxjVU6gcQMmyMiBsVV73gik931-7QjAO9TCu+N2ik6109w@mail.gmail.com>
In-Reply-To: <CAOQ4uxjVU6gcQMmyMiBsVV73gik931-7QjAO9TCu+N2ik6109w@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 17 May 2020 11:45:59 +0300
Message-ID: <CAOQ4uxgVnT3ZXZZa4-YktZaRDpU1hHujPoEtZ2vdFmsGxj=66A@mail.gmail.com>
Subject: Re: [PATCH 2/2] Configure custom layers via environment variables
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> >
> > What's most intuitive to me is this.
> >
> > - If user only specifies UNIONMOUNT_BASEDIR, all layers (lower, upper,
> >   work and even mount point) comes from that directory.
>
> OK.
>
> >
> > - If user specifies both UNIONMOUNT_LOWERDIR and UNIONMOUNT_BASEDIR, then
> >   lower layer path comes from UNIONMOUNT_LOWERDIR and rest of the layers
> >   come from UNIONMOUNT_BASEDIR.
>
> DONE.
>
> >
> > - If user specifies UNIONMOUNT_MNTPOINT, it is used as overlay mount
> >   point. Otherwise one is selected from UNIONMOUNT_BASEDIR if user
> >   specified one. Otherwise "/mnt" is the default.
> >
>
> OK.
>

Vivek,

I finally got around to implementing your suggestion (see [1]).

Quoting from README:

     When user provides UNIONMOUNT_LOWERDIR:

     1) Path should be an existing directory whose content will be deleted.
     2) Path is assumed to be on a different filesystem than base dir, so
        --samefs setup is not supported.

     When user provides UNIONMOUNT_BASEDIR:

     1) Path should be an existing directory whose content will be deleted.
     2) If UNIONMOUNT_MNTPOINT is not provided, the overlay mount point will
        be created under base dir.
     3) If UNIONMOUNT_LOWERDIR is not provided, the lower layer dir will be
        created under base dir.
     4) If UNIONMOUNT_LOWERDIR is not provided, the test setup defaults to
        --samefs (i.e. lower and upper are on the same base fs).  However,
        if --maxfs=<M> is specified, a tmpfs instance will be created for
        the lower layer dir.
----

I realize this last item (4) is a bit tricky.
Let me know if you think it needs further clarification.

Thanks,
Amir.


[1] https://github.com/amir73il/unionmount-testsuite/commits/envvars
