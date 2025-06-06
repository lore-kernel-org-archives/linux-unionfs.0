Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73D97FD;
	Fri,  6 Jun 2025 07:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749195351; cv=none; b=jGPYgASgtXjvEg8HZ4ryFdhZB+yO/xZlOsUKPu+bL4mZ657MaMVerUeGOJiXyKBYXxHtP4gKUrqxPwRILHH8zESbtc2y/PEaCoNehj2T3glb3Sudnkbt7oHkxlO9pJ3HOwjRUl6byQrqWK3TVDXxIKjEJCOoAGLaUu+VLeYEpzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749195351; c=relaxed/simple;
	bh=v9N8q6JVteMfHnV2OA+O1dSqPVkTZrNmhLQGENDC1Io=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=stV+MK2B70Gf6/ZwKw28ADC7xKDj8UaTenv3Eamw9Jasg13aDTBuwKOD5CZtIZs6hZyyi1BLrlvCxrzi6kWiPx+DZe4bXntWjxEZEGs0+aXPVSg183Pg6eqvQNiSnLBEVzWr3E0wzQMia/zwX0istb6xdocpD4MgArFIbclZ6z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F0V3//D9; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F0V3//D9"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-adb4e36904bso340456266b.1;
        Fri, 06 Jun 2025 00:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749195348; x=1749800148; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3B44Arf5QXlToAOOYVpVALNJFgCEDJr8URLaNgTSe24=;
        b=F0V3//D9vE87zQ35B/aDU+acbkHQy96c0hlgJ7Ll5sS4I2pwEQt6+PPFleYD28CIam
         q41gxrwLYhRmWr6LxhfJ+aRUkalxG9NM8O1oureDIY2TLuGdIYAmJuRinghfQZqFLJiM
         7kJGvsEFpSws6gmvseUn/pnpnmPdjfRb7c7ETZ481q2JZ0Tiz7YfU3j/C3Edb3AoWQ5A
         FGusOI7p9uPS4+LozwV8vGKTQxgab/rHmvpkBuNvUAeb8sZF+2OnnM7AXEv+WC58fkn+
         6Yki1BFMUwbruoZ9lAYDu/YdXNyKaiOAlefxUXuo7eFBRlS78pnek6DE3kghPbx+Ne8/
         2XNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749195348; x=1749800148;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3B44Arf5QXlToAOOYVpVALNJFgCEDJr8URLaNgTSe24=;
        b=w88cZbSkpQfUyn/B+k8WaLfwsLcV6iE9NqyblUbi1JQFHugrdN3Yr/M9lhI+oTOnP5
         1bnvaDxTgkvC7VGBug3cWdMM/trh9j40+7LwF8qICskJmRNg+SEP3j/njeHIqW7kDp2E
         v7JihGtQO+t6y4pbU1YEi7B655s44Vq2Xm+53vTwnKqPKy/W6x3yFcalBK/BdJcKlbrc
         1ivCeE8AevIdNmxKCPRO4n5gVDwgIPteHW3QpbJrb673RT65DtYrp0FC2Q2RgFV+98aI
         Hdjq1gvl/Y+CS3W7CUtRgQIK2g5hnKnX5a8sGKjBNxlHMC/2YPK8rZlG/EfE1wHAgbUp
         4bIA==
X-Forwarded-Encrypted: i=1; AJvYcCWmeRJcRnmqOYp85jUFT9sA2R8LGVKZiPhf/acDPSrgPXEuO1+4P+1smSBV2wIKNdDvHlrGOif6@vger.kernel.org, AJvYcCX1PyjHCU8DnOfaSHfDZHcY57e01JGILKNXblHcI4UdwbrlC//pWTf2i9ohPVkqhoEsgw9LC6+0i844qvbv3Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzLuhMcLWrnui6Yg7SRXmZQ28bc0njjPnQ1Zn8LL+I9j3er8yzb
	JymEVDdPoPRpRcQaiyHLXr1RW9c+4SRONiTThedQJ6Az2N5/oFD7VxRGGkZkCZaoiIMRecEc6g6
	Q7sXvZUa6Stn8MufmhjIXa+S19RdtwI94g6EYpiM=
X-Gm-Gg: ASbGncsS0FngZX+Jh06tN/8Zh9XlzQEm8UY2VVRPULKq3g+yZ0Ty/gMvLIFCCJ9E+ZO
	ainocm9nu5tVzOS56VmZaycRspZ7u101BTlzzt7wUrQsAj9mCm34zuooHn/8mPfjt6Cg7dJejU+
	vH3TGsBqB+NoiTcu6WLxPJ2nJ1iR0bzX4GlMj6uJUiFj8=
