Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBCF9C0015E
	for <linux-unionfs@archiver.kernel.org>; Tue, 15 Aug 2023 14:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236409AbjHOOVI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 15 Aug 2023 10:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237629AbjHOOVG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 15 Aug 2023 10:21:06 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD10173F
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Aug 2023 07:21:05 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id a1e0cc1a2514c-79dbd1fb749so1886708241.0
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Aug 2023 07:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692109264; x=1692714064;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wdRH9MMRroCmlJ98oEcuYXSBq2cIO7ao6jbWXf5/sxc=;
        b=hR68wlhMj6ODL9eSdvStsgzsFpkjU4S7JyffY4mjsEEJOD0RO88ROVtUmset3R5Xok
         4xy6h7YRrKAcUBUfQY4mskbK+IxXijMuN62vZRniUyVg2chImjeaPC8vtfKxKL2ZF4Fb
         mzulyq7TscXmPDQAz522d8TIYNF5QZ0a/ihAMabXdBjSXVGMxz+vlRBY1jg5luN4cVIP
         5DfKVfNiHSsKgcTtAIKouX9cCcnuUa1JRY5HeGGoFjz9rM1hpcppjLlBxX78drC+meyM
         gm+ya5568ZaYTkfK/Q1UdkMctb82NmN1W0kl1W5uxbd0KO1+tVSFwVG+dmp5pT4q8YGl
         N74Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692109264; x=1692714064;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wdRH9MMRroCmlJ98oEcuYXSBq2cIO7ao6jbWXf5/sxc=;
        b=a8/4ZvsZPEZ9o6hFV7prdGlu+XSxmOqPyuGydcsMCxNB5gKrkWDuGHw1Vs7HQjzmhY
         g2T8/etXVyhhOyx+JOAO3frd5ivcwXy9+aMR7SGNqoKs7zp5VGCz6AhCyxKScnHkHuqH
         +ebi6WTuXHMvYdIIyI7C+7vOWATNPqV5X4v/8IelB/QxBUVvX7cXMSJKwDUC4TPZTv4f
         unupK0hjGJArubyVzxfbBvOr7LBFxnAiXa8hsvsQn2Lz0hVLBZ1Ud9itT1y/jemFpLyd
         QjXnEXFyqUz0/Y/h7uUU73Or4Af/Haq3bUid2Ys5ieu2MIta0LhUiE7+takxu7rr3EEe
         wL2Q==
X-Gm-Message-State: AOJu0YzYPsYww9t9o3DkJfyY66tUKUZnhxXYCt1ZNtT2lGKE/WWrtnR0
        QyFvjV88fMYAfdqsSMCGFsSahx2ksYsFAr/XP/0=
X-Google-Smtp-Source: AGHT+IEf0Rx+o26Uqqv7nMQ7Ww6Ptb6yk6AeVFKfV9MjrfDKPb/MFrwQTp8fIOm8bbJ1ns5Yc7qarSyo7Im7v23F+v8=
X-Received: by 2002:a05:6102:571a:b0:44a:bbae:f994 with SMTP id
 dg26-20020a056102571a00b0044abbaef994mr1297859vsb.12.1692109264384; Tue, 15
 Aug 2023 07:21:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAL7ro1EArefty01rFo4-D98YcSZ3F6qCRboM=qwU84jWjrJJ4w@mail.gmail.com>
 <CAOQ4uxg6V7J=ZZxQjPPivLtRNVqnNiJ=PAPfYtsS=zN5C29oRA@mail.gmail.com> <CAL7ro1HDZz0vyQV4nn7Jvf5FteEMnaWvMYeGXbF-gZSS6BG9RQ@mail.gmail.com>
In-Reply-To: <CAL7ro1HDZz0vyQV4nn7Jvf5FteEMnaWvMYeGXbF-gZSS6BG9RQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 15 Aug 2023 17:20:53 +0300
Message-ID: <CAOQ4uxhJc2WTBaUEdZnpesvGSDc4YaVsmYzpL4hfqcuPz9_vsw@mail.gmail.com>
Subject: Re: Nesting overlay instances (whiteouts/xattrs)
To:     Alexander Larsson <alexl@redhat.com>
Cc:     linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Aug 15, 2023 at 5:09=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> Bringing this design discussion to the list.
>
> On Tue, Aug 15, 2023 at 3:53=E2=80=AFPM Amir Goldstein <amir73il@gmail.co=
m> wrote:
> >
> > On Tue, Aug 15, 2023 at 3:33=E2=80=AFPM Alexander Larsson <alexl@redhat=
.com> wrote:
> > >
> > > Hi, as discussed in https://github.com/containers/composefs/issues/17=
2
> > > we have some issues with a composefs rootfs that contains lower dirs.
> > > The "inner" overlayfs will consume the overlay xattrs and the
> > > whiteouts that were targeting the outer instance.
> > >
> > > I came up with this patchset to fix this:
> > > https://github.com/alexlarsson/linux/tree/ovl-nesting
> > >
> > > There are two parts, first of all, any xattrs called
> > > overlay.escape.XYZ in the lower/upper will be not be treated speciall=
y
> > > by overlayfs itself, but exposed as overlay.XYZ in the overlayfs
> > > mount. This can be nested by using overlay.escape.escape.XYZ, althoug=
h
> > > the stacking limit makes this stop at two levels.
> >
> > This part looks fine to me.
> > I'd consider overlay.overlay.XYZ for the nested overlay xattr prefix,
> > but that is just my own taste of playful aesthetics ;-)
>
> Heh.
>
> > > Secondly, and whiteouts in lower/upper that have a overlay.nowhiteout
> > > xattrs will not be treated as a whiteout by the overlayfs mount.
> > > However, since this xattr is stripped as part of the overlayfs mount,
> > > the outer instance will apply it. This can be combined with escaping
> > > to create a whiteout in a stacked overlayfs instance.
> > >
> >
> > It looks sane.
> >
> > I am a bit concerned about introducing extra overhead for the
> > common case, but maybe whiteouts are rare enough or the overhead
> > low enough that it shouldn't matter?
>
> Yeah, I was somewhat worried about this too, and this is the reason
> the code is structured so that it only ever reads this new xattr for
> whiteout files. The hope is indeed that they are uncommon enough in
> practice to not make this a large issue.
>
> One thing I noticed is that whiteouts are used in a bunch of places
> for the handling of index files. I'm not completely up to speed on
> these, but it looks like they are always in the work dir, am I right?

Technically, they are in the "indexdir" (i.e. work/index not work/work),
but when ofs->indexdir exists ofs->workdir =3D=3D ofs->indexdir.
The whiteouts in indexdir indicates that open_by_handle_at()
should return ESTALE if a whiteout index is found (by handle).

> So, we could potentially avoid the check for a nowhiteout xattr for
> these for a slight performance improvement. Correct?

Correct.

>
> > > Does this make sense to you?
> >
> > Yes, but it needs documentation.
>
> I'll add some.
>
> > > Do we need options for enabling these features?
> >
> > Don't think so.
> > I see no risk of regressions (i.e. that the escaped xattrs currently
> > exist in the wild).
> >
> > It is easy for userspace to test if kernel supports xattr escaping
> > even if there are no escaped xattrs, getxattr(trusted.overlay.escaped.b=
lah)
> > would return either ENOTSUPP or ENODATA (if escaping is supported).
>
> Yeah, that makes sense.
>

Thanks,
Amir.
