Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABCE225405;
	Thu,  5 Jun 2025 18:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749148726; cv=none; b=ZvOYS2ume3ACd7/lpqlatoV0ZMK2QR1h+x2wchMzm2tmu0JuTKZI6q1l/fjyvVPSoTH0erKYJYC4BK+3yF0ERs43R6LcruNGRb9Hp04hB2APEnL4mMEiQEfXYQPxXftY6SL9TY4r3k8Bqq+VwMocgw+EbKp/2LNzI0bWzXagk2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749148726; c=relaxed/simple;
	bh=UMp2Rj7FWpipz1xJHCM4Bjz+O+Y2XktIh2NxaERA1R0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JpzGk0IaGGlgK/fEiLVKQQNvQcg1XojIdpUQSgvP8K0uWWw0uPQCbhD1KRo9uQhEsMhSNnO23K1AVsmo8OhuxvpuLlAOfZYol8K8xJYN5eYmL2qcM3F29NGqnYwaZh2HoTsl0wAR5SOvjXUuUL7plK2qYU89xypAUFxChf7s+Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nbJyde5n; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nbJyde5n"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-adb47e0644dso303201266b.0;
        Thu, 05 Jun 2025 11:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749148723; x=1749753523; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZLJ9KYP+tnsWuzCZJal9KP3hnwVBuVeRM6WuLpL/aDQ=;
        b=nbJyde5n8+tSZUaLdVFgxfJvc08r+1NEeFYT92Iw2KBJD8vbik8kEwihuhlffRAHYt
         yZxfd5U0wk3tJqjvKlvoioyUSxouZ2XFWVramo3VqHeV8g/dTHI0eoWejrTHaWzDCOuT
         EiPsBo8vWSFMTP7mCnqtKc2Q2otvPHd3cRQX1IORdJDIgr2NI14ap82lUPaoNCtTkMRW
         50AZqwEvkhWM6a3B9ESFG1zOkjK2oikc7M/JeMG+fva6vuWxypD0KAzgFB1J844MCf8X
         nbxz2lx12uC2MFmfxU7GASm13qEHk0+Z3QqxjEyvlsFcP8o05oWokW5XGD+2g0IgyMvz
         eA0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749148723; x=1749753523;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZLJ9KYP+tnsWuzCZJal9KP3hnwVBuVeRM6WuLpL/aDQ=;
        b=JjDIVp5Pgh1LCff3bpIH7Ca33aqL4iKOXGl9QCy8JbXZQcqpumVyiJIHTYtTkeFvVP
         WlGKCoVqd3sSwz+zqyku1oIacv63CHEB5oeiRGiakLnV9bo8FB+c/T2d0GBTzOEUliFo
         acPHxeWXEMCSHwMYp/t04lIMcjT+GXbxAkhO8cTPUNlhY/WoQlHSlovNQUtIkb+L1cVl
         lyWW/Og0yH9cCq2csAJ0YZ0nh4eXo4OfAxn6aL98fmM8zEZXSK59msvmyIAb2+OTJsCM
         +N71+j9NSdIHIOUROyi5oEyY5T+ZWGzxbA8O3cG06q7VGcYxodd2OsiIGXDGlLsV3I71
         sGIA==
X-Forwarded-Encrypted: i=1; AJvYcCUGoXfbIMJ9aJy+se22OcwkhIHqlUYfPdtIrZUkaw7m5LYMrt/baSVOAGgCT92qwn8bKK1Atig/@vger.kernel.org, AJvYcCUJLTOFBWH/vchqz32UL0Xumo1xpQ7Wz18AahItKaqn0F9Nntx2rqupuJNAB+Q1FOj7LU+d7vGaXQXJHdr3lw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0KbHNKWZB9gM8tBJF1VZ3LCqdFoJrgJ8VB8G0h6k0ty78TVCz
	cJTnoFLSTCfTCwy1AxYAj4wsJFlLIxL2f/LKf7fTMDiJgh59w7YMm1cDtLxTaeBOgN7IvC7gi6y
	U4aLeMZ2ZXVzPvqgunQXbDssKN1Yuh6JRGcAV8XE=
