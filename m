Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UgGB7cZa"
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B82120;
	Wed,  6 Dec 2023 02:30:07 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id d75a77b69052e-42573090000so4595241cf.0;
        Wed, 06 Dec 2023 02:30:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701858607; x=1702463407; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ManYJ4iH+7Glq1N9TdJT0x0N7GL+Rgw7Mwl32pJ4Fw=;
        b=UgGB7cZahTq7f6GeA1es/v8OTqk7v21MZsT5WppMym1TE3GfqsEFT7mpHe7s0o7q8e
         wOCN96UEcKxz1oPmmN+aSo3duAi+THPjrmiVKQ8oj2iLejPTsrm1mjUZgcSCoiuW7d+m
         dhIGfMVtqFqqUovygrI9CLT0g76R6pvmY3jKTgxYjlOwASoBpLE3NOF1K1Wfgwbq7/bs
         tRFKElARBj7W7np/y05rZnDtqUHeZKYCTuZwjsIkGK3jV82xV1RI5xzilG8iiWxFbFqE
         ko/2f/WOfQq4wpZF1SGIratBAi5275jiuN+RmyPvg3BGpC4zu2Avp6nD2Yh1BwzGCKeK
         SYmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701858607; x=1702463407;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2ManYJ4iH+7Glq1N9TdJT0x0N7GL+Rgw7Mwl32pJ4Fw=;
        b=H2IAv8aYsfUojw0gWq5uVfZKY2W2kNw2Mh2ttWRgAz3eWBMoVd8Ig7lMJ/1MmRnbAv
         zOxrHK2/1tgq6euEVrICDf3Bb9YKonDj+Qmco+3ptQ/0zTuoV/zmt6vJgVRoCHnL4SbN
         /LIaTd/YaKgtUm03Si12NrtxvB0cDUQRjn79HbeXXtcNfl+2lxP0mBNlHfHyQI7Ky871
         nItF3n+6/zjPw4GdMnGEz65Bj25EiK6GYyxmd7dg2Kz3lbKlCDkdK2KiUvrVY4A9ANYX
         czHiRPnpTssrm7Z9b24cC/IH/neqQsT6QaKFOiomAYA+NtFvXzByBA2Mf0SPYnOlIhq8
         qZ+w==
X-Gm-Message-State: AOJu0YzktPGMSUs1i5yo7frC75Us7eGTeyKmAr/sAs3EZHf8B9yKrIf1
	C3137Bol+jzDRrrJ7N2pd05IAa6dnzi7EJTJCAE=
X-Google-Smtp-Source: AGHT+IEJgD8h2sohptearYgmwgCPJtYWnBi6feYXahkhIuVAEljV/+U5+1I5aXd2IcigqM6ACUmMbU1B87vaRzdatuU=
X-Received: by 2002:a05:6214:cae:b0:67a:55f2:1084 with SMTP id
 s14-20020a0562140cae00b0067a55f21084mr3520404qvs.8.1701858606683; Wed, 06 Dec
 2023 02:30:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231204185859.3731975-1-amir73il@gmail.com> <20231204185859.3731975-3-amir73il@gmail.com>
 <20231206083746.aeokhhylcbpd6rkl@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20231206083746.aeokhhylcbpd6rkl@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 6 Dec 2023 12:29:54 +0200
Message-ID: <CAOQ4uxi-64evfEQo3KNbO5-h1LF1Jgy5o1X1niH_EO+U7-2fHA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] overlay: prepare for new lowerdir+,datadir+ tests
To: Zorro Lang <zlang@redhat.com>
Cc: Alexander Larsson <alexl@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 6, 2023 at 10:37=E2=80=AFAM Zorro Lang <zlang@redhat.com> wrote=
:
>
> On Mon, Dec 04, 2023 at 08:58:57PM +0200, Amir Goldstein wrote:
> > In preparation to forking tests for new lowerdir+,datadir+ mount option=
s,
> > prepare a helper to test kernel support and pass datadirs into mount
> > helpers in overlay/079 test.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  common/overlay    | 15 +++++++++++++++
> >  tests/overlay/079 | 36 +++++++++++++++++++++---------------
> >  2 files changed, 36 insertions(+), 15 deletions(-)
> >
> > diff --git a/common/overlay b/common/overlay
> > index 8f275228..ea1eb7b1 100644
> > --- a/common/overlay
> > +++ b/common/overlay
> > @@ -247,6 +247,21 @@ _require_scratch_overlay_lowerdata_layers()
> >       _scratch_unmount
> >  }
> >
> > +# Check kernel support for lowerdir+=3D<lowerdir>,datadir+=3D<lowerdat=
adir> format
> > +_require_scratch_overlay_lowerdir_add_layers()
> > +{
> > +     local lowerdir=3D"$OVL_BASE_SCRATCH_MNT/$OVL_UPPER"
> > +     local datadir=3D"$OVL_BASE_SCRATCH_MNT/$OVL_LOWER"
> > +
> > +     _scratch_mkfs > /dev/null 2>&1
> > +     $MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
> > +             -o"lowerdir+=3D$lowerdir,datadir+=3D$datadir" \
> > +             -o"redirect_dir=3Dfollow,metacopy=3Don" > /dev/null 2>&1 =
|| \
> > +             _notrun "overlay lowerdir+,datadir+ not supported on ${SC=
RATCH_DEV}"
>
> Hi Amir,
>
> I found overlay cases don't use helpers in common/overlay recently, alway=
s
> use raw $MOUNT_PROG directly (not only in this patchset). Although overla=
y
> supports new mount format, can we improve the mount helpers in common/ove=
rlay
> to support that? It would be to good to use common helpers to do common
> operation.
>
> Anyway, that can be changed in another patch, if it takes too much time o=
r
> you don't want to do it at here. What do you think?

I agree. I wouldn't improve the existing helpers to support the new
lowerdir+,datadir+ options as positional argument like in
_overlay_scratch_mount_dirs(), but there is an opportunity to reduce
dedupe of this common line with a helper:

# Mount with mnt/dev of scratch mount and custom mount options
_overlay_scratch_mount_opts()
{
        $MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT $*
}

I will work on this cleanup and post a patch when I get to it.
No need to block this series for the cleanup.

Thanks,
Amir.
