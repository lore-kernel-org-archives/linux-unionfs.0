Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8976C4338F
	for <linux-unionfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD83F6101D
	for <linux-unionfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237500AbhHJFOY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237495AbhHJFOY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 10 Aug 2021 01:14:24 -0400
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1110EC061796
        for <linux-unionfs@vger.kernel.org>; Mon,  9 Aug 2021 22:14:03 -0700 (PDT)
Received: by mail-vk1-xa35.google.com with SMTP id u138so667971vku.7
        for <linux-unionfs@vger.kernel.org>; Mon, 09 Aug 2021 22:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zbj2YIoq+E9w00zYigZfnEN2+DZS/6bH7EkHmJaJ7+4=;
        b=W2e6d7tANNuZvnWrmp6EN6PiiHeqThHUisatkH1a/4EL21ldzCzpHeXzGPY/9224BN
         Z/CiGZ7mZ32SpUG876YtQApfpUprIqF/xqEBvS7noMQ2n7FVPdaNK2oJscvnwdfI8Rui
         EDb1N2EJDvgQD5KJqrgWTMAVPLLaVNvPnUQHA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zbj2YIoq+E9w00zYigZfnEN2+DZS/6bH7EkHmJaJ7+4=;
        b=AvRcO2J5Ctk0D4DH7tqCgrkxiT39XGcbB+k6Rgdgj4oObxeDBCpi7TceBNu65FLOkF
         Wxk31qK/cdwpY8gzpTZrX7jZVqXboLunAzqwxfsCKNzg6PczkZVD3vQxxmOG6Nng7akO
         /ddWxCCmLMrqr115A26AH+xWim7nQR5/v5G6vzLTRQzOdAIRA7iM/A52ZRxN8Fc6A/kb
         2blUiKUwb5UQzz6GFfVE3N05oyKkItEqjrTKvdcLTSgl4ofCvVI+urGU3bOOlO45aeBa
         iFyOIGo6DmqYa6VegUwaecGiLr1hifaosYOUtIHPQM8RxQN2A865mFzzccFzBHsBxyrJ
         c+/g==
X-Gm-Message-State: AOAM532kP/dZb/tKax6AB+7nY3qJ8Ubc2Rysuz2Su/kARVY43up/1neH
        fViW6UtUcygrwPXim9JMmQ6ob9eKOt9nnlSyKd/vn2oxdaEGmQ==
X-Google-Smtp-Source: ABdhPJyK6yckKurEBP3/dfOsOeLJXctvCuX/cIs5kTcfm8Je/8pZ6c+cyun3iM9fbLfjpMMG2FXHjhz8Ez7yxBUxsWo=
X-Received: by 2002:a05:6122:696:: with SMTP id n22mr15132849vkq.19.1628572442200;
 Mon, 09 Aug 2021 22:14:02 -0700 (PDT)
MIME-Version: 1.0
References: <YRFfGk5lHL0W27oU@miu.piliscsaba.redhat.com> <CAHk-=wigKQqEqt9ev_1k5b_DwFGp7JmCdCR1xFSJjOyisEJ61A@mail.gmail.com>
 <CAHk-=wjhm9CV+sLiA9wWUJS2mQ1ZUcbr1B_jm7Wv8fJdGJbVYA@mail.gmail.com> <YRGtF69Z8kjsaSkb@casper.infradead.org>
In-Reply-To: <YRGtF69Z8kjsaSkb@casper.infradead.org>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 10 Aug 2021 07:13:51 +0200
Message-ID: <CAJfpegvD-n-Gb850wiB6J62CqGOtvV9LVWGfkXqqcB_UpJnBeA@mail.gmail.com>
Subject: Re: [GIT PULL] overlayfs fixes for 5.14-rc6
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 10 Aug 2021 at 00:34, Matthew Wilcox <willy@infradead.org> wrote:
>
> On Mon, Aug 09, 2021 at 02:26:55PM -0700, Linus Torvalds wrote:
> > On Mon, Aug 9, 2021 at 2:25 PM Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > I've pulled this,
> >
> > Actually, I take that back.
> >
> > None of those things have been in linux-next either, and considering
> > my worries about it, I want to see more actual testing of this.

The denywrite patch has been in -next for three weeks, the others
less, but also spent some time in there.  The reason the commit
timestamp is so recent is that the fixes have been pulled to the front
of the queue.

But okay, I can drop that patch from this pull request.

> Not only that, the changes to fs/namespace.c and mm/util.c haven't been
> posted to linux-mm or linux-fsdevel, as far as I can tell.

It has been posted to both and got an ACK from an MM person:

 https://lore.kernel.org/linux-mm/YOhTrVWYi1aFY3o0@miu.piliscsaba.redhat.com/

Thanks,
Miklos
