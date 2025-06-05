Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899C127A103;
	Thu,  5 Jun 2025 18:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749148415; cv=none; b=faGT+QVcezZpYI0+IGY9B16cnQEsCHnNCpPP0h90tT+W7D7Q2Rv83P5rKWTIiEOZuatehs3etdjXO3DwuP7EN5H/Wfl2+VqDOFA7rRoX6zOgjAhie405hJyJHG2GJGgon3KQMBxv0Ktb+F6ohl5OZpYqv4t3G15KPQCDTX32OKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749148415; c=relaxed/simple;
	bh=0pSo8bNqKcTLH+1lIsLB6uBW1flI7vqJLtyqwXC61aM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rye+h6qfMozllWnwCShCczP/XPk2hTpaEkyr2fDZW93Vxe4IUmWo3Qdq3IAMq1Dt6Z+/eyuFkPsRlBXJkXgBJyl2otA6nqgbvNjRRb5H5LN1q7NBBG1/3scXXJ/y2vgY4LKLcunlcUgzJ4TbYojzESs4SZDBZ4jMebCzn/6V2yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g12CvTen; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g12CvTen"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ad88d77314bso255746266b.1;
        Thu, 05 Jun 2025 11:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749148412; x=1749753212; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0pSo8bNqKcTLH+1lIsLB6uBW1flI7vqJLtyqwXC61aM=;
        b=g12CvTend9/G8s6XUsF9CtGUflczSYnmh7scQSe6FPMGNmWJNlfOrA7P9z8ki5JV7R
         uMNi70IRIMDWECw+3x7hZRrYPJnfVx9kIUdy0Z5g4ENgY5F9vsUAV5jYdbXCQkCnag30
         Gt9LjSZgtvuWhm7rrgSD52SnpDaOdphyDZp4d65gPAD5SUqdhblPeZazGZVNE9j8Uzbi
         lD4usKB2Tc2BzAGlgXbdImbM4lhEj1YUlq+fXwks3/V9vww6egQaq9DPvJi7KslWeLwt
         SRSUqI18j836UotE/pgEV80+gTSMZ/6saRP5sWcNqPr9sRUacd53CxN88B0w+a5Zl3cl
         UaOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749148412; x=1749753212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0pSo8bNqKcTLH+1lIsLB6uBW1flI7vqJLtyqwXC61aM=;
        b=IKwOnpLqW8sUhwoPJGtPqQT97OFvzm7QkVFT/ULEUkJFXdeCezWmUMghmA7d4iqcpN
         uqtG0hE5YfsPOMxTfl0goc11YUKRUBo3Gd8gaxWWDtTTGahbQL7ZuxC2Fo9Ze4ssfb1F
         Amj9dzW7rGxiQ7KZDpLANgRosKAhoDUX0BxbPS5erj7lfYYRoO3tDXCv+GovUxx12OPA
         cJBE8Q3TGnEzYrnjM1uNRFfN9dQ8K9tbEZi7LRIj0oWFP7I6VtgCd5h9heBQV/Eqa0rG
         Rtz1U/y724Z8md24k4LQmrTON3OzbjNoe7dtQXdP7ZZjoKj0tM3NTpLIqqEY9eyXk7VS
         9/Dg==
X-Forwarded-Encrypted: i=1; AJvYcCU89hdbNB34jDYN/4o7M9PtTpQQSdaF7odN5+KPYU6XluAADi/uB0dk5XFvgwdmZvbwiSs0a8w0QvT2CR2B0A==@vger.kernel.org, AJvYcCXb3oJxs0OBLxTWGCAVrClMDy4d1WhDkCZ2lFM5HUCdmVAEY4CaW1bRh786ZLEzxFMQnSOobPJO@vger.kernel.org
X-Gm-Message-State: AOJu0YwZTqgR9Kj/CUxh4C6onPYWWILmupg6pn5D24apZrf9OdsmdtRD
	4ePPEB/TH0YIVLvlN/d0wXZIArIl/6MGqFpAn+B+NZY86hFpjWkW/v8n5QBlcwFBOKcjYmEiHov
	ep6eRNZ+tZn/vnDY9xh0p2i0VEsWREN8=
