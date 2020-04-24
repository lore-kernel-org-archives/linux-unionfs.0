Return-Path: <SRS0=0l2z=6I=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74792C5518A
	for <linux-unionfs@archiver.kernel.org>; Fri, 24 Apr 2020 06:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D1D02076C
	for <linux-unionfs@archiver.kernel.org>; Fri, 24 Apr 2020 06:02:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fhpQv0G7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgDXGCM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 24 Apr 2020 02:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725823AbgDXGCM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 24 Apr 2020 02:02:12 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14657C09B045
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Apr 2020 23:02:12 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id e9so9159319iok.9
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Apr 2020 23:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lhm//PRyLWRG3+Zw7tpwTG96zUqrHWxhgVRttPdiOAY=;
        b=fhpQv0G7B7gAZjHYt4Y+cmgPYJ4+GTLDXLoumcyywIi0c9F7dPWI5EaeVxOOrz2WIl
         HmIwcS9/hLWa2etqa9QjmlAEcAF8klm+VWLuOybEm1D9efLe16q3TvnwoZierFJLPs1q
         ic12ukLwmtvvwBXAhmJaZbPbd0yLuOKVg3HtBxLVx4WsnS1X3EmAeFNLcm3T5llYXjmJ
         V+epodTfslLxEUo0esJxO6Q7+kf7j4NasFCjBYNMzFBthG/aXea3kgQMf2CTELwz7DuW
         6xzLSvfFcqI+EpJn6dzsYh2lnQPpPiLBnWV+l0AosYPx6tx27Az85f714bhXPQVGIYZw
         g7lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lhm//PRyLWRG3+Zw7tpwTG96zUqrHWxhgVRttPdiOAY=;
        b=hofsMIRbknYyCcIYIBb54z6b+VV3XA1uc6JigZzRRNaqGeKNacfJcX2ywnHUCFQpPR
         hmwKb8msNoC9OjpRib7l8nmM8ciATCpGpYDbGhxsSXFPaCU2RkK5A3Va8ueTEupQV1XJ
         UXx+qckarhG3H7LG0lqdvfRK9kGt+aqg4vZ0BMaeQhr47J8+xmwpCza2jyF/gPZG4NTJ
         9w4sLsIbEdDASZmYiDG+XlKxT4mAxyywZsqFsI8Xgr3xh0ZVbKi3ndj1pDOmiiI/O0XT
         jZWu6gdKEpsr5Ku7ZowY/rPDs5XU0qlLYctcMxFpn46dbuuoVaX5+EBCq3txjWseKhpf
         ibVA==
X-Gm-Message-State: AGi0Pub1bfsac4KOkenvGbkYXztEbKvFoQ9LW+LuNSolkHYNo9fGTfE/
        WzWGMBMOmEzkUkbVWGPm/Po0tAoOP6NSzs01ODYq/II3
X-Google-Smtp-Source: APiQypIm1OrCW+yv4mWPbus/7gYDecDZ7XD0jB/nUOqdUlxGoLN2TidjvbHQ3dm9DWVTHxC4FaaC83vP07sR2mMWma0=
X-Received: by 2002:a02:4b03:: with SMTP id q3mr6657270jaa.30.1587708131238;
 Thu, 23 Apr 2020 23:02:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200422102740.6670-1-cgxu519@mykernel.net> <CAOQ4uxj5JsWOgQ8vHqTkAXx16Y9URTgNpALY5XO=VNUAMTkOMw@mail.gmail.com>
 <171a49cb02a.e6962d897896.4484083556616944063@mykernel.net>
In-Reply-To: <171a49cb02a.e6962d897896.4484083556616944063@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 24 Apr 2020 09:02:00 +0300
Message-ID: <CAOQ4uxhowSRqD9kSoUHg+D8-RdxF8vBbTauTchgnpG5MoSNSEA@mail.gmail.com>
Subject: Re: [PATCH v4] ovl: whiteout inode sharing
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

>  > > +               case OPT_WHITEOUT_LINK_MAX:
>  > > +                       if (match_int(&args[0], &link_max))
>  > > +                               return -EINVAL;
>  > > +                       if (link_max < ovl_whiteout_link_max_def)
>  > > +                               config->whiteout_link_max = link_max;
>  >
>  > Why not allow link_max > ovl_whiteout_link_max_def?
>  > admin may want to disable ovl_whiteout_link_max_def by default
>  > in module parameter, but allow it for specific overlay instances.
>  >
>
> In this use case, seems we don't need module param any more, we just need to set  default value for option.
>
> I would like to treate module param as a total switch, so that it could disable the feathre for all instances at the same time.
> I think sometimes it's helpful for lazy admin(like me).
>

I am not convinced.

lazy admin could very well want to disable whiteout_link_max by default,
but allow user to specify whiteout_link_max for a specific mount.

In fact, in order to preserve existing behavior and not cause regression with
some special filesystems, distros could decide that default disabled is
a reasonable choice.

I don't understand at all what the purpose of this limitation is.

Thanks,
Amir.
