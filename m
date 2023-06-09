Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67637C7EE2E
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Jun 2023 10:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238861AbjFIKyd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 9 Jun 2023 06:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbjFIKyd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Jun 2023 06:54:33 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB233EB
        for <linux-unionfs@vger.kernel.org>; Fri,  9 Jun 2023 03:54:29 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id ada2fe7eead31-43dda815756so455613137.1
        for <linux-unionfs@vger.kernel.org>; Fri, 09 Jun 2023 03:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686308069; x=1688900069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S10cZYn6jMTIFufDBCPJskbbnd8PV/ltIrhpBROzolQ=;
        b=I74Wq4AVQGEAKxM68lz2vV315ZKmLstfrnvNeCfK/+BFjAYJe9broKazmOyvC4e2Yc
         d0kzZXe/jruL/kNvr5TC8wz5aHOZKC+LvDydp23iq/V6lb2HES8CcI7g+N+BtnsmoLYO
         KW3ti80k9O6OdQH4kY7EY5w1zAna20Si9FZtMeNFMUz9O3oT0FZZkkY+c3Jd6zHheX4l
         Ns5cRDzCFlT9/EFxwx5MX8+PoOgOcuAX8J4GLnryJXPJnPgqQwUHOIHRpvPrsEMt8Ygh
         iWvGxIGQqAZNkZbh25VVNmrtQlgNX17m/BCcWlNgVtNlmPOHQk5ZT2BsWzcrSE7q+zTw
         Picw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686308069; x=1688900069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S10cZYn6jMTIFufDBCPJskbbnd8PV/ltIrhpBROzolQ=;
        b=SBLhjavAxW8cLrjktkD7usIU2bTx4EWqeT+qvP4VfCVcYU9lSj2OK2h+L6G2OZJUPY
         Sxy1XjZwex3sfkgizHQ8S2LPwGGAgkTY0vuidcgcZx/NZyyGp+ksepebdbMTDdCQCLXp
         fT6sN6eW/HS5zZEQhp3oIcrPUz+V/KFfSUJauuEZZOjMGzd4N38UyP0zlQQ2Vbrxr+Ha
         bpiwI7oRDlnfONnFQqo4s0lEs/XHTHyA3SJShij3AYBppfWnvwa8eeYCD/HqfoacHcIG
         FZ4VS3CDAf4iiSqLApl8+rUUXlCZKRd73INK3D5Hv8m9yq2tbfLpL+5xYwdA1v49XGDE
         WsUg==
X-Gm-Message-State: AC+VfDwpvQpvCPVCcrxiVXwGkBYradPXFd1pxSE7QvP9sFFqdggWwECe
        EC5mV1htTWNhpRSkTxLz0VwGuPWz9VcWj9f8dcYDdrkahOI=
X-Google-Smtp-Source: ACHHUZ6ziPnLDF9YTvlIkfPcX1g5UtKD2X2IMkZ82XCV4B4MysevAzfymUm7EgbfDDNbAMwayMpiDfEFtgaZzPJccEw=
X-Received: by 2002:a05:6102:a32:b0:43b:2fd0:e6 with SMTP id
 18-20020a0561020a3200b0043b2fd000e6mr560164vsb.33.1686308068856; Fri, 09 Jun
 2023 03:54:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230427130539.2798797-1-amir73il@gmail.com> <CAL7ro1G7DQS_aAC4+9-ppdQz_7vjoXdBLohZ6bKo6S75NQUDPA@mail.gmail.com>
 <CAOQ4uxhN1dPBkhAu3Zag8=RKCbzMQghuXnyp+uur83dRW8tz6Q@mail.gmail.com>
 <87h6s0z6rf.fsf@redhat.com> <CAOQ4uxhkCgU2=F2oAJn34Jor2_Hr56fLsa8cAAz936G05d-+ZQ@mail.gmail.com>
 <CAL7ro1EoNDMxU2d9WYrb772VFWWMDWV=KVvrZDnK=5byemmo8Q@mail.gmail.com>
 <fb711bb4-3f25-ccee-0d21-2cb6deea75ec@linux.alibaba.com> <CAOQ4uxiCzTbr4OXhxv=RbNbKn+kaBva-Wkz4AGW8OJUwL3GfLQ@mail.gmail.com>
 <CAJfpegvsEuSNepb_9MNEkEFsW7R60DDk57x3oivA6wx9y8StRA@mail.gmail.com>
 <CAOQ4uxh14O9aRiewc+nq+AL-029YGu4bb4AZpp854r78Jm=_dw@mail.gmail.com> <CAJfpegvnBrLtNcW0Oy8Y7seju96scQ0-FHoiXxx3+A3X4N_LMQ@mail.gmail.com>
