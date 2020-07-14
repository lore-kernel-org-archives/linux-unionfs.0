Return-Path: <SRS0=Lx5L=AZ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDE6C433DF
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 14:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC0A22250F
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 14:23:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="SUZvCmHq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbgGNOXQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 10:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgGNOXP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Jul 2020 10:23:15 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B72C061755
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 07:23:15 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id br7so8314513ejb.5
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 07:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NS+WQFOCK1Kgnzgo0UNIZPOF+spKpj5hfdhmLHqMyU0=;
        b=SUZvCmHqmIUTKGCAd9zce4Q88a1dF0BGLxlt2IwR2XdeoA6nc9v6e2GUkl31386H5W
         buUV4SkElbYHPGi0qb0ACf/4SGykzDn41mTUF97XWMI0h8iI85mEZMSEwjxYvAHbgRRl
         lhxN64FcWKy1hhkJ2K4IsSRR1L2H20lTwa21E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NS+WQFOCK1Kgnzgo0UNIZPOF+spKpj5hfdhmLHqMyU0=;
        b=WNUPHXK6kR7BlQrMZxLpUwaVFa7rKjGpTy9qNf27DaSxP3AukNdv8CtAuDukd4Y8Dm
         fUGAKKxUuHFpe+ZBX+BOFnfTbKHhtA0XNDCRS6J9I6PqSoeww1PJwEIIi9/QB6EMZm6s
         QlQA1xFpVyE++3t67Uy/Xo2pFVyuIWa8j7NrXbEA7yCOd63iWkhLvqP210PcsoYUuyBX
         tWiEyEOFNrKAOKJAKqmn3iHMrltiokBEWw+6O+0R7zrjernCupNHnS873z5JKJRC/c+u
         E4qPF3ITlvsvoP6qqidsr2WvLrupeeW2uK3dcdJ8Bsm9ytgvbXeu84tpcHuqkR/y1aJJ
         Sc6g==
X-Gm-Message-State: AOAM531vArCU7lhwvKKNXHwJSXkrcHgN9rR2Tf4IMPDZFxMSc3l1S9Nj
        Th2BSuksCTi3nCpnFaipXtHAunv2Wk7blbimE8X+TA==
X-Google-Smtp-Source: ABdhPJx6a7UmNB66OK60tzIunB0oX2ExPH4E4V27yHo+nkB4kk9fwGhC/yoZdT9MwKSaysmefAYDF5kwuwuifNYHWxg=
X-Received: by 2002:a17:906:4f09:: with SMTP id t9mr4697558eju.110.1594736594185;
 Tue, 14 Jul 2020 07:23:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200621063759.15497-1-amir73il@gmail.com>
In-Reply-To: <20200621063759.15497-1-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 14 Jul 2020 16:23:03 +0200
Message-ID: <CAJfpegtfF-71Fucm1ZCZF96YJ6ntfc4Q+VRY45_a0iBpk6mSLw@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix oops in ovl_indexdir_cleanup() with nfs_export=on
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Jun 21, 2020 at 8:38 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Mounting with nfs_export=on, xfstests overlay/031 triggers a kernel panic
> since v5.8-rc1 overlayfs updates.
>
>  overlayfs: orphan index entry (index/00fb1..., ftype=4000, nlink=2)
>  BUG: kernel NULL pointer dereference, address: 0000000000000030
>  RIP: 0010:ovl_cleanup_and_whiteout+0x28/0x220 [overlay]
>
> Bisect point at commit c21c839b8448 ("ovl: whiteout inode sharing")
>
> Minimal reproducer:
> --------------------------------------------------
> rm -rf l u w m
> mkdir -p l u w m
> mkdir -p l/testdir
> touch l/testdir/testfile
> mount -t overlay -o lowerdir=l,upperdir=u,workdir=w,nfs_export=on overlay m
> echo 1 > m/testdir/testfile
> umount m
> rm -rf u/testdir
> mount -t overlay -o lowerdir=l,upperdir=u,workdir=w,nfs_export=on overlay m
> umount m
> --------------------------------------------------
>
> When mount with nfs_export=on, and fail to verify an orphan index, we're
> cleaning this index from indexdir by calling ovl_cleanup_and_whiteout().
> This dereferences ofs->workdir, that was earlier set to NULL.
>
> The design was that ovl->workdir will point at ovl->indexdir, but we are
> assigning ofs->indexdir to ofs->workdir only after ovl_indexdir_cleanup().
> There is no reason not to do it sooner, because once we get success from
> ofs->indexdir = ovl_workdir_create(... there is no turning back.
>
> Reported-and-tested-by: Murphy Zhou <jencce.kernel@gmail.com>
> Fixes: commit c21c839b8448 ("ovl: whiteout inode sharing")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>


Thanks, applied.

Miklos
