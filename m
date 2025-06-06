Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6EA28751B;
	Fri,  6 Jun 2025 10:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749207519; cv=none; b=r+PrFU7eOs4JgZRm8avYb4hAa+y3MWXEW/IGoCyWoKk9V5UWafVwF5lXRo/K5R+ahR9LpK5ZClQ1/kLKrLshJuuVoBytzcQzwDQ/qTr9fO66jKMUPuQAGJ4tT72eYzabpCc5gxQKDhfaVTpVnks64FTZnbkBMA5oPgsK4Z0CXms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749207519; c=relaxed/simple;
	bh=Nm857/l/4UIU5StLSYE3JtsXcNbXCVf/EhxDzPr225M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OTOUSTAys9PWSGxRErJclBDWO2bw187XFfQ8AXyD85GkTWPv9tBr+OCQXvvmE7cqzG2OlUPefCce6frNDR4nN5ZcQ4dOrwWYtBUNALd1pXbb9Ue9WUmJMzJS3ZaZidVqREhRaWvI1Td4E1Jfu523MfsqLdI4VpuzGg/iOb3GxVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g2uYOYHe; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g2uYOYHe"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-60780d74c85so651942a12.2;
        Fri, 06 Jun 2025 03:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749207516; x=1749812316; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pp97G/YUdaRNLQUeb4BjSwygsZdYbIgkdZd/4ExypFw=;
        b=g2uYOYHeMez7e+8/llOZgwy1jXdEJ6M43d7ZImHFlPgyNYfnIs08fSOcsqhVk/JUrk
         UrFahw6ldGWD8R7wfNFE+XdaLmvw4X/1/s/oV/2r6Cyg2ENwn0/KkJuoNzhlbr+JZrAC
         0JZu5btUFK8jFQFdcIN2TlsJVcebeEcsArq5Ac31YjsCNB+ExaV86aoOaWkQht6PD3Kq
         wFdYAKBjhUMDb3IE5mrHYC3REF85RujdiwfZUpr3oZMXxN0RoG9GfzJjA0iVAVQAn4C+
         c46biD/Vg66lJPQ4ASsfISsvw+6ekCZaxhdirVEvUcmWyGoByxcKOsG1nA1PJNGHE+n6
         l88w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749207516; x=1749812316;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pp97G/YUdaRNLQUeb4BjSwygsZdYbIgkdZd/4ExypFw=;
        b=FP4j+vIl0+gTXPFbS883FtFROwcb5rGub/84em9rGr/OB0wSxBVHJI0zekQabcS0my
         WL9Qyhhb9BNQXgfRcy8LnNcK4jVkaqMP0md9x+j+vjF4F0pa3AJn2ONfiX7h/WQOPvDW
         troizJsaXWs4DWtlgcF8FdRi5BvYAu0zkvLuK7UC9Rw3fv3lTcOov1IYn996iyu/KnM2
         5G5XKP8Z3e1QPCJddJ0orMhcFvHI6NqwrINOksp2OQQNLMvQAcbZGxhdXFgAxlKQIC+v
         Aa3O02Wsfyq0xlGHwPbkamqMNL5xPPKpPwh+jLozmjX3HOc40I5vo8lNUrOW33EJQr+9
         z+Gg==
X-Forwarded-Encrypted: i=1; AJvYcCV+jNFjFd4uNffaa/NnBigu7oBunw4Zx06IzKqOHrQejJXzYFPl02eKbHCZ3XjeoUI/vbDF7COCBWvYJ5Z7BA==@vger.kernel.org, AJvYcCVG3xN+S7YPYuHBg3qW2LeUUuM3b9KSm7q/YSYvHDbd07dd26wZbZS1VklYeXLNB5YiXl8mC/B5@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3zldaX73I/77yHHB6QqOaAIU5rjmIdJl/Qciar+66o3ko5ahV
	A+MEh6NbYY7UIZaIROH+ETA5DfRfEng78jfebx/qN9VJZOfy9pfupRe0x7C1oVIs8Ivc31iy4rD
	K06SlZ+Y+vqSoqCu3uw3QH2UCtvelG2A=
X-Gm-Gg: ASbGncv9lCRyBXqZQMtiMtkEObzR7vCZQab7UMuKy1Eh4hSTbfIf4igsu3ozWyiaG9y
	haP4En58c+KULAZCgaBMybrKlZMR1XckW4gRsMLBQHCEyXrTDnK3Pu+MjGTE4FhwCjleUYmasf1
	dH6erubYQ1M1A0n3ha1Hy0mDEgx20fv6qoKPcQxt71yq8=
X-Google-Smtp-Source: AGHT+IFKTmqzuCMvQULKCTIaSpKd6wX5fuEeygLCqZDNw8UYvtVzXARMbiCrJYUztU9EJ2eXmmNRf22+tOKGKBI9h84=
X-Received: by 2002:a17:907:94c8:b0:ad8:8a46:f156 with SMTP id
 a640c23a62f3a-ade1a9c825emr261982566b.6.1749207515534; Fri, 06 Jun 2025
 03:58:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250603100745.2022891-1-amir73il@gmail.com> <20250603100745.2022891-2-amir73il@gmail.com>
 <20250605175129.oqqzr5qluxv52m6b@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxg2D-ED3vy=jedEKbpEJvWBLD=QYtfp=DCU3pQGGCaGog@mail.gmail.com>
 <20250606011223.gx6xearyoqae5byp@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxh9b285dnw+SO2h6HqtNC5Xog0TQSqhFAQaV1brBnVxVQ@mail.gmail.com> <20250606103518.c3xklsm2ksjl5w4u@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20250606103518.c3xklsm2ksjl5w4u@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 6 Jun 2025 12:58:24 +0200
