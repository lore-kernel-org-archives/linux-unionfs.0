Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D415C77B75
	for <linux-unionfs@archiver.kernel.org>; Mon, 15 May 2023 06:05:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238475AbjEOGFS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 15 May 2023 02:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238527AbjEOGEr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 May 2023 02:04:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41CF449C
        for <linux-unionfs@vger.kernel.org>; Sun, 14 May 2023 22:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684130169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hg9/BOM19HqXmOFBQ79tEo2+Me806o8+IF+gH4ba+/k=;
        b=QDVUjG2Bik1obzwsz9jtCW8rqopY8zGSRnJ9+gkGhV2SZGsUzKjgYtrkgzQJbKrV9VglJG
        AxSBasbjj3ofkDAxIdsrl0SZgk97wIqo2kylUQMQDAaa9ZleOA/1GklJ4p8at+ryN1//0v
        Fp4N1PNjClntHf6ceJmFMiiV23R6CH4=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-fNv_6ObrOUG_5sCfZoxqYw-1; Mon, 15 May 2023 01:56:06 -0400
X-MC-Unique: fNv_6ObrOUG_5sCfZoxqYw-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-331949eb356so78974825ab.0
        for <linux-unionfs@vger.kernel.org>; Sun, 14 May 2023 22:56:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684130165; x=1686722165;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hg9/BOM19HqXmOFBQ79tEo2+Me806o8+IF+gH4ba+/k=;
        b=AT+1VNx7SFRowqCHfvDO+AyS+a7iPONXTPxxzQp74z4Mt/HdLkFY/TEIYSxWyaHPrP
         8Tl14s0X1+U250yXwStHBa4elgJPqR75Ax8a/+izhZ4/P5tR2gDDnWHZbjk9+jqNNnq9
         Ld/iP2RBf9/KpK2RQ1RSV153XTqeTbXnHKpA3BpX0kGGktttnS7cWjL1y9Bnwtu+BWP5
         X95yaXLMvFUJ9skgOin5GRTMnXuRYlHb+m91AsD8MCmflbRKfrlPoc1r1p5FV2MyW3Oz
         9f+yU4EZsZ/otbdhoeWQpVJzaG2LAG5Lajo+rp1ZgkZknD4KDAJ5I2BG+4HDafvg80PY
         2LvA==
X-Gm-Message-State: AC+VfDw12ZzgEA2goJ6KkDlqf8JAGvwYdexzABvn347+dV9+duwaSfxu
        hn5ksuw6co7+X2Geo07pCOllFDTvHYEFgqyj1QKDiD0HLk39Lf7f2BtejSyi3EcDOLTiVfEbtLs
        Op3hEAK+6+l6ZhSOzK78q7iQk/TeqEnHLI0+WrWyWIw==
X-Received: by 2002:a92:4a06:0:b0:331:3b07:56e2 with SMTP id m6-20020a924a06000000b003313b0756e2mr19510788ilf.31.1684130165418;
        Sun, 14 May 2023 22:56:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4EigIvRctcx1SspUYVqwWZncHfhcXeRmsaiFfROR1fYAyEwjyE4+QRNgT7kWR6eRShXzhRBKJ4IbTANFmm5Pg=
X-Received: by 2002:a92:4a06:0:b0:331:3b07:56e2 with SMTP id
 m6-20020a924a06000000b003313b0756e2mr19510782ilf.31.1684130165076; Sun, 14
 May 2023 22:56:05 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1683102959.git.alexl@redhat.com> <20230514190903.GC9528@sol.localdomain>
 <CAOQ4uxj73Tu1XKSte-csHKH4pUN_84Px42MdZ4rVt9hUdjHJ2g@mail.gmail.com>
