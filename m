Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E545C433ED
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Apr 2021 09:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F411A611BE
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Apr 2021 09:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhDIJeN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 05:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbhDIJeL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Apr 2021 05:34:11 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA28BC061760
        for <linux-unionfs@vger.kernel.org>; Fri,  9 Apr 2021 02:33:58 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id 2so2609907vsh.4
        for <linux-unionfs@vger.kernel.org>; Fri, 09 Apr 2021 02:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OO9iwsL0KDbtjIAGoYaz7sDHtq5BkOHEGXLIhrYn/Gc=;
        b=QNgB65wm8nudussgpnqTsTnY6OzfdhaIbY75sl0xLLWMkLDqiO2tPa88Sd//ZM3FNF
         3cNp4y3ouiJfghiGt7Z7Fn0zduVsTrOxG+A41HCLFwSCnxcEjTOSJxsB4h0sLf+JKyNr
         sIRVTs/+jWkSiVHOxMij185IbkHm5IkL5chgQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OO9iwsL0KDbtjIAGoYaz7sDHtq5BkOHEGXLIhrYn/Gc=;
        b=LN/78afnZrD3+IjwexZQ7vKPO5Ghg/FsBe0alT/aqb51XpbHOvyKQS03hNEPPbp3QC
         7Xroo+rhcrha/i+gSx7YE+1bvMyAmSNb9FBuoLPnqYBlisXOHQmyKTi/l3fOLnBqWUkL
         TxIhFkmCa2xJQSCWM5TOL00WrdBoUr9mTV3cjYrDZpsOAIkHkfLCvGinFO4OkT2WTFaO
         nrmOe79Qqk+v5sAC7oytG0kTdc2lq1mux/GS8QqxxJ2nP6igh46Jx9H7ETuASuR9F/2A
         3XtDlDELHzj0SkgbpU3x28r3MZETKeJNT/lqWFwWIdJTwLLSpCmsOMbVVZzcgYmWhByR
         SVVA==
X-Gm-Message-State: AOAM533EeIFpnecUR91AQIIpAONdTR7ljqyJLt8z2oSxzwVpGeaMUT+z
        bSQ5Xmeh2Ss72jyva7a2RBPx+krqo7m2toZORRGejw==
X-Google-Smtp-Source: ABdhPJzSw9GxlWN91DIboH/hs+f1E/gx0AB/RwZCeNgWatXdXeFrf7k5sApQq2djiuifLESr6nZra8iW/j5i6NTe7aA=
X-Received: by 2002:a67:6647:: with SMTP id a68mr7643351vsc.21.1617960838037;
 Fri, 09 Apr 2021 02:33:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210309162654.243184-1-amir73il@gmail.com>
In-Reply-To: <20210309162654.243184-1-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 9 Apr 2021 11:33:47 +0200
Message-ID: <CAJfpegvTtq4G0T6T+9TjDFgYSwNVanF-Dt3Wcf_RYfdzTsFJFg@mail.gmail.com>
Subject: Re: [PATCH] ovl: restrict lower null uuid for "xino=auto"
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Fabian <godi.beat@gmx.net>, Kevin Locke <kevin@kevinlocke.name>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Mar 9, 2021 at 5:27 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Commit a888db310195 ("ovl: fix regression with re-formatted lower
> squashfs") attempted to fix a regression with existing setups that
> use a practice that we are trying to discourage.
>
> The discourage part was described this way in the commit message:
> "To avoid the reported regression while still allowing the new features
>  with single lower squashfs, do not allow decoding origin with lower null
>  uuid unless user opted-in to one of the new features that require
>  following the lower inode of non-dir upper (index, xino, metacopy)."
>
> The three mentioned features are disabled by default in Kconfig, so
> it was assumed that if they are enabled, the user opted-in for them.
> Apparently, distros started to configure CONFIG_OVERLAY_FS_XINO_AUTO=y
> some time ago, so users upgrading their kernels can still be affected
> by said regression even though they never opted-in for any new feature.
>
> To fix this, treat "xino=on" as "user opted-in", but not "xino=auto".
> Since we are changing the behavior of "xino=auto" to no longer follow
> to lower origin with null uuid, take this one step further and disable
> xino in that corner case.  To be consistent, disable xino also in cases
> of lower fs without file handle support and upper fs without xattr
> support.
>
> Update documentation w.r.t the new "xino=auto" behavior and fix the out
> dated bits of documentation regarding "xino" and regarding offline
> modifications to lower layers.
>
> Link: https://lore.kernel.org/linux-unionfs/b36a429d7c563730c28d763d4d57a6fc30508a4f.1615216996.git.kevin@kevinlocke.name/
> Fixes: a888db310195 ("ovl: fix regression with re-formatted lower squashfs")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Miklos,
>
> What do you think about this?

Applied.  I removed the Fixes: tag for fear of too eager backport
bots, the said commit is mentioned in the header, so no information is
lost.

Thanks,
Miklos
