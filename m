Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49DB5EB64D9
	for <linux-unionfs@archiver.kernel.org>; Wed, 14 Jun 2023 07:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237922AbjFNH6s (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238380AbjFNH6r (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Jun 2023 03:58:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FBB19BC
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jun 2023 00:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686729475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UfwReRdUWGYn4SV5oyK98sYbhf53ic2tI0fPucAMzX0=;
        b=JV/YDPMD601QvaYorWAp9OE9x29NVZDNZt2dYgjQj34dfc17ZPCQQTBCD45CUP/9LBGGJ2
        mgML8FsFNtINWVmq3Ty8oFLAwDyiG0PIGJiy/+MxZFXbOoYPmE7VAsC5N+YcTpx4T179wx
        1WpxXLaK7v5Ho6yeHKzFC3ax5oB1xjM=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-gzGEqFxMPYq5hh7CWggCqg-1; Wed, 14 Jun 2023 03:57:53 -0400
X-MC-Unique: gzGEqFxMPYq5hh7CWggCqg-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-33b88241696so69070285ab.1
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jun 2023 00:57:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686729473; x=1689321473;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UfwReRdUWGYn4SV5oyK98sYbhf53ic2tI0fPucAMzX0=;
        b=Il9tbagxCjZUJXNfhcL0+ijqTcUVVNEIyDj+J1VZJP/tM8KyDUfNZs9uC/Dh97U8Bi
         qeH2jyl1Pf9BsCFVcDxjX2M1ULiJCpHfSRFN9uxi/ntvp6GulXw35DxkseN6NHfEPKkR
         dG500u7ziE/ZFQbN94I+2A7fqgK3GtKU+K+93sTJJA7eMQGTj+7o5MEZpwp4iByLbkj7
         8KScKbRYAAdPpfGxsJcSsXwpeti0L3OYEi3iwpKPLrNoJowixVWYRUh+Kiq1z86WDVzt
         wbKIeTvDO1sSfnxp4jkNpLOxSAh/ihQBsMcaS+dbW0SQhntsdnSFUW3MTzvJOFj0zi3v
         wk8w==
X-Gm-Message-State: AC+VfDw6njf0reuz7xNxCKNxZ3UmP9/bjksArZ4r2g67AkeEe3cD64Rc
        Qx8Nz47lFoXvPHqTfvVICdbY86fb1++5wsvnvas62In7doRuMou+NbnqHTwLibjWFd9OiWrmcu1
        RQhKjkCVr0j6HxCpB/kz33MFSvjTsakyceFrEiqxa0A==
X-Received: by 2002:a92:c851:0:b0:340:a4b0:1a35 with SMTP id b17-20020a92c851000000b00340a4b01a35mr730718ilq.8.1686729473015;
        Wed, 14 Jun 2023 00:57:53 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6lt8V2laDcByMSpb8s2uPfTZzeal2kF+czt4/mn2l6B4Bea7i1EXfJz1mlAln5a59LSZZ9xd+zs8EegqX217Y=
X-Received: by 2002:a92:c851:0:b0:340:a4b0:1a35 with SMTP id
 b17-20020a92c851000000b00340a4b01a35mr730712ilq.8.1686729472761; Wed, 14 Jun
 2023 00:57:52 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1686565330.git.alexl@redhat.com> <03ac0ffd82bc1edc3a9baa68d1125f5e8cad93fd.1686565330.git.alexl@redhat.com>
 <20230612163216.GA847@sol.localdomain> <CAOQ4uxjS5-7_PaoxM41YaXW+KxwLK_K8AyJMaoi1m-3P-vZ9Kw@mail.gmail.com>
 <20230613063704.GA879@sol.localdomain> <CAOQ4uxg6BD_RDtWob5q2eX6uQ5hcWrK7wEDcBhFVrGM3vsn=NA@mail.gmail.com>
 <20230613182233.GC1139@sol.localdomain> <CAOQ4uxhzJFpfuFLxK2s0JqS5qGQDGfndFPY7n2NDmZso4cG4Rg@mail.gmail.com>
In-Reply-To: <CAOQ4uxhzJFpfuFLxK2s0JqS5qGQDGfndFPY7n2NDmZso4cG4Rg@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Wed, 14 Jun 2023 09:57:41 +0200
Message-ID: <CAL7ro1FF2iUjPsXrha8tELYvi9MwW7WRhksqX7ahSXc4gPHraw@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] ovl: Add framework for verity support
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 14, 2023 at 7:24=E2=80=AFAM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Tue, Jun 13, 2023 at 9:22=E2=80=AFPM Eric Biggers <ebiggers@kernel.org=
> wrote:
> >
> > On Tue, Jun 13, 2023 at 12:34:10PM +0300, Amir Goldstein wrote:
> > > >
> > > > In general the proposed documentation reads like the audience is ov=
erlayfs
> > > > developers.
> > >
> > > I never considered that overlayfs.rst is for an audience other than
> > > overlayfs developers or people that want to become overlayfs
> > > developers. It is not a user guide. If it were, it would have been a
> > > very bad one.
> > >
> > > > It doesn't describe the motivation for the feature or how to use it
> > > > in each of the two use cases.  Maybe that is intended, but it's not=
 what I had
> > > > expected to see.
> > > >
> > >
> > > Yeh, that's a valid point.
> > > That is what I wanted to know - what exactly is missing.
> > > I guess this is the documented motivation:
> >
> > Sure, but even if the document is just for kernel developers, it should=
 still
> > describe motivation and use cases, as those are important for userstand=
ing.
> >
> > > "This may then be used to verify the content of the source file at th=
e time
> > > the file is opened"
> > >
> > > but it does not tell a complete chain of trust story.
> > >
> > > How about something along the lines of:
> > >
> > > "In the case that the upper layer can be trusted not to be tampered
> > > with while overlayfs is offline
> >
> > So *online* tampering of the upper layer is fine?
>
> No, for the sake of this section, it would be easier to say
> that upper is completely trusted and completely under our
> control and that the feature only hardens overlayfs when
> lower is not under our full control.
>
> In the case of composefs it's actually two lower layers, one trusted
> and one not trusted (and an optional trusted upper), but it does not
> matter IMO for the sake of explaining the basic feature.
>
> >
> > > and some of the lower layers cannot
> > > be trusted not to be tampered with, the "verity" feature can protect
> > > against offline modification to lower files
> >
> > Data of lower files, not simply "lower files", right?
>
> Right.
>
> >
> > Are *online* modifications to lower files indeed not in scope?
>
> They are. doc should not mention online.
>
> >
> > If the feature "can protect", then under what circumstances does it pro=
tect, and
> > under what circumstances what does it not protect?
> >
> > It would also be helpful to explain what specifically is meant by "prot=
ect".
> > Does it mean that overlayfs prevents modifications to lower file data, =
or does
> > it mean that overlayfs detects modifications to lower file data after t=
hey
> > happen?  If the latter, what happens when overlayfs detects a modificat=
ion?
> > What do userspace programs experience?
> >
> > > , whose metadata has been
> > > copied up to the upper layer (a.k.a "metacopy" files) ...."
> > >
> > > It's generic language that what the patches do, regardless of the
> > > trust model of composefs and how it composes an overlayfs layers.
> >
> > It's better, but it could use some more detail.  See my comments above.
> >
>
> Fair enough.
>
> Alex,
>
> Please incorporate Eric's feedback above to come up with a more
> detailed description than:
>
> +This can be useful as a way to validate that a lower directory matches
> +the correct upper when it is re-mounted later. In case you can
> +guarantee that a overlayfs directory with verity xattrs is not
> +tampered with (for example using dm-verity or fs-verity) this can even
> +be used to guarantee the validity of an untrusted lower directory.
> +
>
> On the specific points that Eric mentioned.

I think maybe it's best we hash this out here first.
What do you think about this version:

fs-verity support
----------------------

During metadata copy up of a lower file, if the source file has
fs-verity enabled and overlay verity support is enabled, then the
"trusted.overlay.verity" xattr is set on the new metacopy file. This
specifies the expected fs-verity digest of the lowerdata file, which is
used to verify the content of the lower file at the time the metacopy
file is opened.

When a layer containing verity xattrs is used, it means that any
such metacopy file in the upper layer is guaranteed to match the
content that was in the lower at the time of the copy-up. If at any time
(during a mount, after a remount, etc) such a file in the lower is
replaced or modified in any way, then opening the corresponding file on
overlayfs will result in EIO and a detailed error printed to the kernel log=
s.
(Actually, due to caching the overlayfs mount might still see the previous
file contents after a lower file is replaced under an active mount, but
it will never see the wrong data.)

Verity can be used as a general robustness check to detect accidental
changes in the overlayfs directories in use. But, with additional care
it can also give more powerful guarantees. For example, if the upper layer
is fully trusted (by using dm-verity or something similar), then an untrust=
ed
lower layer can be used to supply validated file content for all metacopy f=
iles.
If additionally the untrusted lower directories are specified as "Data-only=
",
then they can only supply such file content, and the entire mount can be
trusted to match the upper layer.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

