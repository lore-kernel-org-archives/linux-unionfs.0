Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B271A3AB0;
	Mon,  2 Sep 2024 19:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725306403; cv=none; b=WOq2wcmtggZecuPMa25lgXpvWwS6V5ahBZ6lexq1n4c5yrx38A9pwZ6RoGjzU0Y9/dviEbtVlkIMrjMSFZcPOnxhJS2yK0ana3jBH5L2dcapy0wH8A/CBKljq4ajAhgtyT+NzLQKSdLhBi/WBr2UCSe0KYPFmSDp6m5yhk4DtjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725306403; c=relaxed/simple;
	bh=BJZIgV00FKWEiFXZajaS2kuvYdqiP/ScZWM36sr6YDI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lyv0NtrNLvZMOyHyilEqWfAUoBM3u96UyS1afD8jSdEMJ+JTab8XFXXO6oQGMYYEZIJvXxp4uUEZKUI91Yt0ZTHYKzuGA7zrpIKCFxskWhSh9YaXc5uucRbCkTr+TBWs8mhTNcMJwueSMdg2D0CELjunwpdN4Vy7fDgAi69/wHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X6FMlqVv; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X6FMlqVv"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7a8130906faso188028785a.0;
        Mon, 02 Sep 2024 12:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725306401; x=1725911201; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FPt4YftqXl/ITybd0Q+qam9dJypjp2y3bCXrKXx6mCY=;
        b=X6FMlqVvvfyq0ZyJ01+st8bDLNMlTYaEfvKw4TUYddkXvmR8VympxE+nYxDWv+f0EI
         BB9SW4GPKhGL6zwucmlJ9qXzU3V8pOQ9aLOxW3ZP97cQ+mvHKd2+LmmXdzNH2Mp7rXe7
         fqiFyM/jl0jMZgSoQ3apTaNaEPJ2d19bzXJYyoPEnDJrSBgpcdfEQEywV295fvorHEsy
         BEfLjvU4JNAzw+wUzCjBe1lW5aIn2IlK41hzX+yZI1bUcGR6hV6lddh4GEbjGxRI2f6h
         58bOROzRcsVho1QLvqpfoVflLVGl4Ti9Y9o3YlnoD/X88OPQkZoiIfYt9OH6fBW1thC6
         HnMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725306401; x=1725911201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FPt4YftqXl/ITybd0Q+qam9dJypjp2y3bCXrKXx6mCY=;
        b=D/8RArVXkBrVmyUR6jS4W/mjQnkxuBsDz3V5L6p/oyYZ5IalvOPNowmJJIle1Epp8V
         x7gnoC3CZu6ZzChXLC6efU4qMjcqM9W6BxdkaLOQ1KyST4vsf6TiYPL6jelLj8o476wo
         PW51FiMgsPuR8X15c1YBHwtT6xLh17ouH7QZ0BtGsf/7HPKSu8KTD8h5ix+jFcUEXEz2
         NesEt5dHN9tXoNFa2tvHWAtiQEQGgsCrxq6aIp0lsu1EHnn+3hK8XvdvCIUZtQn9rj/2
         NxxgIUb8lPLLtcBNKdVH0AHw5DJWOWeYwKY4yT0n43yuipj/WDCQBwMio70qTOCPU4aR
         5rgA==
X-Forwarded-Encrypted: i=1; AJvYcCWOp4kXzxtEBRRZ8ySoIfoeU3JBrBkgDmUhdY8Dzzbxtt5NZTxxxBxPMMCeduxiXbHF59UkYIcH@vger.kernel.org, AJvYcCXoXLNjxAG0Ca+1aAcoodSxTAKN1n+oQrLL+PjCMWPmts/XgIi6gEX0g17cKQovigf5KxCmaQ0AlbfgaLmHZg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwFw26fo4HX3zR8jgtKQfAXcEziRtp6UoRpwsR0ko/BEtgTxhf7
	3kC7FHhf0fRyekKUeJC6PwwlGVGI+KQUmYlHIGnXZ4zicL5Ci1Myng53U2wZdX6qShgMlyJqo0t
	FKt+A2vJunPTrXAbOHJRkUU0IGW0=
X-Google-Smtp-Source: AGHT+IE61gHaACB1tHddrAB0WfZFxwcx/S2fe+SrGnJrqy5mCpG4o0ePYNMuYTY/ocX8qaqn04AqyPUkpZoBTLWRdUQ=
X-Received: by 2002:a05:620a:460d:b0:79e:f681:777 with SMTP id
 af79cd13be357-7a8ac3ba906mr947769085a.52.1725306401250; Mon, 02 Sep 2024
 12:46:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240830180844.857283-1-amir73il@gmail.com> <20240902190726.GA6220@frogsfrogsfrogs>
In-Reply-To: <20240902190726.GA6220@frogsfrogsfrogs>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 2 Sep 2024 21:46:29 +0200
Message-ID: <CAOQ4uxgDX2n4oRKU5xR=vj_RcvY8MoMkJB2rGet1ov=kjfEAsg@mail.gmail.com>
Subject: Re: [PATCH] overlay: create a variant to syncfs error test xfs/546
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 2, 2024 at 9:07=E2=80=AFPM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> On Fri, Aug 30, 2024 at 08:08:44PM +0200, Amir Goldstein wrote:
> > Test overlayfs over xfs with and without "volatile" mount option.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Zorro,
> >
> > I was going to make a generic test from xfs/546, so that overlayfs coul=
d
> > also run it, but then I realized that ext4 does not behave as xfs in
> > that case (it returns success on syncfs post shutdown).
> >
> > Unless and until this behavior is made a standard, I made an overlayfs
> > specialized test instead, which checks for underlying fs xfs.
> > While at it, I also added test coverage for the "volatile" mount option=
s
> > that is expected to return succuss in that case regardles of the
> > behavior of the underlying fs.
>
> As I said elsewhere in the thread, I think that's a bug in ext4 that
> needs fixing, not a divergence of a testcase.  Perhaps we ought to
> promote xfs/546 to generic/ and (if Ted disagrees with me about the EIO)
> add a _notrun for the overlayfs-on-ext4 case?
>

Well, I have the generic test ready, but it would also need to notrun on ex=
t4
I would rather wait to see what Ted says.

I don't mind promoting xfs/546 to generic/ if there is an agreement,
but since I need test coverage for the overlayfs "volatile" mount option,
I think I will have added this overlayfs test variant anyway.

If ext4 shutdown code changes and there is a general agreement that
the behavior in xfs/546 is expected from all filesystems, then I will be
able to remove the requirement of "only over xfs" from this overlayfs
test variant.

Thanks,
Amir.
