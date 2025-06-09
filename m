Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFAC255E34;
	Mon,  9 Jun 2025 11:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749467572; cv=none; b=Lk066hZs0UzxyBxBTQsFW3dhpG7Xu558six9xMGLY5WwllsNlDI18ZBcZGwVdMl8XrNcAYS+fjZt8eTtKCmdYoCyKkKTC335iVNMLatWWm79XtRgyZjufuYb+Hlc6hLULhZhsK9UJcFpkc/s0ME56vtkyN3LKWT6MJyH+MOQ7n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749467572; c=relaxed/simple;
	bh=c/R64YR5KkEq2G9KBHLx64IWJK0xaFyQ2dIndHkAAl8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PF4R91C7ofqCTW66A/vc3skvZM5D/NKDgmCC/YKHTsYfiC83eMzvYeMRLOJqjkNdZ+S6q1krs5W/ce4QoHJNZNsOeSbnO9HhdDb+g8aGY+NzmaW+55ON9jUmqGY//wvZZFWoJdELs2AxTXoWFZe2+pcadvTCsPFGL3X22bCx3G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CaXFj0LG; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CaXFj0LG"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5fff52493e0so5267593a12.3;
        Mon, 09 Jun 2025 04:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749467568; x=1750072368; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6hSA5ZW18w6HEwavVOqeWjfK4/0omgpDcw5PWst4SNQ=;
        b=CaXFj0LGNtI/9ZtWzhJMBUBJxjejAwN3QfGpObsMZVQrW0aJMFwew6JkyIApe1gnB/
         ofhO8aYxlukZSjiJg3yJY+Fqi5S+Aj72GTWdYN/mTjZQUkQAz3imHxCUCWd9T9y/k8Pn
         pEQgvZrKb/5N6qBEhVQaGHh830p6LxntWvElmg+nz9qKdapiSYyvouIO9tQsbPLmWQQo
         BAMDbM1x/Xomx2Uc1ipYEbCrLTV+268WINI5lLy8QrZma4CKrYfBqttRGko2rcm+ZXiN
         cU/6Ccu8xHMG9uhQv3bV4vzaVHt7Zh7sYdvKggIkF7mfuTb7eRSeCSenfq2DyKBnf+xa
         X6Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749467568; x=1750072368;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6hSA5ZW18w6HEwavVOqeWjfK4/0omgpDcw5PWst4SNQ=;
        b=eestNspfdyhhW57rqFEVW/96NqHLtiZaWCppsboWZE3W1/KQAXXK5PoO0M2CAad8Uo
         AkI3i/ZzNwie2D3qXGHdZV5mwt63rrgoPc700dUJxIJsyZqBLuQ5uCZZaONpkZWdwYuF
         OL/lhDQ2r5U80tZ+ULmdArexe5HAjTN6owe5OIbAkvaJX+c/AFeVLw5SQENy0gPR66vo
         uhc+/44uvYfTDvegEJu0FZ/mG22n0iWsr+v4mWBfi36ht1XbK+otXScJxsv1FnsICZIA
         e75uvPGJSoXvW+AYCJruBEeIsO1+BMOi/e53olFE0NXSL2dTz1CiiDDF/4+C9YJvSwR5
         n6/g==
X-Forwarded-Encrypted: i=1; AJvYcCUWSfxbf+DcigAfrG88C9/SnCoB2K1mjqkC+0+7C+h6j+zmni2xwIHFxUgQlSoRIkZ9fpvSYkJO@vger.kernel.org, AJvYcCVrHX9UnZuj3FBOFQXzw3HdwMYurWa8xtA8LjI6xVxP6fEJN4cY0DyTYx+wdaB5UH35BpFL6QZ5SXsTIJt9XA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzGGUvVhQduZlEQWLCUE14fqyWwEs93b4ae/apjkW0gZBZiIJXY
	MMQCqnjq9Rs3Thgnzpon08rrUzoVNImHYsdOVh4hUO92UIft1qeMXzAzh+LTH6a70wIG3hRZLMW
	9nVtDt87LSl9kwvyRWPyiXJCakdQLKhX7jSRs1xw=
