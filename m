Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A1AC77B7C
	for <linux-unionfs@archiver.kernel.org>; Fri, 26 May 2023 05:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjEZFMo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 26 May 2023 01:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjEZFMn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 26 May 2023 01:12:43 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8B813A
        for <linux-unionfs@vger.kernel.org>; Thu, 25 May 2023 22:12:41 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id a1e0cc1a2514c-78400319b0eso106235241.2
        for <linux-unionfs@vger.kernel.org>; Thu, 25 May 2023 22:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685077961; x=1687669961;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b7W6TMm5uP3LkdztfjoKf9gr6c2OOcsxMDnbcXD5sGM=;
        b=WCSHjfbNyjYUTh8iWUnmIeqktiugK/JuIc42oezzJgh6VIFxUM8yz3bNqCJGqPw1Ne
         MjXxSgQuYaod0mYM7RW7ZzjCtUdIEdyhhAL/Wsy+Wvy8RKdKpgTDK3oTZDDJ+1MrCeCo
         0XcYOGGDujmpprtUTTH2c4Nj0GC+kcgXxd7gNDXerhnRixly07JZW+znhzuV2FZjlnqv
         byVcW53rGPNWFWajGcfvA1MBsZapoTRfe/HKwQpoKRW9+z4U0uyeDgnySFXVOe2c8Swq
         pc7+jAYK2Fbiw+/aRSuOBlm5dJ8Js+a35Ting7LNdxsL5AtFyfaSkCceydFvQj40Kykt
         WtKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685077961; x=1687669961;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b7W6TMm5uP3LkdztfjoKf9gr6c2OOcsxMDnbcXD5sGM=;
        b=SDeGIcWe2rlC+QCvKPizNrQbTyMNg8Rd1rZ0eUQsa+C+Lm56zxDAlF1dhoZqSBgRuD
         csThTkYjxGKq80rggEjPoUZHdQZLQgAEyUawtPyzD3208MjDpu8oJeur8UQm+JfYbjeO
         Gzm11KclB+XK68qhfrfPKL3OY8N8Oa0mvSAah9X7ZB8mzi71nkm03LLeORfpW0jHcsMW
         BCS5GKJXuoePt8KQNS9SqtsqZXIB00Mpd9/zns/+0q6MoWd+G0eMlBt6CegpskxXP+jg
         TIH26Th7xbpjN3XjXNdiXMXvELbrfddmu8rxVZ0hdssMuKCm48eqGbEhUuBm2UgHafwJ
         T/8g==
X-Gm-Message-State: AC+VfDykDfSfxgWg2mfXv7VmE6S1WFTq/rHNpRtDNy4D9OJt85KEOhFk
        Z4Um4vRA8/iElMg3h40QfYAVtDruj/IQxzTB95Y=
X-Google-Smtp-Source: ACHHUZ4dRPLITAiPTYykCuuvUa3Hf7NCHlKdU6gAviXAhoQiCd7/679y9p8KBe9B7EBD0CZ46ZdYRI1XSRQ9yj6gpn4=
X-Received: by 2002:a05:6102:3bce:b0:434:5ae9:5435 with SMTP id
 a14-20020a0561023bce00b004345ae95435mr149627vsv.11.1685077960786; Thu, 25 May
 2023 22:12:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230427130539.2798797-1-amir73il@gmail.com> <CAL7ro1G7DQS_aAC4+9-ppdQz_7vjoXdBLohZ6bKo6S75NQUDPA@mail.gmail.com>
 <CAOQ4uxhN1dPBkhAu3Zag8=RKCbzMQghuXnyp+uur83dRW8tz6Q@mail.gmail.com> <87h6s0z6rf.fsf@redhat.com>