In-Reply-To: <CAOQ4uxj73Tu1XKSte-csHKH4pUN_84Px42MdZ4rVt9hUdjHJ2g@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Mon, 15 May 2023 07:55:54 +0200
Message-ID: <CAL7ro1EBpsq4EcNKod6Lr2km3MTEbJG+mPaneGy93DDKuMTrYQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] ovl: Add support for fs-verity checking of lowerdata
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, May 14, 2023 at 11:25=E2=80=AFPM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> On Sun, May 14, 2023 at 10:09=E2=80=AFPM Eric Biggers <ebiggers@kernel.or=
g> wrote:
> >
> > Hi Alexander,
> >
> > On Wed, May 03, 2023 at 10:51:33AM +0200, Alexander Larsson wrote:
> > > This patchset adds support for using fs-verity to validate lowerdata
> > > files by specifying an overlay.verity xattr on the metacopy
> > > files.
> > >
> > > This is primarily motivated by the Composefs usecase, where there wil=
l
> > > be a read-only EROFS layer that contains redirect into a base data
> > > layer which has fs-verity enabled on all files. However, it is also
> > > useful in general if you want to ensure that the lowerdata files
> > > matches the expected content over time.
> > >
> > > This patch series is based on the lazy lowerdata patch series by Amir=
[1].
> > >
> > > I have also added some tests for this feature to xfstests[2].
> > >
> > > I'm also CC:ing the fsverity list and maintainers because there is on=
e
> > > (tiny) fsverity change, and there may be interest in this usecase.
> > >
> > > Changes since v1:
> > >  * Rebased on v2 lazy lowerdata series
> > >  * Dropped the "validate" mount option variant. We now only support
> > >    "off", "on" and "require", where "off" is the default.
> > >  * We now store the digest algorithm used in the overlay.verity xattr=
.
> > >  * Dropped ability to configure default verity options, as this could
> > >    cause problems moving layers between machines.
> > >  * We now properly resolve dependent mount options by automatically
> > >    enabling metacopy and redirect_dir if verity is on, or failing
> > >    if the specified options conflict.
> > >  * Streamlined and fixed the handling of creds in ovl_ensure_verity_l=
oaded().
> > >  * Renamed new helpers from ovl_entry_path_ to ovl_e_path_
> > >
> > > [1] https://lore.kernel.org/linux-unionfs/20230427130539.2798797-1-am=
ir73il@gmail.com/T/#m3968bf64a31946e77bdba8e3d07688a34cf79982
> > > [2] https://github.com/alexlarsson/xfstests/commits/verity-tests
> > >
> > > Alexander Larsson (6):
> > >   fsverity: Export fsverity_get_digest
> > >   ovl: Break out ovl_e_path_real() from ovl_i_path_real()
> > >   ovl: Break out ovl_e_path_lowerdata() from ovl_path_lowerdata()
> > >   ovl: Add framework for verity support
> > >   ovl: Validate verity xattr when resolving lowerdata
> > >   ovl: Handle verity during copy-up
> > >
> > >  Documentation/filesystems/overlayfs.rst |  27 ++++
> > >  fs/overlayfs/copy_up.c                  |  31 +++++
> > >  fs/overlayfs/namei.c                    |  42 +++++-
> > >  fs/overlayfs/overlayfs.h                |  12 ++
> > >  fs/overlayfs/ovl_entry.h                |   3 +
> > >  fs/overlayfs/super.c                    |  74 ++++++++++-
> > >  fs/overlayfs/util.c                     | 165 ++++++++++++++++++++++=
--
> > >  fs/verity/measure.c                     |   1 +
> > >  8 files changed, 343 insertions(+), 12 deletions(-)
> >
> > Thanks for presenting this topic at LSFMM!
> >
> > I'm not an expert in overlayfs, but I've been working through this patc=
hset.
> >
> > One thing that seems to be missing, and has been tripping me up while r=
eviewing
> > this patchset, is that the overlayfs documentation
> > (Documentation/filesystems/overlayfs.rst) is not properly up to date wi=
th the
> > use case that is intended here.
> >
> > For example, the overlayfs documentation says "An overlay filesystem co=
mbines
> > two filesystems - an 'upper' filesystem and a 'lower' filesystem.".
> >
> > Apparently, that is out of date.  I think a correct statement would be:=
 An
> > overlay filesystem combines an optional upper directory with one or mor=
e lower
> > directories.
> >
> > And as I understand it, the use case here actually involves two lower
> > directories and no upper directory.
> >
> > There is also the "metacopy" feature, which the documentation describes=
 in the
> > section "Metadata only copy up".  The documentation makes it sound like=
 an
> > overlayfs internal optimization.
> >
> > However, when this patchset introduces the fsverity support, it talks a=
bout
> > "metacopy files".  As I understand it, the user is expected to create a
> > read-only filesystem that contains these "metacopy files".  It doesn't =
seem to
> > be documented what these are, exactly, and how to create them.  I assum=
e that
> > these are part of the implementation of "Metadata only copy up", but th=
ere seems
> > to be a gap where the documentation goes from describing the behavior o=
f
> > "metadata only copy up", to expecting users of overlayfs to know what a
> > "metacopy file" is and how to create them.
> >
>
> What may confuse you is that Alexander has a tool mkfs.composefs
> that creates hand crafted overlayfs, but it is not up to overlayfs.rst to
> document this tool.
>
> This patch set and documentation of the feature are standalone to
> overlayfs and they affect and explain standard user workloads.

Yeah, the documentation as part of the patch really just describes the
new options as they relate to how the kernel uses and produces these
new xattrs. I.e. as if you're using the new verity support only as a
way to make the meta-copy-up feature more robust by having the copy-up
operation record the digest of the source.

The way composefs uses the various features of overlayfs (metacopy,
redirect, verity, read-only-image) to combine into the "composefs"
feature isn't really described

> A "metacopy file" is one that has metadata changes in upper layer
> but the data is still read from the lower layer.

To be more specific, it is a sparse file in any layer other than the
lowermost lowerdir that has the "overlay.metacopy" xattr set. When
this file is accessed from the overlay mount, all the metadata is
taken from the file, but the content is taken from the similarly named
file in a lower layer.

In addition, an overlay.redirect xattr can be set on the file. This
allows specifying a separate filename for the content file in the
lower layer.

> The classic example, for which metacopy feature was developed is
> chwon -R on a mounted overlay without having to copy up the data.
>
> I agree that it would be good to clarify this term before using it.
>
> With mount options metacopy=3Don,verity=3Don, once a file's metadata
> was copied up, and its owner changed for the sake of the story, the
> lower data file cannot be replaced with another file with different data
> or without fsverity, while overlayfs is offline.
>
> > I think that it would be easier to understand and review this feature i=
f the
> > documentation was gotten up to date.
> >
>
> Those are all valid comments, but I don't think it would be fair to
> require Alexander to fix the out of date documentation of overlayfs.
>
> IMO, the documentation of verity feature should be judged for its
> own clarity (and I myself find it pretty clear) assuming that the reader
> is familiar with overlayfs and metacopy, but I will surely not object if
> Alexander wants to help improve overlayfs.rst.
>
> Thanks,
> Amir.
>


--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