X-Gm-Gg: ASbGnct+2R1Jx6HyBMmPK/IRJ4BEk6Na2EMIzjAOyzO4uHZU9SUVbsiufEl2gOVYWDN
	WTxLvndKmk9Hq0u/yt3j2BaAuzfJve5MM2zcOwqHM+a25AlkkWxzZbGjVJgO76DO5byPf0iLBxt
	BjmuZkt50UE5xUXsZFsHGgs/va+5sfm96lROZRg0HBvhY=
X-Google-Smtp-Source: AGHT+IFb1YxC4G+g+Sje1J1l+rrVaKYyvP+QToGnlOuQ+xaZ4k3PbrDaQe//H9ZSXdwqCyDcXV0ZgmYhWZ9g/PvIpx0=
X-Received: by 2002:a17:906:1707:b0:ade:31bf:6119 with SMTP id
 a640c23a62f3a-ade31bf641fmr744225066b.12.1749467568201; Mon, 09 Jun 2025
 04:12:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250603100745.2022891-1-amir73il@gmail.com> <20250603100745.2022891-5-amir73il@gmail.com>
 <20250605173233.ndqsjo77ds3e35p5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxgQi6ciXtoKV7Nrw5_ECBOwS_m8h2KXT-ieJ4x4t04qag@mail.gmail.com>
 <20250606014531.d5t4gwx4iymqiqlo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxj_rshiLUUrCVS6RO+KhCeLrrgxNH+me3K38Nhc0Byqzw@mail.gmail.com>
 <20250606102909.77jj6txkqii7erpn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxhwi9qF-j_XiTQCCy-OH77X2SG6_CGngUqUFfXz1X-SuA@mail.gmail.com>
 <20250608131616.xf4dx2zwcwbapya3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxgKmgUroEQfXHz9estFxVqSDbLbYZu3Y7WGWVX_kJ9sBw@mail.gmail.com>
In-Reply-To: <CAOQ4uxgKmgUroEQfXHz9estFxVqSDbLbYZu3Y7WGWVX_kJ9sBw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 9 Jun 2025 13:12:35 +0200
X-Gm-Features: AX0GCFuQI7VEPkLKC-sQgkF9tp2Yz48R8zs0ys3B8bNQfd1LHleRZ0QME5ZFjSw
Message-ID: <CAOQ4uxg7ZCh3woWKKGbr6_Ff1xF3Hk5SznQ-hgPDGvfJ5LLy_A@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] generic/623: do not run with overlayfs
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	=?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> > Actually I'm wondering if we should help xfstests to support BASE_FSTYP and FSTYP
> > for more upper layer fs, likes nfs, cifs, and so on.
>
> I think that could be very useful, but will require cifs/nfs to implement
> more complicated _mount/umount/remount helpers like overlay.
>
> > If so, overlay will not be
> > the only one fs who uses BASE_FSTYP and BASE_SCRATCH_DEV things, then we need to
> > differentiate if a feature (e.g. shutdown) is needed by upper layer fs or underlying
> > fs in a case.
> >
>
> First of all, terminology. Many get this wrong.
> In overlayfs, the "upper" and "lower" refer to the different underlying layers.
> In fstests BASE_SCRATCH_DEV is always the same for both OVL_UPPER and
> OVL_LOWER layers.
>
> Referring to the BASE_SCRATCH_DEV as "underlying" or "base" fs is
> unambiguous in all cases of overlay/nfs/cifs.
>
> I do not have a good terminology to offer for referring to the "fs under test"
> be it overlay/cifs/nfs. You are welcome to offer your suggestions.
>

Sorry, I forgot to answer the question.

So far, with overlayfs there was no need for anything other than
_require_scratch_shutdown and _scratch_shutdown and
_scratch_remount for generic tests that do shutdown and remount
to test consistency after a crash.

overlay tests that are aware of the underlying layers and perform
operations explicitly on underlying layers are not generic tests
they are overlay/* tests, so the generic helpers are not for them.

Bottom line is that I do not think that _require_scratch_shutdown
should refer to fs under test or base fs, until I see a generic
test case that suggests otherwise.

What we could do is a re-factoring:

_require_shutdown()
{
        local dev=$1
        local mnt=$2
...
}

_require_scratch_shutdown()
{
        _require_shutdown $SCRATCH_DEV $SCRATCH_MNT
}

Then overlay,cifs,nfs/* tests can call _require_shutdown on base fs
if they want to, but first, let's see a test case that needs it.

Thanks,
Amir.
