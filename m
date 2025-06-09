Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D1221B9FD;
	Mon,  9 Jun 2025 17:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749491034; cv=none; b=OgM4sk7JN6pvvC5CtUQ1jbUaS+TEhx6ke8vALW3wF7LipS3BLJzn0c+1xBAlqmGdTFcPwj1hWoPsPBK5rcixTJSmOFvSs3ke5ryu1IenGruwhBzcqZvgVIsYDTsnLQDcXiy8s35TE/nlAkefKVOL/iq9KYQxbGFqoLxOo4Ak01E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749491034; c=relaxed/simple;
	bh=mBzZOKOpSzmIYT75/UrpabNH6PlDnpyTPmsc89hfAI4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZHsFAkmnNSWkCWVHMT4VvBb9kfC+zzRJC4T/RU4jDZzGC3yg42t+spC6TRyytmOy8WgC5P1vsjpfQkCv68lwec96grc2d+YPt+nAcD8RIKOJgUvnN1DzzIPcOHakMkrlrg0wSvnyMOpMTxBKLOch6S00XNoKlIZ9GKzaEbEnIkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bTDUyUtb; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bTDUyUtb"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5efe8d9ebdfso8174869a12.3;
        Mon, 09 Jun 2025 10:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749491031; x=1750095831; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jpX7cfYg3WD2wUC3pyKVFxmByKXB5FcCg2aKUj8rz4k=;
        b=bTDUyUtbSfzerxRocD+F6kTDkpKlru9/WNdqSeF9DIfRoolzsy6EKkrYRcKk5MLpKI
         9dAvcnnhTgUPOHq4NcVhbKT6TxcPk+OMgNYVHMqqAGHJR3b/WDjrQTxpBAMYvhBYrKjx
         cZRQjgKjMPBExNYSDQlwCAQfRCUeA2rf+bWFJ1QSjIAGSE68i7fuLp+9/ezWP55QOvuL
         SOyBZ9tSSom7/0Qb7UFoD85BP23fIv2znuY+OCOWhPsy5Nw0ZkiZ15CNsl3PkTDUr0ZX
         JJh6wxt8jDHMqb/PNtz64bOrhPrbEUEW/CL1wdhk46ng39j0DaXocOEBJSakk2Hx2Orz
         r4Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749491031; x=1750095831;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jpX7cfYg3WD2wUC3pyKVFxmByKXB5FcCg2aKUj8rz4k=;
        b=B+E8X2xcm7dr1HJ2keAc5dPyD7+lBkQ2t+9d2grog2UZ9aLoYaa3Vt7HDx7qW/9ZCA
         GOlZRrip3UqHYgGfVhaImH3kHsmUp1AoJO19l/+hlG6kD5U01H2h1bccdj5Cgj2Jyhnq
         zZJDVLS6JwGEZ4LdEv5mYexSVzBq40YwBBxUo1JDpp8r4cQ1OkC/WuOywHs7J5gB91J/
         PJI8sATeJ4G1Y5O3parkWW95m+QY/n/j/HVf8GU0IrFn3dUzKA6JXa3wUwmxb4LxaqyU
         ESExQc4XOr7SH3/jMskJtZm+XQcfhgB/VyOXmAss1UKqiVSYWVh/SxnoAB0Qce+WZCAB
         gs6A==
X-Forwarded-Encrypted: i=1; AJvYcCWAhVMbm5xeRpQb5ynzbjnfQMbiuZIqn4t8OLusVqtArJuWcLn1JFFIeMzG7aoQJG1ADh3cOTeLbWjeD2UYTw==@vger.kernel.org, AJvYcCWaeNVU9zMXEcjxQsFcwCR6dyXKo4qX8voC0FERakvY1pcl3Ha1HFWpFPapOiNbGfQXG6UDBq71@vger.kernel.org
X-Gm-Message-State: AOJu0YycAilwy7B+pAjfbQxtNDO+Vw7QPV5LxfcJhCs8bKSIrTOlaw8J
	66HR0t0zwTDnb19pPByHEMhesaCKcLA3MqzkdRAd3q61/X91ZAO3k0maUoi38OV1PsgNGzfbieH
	LGL6PEixgvumfLmLX4h+voR88Le2fPRU=
X-Gm-Gg: ASbGncuW7XQKAVs0/F/knwltYeSTO9q2CJEwWee+6F+98UsZrUVilZXbzFQKVzcJ5LK
	hoiWTOSzOUuT+/YZg3R2EybAfUdlP+aRWq1OmdAzV7RaJgjggVsUBrrP+ALfwXWzS1b+kXrg12p
	uvAaoABppc6ATj2CZhi+2PnvCngAd9XYkYE6j4p9MBv4eqsqJz5Q/4Vw==
