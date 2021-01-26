Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF5CC433DB
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 Jan 2021 18:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4366C22240
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 Jan 2021 18:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391143AbhAZRVu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 12:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390568AbhAZIsI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 26 Jan 2021 03:48:08 -0500
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9E1C061756
        for <linux-unionfs@vger.kernel.org>; Tue, 26 Jan 2021 00:47:51 -0800 (PST)
Received: by mail-vs1-xe29.google.com with SMTP id b5so4049371vsh.3
        for <linux-unionfs@vger.kernel.org>; Tue, 26 Jan 2021 00:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eJJVXT7Zm3sSCpG8sNIQkas+aRxWJnV+8pTflNpI0kE=;
        b=Vs+AYALnh9wAuAwQAOqQKViVTSsS9zXofeAMuo/KhL+SHGC+6ElIBykrEZyZlMW0ef
         NDrr1BlmHxjI7XnTrTTTdzo5EGaKjcr6N2+e4EFKauBx6Kt4ywtFtM2iuetRgkqSVL3N
         pATNtykcc84AQLXdnCutOczvC+EM2RuJVFuPU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eJJVXT7Zm3sSCpG8sNIQkas+aRxWJnV+8pTflNpI0kE=;
        b=XQA7dLWFHCood61BpJinQIhhLupyIG79l5V9Mp0418HvhdtTX7Y80XzotcUCHIT8A5
         cWk33B+/vi5QUPxb802rsozJE4c7oiu3QcCydDIKTw0oLO1GGpSm13LYpvJv8mqc06oO
         nqzaf84ICkCRXVRbLMRk4UCWv5LqugFMOsSyD4ifFruiIkdRs2dsmk+5kUALetIili5d
         XUdcayhq5moc8/dDNJfNGn/Y6/AB+5VzqmH4lWHa2HDUSDTGehLaUxXlEmP8f1yWV5Om
         V7fmoACXrma6EWi3Pr/JfUvJfiKSY270Pn9Z8Yq0gdfqjNixdUS1zQCpdeqXzABeT958
         dwFQ==
X-Gm-Message-State: AOAM530GWz9TqcQAFDrpEm2NuzqpWSJdRgLGbRT0JmsKfNTIvcR9Faxq
        f11WdFRG5x+ESK6EiInyqlNyjbkjwwrSEXlZQLot6Q==
X-Google-Smtp-Source: ABdhPJzTJTbo0jmbcnLg+/acyVUVHuN4RVsFfiB8gDL/6YB6EXHp1QNRrIyXM7OZEe95WP//ZCgNQDP7wNVVXeoudz8=
X-Received: by 2002:a67:8844:: with SMTP id k65mr3457158vsd.9.1611650870537;
 Tue, 26 Jan 2021 00:47:50 -0800 (PST)
MIME-Version: 1.0
References: <20210116165619.494265-1-amir73il@gmail.com> <20210116165619.494265-5-amir73il@gmail.com>
 <CAOQ4uxiXUN7LkzNLZto6iK2YuDdxp7PGoQMGCm89p1kNWUf=YA@mail.gmail.com>
In-Reply-To: <CAOQ4uxiXUN7LkzNLZto6iK2YuDdxp7PGoQMGCm89p1kNWUf=YA@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 26 Jan 2021 09:47:39 +0100
Message-ID: <CAJfpegu0igQWqaaq3RT5jHx=GLZ80+4rM6uk8yM0+ri4Ks_0bA@mail.gmail.com>
Subject: Re: [PATCH 4/4] overlay: Test lost immutable/append-only flags on copy-up
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, Icenowy Zheng <icenowy@aosc.io>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jan 25, 2021 at 2:24 PM Amir Goldstein <amir73il@gmail.com> wrote:

> Miklos,
>
> Do you plan to followup on your VFS implementation for the
> {s,g}etxflags methods?

Definitely.  Will try for 5.12, but no garantees.

Thanks,
Miklos
