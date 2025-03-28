Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E80218823
	for <linux-unionfs@vger.kernel.org>; Fri, 28 Mar 2025 10:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743156523; cv=none; b=E05UF2M1GYn+K34QXW3g+3R0pI8xxKhqyFFCOXuS9D12e2tjBILEc13HpRLGLxObjQQac+J2MM+6bHDpcvkAYZy/62FHzBVqBbedrksDfWQJlSeNFi1LQ8u0O2o/ZOqxQqfjMo/UIqT38z3DpzOjmI1m1lp6J0haLllJV2xvBM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743156523; c=relaxed/simple;
	bh=GY6LNEGp5wD1whntDXHz9uvTBUdWJ/TtAWYJRXfABv8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iAIy4ZiFxSTkP1vrRWxZQ9qSbKtr8/8ISpe4tu3SuF0ya52nNBEnkHifPeILE9+EO4FZRHF6G/AzUcX/kamjOpnwx/MRDrpBPjApqu87fwifPq37JD3pSDZznby9Uk2ESbW8aW0RvUxkoZREhRJViR9zJlwQpn3ZXNtL4t+ueFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y6EILL8T; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y6EILL8T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743156519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uexjHPHaHB6AaQa6ptS/Rgs1NBKyZtH2mQH7ip8uNcs=;
	b=Y6EILL8TJGh/5Wwu3yG0KJpIGZZIaFWyDah+x0YVF5vqiEfsz31IngTCG7Krov+Rm2nvN+
	G9qCgnwsKoABYMDRluCxnZ/vXr+ufW2yMN7VhWuurHrz2UYgI54wsR+NpclKnlCMcTRZrn
	9tbOdfvKLX8bg47rN/wxG/lWcylSIaw=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-SP1uAT3zPZiiebTi7RdZlg-1; Fri, 28 Mar 2025 06:08:38 -0400
X-MC-Unique: SP1uAT3zPZiiebTi7RdZlg-1
X-Mimecast-MFC-AGG-ID: SP1uAT3zPZiiebTi7RdZlg_1743156517
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-30bfaec88edso13497191fa.1
        for <linux-unionfs@vger.kernel.org>; Fri, 28 Mar 2025 03:08:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743156517; x=1743761317;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uexjHPHaHB6AaQa6ptS/Rgs1NBKyZtH2mQH7ip8uNcs=;
        b=S/a0OjNv7zP/vHAMapCg7lQ/h1NGX+fdVUciJpsNnTXxHF/ya1ZJv8PWLEXh2zgMR4
         gzj1w3rvU4VfWWSdg/ob6kTlhyZyTwgEWmDmHQpdCyQKBA/3h4B4/yGA4EGsq9LVw9hI
         NwfBPdKaeaqFFtapStrrCXCDPzbHfavWDn5HVynH4ouVsRD/cMk9WRF+9N20+hTCm+wy
         +4uCuWRfivxODSp8Xhu+bdgYmSm0sJKsHUeq2bfTrJc99muY4IjS3GRMRCNIgnpXjLcO
         6N0vM2m/9KgagqtOtvnYMQHuK0w26gCwha3exJRNjTFLGW467BkOERvDNsu+Mm7tRutr
         Z2QA==
X-Forwarded-Encrypted: i=1; AJvYcCXwmknWJBjWz5m6Px4PnFQhPUYMICygm2S8Jokkf2q7d50KrGF1tx78/pi34REEPn5cb1jJcOZOSE7XnH1U@vger.kernel.org
X-Gm-Message-State: AOJu0YxC8k0WvSYbL6i3HU99NbLXhzPZ8Croog4vZwAKmzvX0IOSHdLb
	E8P6zl4a1rm0hYMJx4xBlja+a3+lwOpU5zq/P8daqfV4SSjUm6U+oI8fU8ixwdXWK/qv0PMhQHA
	gT4DNeeKCCe3Ms0wEcd2e8FJmONKjhvkpM04MhI7ro4S3Pi+fZULN++lbL7oql1s=
