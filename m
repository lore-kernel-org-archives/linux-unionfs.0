Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B47EBCDB474
	for <linux-unionfs@archiver.kernel.org>; Sat, 14 Oct 2023 08:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbjJNIYX (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 14 Oct 2023 04:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjJNIYW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 14 Oct 2023 04:24:22 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFBC5BF
        for <linux-unionfs@vger.kernel.org>; Sat, 14 Oct 2023 01:24:18 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id d75a77b69052e-419b232fc99so15127231cf.1
        for <linux-unionfs@vger.kernel.org>; Sat, 14 Oct 2023 01:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697271858; x=1697876658; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Ij27msjAljY/oNLXmKwzfnxumPTPhqBMG6YypB8KKc=;
        b=VKf7URXu8TNK5KLWbRg8182BpXf+CE5VKjsP4hqKyiK9vietYT+h3d+Vp1BCiFCnJw
         RiMrw6GhXY3YFAm5o3LXnaP+bQAHPH/i2CdBmZDI+lsPVZgKCxlGIISkwFm+rUVGlXeN
         S+6K2YsrzQkIe9B3AuK1fLJ48B/+kjGLBdNUa+TlEaSC5mIwH+ltk9jBc3RO9ArwXX8M
         HEVM/bktkAPaQamDwyVXCXtkoO2gWDEkzueV++RPXNrLFe5DQZY61jprlQBtCObsG/f4
         TKlP43+ZSEL0Lwammn0x1LM6sLjymXLz3suKijn4wEjODSbDvg5ZoaTBIQi4HPczQeu/
         J71A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697271858; x=1697876658;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Ij27msjAljY/oNLXmKwzfnxumPTPhqBMG6YypB8KKc=;
        b=GyqR668eXmVuaaDkXxSp9onoBlfIIA3Kqq4wQSUE7KUXzekdIkCq/bPxYsYPwSB8yb
         vt/oMd2XwFO9X7z1AVR6RCw1aNFZQrxJCFRM3Omkw8uRjHa0Hu7M9KRlsvDmvbxtJCVI
         6EybqTRFFaqLjF5t35d7I7E4qq2gkHeq5t6Ah0/gt+DOKaHyICtxkK5dev9tDPl43kBq
         WDTn9K2y5pxnDFA93cz5UerGSYhrcdAccZ8AAg1e0RkcqhzK+OBzUPzLQ8VPQBZwNJoq
         0mH0VR34A0me95gnTEGhHxdoO5vMe3QO+snl+Zx8IwfxgKNT6KaePmynqJvEeBWbi3ON
         37Ew==
X-Gm-Message-State: AOJu0YxXQAvtiw+1h4I7pwHpplvT2FSUyPCbdufNXZgy2u2xPX0UR3y0
        ZkXdqDxgQMKDAHTCe8wMtbCExPJD9cOsFB/yeoURium0438=
X-Google-Smtp-Source: AGHT+IFhSwwGAW9TkUH6icvG5LLTi0kHLPlsWErkZWKYYuu281R0mWLsitmB+N+bDU0xBmEdyAwMVcGoCEQOKl+nq78=
X-Received: by 2002:a05:622a:4406:b0:419:c8fd:3bb with SMTP id
 ka6-20020a05622a440600b00419c8fd03bbmr18856839qtb.31.1697271857794; Sat, 14
 Oct 2023 01:24:17 -0700 (PDT)
MIME-Version: 1.0
References: <20231011164613.1766616-1-amir73il@gmail.com> <CAJfpegvgePB-==T=yTU1R+JVxKYsU_Bm18vWdW5hXWLGw=47PQ@mail.gmail.com>
 <CAOQ4uxiE89q62JHnxwm14FBShPORmX_h0EyDCBN-VKv6aTf5BQ@mail.gmail.com> <CAJfpegsexQsNVMOZw+0byzj2wTbU_Tg6p0ATgwBAwmTaDmNbLA@mail.gmail.com>
In-Reply-To: <CAJfpegsexQsNVMOZw+0byzj2wTbU_Tg6p0ATgwBAwmTaDmNbLA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 14 Oct 2023 11:24:06 +0300
Message-ID: <CAOQ4uxjYGckJA=raAW8wyVmDaK-FXfFDRS0RCpZYcLucPqMi3w@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix regression in showing lowerdir mount option
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Oct 14, 2023 at 10:10=E2=80=AFAM Miklos Szeredi <miklos@szeredi.hu>=
 wrote:
>
> On Sat, 14 Oct 2023 at 08:24, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Fri, Oct 13, 2023 at 6:36=E2=80=AFPM Miklos Szeredi <miklos@szeredi.=
hu> wrote:
>
> > > This is too eager.   Just need to escape what seq_show_option() would
> > > escape, which is comma and whitespace.   The '=3D' is  not need escap=
ed
> > > in values only in keys (and that likely never triggers).
> >
> > Right. I will remove =3D.
> >
> > > Colons should have stayed escaped as "\:", so no point in adding anot=
her
> > > level of escape.
> >
> > Yeh, unless the colon are not escaped because they were set via new api=
.
> > In this case, I would like to escape them in mountinfo (e.g. "a:b" =3D>=
 "a\072b").
> > This way, libmount would be able to parse mountinfo correctly in the fu=
ture
> > and learn how to iterate lowerdirs, even before fsinfo().
>
> I'm not sure that will work.  libmount will just remove the \072
> escaping from the whole lowerdir=3D option and we'll be left with the
> the unescaped sequence.   I think it's better to add the old "\:"
> escaping in case it was not added originally.
>

It is better to add "\:" if we want to be super nice and abide by the unspo=
ken
rule that the mount options parsed by libmount can be fed into mount(2) sys=
call
or back into libmount to get the same overlayfs config.

But I don't think it is a must because this rule is for overlayfs created w=
ith
mount(2) syscall or libmount, which knows how to split commas and use new
mount api, but it doesn't know how to split lowerdir colons.

If in the future, libmount will learn how to split lowerdir colons and use =
new
mount api to configure them one by one, then in the same future, libmount
will be able to distinguish between single escaped colons (\072) and
unescaped colons, and we do not need to add "\:" for making this possible.

> > I am not even sure if fsinfo() is going to be able to iterate lowerdirs=
, so
> > escaping colons may be needed there as well.
>
> Right.
>
> > > Yes, this two level escape is pretty confusing, considering that
> > > commas are escaped on both levels if using the old API.  When using
> > > the new API commas need not be escaped, but can be, since the same
> > > unescaping is done.   Not a serious issue as backslash in filenames i=
s
> > > basically nonexistent, but an inconsistency nonetheless.
> >
> > In general, I think we should be conservative and if escaping in mounti=
nfo
> > doesn't hurt we should not change it.
> > Applications should consume mountinfo via libmount and libmount already
> > unescapes the seq_show_option() format.
>
> Yes, it's like a network stack with various levels of encoding and
> decoding.  The escaping on the mountinfo level is there so that fields
> and options can properly be separated.   The escaping on the old mount
> API had a similar purpose but using a different encoding.   Shouldn't
> we make this consistent, so that only one level of escaping is done
> and at the right level?
>
> > > Following choices exist:
> > >
> > > 1) should the redundant escaping be left in mountinfo?
> >
> > Absolutely yes. I don't think it is redundant at all.
> > It may be redundant in fsinfo(), when lowerdirs can be iterated?
> > but mountinfo output is a single monolothic string
> > even if lowerdirs were set individually by new mount api.
>
> No.  What I mean by redundant is that a layer named "x,y" is encoded
> as e.g. upperdir=3Dx\,y when mounting on the old API.   Mountinfo it
> will look like "upperdir=3Dx\134\054y".  The \134 is totally redundant
> and not needed to separate the options, just remains there
> historically from the input encoding.
>

