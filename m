Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88274CA553E
	for <linux-unionfs@archiver.kernel.org>; Thu, 14 Sep 2023 13:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238924AbjINNZL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 14 Sep 2023 09:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235397AbjINNZK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Sep 2023 09:25:10 -0400
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D8B1BEB
        for <linux-unionfs@vger.kernel.org>; Thu, 14 Sep 2023 06:25:06 -0700 (PDT)
Received: by mail-vk1-xa2b.google.com with SMTP id 71dfb90a1353d-4935f87ca26so441026e0c.3
        for <linux-unionfs@vger.kernel.org>; Thu, 14 Sep 2023 06:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694697905; x=1695302705; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g8g7cbRHNiBB7kLy/+15nJEy1q3Dnsjo9urJij9aaIE=;
        b=e9yfJqnCIX7S+StO+WvZxYnKFo4IzBUb704vtLupqpFie/mCrZGjQC/BaDAknkt1VD
         JdP8CNiru+hbgEeRMYsgLHhtAhVj20Jx2NTDIJk394d0r1U6pmO7A/rL8LYMp0XmJacu
         n9Lq0V2buvgTs+XBbo51dMJgwfw/i7sHG6/KowziRwkYSFzMtV/ZkX/voyHtW5RvhnIO
         2Q5ApoRKxs4KDoEeTzHVXwu+JYaqQBxYDomc7UWTyhsgX4kOk65MLaoSdoK2e2e81Z4T
         X1l7Jl/VbfUbQY4449EfdCTjMTQ2/x/Fe3Kkbr+8LkjsGFTcCYerZKSLYPFQZdO7ridf
         Lqmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694697905; x=1695302705;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g8g7cbRHNiBB7kLy/+15nJEy1q3Dnsjo9urJij9aaIE=;
        b=h0801abDRc/zRNhHvbtg7tNPda8llWdu1/1aWnLIGExLTJXMw6JD5QioquEhXxYUmz
         sucUhXuY/TcbpaJ0IC6FsGIMnfRB/k5/k7j/DpxOBhCWyH25Ab5ftIX7pYfI8zUJ4EEI
         lNq6FqpEdffUjgnOpIZ87RsR+6ICwyqWbpViE2hbwqz43pF1W8Sn98lFHC0KxoEU3Qzk
         qWxxZQKSAzjiDPUiqpGfmN2FOzlceJEuuD/KDComTKRA/4usBmtrboc1gviUXcGuYXbT
         W7NEEF+xsqLxtiZLf/n+XOXWy3niIRGNkM6d+czm9xHEHUhzy0lPQCdqVJsbgDurMIaR
         Ddfw==
X-Gm-Message-State: AOJu0Yx4Joja/6NDQRIy53BENMqlPS4zxlC37N4JHCYWuormn/XFpzRv
        u+M3KH4Vg0dEzYk50Ys19jTzv9VDTVENYlLdkjIbzbYL
X-Google-Smtp-Source: AGHT+IH7odsW9+Jh4wQazpPfnhEMWvhHwdmJIXKKqe0W8X4g0avhi866LtGxnWyUZ4PyTandiFuP3i68Lm1fNlYW48c=
X-Received: by 2002:a1f:cac7:0:b0:495:e236:a73 with SMTP id
 a190-20020a1fcac7000000b00495e2360a73mr5732956vkg.11.1694697905041; Thu, 14
 Sep 2023 06:25:05 -0700 (PDT)
MIME-Version: 1.0
References: <20230903111558.2603332-1-amir73il@gmail.com> <20230903111558.2603332-2-amir73il@gmail.com>
 <87il8dghw0.fsf@suse.de>
In-Reply-To: <87il8dghw0.fsf@suse.de>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 14 Sep 2023 16:24:53 +0300
Message-ID: <CAOQ4uxhM8F6iyp5AVLquaq=NoR_V_6Y6NUjBDjqfjgcPvA5-Dw@mail.gmail.com>
Subject: Re: [LTP] [PATCH 1/3] fanotify13: Test watching overlayfs upper fs
To:     rpalethorpe@suse.de
Cc:     Petr Vorel <pvorel@suse.cz>,
        Christian Brauner <brauner@kernel.org>,
        Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, ltp@lists.linux.it
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Sep 14, 2023 at 1:37=E2=80=AFPM Richard Palethorpe <rpalethorpe@sus=
e.de> wrote:
>
> Hello Amir,
>
> Amir Goldstein <amir73il@gmail.com> writes:
>
> > Run a test variant with overlayfs (over all supported fs)
> > when watching the upper fs.
> >
> > This is a regression test for kernel fix bc2473c90fca
> > ("ovl: enable fsnotify events on underlying real files"),
> > from kernel 6.5, which is not likely to be backported to older kernels.
> >
> > To avoid waiting for events that won't arrive when testing old kernels,
> > require that kernel supports encoding fid with new flag AT_HADNLE_FID,
> > also merged to 6.5 and not likely to be backported to older kernels.
>
> Unfortunately Petr's not here at the moment.
>
> I guess this first patch doesn't require 6.6? So it could be merged
> independently without further considerations for what makes it into 6.6?
>

Yes that is correct.

Thanks,
Amir.
