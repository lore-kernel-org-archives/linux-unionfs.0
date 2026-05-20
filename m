Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4486F3A6B6E
	for <linux-unionfs@vger.kernel.org>; Wed, 20 May 2026 13:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779283489; cv=pass; b=Vlj3uxEqT1++D9zuB8PlxN1LPOw7TgFW7PzfPPuRqOcebdF5hk9jV2zvHZcQscI8h0XupP01YGClfhQStiKtzMyf0hVfohqePZKmEMtubqiXhyP9iL6mZa3rXLIvcL4ndgsXUh38ZBq9A5GkH2QWhDo1NJwOysawrwZLpR7yFZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779283489; c=relaxed/simple;
	bh=Rit3XOj+nAqSskgBa3AwkCsmGpVaId+gpzvsbFjHRsc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=le11A0ILkHJzVjpJ0Aam3pvMf02u3HJ8tsk4OPIvQeitNiwqIjeQDqNIBhtj3UQZ1JYYSlDmPRhoLQhxYNzz+DNg5NWg47ViucB16/u2UJ30sFsCLh9tlzlyZHwYhIkh6uu2mBF8+A2KVeiJ9onvKRXqwIOePmzEcrSpXtfWKd8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DwKoCw/P; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DwKoCw/P"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-67c4aaf76ecso8281870a12.3
        for <linux-unionfs@vger.kernel.org>; Wed, 20 May 2026 06:24:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779283485; cv=none;
        d=google.com; s=arc-20240605;
        b=QWHUTUde8GDs/xtS9ya8pjyAQl3S2XLBMuo+8e/2yPKZOevqn0+HNv73ZAxYZghYLO
         Khcza/LFt55ZNLsF5HKmjgJD4qCZ1EinxAjeftLflJv6HX5G6SHJZzSY1XA1p5baJSu5
         xprXZknMmBOa+mm0KVKwzV3E4xkQsFYDlsLA35NszAO7N+3STDu6aV+QHQdEjt4ZEn/x
         1MZ5ehj7ZFbJMsU3zY3JM2ObSn11epNPXIPyhkP4IQ41/vRjIpiTJS+WUZJbpKsJANs8
         TZG2/dbTzNbslq49ZeeBgAqKBVsMYVM+NVFg6zqtzEfgo59bEELZLY5ckjCWeEhH8M8S
         PSnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Rit3XOj+nAqSskgBa3AwkCsmGpVaId+gpzvsbFjHRsc=;
        fh=TBQmgWdQc7NG6k/kZOqWSSKZ5GW8kccX51+X+lv96Dg=;
        b=EdZn/hl+1P8c52Qf4GiNkcDmdBk9nhEK5g4iny63DCL9DzD6xsCiW4px15dN+qBPGN
         Pk8OePvQEAKXyifucaxwn7NQQ0fOfyNx2Kh1Bej1RDEBoJfxbR9uK9qkAdjWMAB31Bb6
         HSRxWtT/EJxHvr2sY+9GdC6eIi6uD5H/Wujt7wdzNOqbySM29ieboafY0OzOJYPs32zr
         Z09giSaXfYGoCCj7pjWtGVd9jL27X+R9jIpClEHv/aQI255z1qSWSckEm+/Bd2rlwY9J
         Dw4XC5mn6uFhqR8AjnLBaW0tpcTaXOs0CHJz0APJ+V20Vnk2jbPt+9r0bLADahpjJIVB
         EBPg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779283485; x=1779888285; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rit3XOj+nAqSskgBa3AwkCsmGpVaId+gpzvsbFjHRsc=;
        b=DwKoCw/PT7mQ10vNBMUrsTEgJ/KD0xilvxMKeI+aiO7GBDvQq7XKJJ6kyNOOhWPRFC
         qAQRff8dLVNruj1MIMY+n75FGD1FnYxldtzIkNgu+HLnxNvGPuCim/abv25tCKOX0c4M
         B90eJODV43Mun+Az+kck902Vl9CJYMttimw0RXk+sRWyhFsmweKWF99SC7Mwan6wOHFe
         ECm4lVjQVlTWgUeeELJ94rOZn5g2GnGibbV9qeU8cfV+5qB+iTfrqeWOwpY9JiXUFeT2
         qwR5fHpfjh1a5z5kJLq0R3QIzdIesXZWyZHMBltpqUvmJGhNMGt1egwYWRwxhVmDRO+w
         Lh+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779283485; x=1779888285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rit3XOj+nAqSskgBa3AwkCsmGpVaId+gpzvsbFjHRsc=;
        b=dfN5s9h4Xpc6PWUbKuUk4i8eaGRvjUIowdi6SWJ1LvKkUdVHa1fKAtj7Jx15i5p+qc
         Ae3Ioxp7ps3ttvg4Vm4tYbEFd5dzC8o1qnwqe/IW0FrGky1mhgRLPZdM+/YCjSiAp86Q
         fgt81n3UAukp9etxsj1z6pIQT3Jh96uGbDCW/j1fVfYSudHDM2ZOzFYfxJCpkzcFjzVe
         kgoKApEsBwB6Ejt4e57o4ZJM/IRWHdCVljbf0+V6w3lLniGhaevoPunYAIz+cNBqB1oZ
         JB5WO13KdgATGps5CfN5wKE37L3yr46JOeWHtxiiCrstmMMZiJHpJNh9qJxyfIzG15Q2
         iJ2w==
