Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A07BC433ED
	for <linux-unionfs@archiver.kernel.org>; Tue, 13 Apr 2021 21:50:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A0676113D
	for <linux-unionfs@archiver.kernel.org>; Tue, 13 Apr 2021 21:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348486AbhDMVuk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 13 Apr 2021 17:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348479AbhDMVui (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 13 Apr 2021 17:50:38 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E60C061574
        for <linux-unionfs@vger.kernel.org>; Tue, 13 Apr 2021 14:50:17 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id n11-20020a05600c4f8bb029010e5cf86347so1773551wmq.1
        for <linux-unionfs@vger.kernel.org>; Tue, 13 Apr 2021 14:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t0aXTMxjsdarzJ9shpjbEft1f11FpCGQpHXIxXrm1v4=;
        b=MJ2T/4imgGTkyKSdRU0MMPspmjDgwhpn1e0wi1ZiUCryQbxBaEP7DjlAtkzsI+h3y/
         HleXjhx4Ubh00armVX3ojWNBnlLu0Em2UjiSyVKpk/gwn+R3Iua0EiW87MvJ41whLr6R
         uhYCbyhuaPGdUAT02Xtbf6cRWrggAkhktLOwQ7mf+j2qQh2QB7GVdHlYGUPfswKejicS
         3+TLCjOVg4RJSMndyXpIBaFOWdPwfZXi0X2gFo18QKsbiRQu9vx0ab/josGxy5kGzpRM
         Ve2kTP8SQYObC+41508QZTPfNddZUKqSRjTY6uKcnV1GO+G57IhccvT593Nn8mK7S3cH
         LVBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t0aXTMxjsdarzJ9shpjbEft1f11FpCGQpHXIxXrm1v4=;
        b=MAHHgtpyZtWX09UzpRu2L6loSUn9F7PSpOMeKYIVpDwUxYATONkAoBcYUrHqjSnik+
         UOAIZQupHG1KcOm/0XcygdDNGMEpyIsuDVOEP3DIJwD8JA2toJnYjbbJcIMaF2+AMkuS
         QLIleiBhYXp3UclO3si5ZUONmt1/JwjFHBrxW0A9OP99ah/QpNXwMLkL6/E1IetW/Mdy
         A1TYHlUor/DaGNN0fJCRmldJtuppGm2woGj84efezdxzd/ylpHHAleEKqmSxFd9oBWa8
         fjUsMS6R8AKS9leT6hiM7jOFfLroKSNebPYeWNO8v3m1cJCwQlxJx6WL8qGRmJtPfTFa
         5WvQ==
X-Gm-Message-State: AOAM531t2wT5s5f2u45MJCKLe78lxQYSS9loxnNeOVOqNVnOy3AO3wdz
        tJYJBfYsL0GUOEtXa3xFbL2MLv0w0t/C/I5k0sMcSQ==
X-Google-Smtp-Source: ABdhPJz2PHyUBepAVSWDQMhxPznWbmHVQ9Bg14TBEgwT9XsQV7uMNvRu7AR9No641Cj3cCFjAZWbeJs//O7x17VU/iQ=
X-Received: by 2002:a7b:c1cf:: with SMTP id a15mr1904855wmj.168.1618350616415;
 Tue, 13 Apr 2021 14:50:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAJCQCtTp0aXBssEr4ZXGX=DS_+RyGghmoANCKDdxG59QWu8LVA@mail.gmail.com>
 <CAOQ4uxht70nODhNHNwGFMSqDyOKLXOKrY0H6g849os4BQ7cokA@mail.gmail.com>
 <CAJCQCtRGdBzyskifrYLbBGAAm0g7VeC6GeD7xBN-hRqE3GAWYA@mail.gmail.com>
 <CAOQ4uxhU2KX=jKKL5EZ102z_+6KyVKAOoAzSp2K8i0PMGJUg4A@mail.gmail.com>
 <CAJCQCtTHepsUHjCUAwawC6r6txAZ=XypE5rJOizqxMx9zuR4AA@mail.gmail.com>
 <CAJCQCtQshgFBvUF2+DLm0=iHhiONu-QCRnB1uNv2dLigT+WfZg@mail.gmail.com>
 <CAJCQCtTg5Cz_GdSTCX-rZDmoB-PDGr2iV=quPWSofbL-Xixapw@mail.gmail.com>
 <CAJCQCtQDyOh-EWL2QMMgNQeY6KDpHqducVRpn_63O30KuX2diQ@mail.gmail.com>
 <CAJCQCtSC36c5yNo+H2sy0o1f+XerjDSj-KYxPZS4GX6v5czUgw@mail.gmail.com>
 <CAOQ4uxjYQV6gUa3rmsoECSjrZSAJ+ENWDcs0pYrLfocM1B+gVg@mail.gmail.com>
 <CAJCQCtSzENaFsZ_mcDv8OANDmpbUWoo+u1RVgfZ=hpxK5hQ7bg@mail.gmail.com> <CAOQ4uxib1YhfP3Pk5s_T7yWXg5iFtLHNMtaVAsBJVJuWdiiwcw@mail.gmail.com>
In-Reply-To: <CAOQ4uxib1YhfP3Pk5s_T7yWXg5iFtLHNMtaVAsBJVJuWdiiwcw@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 13 Apr 2021 15:50:00 -0600
Message-ID: <CAJCQCtQOPmZuajfMXruQPF0puEGdsP79yyFmz4kBJuy52sodzw@mail.gmail.com>
Subject: Re: btrfs+overlayfs: upper fs does not support xattr, falling back to
 index=off and metacopy=off.
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Apr 11, 2021 at 1:29 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> I'm lost in the maze of distros and containers.
> Will wait for more info.

The bolt test suite failure looks like it fuse-overlayfs related. It
happens with (rootless) podman but not when using sudo podman.

https://github.com/containers/fuse-overlayfs/issues/287


-- 
Chris Murphy
