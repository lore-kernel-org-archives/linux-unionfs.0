Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3309C07E99
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Jul 2021 14:03:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC58661356
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Jul 2021 14:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbhGIOGH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 10:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhGIOGH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Jul 2021 10:06:07 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFAEC0613DD
        for <linux-unionfs@vger.kernel.org>; Fri,  9 Jul 2021 07:03:23 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id e9so4139025vsk.13
        for <linux-unionfs@vger.kernel.org>; Fri, 09 Jul 2021 07:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LsyRsgs6uMxRM2GNDSsrmpLFql+i83M2t3ikP3xiPCM=;
        b=n1aZh39PKY/VMzrzl7OLyHo1ZeYj6+5WoG+Yi7POakS2Nwdu/isuvc6yxhTmGv4ysl
         mAW3HDKUe9nsQdSrgD/7Yv++B//5g+71I06J3BojwKMJA2Q1qhDTR9tQN73uqrtC0hkY
         2edfJMlPNzrHB+HI1jzBXTN2JNpWZCY4CcGpU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LsyRsgs6uMxRM2GNDSsrmpLFql+i83M2t3ikP3xiPCM=;
        b=m1G063QB+fpX+GlfP4POCOJGd6xYE9/3LF/f5E66jJ7cUvk/yk2bLpvcEUMSmYWWrM
         5i6YXfoGiO4N2TgWcLUHnrsaylVLjHzPzM2qWcJ5eJWQDAvJPC5KUP8hMZ5A4V6uJU6T
         IjqFmQR/89ZG7pAbC7EqC5fkbu4C15SxUpK2MP5j+idLVzq6Ulzo1XpOgJ8wfjiGK8y9
         54eOCCqMeRzOaF7qdwb/48i+anGdw052ASV6afP3p13N8+zknfH7v1B7NUEGWIO+QPIc
         OUQe0nKvKZscTQsW7qyyRyhak8iWNom4wbQ2WSo5TTT2fSRe1rJkGpAWpvoY5lQKbthh
         6IHw==
X-Gm-Message-State: AOAM531IuFZmJholRyTBQ1peSLh+FSHhyMppa2DaAH7LFHnH0C+oMs0Y
        7kxfpAk3WCfFSrnMvYaiyVN5PW1KepRuEAc+323ueCQPvmn5QA==
X-Google-Smtp-Source: ABdhPJwtWi3n8Q3YGBFu6E/erb5Dt8BUYKKOQT9HxmBQrqYhS1uwbEzUyTGBm4nrzbixSjVkz8Guxd1dYnM3MtykWfs=
X-Received: by 2002:a67:c507:: with SMTP id e7mr29314808vsk.21.1625839402288;
 Fri, 09 Jul 2021 07:03:22 -0700 (PDT)
MIME-Version: 1.0
References: <17a34811bb1.ca67d1a36094.7925246580859918166@mykernel.net>
In-Reply-To: <17a34811bb1.ca67d1a36094.7925246580859918166@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 9 Jul 2021 16:03:11 +0200
Message-ID: <CAJfpegsymMB5ni=GDQ+02u1OD-tzONkQy32bzjWyrOYq3VPf8w@mail.gmail.com>
Subject: Re: Mount failure caused by colon/comma characters in the path of
 lower/upper dirs
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     linux-unionfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 22 Jun 2021 at 18:30, Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Hello,
>
> Today I got a mount failure report from a docker developer about special characters in overlayfs lower/upper path.
> The root cause is quite straightforward  because overlayfs uses colon/comma as seperator of lowerdir layers and module options.
> However, Colon/Comma characters are valid for directory name on linux so some people(especially container users) hope overlayfs
> could correctly recognize and handle those directories.
>
> Strengthen option parsing seems a right solution for fixing the issue, what do think for this?

Use backslash as an escape character.  E.g. lower directory named
"ab,cd:ef" needs to be passed to mount as "-olowerdir=ab\,cd\:ef"

Thanks,
Miklos
