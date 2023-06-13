Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03141C77B7A
	for <linux-unionfs@archiver.kernel.org>; Tue, 13 Jun 2023 08:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238393AbjFMIJB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 13 Jun 2023 04:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbjFMIJA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 13 Jun 2023 04:09:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25166E4E
        for <linux-unionfs@vger.kernel.org>; Tue, 13 Jun 2023 01:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686643698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=47jtj5ZCTRGYAOKrFcvMz5gdwq3YU7Hc0vdVnlyKypQ=;
        b=GZ5XbI6smPOM0ASWBvyoRpd+/1p9IDYZTzyxrxAqy0RHQY99bs+xZpjJZBuKc6kjS8rPpM
        O2dsJ0/JVJzPmjx2obTQ6GcY+BdeNPE51uysEnO8IcmlcWgafqig0VxDygp2vIy/inN7a7
        0H5RBieI2ofxBmHbDnpUD0PF+zhLI8Y=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-dcuy28rgPoiTEIwUB4N53Q-1; Tue, 13 Jun 2023 04:08:16 -0400
X-MC-Unique: dcuy28rgPoiTEIwUB4N53Q-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-33d93feefb5so46711785ab.1
        for <linux-unionfs@vger.kernel.org>; Tue, 13 Jun 2023 01:08:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686643696; x=1689235696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=47jtj5ZCTRGYAOKrFcvMz5gdwq3YU7Hc0vdVnlyKypQ=;
        b=iq8BjU1qq+JxagHR86StbURha8fzCZXCgbHfhRix+cQc4/cq+Aub81fNxj/gPsf+tK
         4R4G7OjpU8vKgVZiSW2kh1IsF+TEP0KsbldjQL5gwc83A3jRMXq5h0jhqmeQfkrsCRpH
         1oJe3cpvaamx3fkTzJg2Uf1HRUKg+APkqrnvEqlns1fQXbyMgsZ3185IZWaP9RD5as6q
         kEyF88MuO1Ojwq96fXoiZWQofHBQkyRKOk+rXOJPBLcL0p5Qcxhapn7wCYW0hYKV3jxw
         A6X3Yz8yX8r2VeGUB4OwmUpfg+8EiOKfs82POOaBQXQiO94I3MfJ2lDz06rru/qO9Jf0
         PHtg==
X-Gm-Message-State: AC+VfDwJ7nbQ0g4nOIHYFfEa9yDTA1atlrzrJcKvvSAw4tqCe1+pTR7R
        1LGoH39s8CXPI3Gqa2cnnGJMPrXeTlZI6zVx7ctE/Ws3sTaDg4bpoyfjsxy4pJSAqyzk4iex+2/
        dQ4beJqW0AfZI5iBjMXE2ZtH07gcYbCqdTDTU1bEHXQ==
X-Received: by 2002:a92:cd06:0:b0:33b:1635:359f with SMTP id z6-20020a92cd06000000b0033b1635359fmr9615928iln.22.1686643696012;
        Tue, 13 Jun 2023 01:08:16 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5wqPBqFlGDRBSyOmXhn04DAOrFwe3wnAVIOAlClJokXjAJNEqz+hBWHNfQUOIzhMGnwJ8QRm1rg3IAN8/d0aw=
X-Received: by 2002:a92:cd06:0:b0:33b:1635:359f with SMTP id
 z6-20020a92cd06000000b0033b1635359fmr9615906iln.22.1686643695456; Tue, 13 Jun
 2023 01:08:15 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1686565330.git.alexl@redhat.com> <03ac0ffd82bc1edc3a9baa68d1125f5e8cad93fd.1686565330.git.alexl@redhat.com>
 <20230612163216.GA847@sol.localdomain> <CAOQ4uxjS5-7_PaoxM41YaXW+KxwLK_K8AyJMaoi1m-3P-vZ9Kw@mail.gmail.com>
 <20230613063704.GA879@sol.localdomain>
In-Reply-To: <20230613063704.GA879@sol.localdomain>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Tue, 13 Jun 2023 10:08:04 +0200
Message-ID: <CAL7ro1EvvGjtVQ79YJrr_iMccPFzQY5rn57wL7cz=OPE7AN66A@mail.gmail.com>
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

