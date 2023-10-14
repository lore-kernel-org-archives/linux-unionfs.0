Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20DB5CDB465
	for <linux-unionfs@archiver.kernel.org>; Sat, 14 Oct 2023 07:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbjJNHKY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 14 Oct 2023 03:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjJNHKY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 14 Oct 2023 03:10:24 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B378C2
        for <linux-unionfs@vger.kernel.org>; Sat, 14 Oct 2023 00:10:20 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-9b2cee55056so484298966b.3
        for <linux-unionfs@vger.kernel.org>; Sat, 14 Oct 2023 00:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1697267418; x=1697872218; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fOu5LepAoGn474sdWQWNWqrkUW9tf1r7ihd93f/c1E8=;
        b=DMYp5MyceRc3VPaSzmuJr+vGp47+crZ36K3Lel2a5Pv/mESwZyTDlynSbXfg0Nvdxm
         Ipm/U52oWIg7NINHGpR3ONfskpjZzW3+AMP9f3nu4vE+ujYvTtUoXz+18fPxKAzdxhTH
         67fnNMtXn9pZsfaWD4vlq9JgZ9xjkdAkLCPeA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697267418; x=1697872218;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fOu5LepAoGn474sdWQWNWqrkUW9tf1r7ihd93f/c1E8=;
        b=sglUZdVcB+MR08M7BUT6XoNJFgxu+7BZckUEJbebF1LTillIS5ae3AYlLMau28LfnD
         up0gnLBPMK2db9mra49mupq0qrfaZINsINvSbIFmi3MQtFJiniJz0n42N4UtaKAZlwxO
         5dGjxjsVB0B89W0wPe+fNQh3wcmmYs72lOVvYV1ttV0WXvHUk/iqQ779kyR+Kr+7h5sp
         AHEu5gEkpQhBdm79QI4JHh5YR5A/twPEoSQSNCEc8C51pMq3PO3fVaqXPTznmhZhXZ6L
         14FfsYcRlQ2OpTAU79q/KcdtmI4csv9d75HdUxaMDP5dm6vDiq5n/oX79ZvI8tliMSC0
         v3VA==
X-Gm-Message-State: AOJu0Yz+dScwtoSaYiLLTuM3ZBvs640CR8HMo8SmM7axL2gItecuccPu
        sbg+fpcGunewW0BZ3shTsG9Ivg/gRBB78o5AuqKEkQ==
X-Google-Smtp-Source: AGHT+IFKpVK7tdRzI4TwKVMMyJLw841lMQib8VQk4RYhVENAxEyQHks9HrP7HTwlqetotN2uoHatzb7AoHg9hzFBFis=
X-Received: by 2002:a17:906:7949:b0:9bd:ff07:a58a with SMTP id
 l9-20020a170906794900b009bdff07a58amr2578087ejo.53.1697267418479; Sat, 14 Oct
 2023 00:10:18 -0700 (PDT)
MIME-Version: 1.0
References: <20231011164613.1766616-1-amir73il@gmail.com> <CAJfpegvgePB-==T=yTU1R+JVxKYsU_Bm18vWdW5hXWLGw=47PQ@mail.gmail.com>
 <CAOQ4uxiE89q62JHnxwm14FBShPORmX_h0EyDCBN-VKv6aTf5BQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxiE89q62JHnxwm14FBShPORmX_h0EyDCBN-VKv6aTf5BQ@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Sat, 14 Oct 2023 09:10:07 +0200
Message-ID: <CAJfpegsexQsNVMOZw+0byzj2wTbU_Tg6p0ATgwBAwmTaDmNbLA@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix regression in showing lowerdir mount option
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, 14 Oct 2023 at 08:24, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Fri, Oct 13, 2023 at 6:36=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu=
> wrote:

