Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D999D17A316
	for <linux-unionfs@vger.kernel.org>; Fri, 28 Mar 2025 09:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743152691; cv=none; b=FQ4bZ0F0BANwpq3lwvh6hUSjzlMq9SHPAcahyeA875ggc/2iAFX1DFeYDNBtlW8GtxL14n2EXUR89InKrusHyQSWn1OPfCiE94A1ugo0fh3LUWsYnMSi8Al2eVrdvohlW77cjme1Oc8eOBWa2Fghjbttg63OIPB585GvUEU9Jr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743152691; c=relaxed/simple;
	bh=ESusgfYdb+XZoSNlRLvcbZvlZG0iyY4YItOOJvPMPJ4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=r/5qkChYNK0SVPEIlS61qZtySiSipgEsjMJdQGnjJ/zyc2/LuCp+yz5+TwYPxaG082ToCLKvisXZGS36NOxwjs5c6klwKkgf6DlbBkLqVX5DPHgctuFseMoWzSvGQy7Jds/4YqKji+nqA3Yx9R/V4xr1MY0ELJ2Addv+il9A9Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A4E8fdJA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A4E8fdJA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743152688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fAjO5a37BNMOhRbA/22/2GhJ437ottI2RizwezpZEfk=;
	b=A4E8fdJAxUAFJh1++3IMxh0CdEeoLu9IWB5mdvnXOMpBRTrRP7suk3QndIezGBq3QfTfyw
	mp71rOpTuQAozI58gezCuxcbvLqlKUVcFYngExo1CLYntDz75OD6Mcp+otclxAWbesr9n/
	Omlznl9j0Tt8MFhA5lsQBKCK5dzKD7s=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-j1RRZo2xOvi_t7kti3eH_g-1; Fri, 28 Mar 2025 05:04:46 -0400
X-MC-Unique: j1RRZo2xOvi_t7kti3eH_g-1
X-Mimecast-MFC-AGG-ID: j1RRZo2xOvi_t7kti3eH_g_1743152685
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5495851a7a9so999231e87.3
        for <linux-unionfs@vger.kernel.org>; Fri, 28 Mar 2025 02:04:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743152685; x=1743757485;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fAjO5a37BNMOhRbA/22/2GhJ437ottI2RizwezpZEfk=;
        b=Yjt1ljk1wKAL0ddVs8V0mC+4NtDdENfx4R6qZ5CUX35hi01WNVEeaLKbTDgwvOaql1
         h0TEk/fZTB72RVMONMLf6+6ciRT43rg5sW+43Q5mNuclIvjnx9zq8n2z5Kxrk2Umenop
         QwMJZScGvmtyED9lBLu3//+58qZTjmnoIViYQCBFP/f6Tl+e9NzTNAH72JoAvHdN+c0M
         0J3/rIufuT2zn6AwL/CgFD6h/x3Jmdy0TxrClIw+zAiiEppvQK9nF3x/spH/DZLqMIOl
         SXJ7aFZIxXA5JpmbUkCT4jJBXfPMAq1iUoc5189p4m3DSlBUtgBy4b/NEceASULDrZ89
         Yk1w==
X-Forwarded-Encrypted: i=1; AJvYcCUdcjc6qlFhDLVYlTGRKgMX8pyaUip0uT/F75V7X2FNaX3AefbiCmfmDPAjnFg4PvMZvlcSk1uVveF26BOW@vger.kernel.org
X-Gm-Message-State: AOJu0Yyw3XE2/QGL1zDMMeGCiptivOS1pmbpnvoxyCd7jljt5Isu+wso
	GvcaJnsnxTJ/a4bVEakJS3vZbTsggkBxH3LbPoCpWd8W4+qlY0a+o0+oFIwtXSZJ4jrtaHSfOFL
	AGJ5LBGU2MElYPLrz/BsGf7l8foVqSyHmu5N+Xj8sWM2KT73lnimULUStgtcAI6g=
X-Gm-Gg: ASbGncvBDj3Cea4H+SpjvbmooZgt51bi0R3vlfHgcQIaFLOJTGk0uRvWjQq8Z7mPILQ
	o0eZp+9dfUYfhFLcIpCW7eNFq34ij2xof72N2bFKlSlHyM4uoJtpmmExziw6ZtpykmhbciUvLkL
	EFMAFLkPyM59DM8BlBaV4NTAitlxdbVVBZ9RcSTpjtGX3st+FDg5n0M6LYSm881F1RcMeRaupRg
	2fEqSO+NG0H/PxSl0pt4jhnRPJOjS6ob2KrdrrwTzbJk5hBbvjYYA9dqypGBWdRsq2jZ3QO7AFD
	yALI27187rBa6uiQXQu1REbwXPhwRT8gY4mgJfJdxBDcJKjAGQ3EGwo=
X-Received: by 2002:a05:6512:3da9:b0:545:6cf:6f3e with SMTP id 2adb3069b0e04-54b01265141mr3026019e87.49.1743152684917;
        Fri, 28 Mar 2025 02:04:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHezFgBQEAMOmDdy8UHLCNmIqvSSOOti8SfWyDewjH6ZMZdYx33W7942mcr+lgURUg3KmybAg==
X-Received: by 2002:a05:6512:3da9:b0:545:6cf:6f3e with SMTP id 2adb3069b0e04-54b01265141mr3026002e87.49.1743152684400;
        Fri, 28 Mar 2025 02:04:44 -0700 (PDT)
