Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDD63BB22
	for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2024 12:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705927950; cv=none; b=Px0fho5+0FtmjgnpijhNDzqV1VraejRpXuD9EAu4XaJ89EM1BgJvsYzpW71fqIhiSCuNXYiqGKUv+o4JwXHMoUPY545LrS1TsVqlqQ71knbC+2ZHezMwD+WYSMGw1v8hPGe/0nxPCeB1R9SkaMbw6MSBDfJi8+Mor6fbYANcQB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705927950; c=relaxed/simple;
	bh=mfzVrxz2KVCfG/EAkYCwx35fGtbyr9FFV0kAm41jMGQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eC2OOyBlzMtr44kvOAhhi6/VeS/gh3kX1sTG3Y4HudE7Vj4Hdep+jiXB+dFecYwCnTvF4DpvoPAKcfqyc54RUgEAKELz42NaBsLnzEq8W7Kj3/ddJdqQodUxytdw4LSIXm2KxxL4yTAma+JNa0ycZCmPfSJN9nCF8c9d4YXayBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ICsTo33B; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ICsTo33B"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-5ff821b9acfso26508857b3.1
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2024 04:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705927948; x=1706532748; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BJEaWjRGYe1lvV65aIPlmwgoUDISSzO3lI96AoVJK3E=;
        b=ICsTo33BPkszwZL/Lkl45Tnx6AB/TvPKnQY4l42zO0Gkk8CFEDYjJduLK2G6fEpi67
         S7DtM4oGg+sn7Lal8Km0eu06AAxhtJOuM1TkyYxRpvuIWQhghi7GyKmaaKPUBE0rEtyK
         nKFbes+nVeqloHOh4zdX8Mnm0nHNmWbxGUQtmvNBN4cJl4cBhu8q6twWx0Iycg05w1EO
         fRE7L/xtFjxAsubW5Sb6orTGz1E2WpGcaqjhhN3AZBy1NIHKVZ1Zlin4OQX+brEnGn6s
         8JRCAgXi2u2sOCPFmJZif7YIMTNrrGSG3WQtayp0xNehlT0w2GRvcY84GSLFNuvSbdws
         YR2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705927948; x=1706532748;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BJEaWjRGYe1lvV65aIPlmwgoUDISSzO3lI96AoVJK3E=;
        b=vo4R6vAkov4D0LKgbRw7ZQ5TpGWZwCW/cIdoN6uBvNlC+jllWfrsb6HI4W/Z9SNohu
         7pr9n7GwzRiDGDAVel4NCACvkAPXlwrNQ15Dc3WW25PeDHjZFy33Sv3gENx+lD+aWebv
         r+6iw8Ev0F3XyauCmqjX2lRJxj2ByoYRGWKzlH6h+wlo0pd9PXvM6HHqWtAJ5KX2RKWX
         eseh5+4Gxzbo0k2aYOCV3sv/Oz2u3421k26FYTksfhiqsDpPimNxeWwxguM3OWr/p3ul
         ZrT0sDO9Im8d47gaHzTq5KP2jKJCaweeZils6Rbx2Dr+4A8bJ0z9vFjr9czVlWC2pm/q
         1GDg==
X-Gm-Message-State: AOJu0Yx0JiKAYl0gLsw0MB/ZBu7rPHwKO3zNf9NAYq1u7mPe+Vak7H2D
	4QSZ63Zvq6IPaXM9+aqVvKR2aXBYiYT6zyxJGyp5KG7i3TZQsx4zlW3Iu7EZPNpNcfxqSCYLio3
	dLjsgsj1CQTX30Q355NpxnHBbXb8=
X-Google-Smtp-Source: AGHT+IER2Xqce3qmyzQevIZ4JjvgySFIqyK+5eQJCIheK4C00zYnD9Tior8Cbfk2B+55LCUC4en9qN3U5S1A15GbocI=
X-Received: by 2002:a0d:f507:0:b0:5ff:9f2c:1299 with SMTP id
 e7-20020a0df507000000b005ff9f2c1299mr3001688ywf.65.1705927948018; Mon, 22 Jan
 2024 04:52:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240121150532.313567-1-amir73il@gmail.com> <3679657b0589ee31d09fb9db140fe57121989a69.camel@redhat.com>
 <CAOQ4uxh5x_-1j8HViCutVkghA1Uh-va+kJshCuvB+ep7WjmOFg@mail.gmail.com> <e7e1a2268a696af96d8b7f14cbb20edcee032dfb.camel@redhat.com>
