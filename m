Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AA52AF19;
	Thu,  5 Jun 2025 18:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749148268; cv=none; b=rdmOcrVDbIlu/JMTi1imVI3HxX1zS9qB/bpPP/67DCsT9IOMxJCTzwJ53Q5tFZSKwvNt09hoVaD9K1Cicf/hpEudMuGU09cExWOiichgPGwoMMFnfJT8h8AxZH6Kgslm6X6zC9bawxDBFN0zcfuCuthaRleSxMqB0JlgTrGBys8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749148268; c=relaxed/simple;
	bh=U6Ts5h05ADXRoqgp/gOlyOtLdajJf9Rmkfua/lzd5WI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cXkyXWH0R89nu7euqOBEIBtEyozTxAaDfAIeplS4siKvxaYiKWjbvrjoe0xeXfce96dsvQQXj5FH7FNn1gQiVWJq6EeecrFGgokuVZPYX1YAVfJenRB3MVB33EYYf1UPS5GlYaI+eROyWvaqPSCd50eBsfscw/J2scciiY347xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d2TD2xTQ; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d2TD2xTQ"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6071ac9dc3eso2039944a12.1;
        Thu, 05 Jun 2025 11:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749148265; x=1749753065; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U6Ts5h05ADXRoqgp/gOlyOtLdajJf9Rmkfua/lzd5WI=;
        b=d2TD2xTQyrMeUOYVWdEcyKsz4uXPVhLw9kwAOSdxh6cBCxhhSseBduK4PjEHKoOg9m
         BD5WNWPtQ4485fo3hwGTWo5ioCj9dK5UQ3G/tKWwtFe8WZe1ykYyMlzGgsY2aKMpipfw
         uwADCYx6YtP12SnYEL8pnG0OHlHmpONMKP6kEv2vfmj9huHjxCIti7dKabyuLLEDoY1N
         Fv5qSF3rF8Om2E1bOIPjdootbOJ9tqI1UKV8E+zsbRWUCVSWFaSemFYJuXb80r3E5MNm
         yMemAWaJMcfOm4GkcLauNaUIqMkhQR+6wnrXAPsBtlNN3eTriG0lsdz4H3LW5hTp1IUi
         GOHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749148265; x=1749753065;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U6Ts5h05ADXRoqgp/gOlyOtLdajJf9Rmkfua/lzd5WI=;
        b=F2cM9k7NiQIJIvqeujEY3RyHZbvSLNN6NypJfwNCTDb8zYSJvejc0H5cZBv/uxERG4
         /4TKD+opKR42G+uJ+DVYOiqaXTFV2WiSEeet7Yie9geK5gpIkaSmX0O6b+tzZV4eXiti
         +1Pc/cPpA0SaOzZUEY/mMIqKQTfi+P2yOhh8MuDMMW6nzwjEDUDyhgPK7JzPp5Y7Q1y9
         87EQ1CCBtL155X/y42mns103Qq3oehyYH09ioFUwGJFGrXZPzNyAQr4xBzfzB8+VK9c6
         lkPEkV2aa0UXBhUBlfOan/drma+f9dsd76atdI3MwoxgruN/z9sbyJQkk1XibAATPl7e
         IMNw==
X-Forwarded-Encrypted: i=1; AJvYcCV1X+t7YbTEg7km6GRPcs1MUuR7HauYC8pTcv8s0Wpravq1AiydmhqW6JfvTpMFL8wqj5FV4pxylRPqOG+ObA==@vger.kernel.org, AJvYcCWPzKcIdmAKtvyOBSUpB0Le+IN2BSvRjtepZnOMPwKCXkrW9CqBrWYCynCbbeomRwHFSfEgZWM1@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7kfrFqSa9yM5XMI08Sdarp/Sdmy32VKFSGBJwWC7U1HH9BTnp
	AQvQap4neNmmaRVfydtjJr0PwJFkF2ifS6Uf/Kk2COn60uyptYEtcPYSHwxoZPeD9YvR70TH+nm
	BuMp7lKp8Tq95mszT7jhZTe0huEACPV4=
X-Gm-Gg: ASbGncu5QnpPMgh/Gjud/zB+PJBxrYvWKm1gBWS1VhZcNhfrOCtYsW8Xfb/bHE5N/vv
	s0np45T5dk68uU+sTB4meddrp2qvmGo7gx+m6GgEr0y/+d8m/QHxFcXDt5XlC8aS441POHSNFfN
	VP5nEzzUkfP5ShkyBXVHvxvIqeDqvedKM+
X-Google-Smtp-Source: AGHT+IE7xydTlzavpeE8HWmd2+TjmcrPNo6wvRqipJtyOIzG8OuuCnejiiY8G3czAUmLNHn78CUPGVPkE7qQD4Mvge4=
X-Received: by 2002:a17:906:f5a9:b0:ad8:9257:573d with SMTP id
 a640c23a62f3a-ade1aa951a4mr24056466b.24.1749148265042; Thu, 05 Jun 2025
 11:31:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250603100745.2022891-1-amir73il@gmail.com> <20250603100745.2022891-2-amir73il@gmail.com>
 <20250605175129.oqqzr5qluxv52m6b@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20250605175129.oqqzr5qluxv52m6b@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 5 Jun 2025 20:30:53 +0200
X-Gm-Features: AX0GCFupfYXqgqiL6iWOv28tqORgE4L2pr2U7kd8sL_SNHl3m9FZ1-zg6lriAEQ
Message-ID: <CAOQ4uxg2D-ED3vy=jedEKbpEJvWBLD=QYtfp=DCU3pQGGCaGog@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] overlay: workaround libmount failure to remount,ro
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	=?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org, 
	Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 5, 2025 at 7:51=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote:
>
> On Tue, Jun 03, 2025 at 12:07:40PM +0200, Amir Goldstein wrote:
> > libmount >=3D v1.39 calls several unneeded fsconfig() calls to reconfig=
ure
> > lowerdir/upperdir when user requests only -o remount,ro.
> >
> > Those calls fail because overlayfs does not allow making any config
> > changes with new mount api, besides MS_RDONLY.
> >
> > We workaround this problem with --options-mode ignore.
> >
> > Reported-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> > Suggested-by: Karel Zak <kzak@redhat.com>
> > Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-2350b1=
493d94@igalia.com/
> > Link: https://lore.kernel.org/fstests/CAJfpegtJ3SDKmC80B4AfWiC3JmtWdW2+=
78fRZVtsuhe-wSRPvg@mail.gmail.com/
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Changes since v1 [1]:
> > - Change workaround from LIBMOUNT_FORCE_MOUNT2 to --options-mode=3Digno=
re
> >
> > [1] https://lore.kernel.org/fstests/20250526143500.1520660-1-amir73il@g=
mail.com/
>
> I'm not sure if I understand clearly. Does overlay list are fixing this i=
ssue
> on kernel side, then providing a workaround to fstests to avoid the issue=
 be
> triggered too?
>

Noone agreed to fix it on the kernel side.
At least not yet.

Thanks,
Amir.
