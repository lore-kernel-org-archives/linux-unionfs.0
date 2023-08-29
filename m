Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 898F5C71153
	for <linux-unionfs@archiver.kernel.org>; Tue, 29 Aug 2023 18:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238620AbjH2S6x (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 14:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238609AbjH2S6d (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Aug 2023 14:58:33 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5A1FC
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Aug 2023 11:58:30 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-99c3c8adb27so594843366b.1
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Aug 2023 11:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1693335509; x=1693940309;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XptbQaF/TmqMzXqMFitdSA+1Ea5JhH7OV4FqHHSEswk=;
        b=MzOH9ntoAa4tre9LGFBbm0kW96r5U6m0Hbco+L7dUsgXWOvDQcwCIAeoavMJ8m0o8F
         ycLlIzAUfuv54nMVhIvc3ZWLr8U3ITmw2eFLzswjLhhs9NiFEzn6u9ynWuCobMDrtaqq
         9ZARfr6rUoH/mZ0FV3yft6KM0QmsdqImsO0Aw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693335509; x=1693940309;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XptbQaF/TmqMzXqMFitdSA+1Ea5JhH7OV4FqHHSEswk=;
        b=TijdfF0ilvxcV/O6KqYhaiZRWCyn5vbHb188Lf/XFXZifkCqruOdepWnSGoxeDJ30h
         UB+pbus6fAsYJm9QE1n/KUqL7DGpGANQlgBCRYFNtP0ZoBG0SxtGN/J8PjjlN6bli1zG
         zyFlPOsPx9cl2+1SL1lo7jATcXnd42R936hwwiO0atBYCaoRXvpH1kWKOclpfexFa7g5
         4kNjRqTjsDmfRwZzUM4Bu2v1hsX8/h1kH9+adQG2zKQvyA4wD+7Hb+tDd2487injmSP/
         XXiA47AiWqtHeaf/zYEDFjLNTp//PljZ8OxRl6coMGneibZzXNLg6MnVeu4Durdzn0J8
         /0KA==
X-Gm-Message-State: AOJu0Yx8ORSNxMoBDPgjEBCgOlcz3mlzEMLAc1FiIWRVDDS2cX29Lrio
        YPypXwpsQzkik+iAcvt3bFNjhPz32V0+K6JLIAD6wnmy
X-Google-Smtp-Source: AGHT+IFNK7j8LrVW+2VEOvrqXNyOkVtoV/TYkqQ5It7Kmq95pNdaVOv/GbhZ366hX3PC0x+5Vxg9aQ==
X-Received: by 2002:a17:906:aadb:b0:99d:fc31:242f with SMTP id kt27-20020a170906aadb00b0099dfc31242fmr21961285ejb.66.1693335509256;
        Tue, 29 Aug 2023 11:58:29 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id d7-20020a1709064c4700b0099bd453357esm6204613ejw.41.2023.08.29.11.58.28
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 11:58:28 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-52a069edca6so6586489a12.3
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Aug 2023 11:58:28 -0700 (PDT)
X-Received: by 2002:a17:906:249:b0:9a1:cbe4:d033 with SMTP id
 9-20020a170906024900b009a1cbe4d033mr16078457ejl.53.1693335507850; Tue, 29 Aug
 2023 11:58:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230829103512.2245736-1-amir73il@gmail.com>
In-Reply-To: <20230829103512.2245736-1-amir73il@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 29 Aug 2023 11:58:11 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiVaYx8+S4KFK0h_PdvG_-WpTgUagTcmt70_13LbHas3g@mail.gmail.com>
Message-ID: <CAHk-=wiVaYx8+S4KFK0h_PdvG_-WpTgUagTcmt70_13LbHas3g@mail.gmail.com>
Subject: Re: [GIT PULL] overlayfs update for 6.6
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <brauner@kernel.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 29 Aug 2023 at 03:35, Amir Goldstein <amir73il@gmail.com> wrote:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git overlayfs-next

Please send me a pull with signed tag, not a bare branch.

I know you can do that, since you've done that before...

               Linus
