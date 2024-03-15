Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF103F9E9
	for <linux-unionfs@vger.kernel.org>; Fri, 15 Mar 2024 15:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710516905; cv=none; b=q/4+dTGDPg5lcQlL0Hs/hRatYjzKMJmbqdEo17v++OnBdF1bJHCS4ULNJJYOKk/eVzq52ZCjcwMnTH2D56XFVXuUnTb/Du5urfwhyk9TwAgvOJXsH7ho86xxVg1tw9eA7aeNhb7ULO4ePCRjlRhoIpul/xqhKHldQ/Ol8Wxva8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710516905; c=relaxed/simple;
	bh=sYXZxPTCQtEh/DBVhWweRVoviE1XYbGjJr89L8fT1VY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AxaWPW31tU3OTQ+LtJ/gwrVkHiWW8yHuQbOAgbkOyGrjCtjdJG64HfrdfiTsKEMsKTIq5Pj1RpySmff61/5Cu93jbYkMedpaLkdH0RBeRETxn1XOAYctCbKa6PB2OmPZivlhDwdor2rXrvKAKmEqci+KeT9HxG8qzTYx3V6nOa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=MfEQ95Tu; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="MfEQ95Tu"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-568107a9ff2so2751941a12.3
        for <linux-unionfs@vger.kernel.org>; Fri, 15 Mar 2024 08:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1710516901; x=1711121701; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sYXZxPTCQtEh/DBVhWweRVoviE1XYbGjJr89L8fT1VY=;
        b=MfEQ95TuDMwu6GNdefUuaE03/YBemHn/Z7f0BLv3OMJCNZOe5RjZgoypaQyo7AZARE
         bpqMTs0Z/lvzt8gw2/JVETkak7s2JgD85w8LldTNqjRN5ZsorefIXDMNqP2efn1QGzzQ
         3rKfnoiuUuUg/4ss57s+tpUKUGAND+tV36ELw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710516901; x=1711121701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sYXZxPTCQtEh/DBVhWweRVoviE1XYbGjJr89L8fT1VY=;
        b=HEvL0jSt/DUOYVymZ7XF4bJWo+mncWC5U0OIUq/1CRZCGSRjkq2DyUI1BZZ8xSWyzW
         Z/NmGM27Z4/qxlZZHG/Jr3WSo8twEkQBHczpDJm8VxzrKjqNOkALf8bGye2sTGx0u0t9
         6+3hrL8aNau2aC1PLkugGSsM9ljh02eibtPykGqvpFcfBjv1AXjjkD3Uc8ZV5SOY31RD
         uixduDDPFl9nSK9DAa1Ns/Kuc821mK21ohtoHvJkLuScnWelohojK0YAr+oHkSuop0ka
         70p14oU5FQO+nicsllYScijMdX6yVHncP1hY0MH3BgD+E8bJUcdlBl9rRi24zQwLfpqM
         EWew==
X-Gm-Message-State: AOJu0YyH0kc2nqnax1SVo0kqO8sWusxegpzLmPL3CY3YghKYSdhKtY0a
	mYaVQRXtaFu14zm3lVIlYko/Hnt6Xl4ggmiXPDRkh4AZiAy5iE4lRXM4hUNxgQdYhA1glFdPBjb
	agg==
X-Google-Smtp-Source: AGHT+IG8kJPYurRXDtaKF3jgm/X0euqvTB9ixuQM4rhchW6Fgt9ekWD7hu9jleegtVKVPR6/Yfs/Gg==
X-Received: by 2002:a05:6402:914:b0:568:b93c:bc7c with SMTP id g20-20020a056402091400b00568b93cbc7cmr375056edz.7.1710516900730;
        Fri, 15 Mar 2024 08:35:00 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id n18-20020aa7c452000000b005687e7b0cd2sm1776934edr.40.2024.03.15.08.35.00
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 08:35:00 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a449c5411e1so299845866b.1
        for <linux-unionfs@vger.kernel.org>; Fri, 15 Mar 2024 08:35:00 -0700 (PDT)
X-Received: by 2002:a17:907:3594:b0:a44:e34a:792f with SMTP id
 ao20-20020a170907359400b00a44e34a792fmr3313662ejc.15.1710516900153; Fri, 15
 Mar 2024 08:35:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHQZ30BFHkt-D65rbxE7MspurQKD8kw2bK2HKxast-RN8ggKfQ@mail.gmail.com>
 <CAOQ4uxgL8isH32NK5WtbQjPudrtG_MKecGB+j6VBHmb1K0jzyA@mail.gmail.com>
In-Reply-To: <CAOQ4uxgL8isH32NK5WtbQjPudrtG_MKecGB+j6VBHmb1K0jzyA@mail.gmail.com>
From: Raul Rangel <rrangel@chromium.org>
Date: Fri, 15 Mar 2024 09:34:46 -0600
X-Gmail-Original-Message-ID: <CAHQZ30DQvsVmp9Co-3Vu6YiOhejT2uNSdDsHi+vkyGAszhKmeA@mail.gmail.com>
Message-ID: <CAHQZ30DQvsVmp9Co-3Vu6YiOhejT2uNSdDsHi+vkyGAszhKmeA@mail.gmail.com>
Subject: Re: Accessing bind mount in lower layer via overlayfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 13, 2024 at 1:50=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Tue, Mar 12, 2024 at 8:13=E2=80=AFPM Raul Rangel <rrangel@chromium.org=
> wrote:
> >
> > Hello,
> > I was wondering if it was possible for the bind mounts created under a
> > lower layer to be exposed via overlayfs?
> >
> > I have attached a test script that reproduces what I'm trying to achiev=
e:
> > $ unshare --user --map-root-user --mount bash -xe mount-test
> > + mkdir -p real/usr/lib
> > + touch real/usr/lib/foo
> >
> > + mkdir -p stage/input
> > + mount --bind real stage/input <-- I want to mount `real` under `input=
`.
> > + ls -l stage/input
> > drwxr-xr-x 3 root root 4096 Mar 12 11:53 usr <-- `usr` is visible.
> >
> > + mkdir work upper merged
> > + mount -t overlay overlay
> > -olowerdir=3D./stage,upperdir=3D./upper,workdir=3D./work ./merged
> > + ls -Rl merged/input
> > merged/input:
> > total 0 <-- The `usr` directory is not passed through.
> >
> > I wasn't able to find anything that explicitly states it's not
> > supported. Is something like this possible? I tried setting the mount
> > propagation to shared, but that didn't have any effect.
>
> Overlayfs does not follow children (bind) mounts.

Ok thanks for confirming. I wasn't sure if I was just doing something wrong=
.
>
> It looks like you are trying to overlay the tree at real over
> the tree in stage/input.
> Why not use an overlayfs layer of real on top of the stage
> layer?

I can do that. I was trying to get away with having a single overlayfs
mount, but it's not really required.

>
> Please explain what you want to achieve rather than how
> you tried to achieve it, so maybe I can help more.
>

Sorry, I simplified the problem a bit too much. Your comments were
exactly what I was looking for though.

> Thanks,
> Amir.

Thanks!
