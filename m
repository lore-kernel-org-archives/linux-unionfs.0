Return-Path: <SRS0=HYNE=EL=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26EA0C00A89
	for <linux-unionfs@archiver.kernel.org>; Thu,  5 Nov 2020 08:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4556206D4
	for <linux-unionfs@archiver.kernel.org>; Thu,  5 Nov 2020 08:07:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WkFmaEIp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgKEIHi (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 5 Nov 2020 03:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgKEIHi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 5 Nov 2020 03:07:38 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256EDC0613CF
        for <linux-unionfs@vger.kernel.org>; Thu,  5 Nov 2020 00:07:38 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id x20so590624ilj.8
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Nov 2020 00:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vjGzBnLg2egmuZbzshWXwhb3thqheURjec714BuDlBg=;
        b=WkFmaEIpS+ZVHRUGIpYFmDRBmBWy1p2sKgza8wNlKNQgJ0OQACp9iG+Y9KENHTMl0d
         i+MHhiqNhp9iH117Sj2jjXJcG8xeDoyDBYu/fpkguaZeJgOMHpopiO5wzZuKKyTrRpql
         FtzSnV+C52E7ThqLQKr7yybyUCrNkoGNMvOXjm5AZxWOP7bL9e5twCbYYkrodhA55sAa
         dw/81mMgOl7tUvPsdSnitRSiPzy6+AYCZhgR+lQ3wMEIorawXigdUvUr3mWD2DLbxWcu
         /NpJqRabh6vO0aFNl97mC2HFVssG8SGccnLdQnAOm/pKZZPbBtg15hkwptZBQGBzz1BZ
         Sfaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vjGzBnLg2egmuZbzshWXwhb3thqheURjec714BuDlBg=;
        b=SVxBo262QfxMkc115x01qL5F1g4M94BEPzFlAqA+pmguRuYs2bPcXM3lTpI4lZu8Yr
         gl2M7ZXD+uT5M9H8ybZePzxJJCqdwDH9gup3XMxxGfanxjLtgj9VFY/KIj/DN1owcw/0
         WkbBM/3YaUZjiXHra1O2GQ5gdCVtuywgoEGAKZa7fvN5TF9pbZUWFHHnfE0grZK4k8hM
         VeiNwnzGdVSay6JKvUoE0zNBrUPFsVorHK1Ng8/EUMOejo2arnRF8sCyEu0Yk7DOY9Rf
         ck7VfSK8ZRevPjmYo413z8bx29Jd/F7Lneq9Z5QsQL0kBKH9+huzPGGmcu+rPDy0HwPa
         1zeA==
X-Gm-Message-State: AOAM531o9r8unCQgs4O1NWXBm4qat+ylrSYQIgzlZ1NxTTiAHz8Bk+Wt
        fD0945bGBbnWGf0kz93xJ2P7I/bLP2WRhFtEOlzLBhqd1rE=
X-Google-Smtp-Source: ABdhPJzQYWAZ1thXOx4UN3pA8i7jo4nFty2fGPsOo5h4A3cH3PGqRGYA5afvr6pF3fZOB1Rdp0wBF3C/kvp2Z3ax5mI=
X-Received: by 2002:a05:6e02:14c9:: with SMTP id o9mr1027480ilk.137.1604563657451;
 Thu, 05 Nov 2020 00:07:37 -0800 (PST)
MIME-Version: 1.0
References: <17596177926.d559c8b77834.5766617584799741474@mykernel.net>
In-Reply-To: <17596177926.d559c8b77834.5766617584799741474@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 5 Nov 2020 10:07:26 +0200
Message-ID: <CAOQ4uxgpmC_B_uWpnMXDrv9BOQ-rsMxyRTc+qC3dT72sqR8ndg@mail.gmail.com>
Subject: Re: a question about opening file
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     linux-unionfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Nov 5, 2020 at 6:39 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Hello,
>
> I have a question about opening file of underlying filesystem in overlayfs,
>
> why we use overlayfs' path(vfsmount/dentry) struct for underlying fs' file
>
> in ovl_open_realfile()?  Is it by design?

Sure. open_with_fake_path() is only used by overlayfs.

IIRC, one of the reasons was to display the user expected path in
/proc/<pid>/maps.
There may have been other reasons.

Thanks,
Amir.

>
>
> Thanks,
> Chengguang
