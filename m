Return-Path: <SRS0=564x=A7=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 085CEC433E6
	for <linux-unionfs@archiver.kernel.org>; Mon, 20 Jul 2020 17:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE40D20709
	for <linux-unionfs@archiver.kernel.org>; Mon, 20 Jul 2020 17:47:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sixEr0RN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbgGTRr1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 13:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728966AbgGTRr1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 20 Jul 2020 13:47:27 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17910C061794
        for <linux-unionfs@vger.kernel.org>; Mon, 20 Jul 2020 10:47:27 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id e18so14052510ilr.7
        for <linux-unionfs@vger.kernel.org>; Mon, 20 Jul 2020 10:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/eF4aHtdnSjDE0icF1yBp7ZAC8SJDbDxnpQMGsFn2Kc=;
        b=sixEr0RNCSfk04RFBPShQR/3rF4/9MQbb5H0iJGSMgBTrV3L/onbdA8ak72WwOIKm1
         jaq/Lj/jVL4m6KwvxRd+i9+3VD+lFjuR3mr1JZ5gQ8vLdUQSTzUvCtk0RV8rU92i2+Tu
         MUGmyfeSPG73kZgAPhvGC/UFvxZ5OIaaUPsPolvo/b/qNbgHDs30WNMDYqxtV55IGUFz
         7QE4WHmZ3I4Hsx63JJJSnOE6dA+clUdjGSbj6+6ECcI44fF4nRESq3i/1JnbXUYkPLFi
         1eRgbxSgfNsPmqCTUqomjUIgWJ0RuGFCREU5nDDACZnVPHH701W11kdHzFzYaTnCCBnp
         qWoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/eF4aHtdnSjDE0icF1yBp7ZAC8SJDbDxnpQMGsFn2Kc=;
        b=R94QBhF0jEfSTQ7whiEsueACvGhHqf9aERigiC2pEakKk9yxQYpAU3sSfx7/zxKGta
         EmRm15dTxpEbqTouhTo6RjthhfN/ITNaOt1JlgXM0QxRKmU1gCM5VPbkXjx1QKCcrhrx
         O4yXnG4d2ywEu/L6waaqOOc0ChEpI27Sxml/V+EOUIgmDjNUTez8TiThHIAZQQ+h8ejX
         ZADcILiLrsoEZ1VerCzXa5WWDwyGkWXsBms6YbYYQWPoQfHsLGxFE/PHusRyuk9CHlsV
         zh/nFKLtKKrp2TQJrlGpf5YzHjU8MR/PeXQHHv36XjTnUGJSOoKA2MJ3nDtvsUp5frSy
         oROw==
X-Gm-Message-State: AOAM533t671/85mTaEV0MYOCtzuaf2Anp/BuZ60uoktmUHAMsSNIMXXY
        i+o0+Ld+biP2nTMArZobahoLuZTIF0TvZGsDYuk=
X-Google-Smtp-Source: ABdhPJyNhenG2E0iC1XXutYkrzYF2fsoH8UjDU+HORztPqXB1W9l1wtQuOcC75Nr06yQczQFRTAL7c/qnlZn7SaRf5g=
X-Received: by 2002:a05:6e02:13e2:: with SMTP id w2mr25051365ilj.9.1595267246489;
 Mon, 20 Jul 2020 10:47:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200706161227.GB3107@redhat.com> <CAJfpegtBjv60ZYJYSgQfU9EFx+eMbjqzcZ1HFV8P2nL64x5D2A@mail.gmail.com>
 <20200720161618.GD502563@redhat.com>
In-Reply-To: <20200720161618.GD502563@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 20 Jul 2020 20:47:14 +0300
Message-ID: <CAOQ4uxjijzhtk4V=4VnyTbh9xKHtPEUQsOOPTs36yi93Kp3ArQ@mail.gmail.com>
Subject: Re: [PATCH v4] overlayfs: Provide mount options sync=off/fs to skip sync
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>, pmatilai@redhat.com,
        Eric Sandeen <sandeen@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> >
> > Naming: I'm not at all convinced by any name having "sync" in it.  I
> > think "sync=no" is about the implementation, not the functionality,
> > and so it's confusing. The functionality is better described by
> > "volatile" or "temporary".   But I can live with sync=... if voted
> > down.
>
> I am fine with the name "volatile/temporary" for sync=off.
>
> Amir, WDYT?

If we knew we were going to stop here, I wouldn't mind "volatile".
I too like the fact that the user config means something functional.
But if we are considering to expand it later to sync=fs and maybe
sync=writeback, then it is going to be quite hard to come by with
equally meaningful names and the "sync=" modes would end up
being less confusing IMO.

So I cast my vote for "sync=off".
We could also make "volatile" an alias to "sync=off" if it makes
anyone happier.

Thanks,
Amir.
