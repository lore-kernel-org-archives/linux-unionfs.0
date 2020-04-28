Return-Path: <SRS0=REe/=6M=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F331C83000
	for <linux-unionfs@archiver.kernel.org>; Tue, 28 Apr 2020 13:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A047206D6
	for <linux-unionfs@archiver.kernel.org>; Tue, 28 Apr 2020 13:32:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="NZbIXl6o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgD1Nca (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 09:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgD1Nc3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Apr 2020 09:32:29 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2869EC03C1A9
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Apr 2020 06:32:28 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id x1so17231200ejd.8
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Apr 2020 06:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QsImM8E8Sx5T2dV/WsDhWlM1WOzIgncwreRpcnmmPvY=;
        b=NZbIXl6oBElcuhvlH3LYSBdiZtZr/16U1fsWBOiGevapez7ylIChAbr9rnV8lrDJ9z
         qHYEMaTzZwXZLXf/lcPCooKQYijxGJ8csxDeHQihbWioIzNloa1/p5xNjL9y0A8MFYCO
         8WQpT7AZ3UwmZ4vaEKk9Cy5J+RJxrYWIx3pWI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QsImM8E8Sx5T2dV/WsDhWlM1WOzIgncwreRpcnmmPvY=;
        b=uGVPwo8yA4vCZUALIlb5P3VkcN/DWCS129Mu/z9ErKilZYihiWKZr2tX3z8fjGzwRE
         75l+T7ug7xA0lnk5nO9GxyW2BfO57mxzDZPkd66RYnKkBgR0RhsaR2V0cpLCX4sGvCf8
         LbjnNl/7GXKj0bK8Gprqj/iib90GNiGso9lnEjjrdBInCW6W53DymhVe8FzIZOa4Av0S
         As/Ych1pW4yOKMSqzRBgsV41ql1Lh4yiyWILcXgOtI3v7jBtS1cpPKgjnSRKGvduExEY
         3h7a27U5iqt6fO/I2biN2ERALfUOszyWKLLAn4QLhxBuvjaPJ2DjjQ7psBAW1epTHnvj
         Ny+w==
X-Gm-Message-State: AGi0PuaXHoPZC2Qtv9m3fmnBTY6qdB3Y/2TrrRBBgHKA/Tt8jSrnAPFg
        vJJz2Ey3umWHi+EFpDJI4c9KFxYZXGQO/RxCsN1drg==
X-Google-Smtp-Source: APiQypJZMAfAQ7clut+um20VSusBRFIkyrCeom+rTEVHmpiz+2n125IszLNfI8RQokwMmA/ZUV+aEc/ItvVb7zlwauQ=
X-Received: by 2002:a17:906:841a:: with SMTP id n26mr25302784ejx.43.1588080746732;
 Tue, 28 Apr 2020 06:32:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200422102740.6670-1-cgxu519@mykernel.net> <CAOQ4uxj5JsWOgQ8vHqTkAXx16Y9URTgNpALY5XO=VNUAMTkOMw@mail.gmail.com>
 <171a49cb02a.e6962d897896.4484083556616944063@mykernel.net>
 <CAOQ4uxhowSRqD9kSoUHg+D8-RdxF8vBbTauTchgnpG5MoSNSEA@mail.gmail.com>
 <171aadd9966.100e576ad1248.8616898883060201949@mykernel.net>
 <CAOQ4uxi_zp45KrjnR4FJx56gsDPsoim4U0H7hj1ta4+gXAwQtQ@mail.gmail.com>
 <20200428122104.GA13131@miu.piliscsaba.redhat.com> <CAOQ4uxh4ZVqOHtiytk4fHB5otNd8VRM-Z_8ZYpW1qMjzAsmkZw@mail.gmail.com>
In-Reply-To: <CAOQ4uxh4ZVqOHtiytk4fHB5otNd8VRM-Z_8ZYpW1qMjzAsmkZw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 28 Apr 2020 15:32:15 +0200
Message-ID: <CAJfpegvCyr_JJr8_n+qXOHVeCxgHGmizCqZ3b2mKAA9M_qbQQw@mail.gmail.com>
Subject: Re: [PATCH v4] ovl: whiteout inode sharing
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 28, 2020 at 3:16 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Apr 28, 2020 at 3:21 PM Miklos Szeredi <miklos@szeredi.hu> wrote:

> > And I don't really see a reason to disable whiteout hard links.  What scenario
> > would that be useful in?
>
> I have a vague memory of e2fsck excessive memory consumption
> in face of many hardlinks created by rsync backups.
> Now I suppose it was a function of number of files with nlink > 1 and not
> a function of nlink itself and could be a non issue for a long time, but I am
> just being careful about introducing non-standard setups which may end up
> exposing filesystem corner case bugs (near the edge of s_max_links).
> Yeh that is very defensive, so I don't mind ignoring that concern and addressing
> it in case somebody shouts.

Right, and even if such a corner case bug exists, it's still primarily
a bug in the underlying filesystem and should be fixed there. A
workaround in overlay would only make sense if for some reason the
primary fix is difficult or impossible.

> > +fallback:
> > +       whiteout = ofs->whiteout;
> > +       ofs->whiteout = NULL;
> > +success:
>
> This label is a bit strange, but fine.

Agreed, changed to "out:"

Thanks,
Miklos
