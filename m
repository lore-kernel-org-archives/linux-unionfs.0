Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9446019D071;
	Wed, 28 May 2025 10:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748429937; cv=none; b=ubyUNrVcKEiycN4ujpHHexTANI+eMYIRUhCoLJXl87gE84/7VQ4eKpt1wzxICm+xRute8soYkE5U8xatoyBf2sd+NkLRpjBJgnd0gG8p22ZkKcoZAsNR2OpVJ7mlukQB8Im92cATv0zBk6oRog80o1PYxjtjdAlpw/X+YrBg1Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748429937; c=relaxed/simple;
	bh=C6ysBc+MPDOEWw9EEwaiQIBiSZ1Uc/oT0aNe+2bwsik=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XhVyUgcaIwPYJR1K++PMMDklOUb6VFcsitY6i5ocUmCf6QFW6U7ZA5zm0o7PjsvuuZ40rf8PmxuDg+q63eHutfT7XpkFx60nzmhcq/fcnqGGChTv5FZKI6umpFVhhFLM1v/kgkZNZ03j5hhc7SxSnAmI92kFe7QN1DIwMtw50GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jeAJg7br; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jeAJg7br"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ad5740dd20eso667467866b.0;
        Wed, 28 May 2025 03:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748429934; x=1749034734; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wNGm+XVL2Zfl7NbTSS+bsZrVa2OnUVpDRUOiJOgQUQ4=;
        b=jeAJg7br0BtNMgnO4i+q8m6pxGv6xaL2hmd2QzfrtpqYrewUuhkLhZH5A4rYEizVMj
         zIHbTKZ3v5D8g88lLvtkn5FlkWJ2QO4co2jscaUM9P2ggd1WpkowAdtGF/QLk72HemfJ
         gyyQFxk63eN6dB6AbKR3d9A5FTBOaOvFOWfe0OMKtExCGNFj+1DJ7PL1x5qM4jBMRL0l
         mv62l46iZDN4OvnCN1REHqsxYBlJ2KUOl0F2o26EUnmQvV+gmww/JBNvxn2tXz1+genS
         F1xx8hQnBXB1YjEyEa/RKaN0zlO5POs7O9m0w8NZCi+AEEFn3QMV/GwQHMKksof9h7Oa
         3PNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748429934; x=1749034734;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wNGm+XVL2Zfl7NbTSS+bsZrVa2OnUVpDRUOiJOgQUQ4=;
        b=HZ0HelzG3ryG0+RcnvzXR+s4h0pPrAxdQ/w2BwvOo7bjNNDQ2M+Gj8bzpqtCcMVfZ8
         7/N6oXB0sqwv90pQTjmIuc/CuVNSE8xlZbVYDO0d3EJ6AfeR3Yuey8zOk6K9XXsK7KAy
         pkVxG4DnokKe2khfpT/HLKDd5V6xr4K/Ecgp2so/nxbiMLqrYqqhcAj/SGT4EZWuxDvn
         qYYGIqz+DElmj0zzYtBs1WB/Q2/8UvJ0jMIE7dNAJaTczZYiJiwDWrGKHYI4mEXvBeBv
         VnUtRMjw2FyRzp7H8agAAEfDPZS05uhp+BBsupfGboOOkMdreFsm9XeNeTY1ZFoHi2f3
         A+GA==
X-Forwarded-Encrypted: i=1; AJvYcCV6O/76hg2QKx2Y0wLuAURRusWLG8n1jRVlKnUGwkzGicxrmas7Zb7sObp/h5dhoWz4BUSuaKhc@vger.kernel.org, AJvYcCXJIhb+tywMaaPV5iAhZA4wAiYb6PPV5+dlCWttflftlFjnNQTwNWsBRt8xbac6q0iO8mkxaprEktSD0Ov4DA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwywLBiEWknJNIdNkHZkV805JE87L41BrwVObKDsstysfjQYwzL
	kvjxhmspm/WBfk4ja3qQqzdEqwl16HE+Uv23QY1Xw8ru834q+BdVELTNiWz0iXkp/zCKdfi7pNF
	ojnDDi6JVkz2MxZLl59UtGdmMr1hnoncFXSNt2w0=
