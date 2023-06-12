Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF7CC7EE25
	for <linux-unionfs@archiver.kernel.org>; Mon, 12 Jun 2023 11:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbjFLLez (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 07:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbjFLLec (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 12 Jun 2023 07:34:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538436E8D
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jun 2023 04:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686568209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cp8GoFCXutEUKrZ9b8hL6TEidWt/LQg4Mbbqz6HQOU8=;
        b=A4n2pkeMq4G89MTsyf5Zh8pPi9UOmO5PX451PvfZb7ZTgyt/0KpcuHnTvbbCTz6JgW5TrT
        nQFD8JN850cQASYNTIwTYg8GV9Q2ehrz4dNZPfAmFbBh1e4uAViDRV0xrvD/PWxWvHaqRA
        w2rinv4pbgWZeEVdiwUbJAPIb8esGkE=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-64-5EIXVi7VPL60w9_jbkF8wA-1; Mon, 12 Jun 2023 07:10:08 -0400
X-MC-Unique: 5EIXVi7VPL60w9_jbkF8wA-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-33d93feefb5so33596935ab.1
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jun 2023 04:10:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686568207; x=1689160207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cp8GoFCXutEUKrZ9b8hL6TEidWt/LQg4Mbbqz6HQOU8=;
        b=OLK9mS9jC2Vm/+i8HwqU7CTWiGPdlVZHi79U+StplaAsksvGrRxecYumWzvk1Fefm1
         n3iCqZ/FVEz1Dg2QyFZU7oHZPKV3+qXRI7zRee76KYvAtX2cN6fTp7GwJgV8Ix758KFD
         xf+KwPDPoCysfcRCqrfdf05UV4/Czej4WyFPcHQ2cx3VRuoK+Od0Dbj3fVp9munoS/e4
         EI3/Pvya+a3D+FGx92W0+p6zL+Z1P67PcjYUUnt9V2NsZJXWx7PHSbJIM0oq7Rb5030G
         sCPY1dXWdJpP/OpT+D4U+6OX6BNxn2KDdtn53QFphwbN85Fvyd3tj3iRN0cNXx268ToK
         fCgg==
X-Gm-Message-State: AC+VfDxI4C5xiNOl2+74uK2eePMQigC3mgBJP1aUO4uA8BI9SAFIYlQX
        eTJDaqFktV5YSiwFemMtW3KGeS2q0JaxU5DhGMc7u3NRNHsk1KYGWlUjQCcz+UmzKDfgclEj3nk
        mkxIDm049XGd6aaCbARS3vQOLVgcJ3HRt1plo3LMkQA==
X-Received: by 2002:a92:cacb:0:b0:338:b9a1:5d06 with SMTP id m11-20020a92cacb000000b00338b9a15d06mr7196196ilq.2.1686568207153;
        Mon, 12 Jun 2023 04:10:07 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4BxkHx/pslQNEhG/r7Ottt42/vgAZ6bfx3OXW+5lgTrwYxnDq/VSEVFxAH5ApNpEMJJb5h0WMxBR5yu7H3/N0=
X-Received: by 2002:a92:cacb:0:b0:338:b9a1:5d06 with SMTP id
 m11-20020a92cacb000000b00338b9a15d06mr7196179ilq.2.1686568206887; Mon, 12 Jun
 2023 04:10:06 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1686565330.git.alexl@redhat.com> <CAOQ4uxgmV1KKCeq8=8FPkAciwqPpz8JiSM8WEuxDaZbVuYcQ7Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxgmV1KKCeq8=8FPkAciwqPpz8JiSM8WEuxDaZbVuYcQ7Q@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Mon, 12 Jun 2023 13:09:56 +0200
Message-ID: <CAL7ro1EiYOOOqexrKy+UXRzmpGyCaNec3+LHGxnA0YfmoMDN3A@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] ovl: Add support for fs-verity checking of lowerdata
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jun 12, 2023 at 12:54=E2=80=AFPM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> On Mon, Jun 12, 2023 at 1:27=E2=80=AFPM Alexander Larsson <alexl@redhat.c=
om> wrote:
> >
> > This patchset adds support for using fs-verity to validate lowerdata
> > files by specifying an overlay.verity xattr on the metacopy
> > files.
> >
> > This is primarily motivated by the Composefs usecase, where there will
> > be a read-only EROFS layer that contains redirect into a base data
> > layer which has fs-verity enabled on all files. However, it is also
> > useful in general if you want to ensure that the lowerdata files
> > matches the expected content over time.
> >
> > I have also added some tests for this feature to xfstests[1].
>
> I can't remember if there is a good reason why your test does
> not include verify in a data-only layer.
>
> I think this test coverage needs to be added.

Yeah. I'll add that.

> >
> > I'm also CC:ing the fsverity list and maintainers because there is one
> > (tiny) fsverity change, and there may be interest in this usecase.
> >
> > Changes since v2:
> >  * Rebased on top of overlayfs-next
> >  * We now alway do verity verification the first time the file content
> >    is used, rather than doing it at lookup time for the non-lazy lookup
> >    case.
>
> Aparat from the minor comment:
>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>
> for the series.
>
> Thanks,
> Amir.
>
> >
> > Changes since v1:
> >  * Rebased on v2 lazy lowerdata series
> >  * Dropped the "validate" mount option variant. We now only support
> >    "off", "on" and "require", where "off" is the default.
> >  * We now store the digest algorithm used in the overlay.verity xattr.
> >  * Dropped ability to configure default verity options, as this could
> >    cause problems moving layers between machines.
> >  * We now properly resolve dependent mount options by automatically
> >    enabling metacopy and redirect_dir if verity is on, or failing
> >    if the specified options conflict.
> >  * Streamlined and fixed the handling of creds in ovl_ensure_verity_loa=
ded().
> >  * Renamed new helpers from ovl_entry_path_ to ovl_e_path_
> >
> > [1] https://github.com/alexlarsson/xfstests/commits/verity-tests
> >
> > Alexander Larsson (4):
> >   fsverity: Export fsverity_get_digest
> >   ovl: Add framework for verity support
> >   ovl: Validate verity xattr when resolving lowerdata
> >   ovl: Handle verity during copy-up
> >
> >  Documentation/filesystems/overlayfs.rst |  27 +++++
> >  fs/overlayfs/copy_up.c                  |  33 +++++-
> >  fs/overlayfs/file.c                     |   8 +-
> >  fs/overlayfs/namei.c                    |  54 +++++++++-
> >  fs/overlayfs/overlayfs.h                |  12 ++-
> >  fs/overlayfs/ovl_entry.h                |   3 +
> >  fs/overlayfs/super.c                    |  79 +++++++++++++-
> >  fs/overlayfs/util.c                     | 133 ++++++++++++++++++++++++
> >  fs/verity/measure.c                     |   1 +
> >  9 files changed, 340 insertions(+), 10 deletions(-)
> >
> > --
> > 2.40.1
> >
>


--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

