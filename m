Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F0EEE49A0
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Aug 2023 14:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236687AbjHWOwm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 23 Aug 2023 10:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234555AbjHWOwm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 23 Aug 2023 10:52:42 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685DAFB
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Aug 2023 07:52:40 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-99c1f6f3884so744531066b.0
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Aug 2023 07:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1692802359; x=1693407159;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1UCVUE9RUmrQ5iGDI8o/OkqxuzPzyNMlVzWnJjp8rVI=;
        b=dPfP98jj9SQhWE7MuZ4l7vrDMlxpFyknwrUps5I7ohlhYLnzzt3yqvKDGDFB6YigmD
         wAMlnw6gqeHj2PIG70fNbeZGrg4ENou3mDEWOrRKHiFoz4HU1JwkLkTUaGfmY/iavljr
         fkZZdhjpYnGzvsx/A6DEuQBVqN/3IQmPDb4pc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692802359; x=1693407159;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1UCVUE9RUmrQ5iGDI8o/OkqxuzPzyNMlVzWnJjp8rVI=;
        b=h0khMljRnmMCsP+dz4axRKBny0DPuVMhg2sXul6fFvmiDMxul/d3FrTn2Dv5/BCDYB
         oWuhHErV+MpCCq1vwVsuKeBj6nGY0omkhhW29t4wRqinAXdMLljTpdf49GZDPMS8W1hz
         RKzJAzpbPwQ3kBNxUB+EdFY2ZKb0egQn1tFaookJpqnLG9n8zHMxWgYRT6g2DxK9Pff+
         +WBuzEeD2tTChYzBhlg5GAEQ/S9kbknP/Kq5Fi1fzn1XfIT5wHUgp8WfwI89pToxu2oX
         AIxVFIliXz553ILwK9NWA9GYunUz8h+FhiSm9vYxlfg4hE0Vwc2a4DX0jRu6bIx5Z1HB
         YIaA==
X-Gm-Message-State: AOJu0YzJZByEyXOzMoMqlvw4FDoDCRtKw6QJgbMc1S14BhFtpeeOtUuw
        6/2NSPm8EObsMWT+94+U8xw+cn2d+oNiNDcv8i+NpCvLaF469YTa5yQ=
X-Google-Smtp-Source: AGHT+IFOjEyVc3BD+NdHH2PHC8g3uwAJyuZqOO3mZp6TsSpgVR7QOLcWd/t5dsQ4eDmLUUFy6bC82eFMSnnS4lkIXuE=
X-Received: by 2002:a17:907:2cd6:b0:9a1:f668:dae4 with SMTP id
 hg22-20020a1709072cd600b009a1f668dae4mr479468ejc.3.1692802358860; Wed, 23 Aug
 2023 07:52:38 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
 <CAL7ro1HMZxXZDyJG9yikx+KCd3HsYPZdgk7SJBLAGWBKVrYD6g@mail.gmail.com>
 <CAJfpeguerGOWAELyd7oY=z8Y-1sGG6OY9MurhCB7-kegxZ-wmQ@mail.gmail.com>
 <CAL7ro1Hr43u7CoyHwVOzxp+pcN2MHEf18B7+CZk=HFw=viGz8A@mail.gmail.com>
 <CAL7ro1FagGOZZg9yeWvWDov6L3prrjJE-+Yre1CJuViT7idNYw@mail.gmail.com>
 <CAOQ4uxhVXrNfhWc-EsunfyWyrJDFCjYu8GeAtvN0__QTfjtV5A@mail.gmail.com>
 <CAL7ro1GS9ieN=ZuDLE9mreiiYH4KUK6xWxp40hS-7ZTzf+r6Gg@mail.gmail.com> <CAOQ4uxhYH1SH5TbYfARDkep5p+xspUX2gq1HgMyLnv7J4=1emg@mail.gmail.com>
In-Reply-To: <CAOQ4uxhYH1SH5TbYfARDkep5p+xspUX2gq1HgMyLnv7J4=1emg@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 23 Aug 2023 16:52:27 +0200
Message-ID: <CAJfpegsv3fHwutkEq7S8PV9fYWC07BRUE8GMEpsnK1XkE2hb5w@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, 23 Aug 2023 at 16:43, Amir Goldstein <amir73il@gmail.com> wrote:

> If we do this, then both overlay.whiteout and overlay.xattr_whiteouts
> xattrs will be xattrs that the overlayfs driver never sets.
> It's a precedent, but as long as it is properly documented and encoded
> in fstests, I will be fine with it. Not sure about Miklos.

Firstly I need to properly understand the proposal.  At this point I'm
not sure what overlay.whiteout is supposed to mean.   Does it mean the
same as a whiteout (chrdev(0,0))?  Or does it mean that overlayfs
should not treat it as a whiteout, but instead transform that into a
chrdev(0,0) for the top overlay to interpret as a whiteout?  Or
something else?

Thanks,
Miklos
