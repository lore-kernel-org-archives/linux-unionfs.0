Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE917C433F5
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Sep 2021 08:04:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9DC3610A4
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Sep 2021 08:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348939AbhI3IF6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 30 Sep 2021 04:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348950AbhI3IEb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 30 Sep 2021 04:04:31 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A32C06161C
        for <linux-unionfs@vger.kernel.org>; Thu, 30 Sep 2021 01:02:24 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id y141so6244347vsy.5
        for <linux-unionfs@vger.kernel.org>; Thu, 30 Sep 2021 01:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=92U70qC982rmm8b+Okt4L8pm/v/AS9jJLK7HS+uEBAg=;
        b=dJoHRLneh7d55by8zbIYaGBb1Rl5vukOa2sMqN0mTBEiJrherDgmBPFsemKSLFVIIe
         r9Upb57nqtjE/LiMirmmwrAbAJMjUO+ShYQ3pEgcst0GE0a0XkiLldVLtCyvh15yQWwP
         fz+pGPiJwvoMRbsSJC2db+Fg+w6R/24w5Gl58=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=92U70qC982rmm8b+Okt4L8pm/v/AS9jJLK7HS+uEBAg=;
        b=MbFzeU56FXjSedxRA5Qgmml6rh4arg4Vig9Wqfq5/uboqVcNaRGfID34bNepPWii/I
         OEiMJ3CjU4Cvy2W2LUENwEZj7vBs/s8ByGdtHF/ajc4cBzQbNVcSGcuAdHUOztKGAO7v
         CpbwmtMWuaTF7/Lzqd629gEoQG5g8+8Mq31sBz0R9xop6drYt/CclvUFD3pucnkOQw84
         M5fuOB3mx/Y8RdbquG3xiK5XNuqm0jbRVI1mN8YUOOiCfXaC5HCNp+O7YEXXw+Z0Cor4
         AdBgLSVoXpbUuj5tPK2w+pu8o4duf8bLf9lzh+CBY5iUuzkOM0cOfxXnVEyuExe3n/oj
         bL9A==
X-Gm-Message-State: AOAM530XaOE/IKAYe1m7AdR4LIm5RVDwc6xhaOivJMRIk9hSGSLmesdL
        rR/tgWEiaTN/wmwlWdvPQ7JKtJgANl2r6i0m5vBagA==
X-Google-Smtp-Source: ABdhPJyTheh7nHP1WtcTjy6Y15KZVT5U1wOuH/lf5ouCdlwrNToNvJ/MhaAaqCFSCtFP8YJNBtiFUCja7PXkcw0RBok=
X-Received: by 2002:a67:a644:: with SMTP id r4mr2016362vsh.24.1632988944102;
 Thu, 30 Sep 2021 01:02:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210928124757.117556-1-cgxu519@mykernel.net> <2ef5a5e3-234f-5b1b-5463-726d200e7e96@oppo.com>
In-Reply-To: <2ef5a5e3-234f-5b1b-5463-726d200e7e96@oppo.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 30 Sep 2021 10:02:13 +0200
Message-ID: <CAJfpegsJuprveXYHCz7wu11nZU2ZG+pOQ6Jy--PSO6Km1VnTng@mail.gmail.com>
Subject: Re: [PATCH] ovl: set overlayfs inode's a_ops->direct_IO properly
To:     Huang Jianan <huangjianan@oppo.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <mszeredi@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 30 Sept 2021 at 08:52, Huang Jianan <huangjianan@oppo.com> wrote:
>
> This patch can ensure that loop devices based on erofs and overlayfs
> can't set dio through __loop_update_dio.

So does this mean that you tested the "loop on overlayfs on erofs"
setup and it works?

Thanks,
Miklos
