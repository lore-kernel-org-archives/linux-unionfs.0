Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C26C433E6
	for <linux-unionfs@archiver.kernel.org>; Fri, 19 Mar 2021 10:52:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ED3864F38
	for <linux-unionfs@archiver.kernel.org>; Fri, 19 Mar 2021 10:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhCSKwM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 19 Mar 2021 06:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbhCSKwH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 19 Mar 2021 06:52:07 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F06AC06175F
        for <linux-unionfs@vger.kernel.org>; Fri, 19 Mar 2021 03:52:06 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id h25so3220192vso.2
        for <linux-unionfs@vger.kernel.org>; Fri, 19 Mar 2021 03:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DyU0kfhyJ9K9PwDpeZgafjUaj5wayL2Dd1uu3ttNySA=;
        b=X8iKjZKkXYwh3BR84dUDizD/1NFrlbgZCIGwoUQIOsscM/6j6yFdalp+0zHlY0afLn
         2TTOEZwIma6EHaZtjOqsTYsEb8tM38HBkrCQKxJekX0F6Gu8kT4t4O/jhs4t1r4qM08d
         IsqnUJVbVcdM3PYW9BAKdBv2zowZxdkW2mVcU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DyU0kfhyJ9K9PwDpeZgafjUaj5wayL2Dd1uu3ttNySA=;
        b=BgoFe3ZbUrplAekT8TWqzz/IKy3ITFBSo6LQlfH8KRHr8qkS7/VMk/elWvInwS8Sut
         1s9xoUO4ORJ0jkL550zHJh3EVunrPstJaNkr2ksppcriMoGX/tCJnQ6iE72YtI5Im2CL
         6I4gaQb5HyYRjN8Q916KAJFy9S68ZX7/wfIdwMn7sFUQbxhF25VLJ6psHhqErntfwqOm
         VCKNkx+aHl7cfVPD3tXh/4wb5mTBRZ5b+nCmbwVdeAYLdo3Oka+CY3nyvGZv/szAVimW
         AGGI+ddmR+ZP1+CnrdtJo0Xv3o7ClRyDIgUg/TWFcX93E4r+rfGZ+AkIxtYuHx8r0X8E
         RO+g==
X-Gm-Message-State: AOAM531eU1uSGgEpoI+PrnIY7R2POq4DIIgfAU/+AbU/M09jGOgt6u55
        IHnu4dtLpS4nBFLsRnmQGSMdUdh544wImBRQqEUnUQ==
X-Google-Smtp-Source: ABdhPJyKXHCKa1uQYDJ36wfBLGH7zSQQ4glHPyYkdKrk6MfMGZWPApUav49zfHhz35XD+Gis8mq8yciY5zILs46+sW0=
X-Received: by 2002:a67:f7d2:: with SMTP id a18mr1977372vsp.21.1616151125453;
 Fri, 19 Mar 2021 03:52:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210316221921.1124955-1-harshadshirwadkar@gmail.com>
 <CAOQ4uxiD8WGLeSftqL6dOfz_kNp+YSE7qfXYG34Pea4j8G7CxA@mail.gmail.com>
 <CAD+ocbzMv6SyUUZFnBE0gTnHf8yvMFfq6Dm9rdnLXoUrh7gYkg@mail.gmail.com>
 <CAOQ4uxg+d2WoPEL2mC5H3d0uxh-_HGw3Bhyrun=z4O2nCg-yNQ@mail.gmail.com>
 <CAJfpeguiFU5qv-L-jeXBhc+PqeMOUoVnPO3EN4xOB0nCH9Z2cA@mail.gmail.com> <CAOQ4uxjcQWQ9n1rO7=js2SQ8-ZEbX2Wjvq-6ZGCyy5X5CJcTbw@mail.gmail.com>
In-Reply-To: <CAOQ4uxjcQWQ9n1rO7=js2SQ8-ZEbX2Wjvq-6ZGCyy5X5CJcTbw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 19 Mar 2021 11:51:54 +0100
Message-ID: <CAJfpegsGpaFdLcmUsBW66qhJSfXuog=3UbsZ50O_FSw2WUGhJA@mail.gmail.com>
Subject: Re: [PATCH] ext4: add rename whiteout support for fast commit
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     harshad shirwadkar <harshadshirwadkar@gmail.com>,
        Ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Mar 19, 2021 at 11:35 AM Amir Goldstein <amir73il@gmail.com> wrote:

> One thing that we will probably need to do is use the RENAME_WHITEOUT
> interface as the explicit way to create the shared whiteout instead of using
> vfs_whiteout() for filesystems that support RENAME_WHITEOUT
> (we check for RENAME_WHITEOUT support anyway).
>
> The only thing that bothered me in moving from per-ovl-instance singleton
> to per-ext4-singleton is what happens if someone tries to (say) chown -R
> the upper layer or some other offline modification that was working up to
> now and seemed to make sense.

Eek.

>
> Surely, the ext4 singleton whiteout cannot allow modifications like that,
> so what do we do about this? Let those scripts fail (if they exist) and
> let their owners fix them to skip errors on whiteouts?

Might try that.  But the no-regressions rule means we'd have to change
that in case it breaks something.

Thanks,
Miklos

> Thanks,
> Amir.
