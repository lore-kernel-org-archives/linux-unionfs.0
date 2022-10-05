Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F20A8C433F5
	for <linux-unionfs@archiver.kernel.org>; Wed,  5 Oct 2022 14:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiJEOkY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 5 Oct 2022 10:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiJEOkX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 5 Oct 2022 10:40:23 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CC631DD2
        for <linux-unionfs@vger.kernel.org>; Wed,  5 Oct 2022 07:40:22 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id a13so23324656edj.0
        for <linux-unionfs@vger.kernel.org>; Wed, 05 Oct 2022 07:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=1npcSRBJ7PO3bk52I4TiZZqyr2go37XvM6M7pRWaQTU=;
        b=ge2MeuQpUWKgYk1cf2md+tnifiDoAYsSdFbyramvwFt9I228RAJMOPPgT14IHn9v12
         6C1F5/zc8hHCGVyPobdykrXJ+hmwdW/U/FyZmUcPqy9sDk4EmuIFNu1jNRk6tQ+1cekk
         /soa3ZK3ItTEar/SWs3SDskDERwazsnM+c498=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=1npcSRBJ7PO3bk52I4TiZZqyr2go37XvM6M7pRWaQTU=;
        b=jHwPn4oJ65WWgOukv+8hJCs84d2c7gehRkokvArmdgXpJoornBY03ABCO/gRjpQEVe
         uLMhfZU9aQgPUVWqgEnl4XI8aXFl5ylKGjmX763n6woat7aoJfuMmHY0pSqTw1fhOfT+
         AQ8MZkXAdODI0PPWwh4Yl6x6Hrt17Bk6Fv1usTcKmlf38HsM0GzmtlRR0Erj7/3auwAm
         LHrXfKAH4Jvuw+zIRBrIzMovYQUQrgY87Nzy/FPQjH8GvMEUX3e9KGXxcYQ2h423WXSd
         Bb748J4IJdE9EjZbk0WxUm6Pxc5dFZihzy7iDV1QH8312Kj5vgLgamBxWHoW5Sl8Ob82
         c9+A==
X-Gm-Message-State: ACrzQf2bi95jztdpkwgpCSdhZmE2Q3x3xivzCSB9BStHhm8g5tp+oTsi
        Qmq3HS5A3Po+r6E/PuIZK2+dYmby0C0xNZTrgPjKMA==
X-Google-Smtp-Source: AMsMyM721GWiaiYF8Wds1lYCp6FGX4CmgL78gc2lSi2/xr5DmVQS4VGO0Opvb3UKTjBBqh1xL1cl8xTz7+glpMDh4Ew=
X-Received: by 2002:a50:fc0a:0:b0:458:73c0:7e04 with SMTP id
 i10-20020a50fc0a000000b0045873c07e04mr86310edr.270.1664980821039; Wed, 05 Oct
 2022 07:40:21 -0700 (PDT)
MIME-Version: 1.0
References: <20221003123040.900827-1-amir73il@gmail.com> <20221003123040.900827-3-amir73il@gmail.com>
In-Reply-To: <20221003123040.900827-3-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 5 Oct 2022 16:40:10 +0200
Message-ID: <CAJfpeguiGqdSZVwsx_MrLd2MLvLMAkz58NjCMHZehpWZCK5fFw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ovl: remove privs in ovl_fallocate()
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Yang Xu <xuyang2018.jy@fujitsu.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Filipe Manana <fdmanana@kernel.org>,
        linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 3 Oct 2022 at 14:30, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Underlying fs doesn't remove privs because fallocate is called with
> privileged mounter credentials.
>
> This fixes some failure in fstests generic/683..687.
>
> Fixes: aab8848cee5e ("ovl: add ovl_fallocate()")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Acked-by: Miklos Szeredi <mszeredi@redhat.com>

Christian, please feel free to take these if you already have a bunch
of related patches.

Thanks,
Miklos
