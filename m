Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44350286D61
	for <linux-unionfs@vger.kernel.org>; Wed, 28 May 2025 13:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748438890; cv=none; b=pqK71FX2NqIWiu74AouEKM/EkymMSIQelZ+x7aws6F5bBlzD00GTHQxoOqc5JY/fvtsc5GjY5ahBNheyY8LAaCZ5AdwqyL0Kgm18TA0uaaA6IlNUTi12/zrQtKjKvJ4SajKghfP8ZtHiScMD8rCqjFh7S97KReZdfagWGOvBfhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748438890; c=relaxed/simple;
	bh=AO0qheCg3pvTADmYgLIyl+58wRbI9XkllfAHkyyMNTA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W79Mitj2yA97XgpIDVoGDTA0n2Eru7fc7A3cJ9Ukm6qaSGLr7l1FJ+8rw0QesguBfqjXURMaBP7lqQXogRHb4ioeBHAEeKPjsdp2DJ1WztAncVQ4pUw9fIdjd6adAEfv/anMIVBRkAzx1puBbLTNBO+A5CT7YtGeayq40yDgFUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=DhFskK+y; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="DhFskK+y"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-47691d82bfbso86565771cf.0
        for <linux-unionfs@vger.kernel.org>; Wed, 28 May 2025 06:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1748438888; x=1749043688; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n7m0M+12DLMVTqHyfHZk/+HgGWNzdFOV6XWjPa7hJe0=;
        b=DhFskK+yKypFng0juscoGXtfMAMHKSpKArpx9f3XR10kqQNGCEJefxYPn62KB/OnBG
         R/USvChspgTwTSe+zhuPlzjr9HT8tRrgWF0BvAvnbHjYLx8bLpkXdIU13R7z8bfjxfK5
         onaP+sRQXMJEBJ/nb+0YOFwZqFR0KK0Ew1tpE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748438888; x=1749043688;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n7m0M+12DLMVTqHyfHZk/+HgGWNzdFOV6XWjPa7hJe0=;
        b=ApbuipHTDnJks79WMqNSpE8XfsgJL4tKTh5QBnYsfiV2AxayxynNTq6LGhCDqSxKbE
         1avzI7h66rPoLEyP/n4tThTMgapI/5kGPua9HzR5nvYP7M9CtzSt3EZcgARCicczEN1s
         qkXwVH73voBb3fdHk9+8h6U7QY4mCbLwkE9lnSse8pzveq8Zf8sUF82s7twfQsAyRgri
         DtYZLT5V0Aoe0stUngkqqNUw2ywyMBDJ1O1mwgkjtkA6UJ4DzjXpsQNUn9eKhXoteehh
         XZZNLarH+msm+j0EKLz7YcOGqUbDIg3lGQ3WJPFIL9giiwSfmS8Lb/lqb1hitznZ4s/D
         FKuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBnTwJyyPWdlwzl/G3ZXTXhTDeAlUnMIxtPTWusA3D7udEnsf9OKkfOJAJUxCzfMAybaHGkNFJTtjr5RI8@vger.kernel.org
X-Gm-Message-State: AOJu0YwphxIixDDZON9ywT/C92eDH+IpqrBixL7QIKtHslMoybIoETUE
	nx/vRM8rZlb2pABhMhxDm64CKGA40EW+wEXwYBShb/lfykqG8BXrKJ9xYs1jUT1Uzu2o08F26tF
	5NDyqKtCYhqSxLlmNdyhL0jPLNwPdUNWAl3W1Dwu+qw==
X-Gm-Gg: ASbGncuL5TYnzM4gpq+DuUDiYY+Bfu/Ep7U1aI5xsVQtHn1lT8AF49MO11Yaw29DPVM
	+b0G8B/TY7159nfjAcSAC/tXFEJy/7UfvTDIzWiwaelBIFnugJMfebqwk5T6qDaMaO2ASj1Yrsh
	p7c5fbkSSO0cUzGGdpT+J9OwoURw/ZtfPOTa4=
X-Google-Smtp-Source: AGHT+IHm3UyI3GsTSNsOcmNUM2LgeYCbmnHvKfVAM/h0ttlHAq7mvwVbjaumTPITV3jsHGjFO80GNSXr4wONGrFBvTs=
X-Received: by 2002:a05:622a:250e:b0:4a3:ebb6:6a62 with SMTP id
 d75a77b69052e-4a3ebb66ae9mr26275171cf.31.1748438888232; Wed, 28 May 2025
 06:28:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250526143500.1520660-1-amir73il@gmail.com> <20250526143500.1520660-2-amir73il@gmail.com>
 <CAJfpegtYTpJXYOiyckcfQA=YTVXcLQZRGV4=sjueLenJpTp7Lw@mail.gmail.com>
 <CAOQ4uxjh9u3DE_HKExa=kK08efzDsxVuCVuA0tUMjwSeLX=jnQ@mail.gmail.com>
 <rjqagpvze4mwnil6tck6jnyqfbcgqszy5bjgu4fqzdtq7e3idq@uizmifogsqyf>
 <CAJfpegtJ3SDKmC80B4AfWiC3JmtWdW2+78fRZVtsuhe-wSRPvg@mail.gmail.com>
 <urxghfhdccjg6v47h63btu77kyxnsxbrmxdbhb7kx3oiqz23og@plyznhi36omp>
 <CAJfpegv9Evti_MmWR72Gg13s9XYsxJHQ3WSJRwLrBy5O8aVHaQ@mail.gmail.com> <u6gsk65mznw3gisnr4btpxvooa7czbhiei4exbsgc5swdbgtf7@c5hx27plyu6e>
In-Reply-To: <u6gsk65mznw3gisnr4btpxvooa7czbhiei4exbsgc5swdbgtf7@c5hx27plyu6e>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 28 May 2025 15:27:57 +0200
X-Gm-Features: AX0GCFtyfJbR5X2Eo_sUl6uSNhcPhnDrTNwNM82qWTZ4obdARXYZN6KSC1XhdMQ
Message-ID: <CAJfpegsd1SyyojcrY0dekKiYFP_ZaL4pe7sKaq57xEyx8RsPqQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] overlay: workaround libmount failure to remount,ro
To: Karel Zak <kzak@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Zorro Lang <zlang@redhat.com>, linux-unionfs@vger.kernel.org, 
	fstests@vger.kernel.org, =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 28 May 2025 at 15:13, Karel Zak <kzak@redhat.com> wrote:

> Why can't filesystems silently ignore fsconfig() requests that do not
> introduce a change? For example, if the current setting is foo=123 and
> fsconfig() is used to change it to foo=123, why is it reported as an
> error? It's stupid, but just no op.

It's a workaround for legacy behavior.   For overlayfs it doesn't make
sense to specify "lowerdir=" option for reconfigure and as such it is
rejected.  What you suggest is a hack, which if there was no other way
I'd accept, but I think there are better ways to fix this.

> I'm not sure I understand how it will affect userspace. Do you mean
> that with the flag, the kernel will assume a completely new set of
> options from userspace, and the filesystem will adapt (if possible) to
> the new settings?

Maybe the naming wasn't good.

I meant the opposite of what you describe: the kernel would guarantee
that only the supplied options change.  This is already what sane
filesystems do and they would not have to be changed at all to support
this flag.

Or maybe all filesystems do this?  I haven't checked, but I assumed
that libmount does the "append to current options" even for the new
API because without it some fs are broke.

Thanks,
Miklos




>
>     Karel
>
> --
>  Karel Zak  <kzak@redhat.com>
>  http://karelzak.blogspot.com
>
