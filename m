Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2850CD8CA9
	for <linux-unionfs@archiver.kernel.org>; Tue, 10 Oct 2023 16:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbjJJQyV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 10 Oct 2023 12:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbjJJQyV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 10 Oct 2023 12:54:21 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813A18E
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Oct 2023 09:54:19 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id 3f1490d57ef6-d8195078f69so6276346276.3
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Oct 2023 09:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696956858; x=1697561658; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DZyT/cU2mkqVStKD/xadkqHSI/0b7AkHYnvaGdg5bbk=;
        b=k0E4Emg7EJvVl2/DNcKi8ulE7QCTQBuw6TCAtY1r6DHrY/D1s9tTItX6mo52548TSw
         wbzF1hsmYiiqhft5n0jkvQryJjSkMck+3YtGZzJyONj2Qu5ZxnpK1hbAcmK9/dPZmXq7
         PPW9PXcoLb5+aea8u+7znp86wJ+JMF4p+EnUtSHEUjW/6uJm8nV5+nqVCGK/jWp7JeNH
         BAm/b+L8UJKz2+coVouvKRZoiraDWW1Rm3LS0lzuqrpVhs1Gmk3lltPM770/z3VOpX4g
         f8LuxoYBtjnaDjBL/jlRIV2hH0qRdD0pDD97kuEuazj13lL6gjeb0U1mE1QssVh91oHI
         EfMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696956858; x=1697561658;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DZyT/cU2mkqVStKD/xadkqHSI/0b7AkHYnvaGdg5bbk=;
        b=ZfmfmuUhD2zFVgT3+3iRTW9nHraPrZ5xVsfb8w1lTynrd0DmlzJ8mLTK13NuCp0JKT
         Bo6FKoZwICix0FQmX20crIRP/I7ILh+BNsVljJb3vUQsWFB+q7sj0kYQwuco2y74NyNi
         R1z1xTtCERi3n16I5BDzGvcrQpZPsYYeHgVe61ehi7grVDnTHyHj6uvyhWtKMzQXNDBU
         BZiQlYfBt8qcQ6JBA2EhWpkusjcB2HeFTpxvr5iAh/b+4aVBOoe8ZkUiOF1CewOdONrS
         T9JD6pogiQOMt/dPBe2cpSGkXoePakjebR3bmHQWhx+qdxLEYv07jD+R+TsWENa2DBvD
         j/mw==
X-Gm-Message-State: AOJu0YyBgc9KbWN3291MW5LsDw968aEeQc739VcfkkqK3tX92fEw71ZC
        fzZZjQpwHX+upXoJyDFj3yJzqosWD9j9I7xYARU=
X-Google-Smtp-Source: AGHT+IEg5NUm72+Ygf4yWzAklWbxwZPpSfdDYfe061H1s9fZXB5u42nlqq/RgHwZUpQDP4GHzdrrIdNGZO9paLpfEZc=
X-Received: by 2002:a25:d0d:0:b0:d9a:5895:2c74 with SMTP id
 13-20020a250d0d000000b00d9a58952c74mr2308985ybn.42.1696956858502; Tue, 10 Oct
 2023 09:54:18 -0700 (PDT)
MIME-Version: 1.0
References: <8da307fb-9318-cf78-8a27-ba5c5a0aef6d@alum.mit.edu>
 <CAOQ4uxhQhzv_LUW89m_BmKf+NjE+XDyY9XtLAt+SWG03M6LmYQ@mail.gmail.com>
 <20231006130259.GA438068@toolbox> <CAOQ4uxg84M7H0EtTLWAsNkHaaLzVVXQ=-fCVFVr8a6MGSQC=vg@mail.gmail.com>
 <5d708a45-43c9-b026-6619-7c377ee02793@alum.mit.edu> <CAOQ4uxgNakTHi0dHC1v51TCU_aAKTOrJ4zFv=BzfoKNMsCwZEg@mail.gmail.com>
 <CAJfpegsFNjMX+Lz8uX-6=fDa59qYJQjnUnJpzKiTxuBziC7pxQ@mail.gmail.com>
 <CAOQ4uxgNr=ZbHTB8TcMfWLceBoQD0a2u4Bzo3-Hr3QZTRoBjLQ@mail.gmail.com> <CA+hFU4w78Ze-wKPg9fsdR6zpL5VUwp8jNqCcHGmOFJ--GAGKJA@mail.gmail.com>
