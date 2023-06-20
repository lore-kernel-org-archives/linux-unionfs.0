Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D939EB64D7
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jun 2023 09:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjFTJrV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 05:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbjFTJrF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jun 2023 05:47:05 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1560CDD
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 02:47:04 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id ada2fe7eead31-440a925df4aso672523137.2
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 02:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687254423; x=1689846423;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NTS5pm4uOHsyXNULCmpOxGaF2EgyOv4Jdp2d8FGXJR8=;
        b=sTu5yBIjfIyhhVALRH31qIYIzjROgEf5se97vN3IZp2RcBom7pp9DHk9aGlaiRKqZV
         gP65uVnWpptYK57JOISzsilcBAce+OEKGpo5+Q5EQut4hf6Cl4h+u01LHP1W21RJFa5f
         RHQQw0RznQLvzxq7JJfXlleNmLmr7ePyBMJHpEjAUC6rAl9gkDfUju9dHsmzjEx5pUFj
         40su1LEQN/UXhJj6WCGGmJEd66S3xWDQ7FmNLfXPacogPNO15c950V4N+IdooW9J7XZZ
         Izg4Mf/oh2NX0ozukFEQHPJ15NxosjHL3pTd3dYDST1r2VMylJMCI9J6jm4GUhE3G0cN
         jsoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687254423; x=1689846423;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NTS5pm4uOHsyXNULCmpOxGaF2EgyOv4Jdp2d8FGXJR8=;
        b=BKUtEVz1hNpU7y1N47Cl7GUFqanSuTVMMtOkOE2KxATL9pMbBb4WNXKjpQGVprSpOX
         yEZdrxFMj0j0AfpAT3iiZ2/iObgeWs2sHCvajGGocsHO6H8JZFzqzptcI13+f5gEeyBm
         nAgzMH+FJidtuWK/3hIe/wO7Bhav0MVteP9D4Z6J7knbHS6OH9My6g7jJ6cd37uymh0n
         ANV9q2M9Uaw2BLFinkpS0ELZGy87Cyq2Z2VT1uu/gQIh5+FTyoLhPPU2Sz2Xdj25ESXk
         n3iWzobd0LBINkstz+6Ee8Qk2XLboMb76eXcaufRJNjIZWrbAfOsrDbCIU/syakzUbm8
         YKiQ==
X-Gm-Message-State: AC+VfDw1mavinZ2Lflr2qY79o/bRNa3akTg7ZVikRzHfZz/I7KLnSawD
        SLEVrEOwff9BlThWodc++F9INnZbH2Mh0V46fqYW26Gb
X-Google-Smtp-Source: ACHHUZ7jqew2XLZMk0ucZwza7FMikFx1aao9YFr5Fj+2FKpkjqgKJsJRqTWhO8DfrnOb7QLJVJQRJ5XoltGlXOavT3E=
X-Received: by 2002:a05:6102:51b:b0:434:8401:beae with SMTP id
 l27-20020a056102051b00b004348401beaemr2096347vsa.34.1687254423134; Tue, 20
 Jun 2023 02:47:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230617084702.2468470-1-amir73il@gmail.com> <20230620-emblem-umgeladen-7d5c2cc0a8db@brauner>
In-Reply-To: <20230620-emblem-umgeladen-7d5c2cc0a8db@brauner>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 20 Jun 2023 12:46:52 +0300
Message-ID: <CAOQ4uxjLm92xRoSoexheyAE49298++hAWs4MbqyT8KEAZJQtdQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Prep patches for porting overlayfs to new mount api
To:     Christian Brauner <brauner@kernel.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 20, 2023 at 12:26=E2=80=AFPM Christian Brauner <brauner@kernel.=
org> wrote:
>
> On Sat, Jun 17, 2023 at 11:46:57AM +0300, Amir Goldstein wrote:
> > Miklos,
> >
> > Following some more cleanup patches that make Christian's new mount api
> > patches smaller and easier to review.
> >
> > I had rebased Christain's patches over these cleanups and pushed the
> > result to github branch fs-overlayfs-mount_api [1].
> >
> > The v1 prep patches had a bug with xino option parsing that resulted in
> > some tests being skipped (not failing) and I had only noticed the
> > skipped test after posting v1.
> >
> > The v2 prep patches + new mount api patches have passed all the tests
> > with no new tests skipped.
> >
> > In addition to running the tests with the default kernel config, I also
> > ran the tests with the following non-default configs (individually):
> >
> > 1) CONFIG_OVERLAY_FS_REDIRECT_DIR=3Dy
> > 2) CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=3Dn
> > 3) CONFIG_OVERLAY_FS_XINO_AUTO=3Dy
>
> Thanks for splitting some work into preparatory patches. I'm not sure
> how worthwhile this actually is given they aren't marked as backports
> for LTS releases so the overall delta ould still the same between LTSes
> and mainline but it might make bisection easier.

Yeh, bisection, review, all the usual reasons for keep unrelated changes
split. I am not usually fanatic about splitting hairs on this, but the
mount api porting patch was already a big change that was hard for me to
review and it grew all those extra additions like redirect_mode which
were good changes, but not related, so I did this to make my own (and other=
s)
review of your patches easier.

I am glad if we are all happy with the end result.

Thanks,
Amir.
