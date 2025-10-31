Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9637D34D38A
	for <linux-unionfs@vger.kernel.org>; Fri, 31 Oct 2025 14:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761920990; cv=none; b=nQ9jPmSLEa1VDy2DeN2dx9hIpPCs2mYaAOYkadMsT6AmYQNdIx3LJvAhp9G+0AMGAAEgcGWsBek8Mcohy4CamqEukH32dJORncIz6Q6Bn075pjEyf45/azG8uyeBajRkY9bos1nmGBAMITfIa1+Sn7flP71ql674TvSd/SckPrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761920990; c=relaxed/simple;
	bh=csyzWyAEIRQuBa20Zip7w0lBvK/FLs6wGK2/VFEAD0g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BWHv06qDIZ8cTKEh+bvJxaz5ymF8gnuUsPkROLdIu/nmeBM4Ktq6rTXk6nY256RZlYKBg7b3TaVi00TX0ML9RA2bTpmpe48DfrecorBXqdcYbv3Plf5w+nNmpQTrQsJ2qGZVmHgn32DiShehBzm0lI70g+93rOrvpz7BoTPYKq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lunarenergy.com; spf=pass smtp.mailfrom=lunarenergy.com; dkim=pass (2048-bit key) header.d=lunarenergy.com header.i=@lunarenergy.com header.b=bEen7MwN; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lunarenergy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunarenergy.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lunarenergy.com header.i=@lunarenergy.com header.b="bEen7MwN"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47719ad0c7dso20734475e9.0
        for <linux-unionfs@vger.kernel.org>; Fri, 31 Oct 2025 07:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lunarenergy.com; s=google; t=1761920986; x=1762525786; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dt6hHT8shxfg/wvAVKGXhe4+P6Lt1g266GPcl1d6oy4=;
        b=bEen7MwNE+Z0R2R39zQ9PBPqM2ix+tNZazmv24e7uV7yMksZXZRH9geTbt48rN//id
         VUv3kVgRN6HxXMcSc99KMwaDLfMA/8VJf5VL2lI0w6M0V1U6Q8ekM9ybdpTn3/rxisUk
         /e9nWMM/pAiN7PnjzwA6738bnUBRoctMFHaycWf3rPhA+bLlhWj84MQKHrAastTinwQQ
         FN/CeieMa+GyNMjwWdpsS5l9fM7hTh1FWIVz1Fn9NB5Z7tEGzlgFemL/0aY4ZltvmyGy
         QERf4ivLb/+Mpk88U+QpPolv3VVT1KR+2xvvtwgNSOyV77e9X3khIAzaTE3+dlszB4Lu
         Pvvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761920986; x=1762525786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dt6hHT8shxfg/wvAVKGXhe4+P6Lt1g266GPcl1d6oy4=;
        b=njCXYpOCsKqDHCh9DhDHpI4yUuiugkNUAQDHVsZc1YAUoaCAgPLNwRhlJJtnqxnvUs
         UXnVw2OxoZumb9aPMlAUs9IuRL7OJ9KEP2T4dWP9b7CTAlB2Nq1Xp1eakg6zEElGASkT
         BrB8D2rpLIqxan27GfV8VDiov3o+m320sI7JiPtabWPo+WimJuzUqEGXPl20C+9Hdge/
         uUXgdaid7Zn5dhT2n2leSkbCP9C+n4sf7zayD+EoOTmx1Yenmt+62rRenX7KmDNYwLXI
         SPlxGcSgtU23Qbcx7tK7qeF+LJoJyWg1wXYFN61xOdhJjBiOyH3xgHHHbMsOi2zuXfYt
         8LNA==
X-Gm-Message-State: AOJu0YxYYXevqbfgD2sIheKpIleEKOHnEQMDXLOl9rb4D1rSMJz5f56t
	xDuzrVBDZdgL2M2isK6GWFYT9BGMEq9bBL4a8+TiGPDhBo8nhFivnamwDM/s+bX12RnjSAv7lPo
	jRvWXASMGW1WFbuiLA2h84YR+CcYRvWXe6FwZsP8C1dNTCqsp8XlLZRAv+iZUiM/jejP6Yl1Vmz
	/xDX+AEEHPZvbG08Wl+fxJVxrGhz30X7G483XGJy+gN1bKQg==