It is not only historical.
In the present, even with most recent libmount, the mount(8) tool
e.g. mount -t overlay, displays the options (... upperdir=3Dx\,y) and
then the user can replay those options.

It is true that libmount could have displayed "upperdir=3Dx\054y" as
(... upperdir=3D"x,y"), which is the escaping for commas that libmount
supports, but:
1. libmount does not do that
2. those options could be fed back into libmount but not directly to
    mount(2)

> > > 2) should FSCONFIG_SET_STRING accept escaped commas?
> > >
> >
> > Well, it already does.
> > If you are considering to change that retroactively then my argument
> > is that IMO userspace needs to be able to pass in \: in lowerdirs
> > and see it in mountinto (and mount command output) as long as
> > libmount does not know how to split lowerdirs by itself.
> > Otherwise, replaying the options from mountinfo into libmount will not
> > work correctly.
>
> If we are not strict about the encoding/decoding rules then something
> can break anyway.
> >
> > > 3) should unescaped commas on FSCONFIG_SET_STRING (and
> > > FSCONFIG_SET_PATH) be double escaped in mountinfo?
> > >
> >
> > Too much escaping in the sentence. I could not parse it ;)
> > For example, if "a:b" is set via FSCONFIG_SET_{STRING,PATH}
> > IMO mount info should output "a\072b", for the aforementioned reasons.
> > If by "double escaped" you meant "a\:b" or "a\134\072b", then I don't t=
hink
> > this is necessary.
>
> Agree double escaping being unncessary, not sure I agree about needing
> to escape ':' on the mountinfo level.
>
> >
> > > Currently it's yes, yes, no.  I'm fine with leaving things as they
> > > are, but at least the documentation should be clear on what should
> > > happen.
> >
> > OK.
> > How is that:
> >
> > --- a/Documentation/filesystems/overlayfs.rst
> > +++ b/Documentation/filesystems/overlayfs.rst
> > @@ -339,6 +339,18 @@ The specified lower directories will be stacked
> > beginning from the
> >  rightmost one and going left.  In the above example lower1 will be the
> >  top, lower2 the middle and lower3 the bottom layer.
> >
> > +Note: directory names containing colons can be provided as lower layer=
 by
