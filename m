Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 123ABC433ED
	for <linux-unionfs@archiver.kernel.org>; Sat, 10 Apr 2021 19:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4D5A61029
	for <linux-unionfs@archiver.kernel.org>; Sat, 10 Apr 2021 19:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhDJTns (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 10 Apr 2021 15:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234536AbhDJTnr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 10 Apr 2021 15:43:47 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9705EC06138B
        for <linux-unionfs@vger.kernel.org>; Sat, 10 Apr 2021 12:43:32 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id w7-20020a1cdf070000b0290125f388fb34so3962643wmg.0
        for <linux-unionfs@vger.kernel.org>; Sat, 10 Apr 2021 12:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fbNXY8Pk/DKf/nAVjWpfCyJHb/drxxFt3BLs/RciLmE=;
        b=uFDdnps6xkxSF1Z9788TAD2ab8huZVrD/mSNs5CUBAFRdgIslYl4wDSaqmeOCuJDFk
         2RW2/fY91dxuawJq28oohniHKxImRVBcwVPgH1cBzpYqGZvKw3hRtY2McpAnKdXHOEm7
         1odwiCLeiQsJPavguWFsNStbfbycvynhCxh/iPTRXH/yNyod5dWIrM0d7JdYt0rsnjYE
         GUb1BvGyStNVtr6YzMtgLU1RchagHz5y2W3cyuXBOBYyDVtDfBgozxTPsLHSIIdqLRjQ
         FWcaqJJ7vQmh7uCPJqaCS8JCaOOJIj3jBYVFT9xfks+W1SgyVhjbkbJK5XkB+o0iyAlL
         4L1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fbNXY8Pk/DKf/nAVjWpfCyJHb/drxxFt3BLs/RciLmE=;
        b=mAIrW0izlIrDykf/NbwOlnWHLvWpOhLi4X7siuo1BeUUyNMAXNHwfR/0N4y9e1qBDL
         GqZueE9z2GAd18Yikm1scHhAntm07FxDORGm591z2J7/Bj+9PCZ1FiJY+Sm321vDcANB
         GyJKEDXEwZVj5hqkqYUwgM3xifMCYatrrr7bnhy7B5hDpjMn287LDdGaoKRd7V35QrKN
         4HZisWo2B5UMEiNzhX9FJ8kCjI0pq6Kh1SOhe59WWq583Tx2dLXuGlwTAix2ZpLlxyL3
         u96+xIVGBxNrpoL2JzhOXssFrxLjx3+906NHxCzTbRStElczicH35m6foshRYPL+EJJd
         +JPQ==
X-Gm-Message-State: AOAM5335wV/tTaBuVdd6c3yC8fsFCK7pYIiZ+klWtbDPwxJ64YFuCTjo
        igUwIl+9vJimwHUBnwyXJ5REnyNzrploKlOFIBO9YA==
X-Google-Smtp-Source: ABdhPJzB4HPQRbKMyUbW0WCASVq55PwvGDx1IkwFeNKJtXt+IbU8p0o+lY3LFY5QbskkNDZS/Bz8rFHGZhGJZpeshmc=
X-Received: by 2002:a7b:c30e:: with SMTP id k14mr19384530wmj.128.1618083811376;
 Sat, 10 Apr 2021 12:43:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAJCQCtTp0aXBssEr4ZXGX=DS_+RyGghmoANCKDdxG59QWu8LVA@mail.gmail.com>
 <CAOQ4uxht70nODhNHNwGFMSqDyOKLXOKrY0H6g849os4BQ7cokA@mail.gmail.com>
 <CAJCQCtRGdBzyskifrYLbBGAAm0g7VeC6GeD7xBN-hRqE3GAWYA@mail.gmail.com>
 <CAOQ4uxhU2KX=jKKL5EZ102z_+6KyVKAOoAzSp2K8i0PMGJUg4A@mail.gmail.com>
 <CAJCQCtTHepsUHjCUAwawC6r6txAZ=XypE5rJOizqxMx9zuR4AA@mail.gmail.com> <CAJCQCtQshgFBvUF2+DLm0=iHhiONu-QCRnB1uNv2dLigT+WfZg@mail.gmail.com>
In-Reply-To: <CAJCQCtQshgFBvUF2+DLm0=iHhiONu-QCRnB1uNv2dLigT+WfZg@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sat, 10 Apr 2021 13:43:15 -0600
Message-ID: <CAJCQCtTg5Cz_GdSTCX-rZDmoB-PDGr2iV=quPWSofbL-Xixapw@mail.gmail.com>
Subject: Re: btrfs+overlayfs: upper fs does not support xattr, falling back to
 index=off and metacopy=off.
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Apr 10, 2021 at 1:42 PM Chris Murphy <lists@colorremedies.com> wrote:
>
> On Sat, Apr 10, 2021 at 1:36 PM Chris Murphy <lists@colorremedies.com> wrote:
> >
> > $ sudo mount -o remount,userxattr /home
> > mount: /home: mount point not mounted or bad option.
> >
> > [   92.573364] BTRFS error (device sda6): unrecognized mount option 'userxattr'
> >
>
> [   63.320831] BTRFS error (device sda6): unrecognized mount option 'user_xattr'
>
> And if I try it with rootflags at boot, boot fails due to mount
> failure due to unrecognized mount option.

These are all with kernel 5.12-rc6


-- 
Chris Murphy
