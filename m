Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98EA0C43460
	for <linux-unionfs@archiver.kernel.org>; Thu,  1 Apr 2021 17:48:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B23D60234
	for <linux-unionfs@archiver.kernel.org>; Thu,  1 Apr 2021 17:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbhDARsy (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236699AbhDARqZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Apr 2021 13:46:25 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6C4C0613A6
        for <linux-unionfs@vger.kernel.org>; Thu,  1 Apr 2021 04:31:24 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id h23so1035330vsj.8
        for <linux-unionfs@vger.kernel.org>; Thu, 01 Apr 2021 04:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AtjoJrW+K528tDQVsKqZvdREH3wz5eHW195nbhXbRuQ=;
        b=m1CSR9BZcP1iyCY6n/TyvutJEXKV4je/TS75cw4qC0CtATdPNxSxR6c4KGH6zd5GNp
         dxVPV5pqUfVCK/s2zXM/j2F64MvMQB0Gw1r/JeRXpcgsMQufPHugIzjFYDT4Ag9mrWcx
         v+A7RBRXEOguyQjiha+WZtLrxJf2Ub/MZ5fM4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AtjoJrW+K528tDQVsKqZvdREH3wz5eHW195nbhXbRuQ=;
        b=TBz60lAx8n5o7KjzzG8e3SmV6o5YmdycRQM5R3leeBfNlCCOf9yr0KSTlFYl14Sa9n
         DorkM6fRk3HDGkxV2fl6GHla7ies6cTs58imIMLHMlP4MY6tFRfOzAbPdU7m4SLNwpER
         26C4DNw1SEUZAhzIDJKHmbX/4bKTDVMV75uwbC7ld9hnbbnXmUxMOOrH0b8d79xlxZa0
         vsI1N5plv+y+bMYmjO0QVUHGdvbZASiC4mzTBdUfp7bnFlhDv57gH4YemygeefUnUvSO
         IvXuV6GZ++xsqz4LNk2oDZF4kSBFGRGJKp6hxGXw5p2zYhBC+iWXab0T5TtW+r9UfP6v
         sTBQ==
X-Gm-Message-State: AOAM532CWvWR0/ooNuso/yGP9zTTSSmlZS/ltkaSZDMoa0Q2XztjKWxI
        5I26tnwvweqIa+AHQu6hRjigibnnyDKKkLjG59bTe9b5m3Kdcw==
X-Google-Smtp-Source: ABdhPJzsRt3alzuqK+GQRVILu6BnaAre/SCIJFh+w71rBtEOhsrS+I4xQaCeRkUh+VphlayRaVox0Xj5GeD8q/iis/A=
X-Received: by 2002:a67:8793:: with SMTP id j141mr4773525vsd.7.1617276683391;
 Thu, 01 Apr 2021 04:31:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210308111717.2027030-1-cgxu519@mykernel.net>
 <CAJfpeguFdafs65aOgDrJnAh6Tg8bnwP3gP5sUhfsRka5Azctbg@mail.gmail.com> <1788d256770.ff2961df3248.3624659711262801588@mykernel.net>
In-Reply-To: <1788d256770.ff2961df3248.3624659711262801588@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 1 Apr 2021 13:31:12 +0200
Message-ID: <CAJfpegt_r6rWFMjpLxmQK8saQ=G01RKSd=5+GUCnz_By_27EGg@mail.gmail.com>
Subject: Re: [PATCH] ovl: copy-up optimization for truncate
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 1, 2021 at 1:15 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=80, 2021-03-29 23:13:52 Miklos S=
zeredi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
>  > On Mon, Mar 8, 2021 at 12:17 PM Chengguang Xu <cgxu519@mykernel.net> w=
rote:
>  > >
>  > > Currently copy-up will copy whole lower file to upper
>  > > regardless of the data range which is needed for further
>  > > operation. This patch avoids unnecessary copy when truncate
>  > > size is smaller than the file size.
>  >
>  > This doesn't look right.   If copy up succeeds, resulting in a
>  > truncated file, then we should return success there and then.   Doing
>  > the truncate again and failing (unlikely, but I wouldn't think it
>  > impossible) wouldn't be nice.
>
> Hi Miklos
>
> I noticed a problem here, if we just return success after copy-up then mt=
ime
> keeps the same as lower file. I think doing the truncate again would be b=
etter
> than manually updating the upper file's mtime. What do you think for this=
?

Let's simplify instead:  skip the mtime restore on copy-up.   Not sure
how that's handled on O_TRUNC opens, maybe it's relevant to that case
too.

Thanks,
Miklos
