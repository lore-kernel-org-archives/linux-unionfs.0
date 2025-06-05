Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F6A27603F;
	Thu,  5 Jun 2025 17:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749143355; cv=none; b=rcbd26rCWLvJ0vcD/j3Woua07jwBWzyGhcqBWRCRyUp8viVJtHTwor6MpIAcKeVPxqs7+Sy2XOAfY4zRU01nxppKzhlHlf9oBMoCxMbsiySxl48qi2J6kAMdKb9Qt45rYM4UBGrD4wpOV+ai3MHgr9bbe8vrVcMVQHWonmbVuN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749143355; c=relaxed/simple;
	bh=GLV2tOOxqglWSJvSK1xh0znF3fY/hvr8eWDI89/4hB4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UeOPA1T5AbKBTJwPkjbRaf5p3o7BziIJlNtiSdMbtwMJTKTVkuc+/0eXheut6cspK+bEDjBmCC5ylzP44ckgNK3yMFhYY/3RoElMNSiIYf7VFtS5yUN1Qr2c6L0oIh4dswWhbpwMrcVQQgn36mxC/zyVkF2syEFG2+0/vAGnimk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FNdjmgGV; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FNdjmgGV"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-addcea380eeso186957366b.0;
        Thu, 05 Jun 2025 10:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749143349; x=1749748149; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GLV2tOOxqglWSJvSK1xh0znF3fY/hvr8eWDI89/4hB4=;
        b=FNdjmgGVxPZWormoNHxx49hv78AByY5byH4twwJCudkQrAPumzWbhUwG/Ln8+n16ev
         yTxuz+oBiQT0+rXWiK8zlvTnceeSBndBVIhgrZz+qYlp5p09VDGZeVmAKhKmA4dHcT0o
         8xuCjgXdvTRzHETzC4bDRFCwq43Qsjeg/A2hCtgSmEg3jo26MbrcKm34Lckz3cXQ+kFu
         LvTNaMLPJntZ/as7NUbNoCgvs45qVvti8ARaIQmc+oWVRFv8RbpypJ3GcEvc+vo//Oa8
         1i9vzuHW0QFPFOObln9ROkQAAhD669vobLnmsumoXRxwvdZjFwbj8JX5gU7CrPjdShvC
         2xdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749143349; x=1749748149;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GLV2tOOxqglWSJvSK1xh0znF3fY/hvr8eWDI89/4hB4=;
        b=T+xWuhocVPJFhYUP8RspV9ocl1O7ZN5XezoeNIDaMgrg4zUz1Zd8H3XDqTKlrY1q7x
         ARiBW8hy6Fh2/wIq94wjZqGb95GOiG8D/osE3r1eDiNyOhAXS/la1h0dJ66tfMSw5i3y
         0kVJnsQw1opxEyCwcY084d8Um1JJhRfstaW52xSzUP40oqZ3qaPxr7rbRHcEH3C7rfW3
         Vg6xciOn26SmbEbK493hdJnxS2Zvlzz4K8bZpIdLigTK76pBC/0TqTbVlSeWIBr246xN
         DwITpPZ7/uUFjbYlz9Gn+Z/jQQjePFQ2Bp5iOP/e8zgDUaVQhWLsuCjO4sA6hjZl+NmO
         198A==
X-Forwarded-Encrypted: i=1; AJvYcCVBZ+n3ZuO3eNiSA8Py2qkl6olhJ2zoeiD5+fN7Fj4TpPfC5O9Ub8BZqJGQ1P0/MpPm8gVr6JKf@vger.kernel.org, AJvYcCVsvJDT6KnjVaEMGBztxsvhXhJcZtZXZUsFYaG/raxq/VjpfridcUDAf/ML01BD6PHAbdm7SNvzAO1mLkTqHg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyc+kdXehYbOsWV0IKOQmCGqKbFRZpyS32pmGzTBVndKIna7JqS
	fWjDA5t6GC1z7BC7lGfOXFjNYfugJ1JpO+dDK6tG3pJfqmEvowV7Xa2bhpWiLj/jyTGSk5SO2JJ
	UcYV30+gqWaUgDv7VzWQiDp9gXOfKSEg=
X-Gm-Gg: ASbGncsSyNYEpbx/rNWmT/QMVoLNYeQENT3IcVFkURDvVzQnMagLMav3qSkxpnbcv8F
	S0YN+Ekq8aUQJM5uVi4HZewu2K8s908GmRXVHHifuvYXr6HbbYBmjKNZGhgPzpfXodzMEOy8Fp4
	cYOmi+fkuwxdz63FFQLpSa0ORhbGrpM8mv
X-Google-Smtp-Source: AGHT+IG6bGcf3YQXdGQ7nFcL0XQ5etG4x+15bbGTAPZnIO5w11KIhSUc5oys6z3PX0/JMY+bTLKyGGH1XYgx34miNxU=
X-Received: by 2002:a17:907:1c0a:b0:ad8:97d8:a52e with SMTP id
 a640c23a62f3a-addf8fd07f7mr775542666b.55.1749143349150; Thu, 05 Jun 2025
 10:09:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250526081852.1505232-1-amir73il@gmail.com> <20250605170018.j5ocx6n3rujob2h5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20250605170018.j5ocx6n3rujob2h5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 5 Jun 2025 19:08:57 +0200
X-Gm-Features: AX0GCFuUHGW4bQ6ELGJYcYBYSNRvLW2Cahi53GTHx9eQK8oTNQwCWzEFX65L5gM
Message-ID: <CAOQ4uxgArinXr6Q2F=XTcN-mXHHUmPSkg+u__ojLU=CGUcgktw@mail.gmail.com>
Subject: Re: [PATCH] overlay: workaround libmount failure to remount,ro
To: Zorro Lang <zlang@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	fstests@vger.kernel.org, =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
	Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 5, 2025 at 7:00=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote:
>
> On Mon, May 26, 2025 at 10:18:52AM +0200, Amir Goldstein wrote:
> > libmount v1.41 calls several unneeded fsconfig() calls to reconfigure
> > lowerdir/upperdir when user requests only -o remount,ro.
> >
> > Those calls fail because overlayfs does not allow making any config
> > changes with new mount api, besides MS_RDONLY.
> >
> > force mount(8) to use mount(2) to remount ro/rw to workaround
> > this issue, by setting LIBMOUNT_FORCE_MOUNT2=3Dalways.
> >
> > Reported-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> > Cc: Karel Zak <kzak@redhat.com>
> > Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-2350b1=
493d94@igalia.com/
>
> Is my bug report (a year ago) gotten fixed?
> https://lore.kernel.org/linux-fsdevel/20241026180741.cfqm6oqp3frvasfm@del=
l-per750-06-vm-08.rhts.eng.pek2.redhat.com/
>

Please see v2 (this is v1):
https://lore.kernel.org/fstests/20250603100745.2022891-2-amir73il@gmail.com=
/
The suggested workaround is exactly the same as suggested one year ago

> If this kernel fix works, do we still need this workaround?
>

Which kernel fix?
There was no agreement on a kernel fix (yet).

Thanks,
Amir.
