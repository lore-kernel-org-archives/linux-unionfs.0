Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A13EB64D8
	for <linux-unionfs@archiver.kernel.org>; Wed, 14 Jun 2023 05:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbjFNFYk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 14 Jun 2023 01:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbjFNFYj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Jun 2023 01:24:39 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BD5E3
        for <linux-unionfs@vger.kernel.org>; Tue, 13 Jun 2023 22:24:38 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id ada2fe7eead31-43b4b5378ecso762079137.1
        for <linux-unionfs@vger.kernel.org>; Tue, 13 Jun 2023 22:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686720277; x=1689312277;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uedl8aOmiD9AKNJjAanB/6NKPkD3ghHapo7xFGnVcI4=;
        b=GxQ6/f1I6tO+C7Ch3n+s1ebyI29IljGly8i/0kN0b42auuXxG+TAp/8tVSN9d7vV9P
         ftnITETth9re8KF0uIq3/dPf0xIGjTgRzHcT6+4qb6duXXYSkVGljmAv2KpJlrTZb661
         4wcSytUg0e6Se2YotMK0gTGRV5vHTSYio3Ny3R6FpIpRWDPW0GKESY0EVyR+hPidNH+Y
         ASgpwlSoPO+PBrBdMhtDsA3yOt8XguHcxF+/Dj+e3hPYUSJZHBORXJru5A2wzMKq0Wt/
         khOquhLQ8TSrptK9XnmVSgE/MAp3LacdH0yAOIXT43++xQeg69F/ZTckcXO+QoJaT8BT
         8rng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686720277; x=1689312277;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uedl8aOmiD9AKNJjAanB/6NKPkD3ghHapo7xFGnVcI4=;
        b=WT1K+qdXvQ4HQWr6Mo7bpqKjZ9HYA7FdV/QxkHspOUd8EIuFYEBpxnRklbMe6tR5b8
         4EN7g9IoIS4sT4SZVXgGZabSVJbsJ/yKlfMupYAMMEiN+gadV1OCgf6LGG6EZ6b5m4ws
         uWy2zAqNVFNn922f53yk5UjV0S0bK0tYdcgok5oDLGCPtkeZExs+ZUVJlc6Dky0iVdMH
         IOwmbmBepwfS29JdedDJ71jWxtQpORLo/Oxahq/gOv2GwyaNNU1/V7lR70zWRWBBbxMV
         zFcJ0aIvLAkZw+gSklBH2y7cmw/sCxjOSqvDQLBhTwUIHLGZMqIz76lMy2NHJUUOgVTc
         T2RQ==
X-Gm-Message-State: AC+VfDwkbe8b+w9E8hw4XoKFyPW0cvDDtxpiCcg4a0IzIuOfhbTIIYZT
        KmY8IivVAg5F+aRVimofCvCYrnlDJKs1ynB66H4=
X-Google-Smtp-Source: ACHHUZ6+2LyGJoGaXWvdQsThKMeLm5gzNhPgYGganjlJ60TM5GqBo1VW3u1Bk1cmN4NyEeFmE47T4PiIGAKjPZjn+WM=
X-Received: by 2002:a05:6102:141:b0:439:3c9f:d040 with SMTP id
 a1-20020a056102014100b004393c9fd040mr8085392vsr.34.1686720277396; Tue, 13 Jun
 2023 22:24:37 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1686565330.git.alexl@redhat.com> <03ac0ffd82bc1edc3a9baa68d1125f5e8cad93fd.1686565330.git.alexl@redhat.com>
 <20230612163216.GA847@sol.localdomain> <CAOQ4uxjS5-7_PaoxM41YaXW+KxwLK_K8AyJMaoi1m-3P-vZ9Kw@mail.gmail.com>
 <20230613063704.GA879@sol.localdomain> <CAOQ4uxg6BD_RDtWob5q2eX6uQ5hcWrK7wEDcBhFVrGM3vsn=NA@mail.gmail.com>
 <20230613182233.GC1139@sol.localdomain>
In-Reply-To: <20230613182233.GC1139@sol.localdomain>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 14 Jun 2023 08:24:25 +0300
Message-ID: <CAOQ4uxhzJFpfuFLxK2s0JqS5qGQDGfndFPY7n2NDmZso4cG4Rg@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] ovl: Add framework for verity support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Alexander Larsson <alexl@redhat.com>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 13, 2023 at 9:22=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Tue, Jun 13, 2023 at 12:34:10PM +0300, Amir Goldstein wrote:
> > >
> > > In general the proposed documentation reads like the audience is over=
layfs
> > > developers.
> >
> > I never considered that overlayfs.rst is for an audience other than
> > overlayfs developers or people that want to become overlayfs
> > developers. It is not a user guide. If it were, it would have been a
> > very bad one.
> >
> > > It doesn't describe the motivation for the feature or how to use it
> > > in each of the two use cases.  Maybe that is intended, but it's not w=
hat I had
> > > expected to see.
> > >
> >
> > Yeh, that's a valid point.
> > That is what I wanted to know - what exactly is missing.
> > I guess this is the documented motivation:
>
> Sure, but even if the document is just for kernel developers, it should s=
till
> describe motivation and use cases, as those are important for userstandin=
g.
>
> > "This may then be used to verify the content of the source file at the =
time
> > the file is opened"
> >
> > but it does not tell a complete chain of trust story.
> >
> > How about something along the lines of:
> >
> > "In the case that the upper layer can be trusted not to be tampered
> > with while overlayfs is offline
>
> So *online* tampering of the upper layer is fine?

No, for the sake of this section, it would be easier to say
that upper is completely trusted and completely under our
control and that the feature only hardens overlayfs when
lower is not under our full control.

In the case of composefs it's actually two lower layers, one trusted
and one not trusted (and an optional trusted upper), but it does not
matter IMO for the sake of explaining the basic feature.

>
> > and some of the lower layers cannot
> > be trusted not to be tampered with, the "verity" feature can protect
> > against offline modification to lower files
>
> Data of lower files, not simply "lower files", right?

Right.

>
> Are *online* modifications to lower files indeed not in scope?

They are. doc should not mention online.

>
> If the feature "can protect", then under what circumstances does it prote=
ct, and
> under what circumstances what does it not protect?
>
> It would also be helpful to explain what specifically is meant by "protec=
t".
> Does it mean that overlayfs prevents modifications to lower file data, or=
 does
> it mean that overlayfs detects modifications to lower file data after the=
y
> happen?  If the latter, what happens when overlayfs detects a modificatio=
n?
> What do userspace programs experience?
>
> > , whose metadata has been
> > copied up to the upper layer (a.k.a "metacopy" files) ...."
> >
> > It's generic language that what the patches do, regardless of the
> > trust model of composefs and how it composes an overlayfs layers.
>
> It's better, but it could use some more detail.  See my comments above.
>

Fair enough.

Alex,

Please incorporate Eric's feedback above to come up with a more
detailed description than:

+This can be useful as a way to validate that a lower directory matches
+the correct upper when it is re-mounted later. In case you can
+guarantee that a overlayfs directory with verity xattrs is not
+tampered with (for example using dm-verity or fs-verity) this can even
+be used to guarantee the validity of an untrusted lower directory.
+

On the specific points that Eric mentioned.

Thanks,
Amir.
