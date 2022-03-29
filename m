Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B69C433F5
	for <linux-unionfs@archiver.kernel.org>; Tue, 29 Mar 2022 12:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236283AbiC2M1z (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 08:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236297AbiC2M1T (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Mar 2022 08:27:19 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791984D9C3
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 05:25:36 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id j15so34741709eje.9
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 05:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GH31873XPQjzp7m2Icv5/8E30NAaUtm9H/Qz6YpaYgI=;
        b=IJ0FvMS/e65wDZILJmOyi617GiHYNPVRu3SqiviO+EL/bf+8Pp4T20qHruB/UvjyAC
         Uz1iXWYQVPw8Add6VjnKbu6/yUov/1CylLnze1BSz4f0qQGaqVdniA4O5q9WggDq6+GQ
         fejs6FVK1U6QLFimZQFuzHCl0JxPm5zVLTZ6Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GH31873XPQjzp7m2Icv5/8E30NAaUtm9H/Qz6YpaYgI=;
        b=merJIpaLDkYxAxswdWf/b2651UVmI97Sd7oze97Ldw0Q5IM5XAnNx1pK4BKfhrM4em
         zXMdQg7+SOk1LiEMJH2btGNQQfz9oZRl8oUifGucEwNk09Pt3pu2qqfI47BqdVyDgdK0
         UyYZNBz3UxPLuCcv+M5vqJNaDhkubQYsgSYoI0FSsV5vFAagtVKfRP4Zd4a6FJ207Mte
         EKjyt5A1jblGO5B8eXWKGJuSrHFI6J4eAQX7ufir12wnzQPKfOSVYCKZnZjrgO02Iqdq
         ACTYxOcC6solKqloqHFXXzLBE0mLHSnZD6Ze9tkrGI/ou4RdH65uQsrmN5RUp8ActMbz
         26gA==
X-Gm-Message-State: AOAM532NVgMz89EMLPHC+CGM/kBFta3cu3x+ydeH/GSNsgF+yR3/HOJQ
        yqOgp1Wa5jUjrKSsJDuV7ux8yUh7HTEKBYQ4akUmeA==
X-Google-Smtp-Source: ABdhPJzgXCVcSQOZnkZMcy/8DojiZgvt0i90eA8tHSsTjsMpZ5Mvb9My3MQmJt9Bg8ngopFVL+0DXUlhfZEDcwFuhYE=
X-Received: by 2002:a17:907:62aa:b0:6e0:f208:b869 with SMTP id
 nd42-20020a17090762aa00b006e0f208b869mr15570930ejc.270.1648556734991; Tue, 29
 Mar 2022 05:25:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220329103526.1207086-1-brauner@kernel.org>
In-Reply-To: <20220329103526.1207086-1-brauner@kernel.org>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 29 Mar 2022 14:25:23 +0200
Message-ID: <CAJfpegvrv6MTx_4sVSD_5zKtWs1KMDwbBA5egegueU87xws24Q@mail.gmail.com>
Subject: Re: [PATCH 00/18] overlay: support idmapped layers
To:     Christian Brauner <brauner@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigoca@microsoft.com>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 29 Mar 2022 at 12:35, Christian Brauner <brauner@kernel.org> wrote:
>
> From: "Christian Brauner (Microsoft)" <brauner@kernel.org>
>
> Hey,
>
> This adds support for mounting overlay on top of idmapped layers.

Looks good at first glance.

I'm wondering if there's a way to deduplicate the info stored in
ovl_entry and ovl_inode, but that can come later...

Thanks,
Miklos
