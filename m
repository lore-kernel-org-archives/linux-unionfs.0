Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 733CDE7D0A2
	for <linux-unionfs@archiver.kernel.org>; Thu, 21 Sep 2023 20:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbjIUUYF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 16:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbjIUUXm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 21 Sep 2023 16:23:42 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C65297A3;
        Thu, 21 Sep 2023 10:11:59 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-417f1eac78dso2088851cf.2;
        Thu, 21 Sep 2023 10:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695316317; x=1695921117; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B1BEXO62EEn6iGTjffZUwayUHq4lmRxZ6FhKktsQuGo=;
        b=XE2LRK+amVP3yQqCce6g/KT6k/GPPu84eQxqNqt4d9PMEh9G2bkfBYRtbmkORiujoE
         ACTEdVClmpoZh5igc/AZXO4bMod1fPnOmVA9NzS2W7lorTreJBxg2bwlDM4zxEHgF6Pm
         Jh3omsXR8f6vxqkMe5FqUtPw68tFa6WOS+jSnTjmuQGstuhGx91g8RHp0Sqg0unb8J+h
         MYDMxa/PbMW8tHLJz/jjPaa30AqxotqcL3XhyRe2657YPeqsh51G/IVK2kEZ14idEUph
         rEIFrWmvXMPmP04HakE36QhpHMPBz5NP/aZUYdT/VUjiNGIJqiHBmCgobodp7cxvK21z
         gFOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695316317; x=1695921117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B1BEXO62EEn6iGTjffZUwayUHq4lmRxZ6FhKktsQuGo=;
        b=Y3ffRDvnj29id0AMCv8X4DELiMEGT6RhdB8hRUQh6yiW+chmK8Q1gTSmQpUJPItouB
         jF5yeMW/0ZSMJCOJLDKR+YVfDVI3UZY7lC0y/viAIHu09IeguQnRSqMyzNiYjQFcr6Dk
         dyqSUFVHVyCYcylVt39JGd96SylYyYH/4OEZiPoYYPgYqDTSTjONhqR5waZa5tNHFDCt
         pM73gVi4K+If4sfPq/FxNTzpyLN6rNDrmlB8e9J8Nqg8SOOxA++7Mf6nfFI+9pWfwqSn
         0wNriYZuR4cJumaEw6LRCMtfcfOHHd1uOUQ8NmtLN/pJBMjV+xPNjh9gad+HvvolHR8K
         dD2w==
X-Gm-Message-State: AOJu0YyGkOx/CzmvzHmbGBugmUkrGYP8QXRyxaoEcxvJzm6unkVwBp90
        JnGHM6LgFLkmjBkEhzYKGYrDa1Q4Bqzo/HI9OeKYdCReEeU=
X-Google-Smtp-Source: AGHT+IFdSsCwPtNG1F1MfazC3K9oia0A+lErcjIuVp4zrRqeXtkM1jjof5FwEuhbvVYVPK763RUuDJ1Qy+gVkNEDRo0=
X-Received: by 2002:a05:6102:578d:b0:452:c5b5:e666 with SMTP id
 dh13-20020a056102578d00b00452c5b5e666mr1279841vsb.34.1695314783488; Thu, 21
 Sep 2023 09:46:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230921143102.127526-1-amir73il@gmail.com> <20230921143102.127526-2-amir73il@gmail.com>
 <20230921152648.25wd4gqralgiuksv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxj5YR4Kv2-EZXnQGDo1zbExKZ+mw=rYNVBpCo30KkFAfQ@mail.gmail.com> <20230921162319.gsh5is3vkptp5hz2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20230921162319.gsh5is3vkptp5hz2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 21 Sep 2023 19:46:12 +0300
Message-ID: <CAOQ4uxjgMjSY0fye1o-i-d44usfswuFebWBaQ6pE_od+HYGfrQ@mail.gmail.com>
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

