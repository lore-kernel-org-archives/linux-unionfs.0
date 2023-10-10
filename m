Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189C1CD691F
	for <linux-unionfs@archiver.kernel.org>; Tue, 10 Oct 2023 10:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjJJKAU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 10 Oct 2023 06:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbjJJKAS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 10 Oct 2023 06:00:18 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C8899
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Oct 2023 03:00:17 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id 3f1490d57ef6-d862533ea85so6351469276.0
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Oct 2023 03:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696932016; x=1697536816; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5etZdD+1W4fYdFVA9j5Q8TpHKZ2dhaWJJeUbdvchL1w=;
        b=NbsTVruLU5y+rwnIJ3nZBD11EOSMTyh6Ha8O5kMBt75GOtCZgKf6Yd6yTV5JLP7EDC
         U+XWhRaCY0o4/+wHBSuKmLdkKYUfI1P+f4Jz9bPc6ek4vR08BgxkeJoNP+xQ845K1+Oi
         xNBPunF09ndX0lEInByh+386Xe1Mu7CbylusgujCEh2KwUouG39O8gnBOBncDdi8cVfg
         fgOhjqWfBmr3W2ygSqF8rGj2Bz8SVDuxSXDvzZlIr3vAzQpkSHrpwEZvupSIfkv/pQ82
         s+SUXflIGDe44lDfw3UbrQIpMjvaEDGuwUJUy6h0W8hCDSsPdJwdg6Ldu+k+4lpN2654
         KtcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696932016; x=1697536816;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5etZdD+1W4fYdFVA9j5Q8TpHKZ2dhaWJJeUbdvchL1w=;
        b=ERtKH7Bz+BB6qNMgzPpiRLM0M0POjrvb6fyXpBtpbyylZfg/TbgDcDls5kDDEpjU/3
         bM7kgnodiRp9qVMLVJ7nVTCdJzyVhKEoeFadm6MIg1xgoYeOZgXNuWLcgnirgTT6Irgz
         pJTFx7sP1zApaCdeIVvRK6qs23TxbWWM1EwfwcpleGmP7mvO75XD4pL/he98xD3DuoO6
         O1FhgfHCi0vR2frfC2irf7NKHceBUYmpOGTay377BeqT1YzoJezDPFnervL6oXaATdEN
         /vcTEqaXxlqZgsdVCR707c+O2FDL00ALolsVfU92Et0w82onPeXWppLtT20m9fJTvTTf
         UrEg==
X-Gm-Message-State: AOJu0YwJEFGAFLjYXN6UBUio8uJ/8uygB8aSpiNJDFHBQQhCW8UtCdxc
        /AiOTnzqlkvPZQ9kDFLNCGyO1O3VYix6YZdqZFw=
X-Google-Smtp-Source: AGHT+IHkqomg4q5xUEjzB6PKQAGif9EwrX+Y7CwCPMWtWo13/dNx9iXux3IcyRO9VxRco1zLM1NH6keEKwGNF9bdJVI=
X-Received: by 2002:a25:698f:0:b0:d91:92c8:9052 with SMTP id
 e137-20020a25698f000000b00d9192c89052mr16436185ybc.8.1696932016287; Tue, 10
 Oct 2023 03:00:16 -0700 (PDT)
MIME-Version: 1.0
References: <8da307fb-9318-cf78-8a27-ba5c5a0aef6d@alum.mit.edu>
 <CAOQ4uxhQhzv_LUW89m_BmKf+NjE+XDyY9XtLAt+SWG03M6LmYQ@mail.gmail.com>
 <20231006130259.GA438068@toolbox> <CAOQ4uxg84M7H0EtTLWAsNkHaaLzVVXQ=-fCVFVr8a6MGSQC=vg@mail.gmail.com>
 <5d708a45-43c9-b026-6619-7c377ee02793@alum.mit.edu> <CAOQ4uxgNakTHi0dHC1v51TCU_aAKTOrJ4zFv=BzfoKNMsCwZEg@mail.gmail.com>
 <CAJfpegsFNjMX+Lz8uX-6=fDa59qYJQjnUnJpzKiTxuBziC7pxQ@mail.gmail.com>
In-Reply-To: <CAJfpegsFNjMX+Lz8uX-6=fDa59qYJQjnUnJpzKiTxuBziC7pxQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 10 Oct 2023 13:00:05 +0300
Message-ID: <CAOQ4uxgNr=ZbHTB8TcMfWLceBoQD0a2u4Bzo3-Hr3QZTRoBjLQ@mail.gmail.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>,
        Sebastian Wick <sebastian.wick@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Oct 10, 2023 at 12:06=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu>=
 wrote:
>
> On Fri, 6 Oct 2023 at 19:21, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Fri, Oct 6, 2023 at 7:42=E2=80=AFPM Ryan Hendrickson
>
> > > And there is the escaping that needs to happen for ':' and '\' when
> > > parsing the path parameters (':' is only special syntax in lowerdir, =
but
> > > the escaping logic seems to apply to upperdir and workdir as well, ba=
sed
> > > on my testing). Even using the new API, this is handled in the kernel=
.
> > > We'd like to know if this escaping can be considered stable as well, =
and I
> > > don't think that's a question for the libmount maintainer.
> >
> > Agree.
> > Unlike the comma separated parameters list,
> > upperdir,workdir,lowerdir are overlayfs specific format.
> >
> > ovl_unescape() (for upperdir/workdir) unescapes '\' characters.
> > as does ovl_parse_param_split_lowerdirs().
> > Not sure why this was needed for upperdir/workdir, but it It has
> > been this way for a long time.
> > I see no reason for it to change in the future.
>
> Unescaping  upperdir/workdir was the side effect of using a common
> helper; it wasn't intentional, I think.  The problem is that
> unescaping breaks code that doesn't expect it, and filenames with
> backslashes (and especially \\ or \: sequences) are very rare, so this
> won't show up in testing.
>
> At this point I'm not sure which is more likely to cause bugs: getting
> rid of unescaping or leaving it alone.

Considering the fact that the applications that mount overlayfs has
always had to do the correct escaping, getting rid of escaping can
only solve issues in new deployments, so I think we should greatly
favor leaving it alone.

>
> One way out of this mess is to create explicit _unesc versions of these o=
ptions.
>

I like that solution, with two reservations:
1. IMO, new _unesc versions should only be supported from new mount API
2. I only want to do that if real users exists - said users are expected
    to send the patch and explain their use case

Thanks,
Amir.
