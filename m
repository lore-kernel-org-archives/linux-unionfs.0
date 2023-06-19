Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A57E0EB64D9
	for <linux-unionfs@archiver.kernel.org>; Mon, 19 Jun 2023 08:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjFSIBN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 19 Jun 2023 04:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbjFSIAr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Jun 2023 04:00:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A341BDC
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Jun 2023 00:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687161550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PttGsP00aRBaVy89CIKR6rFg9VqQnu6lyJb2FpOUizA=;
        b=DgbEje2GiqjJCPpGMLzBK0jpxkNXHZaUnsHvquEg2HjJk0UwH1OaMG1vIsaNh9k9z3Kq4d
        50QohMVKXHDThc99dpQ94xmnd29yMtV2t9m0Nm3tBtc5CBvLxKWaMnaZPtek1tR5GU8/Y0
        BrlyYr5YBpa+xKXdBD/TPNc2q4ZBBn8=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-XgsPBAW_NV2_AKvnwikSCg-1; Mon, 19 Jun 2023 03:59:08 -0400
X-MC-Unique: XgsPBAW_NV2_AKvnwikSCg-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-33d5df1a8ddso24314315ab.2
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Jun 2023 00:59:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687161548; x=1689753548;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PttGsP00aRBaVy89CIKR6rFg9VqQnu6lyJb2FpOUizA=;
        b=QuSvWC6MbR/cX5njNJE4iPYVTY3Ei61V+ajsE6No+WYBW6jI7XMpKThbj8y8wy0FIG
         VZHt+gI9K0QPKrgd3Ta6HchUoivYzp/p4bI7DFD9LzhQ814sKBBWRCHms2QTQnsEirE3
         ViMJ9Y3vcNXTVKmtTFmKuFBCkN+kPtg35X/Z/sR8e1/ktm3Xi/gXmo0y0MN49KwTvyE8
         vRtd27v22kKi4vuJ0fHAVJedjzsueeNr02Ki/cVyXb8994MmOGtDXAuPBNeP3R6zJXTr
         kKjlWRzYm2rKRA5liWlEOclyyKyGMr1Gzmtq6UcFYA0IAj6hwRCINGVPC11U70B3Qdyh
         gDEg==
X-Gm-Message-State: AC+VfDxsOvaLLXX39OKzUNqV7faDSSMIqLVF4yZmTtqjyWuFBtLPHsOq
        NkR2NBVugz8CvbZXp33DWnGXIoqFSK2gPDav54KkYdsXtXRXtEZVQIzSOqVckZpTIkplWDRIDmT
        m1pU7oS9OhTPiWzhPv9ytQ17EgeW9xpiCGeS1p69I9Y+sSjMIjg==
X-Received: by 2002:a92:c989:0:b0:341:d9e7:9d94 with SMTP id y9-20020a92c989000000b00341d9e79d94mr4867835iln.25.1687161547825;
        Mon, 19 Jun 2023 00:59:07 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7GMXqYzkPxBQhV1WNeUjID0xET/28y5LLauyHtHC+Hn0YMLlXYK1/ghA1EFdVLa0RQx3svyiIVJEKoiDwyAm4=
X-Received: by 2002:a92:c989:0:b0:341:d9e7:9d94 with SMTP id
 y9-20020a92c989000000b00341d9e79d94mr4867826iln.25.1687161547563; Mon, 19 Jun
 2023 00:59:07 -0700 (PDT)
MIME-Version: 1.0
References: <03ac0ffd82bc1edc3a9baa68d1125f5e8cad93fd.1686565330.git.alexl@redhat.com>
 <20230612163216.GA847@sol.localdomain> <CAOQ4uxjS5-7_PaoxM41YaXW+KxwLK_K8AyJMaoi1m-3P-vZ9Kw@mail.gmail.com>
 <20230613063704.GA879@sol.localdomain> <CAOQ4uxg6BD_RDtWob5q2eX6uQ5hcWrK7wEDcBhFVrGM3vsn=NA@mail.gmail.com>
 <20230613182233.GC1139@sol.localdomain> <CAOQ4uxhzJFpfuFLxK2s0JqS5qGQDGfndFPY7n2NDmZso4cG4Rg@mail.gmail.com>
 <CAL7ro1FF2iUjPsXrha8tELYvi9MwW7WRhksqX7ahSXc4gPHraw@mail.gmail.com>
 <20230615235229.GC25295@sol.localdomain> <CAL7ro1G+Dnet=M+CUY7e_9nJhOtD3rQm16C7bWkMBVnfcvm4Yg@mail.gmail.com>
 <20230617194735.GA4703@sol.localdomain>