On Tue, Jun 13, 2023 at 8:37=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Tue, Jun 13, 2023 at 08:18:50AM +0300, Amir Goldstein wrote:
> > On Mon, Jun 12, 2023 at 7:32=E2=80=AFPM Eric Biggers <ebiggers@kernel.o=
rg> wrote:
> > >
> > > On Mon, Jun 12, 2023 at 12:27:17PM +0200, Alexander Larsson wrote:
> > > > +fs-verity support
> > > > +----------------------
> > > > +
> > > > +When metadata copy up is used for a file, then the xattr
> > > > +"trusted.overlay.verity" may be set on the metacopy file. This
> > > > +specifies the expected fs-verity digest of the lowerdata file. Thi=
s
> > > > +may then be used to verify the content of the source file at the t=
ime
> > > > +the file is opened. During metacopy copy up overlayfs can also set
> > > > +this xattr.
> > > > +
> > > > +This is controlled by the "verity" mount option, which supports
> > > > +these values:
> > > > +
> > > > +- "off":
> > > > +    The verity xattr is never used. This is the default if verity
> > > > +    option is not specified.
> > > > +- "on":
> > > > +    Whenever a metacopy files specifies an expected digest, the
> > > > +    corresponding data file must match the specified digest.
> > > > +    When generating a metacopy file the verity xattr will be set
> > > > +    from the source file fs-verity digest (if it has one).
> > > > +- "require":
> > > > +    Same as "on", but additionally all metacopy files must specify=
 a
> > > > +    verity xattr. This means metadata copy up will only be used if
> > > > +    the data file has fs-verity enabled, otherwise a full copy-up =
is
> > > > +    used.
> > >
> > > It looks like my request for improved documentation was not taken, wh=
ich is
> > > unfortunate and makes this patchset difficult to review.
> > >
> >
> > Which one?
> > IIRC, you had two requests.
> > One very broad to get the overlayfs.rst document up-to-date:
> > [1] https://lore.kernel.org/linux-unionfs/20230514190903.GC9528@sol.loc=
aldomain/
>
> That isn't an accurate summary of what I said.  I actually pointed out tw=
o
> specific things that are confusing specifically in the context of this fe=
ature.
>
> > But I assume you mean the specific request about this sentence:
> > [2] https://lore.kernel.org/linux-unionfs/20230514192227.GE9528@sol.loc=
aldomain/
>
> And that was a third specific thing.  I got a detailed response back
> (https://lore.kernel.org/linux-unionfs/CAL7ro1GGAfdZG9cHDWE2vnhY5tSE=3D9M=
xYi_n_gJHRfaw7zMSgg@mail.gmail.com),
> which was helpful.  Unfortunately, the information in that response hasn'=
t yet
> found its way into the documentation that is being proposed.
>
> In general the proposed documentation reads like the audience is overlayf=
s
> developers.  It doesn't describe the motivation for the feature or how to=
 use it
> in each of the two use cases.  Maybe that is intended, but it's not what =
I had
> expected to see.

I think your complaint is mostly related to the scope/goal of the
overlayfs.rst file. The way it is currently written, and how the patch
adds to it, it describes purely how overlayfs works "natively".

For example, when you change just the permissions of a file from the
lower layer, then overlayfs generates a metacopy file with some
special xattrs in the upper dir (rather than a full copy). It can also
do things like set a redirect xattr on the metacopy file if the file
changes name in the upper (due to a rename for example).

With the patch it may (depending on options) also set a verity xattr
on the metacopy file so that later uses of the upper layer can ensure
that the lower layer content file hasn't changed. This allows you to
improve the robustness of overlayfs layers, such that if at a later
time the lower directories accidentally change we will detect this
when using the metacopy file rather than delivering the wrong data.

These kinds of uses are completely standalone, you just mount overlay
with the right options and the kernel will do the right thing. There
is no need to know the internal details of the xattrs.

The problem is that I also have a different usecase with composefs.
This involves a completely different way of using overlayfs where you
construct manually a filesystem with the xattrs that overlayfs reads,
and then you mount this in a very special way (using a read-only
filesystem on loopback). A combination of overlayfs features will give
certain properties that are useful.

I feel like you expect that the overlayfs.rst document should describe
the details of the composefs setup, but instead it (both the patch and
the existing document) mainly describes the other kind of use.

In other words, if you are interested in using overlayfs with verity
to increase the robustness against layer changes, then the document is
probably enough. However, If you're interested in using overlayfs to
implement more complex features like composefs, then the document is
very weak in all sorts of details, not limited to the fs-verity part.

So, I don't think the current document is bad for what it does. But it
should perhaps be amended with a more detailed description of the
internals of the xattrs and their behaviour so that advanced users
(i.e. developers) don't have to read the source code for such details.
That seems like a general critique though, and not necessarily related
to this particular patchset.

> Side note: the use of the passive voice, e.g. "the xattr may be set" and =
"the
xattr may then be used to verify", should be avoided since it makes it uncl=
ear
who/what is doing these actions.

I'm not a native english speaker so I'm sure this can be written in a
better way, but when it says:

  When metadata copy up is used for a file, then the xattr
"trusted.overlay.verity" may be set on the metacopy file.

It really means:

  In certain circumstances, depending on mount options and other
details, it may be the case that when a metacopy file is being created
by overlayfs (as a side effect of a filesystem operation) the xattr
"trusted.overlay.verity" will be set on the new metacopy file.

So, this is not really using "may" in the passive voice, but I see
that it can be read that way.  I'll try to reword this in a way that
is more precise.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