In-Reply-To: <CA+hFU4w78Ze-wKPg9fsdR6zpL5VUwp8jNqCcHGmOFJ--GAGKJA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 10 Oct 2023 19:54:07 +0300
Message-ID: <CAOQ4uxhSTJaZggq-z_3oPbXh48n88E1QjfNTr5HO1ZuqyrF+ew@mail.gmail.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
To:     Sebastian Wick <sebastian.wick@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Oct 10, 2023 at 7:13=E2=80=AFPM Sebastian Wick
<sebastian.wick@redhat.com> wrote:
>
> On Tue, Oct 10, 2023 at 12:00=E2=80=AFPM Amir Goldstein <amir73il@gmail.c=
om> wrote:
> >
> > On Tue, Oct 10, 2023 at 12:06=E2=80=AFPM Miklos Szeredi <miklos@szeredi=
.hu> wrote:
> > >
> > > On Fri, 6 Oct 2023 at 19:21, Amir Goldstein <amir73il@gmail.com> wrot=
e:
> > > >
> > > > On Fri, Oct 6, 2023 at 7:42=E2=80=AFPM Ryan Hendrickson
> > >
> > > > > And there is the escaping that needs to happen for ':' and '\' wh=
en
> > > > > parsing the path parameters (':' is only special syntax in lowerd=
ir, but
> > > > > the escaping logic seems to apply to upperdir and workdir as well=
, based
> > > > > on my testing). Even using the new API, this is handled in the ke=
rnel.
> > > > > We'd like to know if this escaping can be considered stable as we=
ll, and I
> > > > > don't think that's a question for the libmount maintainer.
> > > >
> > > > Agree.
> > > > Unlike the comma separated parameters list,
> > > > upperdir,workdir,lowerdir are overlayfs specific format.
> > > >
> > > > ovl_unescape() (for upperdir/workdir) unescapes '\' characters.
> > > > as does ovl_parse_param_split_lowerdirs().
> > > > Not sure why this was needed for upperdir/workdir, but it It has
> > > > been this way for a long time.
> > > > I see no reason for it to change in the future.
> > >
> > > Unescaping  upperdir/workdir was the side effect of using a common
> > > helper; it wasn't intentional, I think.  The problem is that
> > > unescaping breaks code that doesn't expect it, and filenames with
> > > backslashes (and especially \\ or \: sequences) are very rare, so thi=
s
> > > won't show up in testing.
> > >
> > > At this point I'm not sure which is more likely to cause bugs: gettin=
g
> > > rid of unescaping or leaving it alone.
> >
> > Considering the fact that the applications that mount overlayfs has
> > always had to do the correct escaping, getting rid of escaping can
> > only solve issues in new deployments, so I think we should greatly
> > favor leaving it alone.
>
> Any change here is a regression. I'm seriously confused why this is
> even debated. You already managed to have a regression and I'm still
> of the opinion that this should be fixed because it literally breaks
> user space.
>

You are right. Literally it does.
But if prospect users are ok with upgrading libmount and if that
solves the problem, I'd rather not have to carry in the kernel
baggage code to support old mount API for a very niche use case.

> > >
> > > One way out of this mess is to create explicit _unesc versions of the=
se options.
> > >
> >
> > I like that solution, with two reservations:
> > 1. IMO, new _unesc versions should only be supported from new mount API
> > 2. I only want to do that if real users exists - said users are expecte=
d
> >     to send the patch and explain their use case
>
> This is confusing me a lot. Why would you not want to provide an API
> which is clearly, objectively the better API? As user space, when we
> can use the new mount API and we could use this, we absolutely would
> use this.

I am also confused by this reaction.
Who said that I do not want to provide the _unenc API?

IIUC, you are requesting a new feature that did not exist before,
namely, upperdir_unenc, workdir_unenc, lowerdir_unenc options.
Did I understand correctly?
If that is the case then please send a patch to support
those new options in the new mount API only
including documentation and tests.

Thanks,
Amir.
