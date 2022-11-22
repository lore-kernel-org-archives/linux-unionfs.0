Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A4EC433FE
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Nov 2022 21:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbiKVVXY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 22 Nov 2022 16:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbiKVVXW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Nov 2022 16:23:22 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD752250E
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Nov 2022 13:23:21 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id b2so11870357iof.12
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Nov 2022 13:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=io661+dNfxoEO20qUW/6J+6nYl2fudHXUp0XJ6CzRak=;
        b=rcn5Ssf6R9mCT4CzmKOXenY+pbjaS92fqt2NvtqqkmlAadHSvRkAMAYdSrfUfIwK5/
         vvFdgrWUY/TpsHqBTVKNHJgbrtVOqGVhEsrW202OSXK0WzyfFil/cA7+XwW7MO5F57CP
         b0SopjqTUfk16jHO7iUpcUOyy5+k3AFma6MGzbjbNuJ7UJ1/UrQpi6dO/J2dHCrLOr+V
         cOA1GbZ+WjVAMBeKONYIaL1nzqGJ+HFoGjlixnLpeo05BVGBnfI8tTzIWCugDwDv+xWW
         gCM/OeN4tP0JUbqUwD7K7yBbDnrOu5Kt7ZhHoT3JtRZcx92Clbcnamf6wgiC8DaGMlnE
         rHKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=io661+dNfxoEO20qUW/6J+6nYl2fudHXUp0XJ6CzRak=;
        b=OoEza/+eej5KOcrCN7KLlD46DDr9nRrcxbh3W1euQ/HF/ltmNWgEI+ziyqxlhFlP8M
         DWD4GA1w8fbMU0DJrzI0OiLgHY1pWjkwp8TDKV74OO1m52kAOVFBivCrYafK9SVUJMv0
         z63hm1At3b87/h+oGIAkMfzgPMAIyVpJQhXFqchYCW+2mM81urQU+BtdSp16S3zzELfj
         uk29VWpJSqACMUUOvqobq4FYbf4zWZypl4i3r1xIBsGGQonIWf8MeyHih8n61sLV9jnk
         qFqSrOg/Zl1M/rZ/TmZ12JP7/gR3/9Bnc9Cjd7xYdHBD3ntvWRM6A8OlEFtezWHOVctd
         q0dw==
X-Gm-Message-State: ANoB5pmqWV7TzsX9Wl6Kj2i5ubmqSVDn8CrAbmrsKaI0x7dT5p+FjJU+
        1jzvAFm0LIiFNnNxvTPEj37G6gWfGNSUzc49bG24iw==
X-Google-Smtp-Source: AA0mqf6j27rtk5QqfpU1n2G7f0HKRuEXryQzebEWQwgQKaNiSIdYcrTiMD+WuvwIC+GwzdJAlIKU/J1aJVvLyUVGoyQ=
X-Received: by 2002:a02:7115:0:b0:36f:a831:4497 with SMTP id
 n21-20020a027115000000b0036fa8314497mr11958860jac.209.1669152201047; Tue, 22
 Nov 2022 13:23:21 -0800 (PST)
MIME-Version: 1.0
References: <20221122021536.1629178-1-drosen@google.com> <20221122021536.1629178-5-drosen@google.com>
 <CAOQ4uxiVqR_HxCytweO_uKR=gdRHTjGG9SgHaNTFb1+5b6ucGQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxiVqR_HxCytweO_uKR=gdRHTjGG9SgHaNTFb1+5b6ucGQ@mail.gmail.com>
From:   Daniel Rosenberg <drosen@google.com>
Date:   Tue, 22 Nov 2022 13:23:09 -0800
Message-ID: <CA+PiJmR4rtSHveW_wntt5X2g6zOwarSg3mseRUyo9mSD8ZfyRg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 04/21] fuse: Add fuse-bpf, a stacked fs extension
 for FUSE
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@android.com,
        Paul Lawrence <paullawrence@google.com>,
        Alessio Balsini <balsini@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Nov 22, 2022 at 2:19 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> I hope there is a better way than this macro...
> Haven't studied the patches enough to be able to suggest one.
>
> Thanks,
> Amir.

I'm certainly open to suggestions there. Currently the main thing
stopping us from moving away from that macro are the four
functions/var args we pass in. We've thought about alternatives there,
but we haven't found one we like so far. Since we've refactored all
the uses of the macro into function calls, we can avoid most of it
now. The ugliest bit would be moving the var args into a struct and
passing it in as a void*. Then we could have all the function
signatures match and pass them as function pointers. The remaining
things we use the macro for could either be pushed into the struct, or
extra boilerplate around the function call.
