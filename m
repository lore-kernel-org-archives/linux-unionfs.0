Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34632C433B4
	for <linux-unionfs@archiver.kernel.org>; Fri, 30 Apr 2021 22:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EFC4613C8
	for <linux-unionfs@archiver.kernel.org>; Fri, 30 Apr 2021 22:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhD3WUy (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 30 Apr 2021 18:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhD3WUx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 30 Apr 2021 18:20:53 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3FFC06174A
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Apr 2021 15:20:04 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id n138so112490676lfa.3
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Apr 2021 15:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LPHXuFLy5stLpGwQaeIuIJPobdMaEnCqfseYzg/gd2Y=;
        b=CocY4j7++UJ3Tc8jJmqROkOnzc8H9GEFjGGcDlbZNXrn4v38F9dgTWsMHGhZynPK76
         npc+QlQdePfy2Mzi3UYBTefVTgTCaLxr5YqshopI64WjF2MnPwTs9nH2p8i+0HCbUwBx
         2bVS4qj4KPhfsKsMVy+FfBkC1jGCVOP2yxCug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LPHXuFLy5stLpGwQaeIuIJPobdMaEnCqfseYzg/gd2Y=;
        b=GRaa17XJ8VE9rELTtNOJjzalxe7bzNgNKMy7VEocljHbx1huRj5TxP4ZSsP/6pBXEj
         cWxjl7cQWxf1MRvU4A4KVy1//5iPa/klZXe+xNhnXE9F3sWKsETX19b9WQ88GojnifGN
         piDx0OQppQ0EBL4MqHesyhLP7fWYGgeTtg8mgZEok7lFWWfnYB/5FRKVba2vRejlAX54
         sh3DINwcpibGObp9+C8pHTANMRb9SubfkZcgdhUe7ng3QFfpkngB+0aEg4DYrVTdOrPG
         2A7sH3FqtQAL1YDjluPNDregNEyp8i9A+G9KgcQ65/kXDILq1hckaY+w/vJsj4Ns7uv/
         +CWQ==
X-Gm-Message-State: AOAM532zVPhK44DDCM/w+TTsPVQ3BBlvmSKvio/BxwlOp477X9Gc291i
        mAN1+snbAiLHPPXfwMynCyBNbZovb2+ulUNk
X-Google-Smtp-Source: ABdhPJwjNIPjiLipwTsUgr23Hhtx8BVUzhcdYKrKiw7VYEuoL0c8sp4oyxj84ciuQpZVNSXmP0no6w==
X-Received: by 2002:ac2:4e05:: with SMTP id e5mr4689073lfr.613.1619821203274;
        Fri, 30 Apr 2021 15:20:03 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id u16sm398791lfl.83.2021.04.30.15.20.02
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 15:20:02 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id h36so58184115lfv.7
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Apr 2021 15:20:02 -0700 (PDT)
X-Received: by 2002:a19:c30b:: with SMTP id t11mr4728228lff.421.1619821202593;
 Fri, 30 Apr 2021 15:20:02 -0700 (PDT)
MIME-Version: 1.0
References: <YIwYirYCIdcVUjk6@miu.piliscsaba.redhat.com>
In-Reply-To: <YIwYirYCIdcVUjk6@miu.piliscsaba.redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 30 Apr 2021 15:19:46 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh+RrxDNLJJoANx02QEBYYBfJbHRjRV1FD+di6x+tTiNw@mail.gmail.com>
Message-ID: <CAHk-=wh+RrxDNLJJoANx02QEBYYBfJbHRjRV1FD+di6x+tTiNw@mail.gmail.com>
Subject: Re: [GIT PULL] overlayfs update for 5.13
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Apr 30, 2021 at 7:47 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> - Miscallenous improvements and cleanups.

Life hack: everybody misspells 'miscellaneous', which is why we have
the very special kernel rule that we always shorten that word to
"misc".

Problem avoided ;)

              Linus
