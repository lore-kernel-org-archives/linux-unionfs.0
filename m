Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 471F1C4338F
	for <linux-unionfs@archiver.kernel.org>; Wed, 28 Jul 2021 05:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20B4160F6D
	for <linux-unionfs@archiver.kernel.org>; Wed, 28 Jul 2021 05:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhG1F2Y (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 01:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhG1F2Y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 28 Jul 2021 01:28:24 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414C4C061757
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Jul 2021 22:28:22 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id c3so1559886ilh.3
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Jul 2021 22:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ya0vA1hsfwNC+XZkumjcuDjGDvgai5my/lXUR/b79jQ=;
        b=S69TrydzoxKXJPxtK1dR5FvFyXtveI95LrmondfGHIO6G8uHf+Oc0O7qjnSglNVhcN
         l9/Qod44Uz8K3j0r7NlS5OvD264JitWlI1KiwVuVaT8mgq66h1WEsO7Jyy8Ua8HZwHV5
         plPjyGfGY9xjQxZ7NxpeMsegzCT9TkWzwq85k72WUKVrxD1MI+2VP6e8VRszXmy/MGjR
         5NfCkTIOqhyZc7l0COKZWghv4Z0A6r4fpbJXt+c68wjQhCEWARkDEuZKovX9B7R8tcVI
         bx/LIX434tHL46VsCKi1G+o2jhTwydZVmBD+sQ6wsPFbiVXGG4jNjDZoAnpjsk571Ba/
         2Cqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ya0vA1hsfwNC+XZkumjcuDjGDvgai5my/lXUR/b79jQ=;
        b=Tf16JnLH77MVXA2YqCXQrJNQHvKrkPJSdevALd5069RXhym5QtUcjkGEqxuJ+H+ip6
         jpKJWPFsB0KcKqWEK2RFLJsuXPBN65lUXn6h3XCnFZq/k4eWeF6D7xASkeannqwxTheI
         fJZ7m24ne9ZXpUp3C8GKs5WFR+ZuiazlWJRVASb0tzts0QZSaSc+SSxseSkPpHjQzV5m
         IMRjfDlSvps/CTiwW3FFGRhb7yMZwLx2MGkV/IlZNtjys1uwPJYjQEpGA3pjNM2+u2Dz
         x0Vj0GeGSJQFf3yU40/Pr3T+dUUEm3YRC3j2rkgFDRktsu9QXUwTZdQ02YqR5twXPvyr
         uoLg==
X-Gm-Message-State: AOAM530kWzFqanaqV/WkhmRKLT15QtkibumW0T4jCsfGeU+KotFRyHSN
        ug0AggifpWh4vnu5DOUg5TY8qAnTyq+DkdNrBQw=
X-Google-Smtp-Source: ABdhPJwLP6KuPzTB7w8c0kLU0ZnUYtmOu2RaeXeXC8fYTRtulnyTZw7X+kf61mfdhDSauj7pymwI5vI6fdYeaorVmhM=
X-Received: by 2002:a05:6e02:1c02:: with SMTP id l2mr19436593ilh.9.1627450101526;
 Tue, 27 Jul 2021 22:28:21 -0700 (PDT)
MIME-Version: 1.0
References: <4a261352.642.17aeab04218.Coremail.ouyangxuan10@163.com>
In-Reply-To: <4a261352.642.17aeab04218.Coremail.ouyangxuan10@163.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 28 Jul 2021 08:28:09 +0300
Message-ID: <CAOQ4uxgQ=oH9Z5Y=kWZ8-0XWCNg=vnWYOyF8QwTH=DP5PkYM5Q@mail.gmail.com>
Subject: Re: [overlayfs]: Overlayfs questions
To:     www <ouyangxuan10@163.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Kevin Locke <kevin@kevinlocke.name>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jul 28, 2021 at 4:18 AM www <ouyangxuan10@163.com> wrote:
>
> Dear Miklos Szeredi , Amir Goldstein and Kevin,
>
> I would like to ask some question in overlayfs=EF=BC=9A
> 1.  in overlayfs, where is the code for obtaining directory or file attri=
butes?
>
> 2. Where is the code that combines lowerdir and Upper Dir into a visual p=
art?
>
> thanks=EF=BC=8C
> Byron
>

Those are very broad questions.

In a very narrow sense the answers are
1. ovl_getattr()
2. ovl_iterate() and ovl_lookup()

This is the most up to date documentation:
https://www.kernel.org/doc/Documentation/filesystems/overlayfs.rst

For anything beyond that, you'll need to read the code:
https://elixir.bootlin.com/linux/latest/source/fs/overlayfs

Thanks,
Amir.
