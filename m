Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76CF0CDB465
	for <linux-unionfs@archiver.kernel.org>; Sat, 14 Oct 2023 17:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbjJNRbl (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 14 Oct 2023 13:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbjJNRbk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 14 Oct 2023 13:31:40 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042A7CC
        for <linux-unionfs@vger.kernel.org>; Sat, 14 Oct 2023 10:31:38 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-9a6190af24aso515734866b.0
        for <linux-unionfs@vger.kernel.org>; Sat, 14 Oct 2023 10:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1697304696; x=1697909496; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LwDaOG7+s8K9/7h3Px1eqNebN/lIc0yDoawOB9JFDjs=;
        b=P4lpP3gJbjBpW4kDBu0QATxMLRvboPLVg+3BEfveIDiHhGiy9DvAIs051XMcottvna
         zmJYRHGRvHN8KcLdq75y9pIjvucpKSnSOirxz4Jp9PRtLlmGAIlNvixckms4NtCsEQ3g
         FKVGQLEqVbafhAxt6xAYacCM2gCYVf2miUyjY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697304696; x=1697909496;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LwDaOG7+s8K9/7h3Px1eqNebN/lIc0yDoawOB9JFDjs=;
        b=rlNEYfNcsyVCe7Kszehv9UrGmNDfxtXK1mw4mgcqznhK0Pt18DMYa/iSVc6pJrm3Yt
         eRSVScZz4MV7P4l8vwIcbmd9ssyK0imws4DQfQMTEW4xKlJe3+4QjFDg5aLrOiG8Z4Cg
         UAGwjhkOZ6JRHAn1+Dk+x5H0AyF0L9nJZUvRDhSkxMrTUbxZfuf5nciv+i2m8+xPGvmm
         3SZMvo4gRzEthORK9ESWyN3YiuUu5CezHgpaFkrlvM99Nt9hZNPR1sSed4wjHtDFqt32
         WkhxVzgEG5d5zZsRi9N8YltZtpDEcFZm/RCk5uHMVOrQrhKOXQdw5kuoZ3+6wxid3N1k
         k8aQ==
X-Gm-Message-State: AOJu0Yx+fZKTGNSmqW0CoYeRuqPVx7f1qecbuXnr2wynmCnW9j2gr1NW
        QPgsI7f+hNZ6RXPI+OBUjMvwr4Qco+qvse/yIqLBMw==
X-Google-Smtp-Source: AGHT+IETz7pmA6mE1rEuZcqpTvZir0pdnkx84Fs8N59UB1F2GeU+E23rbvfsh/VArpIqpDuQxMaQIna/4b0xV30LexA=
X-Received: by 2002:a17:907:1c25:b0:9bf:b5bc:6c4b with SMTP id
 nc37-20020a1709071c2500b009bfb5bc6c4bmr200489ejc.62.1697304696261; Sat, 14
 Oct 2023 10:31:36 -0700 (PDT)
MIME-Version: 1.0
References: <20231011164613.1766616-1-amir73il@gmail.com> <CAJfpegvgePB-==T=yTU1R+JVxKYsU_Bm18vWdW5hXWLGw=47PQ@mail.gmail.com>
 <CAOQ4uxiE89q62JHnxwm14FBShPORmX_h0EyDCBN-VKv6aTf5BQ@mail.gmail.com>
 <CAJfpegsexQsNVMOZw+0byzj2wTbU_Tg6p0ATgwBAwmTaDmNbLA@mail.gmail.com>
 <CAOQ4uxjYGckJA=raAW8wyVmDaK-FXfFDRS0RCpZYcLucPqMi3w@mail.gmail.com>
 <CAJfpegt5COamxm-ZN+A9ub_Te-CPM0xMd-Rrzwv7OHBkvHS3yg@mail.gmail.com> <CAOQ4uxic3NDtEt9EiP+RYKGEB=6b_PCaudQA=cXK6mWY4Cmeqg@mail.gmail.com>
In-Reply-To: <CAOQ4uxic3NDtEt9EiP+RYKGEB=6b_PCaudQA=cXK6mWY4Cmeqg@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Sat, 14 Oct 2023 19:31:25 +0200
Message-ID: <CAJfpegsr3A4YgF2YBevWa6n3=AcP7hNndG6EPMu3ncvV-AM71A@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix regression in showing lowerdir mount option
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, 14 Oct 2023 at 17:32, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Sat, Oct 14, 2023 at 5:09=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu=
> wrote:
> >
> > On Sat, 14 Oct 2023 at 10:24, Amir Goldstein <amir73il@gmail.com> wrote=
:
> >
> > > Being extra nice and displaying "a\,b" and "a\:b" for new users that
> > > used new mount api explicitly to pass "a,b" and "a:b" is possible, bu=
t
> > > it is not a 6.5 regression fix, so we can take the time to decide if =
we
> > > want to do that or not.
> > >
> > > OK?
> >
> > Yeah, I'm mostly convinced by your arguments.
> >
> > The other issue that has to be decided pretty quickly is whether to
> > leave the append mode (starting lowerdir with ':') or remove it now
> > and replace it in the next cycle with a mode that doesn't play games
> > with separators (i.e. adding layers one at a time).
> >
> > The only argument I can see for the current append is that it's
> > possible to add multiple layers at once, but it's also redundant once
> > we add the one-by-one append mode and I'm not convinced that it's
> > worth the complexity and the mess with having to escape separators.
> >
> > What do you think?
>
> I think that we can leave the string-append mode, but disallow ':' and '\=
'
> within an appended string, so we only support adding lowerdirs one at
> a time and no support for special chars in file name, so escaping is moot=
.
>
> This way, we do not complicate things and leave the functionality intact.
> Sure, it's going to be redundant once we add support for
> FSCONFIG_SET_PATH*, but the added code to strip the ":" or "::"
> prefix for FSCONFIG_SET_STRING is not really complicated.
>
> I can add this patch if you agree (without all the possible code cleanup)=
.

So what I figured is that a separate key for the append interface is
better, otherwise data only and plain lower layers can't be
differentiated.

So my PoC is using "lowerdir+" and "datadir+" for this.  I think this
might be a good convention going forward if any other filesystem needs
such append mode options.

If you can code this up quickly, that's good.  I can have a go at it
on Monday, but my PoC patch needs splitting up and so it's not ready
for 6.6.

Thanks,
Miklos
