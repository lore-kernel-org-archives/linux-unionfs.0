Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0497BC4361B
	for <linux-unionfs@archiver.kernel.org>; Tue, 15 Dec 2020 15:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A13B4224B8
	for <linux-unionfs@archiver.kernel.org>; Tue, 15 Dec 2020 15:33:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgLOPcz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 15 Dec 2020 10:32:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728054AbgLOPcy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 15 Dec 2020 10:32:54 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426A4C06179C
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Dec 2020 07:32:14 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id et9so3427739qvb.10
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Dec 2020 07:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:subject:in-reply-to:references;
        bh=0ftWH5Evu+DAHTCXgUl7EOqkd7cKu/FA4LufcysD1g8=;
        b=PRtIAKXiAuJ1pQ3+x4OKqjE7oern87M44VZsyQkojZJgTyewRPsHeGEn6MIbTE9SmD
         7VPxiCpECOffyrX+ZEkfItm4MRcgzkoa6wdOb+k1Jd2hrp3dfzdSz1y/4s4V7CCLAiJC
         se5HRWUcoJtZniTToRsNZNCnjmEMjiv9e3TUR85Xsp/3ZPf64nvLXXbvufps2ukp2rI7
         AkQkZXij+Bwr+1bxhTOx8trCz5T4DVf5r1y/9wQalw28J8C9dT5lpCC/0QrYfF/1h1Im
         QjCiANIJ3TWgV4BTAKTIrwbPxDjGjbL1If+6aEb3eXJ1UJ7UFTgSq8atyY822A0EAdsB
         dteA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:subject:in-reply-to
         :references;
        bh=0ftWH5Evu+DAHTCXgUl7EOqkd7cKu/FA4LufcysD1g8=;
        b=VzPrnxFKtikRI+YD6QWj7TAkukXPxQWZS8b8ErE/BXlR4xv/V847xxrYYBE39nylHH
         o2icD9MxFV/mV2T0eAUKLeizq/un59KgDMrrXiYMrxierJxiHRx8R8NDtEy3PSyHdDBY
         4ToHg3P+h+cIHRy720t725PVx7MKTHJMGp1LjHCCPSCbkXTv62o9yKjhk4+bJNAXMFHC
         05LiFJrwu5eq+Ws+BzVLg7Lcwdad8NF819kzkyO/AytzJvamFXK4ip4MUi42eqGet9rs
         row/JEVsbtOK+x4qKz8jjyfzeQskB2eZTHAQGswRj2C9SIgXbiJ+ziHTVMNcZwS0LtB1
         rtAw==
X-Gm-Message-State: AOAM531r4QZiDIgDHs4OLm/9l0uEbAyNxalG9S4FGGmxnXopm2tZlOl5
        TwbwCItLx5ThHYD8HhSZVT0=
X-Google-Smtp-Source: ABdhPJwhuEsW/9odI9IWql7UOtVcfrF3+w/o7w7mUrbAPtlARUTy+JFeimbhY0GifMtG4cFJhzyKUg==
X-Received: by 2002:a0c:9e25:: with SMTP id p37mr18170035qve.54.1608046333291;
        Tue, 15 Dec 2020 07:32:13 -0800 (PST)
Received: from aldarion (pool-74-97-22-49.prvdri.fios.verizon.net. [74.97.22.49])
        by smtp.gmail.com with ESMTPSA id x28sm16416445qtv.8.2020.12.15.07.32.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Dec 2020 07:32:12 -0800 (PST)
Date:   Tue, 15 Dec 2020 10:32:11 -0500
Message-Id: <2n1rfrf5l0.fsf@aldarion.sourceruckus.org>
From:   Michael D Labriola <michael.d.labriola@gmail.com>
To:     linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
        Michael D Labriola <michael.d.labriola@gmail.com>
Subject: Re: failed open: No data available
In-Reply-To: <2nv9d47zt7.fsf@aldarion.sourceruckus.org>
References: <2nv9d47zt7.fsf@aldarion.sourceruckus.org>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Dec 14, 2020 at 6:06 PM Michael D Labriola <michael.d.labriola@gmail.com> wrote:
>
> I'm sporatically getting "no data available" as a reason to fail to
> open files on an overlay mount.  Most obvious is during ln of backup
> file during apt install.  Only seems to happen on copy_up from lower
> layer.  Lower layer is squashfs (I've seen it happen with both the
> default zlib and also zstd compression), upper is EXT4.
>
> I've only bumped into this problem recently with 5.9+ kernels.  I'm
> gonna go see if I can reproduce in some older kernels I still have
> installed.

Rebooting into 5.4 made the problem go away and I can apt upgrade
w/out any problems.  Rebooting an affected virtual machine into 5.8
also fixed the problem, so it looks to be something introduced in 5.9.

I suppose I should try 5.10 and see if this problem has already been
fixed.

>
> Anyone else reporting this?


-- 
Michael D Labriola
21 Rip Van Winkle Cir
Warwick, RI 02886
401-316-9844 (cell)