> > This is too eager.   Just need to escape what seq_show_option() would
> > escape, which is comma and whitespace.   The '=3D' is  not need escaped
> > in values only in keys (and that likely never triggers).
>
> Right. I will remove =3D.
>
> > Colons should have stayed escaped as "\:", so no point in adding anothe=
r
> > level of escape.
>
> Yeh, unless the colon are not escaped because they were set via new api.
> In this case, I would like to escape them in mountinfo (e.g. "a:b" =3D> "=
a\072b").
> This way, libmount would be able to parse mountinfo correctly in the futu=
re
> and learn how to iterate lowerdirs, even before fsinfo().

I'm not sure that will work.  libmount will just remove the \072
escaping from the whole lowerdir=3D option and we'll be left with the
the unescaped sequence.   I think it's better to add the old "\:"
escaping in case it was not added originally.

> I am not even sure if fsinfo() is going to be able to iterate lowerdirs, =
so
> escaping colons may be needed there as well.

Right.

> > Yes, this two level escape is pretty confusing, considering that
> > commas are escaped on both levels if using the old API.  When using
> > the new API commas need not be escaped, but can be, since the same
> > unescaping is done.   Not a serious issue as backslash in filenames is
> > basically nonexistent, but an inconsistency nonetheless.
>
> In general, I think we should be conservative and if escaping in mountinf=
o
> doesn't hurt we should not change it.
> Applications should consume mountinfo via libmount and libmount already
> unescapes the seq_show_option() format.

Yes, it's like a network stack with various levels of encoding and
decoding.  The escaping on the mountinfo level is there so that fields
and options can properly be separated.   The escaping on the old mount
API had a similar purpose but using a different encoding.   Shouldn't
we make this consistent, so that only one level of escaping is done
and at the right level?

> > Following choices exist:
> >
> > 1) should the redundant escaping be left in mountinfo?
>
> Absolutely yes. I don't think it is redundant at all.
> It may be redundant in fsinfo(), when lowerdirs can be iterated?
> but mountinfo output is a single monolothic string
> even if lowerdirs were set individually by new mount api.

No.  What I mean by redundant is that a layer named "x,y" is encoded
as e.g. upperdir=3Dx\,y when mounting on the old API.   Mountinfo it
will look like "upperdir=3Dx\134\054y".  The \134 is totally redundant
and not needed to separate the options, just remains there
historically from the input encoding.

> > 2) should FSCONFIG_SET_STRING accept escaped commas?
> >
>
> Well, it already does.
> If you are considering to change that retroactively then my argument
> is that IMO userspace needs to be able to pass in \: in lowerdirs
> and see it in mountinto (and mount command output) as long as
> libmount does not know how to split lowerdirs by itself.
> Otherwise, replaying the options from mountinfo into libmount will not
> work correctly.

If we are not strict about the encoding/decoding rules then something
can break anyway.
>
> > 3) should unescaped commas on FSCONFIG_SET_STRING (and
> > FSCONFIG_SET_PATH) be double escaped in mountinfo?
> >
>
> Too much escaping in the sentence. I could not parse it ;)
> For example, if "a:b" is set via FSCONFIG_SET_{STRING,PATH}
> IMO mount info should output "a\072b", for the aforementioned reasons.
> If by "double escaped" you meant "a\:b" or "a\134\072b", then I don't thi=
nk
> this is necessary.

Agree double escaping being unncessary, not sure I agree about needing
to escape ':' on the mountinfo level.

>
> > Currently it's yes, yes, no.  I'm fine with leaving things as they
> > are, but at least the documentation should be clear on what should
> > happen.
>
> OK.
> How is that:
>
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -339,6 +339,18 @@ The specified lower directories will be stacked
> beginning from the
>  rightmost one and going left.  In the above example lower1 will be the
>  top, lower2 the middle and lower3 the bottom layer.
>
> +Note: directory names containing colons can be provided as lower layer b=
y
> +escaping the colons with a single backslash.  For example:
> +
> +  mount -t overlay overlay -olowerdir=3D/a\:lower\:\:dir /merged
> +
> +Since kernel version v6.5, directory names containing colons can also
> +be provided as lower layer using the fsconfig syscall from new mount api=
:
> +
> +  fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "/a:lower::dir", 0);
> +
> +In the latter case, colons in lower layer directory names will be escape=
d
> +as an octal characters (\072) when displayed in /proc/self/mountinfo.
>
> The wording of the last sentence above is somewhat legalish -
> De facto, since v6.5,y, we will escape ":" to "\072" no matter via which =
api
> we got it and regardless of whether it is also escaped with "\:" or not. =
but
> we only need to commit to this rule for unescaped colons via new mount ap=
i.

See my above argument against escaping colons on the mountinfo level.

Thanks,
Miklos
