Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3ACDE7D0A7
	for <linux-unionfs@archiver.kernel.org>; Thu, 21 Sep 2023 20:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbjIUUTi (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 16:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbjIUUTP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 21 Sep 2023 16:19:15 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BE39B4C;
        Thu, 21 Sep 2023 10:12:57 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id ada2fe7eead31-452b4fd977eso477717137.1;
        Thu, 21 Sep 2023 10:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695316376; x=1695921176; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+WIdFt6vJDrcHdG6YWsakScBEBflHQiav+VrJj2Kr/U=;
        b=Ddh8MU/bdBmAQp1f2l/kEk1xCBkoM3McuPaGkjHWxcautYIgvh8zSCYTZ70evx/vmX
         kF2GCVeUIk3uubwldVh5ckbT6fhBKt5UbmV4FewhZEqZUoOv2Y65drwg9GnUJyJB9LDl
         /vdkfE1rtZfLyp61fdaLlC/9UFMvNBReL5yLDbBKYWQCmVYwo9SlQJNxh/FZuosaPu8/
         8+JkxbEl22YT9V6z+Rnnu5vwHqgVGUR2/QYsAtZKFzi2Z6lAEzssbf+8Dio9HWczlBDi
         y3j4ug3OGcsHTtRnktzcOBkL7tc+p/Eids0lRJ8wQtHvAhKIceFWJwe5e9P6EJz6FQMG
         L+EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695316376; x=1695921176;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+WIdFt6vJDrcHdG6YWsakScBEBflHQiav+VrJj2Kr/U=;
        b=vvb6UO0ftBXWOcq8rBu9UfsEnsU+RlgbSqMgDsY9MugZsMFqx84Ih7NktM4xsUxK1A
         jeWnzpnhaXPYMGaeoqQkGZrNnQHYTliHfiVa5XSXxwreHGiw6h5bZxPihUgg7914qOoa
         DRm4uZ4Dd/SXkEZc6+543B9ULWWEZCjQXSt9Hu4Dvfo8s91mRTBJDMaXELkvjwWOZNH3
         MR0zAcEOdT9Wff4JBSqo3+n119rtYKBI1P8cvzYMFgPMRCB2sjrbLjRvVH0blVdGvYlA
         AsXjbzUXvvcGOjLXnaenaeqSDXPsNK2eRHum92ZY2P/J/pAPgrbIoZWojnSBvt+TGQIb
         bVpg==
X-Gm-Message-State: AOJu0YyGJoWs3xmOU1yUWErEDVH7LJE17LAcy6SILwZYLBsoTDWd559I
        k9TUmiv/3nVxlM/hg9PuA9J9vzw0F9mCw5Wnhbc=
X-Google-Smtp-Source: AGHT+IFsy931Jm6ji1RHCOwW/6LEeHndp4zhhg1dG3BN59Y6z6f0r1EsU2629DVm6cMgn3ciWSdJP2NeetcvVLjO9Co=
X-Received: by 2002:a05:6102:3168:b0:452:8423:e957 with SMTP id
 l8-20020a056102316800b004528423e957mr5238598vsm.28.1695316376147; Thu, 21 Sep
 2023 10:12:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230921143102.127526-1-amir73il@gmail.com> <20230921143102.127526-2-amir73il@gmail.com>
 <20230921152648.25wd4gqralgiuksv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxj5YR4Kv2-EZXnQGDo1zbExKZ+mw=rYNVBpCo30KkFAfQ@mail.gmail.com>
 <20230921162319.gsh5is3vkptp5hz2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxjgMjSY0fye1o-i-d44usfswuFebWBaQ6pE_od+HYGfrQ@mail.gmail.com> <20230921170626.hdqw5snvxtg4oxgl@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20230921170626.hdqw5snvxtg4oxgl@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 21 Sep 2023 20:12:45 +0300
Message-ID: <CAOQ4uxj0jhs1jxoP73FCAvmGxWhOVv26pnfgwfUC9YydCjGgSQ@mail.gmail.com>
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

On Thu, Sep 21, 2023 at 8:06=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote=
:
>
> On Thu, Sep 21, 2023 at 07:46:12PM +0300, Amir Goldstein wrote:
> > On Thu, Sep 21, 2023 at 7:23=E2=80=AFPM Zorro Lang <zlang@redhat.com> w=
rote:
> > >
> > > On Thu, Sep 21, 2023 at 06:40:49PM +0300, Amir Goldstein wrote:
> > > > On Thu, Sep 21, 2023 at 6:26=E2=80=AFPM Zorro Lang <zlang@redhat.co=
m> wrote:
> > > > >
> > > > > On Thu, Sep 21, 2023 at 05:31:01PM +0300, Amir Goldstein wrote:
> > > > > > Similar to _require_chattr, but also checks if an attribute is
> > > > > > inheritted from parent dir to children.
> > > > > >
> > > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > > ---
> > > > > >  common/rc | 52 +++++++++++++++++++++++++++++++++++++++++++----=
-----
> > > > > >  1 file changed, 43 insertions(+), 9 deletions(-)
> > > > > >
> > > > > > diff --git a/common/rc b/common/rc
> > > > > > index 1618ded5..00cfd434 100644
> > > > > > --- a/common/rc
> > > > > > +++ b/common/rc
> > > > > > @@ -4235,23 +4235,57 @@ _require_test_lsattr()
> > > > > >               _notrun "lsattr not supported by test filesystem =
type: $FSTYP"
> > > > > >  }
> > > > > >
> > > > > > +_check_chattr_inherit()
> > > > > > +{
> > > > > > +     local attribute=3D$1
> > > > > > +     local path=3D$2
> > > > > > +     local inherit=3D$3
> > > > >
> > > > > As I understand, this function calls _check_chattr_inherit, so it=
 will
> > > > > return zero or non-zero to clarify if $path support $attribute in=
heritance.
> > > > > ...
> > > > >
> > > > > > +
> > > > > > +     touch $path
> > > > > > +     $CHATTR_PROG "+$attribute" $path > $tmp.chattr 2>&1
> > > > > > +     local ret=3D$?
> > > > > > +     if [ -n "$inherit" ]; then
> > > > > > +             touch "$path/$inherit"
> > > > > > +     fi
> > > > >
> > > > > ... but looks like it doesn't, it only create a $inherit file, th=
en let the
> > > > > caller check if the $attribute is inherited.
> > > > >
> > > > > I think that's a little confused.
> > > >
> > > > I agree.
> > > >
> > > > > I think we can name the function as _check_chattr()
> > > >
> > > > I agree.
> > > >
> > > > > and the 3rd argument $inherit as a bool variable, to
> > > > > decide if we check inheritance or not.
> > > > >
> > > >
> > > > Not my prefered choice.
> > > >
> > > > > Or you'd like to have two functions _check_chattr and _check_chat=
tr_inherit,
> > > > > _check_chattr_inherit calls _check_chattr then keep checking inhe=
ritance.
> > > > >
> > > > > What do you think?
> > > >
> > > > I think this is over engineering for a helper that may not
> > > > be ever used by any other test.
> > > >
> > > > Suggest to just change the name to _check_chattr()
> > > > to match the meaning to the return value.
> > > >
> > > > The 3rd inherit argument just means that we request
> > > > to create a file after chattr + and before chattr -,
> > > > so that the caller could check it itself later.
> > >
> > > I still think it doesn't make sense ... but I don't want to give you
> > > that pressure, so ...
> > >
> > > >
> > > > If you accept this minor change is enough
> > > > can you apply it yourself on commit?
> > >
> > > ... If you think it's too complicated, we can drop the inheritance ch=
ecking
> > > common helper. Just change the _require_chattr(), make it to accept o=
ne more
> > > *directory* argument (use $TEST_DIR by default). Then we can do:
> > >
> > > _require_chattr A $BASE_SCRATCH_MNT
> >
> > This is not needed.
> > Overlayfs (on $SCRATCH_MNT) will not pass the require_chattr
> > check if the base fs does not support chattr.
>
> Oh, I saw you wrote as this:
>
>   +# prepare lower test dir with NOATIME flag
>   +lowerdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
>   +mkdir -p $lowerdir/testdir
>   +$CHATTR_PROG +A $lowerdir/testdir >> $seqres.full 2>&1 ||
>   +       _notrun "base fs $OVL_BASE_FSTYP does not support No_Atime flag=
"
>
> so I thought you might want a `_require_chattr A $BASE_SCRATCH_MNT`.
>

You are right. it should have been an error, not _notrun
as it is in V2.

> >
> > > _require_chattr A $SCRATCH_MNT
> >
> > This is practically equivalent to _require_chattr A
> > on the test partition, there is no reason to test the
> > scratch partition specifically.
> >
> > So there is no need for the proposed change in _require_chattr.
> >
> > >
> > > And then do all inheritance checking in the overlay case itself (like=
s you did in
> > > V1), don't make them to be a common helper. Due to only this case nee=
d the
> > > _require_chattr_inheritance, so we can think about that common helper=
 when more
> > > cases need that :)
> > >
> > > I think this change is simple enough (base on your V1 patch). Is that=
 good to
> > > you :)
> >
> > V1 is good enough for me as is. :)
> > You can take the commit message and test
> > header comment fixes from V2.
>
> I'll merge v2 patch 2/2, with ...
> 1) Change _require_chattr_inherit to _require_chattr.
> 2) Add `sleep 2s` under the "before=3D$(stat -c %x $lowerdir/testdir/lnk)=
" line.
>

OK.

Thanks!
Amir.
