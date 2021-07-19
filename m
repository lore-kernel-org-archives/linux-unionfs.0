Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC4CC07E9B
	for <linux-unionfs@archiver.kernel.org>; Mon, 19 Jul 2021 14:29:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E72E610D0
	for <linux-unionfs@archiver.kernel.org>; Mon, 19 Jul 2021 14:29:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240564AbhGSNs5 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 09:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbhGSNs5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Jul 2021 09:48:57 -0400
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961FBC061574
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Jul 2021 06:55:59 -0700 (PDT)
Received: by mail-vk1-xa2c.google.com with SMTP id x20so3859464vkd.5
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Jul 2021 07:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4GO7b9XRRYtS27QmEwoxXcEMD92d6vyXqjDf4xPUd5Y=;
        b=jFFdxiGU7zNRmxHgyNdF4FEGHa9JOrkeAD07bHWqg4aSwFUV9xy1VnrvZDm/UcRXVF
         qrlVF7eRoXWHh3LgUUGlNPXTJUULlCq6Wy1OGUHsukgBZPV6JTra3SVB2/NQm26XtJP7
         kQePNh2cosdHOatxnqlv33DT8/xEM4PB30xmo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4GO7b9XRRYtS27QmEwoxXcEMD92d6vyXqjDf4xPUd5Y=;
        b=Ttj2JX5prxADi/yFhB5DdVaHDWtbRDHBTR7zbbjoj7BZNpnQCHbf4xY+/aG093JNkD
         cvxZjJcVrIzdZH9Hud9mrmHw3ZJf9JSdSKNcRpRmLvLyH3XXOt0wS7aKKhijcvEyRm+7
         iH79Vf+o/CFSAnzmy5TGus6ANSkHxcFv+0vlZNrWTgCXVoLWhG7uxX7hBVIhIVBhu++m
         /62q1NtlfIQMsf7i6VkMc+Sd6zy4OLu5qlCjNOvGllRGscUGZ7jAxh6yKVPCgb3EDaMd
         RIySUPP+er4SFSnPH7CgTV8PKJCUy+swAY/b5SdwRE52/34YJ6GZPlXnPhSTnS4ljsTo
         jxog==
X-Gm-Message-State: AOAM532XjYbZuGJ9sinIpr8c/PZCakJ42eYWzxvzvEerX60CB75GyGNP
        ahB4pDejfw0et8maAM8S2L4wQYeD092jDM69scqqPg==
X-Google-Smtp-Source: ABdhPJyJ+fDD7EDvl5jcuA7hbgDVIcAvpOACUWWc8f87qxcqVx6xtFse4TWHRK5qon1N0zTxkK7uMIdLe4F6Q0qf5Nc=
X-Received: by 2002:a1f:d943:: with SMTP id q64mr12835942vkg.23.1626704975133;
 Mon, 19 Jul 2021 07:29:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210527174547.109269-1-uvv.mail@gmail.com> <20210527174547.109269-3-uvv.mail@gmail.com>
In-Reply-To: <20210527174547.109269-3-uvv.mail@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 19 Jul 2021 16:29:24 +0200
Message-ID: <CAJfpegvLTPauUUSh7+9BS3OxDQHGBpek3k=Jda_7+nv3aeeSug@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] ovl: do not set overlay.opaque for new directories
To:     Vyacheslav Yurkov <uvv.mail@gmail.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 27 May 2021 at 19:46, Vyacheslav Yurkov <uvv.mail@gmail.com> wrote:
>
> From: Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
>
> Enable optimizations only if user opted-in for any of extended features.
> If optimization is enabled, it breaks existing use case when a lower layer
> directory appears after directory was created on a merged layer. If
> overlay.opaque is applied, new files on lower layer are not visible.
>
> Consider the following scenario:
> - /lower and /upper are mounted to /merged
> - directory /merged/new-dir is created with a file test1
> - overlay is unmounted
> - directory /lower/new-dir is created with a file test2
> - overlay is mounted again
>
> If opaque is applied by default, file test2 is not going to be visible
> without explicitly clearing the overlay.opaque attribute

Series applied and pushed to vfs.git#overlayfs-next.

Thanks,
Miklos
