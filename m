Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D34EEB64DB
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jun 2023 10:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbjFTKGi (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 06:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbjFTKGQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jun 2023 06:06:16 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE514118;
        Tue, 20 Jun 2023 03:06:10 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id ada2fe7eead31-440ac4b44a8so831633137.3;
        Tue, 20 Jun 2023 03:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687255570; x=1689847570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GZu6HJuUd7t+BoF8M06vELEEszqiWLVNspghDLlLsn8=;
        b=edgFvOcH/asyahDTMqtJRQmiLbZY1d3DGYUidGPdpkX9uNIl7qeJ/Hn3BhWATOUXqR
         8gJ/1CHXsxhY5CLy1F13PQUs/7SPOfIqP7X0JN6r/LVQn9Ce3YtuIxjwRK8yVwgTuRb2
         uIub4wsApnMsBAEhkqqBuslDe9EdFvWlzPdHNsy+wpOAn3kTt30rctRlPy5ikBLu9P32
         PHZ/iykaL6jR6DtD3cF115lf17w26qPNTYnmQ24a6doGGFoWyO0EMnbF8V9KttIRPlS2
         vgwAOqC7HAB0KgLGpZa2bzo9WseAOQxByfAdivM3bqPRDU5+g4TuTerZQGyNxAN/Xqw4
         wOwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687255570; x=1689847570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GZu6HJuUd7t+BoF8M06vELEEszqiWLVNspghDLlLsn8=;
        b=Wcfo1HJq2+wesJhzvH4axWTj2HUnGB3hUfSORcrScb3DSTHzk/KWZsUB2Lb6damETq
         WTb+9TywyGqUhokYyBq2QleRNbuLSphPrjHB0E/DCcTyTBoRoJR3YzUFEbuvoKpdv3d4
         p/Vqb8LMmuwr4/iiV6vdDvSTWjtZLj2JIPZRF5O4pK0AKm/TZc6I7wOxOzak3ImkqJOT
         YL1xt6y2O15ln+KzLr8sMZ1Ouqv3XSTy1li1UzZbQ/nmVxsPLgMDJv/xkYgROSg6ub0x
         Z6mvAVEblNaG5KOCcmLecKNVjGAWkPgiPslnFIYLkPiJtV8jc2DJNAYAkSthBYNoQioI
         GEcA==
X-Gm-Message-State: AC+VfDzZTVeNkXfeLrmNkXHVP2IMulzseipu++oCL2RdhQy0NEZzosZy
        MkrnjACYdgawoM/EXqQ3TEzz3wttrMOkDLcZehbs7MUmWSg=
X-Google-Smtp-Source: ACHHUZ7U12XaAnmwAy/mcO+N1hdPU4bc5c9xN68xJ3A1I3SK4LLwGfkalBx7dOIuh8dftq73f4I1irqmeDeJL3j5LOI=
X-Received: by 2002:a67:eec8:0:b0:43f:4d69:608f with SMTP id
 o8-20020a67eec8000000b0043f4d69608fmr4422772vsp.30.1687255569654; Tue, 20 Jun
 2023 03:06:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230618124506.2642352-1-amir73il@gmail.com> <20230620-dissident-bestmarke-33d41a1c4d40@brauner>
In-Reply-To: <20230620-dissident-bestmarke-33d41a1c4d40@brauner>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 20 Jun 2023 13:05:58 +0300
Message-ID: <CAOQ4uxhdbWHHwMZwot5Q0+K6RBKbSBNZDzQ2UCgWzBQLsxn0bg@mail.gmail.com>
Subject: Re: [PATCH] generic/604: Fix for overlayfs
To:     Christian Brauner <brauner@kernel.org>
Cc:     Zorro Lang <zlang@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 20, 2023 at 12:50=E2=80=AFPM Christian Brauner <brauner@kernel.=
org> wrote:
>
> On Sun, Jun 18, 2023 at 03:45:06PM +0300, Amir Goldstein wrote:
> > Since v6.3, I noticed that generic/604 does not run on overlayfs
> > because:
> >
> >   generic/604 -- upper fs needs to support d_type
> >
> > This is odd because the base fs I am using (xfs) does support d_type.
> >
> > The reason is that for overlayfs, this sequence run by this test:
> >
> >   _scratch_unmount &
> >   _scratch_mount
> >
> > Translates to:
> >
> >   umount $OVL_MNT; umount $BASE_MNT &
> >   mount $BASE_MNT ...; mount $OVL_MNT ...
> >
> > Which can end up reordred as:
> >
> >   umount $OVL_MNT;
> >   mount $BASE_MNT ...
> >                   umount $BASE_MNT &
> >                   mount $OVL_MNT ...
> >
> > and overlayfs is trying to use a non-existing upper fs.
> >
> > Use UMOUNT_PROG directly instead of the _scratch_unmount
> > helper, to avoid unmounting the base fs.
> >
> > Incidently, the only thing that has changed in overlayfs in v6.3
> > is idmapped mounts support and the test in question was run without
> > idmapped mounts enabled, so the cahnge in behavior must be related
> > to some subtle timing change.
>
> I implemented testing overlayfs on top of idmapped mounts in xfstests
> and changed a lot of the overlayfs test infrastructure. So I wouldn't be
> surprised if that's the reason.

Could be, but to clarify, I was comparing kernel v6.2 to v6.3 with
same xfstests and in both cases I did not set IDMAPPED_MOUNTS,
so _idmapped_mount() should have been a noop.

Thanks,
Amir.
