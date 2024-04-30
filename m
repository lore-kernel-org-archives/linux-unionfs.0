Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315D8173323;
	Tue, 30 Apr 2024 14:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714486327; cv=none; b=YngeBVGvdQau4sTgvajJ5PG7OTpZCGo36oen+E81SpuGxF/qrKdJmrBTAcQd2mL62o3ntMLlTO98HgPR12WWi5ZSvCCXEFRzjN5RomWE0hgrVOp4zgItpDXPjwQWx62jTgIbPoFOAjg2N2O+M/S7VPlwGkvoG7JBagu4L3Lh2r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714486327; c=relaxed/simple;
	bh=713j37krr/fkAsz5OXhOo4E2ka6ruUsiDMtfW5puYko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T0nN45eQgpj0s0H06qnaXfoM6ViMzzin7CU0/0MOPNI3Q9Eoqbo+OqzJCSb0LLbpcWEE40bA4Y/WpnOhDZhjFUeFuPUAEqMLg05n2ZHl4z5GgT/IWV3Hc7GzShI9wDTBKz0glDVXg7RnTotMydg0COg/FrHrY26jhBui+K+JKKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dyKpkUzA; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dyKpkUzA"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6a077a861e7so36336806d6.2;
        Tue, 30 Apr 2024 07:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714486325; x=1715091125; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=713j37krr/fkAsz5OXhOo4E2ka6ruUsiDMtfW5puYko=;
        b=dyKpkUzAIaeW117d0/XJkYA/BxqLsbBLbcvG6zO+fYmy20bGdr3BMAIA4RyA7fmyuj
         7fNS/JAaRLGrc3rhw8z5r9vuI8U0PlW97GDL/UcVZwx531alJN8JKuN0V1O+k5MHVCOB
         /+R9uLH+nS5C2VD6jGt8XGQAPcDim+s30UOyTPgSJ0GD+glc+jOys4WUu9Y6Erl/Ot9f
         VbiLQ8qwYtvYaITDYaYx/iKxXh/AqqcI8anoDRFl2SpEgIC9g1+2RSDG5rt0uJYnTYWg
         6e7AOUmtlSbTDR/S5qzKyToq4SRDYyHsVoyysbWPXRYlQBPFqP+C9NIXW3xDlj344NB0
         AqzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714486325; x=1715091125;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=713j37krr/fkAsz5OXhOo4E2ka6ruUsiDMtfW5puYko=;
        b=a+hK0G5AmWnpjbw/UjtS0J91LTMxXQ5tR7BaFQM9OQai93c95noekhAWLEBLDrCiov
         zBUWNr2tra8zrZMwZslP5TCm57QQ8itFLht0sSP5+ZZJq4/oRh5YK32idYzb4Ep9qu4P
         OjJ8pz1jnLWFnfcCbmBUVE5PPON/cQj4WP85pfpJTvgMmeSJovrvHc7NLunvAvHMGjVG
         eWOEWZ0fGmPJP60sSQ4r7qAy2/fCzeJWCt6bk7HXnKQ5CAdyp01Nwe85E1sYoTUzxYzo
         rkP8PIDbKIyoJ3iMiEOUoVSF+N46ewi2wyxbtO35vdnw7g8KGtQaIgxwdG8F7Cl0V5bf
         ZBcw==
X-Forwarded-Encrypted: i=1; AJvYcCU1Q7QXPqNdOg6RayNFtbyVSAN+REN3x7IlA/Z899Wn3Qe2T3j9d0NNeLxSpE21Nb7YxeCT7xprGcEjzbyUgpURGaC/9hgW6LYelByPc8D9s9s52fN4+cWPGp5NSA3JrCtH0rBSGA==
X-Gm-Message-State: AOJu0YyBm2p+KNImlhJNtFC8y6EI3vGiYmmHn+FaJttZ5lXgmf7SDdy5
	02+mrnpGB5VM7NSXyyIC34rKSwCy8PCNPLHSbkJD1vUHskLB3ksCittbWFpttARbj6ZDOBO39d4
	XKsrn187TTr09ydqYgsApEwC4aJ4=
X-Google-Smtp-Source: AGHT+IEpm+rLbgcDaZ/FYOU94jMpsYbh94fCw04Lypg9cTbqmCTTWg14lVnDG5xGEj/erPJNxeg7VvNmGXV6+m0CvUU=
X-Received: by 2002:a05:6214:2481:b0:6a0:d22f:b668 with SMTP id
 gi1-20020a056214248100b006a0d22fb668mr6570259qvb.26.1714486322916; Tue, 30
 Apr 2024 07:12:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240430034854.126947-1-jefflexu@linux.alibaba.com> <2024043049-divisibly-discover-7a32@gregkh>
In-Reply-To: <2024043049-divisibly-discover-7a32@gregkh>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 30 Apr 2024 17:11:51 +0300
Message-ID: <CAOQ4uxgP6gDTZWjsVvDF8kFqCihSccmyXfzkxTgNs--rrdaOfg@mail.gmail.com>
Subject: Re: [STABLE 6.6.y] ovl: fix memory leak in ovl_parse_param()
To: Greg KH <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>
Cc: Jingbo Xu <jefflexu@linux.alibaba.com>, stable@vger.kernel.org, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 30, 2024 at 10:53=E2=80=AFAM Greg KH <gregkh@linuxfoundation.or=
g> wrote:
>
> On Tue, Apr 30, 2024 at 11:48:54AM +0800, Jingbo Xu wrote:
> > From: Amir Goldstein <amir73il@gmail.com>
> >
> > commit 37f32f52643869131ec01bb69bdf9f404f6109fb upstream.
> >
> > On failure to parse parameters in ovl_parse_param_lowerdir(), it is
> > necessary to update ctx->nr with the correct nr before using
> > ovl_reset_lowerdirs() to release l->name.
> >
> > Reported-and-tested-by: syzbot+26eedf3631650972f17c@syzkaller.appspotma=
il.com
> > Fixes: c835110b588a ("ovl: remove unused code in lowerdir param parsing=
")
> > Co-authored-by: Edward Adam Davis <eadavis@qq.com>
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
> > ---
> > Commit c835110b588a ("ovl: remove unused code in lowerdir param
> > parsing") was back ported to 6.6.y as a "Stable-dep-of" of commit
> > 2824083db76c ("ovl: Always reject mounting over case-insensitive
> > directories"), while omitting the fix for commit c835110b588a itself.
> > Maybe that is because by the time commit 37f32f526438 (the fix) is merg=
ed
> > into master branch, commit c835110b588a has not been back ported to 6.6=
.y
> > yet.

This is strange.
The 6.6 backports were posted by Sasha on Mar 2024.
The omitted fix was merged in Nov 2023.

Sasha,

Do you understand what went wrong?

Thanks,
Amir.
