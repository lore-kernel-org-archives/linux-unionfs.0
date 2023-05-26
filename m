Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E02C6C7EE23
	for <linux-unionfs@archiver.kernel.org>; Fri, 26 May 2023 11:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236875AbjEZLhx (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 26 May 2023 07:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjEZLhw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 26 May 2023 07:37:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3B0198
        for <linux-unionfs@vger.kernel.org>; Fri, 26 May 2023 04:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685100978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KinZCk6AXt20Gi5dmtQy+zFYlA1B/3DFZjQHmqRSzrk=;
        b=iGA5+s/0FLomrVBy/yHnTB7s3auZaBBuBixXY8NUZ3K7pT3cbiEbP2a8R8LMX42a4OljXQ
        VgXLtYzvqniMgjoIeMwyL0G8jR8UoyNcWyTBSShOqoJQkc+ul9HLC5yCqrsP1LMteKcXYj
        5b5yQvU0e39bcS4kDCIyOCnwdr+1GbU=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-576-9XLt9obaOJOx0xEmpb6yMQ-1; Fri, 26 May 2023 07:36:17 -0400
X-MC-Unique: 9XLt9obaOJOx0xEmpb6yMQ-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7748b05ab49so53041839f.1
        for <linux-unionfs@vger.kernel.org>; Fri, 26 May 2023 04:36:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685100976; x=1687692976;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KinZCk6AXt20Gi5dmtQy+zFYlA1B/3DFZjQHmqRSzrk=;
        b=F+mAKjpU/aq29sOknaAVLX43VVtmaQbAkuomo3K0yIxLjJ1ZHZuK/GSPBqF+GYaO/T
         6id/xjIKjv17y3FOkkDk7gxM9xh6OOVEQdC76FtQfYlpm3djzaMFw07PP9ZgRg/GNCI9
         /uqZh4hPuwCWZH/9xYt8XIScpbR9GRO30lGN9VOhQA4CUJhZgi+VsCYay8xg+qORyWJ9
         vab85MLzaFo1VE8UJEvhmV4ZFUiPIUMiSQu4HDjhpnEdpN+xENZWyH6entsMnCi8xGBc
         JlnSQA7TOAWmbS4H6XH4Vfhk8ABnQvvw8LGjym5AfDLgMYDMdWxPLhrABy45iZCC8yRb
         SPsA==
X-Gm-Message-State: AC+VfDxaub8jQnjlIrX9UE/dQ2TRFmO07iexMy5d0wMgUxRe4ymaC6pl
        ZLBAXJbrIJE/ziQ3rGf0BoSBNay5fky8+EUQhtZCdYRwWk2M0b9jDg2HbEsn0zx9IHstPeKoaF+
        fAI3u5FjIQP/ioMABVlE8N3aeCnUtvPlGFylXzLltvg==
X-Received: by 2002:a92:c98d:0:b0:331:96e5:678b with SMTP id y13-20020a92c98d000000b0033196e5678bmr1117296iln.23.1685100976541;
        Fri, 26 May 2023 04:36:16 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7eNcLQHza1s7jUM9Rlt6qpHoh418zrLt7gUT8RwIAtEj5HYTnD59SSFXORH0A3XjnqzKkaBsy5IyPQ26lQFho=
X-Received: by 2002:a92:c98d:0:b0:331:96e5:678b with SMTP id
 y13-20020a92c98d000000b0033196e5678bmr1117283iln.23.1685100976206; Fri, 26
 May 2023 04:36:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230427130539.2798797-1-amir73il@gmail.com> <CAL7ro1G7DQS_aAC4+9-ppdQz_7vjoXdBLohZ6bKo6S75NQUDPA@mail.gmail.com>
 <CAOQ4uxhN1dPBkhAu3Zag8=RKCbzMQghuXnyp+uur83dRW8tz6Q@mail.gmail.com>
 <87h6s0z6rf.fsf@redhat.com> <CAOQ4uxhkCgU2=F2oAJn34Jor2_Hr56fLsa8cAAz936G05d-+ZQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxhkCgU2=F2oAJn34Jor2_Hr56fLsa8cAAz936G05d-+ZQ@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Fri, 26 May 2023 13:36:05 +0200
Message-ID: <CAL7ro1EoNDMxU2d9WYrb772VFWWMDWV=KVvrZDnK=5byemmo8Q@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Overlayfs lazy lookup of lowerdata
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, May 26, 2023 at 7:12=E2=80=AFAM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Thu, May 25, 2023 at 7:59=E2=80=AFPM Giuseppe Scrivano <gscrivan@redha=
t.com> wrote:
> >
> > Hi Amir,
> >
> > Amir Goldstein <amir73il@gmail.com> writes:
> >
> > > On Thu, May 25, 2023 at 6:21=E2=80=AFPM Alexander Larsson <alexl@redh=
at.com> wrote:
> > >>
> > >> Something that came up about this in a discussion recently was
> > >> multi-layer composefs style images. For example, this may be a usefu=
l
> > >> approach for multi-layer container images.
> > >>
> > >> In such a setup you would have one lowerdata layer, but two real
> > >> lowerdirs, like lowerdir=3DA:B::C. In this situation a file in B may
> > >> accidentally have the same name as a file on C, causing a redirect
> > >> from A to end up in B instead of C.
> > >>
> > >
> > > I was under the impression that the names of the data blobs in C
> > > are supposed to be content derived names (hash).
> > > Is this not the case or is the concern about hash conflicts?
> > >
> > >> Would it be possible to have a syntax for redirects that mean "only
> > >> lookup in lowerdata layers. For example a double-slash path
> > >> //some/file.
> > >>
> > >
> > > Anything is possible if we can define the problem that needs to be so=
lved.
> > > In this case, I did not understand why the problem is limited to find=
ing a file
> > > by mistake in layer B.
> > >
> > > If there are several data layers A:B::C:D why wouldn't we have the sa=
me
> > > problem with a file name collision between C and D?
> >
> > the data layer is constructed in a way that files are stored by their
> > hash and there is control from the container runtime on how this is
> > built and maintained.  So a file name collision would happen only when
> > on a hash collision.
> >
> > Differently for the other layers we've no control on what files are in
> > the image, unless we limit to mount only one EROFS as the first lower
> > layer and then all the other lower layers are data layers.
> >
> > Given your example above A:B::C:D, if both A and B are EROFS we are
> > limited in the files/directories that can be in B.
> >
> > e.g. we have A/foo with the following xattrs:
> >
> > trusted.overlay.metacopy=3D""
> > trusted.overlay.redirect=3D"/1e/de1743e73b904f16924c04fbd0b7fbfb7e45b86=
40241e7a08779e8f38fc20d"
> >
> > Now what would happen if /1e is present as a file in layer B?  It will
> > just cause the lookup for `foo` to fail with EIO since the redirect
> > didn't find any file in the layers below.
> >
> >
>
> I understand the problem and I understand why a // redirect to data-only =
layers
> would be a simple and workable solution for composefs.
>
> Unlike the rest of the changes to overlayfs that we worked on to support
> composefs, this would really be a composefs only on-disk format because i=
t
> could not be generated by overlayfs itself, so we need Miklos to chime in=
 to
> say if this is acceptable.
>
> I have one question though:
>
> If you place all the blobs under /.cfs/1e/... is that really going to
> be an issue?
> I mean the middle layers are not random stuff and I don't think we need t=
o worry
> about malicious images blocking the data layers, because malicious images=
 have
> much easier ways of making damage.

I think if you make the prefix (the /.cfs part) "weird" enough it will
only become an issue for the malicious layer case. For example, a
malicious layer could inject a file that was typically unused, but if
an upper layer happened to use a particular redirect path it would get
unexpected content for its redirect.

However, you wouldn't be able to inject such a base layer after the
fact, it would have to have been there already in the base layer used
when building the upper layer. So in this case I agree, such a
malicious layer used already at image build time can do malicious
things in much easier ways anyway.

> It doesn't seem so likely for images to overload /.cfs by mistake with
> anything other
> than a proper composefs blobs repository (which should have no hash confl=
icts)
> and in the unlikely case that the image does happen to have a rogue /.cfs=
 file
> the container runtime can declare that image invalid for composefs mount.
>
> Another observation: this problem reminds me of the "follow origin" [1] f=
eature
> I was working on a long time ago.
>
> [1] https://github.com/amir73il/linux/commits/ovl-follow-origin
>
> This work had a different use case and the patches (that follow directori=
es)
> are not relevant for this use case, but the same principle could be appli=
ed
> to following metacopy to lowerdata by origin when the lowerdata cannot be
> found by redirect (or redirected to "" to signify disconnected path).
>
> Overlayfs copied up files and metacopy in particular have an "origin" xat=
tr.
> The "origin" xattr holds a file handle of the origin inode and uuid of
> the origin layer.
> This xattr has some uses, but I would like to point out one particular us=
e -
> in ovl_lookup() we use ovl_check_origin() to find a lower non-dir, so
> that we can
> use its i_ino for the overlay inode.
>
> We do that also for non-metacopy and non-redirect. The special thing abou=
t
> ovl_check_origin() is that it is blind to the problem that you described.
> Unless the origin inode was deleted from the filesystem, overlayfs will f=
ind it.
> The path of the found "origin" may not be known to overlayfs (i.e. discon=
nected
> dentry), but it also does not matter to overlayfs.
>
> The reason I am telling you about this is because in the case that compos=
efs
> is used to create composefs layers on a specific machine or in a specific
> local network, where the blobs are going to be stored on a specific
> shared backing
> filesystem, using "origin" instead of "redirect" as the way to refer
> to the lower-data
> might not be such a bad idea.
>
> For example, in LSFMM, Lennart presented the idea of a system service tha=
t would
> be able to provide "signed composefs image creation" services for unprivi=
leged
> containers from standard OCI images. In that case, creating images
> optimized for a
> specific local blobs repository could be an option.
>
> Apart from enabling composefs mount for unprivileged containers, the cent=
ric
> system service scheme could also be used to "optimize" distributed compos=
efs
> images to the local storage (i.e. convert //data redirect to origin refer=
ence).
>
> Combined with Alex's verity feature, I think we could allow following low=
erdata
> by "origin" without any further opt-in from user, meaning:
> If lowerdata cannot be found by path (or has intentional "" redirect)
> AND if metacopy has verity xattr, defer to lazy lowerdata lookup,
> where lowerdata would be looked up by origin.
>
> Does this sound like something that would be useful for composefs ecosyst=
em?
> If it is, I could send a patch for testing.

I can't think of any use of this currently. Generally we very rarely
work with images using a backing store tied to a particular machine
like this. Generally the goal is to have something you can distribute.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