On Thu, Sep 21, 2023 at 7:23=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote=
:
>
> On Thu, Sep 21, 2023 at 06:40:49PM +0300, Amir Goldstein wrote:
> > On Thu, Sep 21, 2023 at 6:26=E2=80=AFPM Zorro Lang <zlang@redhat.com> w=
rote:
> > >
> > > On Thu, Sep 21, 2023 at 05:31:01PM +0300, Amir Goldstein wrote:
> > > > Similar to _require_chattr, but also checks if an attribute is
> > > > inheritted from parent dir to children.
> > > >
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > ---
> > > >  common/rc | 52 +++++++++++++++++++++++++++++++++++++++++++--------=
-
> > > >  1 file changed, 43 insertions(+), 9 deletions(-)
> > > >
> > > > diff --git a/common/rc b/common/rc
> > > > index 1618ded5..00cfd434 100644
> > > > --- a/common/rc
> > > > +++ b/common/rc
> > > > @@ -4235,23 +4235,57 @@ _require_test_lsattr()
> > > >               _notrun "lsattr not supported by test filesystem type=
: $FSTYP"
> > > >  }
> > > >
> > > > +_check_chattr_inherit()
> > > > +{
> > > > +     local attribute=3D$1
> > > > +     local path=3D$2
> > > > +     local inherit=3D$3
> > >
> > > As I understand, this function calls _check_chattr_inherit, so it wil=
l
> > > return zero or non-zero to clarify if $path support $attribute inheri=
tance.
> > > ...
> > >
> > > > +
> > > > +     touch $path
> > > > +     $CHATTR_PROG "+$attribute" $path > $tmp.chattr 2>&1
> > > > +     local ret=3D$?
> > > > +     if [ -n "$inherit" ]; then
> > > > +             touch "$path/$inherit"
> > > > +     fi
> > >
> > > ... but looks like it doesn't, it only create a $inherit file, then l=
et the
> > > caller check if the $attribute is inherited.
> > >
> > > I think that's a little confused.
> >
> > I agree.
> >
> > > I think we can name the function as _check_chattr()
> >
> > I agree.
> >
> > > and the 3rd argument $inherit as a bool variable, to
> > > decide if we check inheritance or not.
> > >
> >
> > Not my prefered choice.
> >
> > > Or you'd like to have two functions _check_chattr and _check_chattr_i=
nherit,
> > > _check_chattr_inherit calls _check_chattr then keep checking inherita=
nce.
> > >
> > > What do you think?
> >
> > I think this is over engineering for a helper that may not
> > be ever used by any other test.
> >
> > Suggest to just change the name to _check_chattr()
> > to match the meaning to the return value.
> >
> > The 3rd inherit argument just means that we request
> > to create a file after chattr + and before chattr -,
> > so that the caller could check it itself later.
>
> I still think it doesn't make sense ... but I don't want to give you
> that pressure, so ...
>
> >
> > If you accept this minor change is enough
> > can you apply it yourself on commit?
>
> ... If you think it's too complicated, we can drop the inheritance checki=
ng
> common helper. Just change the _require_chattr(), make it to accept one m=
ore
> *directory* argument (use $TEST_DIR by default). Then we can do:
>
> _require_chattr A $BASE_SCRATCH_MNT

This is not needed.
Overlayfs (on $SCRATCH_MNT) will not pass the require_chattr
check if the base fs does not support chattr.

> _require_chattr A $SCRATCH_MNT

This is practically equivalent to _require_chattr A
on the test partition, there is no reason to test the
scratch partition specifically.

So there is no need for the proposed change in _require_chattr.

>
> And then do all inheritance checking in the overlay case itself (likes yo=
u did in
> V1), don't make them to be a common helper. Due to only this case need th=
e
> _require_chattr_inheritance, so we can think about that common helper whe=
n more
> cases need that :)
>
> I think this change is simple enough (base on your V1 patch). Is that goo=
d to
> you :)

V1 is good enough for me as is. :)
You can take the commit message and test
header comment fixes from V2.

Note that the common _require_chattr_inheritance in V2
almost did not remove any lines from the test at all -
it moved one _notrun line into _require_chattr_inheritance
and turned another _notrun into echo "fail".

So I agree that if no other test is going to use the new helpers
their value is limited.

Thanks,
Amir.