In-Reply-To: <20230617194735.GA4703@sol.localdomain>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Mon, 19 Jun 2023 09:58:56 +0200
Message-ID: <CAL7ro1G+rdRKvFcoOafvA=5us=RrA-rQ2kTvKP-_jWMiiXPCrg@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] ovl: Add framework for verity support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Jun 17, 2023 at 9:47=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Fri, Jun 16, 2023 at 10:11:06AM +0200, Alexander Larsson wrote:
> > On Fri, Jun 16, 2023 at 1:52=E2=80=AFAM Eric Biggers <ebiggers@kernel.o=
rg> wrote:
> > >
> > > On Wed, Jun 14, 2023 at 09:57:41AM +0200, Alexander Larsson wrote:
> > > > When a layer containing verity xattrs is used, it means that any
> > > > such metacopy file in the upper layer is guaranteed to match the
> > > > content that was in the lower at the time of the copy-up. If at any=
 time
> > > > (during a mount, after a remount, etc) such a file in the lower is
> > > > replaced or modified in any way, then opening the corresponding fil=
e on
> > > > overlayfs will result in EIO and a detailed error printed to the ke=
rnel logs.
> > > > (Actually, due to caching the overlayfs mount might still see the p=
revious
> > > > file contents after a lower file is replaced under an active mount,=
 but
> > > > it will never see the wrong data.)
> > >
> > > Well, the key point of fsverity is that data is not verified until it=
 is
> > > actually read.  At open time, the fsverity file digest is made availa=
ble in
> > > constant time, and overlayfs will verify that.  However, invalid data=
 blocks are
> > > not reported until the data is actually read.  The error that applica=
tions get
> > > is EIO for syscalls, and SIGBUS for memory-mapped reads, as mentioned=
 at
> > > https://www.kernel.org/doc/html/latest/filesystems/fsverity.html#acce=
ssing-verity-files
> > >
> > > So overlayfs might report EIO at open time, or it might not report an=
 error
> > > until the modified data is read.  And in the latter case, presumably =
the error
> > > seen by the application matches the one for using fsverity natively?
> >
> > Yes, I'm aware of that, but do we need to describe this in the
> > overlayfs documentation?
> > The text I wrote is describing the behaviour that overlayfs adds to
> > the mix, and I sort of
> > assumed the late validation from fs-verity itself would be known about
> > if the file already
> > has fs-verity enabled.
> >
> > > You can link to the fsverity documentation somewhere if it would be h=
elpful, but
> > > I'd still like the semantics of how this works on overlayfs to be doc=
umented.
> >
> > I guess just adding a link to that is not that bad. What about:
> >
> > ----
> > When a layer containing verity xattrs is used, it means that any such
> > metacopy file in the upper layer is guaranteed to match the content
> > that was in the lower at the time of the copy-up. If at any time
> > (during a mount, after a remount, etc) such a file in the lower is
> > replaced or modified in any way, then opening the corresponding file
> > on overlayfs will result in EIO and a detailed error printed to the
> > kernel logs.  (Actually, due to caching the overlayfs mount might
> > still see the previous file contents after a lower file is replaced
> > under an active mount, but it will never see the wrong data.)  In
> > addition fs-verity will do late validation of the file content, as
> > described in :ref:`Documentation/filesystems/fsverity.rst
> > <accessing_verity_files>`.
>
> That still has the incorrect statement "If at any time (during a mount, a=
fter a
> remount, etc) such a file in the lower is replaced or modified in any way=
, then
> opening the corresponding file on overlayfs will result in EIO and a deta=
iled
> error printed to the kernel logs."  See my last email where I explained w=
hy that
> statement is not correct.

If the modification of the file happens via the kernel vfs API, then
the new backing file will have either have no, or the wrong fs-verity
digest, which will be reported by overlayfs on open. It is true that a
modification on the block level which the vfs is unaware of will be
reported at read time, by fs-verity (i.e. independent of overlayfs).
This is what I meant by the "in addition .." part, but maybe that is
not clear. I'll try to rephrase it.


--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

