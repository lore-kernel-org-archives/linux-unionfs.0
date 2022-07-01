Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A574C43334
	for <linux-unionfs@archiver.kernel.org>; Fri,  1 Jul 2022 14:15:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiGAOPt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 1 Jul 2022 10:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiGAOPs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 1 Jul 2022 10:15:48 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65ED38DAF
        for <linux-unionfs@vger.kernel.org>; Fri,  1 Jul 2022 07:15:47 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id o4so3453308wrh.3
        for <linux-unionfs@vger.kernel.org>; Fri, 01 Jul 2022 07:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=V+i8YManENBXBhU+gQ1UkH5IBmrmkkLqRsWQO3U5Xq8=;
        b=2cHtCqPBZQqjTUpT97gllZCQrQEVVFlNFZOf9GTu1uL0GGHuwSzZWV7U0Af4nmIF6W
         xK55R6+cn2gZ/8BLn4OU99IH296u0yDiYmUZz0QOGwkrY3OnU9eHWBJOz/k2EiWtmsHH
         Y0Rq9jMUfpmX+Xw6fApG6wz8mAWU0IbcSbFZprTJFotUlyI7Nw68+5cOlSm+yafqCRwJ
         anI/vA/45JXTc2PlbnLVEmde6VMyq5tE0YkxS18iWRKBFNI/ZODmnMCN5N8bdhMlLo6Z
         2Q9nXxNe2BBoA5avy/2XhWzIGpa2NyxoXhrO5ZZhwtHxkLS2g3gAn+ObvN1Kj7cEfPrN
         MN3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=V+i8YManENBXBhU+gQ1UkH5IBmrmkkLqRsWQO3U5Xq8=;
        b=MGpquyn2TUIP77bVbNoeygqoGNIBrWqYZSAbdMpF2Fj0OzAF5WQiRp1GQh/YP33FeU
         JJrk7VN0BDCa7LFJPLmkuVJqLYYviMCvTGNsX5BOf2OM8/ws6HxY/m38JXjnkhMydlvg
         Y/eszoGRoIeSEpFryFkvCkbpZ+8h9wvzzalaqIT+w0B4Le+6HuHemoqU8soxMJGusRjX
         sqi9WqRk+L+lkyEtkU8jttLhG4E9t+xzK+qpeHyWQ+1EDI6qB2/98BhoTCGZzkeRIy2S
         m8/4ZNa3Js+oPNo10ssYvdadHmG/u1YApblmBwcq7f2TSIJBiAuJP2hR2oiFRQeJmBjj
         6zxQ==
X-Gm-Message-State: AJIora8kFEMi95EceBI91gEQ098FSpkFPV0mpTJProARA+uajO32nIAS
        /ewq7xTCUE3I2wFwR3jF/8OQXxhtdhKvSrU/KYudND53dw==
X-Google-Smtp-Source: AGRyM1up/ljygGpqP3aiwQwJsxtKqk5ofnLhPkqVTJ/NWMoT4rcc9xBv4if9Dg9ayEexgQ7VIqIN2mbs3Vf4STRqOQ0=
X-Received: by 2002:adf:f186:0:b0:21b:960b:8f9 with SMTP id
 h6-20020adff186000000b0021b960b08f9mr14677351wro.70.1656684946374; Fri, 01
 Jul 2022 07:15:46 -0700 (PDT)
MIME-Version: 1.0
References: <165668469351.28601.2872895377697386439.stgit@olly>
In-Reply-To: <165668469351.28601.2872895377697386439.stgit@olly>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 1 Jul 2022 10:15:35 -0400
Message-ID: <CAHC9VhSBF5oK0x2zw6xemqNn-Zf5p8ih8Q5hWyF9waF1RpzAvA@mail.gmail.com>
Subject: Re: [RFC PATCH] ovl: properly release old cache entries in ovl_cache_get()
To:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jul 1, 2022 at 10:11 AM Paul Moore <paul@paul-moore.com> wrote:
>
> If an old readdir cache entry is found during lookup we need to
> ensure that we drop a reference to the old cache entry before
> we remove it from the cache.
>
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> ---
>  fs/overlayfs/readdir.c |   21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)

I ran across this a few months ago while working on something related
in overlayfs' readdir cache, unfortunately that work has been shelved
for now, but it seems like this bugfix might still have merit,
although I'll leave that decision up to the overlayfs experts; it's
very possible I've missed an important detail and this isn't actually
a bug.

I've done some basic manual testing (kernel boots,
mounting/traversal/accesses are all okay), but nothing exhaustive.

-- 
paul-moore.com