X-Gm-Gg: ASbGnctuHWZ58qH5klJ0ogo6AU+7acNqjUAtkoRPRK/QRwgSz2PS+PZLaKxsQrJhMlb
	3sPrkxUK5LPrB4g19OEdo80v5pouOZy3SgXF58soRj+edUWzH+dumtqpFL706LHR+2DcQYtLsP8
	SuKT/f0I3/sbfmdjrl64qrwEWwYswWa7peh4vq2qepKnqw5Ivu3PvwTZ/er+NS1RltyDW1Gkmty
	nlzy6diHsn8NXVteFqBA+HEvmaQc+MSIZQXANchjviPXpydoE3OJ/XPA5lkoldc9U0a7P4=
X-Google-Smtp-Source: AGHT+IHeLUxpaLvIHRH9wZfHiwNqkyqpAcgwnWd7yk6nK2wJfsoQWhZkzPsL5eJPhVu/maJi/twHtj4WE69H8cA96Zo=
X-Received: by 2002:a05:600c:3b15:b0:46e:6d5f:f68 with SMTP id
 5b1f17b1804b1-477307c2950mr37366005e9.12.1761920985748; Fri, 31 Oct 2025
 07:29:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPfD7wmf=ks9WEgAKdLWsn1igWG+v4bYsM=+ATat_0BZ+djaOA@mail.gmail.com>
 <CAOQ4uxhbdE-HE5wX2nJ3oFy++BJqSWctwaoXGnk=-1hTp8VOvg@mail.gmail.com>
In-Reply-To: <CAOQ4uxhbdE-HE5wX2nJ3oFy++BJqSWctwaoXGnk=-1hTp8VOvg@mail.gmail.com>
From: Mark Corbin <mcorbin@lunarenergy.com>
Date: Fri, 31 Oct 2025 14:29:34 +0000
X-Gm-Features: AWmQ_bkCd9JX7SkSvj6UX2OPwPSroeQWMS8vm2arIujlC6w0NHKsnB2HaNpj4yA
Message-ID: <CAPfD7wkucaZRtuaHhPmNHJjc4_SNuCtc+TatChBrpJS2Sb-WVw@mail.gmail.com>
Subject: Re: overlayfs - vaild to mount mergedir over lowerdir?
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 30 Oct 2025 at 17:54, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Oct 30, 2025 at 6:26=E2=80=AFPM Mark Corbin <mcorbin@lunarenergy.=
com> wrote:
> >
> > Hello
> >
> > Is it valid/safe to mount an overlayfs mergedir over the lowerdir?
> >
> > The Yocto/OE mount-copybind script does exactly that:
> >
> > overlay on /srv type overlay
> > (rw,relatime,lowerdir=3D/srv,upperdir=3D/var/volatile/srv,workdir=3D/va=
r/vola
> > tile/.srv-work)
> >
> > I wanted to do something similar with a read-only /etc where the
> > merged /etc is mounted on /etc, e.g.
> > mount -v -t overlay overlay -o
> > lowerdir=3D/etc,upperdir=3D/data/etc,workdir=3D/data/etc-work /etc
> >
> > Any issues or recommendations?
>
> None that I can think of.
> Overlayfs has no problem with that.
> It gets a reference to the lowerdir object at mount time *before*
> attaching itself to the mount point and that's it.
>
> Thanks,
> Amir.

Thanks Amir.

--=20

Mark Corbin
Senior Software Engineer  |  lunarenergy.com  |  LinkedIn  |  Instagram

--=20
C2:Restricted unless otherwise stated.

--=20








Lunar Energy Limited is a company registered in England and Wales,=C2=A0
authorised and regulated by the Financial Conduct Authority under reference=
=20
number 767876. Company registration number: 05631091. Registered office: 55=
=20
Baker Street, London, England, W1U 7EU