X-Gm-Gg: ASbGncuM9U6w1pV4mSxP00vTe32AZ67SkKf7PhNb39TZ/QDr+4xuTzHjkuNxNf1Uogv
	HBMaeV3M28xTxHiftJXfar1ZFORJ02twhVMALZ9cuCkAOvlUWWzLY5io9uY4TxaWVrYVOG1awBb
	VQQy1LLplyRzfSq1aX96yHPdbp5MHV/bUUwv3RaOiwN9g=
X-Google-Smtp-Source: AGHT+IGBrIfxZk1HBxSWhhsKrtEM6rWRM1211yvkiUqr8Vj1YsrUS9u9WyEUpgf92uozCGu9CQ8ejlr0TKxMVLYRjNg=
X-Received: by 2002:a17:907:1c91:b0:ad8:9394:272a with SMTP id
 a640c23a62f3a-ade07606ed3mr463192766b.12.1749148722645; Thu, 05 Jun 2025
 11:38:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250603100745.2022891-1-amir73il@gmail.com> <20250603100745.2022891-5-amir73il@gmail.com>
 <20250605173233.ndqsjo77ds3e35p5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20250605173233.ndqsjo77ds3e35p5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 5 Jun 2025 20:38:30 +0200
X-Gm-Features: AX0GCFtctcXbh6UoJVC20PPmPktvKFW8PbaXoecZab6QO-RagCySejkRy5_YIeI
Message-ID: <CAOQ4uxgQi6ciXtoKV7Nrw5_ECBOwS_m8h2KXT-ieJ4x4t04qag@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] generic/623: do not run with overlayfs
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	=?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 5, 2025 at 7:32=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote:
>
> On Tue, Jun 03, 2025 at 12:07:43PM +0200, Amir Goldstein wrote:
> > This test performs shutdown via xfs_io -c shutdown.
> >
> > Overlayfs tests can use _scratch_shutdown, but they cannot use
> > "-c shutdown" xfs_io command without jumping through hoops, so by
> > default we do not support it.
> >
> > Add this condition to _require_xfs_io_command and add the require
> > statement to test generic/623 so it wont run with overlayfs.
> >
> > Reported-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> > Tested-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> > Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-2350b1=
493d94@igalia.com/
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  common/rc         | 8 ++++++++
> >  tests/generic/623 | 1 +
> >  2 files changed, 9 insertions(+)
> >
> > diff --git a/common/rc b/common/rc
> > index d8ee8328..bffd576a 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -3033,6 +3033,14 @@ _require_xfs_io_command()
> >               touch $testfile
> >               testio=3D`$XFS_IO_PROG -c "syncfs" $testfile 2>&1`
> >               ;;
> > +     "shutdown")
> > +             if [ $FSTYP =3D "overlay" ]; then
> > +                     # Overlayfs tests can use _scratch_shutdown, but =
they
> > +                     # cannot use "-c shutdown" xfs_io command without=
 jumping
> > +                     # through hoops, so by default we do not support =
it.
> > +                     _notrun "xfs_io $command not supported on $FSTYP"
> > +             fi
> > +             ;;
>
> Hmm... I'm not sure this's a good way.
> For example, overlay/087 does xfs_io shutdown too,

Yes it does but look at the effort needed to do that properly:

$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f
' -c close -c syncfs $SCRATCH_MNT | \
        grep -vF '[00'

> generally it should calls
> _require_xfs_io_command "shutdown" although it doesn't. If someone overla=
y
> test case hope to test as o/087 does, and it calls _require_xfs_io_comman=
d "shutdown",
> then it'll be _notrun.

If someone knows enough to perform the dance above with _scratch_shutdown_h=
andle
then that someone should know enough not to call
_require_xfs_io_command "shutdown".
OTOH, if someone doesn't know then default is to not run.

>
> If g/623 is not suitable for overlay, how about skip it for overlay clear=
ly, by
> `_exclude_fs overlay` ?
>

I do not personally mind doing this _exclude_fs overlay, but it is usually
prefered to require what the test needs.

Whatever you prefer is fine by me.

Thanks,
Amir.
