Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A023C04A68
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 Jul 2022 13:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiG0NYI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 27 Jul 2022 09:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiG0NYH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 27 Jul 2022 09:24:07 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089602E6B2
        for <linux-unionfs@vger.kernel.org>; Wed, 27 Jul 2022 06:24:07 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id j22so31495241ejs.2
        for <linux-unionfs@vger.kernel.org>; Wed, 27 Jul 2022 06:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FHMkpB5t7hmbPWWLKlbDM5K2ZorzaQLbHtU4+jaalmQ=;
        b=oddts4B12U+6PCzk4eaFHpzKf0/AWjqXcJsh2FsYPvng1kZorzMkNff/nvoIyfbZMH
         oKMKGa9FPYuHC6KVm4My/G0pVyfXO17wO2s1Etx2EMTXxL3/TGQdmuYb59Z/pXnrU9xO
         YBw1URWs1cQ8zFuef52zRvSdb8Bvr26tmTZ3Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FHMkpB5t7hmbPWWLKlbDM5K2ZorzaQLbHtU4+jaalmQ=;
        b=qGADh1PEFLu0e0iKiK1ihRoFmulm4oIyhiT7SebPNSdQBM0Q/WdB7lz0Xx4J2mcDk8
         zbM4M6pnRuZPQq5q8bCCME7PoI5FmR7wYZvn5vBnG8WYMxkfLkRPBuvGFEyqHZbR5/4H
         xngLd71xAzg4QtUQYvaNVaFq85fMR4JHkoNgmDxQgZO9dTgvBB8LdTVrHBy/ocmcuLaF
         SD3j+neflKf07ODMYfYvPvwr69xNxh8DqWS2Q16KrVAdYQJhygyZjtG3y+g7kzWekZJd
         5feaE3SpNbzGxOe6Csg7wfvV73iB+x062rmRbmPW9P6xYl/P48r8o5gpsQ8vcyr0Tgfk
         gzLQ==
X-Gm-Message-State: AJIora/YoKdYGlxtl/UpShZs6Udyumfha4lL2voLuEll5LCUdYxir3rD
        +SpPk1mjOZsKFOsVdB6lPnIwdUT6a2xdyh9NyBkqTdkOG9Pwiw==
X-Google-Smtp-Source: AGRyM1uJuZCTUizUZkLY1fl9uNE3WAVaWRFsoUax4sRn1yFc1O3sJwP8uWV2lS+qNxCZkgECeYMKGj9UHQ+DlXPTFy8=
X-Received: by 2002:a17:907:2854:b0:72b:7daf:cc0d with SMTP id
 el20-20020a170907285400b0072b7dafcc0dmr17709950ejc.524.1658928245376; Wed, 27
 Jul 2022 06:24:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220712110933.2646293-1-williamsukatube@163.com>
In-Reply-To: <20220712110933.2646293-1-williamsukatube@163.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 27 Jul 2022 15:23:54 +0200
Message-ID: <CAJfpegsBbRaqG3UeVhiXhPsFX-6kZf+OGT9Rxu93vSfoepgbfw@mail.gmail.com>
Subject: Re: [PATCH -next] ovl: Fix spelling mistakes and cleanup code
To:     williamsukatube@163.com
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        William Dean <williamsukatube@gmail.com>,
        Hacash Robot <hacashRobot@santino.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 12 Jul 2022 at 13:10, <williamsukatube@163.com> wrote:
>
> From: William Dean <williamsukatube@gmail.com>
>
> First, fix follow spelling misktakes:
>         decendant  ==> descendant
>         indentify  ==> identify

I will accept a patch fixing typos, but...

> Second, delete extra blank line and add blank line where
> appropriate to make code format more standardized.

...not this.

Thanks,
Miklos
