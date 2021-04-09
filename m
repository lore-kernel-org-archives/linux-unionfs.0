Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D63C433B4
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Apr 2021 13:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A57D261056
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Apr 2021 13:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbhDINvB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 09:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbhDINvA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Apr 2021 09:51:00 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A29C061761
        for <linux-unionfs@vger.kernel.org>; Fri,  9 Apr 2021 06:50:46 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id 66so2944784vsk.9
        for <linux-unionfs@vger.kernel.org>; Fri, 09 Apr 2021 06:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N8RoAP1EiR/LcGsXbxnBBCjPu3U5eRJLQXStV3VL6kw=;
        b=panrMHI79cDH7dTlwdn1I3IGqUb9am4TAQaZFV2Q0SFp7/bM44yhhHQikyWizy4e3g
         gnsRXzw9YnJSeQrRTFKzSQLvibLJR+aDeY4xdbNhgur3ipBxNqb/bmDe5j595DUGRXs3
         oN1fMt8Wvylbxj+Pggxqa2ifLXkeSmP4SdY3s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N8RoAP1EiR/LcGsXbxnBBCjPu3U5eRJLQXStV3VL6kw=;
        b=FAbozan79krE8BUbVZZkCRPGwDcGzGre7l3cl4gPtzWL0rNWnW2i8O8/80u+JtV973
         8x3QVeAqWl6XHtRb4h+NPgosLIM96/Sw9hp/tTRFuU66pzcylRgLKAh5lLLAqh6tM9VS
         PnbBHTVH6uLudQL+viBcgaTkzFXNYFEzbtL9jCR3WCi9mhrPZFRBDScV7E8XEfNg/jaA
         wn7f5ff2daroSb6Ncj7FQcoXvkQliVosJKHRAb2RXsEyGC716blSER1VqR2BTf2/gipS
         NeGDcgMixy+f1lYSWJ3VTmcVaTMtfR+CFJ0ZP/1FRkRARubqlbDtNGfWnTBVIjkqs7ct
         1iLQ==
X-Gm-Message-State: AOAM532ADHad26y2RYwur9yHXQ/vFFrsg6BpSVXCribxe96xv9yaF5od
        h9lvkIYVzu2GgU5FfrEncdOST0R7laqW1lelrU5g8A==
X-Google-Smtp-Source: ABdhPJwI4caeqnFFIu4i21Ymw4kHKa1nHUINrWzbVZD02yAE8tX+rdFIAOGmqoLfUUGSnEdfy4+9sdAFwYfcDywJoek=
X-Received: by 2002:a67:f487:: with SMTP id o7mr11201561vsn.7.1617976246033;
 Fri, 09 Apr 2021 06:50:46 -0700 (PDT)
MIME-Version: 1.0
References: <20201113065555.147276-1-cgxu519@mykernel.net> <20201113065555.147276-8-cgxu519@mykernel.net>
In-Reply-To: <20201113065555.147276-8-cgxu519@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 9 Apr 2021 15:50:35 +0200
Message-ID: <CAJfpegtpD5012YQsmFEbkj__x52N4QrV0jSi=7iZtREqVf3tcA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 7/9] ovl: cache dirty overlayfs' inode
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Nov 13, 2020 at 7:57 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Now drop overlayfs' inode will sync dirty data,
> so we change to only drop clean inode.

I don't understand what happens here.  Please add more explanation.

Thanks,
Miklos