In-Reply-To: <e7e1a2268a696af96d8b7f14cbb20edcee032dfb.camel@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 22 Jan 2024 14:52:16 +0200
Message-ID: <CAOQ4uxhu_p1OGh8aFEq6nEpWMzFjyXOvrirhYc-apAzc6Phq6g@mail.gmail.com>
Subject: Re: [PATCH v3] ovl: mark xwhiteouts directory with overlay.opaque='x'
To: Alexander Larsson <alexl@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 22, 2024 at 1:52=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> On Mon, 2024-01-22 at 13:09 +0200, Amir Goldstein wrote:
> > On Mon, Jan 22, 2024 at 12:14=E2=80=AFPM Alexander Larsson <alexl@redha=
t.com>
> > wrote:
> > >
> > > On Sun, 2024-01-21 at 17:05 +0200, Amir Goldstein wrote:
> > > > An opaque directory cannot have xwhiteouts, so instead of marking
> > > > an
> > > > xwhiteouts directory with a new xattr, overload overlay.opaque
> > > > xattr
> > > > for marking both opaque dir ('y') and xwhiteouts dir ('x').
> > > >
> > > > This is more efficient as the overlay.opaque xattr is checked
> > > > during
> > > > lookup of directory anyway.
> > > >
> > > > This also prevents unnecessary checking the xattr when reading a
> > > > directory without xwhiteouts, i.e. most of the time.
> > > >
> > > > Note that the xwhiteouts marker is not checked on the upper layer
> > > > and
> > > > on the last layer in lowerstack, where xwhiteouts are not
> > > > expected.
> > > >
> > > > Fixes: bc8df7a3dc03 ("ovl: Add an alternative type of whiteout")
> > > > Cc: <stable@vger.kernel.org> # v6.7
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > ---
> > > >
> > > > Miklos,
> > > >
> > > > Alex has reported a problem with your suggested approach of
> > > > requiring
> > > > xwhiteouts xattr on layers root dir [1].
> > > >
> > > > Following counter proposal, amortizes the cost of checking opaque
> > > > xattr
> > > > on directories during lookup to also check for xwhiteouts.
> > > >
> > > > This change requires the following change to test overlay/084:
> > > >
> > > > --- a/tests/overlay/084
> > > > +++ b/tests/overlay/084
> > > > @@ -115,7 +115,8 @@ do_test_xwhiteout()
> > > >
> > > >         mkdir -p $basedir/lower $basedir/upper $basedir/work
> > > >         touch $basedir/lower/regular $basedir/lower/hidden
> > > > $basedir/upper/hidden
> > > > -       setfattr -n $prefix.overlay.whiteouts -v "y"
> > > > $basedir/upper
> > > > +       # overlay.opaque=3D"x" means directory has xwhiteout
> > > > children
> > > > +       setfattr -n $prefix.overlay.opaque -v "x" $basedir/upper
> > > >         setfattr -n $prefix.overlay.whiteout -v "y"
> > > > $basedir/upper/hidden
> > > >
> > > >
> > > > Alex,
> > > >
> > > > Please let us know if this change is acceptable for composefs.
> > >
> > > Yes, this looks very good to me. (Minor comments below)
> > > I'll do some testing on this.
> > >
> >
> > Excellent, I'll be expecting your RVB/Tested-by.
> > >
>
> Yes
> Reviewed-by: Alexander Larsson <alexl@redhat.com>
> Tested-by: Alexander Larsson <alexl@redhat.com>
>
> for the patch in the ovl-fixes branch.

Thanks. pushed.

>
> I tested it manually, and with xfstest (with change), and also
> with this composefs change:
>
> https://github.com/alexlarsson/composefs/tree/new-format-version
>
> I created a lowerdir with a regular whiteout in, and after running that
> though the changed mkcomposefs I was able to mount the composefs image,
> and then mount the lowerdirs from the composefs mount, and they
> correctly handled the whiteout both when mounted normally and with
> userxattr.
>

I noticed you comment in composefs:

 * 1 - Mark xwhitouts using the new opaque=3Dx format as needed by Linux 6.=
8

Note that this "fix" is aimed to be backported to v6.7.y, so there is no ke=
rnel
version that is expected to retain support for the old format.

Thanks,
Amir.