X-Gm-Gg: ASbGncvo0e5slWhYOVU15CufnXDejmemk+C5fsJ50Mamvo+o+MO/NztofFXLvmUwvJR
	3wfzs2U6IjyMHRGv/MUdtI2LLxBpypCDmA/EL6R0WyUhHsMmUFmXvWK3L0s7FWBa61cUX0w+ryi
	aYnJb61s1kibMGls4NuMZmcf9Z/EFsgKM/
X-Google-Smtp-Source: AGHT+IEiQt68A/sPXqMx31SxVMSyyT5oVB/9QWxBc8tRKih70OA77O5wZMdhpQE5KyvnO5scTfWl8YoA3s8jfCHQuJ0=
X-Received: by 2002:a17:907:9349:b0:ad5:777d:83d8 with SMTP id
 a640c23a62f3a-ade1a924e0bmr28826466b.29.1749148411410; Thu, 05 Jun 2025
 11:33:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250603100745.2022891-1-amir73il@gmail.com> <20250603100745.2022891-6-amir73il@gmail.com>
 <20250605172401.v7lpervaq6bbxgn2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20250605172401.v7lpervaq6bbxgn2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 5 Jun 2025 20:33:19 +0200
X-Gm-Features: AX0GCFsnLNbcVJWVFfdZSkuAb2jzDGkDXQDdYEUJSL4QrzpN6KSLNny6JqVllIs
Message-ID: <CAOQ4uxgKMo8O4u3s0UkiYBpjgnH8JTToShSueVEzewWTO9gcAw@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] generic: remove incorrect _require_idmapped_mounts checks
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	=?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org, 
	Yang Xu <xuyang2018.jy@fujitsu.com>, Anthony Iliopoulos <ailiop@suse.com>, 
	David Disseldorp <ddiss@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 5, 2025 at 7:24=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote:
>
> On Tue, Jun 03, 2025 at 12:07:44PM +0200, Amir Goldstein wrote:
> > commit f5661920 ("generic: add missed _require_idmapped_mounts check")
> > wrongly adds _require_idmapped_mounts to tests that do not require
> > idmapped mounts support.
> >
> > The added _require_idmapped_mounts in test generic/633 goes against
> > commit d8dee122 ("idmapped-mounts: always run generic vfs tests")
> > that intentionally removed this requirement from the generic tests.
> >
> > The added _require_idmapped_mounts in tests generic/69{6,7} causes
> > those tests not to run with overlayfs, which does not support idmapped
> > mounts. However, those tests are regression tests to kernel commit
> > 1639a49ccdce ("fs: move S_ISGID stripping into the vfs_*() helpers")
> > which is documented as also solving a correction issue with overlayfs,
> > so removing this test converage is very much undesired.
> >
> > Remove the incorrectly added _require_idmapped_mounts checks.
> > Also fix the log in _require_idmapped_mounts to say that
> > "idmapped mounts not support by $FSTYP", which is what the helper
> > checks instead of "vfstests not support by $FSTYP" which is incorrect.
> >
> > Cc: Yang Xu <xuyang2018.jy@fujitsu.com>
> > Cc: Anthony Iliopoulos <ailiop@suse.com>
> > Cc: David Disseldorp <ddiss@suse.de>
> > Fixes: commit f5661920 ("generic: add missed _require_idmapped_mounts c=
heck")
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
>
> Is this one changed anything from this ?
> https://lore.kernel.org/fstests/20250526175437.1528310-1-amir73il@gmail.c=
om/

There is no change. I just forgot to add the RVB.

>
> Due to above link has been reviewed by Christian Brauner, do you want to
> add his RVB to this version?
>

Yes please.

Thanks,
Amir.