X-Google-Smtp-Source: AGHT+IEnF/XihdgQOQBn2vNg9hqk1HpIOLkf4/DNffuV67rGZZHTx4el18C6XX/kqAhPUIvms0YsBysJjt84vcptH70=
X-Received: by 2002:a17:907:3c8d:b0:ad8:adbc:bbf6 with SMTP id
 a640c23a62f3a-ade1ab32c07mr1381858366b.58.1749491030983; Mon, 09 Jun 2025
 10:43:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250603100745.2022891-5-amir73il@gmail.com> <20250605173233.ndqsjo77ds3e35p5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxgQi6ciXtoKV7Nrw5_ECBOwS_m8h2KXT-ieJ4x4t04qag@mail.gmail.com>
 <20250606014531.d5t4gwx4iymqiqlo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxj_rshiLUUrCVS6RO+KhCeLrrgxNH+me3K38Nhc0Byqzw@mail.gmail.com>
 <20250606102909.77jj6txkqii7erpn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxhwi9qF-j_XiTQCCy-OH77X2SG6_CGngUqUFfXz1X-SuA@mail.gmail.com>
 <20250608131616.xf4dx2zwcwbapya3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxgKmgUroEQfXHz9estFxVqSDbLbYZu3Y7WGWVX_kJ9sBw@mail.gmail.com>
 <CAOQ4uxg7ZCh3woWKKGbr6_Ff1xF3Hk5SznQ-hgPDGvfJ5LLy_A@mail.gmail.com> <20250609172617.4ucu7khc56cgud2d@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20250609172617.4ucu7khc56cgud2d@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 9 Jun 2025 19:43:39 +0200
X-Gm-Features: AX0GCFshNZs0LoNos9hSWuw9Bhcv_kUHyKYC4fmpNb-LhhfM__usyTkQxNwNgf8
Message-ID: <CAOQ4uxjwYCtW58Q=iApT-_bZe=qOWuJwEPQKBKK9EdnLg-sRKw@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] generic/623: do not run with overlayfs
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	=?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 9, 2025 at 7:26=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote:
>
> On Mon, Jun 09, 2025 at 01:12:35PM +0200, Amir Goldstein wrote:
> > > > Actually I'm wondering if we should help xfstests to support BASE_F=
STYP and FSTYP
> > > > for more upper layer fs, likes nfs, cifs, and so on.
> > >
> > > I think that could be very useful, but will require cifs/nfs to imple=
ment
> > > more complicated _mount/umount/remount helpers like overlay.
> > >
> > > > If so, overlay will not be
> > > > the only one fs who uses BASE_FSTYP and BASE_SCRATCH_DEV things, th=
en we need to
> > > > differentiate if a feature (e.g. shutdown) is needed by upper layer=
 fs or underlying
> > > > fs in a case.
> > > >
> > >
> > > First of all, terminology. Many get this wrong.
> > > In overlayfs, the "upper" and "lower" refer to the different underlyi=
ng layers.
> > > In fstests BASE_SCRATCH_DEV is always the same for both OVL_UPPER and
> > > OVL_LOWER layers.
> > >
> > > Referring to the BASE_SCRATCH_DEV as "underlying" or "base" fs is
> > > unambiguous in all cases of overlay/nfs/cifs.
> > >
> > > I do not have a good terminology to offer for referring to the "fs un=
der test"
> > > be it overlay/cifs/nfs. You are welcome to offer your suggestions.
> > >
> >
> > Sorry, I forgot to answer the question.
> >
> > So far, with overlayfs there was no need for anything other than
> > _require_scratch_shutdown and _scratch_shutdown and
> > _scratch_remount for generic tests that do shutdown and remount
> > to test consistency after a crash.
> >
> > overlay tests that are aware of the underlying layers and perform
> > operations explicitly on underlying layers are not generic tests
> > they are overlay/* tests, so the generic helpers are not for them.
> >
> > Bottom line is that I do not think that _require_scratch_shutdown
> > should refer to fs under test or base fs, until I see a generic
> > test case that suggests otherwise.
> >
> > What we could do is a re-factoring:
> >
> > _require_shutdown()
> > {
> >         local dev=3D$1
> >         local mnt=3D$2
> > ...
> > }
> >
> > _require_scratch_shutdown()
> > {
> >         _require_shutdown $SCRATCH_DEV $SCRATCH_MNT
> > }
> >
> > Then overlay,cifs,nfs/* tests can call _require_shutdown on base fs
> > if they want to, but first, let's see a test case that needs it.
>
> Actually I thought about the _require_shutdown when I reviewed this
> patch. Something likes:
>
> g/623: _require_shutdown $SCRATCH_MNT ...
> o/087: _require_shutdown $BASE_SCRATCH_MNT ...
>
> But I dropped this idea for two reasons:
> 1) _require_shutdown needs to do real "shutdown" on a directory, a flexib=
le
>    argument to be "shutdown" is dangerous. If someone would like to check
>    "shutdown" is supported on a $mnt, but if some exceptions cause the $m=
nt
>    isn't mounted the expected fs, then the "/" might be down.
> 2) shutdown checking need to shutdown the $mnt and remount it. It's not
>    only about $mnt and $dev, but also about mount options. _require_scrat=
ch_shutdown
>    can use _scratch_mount, but how to deal with a flexible $mnt?
>
> The 1) problem might can be fixed by checking the $mnt is a mountpoint, o=
r return.
> The 2) problem is difficult to me, except we let _require_shutdown accept=
 the mount
> options list as the 3rd argument. I think that looks ugly for a _require_=
 function :)
>

I don't like it either

> If you have good idea, it can replace this patch 4/6 :)
>

Already sent a replacement patch per our earlier discussion
https://lore.kernel.org/fstests/20250609151915.2638057-3-amir73il@gmail.com=
/

Thanks,
Amir.