> > +escaping the colons with a single backslash.  For example:
> > +
> > +  mount -t overlay overlay -olowerdir=3D/a\:lower\:\:dir /merged
> > +
> > +Since kernel version v6.5, directory names containing colons can also
> > +be provided as lower layer using the fsconfig syscall from new mount a=
pi:
> > +
> > +  fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "/a:lower::dir", 0)=
;
> > +
> > +In the latter case, colons in lower layer directory names will be esca=
ped
> > +as an octal characters (\072) when displayed in /proc/self/mountinfo.
> >
> > The wording of the last sentence above is somewhat legalish -
> > De facto, since v6.5,y, we will escape ":" to "\072" no matter via whic=
h api
> > we got it and regardless of whether it is also escaped with "\:" or not=
. but
> > we only need to commit to this rule for unescaped colons via new mount =
api.
>
> See my above argument against escaping colons on the mountinfo level.
>

See counter arguments.
My goal is to get as much of the parsing/escaping logic done by libmount
going forward, so I'd rather not add new escaping logic to new use cases
if we can avoid it.

At the moment, I would like to get some minimal fix to the 6.5 regression
merged while 6.5.y is still getting fixes.

If we cannot reach consensus within this short timeframe, then I think
that the smallest and least controversial fix is to escape colons once
as \072 as the current patch does.

We can always remove this escaping later if we find that it is not needed
no harm done. If you like, I can remove the commitment to mountinfo
format from documentation for the fix patch?

Being extra nice and displaying "a\,b" and "a\:b" for new users that
used new mount api explicitly to pass "a,b" and "a:b" is possible, but
it is not a 6.5 regression fix, so we can take the time to decide if we
want to do that or not.

OK?

Thanks,
Amir.
