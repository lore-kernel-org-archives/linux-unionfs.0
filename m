Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB26EB64D7
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Jun 2023 12:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjFUM5t (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Jun 2023 08:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbjFUM5r (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2023 08:57:47 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03B5E72
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2023 05:57:45 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id ada2fe7eead31-440b69847bfso1237346137.1
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2023 05:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687352265; x=1689944265;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I0q7WfcOFvqrhkctWq19KEIGjIjcLET4Slbyb/fAY3o=;
        b=E/lmjNjCDZAHjgnElIstz5Si1O802L65rZRpNfZbtbkt+A9BhjDzRx66AEiQrOrRvl
         OdLc8E8OdYpE2Mh+5eGAr6RsjSCpjKOJ/MpYlOQXcuiKfO4VimTjwU11Nwa9xtHUyksO
         jaUrx7EkPmgeltZJ7TuKF3a3fyqnfBw+Q71D1Qzq7wDKwISfm3Zoc7AeNcisKj2L2S3w
         ngkmmzzjHj6pXNUDN6r/FHE51ivYpGuQglCDHTEtwQXl+S4Ty13S4Y6AONOtjN5J5Ytk
         QV7nvXFzf9dXG2PmKHL4QrP1lHJnJEfix+yn2uu2voVYeArOj5iiDK2XOUNsrXRxhbOc
         J9sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687352265; x=1689944265;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I0q7WfcOFvqrhkctWq19KEIGjIjcLET4Slbyb/fAY3o=;
        b=HxhTMwefR5WGQPSnIeRlkztzWVeCMYaTfdQoKauE0wh/+iCN417gIpdodIgSQSN3yh
         tffrT+Wb2jovUlZx/oyfX/T2ibfQNDftiru14+6BaaMhmT09XYgkxv2GwOWfpA1tViT5
         YGjbXtOaIYpYvyD1Z01qumOXjWpXpajTh8B+3JDzfH8dkpNAmG58jfFW0c9xyUb88mNb
         FdNp42Df+hDzk7O2R8aaifS/J9PHTXmCHtD9Fj9uO0CxYi6nucCDgU7nUFxNsD4zLt1g
         F0K3VCXfDElg+h2tgOtWKMkZ5+lFYuhg+g+Du20vODGOpU229a/DqGpBDXavTx3IpVQN
         3v/g==
X-Gm-Message-State: AC+VfDzCEkX76p/miUtSwlZmIKBgSfxa9qR0Adkj1XqymWNCDuMsld8h
        Q+12uk0sBOhJ9yYHMd54l0FZNwC+gcq34ZjkXt4=
X-Google-Smtp-Source: ACHHUZ6DM8te8nRgkvXmkp/NPhagYZn8pkawRwEE1I5BrpfgHhi2yfyWzXk9PgxvaLLo4xxQORpKStEGGFMIyUP5reE=
X-Received: by 2002:a67:ebd8:0:b0:43f:5aa1:a23e with SMTP id
 y24-20020a67ebd8000000b0043f5aa1a23emr6862253vso.34.1687352264901; Wed, 21
 Jun 2023 05:57:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1687255035.git.alexl@redhat.com> <20230620161507.GA864@sol.localdomain>
 <CAL7ro1GEObg78=LE2h7H2x0TnsuqGTmt2xvuT3grROWNPzr46w@mail.gmail.com>
In-Reply-To: <CAL7ro1GEObg78=LE2h7H2x0TnsuqGTmt2xvuT3grROWNPzr46w@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 21 Jun 2023 15:57:33 +0300
Message-ID: <CAOQ4uxgv9AxmQ3BuwJqY1M-X_4N_hkBCATzxrnhWbxdy-XhA-w@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] ovl: Add support for fs-verity checking of lowerdata
To:     Alexander Larsson <alexl@redhat.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 21, 2023 at 2:27=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> On Tue, Jun 20, 2023 at 6:15=E2=80=AFPM Eric Biggers <ebiggers@kernel.org=
> wrote:
> >
> > On Tue, Jun 20, 2023 at 12:15:15PM +0200, Alexander Larsson wrote:
> > > This series depends on the commit
> > >   fsverity: rework fsverity_get_digest() again
> > > Which is in the "for-next" branch of
> > >   https://git.kernel.org/pub/scm/fs/fsverity/linux.git/
> > >
> > > This series, plus the above commit are also in git here:
> > >   https://github.com/alexlarsson/linux/tree/overlay-verity
> > >
> > > I would love to see this go into 6.5. So Eric, could you maybe Ack th=
e
> > > implementation patches separately from the documentation patches? The=
n
> > > maybe we can get this in early, and I promise to try to get the
> > > documentation up to standard during the 6.5 cycle as needed.
> >
> > I think it's gotten too late for 6.5.  If there is no 6.4-rc8, then the=
 6.5
> > merge window will open just 5 days from now.  This series has recently =
gone
> > through some significant changes, including in the version just sent ou=
t today
> > which I haven't had a chance to review yet.
> >
> > Please don't try to rush things in when they involve UAPI and on-disk f=
ormat
> > changes, which will have to be supported forever.  We need to take the =
time to
> > get them right.
> >
> > I also see that the overlayfs tree is already very busy in 6.5, with th=
e support
> > for data-only lower layers, lazy lookup of lowerdata, and the new mount=
 API.
> >
> > I think 6.6 would be a more realistic target.  That would give time to =
write
> > proper documentation as well, which is super important.  (Very often wh=
ile
> > writing documentation, I realize that I should do something differently=
 in the
> > code.  Please don't think of documentation as something can be done "la=
ter".)
>
> If 6.6 is what ends up happening I'm not gonna protest, it's not a
> huge issue for me, only mildly inconvenient. But, for now I'll at
> least keep targeting 6.5, and then we will have to see how it works
> out wrt reviews and what Miklos decides.
>
> I pushed out a v5 series today too, because the v4 series conflicted
> with some other changes in vfs.all that are staged for 6.5. v5 is also
> a bit simplified based on Amirs feedback, has some documentation
> updates and is refactored into more commits for easier review.
>

I reviewed v5 and it is all fine by me, but I do agree with Eric that
it has become quite late for 6.5 and other reviewers need to get
enough time to review v5, so no need to rush.

I also need some time to test verity feature which I hadn't had
the chance to do yet, so it looks like the stars are aligned for 6.6.
I am planning to be on vacation around 6.5-rc2..6.5-rc6 -
because of your efforts to get the patches ready in time for 6.5,
I will now have time to test your patches before -rc6, so your
efforts have not been in vain...

Thanks,
Amir.
