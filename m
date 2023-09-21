Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 091D4E7D0AA
	for <linux-unionfs@archiver.kernel.org>; Thu, 21 Sep 2023 18:51:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjIUSvD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 14:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjIUSus (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 21 Sep 2023 14:50:48 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A89F8A224;
        Thu, 21 Sep 2023 10:40:40 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id 5614622812f47-3adba522a5dso763478b6e.2;
        Thu, 21 Sep 2023 10:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695318039; x=1695922839; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9EyuaiaJr9XfdsbSvB9YhWBNbzyhipdKnmp4WIFTwUk=;
        b=DAamoqZWhJ++x9+nF6LxFwvC3brKwPrUegZa0LR3XE30lk637CahTbIvLdokC5+3Zh
         okhrdeblaLwgtLULzVuJK1TNjDXE95wGWvaXQTbBnHOUKu6qzAuDijnWUFVG6IMWkCdu
         sq2XMijPIGnGeaum2tC6C0/8uSFR4FoEam4VuMoAzGdnJI50OTUmhBOfe0Yp+/STjA4O
         2lqOqxVXo7iq5X9fwXVaPyKopIfR/nEENcNOpX3sr9gwg6oZb4eo5T0S8Q1EXm4QNii5
         SwJN7voFtvLwhCofHVo4u4zOSTbiJ2fFuOCMqb0HdfsAk1SlqP+Qehi7peSzbH/yByEE
         P5pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695318039; x=1695922839;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9EyuaiaJr9XfdsbSvB9YhWBNbzyhipdKnmp4WIFTwUk=;
        b=ByX6W3yfDQpmUM34TgtnKoJlNfUTkIOyC2/cmreNChR19OvU1em2tZ9+DplyS8SbtZ
         mVhvnQTkyZ6/FO5AGJDZjhBw2NAzlrVKpq/kfAHxCGoYtwUvglvQxN8dlAIV7B+HEx5m
         tMiBn8+9ZHwV94NkvombGhA6GuGDCW8S3SY8vnclnIpMsweewE0n5RuzOBlW/ZQAdQgS
         11GBEHJGbWaqvyX3+FZ5cAN8+o75zMPZZcEcqfrsZw0P1mnUlIYSJmfARbVKQlzBjZ2S
         JmAfCoLkTA6foqpDg1qysh+sVHhrUzS9Vwf8j1FZK5EFT/tlga/0ScaCkALDkKOjeas6
         115Q==
X-Gm-Message-State: AOJu0YzpA24u2KxL1gL5bow64oGtPP/ki7nQKolFrEYIlWmd8lmH00eu
        bf4mmuHCEnA4yeNLeDtFspaTRTaFGO+EEIlFJqeNX6073k4=
X-Google-Smtp-Source: AGHT+IGkSDnx9+yI2PZKk5+CoubqcFa0ufQzcfuf5Sbvp7tXIQvBzE0On8ScGLzXQV12jqxhX91KAqLT9oWOxPRAwo8=
X-Received: by 2002:a67:ce9a:0:b0:452:61eb:dc2a with SMTP id
 c26-20020a67ce9a000000b0045261ebdc2amr5320395vse.21.1695310860508; Thu, 21
 Sep 2023 08:41:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230921143102.127526-1-amir73il@gmail.com> <20230921143102.127526-2-amir73il@gmail.com>
 <20230921152648.25wd4gqralgiuksv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20230921152648.25wd4gqralgiuksv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 21 Sep 2023 18:40:49 +0300
Message-ID: <CAOQ4uxj5YR4Kv2-EZXnQGDo1zbExKZ+mw=rYNVBpCo30KkFAfQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] common: add helper _require_chattr_inherit
To:     Zorro Lang <zlang@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Ruiwen Zhao <ruiwen@google.com>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Sep 21, 2023 at 6:26=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote=
:
>
> On Thu, Sep 21, 2023 at 05:31:01PM +0300, Amir Goldstein wrote:
> > Similar to _require_chattr, but also checks if an attribute is
> > inheritted from parent dir to children.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  common/rc | 52 +++++++++++++++++++++++++++++++++++++++++++---------
> >  1 file changed, 43 insertions(+), 9 deletions(-)
> >
> > diff --git a/common/rc b/common/rc
> > index 1618ded5..00cfd434 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -4235,23 +4235,57 @@ _require_test_lsattr()
> >               _notrun "lsattr not supported by test filesystem type: $F=
STYP"
> >  }
> >
> > +_check_chattr_inherit()
> > +{
> > +     local attribute=3D$1
> > +     local path=3D$2
> > +     local inherit=3D$3
>
> As I understand, this function calls _check_chattr_inherit, so it will
> return zero or non-zero to clarify if $path support $attribute inheritanc=
e.
> ...
>
> > +
> > +     touch $path
> > +     $CHATTR_PROG "+$attribute" $path > $tmp.chattr 2>&1
> > +     local ret=3D$?
> > +     if [ -n "$inherit" ]; then
> > +             touch "$path/$inherit"
> > +     fi
>
> ... but looks like it doesn't, it only create a $inherit file, then let t=
he
> caller check if the $attribute is inherited.
>
> I think that's a little confused.

I agree.

> I think we can name the function as _check_chattr()

I agree.

> and the 3rd argument $inherit as a bool variable, to
> decide if we check inheritance or not.
>

Not my prefered choice.

> Or you'd like to have two functions _check_chattr and _check_chattr_inher=
it,
> _check_chattr_inherit calls _check_chattr then keep checking inheritance.
>
> What do you think?

I think this is over engineering for a helper that may not
be ever used by any other test.

Suggest to just change the name to _check_chattr()
to match the meaning to the return value.

The 3rd inherit argument just means that we request
to create a file after chattr + and before chattr -,
so that the caller could check it itself later.

If you accept this minor change is enough
can you apply it yourself on commit?

Thanks,
Amir.