X-Forwarded-Encrypted: i=1; AFNElJ/mMCzIiov/dKZr6gQ8jd4r5ySsmLsYvUqw9TWppnujvKoWRjNOIo5AUKhuQRXs2KSt6jlf6nc7MbDT5NxS@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3YRIzCoTCkWFwBOxqZf1pTdY0i/RF2kk2BbyY4Vt22TAl5lup
	w1uXZoK98zeZwWzHdQhR2yx7+tM4e0iDcDRMXS199QuojW30/53Rm4O2icV9Yfku8+Y2sozQ5U6
	sH0PK0EdFpEtEDiCfNdmgv/+tc+DTt6g=
X-Gm-Gg: Acq92OE0MheGBw3pMIyvDV8JF48CI1Xytu79ZFCKFxGDK5Oq7NsSWWRkZo/VKJFDz1P
	uTm+niP6TmptG30s/Pd4aixagLUUWLKCXPWpRbeZI0lJkNEuiu/piCjwvap77y4Sut8L4U/BWQl
	yWp5R8KmzITPsB06v2skhR01pTb/o45BRHRU+EPcu/f7LUeASqsjLr0R9KFuWwdfEGO5nqTjsFp
	ec4ikuVGBVnwoFzAgHywyDdek9icUqWUEkEPb5JfyEvUIEpMmAxY8SKZ68aCFXSiSXeBzNpBy1c
	ns2DmOFzJlBvpt68k/KjIBZncaGdtZmkgEr3wNBBecI63TB1kQTN
X-Received: by 2002:a05:6402:4313:b0:687:285d:44a3 with SMTP id
 4fb4d7f45d1cf-687285d465fmr1620985a12.15.1779283484506; Wed, 20 May 2026
 06:24:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260520123722.405752-1-aalbersh@kernel.org> <20260520123722.405752-4-aalbersh@kernel.org>
 <n67pde3prjxt2c2u2pvjytfw7uzwbeij2yljlrwh7fixcgnzhp@piqsltgpcc4v>
In-Reply-To: <n67pde3prjxt2c2u2pvjytfw7uzwbeij2yljlrwh7fixcgnzhp@piqsltgpcc4v>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 20 May 2026 15:24:33 +0200
X-Gm-Features: AVHnY4Jb9lW17aXG5JPAYjGDiGqwrTNH7OJH9zvcsbDKfZCeeZ6RTdTNxiDlapc
Message-ID: <CAOQ4uxiNN3U4datJb8kxxGVp7VNRFZB6_zEnO76kh9oEjE_-bg@mail.gmail.com>
Subject: Re: [PATCH v10 03/22] ovl: use core fsverity ensure info interface
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, djwong@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 20, 2026 at 2:54=E2=80=AFPM Andrey Albershteyn <aalbersh@kernel=
.org> wrote:
>
> On 2026-05-20 14:37:01, Andrey Albershteyn wrote:
> > fsverity now exposes fsverity_ensure_verity_info() which could be used
> > instead of opening file to ensure that fsverity info is loaded and
> > attached to inode.
> >
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > Acked-by: Amir Goldstein <amir73il@gmail.com>
>
> Amir, Eric, this is the last patch missing a review. Could one of
> you have a look at it. Not sure who should review this.

Feel free to upgrade my ack to:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
