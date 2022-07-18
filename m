Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 502E8C43334
	for <linux-unionfs@archiver.kernel.org>; Mon, 18 Jul 2022 13:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbiGRNNn (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 09:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234829AbiGRNNm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Jul 2022 09:13:42 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C29E2717F
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Jul 2022 06:13:41 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id t3so15255806edd.0
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Jul 2022 06:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DemOKMHhZF3bL68gab3/ZnvjvNZQC14ke44+CAjVeE0=;
        b=qkj5sL9AXqE4MMHohODclRGaHobppjOPaPwZrckNV7rVX+5xk6Y5kZLptuYAsgmuLV
         W/E5E3Liof8DSJgkDsZ5FH1U4RmtxhbDLpIj98x5vOqrNmnAfVtrMyuMSsa1VN38M5Co
         zzfBesdWFUs7dEGqENIHgu5wIsZ6f1Fhme6wE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DemOKMHhZF3bL68gab3/ZnvjvNZQC14ke44+CAjVeE0=;
        b=jyQnWIKCjoH43e4LU3u3dTrq1yJSeb43xkjZIADdThubMbOqbTq8z2jBorOkdzxWeO
         +sn4LTnEaOGaTNOrdflBZ4t15fVdPvdXfEwbs2XT3Hhh6HoxvJmft9BI1FcMsvHPQexv
         pGg48K1b8Ah5ik5l0LdvvjZi1kiwcXGPFI2U4fazhdX5drgRas9fPj9/O0QqINpoaB70
         grzwBmrWKZY57zjmujYqdKxZjwtHAF/kAywahBSH81ptNb+eQszHzBfDKhLH4rQRv8EY
         1Gy8/3FyZDe7Fpo95S5iXZ7wH75rAHTrZ2l+Bx8ehX0RV3unOFiJ3Q7UOf6KJavS//Ru
         Mpbw==
X-Gm-Message-State: AJIora9mOa+Dc5WOnV0cLlZGaqKAaaDfaG7/tdoKUUSQxu1uc6od3Je3
        rVoaOZhY0/AghYRBlx5ablYuTJluDTbSWP0H/FWISw==
X-Google-Smtp-Source: AGRyM1s62j3MUSXuzz3DC8rfU5UvJmiYwnYQo2iuFRpY/jqWv1YRWKc3lzzXZMGJlstM+esSCZOyhW7Z67XsTzxSgfg=
X-Received: by 2002:a05:6402:4245:b0:43a:961a:583f with SMTP id
 g5-20020a056402424500b0043a961a583fmr37178878edb.374.1658150019848; Mon, 18
 Jul 2022 06:13:39 -0700 (PDT)
MIME-Version: 1.0
References: <4B9D76D5-C794-4A49-A76F-3D4C10385EE0@kohlschutter.com>
 <CAJfpegs1Kta-HcikDGFt4=fa_LDttCeRmffKhUjWLr=DxzXg-A@mail.gmail.com>
 <83A29F9C-1A91-4753-953A-0C98E8A9832C@kohlschutter.com> <CAJfpegv5W0CycWCc2-kcn4=UVqk1hP7KrvBpzXHwW-Nmkjx8zA@mail.gmail.com>
 <FFA26FD1-60EF-457E-B914-E1978CCC7B57@kohlschutter.com> <CAJfpeguDAJpLMABsomBFQ=w6Li0=sBW0bFyALv4EJrAmR2BkpQ@mail.gmail.com>
 <A31096BA-C128-4D0B-B27D-C34560844ED0@kohlschutter.com>
In-Reply-To: <A31096BA-C128-4D0B-B27D-C34560844ED0@kohlschutter.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 18 Jul 2022 15:13:28 +0200
Message-ID: <CAJfpegvBSCQwkCv=5LJDx1LRCN_ztTh9VMvrTbCyt0zf7W2trw@mail.gmail.com>
Subject: Re: [PATCH] [REGRESSION] ovl: Handle ENOSYS when fileattr support is
 missing in lower/upper fs
To:     =?UTF-8?Q?Christian_Kohlsch=C3=BCtter?= 
        <christian@kohlschutter.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 18 Jul 2022 at 15:03, Christian Kohlsch=C3=BCtter
<christian@kohlschutter.com> wrote:
>
> Am 18.07.2022 um 14:21 schrieb Miklos Szeredi <miklos@szeredi.hu>:
> >
> > On Mon, 18 Jul 2022 at 12:56, Christian Kohlsch=C3=BCtter
> > <christian@kohlschutter.com> wrote:
> >
> >> However, users of fuse that have no business with overlayfs suddenly s=
ee their ioctl return ENOTTY instead of ENOSYS.
> >
> > And returning ENOTTY is the correct behavior.  See this comment in
> > <asm-generic/errrno.h>:
> >
> > /*
> > * This error code is special: arch syscall entry code will return
> > * -ENOSYS if users try to call a syscall that doesn't exist.  To keep
> > * failures of syscalls that really do exist distinguishable from
> > * failures due to attempts to use a nonexistent syscall, syscall
> > * implementations should refrain from returning -ENOSYS.
> > */
> > #define ENOSYS 38 /* Invalid system call number */
> >
> > Thanks,
> > Miklos
>
> That ship is sailed since ENOSYS was returned to user-space for the first=
 time.
>
> It reminds me a bit of Linus' "we do not break userspace" email from 2012=
 [1, 2], where Linus wrote:
> > Applications *do* care about error return values. There's no way in
> > hell you can willy-nilly just change them. And if you do change them,
> > and applications break, there is no way in hell you can then blame the
> > application.

Correct.  The question is whether any application would break in this
case.  I think not, but you are free to prove otherwise.

Thanks,
Miklos