X-Gm-Gg: ASbGnctXKYraOSZ8WssQ5cG+arJoLJ7sziQY8ltQFTg/8WQRo/vwOWzoNX/eGPqW6If
	SBHqS/s85+PmrKOljAu0YQQaIiIxNtlNaPgSg75grCsbKdGjoTWnHSlVAyJpK0yd9hVTOvGOe3R
	Au4r5c+bIm37fopd11w1bl6X9Io+/SgW5N
X-Google-Smtp-Source: AGHT+IEWEc+aTjbATn+MWeDvxPGpQYWxE3FT9Qp+aPuGkXf+GOtXZcyVKIyrgwnrYZFruwElcKYBFkBbPGP4q6A4ecc=
X-Received: by 2002:a17:907:25c7:b0:ad6:4e8e:1883 with SMTP id
 a640c23a62f3a-ad85b0a7809mr1552755366b.3.1748429933592; Wed, 28 May 2025
 03:58:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250526143500.1520660-1-amir73il@gmail.com> <20250526143500.1520660-2-amir73il@gmail.com>
 <CAJfpegtYTpJXYOiyckcfQA=YTVXcLQZRGV4=sjueLenJpTp7Lw@mail.gmail.com>
 <CAOQ4uxjh9u3DE_HKExa=kK08efzDsxVuCVuA0tUMjwSeLX=jnQ@mail.gmail.com>
 <rjqagpvze4mwnil6tck6jnyqfbcgqszy5bjgu4fqzdtq7e3idq@uizmifogsqyf> <CAJfpegtJ3SDKmC80B4AfWiC3JmtWdW2+78fRZVtsuhe-wSRPvg@mail.gmail.com>
In-Reply-To: <CAJfpegtJ3SDKmC80B4AfWiC3JmtWdW2+78fRZVtsuhe-wSRPvg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 28 May 2025 12:58:40 +0200
X-Gm-Features: AX0GCFvJzp-2padslxisj0BL98U_mizL0YISvumQhJokEjJTj2Mxd0sT_hFOq0Y
Message-ID: <CAOQ4uxj45_DdENOxpbz68rBRTA-Crq7OwpJ5VqGs=DScSr9AQQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] overlay: workaround libmount failure to remount,ro
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Karel Zak <kzak@redhat.com>, Zorro Lang <zlang@redhat.com>, linux-unionfs@vger.kernel.org, 
	fstests@vger.kernel.org, =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025 at 11:57=E2=80=AFAM Miklos Szeredi <miklos@szeredi.hu>=
 wrote:
>
> On Wed, 28 May 2025 at 10:47, Karel Zak <kzak@redhat.com> wrote:
>
> > Anyway, I agree that this semantics sucks, and from my point of view,
> > the best approach would be to introduce a new mount(8) command line
> > semantics to reflect the new kernel API, something like:
> >
> >    mount modify [--clear noexec] [--set nodev,ro] [--make-private] [--r=
ecursive] /mnt
> >    mount reconfigure data=3Djournal,errors=3Dcontinue,foo,bar /mnt
> >
> > and do not include options from fstab in this by default.
>
> But there's no fstab entry in the testcase.  The no-fstab case likely
> gets way more use in real life then remounting something in fstab.
> And this should not need to get the current options from the kernel,
> since the kernel is the source of the current options.
>
> With the KISS principle in mind the non-fstab "mount -oremount,ro
> /mnt/foo" should just be translated into:
>
> fd =3D fspick(AT_FDCWD, "/mnt/foo", 0);
> fsconfig(fd, FSCONFIG_SET_FLAG, "ro", NULL, 0);
> fsconfig(fd, FSCONFIG_CMD_RECONFIGURE, NULL, NULL, 0);
>

+1

> and the kernel should take care of the rest.  I assume this doesn't
> generally work, which is a pity, but I'd still think about salvaging
> the concept.
>
> > So, you do not need LIBMOUNT_FORCE_MOUNT2=3D workaround, use
> > "--options-mode ignore" or source and target ;-)
>
> Yeah, that's definitely a better workaround.
>

Agree. I will use a different workaround for fstest.

Thanks,
Amir.


> I wouldn't call it a fix, since "mount -oremount,ro /overlay" still
> doesn't work the way it is supposed to, and the thought of adding code
> to the kernel to work around the current libmount behavior makes me go
> bleah.
>
> Thanks,
> Miklos
