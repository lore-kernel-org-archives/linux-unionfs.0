Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EECCFC001E0
	for <linux-unionfs@archiver.kernel.org>; Wed, 16 Aug 2023 15:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343933AbjHPPDY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 16 Aug 2023 11:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343970AbjHPPDB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Aug 2023 11:03:01 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1101B2
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 08:02:59 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id d75a77b69052e-40fc670197aso34207971cf.1
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 08:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692198178; x=1692802978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=df9dQ7gPtVVoUo8GbiTxHmDTRJhf4wa9hfSclurXFPY=;
        b=LSNP4Sr22be/xUG2Kt+OzZGZGgiSWotxzPa5SlSaI471XXO0/p00nzUG+lMoPnVUyv
         Y/juuYnZtEj3ZZgl1TDxLaxI0tOKZFrXuG2Cmf+WE/9OOE+0Qh7dWLjjF2BYBhufYACe
         /G2BnmwNINjcTlwVEyl4SasakMlaUEpC+lmb+hSznD+4R6y8VG+365DW3tVWIInoENa7
         K3By3g3fAUHo6flNaOr8omb30YMABUzmCb7kwcRZU4JeL7dgoc5zCKVl6FV7uAbymhsH
         WArHh0a9eDha6AdF/cfHq6ehjovJu422auM/mREeSM4Mjjk5fi4Fdy78QTEUFDTuah1r
         55qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692198178; x=1692802978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=df9dQ7gPtVVoUo8GbiTxHmDTRJhf4wa9hfSclurXFPY=;
        b=hgzOoluaEgHuJHDderVWgGrq4zBo4K0jBEkcaN5rxoxDncLcBQGBbva18pyt9jvbaC
         jhkVEYffCCH0vA8MRh+XT1YnniharmWhggrDjrhNpLWP85vfsVXs4u3CyQE6Si79WO23
         yEsVjzdxbbm4q6rsYqevoVATBYw8C4XM9IOAsRztLQ+ybLF7MGpdQ+lp6Iztze5o7wGP
         UVqN3IKMe+SGQXoCxBIvCIM1hFnufMzPfLvhBrOdgYlv+HCxQhPgC+zPNCZc70NZR6ba
         3Q/yZYl3SY69lZzo4gqXoQxu3v8AzAS4koAcXGSdeskMew+iOSnM+QvVsDYRs7F7az23
         Ya7w==
X-Gm-Message-State: AOJu0Yy7ajGnMCQSCtTI32wCQhsXqLvqONwtmhsP7Uto9nWxpazraL7v
        uVBBlp4XcHA8zbN6WkiEK7x9OJduk20krScmVRo=
X-Google-Smtp-Source: AGHT+IFP88zmmKK+6YW9T0TmtlDE0FXwAuDLe1flGYw/qlZ6NIUS07FLbbBEyO3ZRMOBZVmkAwQ/AF6BPgUx+8jm+tQ=
X-Received: by 2002:a05:620a:2907:b0:760:76c1:9689 with SMTP id
 m7-20020a05620a290700b0076076c19689mr6805991qkp.16.1692198178552; Wed, 16 Aug
 2023 08:02:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230814140518.763674-1-amir73il@gmail.com> <20230814140518.763674-3-amir73il@gmail.com>
 <CAJfpegu=-+jA1026KoqrFBX9dsfvQbcjHbkNunkZ6A794mZ1TQ@mail.gmail.com>
 <CAOQ4uxiTtraLVdsKJdty6z89=Lm52DGHFf1i_aL9jQz3L80V9Q@mail.gmail.com> <CAJfpegudye=2e2BWtk+fmaKMN_vUnwsKM8fi-GPcEX5n_vEizQ@mail.gmail.com>
In-Reply-To: <CAJfpegudye=2e2BWtk+fmaKMN_vUnwsKM8fi-GPcEX5n_vEizQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 16 Aug 2023 18:02:47 +0300
Message-ID: <CAOQ4uxj+RAFeaqErOdE7xymUShawJka7L0noCopjzaeFY8ZQ-w@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] ovl: do not open/llseek lower file with upper
 sb_writers held
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Jan Kara <jack@suse.cz>, linux-unionfs@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Aug 15, 2023 at 10:07=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu>=
 wrote:
>
> On Tue, 15 Aug 2023 at 17:59, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > > What occurs to me is why are we bothering with getting write access o=
n
> > > the internal upper mnt each time.  Seems to me it's a historical thin=
g
> > > without a good reason.  Upper mnt is never changed from R/W to R/O.
> > >
> > > So the only thing we need to do is grab the upper mount write access
> > > on superblock creation and do the sb_start_write/end_write() thing
> > > which can't fail.  If upper mnt is read-only, we effectively have a
> > > read-only filesystem, and can handle it that way (sb->s_flags |=3D
> > > SB_RDONLY).
> > >
> > > There's still the possibility that we do some changes to upper even
> > > for non-modify operations.  But with careful review we can remove a
> > > most (possibly all) error handling cases from ovl_want_write()
> > > callsites when we do know that we have write access on upper.  And
> > > WARN_ON(__mnt_is_readonly(ovl_upper_mnt(ofs))) should ensure that we
> > > catch any mistakes.
> > >
> > > Hmm?
> > >
> >
> > I was thinking the same thing myself, before I went on this journey.
> > I reached the conclusion that doing only sb_start_write() would not be
> > safe against emergency remount rdonly of the upper sb.
> >
> > I guess if upper sb is emergency mounted rdonly, then overlayfs
> > sb would also be emergency remounted rdonly, but for example
> > ext4 sb can become rdonly on internal errors.
> > But maybe that is not the responsibility of vfs or ovl to care about?
>
> Consider the case of a writable open file: the mount write access is
> only checked on open.  So not having fine grained mnt write access
> checks is not without precedent.
>
> I'm not sure, but the number of added lines in this particular patch
> makes me think that at least during copy-up we could separate the mnt
> and the sb write locks.
>

The patch with separate locks during copy-up is not much smaller
but it is a lot nicer IMO:

https://github.com/amir73il/linux/commits/ovl_want_write-v3

I shall post these shortly after tests are complete.

Thanks,
Amir.
