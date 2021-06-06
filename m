Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E6ACC4743D
	for <linux-unionfs@archiver.kernel.org>; Sun,  6 Jun 2021 16:00:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 072406142B
	for <linux-unionfs@archiver.kernel.org>; Sun,  6 Jun 2021 16:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhFFQCc (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 6 Jun 2021 12:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhFFQCb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 6 Jun 2021 12:02:31 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90484C061766;
        Sun,  6 Jun 2021 09:00:28 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id a8so12616172ilv.9;
        Sun, 06 Jun 2021 09:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FNu0XD+49lQmNxkW8RYXch40uXb65JQSTwY5Xd5wYus=;
        b=iEFxt4CZB9fxgqCBqGeYe1W8RfVE1tjeSoRCFsY+/pzWMNZ7lnUzEfqaMHjzrGsUUk
         0nj80/Qvux+RleR7V9WdiFcu7oaEUgmzeq9fmoRToVOv5LWo9MQZFgIiQEf6x3oY349g
         q6CdXI/hxunJFI8MdYFrunu3ybFmw2hFU93htnTvwthbAMmKXghXb6tU5ngs2sdUDmoK
         pjoeaoC7cscECuISXLy0xo+CTal5Vy4YtUAguouJZZ6UeC899GKr7kaJSOsa73ktssuq
         nc5ilMsr2hMSqvUoqW2p+3rmLMcOr6bVaiuu8ljCIlhDmJ03OX6QFtkpMh0yd6InhzfO
         d0Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FNu0XD+49lQmNxkW8RYXch40uXb65JQSTwY5Xd5wYus=;
        b=MrDxEYQa3wz76Xk8LSGO7aerIxyCY+EVRAetoO7WLMfk2TfvjEmQl4c7Dx+/TkBdrb
         MI6vRpmT1bktCfci3HxPXCXTX2ghwYMyK4dVkkWpLbQS/g0FPkc9Vx1VPDUiv3BKdenJ
         BXWgqcDnvZqv63YVSdA7Wzuc+nNBi3WmkMHk3wtfbLWP2mXyhv71grTBlPrkbOuT6Vd+
         PepXRRP0HTEcVsUikIcifiGUl1ODEIQgG8poX9tHx1e+h7RnhH//EQdmYi9jwhuRowt7
         OfnagCQYrqagdawQClMMBvGvSXS8/saRyaVeCuxZmGM2RN6DnFTVsg1eZJhCd7cMPBth
         SEYg==
X-Gm-Message-State: AOAM531Fcjfhlpw+ezTRiSXGaMErhdhIf+I3oTDXL2gUtM/lNFqJAVC0
        pVYiTLFtC93536rYH/CgPTmQenqS9n5ZXHUrXg0=
X-Google-Smtp-Source: ABdhPJxDRxpinwyESvId2N9x+xJfoSIW79GKlbkQnAcleZKg8T7Cm9MSSndMBiJ8RyZ1p7JU4JRhFHRFQ18AfZRXpb0=
X-Received: by 2002:a05:6e02:4e:: with SMTP id i14mr11576438ilr.72.1622995227020;
 Sun, 06 Jun 2021 09:00:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210606151811.420788-1-amir73il@gmail.com>
In-Reply-To: <20210606151811.420788-1-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 6 Jun 2021 19:00:16 +0300
Message-ID: <CAOQ4uxj=ztE5kyE62dS=UrLzt--E7Gwucab_r+k4Jgg+nEpt1g@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Fixes to overlayfs immutable files tests
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Jun 6, 2021 at 6:18 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Eryu,
>
> Test overlay/075 was written and merged to track a known overlayfs issue
> which exists in current upstream.
>
> The introduction of fileattr operations in kernel v5.13-rc1 by Miklos
> has paved the way for the fix patch that I recently posted [1].
>
> Patch #1 fixes a test bug that was hiding behind the known issue in
> upstream kernel.

Oh, you already merged this one. Great.
There is no change from v1 to v2, so you may ignore it and review
patch #2 for next week.

Thanks,
Amir.

>
> Patch #2 add test coverage to part of the kernel fix patch that is not
> covered by the current test.
>
> Thanks,
> Amir.
>
> [1] https://lore.kernel.org/linux-unionfs/20210606144641.419138-1-amir73il@gmail.com/
>
> Amir Goldstein (2):
>   overlay/075: fix wrong invocation of t_immutable
>   overlay/075: add test coverage for clearing immutable/append-only
>     flags
>
>  tests/overlay/075 | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
>
> --
> 2.31.1
>
