Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32311D0F63
	for <linux-unionfs@vger.kernel.org>; Tue,  5 Nov 2024 11:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730806498; cv=none; b=CqrMc99VAODW4UMHxzm1qHpTLr2ZnStiQsoZcBhHHvGpNW3TDjkNHC6ACXxiUHUpEWp+uZGdpsCy/ypaV0QedvIV9T3ax+/+sYF5rkMMMmrC92+2JFWAPs9fczboQtI4qaeHV0WunMtNee6eliUiBhJMXwP3My5SedVdR88dh8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730806498; c=relaxed/simple;
	bh=5hOqNCQn601FkDuP2nCWB1ATvSZ1VINosMu3McQuJAs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ritC582pzZcjuUcGLMqEK1yJm4J7nNHDi5YpGGuE1v2P1afrVMuxeNAuq7+TFEaXc7yrM/AfMzU7lXOOktQ9Y/CGFN41b1g0AMQq9J7ivj3231jZyVhJJMFZuClITC+WMOku2ktzgebIWXGNs4+Sots/uhglxAir5gMyuY15QS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=LX1wFNqQ; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="LX1wFNqQ"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-462d8b29c14so11377981cf.1
        for <linux-unionfs@vger.kernel.org>; Tue, 05 Nov 2024 03:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1730806494; x=1731411294; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=psWw/Rad+KTcv4OScEPwUco7plFjBWP/BEIctwXEWNo=;
        b=LX1wFNqQemfMpNMlAn6G21W5VZAdXrvLm0ULGDsSrUEE0IRNkqLY45uEuqGL3IgxIg
         r5SNJtuICuX6rMGYdKKlvl7WUxedaLAQN0urdsqGrD6Xxo3CtSNWi+W+itnos534tO31
         5FrTQJ1RXkW8mZB42sHkTTDjSd+OKba4GL7/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730806494; x=1731411294;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=psWw/Rad+KTcv4OScEPwUco7plFjBWP/BEIctwXEWNo=;
        b=X/FrGxW8oFWROb5z2ZCpg42BCjovgB0WokMaBZ1m1yrncbqKzINoSL5v3ndke86ToN
         WGxihlFDuwHdrFbt1ftMApG5vIfKIR4dYCHo7GhufJthcIG3FB+maOI1Q0cRSBtSEMxQ
         fha/4149zg0L8euWp8mns9CvUYr1DPtk7GWRsstUzmO14g9UZnbeLKWIX/IDAOEEfV+T
         5aUtCakEtEbdEgVOWkPiULFbWpMkzZoduCJVpXzVn72VfLPsdE4FWyV2phj18tc8nglk
         NPSGfiZKGOLQdXlikG9bJti0fas9RtrtwtzjXcZR3sBsACTFikGizXAZAc1U2mY3dkQN
         E6LQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4oD1GM2Jtaa25Ak/ZD8BS+9luJ93T6BY2/RHKkXW1DhsFhz2RCxnO9RmK+pJpAUo5x3rdSH/S8ENrWvN5@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2U1SELWN3Oxroc+wd/sl3wVfuN7y5doCbznsyvBPc+M890BDA
	RlK+WseA5tyAvASHOa2efliU7dUuqrTSDKGdubHrSXkoUeUUBsAJeY7bqn+8h7WyJ402Hn5M1//
	nUS2kUT6tcnGP7LP13Aw70M3WZg/vlKq+Cy8d4w==
X-Google-Smtp-Source: AGHT+IH7/d1rmM7VWLPRdbK3Mx/FHurc8/ZPHObnO2Y9DUt0VsVdAZFPZ5dxnw5XFLU0s99im+MGu2kVCQSjcLwlGLE=
X-Received: by 2002:ac8:7f54:0:b0:461:1474:2057 with SMTP id
 d75a77b69052e-4613c19b6f4mr546758841cf.53.1730806493688; Tue, 05 Nov 2024
 03:34:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241025150154.879541-1-mszeredi@redhat.com> <CAOQ4uxhA-o_=4jE2DyNSAW8OWt3vOP1uaaua+t3W5aA-nV+34Q@mail.gmail.com>
 <20241026065619.GD1350452@ZenIV>
In-Reply-To: <20241026065619.GD1350452@ZenIV>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 5 Nov 2024 12:34:42 +0100
Message-ID: <CAJfpegt3qfhP85f+L+Qz03JAfOcSP4fzfz-x_8dvwoP9CgLdnw@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: replace dget/dput with d_drop in ovl_cleanup()
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 26 Oct 2024 at 08:56, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Sat, Oct 26, 2024 at 08:30:54AM +0200, Amir Goldstein wrote:
> > On Fri, Oct 25, 2024 at 5:02=E2=80=AFPM Miklos Szeredi <mszeredi@redhat=
.com> wrote:
> > >
> > > The reason for the dget/dput pair was to force the upperdentry to be
> > > dropped from the cache instead of turning it negative and keeping it
> > > cached.
> > >
> > > Simpler and cleaner way to achieve the same effect is to just drop th=
e
> > > dentry after unlink/rmdir if it was turned negative.
> > >
> > > Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> >
> > Looks sane.
> > Applied to overlayfs-next for testing.
>
> I thought it was about preventing an overlayfs objects with negative ->__=
upperdentry;

Yeah, I overlooked that aspect.   Amir, please drop this patch.

> why would a negative dentry in upper layer be a problem otherwise?

Double caching, see this commit:

commit 1434a65ea625c51317ccdf06dabf4bd27d20fa10
Author: Chengguang Xu <cgxu519@mykernel.net>
Date:   Tue May 26 09:35:57 2020 +0800

    ovl: drop negative dentry in upper layer

    Negative dentries of upper layer are useless after construction of
    overlayfs' own dentry and may keep in the memory long time even after
    unmount of overlayfs instance. This patch tries to drop unnecessary
    negative dentry of upper layer to effectively reclaim memory.

The reason lower dentries are different is that lower layers could be
(and often are) shared, while the upper layer is always private.

Thanks,
Miklos
