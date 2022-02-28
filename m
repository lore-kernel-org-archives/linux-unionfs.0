Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D59C433F5
	for <linux-unionfs@archiver.kernel.org>; Mon, 28 Feb 2022 15:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbiB1PHb (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 10:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233524AbiB1PHa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 28 Feb 2022 10:07:30 -0500
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DB076E0B
        for <linux-unionfs@vger.kernel.org>; Mon, 28 Feb 2022 07:06:50 -0800 (PST)
Received: by mail-vk1-xa2b.google.com with SMTP id l10so5306152vki.9
        for <linux-unionfs@vger.kernel.org>; Mon, 28 Feb 2022 07:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jiqKta+C/bUAijQgVs2pIwZxEquJxCrRrkx40wt5xeU=;
        b=jrZ7QG8cvbuAWbySWWqcPRl1HzBxXrPIQi88Qwxn9KEns4B4V6BG/WCFVt2TODG2Ek
         mVVcRUWT7BUAL5BAyusW6Vh4apN5Ewv3KR/Aq+pMkgfcel1DXFU8JWDqrvlCEpRo5wt5
         tALdoK1ujT5pztZcBl+qe2p7Xd+6FhJuFYLw0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jiqKta+C/bUAijQgVs2pIwZxEquJxCrRrkx40wt5xeU=;
        b=75Pg3V1tGxz1BXPJyNn0tUE7Nqm5tnfaE0NFH9MQuehT24fD+kxV4n9zAt+qF76zs8
         0KfxO2eVHbbJHnBzdWylkq62991YEZ7+7vhDQyMU3HqgY7FLLECjfAgrmMBPhY7zlJna
         qUqlLCjNZBaBTJ7GYDjAqFqHOeg8ilk5E7dOJKzBoaEUnhCjesKHfTUQFcKC3q9ZNdE8
         bzt2R3Eh46jsuYYJOto+gn3+oqrFAUkvoWjrNHgMsnD1BYnDnRb+xxshxQaF4wBHGDvE
         MQQcTc5qRYSUzuASSKl/VsGWkQAT6xKbzcDVH3ryJOeHlmlzwDqNZYLq6zfgbsf75vJ6
         iIlQ==
X-Gm-Message-State: AOAM531ZYUEsrsGADy6FhaNJ3pJsLEBpjBEBT+iXU5u4UCwL+q3+VI3z
        rGq3yJ0s9CgQa3XouT0TwOBL5U+N+eA1SmyHq2MFeg==
X-Google-Smtp-Source: ABdhPJwG4oeunZtfTAqFSdPSvXQ/EGO74OOSjPwKybQKY955Q+Lm+yXaJNDZXx6QkmGxjo5MfMxF2Uv2x7n3YyUuw60=
X-Received: by 2002:a05:6122:2213:b0:31b:76c3:16df with SMTP id
 bb19-20020a056122221300b0031b76c316dfmr7894044vkb.31.1646060809331; Mon, 28
 Feb 2022 07:06:49 -0800 (PST)
MIME-Version: 1.0
References: <20220228113910.1727819-1-amir73il@gmail.com> <20220228113910.1727819-5-amir73il@gmail.com>
In-Reply-To: <20220228113910.1727819-5-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 28 Feb 2022 16:06:38 +0100
Message-ID: <CAJfpegvZefGp9NChm_69Km0FgpxwUs+og-uc2mpMAbH6mZ2azQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] fs: report per-mount io stats
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        containers@lists.linux.dev, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 28 Feb 2022 at 12:39, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Show optional collected per-mount io stats in /proc/<pid>/mountstats
> for filesystems that do not implement their own show_stats() method
> and opted-in to generic per-mount stats with FS_MOUNT_STATS flag.

This would allow some filesystems to report per-mount I/O stats, while
leaving CIFS and NFS reporting a different set of per-sb stats.  This
doesn't sound very clean.

There was an effort to create saner and more efficient interfaces for
per-mount info.  IMO this should be part of that effort instead of
overloading the old interface.

Thanks,
Miklos
