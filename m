Return-Path: <SRS0=PFgV=7F=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E3ECC433DF
	for <linux-unionfs@archiver.kernel.org>; Sat, 23 May 2020 04:07:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 046EB206F6
	for <linux-unionfs@archiver.kernel.org>; Sat, 23 May 2020 04:07:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FXRVNUAT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgEWEHn (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 23 May 2020 00:07:43 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50759 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725294AbgEWEHn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 23 May 2020 00:07:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590206862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F1bhCGQtRl8cBs0zYrkz/5FLXJrqBYq5wZlx9jEG8Uc=;
        b=FXRVNUATXU7qldY+kE6Q9/P2oonvJJuAlXdTyJwrW4bDkTTa9k2J8YjH15F4nlesr9Q/J3
        TrN6QwoLqB9XBz0YOq0KNkLG+X5Q0d03T3pEIf/E4USn5mwMNimpFdP2n5NTQz1NwJrKQI
        JbIYJ/8bJ7Xkj2CI2HUnk0aRb/Xdmjk=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-KAH-sqRiPaimBK6p4_Hw7A-1; Sat, 23 May 2020 00:07:40 -0400
X-MC-Unique: KAH-sqRiPaimBK6p4_Hw7A-1
Received: by mail-qk1-f199.google.com with SMTP id r124so13179888qkf.1
        for <linux-unionfs@vger.kernel.org>; Fri, 22 May 2020 21:07:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F1bhCGQtRl8cBs0zYrkz/5FLXJrqBYq5wZlx9jEG8Uc=;
        b=hE842uknelkzJHFT2183rGFA4c7h8HMLXyZ4DHtS3mnbr99srTG1OKixgFzjIydqlb
         1cBEgLbQxcq0gPSU3yx4B2LcDpmjs+ASytYZVZd3T7hrHRRfxwIkcNQfWSDPXr60Xg59
         9CiRr1n91RXCnQMWZ1LEiLLCNW55e1O7zIrnKKIL1U2FAQ3feJhlmiw1BN4kk2H4ieBI
         luYvMrSmR8F5LhVBoIEhG1s9mN0s33Os0Fwqhjui2hpS0WbHZsEg28lpuQpG6MUhy7nz
         agkSn8oEDVqAFhtQ3nkVhNp2IFIbb0lYia87cypWzuxuz9yjSBHjy/+kQPbyOF8sBqeL
         nRCw==
X-Gm-Message-State: AOAM530CajC+Z0P4jfKHke6jGIvTAoV/ttorvejZGUPEcAQxiIGmr+WC
        8NC/+L6A9QTuR2XdWCGQamjAzIN/TrrDx+RnJh/k/xJ58lgzJwc0fpjf3Pqye2e3cpliLczPBP9
        AmftwUVbLXWrI7MeOcvqXwRYTB1x0+iX5KXmZ+jfV8A==
X-Received: by 2002:a37:270a:: with SMTP id n10mr17623766qkn.288.1590206860003;
        Fri, 22 May 2020 21:07:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqucE/BLDWAWbsUb5BS4pFv+/cIpYb0lPmqP/rcpvyVgWQsH8wbXFsAUfUqER06Q9HPajqCxqlT56dHPAxYvs=
X-Received: by 2002:a37:270a:: with SMTP id n10mr17623751qkn.288.1590206859751;
 Fri, 22 May 2020 21:07:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200522085723.29007-1-mszeredi@redhat.com> <20200522160815.GT23230@ZenIV.linux.org.uk>
 <CAOssrKcpQwYh39JpcNmV3JiuH2aPDJxgT5MADQ9cZMboPa9QaQ@mail.gmail.com>
 <CAOQ4uxi80CFLgeTYbnHvD7GbY_01z0uywP1jF8gZe76_EZYiug@mail.gmail.com>
 <CAOssrKfXgpRykVN94EiEy8xT4j+HCedN96i31j9iHomtavFaLA@mail.gmail.com> <20200522195626.GV23230@ZenIV.linux.org.uk>
In-Reply-To: <20200522195626.GV23230@ZenIV.linux.org.uk>
From:   Miklos Szeredi <mszeredi@redhat.com>
Date:   Sat, 23 May 2020 06:07:28 +0200
Message-ID: <CAOssrKcpWj=ACbNfy0iBjGDRogouDZAv-LT3P91XaXY3HD=jBA@mail.gmail.com>
Subject: Re: [PATCH] ovl: make private mounts longterm
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, May 22, 2020 at 9:56 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Fri, May 22, 2020 at 08:53:49PM +0200, Miklos Szeredi wrote:

> > Right, we should just get rid of ofs->upper_mnt and ofs->upperdir_trap
> > and use ofs->layers[0] to store those.
>
> For that you'd need to allocate ->layers before you get to ovl_get_upper(),
> though.  I'm not saying it's a bad idea - doing plain memory allocations
> before anything else tends to make failure exits cleaner; it's just that
> it'll take some massage.  Basically, do ovl_split_lowerdirs() early,
> then allocate everything you need, then do lookups, etc., filling that
> stuff.

That was exactly the plan I set out.

> Regarding this series - the points regarding the name choice and the
> need to document the calling conventions change still remain.

Agreed.

Thanks,
Miklos