In-Reply-To: <87h6s0z6rf.fsf@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 26 May 2023 08:12:29 +0300
Message-ID: <CAOQ4uxhkCgU2=F2oAJn34Jor2_Hr56fLsa8cAAz936G05d-+ZQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Overlayfs lazy lookup of lowerdata
To:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Alexander Larsson <alexl@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, May 25, 2023 at 7:59=E2=80=AFPM Giuseppe Scrivano <gscrivan@redhat.=
com> wrote:
>
> Hi Amir,
>
> Amir Goldstein <amir73il@gmail.com> writes:
>
> > On Thu, May 25, 2023 at 6:21=E2=80=AFPM Alexander Larsson <alexl@redhat=
.com> wrote:
> >>
> >> Something that came up about this in a discussion recently was
> >> multi-layer composefs style images. For example, this may be a useful
> >> approach for multi-layer container images.
> >>
> >> In such a setup you would have one lowerdata layer, but two real
> >> lowerdirs, like lowerdir=3DA:B::C. In this situation a file in B may
> >> accidentally have the same name as a file on C, causing a redirect
> >> from A to end up in B instead of C.
> >>
> >
> > I was under the impression that the names of the data blobs in C
> > are supposed to be content derived names (hash).
> > Is this not the case or is the concern about hash conflicts?
> >
> >> Would it be possible to have a syntax for redirects that mean "only
> >> lookup in lowerdata layers. For example a double-slash path
> >> //some/file.
> >>
> >
> > Anything is possible if we can define the problem that needs to be solv=
ed.
> > In this case, I did not understand why the problem is limited to findin=
g a file
> > by mistake in layer B.
> >
> > If there are several data layers A:B::C:D why wouldn't we have the same
> > problem with a file name collision between C and D?
>
> the data layer is constructed in a way that files are stored by their
> hash and there is control from the container runtime on how this is
> built and maintained.  So a file name collision would happen only when
> on a hash collision.
>
> Differently for the other layers we've no control on what files are in
> the image, unless we limit to mount only one EROFS as the first lower
> layer and then all the other lower layers are data layers.
>
> Given your example above A:B::C:D, if both A and B are EROFS we are
> limited in the files/directories that can be in B.
>
> e.g. we have A/foo with the following xattrs:
>
> trusted.overlay.metacopy=3D""
> trusted.overlay.redirect=3D"/1e/de1743e73b904f16924c04fbd0b7fbfb7e45b8640=
241e7a08779e8f38fc20d"
>
> Now what would happen if /1e is present as a file in layer B?  It will
> just cause the lookup for `foo` to fail with EIO since the redirect
> didn't find any file in the layers below.
>
>

I understand the problem and I understand why a // redirect to data-only la=
yers
would be a simple and workable solution for composefs.

Unlike the rest of the changes to overlayfs that we worked on to support
composefs, this would really be a composefs only on-disk format because it
could not be generated by overlayfs itself, so we need Miklos to chime in t=
o
say if this is acceptable.

I have one question though:

If you place all the blobs under /.cfs/1e/... is that really going to
be an issue?
I mean the middle layers are not random stuff and I don't think we need to =
worry
about malicious images blocking the data layers, because malicious images h=
ave
much easier ways of making damage.

It doesn't seem so likely for images to overload /.cfs by mistake with
anything other
than a proper composefs blobs repository (which should have no hash conflic=
ts)
and in the unlikely case that the image does happen to have a rogue /.cfs f=
ile
the container runtime can declare that image invalid for composefs mount.

Another observation: this problem reminds me of the "follow origin" [1] fea=
ture
I was working on a long time ago.

[1] https://github.com/amir73il/linux/commits/ovl-follow-origin

This work had a different use case and the patches (that follow directories=
)
are not relevant for this use case, but the same principle could be applied
to following metacopy to lowerdata by origin when the lowerdata cannot be
found by redirect (or redirected to "" to signify disconnected path).

Overlayfs copied up files and metacopy in particular have an "origin" xattr=
.
The "origin" xattr holds a file handle of the origin inode and uuid of
the origin layer.
This xattr has some uses, but I would like to point out one particular use =
-
in ovl_lookup() we use ovl_check_origin() to find a lower non-dir, so
that we can
use its i_ino for the overlay inode.

We do that also for non-metacopy and non-redirect. The special thing about
ovl_check_origin() is that it is blind to the problem that you described.
Unless the origin inode was deleted from the filesystem, overlayfs will fin=
d it.
The path of the found "origin" may not be known to overlayfs (i.e. disconne=
cted
dentry), but it also does not matter to overlayfs.

The reason I am telling you about this is because in the case that composef=
s
is used to create composefs layers on a specific machine or in a specific
local network, where the blobs are going to be stored on a specific
shared backing
filesystem, using "origin" instead of "redirect" as the way to refer
to the lower-data
might not be such a bad idea.

For example, in LSFMM, Lennart presented the idea of a system service that =
would
be able to provide "signed composefs image creation" services for unprivile=
ged
containers from standard OCI images. In that case, creating images
optimized for a
specific local blobs repository could be an option.

Apart from enabling composefs mount for unprivileged containers, the centri=
c
system service scheme could also be used to "optimize" distributed composef=
s
images to the local storage (i.e. convert //data redirect to origin referen=
ce).

Combined with Alex's verity feature, I think we could allow following lower=
data
by "origin" without any further opt-in from user, meaning:
If lowerdata cannot be found by path (or has intentional "" redirect)
AND if metacopy has verity xattr, defer to lazy lowerdata lookup,
where lowerdata would be looked up by origin.

Does this sound like something that would be useful for composefs ecosystem=
?
If it is, I could send a patch for testing.

Thanks,
Amir.