X-Gm-Gg: ASbGncv1Ch9ltuc4SKsP47q7WZKi2SAx0JCGoq7sDHhwFzqf4e1991hHpxKqxS/2nih
	wkwbV+YPPf3wEgMDbbqWnwLTICCHGiIynsULQHP2CuykKTUxNaeagbRukKgfHTUN+MiNJ7NvYBU
	JKKSirQLswkzsseMOqscgfTLOLlB8mt5WGP6zIx1NhkGjUp1/sDfdZrf5o2MqZDckscqK8KKZyE
	pEfjunty8aJKqEdfP9fm+D6yowFwRErwWMuTTDxNIhb8XnSblphpSXw2TrVCLOoESKDtoVyBD4T
	TvwoZHZDK5CyR8Ez17SmyWunBO+ZnxJHWm68CEWI0wT8iDIoSrTPMHU=
X-Received: by 2002:a2e:be27:0:b0:30d:c4c3:eafa with SMTP id 38308e7fff4ca-30dd439309fmr7972501fa.7.1743156517027;
        Fri, 28 Mar 2025 03:08:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKN7MpSkYfaqsK+bopt1EUqDawYJWOWT1t2Mj7wA9dhUaXFx/N4035wBULqQpXCsHogYYIjw==
X-Received: by 2002:a2e:be27:0:b0:30d:c4c3:eafa with SMTP id 38308e7fff4ca-30dd439309fmr7972351fa.7.1743156516610;
        Fri, 28 Mar 2025 03:08:36 -0700 (PDT)
Received: from [192.168.68.107] (c-85-226-167-233.bbcust.telenor.se. [85.226.167.233])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-30dd2acf881sm3054901fa.51.2025.03.28.03.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 03:08:36 -0700 (PDT)
Message-ID: <3b87c2ef6b50c40dae62dbd062ca542308767cb1.camel@redhat.com>
Subject: Re: [PATCH v2 5/5] ovl: don't require "metacopy=on" for "verity"
From: Alexander Larsson <alexl@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Giuseppe Scrivano <gscrivan@redhat.com>
Date: Fri, 28 Mar 2025 11:08:33 +0100
In-Reply-To: <CAJfpegvvRBgYHpuOUuunurwN0Nad+OUdjNOdLw6d1C0kEAg5PQ@mail.gmail.com>
References: <20250325104634.162496-1-mszeredi@redhat.com>
	 <20250325104634.162496-6-mszeredi@redhat.com>
	 <CAOQ4uxgif5FZNqp7NtP+4EqRW1W0xp+zXPFj=DDG3ztxCswv_Q@mail.gmail.com>
	 <CAJfpegvvRBgYHpuOUuunurwN0Nad+OUdjNOdLw6d1C0kEAg5PQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-03-26 at 11:24 +0100, Miklos Szeredi wrote:
> On Tue, 25 Mar 2025 at 12:35, Amir Goldstein <amir73il@gmail.com>
> wrote:
>=20
> > > --- a/fs/overlayfs/params.c
> > > +++ b/fs/overlayfs/params.c
> > > @@ -846,8 +846,8 @@ int ovl_fs_params_verify(const struct
> > > ovl_fs_context *ctx,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 config->uuid =3D OVL_UUID_NULL;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> > >=20
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Resolve verity -> metacopy d=
ependency */
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (config->verity_mode && !con=
fig->metacopy) {
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Resolve verity -> metacopy d=
ependency (unless used
> > > with userxattr) */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (config->verity_mode && !con=
fig->metacopy && !config-
> > > >userxattr) {
> >=20
> > This is very un-intuitive to me.
> >=20
> > Why do we need to keep the dependency verity -> metacopy with
> > trusted xattrs?
>=20
> Yeah, now it's clear that metacopy has little to do with the data
> redirect feature that verity was added for.
>=20
> I don't really understand the copy-up logic around verity=3Drequire,
> though.=C2=A0 Why does that not return EIO like open?

If a lowerdir file doesn't have fsverity enabled, there is no struct
fsverity_info, so no digest available to use. This means we cannot make
a verity-enforced redirect to it.=C2=A0

This is not an VERITY_REQUIRE failure, those are when we find a
redirect with a missing digest xattr, but in this case the lower file
is a real data file, not a redirect.

Note: This actually happens in composefs. We don't use redirect for
tiny files (smaller than the redirect xattrs would be), instead we
embed them directly in the EROFS image.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
=3D-=3D-=3D
 Alexander Larsson                                            Red Hat,
Inc=20
       alexl@redhat.com            alexander.larsson@gmail.com=20
He's a lonely Jewish vampire hunter on a search for his missing sister.
She's a man-hating Buddhist socialite trying to make a difference in a=20
man's world. They fight crime!=20

