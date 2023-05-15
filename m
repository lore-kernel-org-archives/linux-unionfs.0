Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A61ECC77B7D
	for <linux-unionfs@archiver.kernel.org>; Mon, 15 May 2023 06:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238849AbjEOGrj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 15 May 2023 02:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240103AbjEOGri (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 May 2023 02:47:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353A81BCC
        for <linux-unionfs@vger.kernel.org>; Sun, 14 May 2023 23:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684133203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KAO4OYx+CvEgSrP0Lc+Dq0btGojc5GqPxlfkTsCupXw=;
        b=TbVm8rBPU4m4Bc0mKUH9+sypoiQa50kRz0TDN+vCRmg7iFGwUfifUAq3ej1QSzrvKMnLPo
        x6akjiV0f0f/dT4CgJ2EtVvOaymvYR4wrfBjq5N+/msH0QbtYv0pAlMLHvJI63MTwpKKV4
        4NejFFSJv1CbuIlgu9UPHS71m0IyMjw=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-TPSoBIwxMpuxGab-fMra_Q-1; Mon, 15 May 2023 02:46:42 -0400
X-MC-Unique: TPSoBIwxMpuxGab-fMra_Q-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-331ab91abdeso174318095ab.0
        for <linux-unionfs@vger.kernel.org>; Sun, 14 May 2023 23:46:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684133201; x=1686725201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KAO4OYx+CvEgSrP0Lc+Dq0btGojc5GqPxlfkTsCupXw=;
        b=ZYhfdDamngfLaCXphHRCwOheeSRjMv31kUsmstl8TVY5K0IqB+z7EGL4idWrDPR838
         R/ZXkBcOlmSZ9cdCbhVbEjkfxFZgVT9sBKO9PIr3EoG+QngL7ErTcjCmxOUEeLThQd+C
         YZLAk+tuqdMSbqkXOmWlHDYjX2yHcFjcn0+mzK0UyX1nNXEqzHav+pcvnSKtNhG643uo
         g9kVVT8my1U7EPvYKW3YKVQRzvOIzFkKUepL57HbrH7o6wLFqVrDWENxLG21Z3vIaMGf
         /thRDZhtJVpGgSA04FvNr9WgUYPcX+S4/IIrLU8nKupfT4XRfvUQpKuZQwUn0BDDNvK+
         TREg==
X-Gm-Message-State: AC+VfDxvl7bNOvezlo5NXFgRAK6yOsLca60VfIjggPqKk+9lopNxcbF1
        yxvNZZMukt3HIiOGzf9h7vlzXFVa/okutz99J431aSebng3HXoFYrzwRdfN6VX05IP0c/EhcmAh
        swPVbZ+571gST2+aBv/yelXJ2sSZM9zjq+me9m+vIVw==
X-Received: by 2002:a92:c0c9:0:b0:337:8342:e6a5 with SMTP id t9-20020a92c0c9000000b003378342e6a5mr2635687ilf.31.1684133201318;
        Sun, 14 May 2023 23:46:41 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7OaAVV+swMnkzhwcIFNcVNKS7Pt+STutkJWfUnbVbiLDbVoBJAbLgS1K90NNVDEz8Z3vwx8GrHVQziEnVEpF8=
X-Received: by 2002:a92:c0c9:0:b0:337:8342:e6a5 with SMTP id
 t9-20020a92c0c9000000b003378342e6a5mr2635675ilf.31.1684133201085; Sun, 14 May
 2023 23:46:41 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1683102959.git.alexl@redhat.com> <0292ade77250a8bb563744f596ecaab5614cbd80.1683102959.git.alexl@redhat.com>
 <20230514192227.GE9528@sol.localdomain> <CAL7ro1EaqFcS5sRAAJLWuiy4OHEP8KGXTm5T-LRh09XSrnav5A@mail.gmail.com>
 <20230515060008.GA15871@sol.localdomain>
In-Reply-To: <20230515060008.GA15871@sol.localdomain>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Mon, 15 May 2023 08:46:30 +0200
Message-ID: <CAL7ro1GGAfdZG9cHDWE2vnhY5tSE=9MxYi_n_gJHRfaw7zMSgg@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] ovl: Add framework for verity support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        amir73il@gmail.com, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, May 15, 2023 at 8:00=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Mon, May 15, 2023 at 07:44:13AM +0200, Alexander Larsson wrote:
> > On Sun, May 14, 2023 at 9:22=E2=80=AFPM Eric Biggers <ebiggers@kernel.o=
rg> wrote:
> > >
> > > On Wed, May 03, 2023 at 10:51:37AM +0200, Alexander Larsson wrote:
> > > > +- "require":
> > > > +    Same as "on", but additionally all metacopy files must specify=
 a
> > > > +    verity xattr. This means metadata copy up will only be used if
> > > > +    the data file has fs-verity enabled, otherwise a full copy-up =
is
> > > > +    used.
> > >
> > > The second sentence makes it sound like an attacker can inject arbitr=
ary data
> > > just by replacing a data file with one that doesn't have fsverity ena=
bled.
> > >
> > > I really hope that's not the case?
> > >
> > > I *think* there is a subtlety here involving "metacopy files" that we=
re created
> > > ahead of time by the user, vs. being generated by overlayfs.  But it'=
s not
> > > really explained.
> >
> > I'm not sure what you mean here? When you say "replacing a data file",
> > do you mean "changing the content of the lowerdir"?
>
> Yes.  Specifically the data-only lowerdir.
>
> > Because if you can just change lowerdir content then you can make users=
 of the
> > overlayfs mount read whatever data you want (independent of metacopy or=
 any of
> > this).
>
> But isn't preventing that the whole point of your feature?
>
> What am I missing?

If by "your feature", you mean the full composefs idea, then things
are different. In this case the root mount is an overlayfs with two
lowerdirs and no upper. The uppermost lower is a read-only erofs mount
with metadata and overlay xattrs for all files, and the lowermost one
is a data-only dir. You cannot modify the uppermost layer (since it's
a fsverity readonly erofs file). If you modify a data-only file it
will be detected at validation, because it can only be reached from
redirects in the image file, and we ensured all image files specified
a digest. There is no upper dir, so the overlayfs mount itself is not
writable, and thus there can be any meta-copy-up operations triggered
at all.

However, even if you had an upper dir ("writable composefs" usecase) I
don't see a problem. If you trigger a full (i.e. non-metadata) copy-up
then the copy-up operation itself will validate the data from the
lower at copy time (due to the verity xattr on the "middle layer").


I think again there is some confusion due to the two kinds of usecases
for the verity support. The basic usecase is just for general
robustness. I.e it allows the kernel to record information about the
original state of the content file when generating a metacopy
reference to it. If you later accidentally mount the overlayfs against
the wrong lower version you will get told about it. The second usecase
is the tamper proofing image case (composefs), and its security
depends on more details (i.e. the readonly image part and its
construction).

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

