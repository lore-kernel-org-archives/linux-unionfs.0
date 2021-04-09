Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50DDFC433ED
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Apr 2021 05:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0A14610CB
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Apr 2021 05:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhDIFox (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 01:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhDIFow (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Apr 2021 01:44:52 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597A7C061760
        for <linux-unionfs@vger.kernel.org>; Thu,  8 Apr 2021 22:44:40 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id x3so3168181ilg.5
        for <linux-unionfs@vger.kernel.org>; Thu, 08 Apr 2021 22:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fG8FFPNd6jRuMoMQRffVcwVR9c4Nkv7/fVMP4LX0jCo=;
        b=WA67Lhm22nuWXn2AsdNWaLjUDzu8UgK6qgk0VqDbLR1dPwK0T0EBh8pd/dnGsIxzSR
         Jar5LVK0Q3csoJOxcdwnIMTeGtmJZXs3ZBGL5p2DshZRQ2+PDAVXSO6Z5BM8cEDkvfsx
         t9daq8LuHjSFbJdLBUrMptlFUZ9LSlxxv0DuBu6mPRyoWmnugFtd3J2RQv2cGccpcNeA
         jZgYORim7JauIitVAv9J0kammxya4zE38kVi0etCAjF5Wq39bAAzzByJWsJMYj5eF49S
         AG5pLghoLRzyQQ4zmzCs3sNKgs8BJ1rC9LsptdBvXkAmSk6l86bFhok7EvQ5dq/2JttE
         gqSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fG8FFPNd6jRuMoMQRffVcwVR9c4Nkv7/fVMP4LX0jCo=;
        b=tCKdf4aBuCFI6C5ActUtBDSXiqPaRxytEslLiTyEttmkIAIrMliGpIzxg75RdsWk49
         BaxrY1KY9TYNo+03xEKKdw6WF1wU8OyDdxqaF91gB8Ts45BZJJOvFrybBsniLhFFsUC8
         W5tLijNnFQyWkMjnH8uvtvcuY4C8HHl8sSk7SummlNEt+vC8Yx+0aLGBAO8UDvnqAfm2
         v2MI7VEfQyRKdCBl22DdL/zTC861b1S4c5pUCA7u/GUQl8Lh0RIm/9U9kxAjYJ6YNZfG
         SUxfeMDujISHXwdJ+kwXZgFjNSPCLX3Hzj4K5jYD+vR3/eSmXY9LTetft+5nYLLohMkq
         czqg==
X-Gm-Message-State: AOAM5337CDOOcTQXm2bps0YqkNUCWYUUb2Q+1+pg45MiKh3wxd6XJifA
        JA2ybgyqKhfchY2CGbIDzDo7P+6+dcTjM5xN6gvBcpHtlbM=
X-Google-Smtp-Source: ABdhPJw2jJ79IaXrHK0dbeCJsnt1ixqq//hCO7exv36dpDjEKV0qfuFLzqVH8s9nkqsd0VYRA2VuInLwyx66qzvxVMU=
X-Received: by 2002:a92:2c08:: with SMTP id t8mr9746889ile.72.1617947079797;
 Thu, 08 Apr 2021 22:44:39 -0700 (PDT)
MIME-Version: 1.0
References: <606F526A.1040405@tlinx.org>
In-Reply-To: <606F526A.1040405@tlinx.org>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 9 Apr 2021 08:44:28 +0300
Message-ID: <CAOQ4uxj4bdzcdcy7jpkRCZTNv=4b8BPVVP+1L_3OLWFwMnV-kQ@mail.gmail.com>
Subject: Re: odd error: why: mount: /home2: mount(2) system call failed: Stale
 file handle
To:     "L. A. Walsh" <lkml@tlinx.org>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 8, 2021 at 10:18 PM L. A. Walsh <lkml@tlinx.org> wrote:
>
> Started to try overlay fs w/one fs, but decided on another, so
> umounted the first -- hadn't done any changes.
>
> Then tried a different lower dir (/home) and tried to mount into new
> dir /home2.  Got:
> mount: /home2: mount(2) system call failed: Stale file handle
>
> any idea why?  I cleared out contents of workdir (two empty dirs)
> but still didn't work again.
>
> running a Vanilla-ish self-made kernel version 5.9.2...
> don't know what other info I should provide...oh well...
>

You should normally at least look at kmsg, where you are likely to
find "overlayfs: failed to verify upper root origin".

It is generally not allowed to reuse the upper layer and replace the
lower layers after overlayfs has been mounted once.

If you say you did not change anything, it is not clear what is the
benefit of reusing  the empty upper layer.

Thanks,
Amir.