X-Gm-Features: AX0GCFu4mlQyFodXBBc4Umc5eqT1NMOvC89FkX36A4BDmNV5wqsnftDdV0nzoYk
Message-ID: <CAOQ4uxi-ZTzatP-iVbWjzYVnv7_JA1F7WjTfjjBUTCmhoWCr-g@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] overlay: workaround libmount failure to remount,ro
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	=?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org, 
	Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 6, 2025 at 12:35=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote=
:
>
> On Fri, Jun 06, 2025 at 09:35:36AM +0200, Amir Goldstein wrote:
> > On Fri, Jun 6, 2025 at 3:12=E2=80=AFAM Zorro Lang <zlang@redhat.com> wr=
ote:
> > >
> > > On Thu, Jun 05, 2025 at 08:30:53PM +0200, Amir Goldstein wrote:
> > > > On Thu, Jun 5, 2025 at 7:51=E2=80=AFPM Zorro Lang <zlang@redhat.com=
> wrote:
> > > > >
> > > > > On Tue, Jun 03, 2025 at 12:07:40PM +0200, Amir Goldstein wrote:
> > > > > > libmount >=3D v1.39 calls several unneeded fsconfig() calls to =
reconfigure
> > > > > > lowerdir/upperdir when user requests only -o remount,ro.
> > > > > >
> > > > > > Those calls fail because overlayfs does not allow making any co=
nfig
> > > > > > changes with new mount api, besides MS_RDONLY.
> > > > > >
> > > > > > We workaround this problem with --options-mode ignore.
> > > > > >
> > > > > > Reported-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> > > > > > Suggested-by: Karel Zak <kzak@redhat.com>
> > > > > > Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-=
1-2350b1493d94@igalia.com/
> > > > > > Link: https://lore.kernel.org/fstests/CAJfpegtJ3SDKmC80B4AfWiC3=
JmtWdW2+78fRZVtsuhe-wSRPvg@mail.gmail.com/
> > > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > > ---
> > > > > >
> > > > > > Changes since v1 [1]:
> > > > > > - Change workaround from LIBMOUNT_FORCE_MOUNT2 to --options-mod=
e=3Dignore
> > > > > >
> > > > > > [1] https://lore.kernel.org/fstests/20250526143500.1520660-1-am=
ir73il@gmail.com/
> > > > >
> > > > > I'm not sure if I understand clearly. Does overlay list are fixin=
g this issue
> > > > > on kernel side, then providing a workaround to fstests to avoid t=
he issue be
> > > > > triggered too?
> > > > >
> > > >
> > > > Noone agreed to fix it on the kernel side.
> > > > At least not yet.
> > >
> > > If so, I have two questions:)
> > > 1) Will overlay fix it on kernel or mount util side?
> >
> > This is not known at this time.
>
> Oh, I thought it's getting fix :-D
>
> >
> > > 2) Do you plan to keep this workaround until the issue be fixed in on=
e day?
> > >    Then revert this workaround?
> >
> > Maybe, but keep in mind that the workaround is simply
> > telling the library what we want to do.
> >
> > We want to remount overlay ro and nothing else and that is exactly
> > what  "--options-mode ignore" tells the library to do.
> >
> > I could have just as well written a test helper src/remount_rdonly.c
> > and not have to deal with the question of which libmount version
> > the test machine is using.
> >
> > Note that the tests in question are not intended to test the remount,ro
> > functionality itself, they are intended to test the behavior of fs in
> > some scenarios involving a rdonly mount.
> >
> > I do not want to lose important test coverage of these scenarios
> > because of regressions in the kernel/libmount API.
> >
> > We can add a new test that ONLY tests remount,ro and let that
> > test fail on overlayfs to keep us reminded of the real regresion that
> > needs to be fixed, but the "workaround" or as I prefer to call it
> > "using the right tool for the test case" has to stay for those other te=
sts.
>
> OK, I just tried to figure out if "hide this error output on new mount AP=
Is"
> is what overlay list wants. If overlay list (or vfs) acks this patch, and
> will track this issue. I'm good to merge this workaround for testing :)
>

This workaround in v2 was suggested by libmount maintainer
and approved by overlayfs maintainer:

"> So, you do not need LIBMOUNT_FORCE_MOUNT2=3D workaround, use
> "--options-mode ignore" or source and target ;-)

Yeah, that's definitely a better workaround.

I wouldn't call it a fix, since "mount -oremount,ro /overlay" still
doesn't work the way it is supposed to, and the thought of adding code
to the kernel to work around the current libmount behavior makes me go
bleah."

Thanks,
Amir.

[1] https://lore.kernel.org/linux-unionfs/CAJfpegtJ3SDKmC80B4AfWiC3JmtWdW2+=
78fRZVtsuhe-wSRPvg@mail.gmail.com/