Received: from [192.168.68.107] (c-85-226-167-233.bbcust.telenor.se. [85.226.167.233])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54b09591a01sm228635e87.164.2025.03.28.02.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 02:04:42 -0700 (PDT)
Message-ID: <a206a3113e834a40740f12e078d1301cb9fc22dc.camel@redhat.com>
Subject: Re: [PATCH 3/5] ovl: make redirect/metacopy rejection consistent
From: Alexander Larsson <alexl@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: Giuseppe Scrivano <gscrivan@redhat.com>, Miklos Szeredi
	 <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Date: Fri, 28 Mar 2025 10:04:40 +0100
In-Reply-To: <CAJfpegv44p8MhCWCQ2R93+iUCCrTZbk0KowZxVmsf=0tsbGHLA@mail.gmail.com>
References: <20250210194512.417339-1-mszeredi@redhat.com>
	 <20250210194512.417339-3-mszeredi@redhat.com>
	 <CAOQ4uxiqis6kawuv4pa6jxHYgpQPc18izFP8e0TORfA_mVu_-w@mail.gmail.com>
	 <CAJfpegt=PWs8ZDF11p3nOCWHbWescE5nwVtUt82f=B6B+S0Miw@mail.gmail.com>
	 <CAOQ4uxiQQV_O1MJgTksKycBjJ6Bneqc=CQbUoghvXc=8KEEsMg@mail.gmail.com>
	 <CAJfpegsuN+C4YiA9PAuY3+-BJ959aSAaXTYBwKNCjEnhXVw0pg@mail.gmail.com>
	 <CAOQ4uxjkBQP=x6+2YPYw4pCfaNy0=x48McLCMPJdEJYEb85f-A@mail.gmail.com>
	 <CAJfpegvUdaCeBcPPc_Qe6vK4ELz7NXWCxuDcVHLpbzZJazXsqA@mail.gmail.com>
	 <87a5ahdjrd.fsf@redhat.com>
	 <CAJfpeguv2+bRiatynX2wzJTjWpUYY5AS897-Tc4EBZZXq976qQ@mail.gmail.com>
	 <875xl4etgk.fsf@redhat.com>
	 <CAJfpeguhVYAp5aKeKDXDwip-Z0hc=3W4t=TMLr+-cbEUODf2vA@mail.gmail.com>
	 <CAOQ4uxgenjB-TQ4rT9JH3wk+q6Qb8b4TgoPxA0P3G8R-gVm+WA@mail.gmail.com>
	 <CAJfpegu6mJ2NZr2rkCVexrayUt=wwNSyYv5AE694D04EH2vx2w@mail.gmail.com>
	 <CAOQ4uxjad0hm10F1hMFX8uqZr+kJT-GibFNe9hAv_v971sb97A@mail.gmail.com>
	 <CAJfpegv44p8MhCWCQ2R93+iUCCrTZbk0KowZxVmsf=0tsbGHLA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2025-03-27 at 20:23 +0100, Miklos Szeredi wrote:
> On Thu, 27 Mar 2025 at 18:14, Amir Goldstein <amir73il@gmail.com>
> wrote:
> > origin xattr only checks from upper to uppermost lower layer IIRC,
> > do definitely not all the way to lowerdata inode.
>=20
> Makes sense.
>=20
> > > so as long as the user is unable to change the origin integrity
> > > should
> > > be guaranteed.=C2=A0 IOW, what we need is just to always check origin
> > > on
> > > metacopy regardless of the index option.
> > >=20
> > > But I'm not even sure this is used at all, since the verity code
> > > was
> > > added for the composefs use case, which does not use this path
> > > AFAICS.
> > > Alex, can you clarify?
> >=20
> > I am not sure how composefs lowerdata layer is being deployed,
> > but but I am pretty sure that the composefs erofs layers are
> > designed to be migratable to any fs where the lowerdata repo
> > exists, so I think hard coding the lowerdata inode is undesired.
>=20
> Yeah, I understand the basic composefs architecture, and storing the
> digest in the metadata inode makes perfect sense.
>=20
> What I'm not sure is what is being used outside of that.
>=20
> Anyway, I don't see any issue with the current architecture, just
> trying to understand what this is useful for and possible
> simplifications based on that.
>=20
> For example the copy-up code is apparently unused, and could be
> removed.=C2=A0 OTOH it could be useful for the idmapping case from
> Guiseppe.

I think there are two basic composefs usecases, first a completely
read-only one with a data-only, an erofs lower and nothing more. The
traditional example here is a read-only rootfs. In this case, clearly
digest copy-up is not needed.

The second usecase is when you use composefs for a container image,
similar to use case 1, but on top of that you have the writable upper
layer that is for the running container itself. In this case, you want
to validate all accesses to the lower layer, but allow the container to
make changes. Obviously, once you create a new file, or modify a lower
one there will not be any validation of that file.=C2=A0

However, if you for example change just file ownership, then you may
trigger a meta-copy-up, and at this point it makes sense to also copy
up the digest to the metacopy file, because otherwise accesses to it
would read the datadir file without validating its digest.=C2=A0

Unfortunately this (as you say) weakens the security in the case the
raw upperdir is not trusted, as it would allow the digest xattr to be
changed. But I think this is acceptable, because the alternative
without meta-copy-up is a full copy up, but then you can change the
file data in the upper instead, which is even worse.

As for origin checks, they are really never interesting to any
composefs-style usecase, because those are fundamentally about
transporting images between different systems (with different
filesystems, inodes, etc).


--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
=3D-=3D-=3D
 Alexander Larsson                                            Red Hat,
Inc=20
       alexl@redhat.com            alexander.larsson@gmail.com=20
He's a superhumanly strong coffee-fuelled firefighter who hides his=20
scarred face behind a mask. She's a sarcastic mute opera singer who=20
inherited a spooky stately manor from her late maiden aunt. They fight=20
crime!=20