In-Reply-To: <CAJfpegvnBrLtNcW0Oy8Y7seju96scQ0-FHoiXxx3+A3X4N_LMQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 9 Jun 2023 13:54:17 +0300
Message-ID: <CAOQ4uxgHiOTYAgxL4=g26XgPBwdRhZqKReR8mp21e43zC2b2KA@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Overlayfs lazy lookup of lowerdata
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Gao Xiang <hsiangkao@linux.alibaba.com>,
        Alexander Larsson <alexl@redhat.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        linux-unionfs@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jun 9, 2023 at 10:24=E2=80=AFAM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Tue, 30 May 2023 at 16:15, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Tue, May 30, 2023 at 5:08=E2=80=AFPM Miklos Szeredi <miklos@szeredi.=
hu> wrote:
> > >
> > > On Sat, 27 May 2023 at 16:04, Amir Goldstein <amir73il@gmail.com> wro=
te:
> > >
> > > > If we would want to support data-only layers in the middle on the
> > > > stack, which would this syntax make sense?
> > > > lowerdir=3Dlower1::data1:lower2::data2
> > > >
> > > > If this syntax makes sense to everyone, then we can change the synt=
ax
> > > > of data-only in the tail from lower1::data1:data2 to lower1::data1:=
:data2
> > > > and enforce that after the first ::, only :: are allowed.
> > > >
> > > > Miklos, any thoughts?
> > > > I have a feeling that this was your natural interpretation when you=
 first
> > > > saw the :: syntax.
> > >
> > > Yes, I think it's more natural to have a prefix for each data-only
> > > layer.  And this is also good for extensibility, as discussed.
> > >
> >
> > Good timing ;-)
> >
> > I was just about to say that I changed the syntax and pushed to:
> >
> > https://github.com/amir73il/linux/commits/ovl-lazy-lowerdata-v3
> > https://github.com/amir73il/xfstests/commits/ovl-lazy-lowerdata
> >
> > The gist of the documentation of v3 is:
> >
> > Below the top most lower layer, any number of lower most layers may be =
defined
> > as "data-only" lower layers, using double colon ("::") separators.
> > A normal lower layer is not allowed to be below a data-only layer, so s=
ingle
> > colon separators are not allowed to the right of double colon ("::") se=
parators.
> >
> > For example:
> >
> >   mount -t overlay overlay -olowerdir=3D/l1:/l2:/l3::/do1::/do2 /merged
> >
> >
> > Do you need me to post the v3 patches?
> >
> > The changes since ovl-lazy-lowerdata-v2 branch are:
> > - Reabse on 6.4-rc2 + NULL deref fixes
> > - Syntax change
>
> Patches look good to me.
>
> Pushed v3 to overlayfs-next.
>
> It'd be interesting to hear what obstacles you encountered when trying
> to implement generic lazy lookup.  I can put that into the pull
> request so the information is not lost.
>

Depends on what you mean by "generic lazy lookup".

Generic lazy lookup in the sense that it does lazy lookup to lower
(not to lowerdata) is challenging, because we use lower inode
number for many things including hashing the overlay inode,
which is done during lookup.

The challenges with generic lazy lowerdata lookup in layers
that are not data-only is that there is more state to store for
the lazy lookup:
- Which layer we stopped lookup
- The current path, if not an absolute redirect
- Maybe more?

And the lazy lookup will have to resume the ovl layers lookup
state machine on access including checking redirects,
metacopy, etc.

The current code only stores an optional absolute lowerdata_redirect
string on ovl_lookup() only for the case of lowerdata lookup in data-only
layers and lazy lookup calls a single vfs helper vfs_path_lookup() per
data-only layer - it is quite trivial.

No obstacles that I am aware of - only more work that
is not driven by request from users.

Thanks,
Amir.