X-Google-Smtp-Source: AGHT+IFab66mhYRxNZ86NFKf4CX41HwrnccLYskoEwH3USdpcoC/vMeZcxBwhrf1SFF0iZCCrQSV/s/3BAkwouB73Jw=
X-Received: by 2002:a17:907:7f0b:b0:ad8:9257:5724 with SMTP id
 a640c23a62f3a-ade1a9061f1mr194996366b.24.1749195347585; Fri, 06 Jun 2025
 00:35:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250603100745.2022891-1-amir73il@gmail.com> <20250603100745.2022891-2-amir73il@gmail.com>
 <20250605175129.oqqzr5qluxv52m6b@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxg2D-ED3vy=jedEKbpEJvWBLD=QYtfp=DCU3pQGGCaGog@mail.gmail.com> <20250606011223.gx6xearyoqae5byp@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20250606011223.gx6xearyoqae5byp@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 6 Jun 2025 09:35:36 +0200
X-Gm-Features: AX0GCFvZyPcHgbDSY5goMTstXhSylJtLDmHkmu25qbDsIGGzT7Rm38XHVVWLMfo
Message-ID: <CAOQ4uxh9b285dnw+SO2h6HqtNC5Xog0TQSqhFAQaV1brBnVxVQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] overlay: workaround libmount failure to remount,ro
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	=?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org, 
	Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 6, 2025 at 3:12=E2=80=AFAM Zorro Lang <zlang@redhat.com> wrote:
>
> On Thu, Jun 05, 2025 at 08:30:53PM +0200, Amir Goldstein wrote:
> > On Thu, Jun 5, 2025 at 7:51=E2=80=AFPM Zorro Lang <zlang@redhat.com> wr=
ote:
> > >
> > > On Tue, Jun 03, 2025 at 12:07:40PM +0200, Amir Goldstein wrote:
> > > > libmount >=3D v1.39 calls several unneeded fsconfig() calls to reco=
nfigure
> > > > lowerdir/upperdir when user requests only -o remount,ro.
> > > >
> > > > Those calls fail because overlayfs does not allow making any config
> > > > changes with new mount api, besides MS_RDONLY.
> > > >
> > > > We workaround this problem with --options-mode ignore.
> > > >
> > > > Reported-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> > > > Suggested-by: Karel Zak <kzak@redhat.com>
> > > > Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-23=
50b1493d94@igalia.com/
> > > > Link: https://lore.kernel.org/fstests/CAJfpegtJ3SDKmC80B4AfWiC3JmtW=
dW2+78fRZVtsuhe-wSRPvg@mail.gmail.com/
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > ---
> > > >
> > > > Changes since v1 [1]:
> > > > - Change workaround from LIBMOUNT_FORCE_MOUNT2 to --options-mode=3D=
ignore
> > > >
> > > > [1] https://lore.kernel.org/fstests/20250526143500.1520660-1-amir73=
il@gmail.com/
> > >
> > > I'm not sure if I understand clearly. Does overlay list are fixing th=
is issue
> > > on kernel side, then providing a workaround to fstests to avoid the i=
ssue be
> > > triggered too?
> > >
> >
> > Noone agreed to fix it on the kernel side.
> > At least not yet.
>
> If so, I have two questions:)
> 1) Will overlay fix it on kernel or mount util side?

This is not known at this time.

> 2) Do you plan to keep this workaround until the issue be fixed in one da=
y?
>    Then revert this workaround?

Maybe, but keep in mind that the workaround is simply
telling the library what we want to do.

We want to remount overlay ro and nothing else and that is exactly
what  "--options-mode ignore" tells the library to do.

I could have just as well written a test helper src/remount_rdonly.c
and not have to deal with the question of which libmount version
the test machine is using.

Note that the tests in question are not intended to test the remount,ro
functionality itself, they are intended to test the behavior of fs in
some scenarios involving a rdonly mount.

I do not want to lose important test coverage of these scenarios
because of regressions in the kernel/libmount API.

We can add a new test that ONLY tests remount,ro and let that
test fail on overlayfs to keep us reminded of the real regresion that
needs to be fixed, but the "workaround" or as I prefer to call it
"using the right tool for the test case" has to stay for those other tests.

Thanks,
Amir.
