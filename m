Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD615BADB
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jan 2024 10:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706004191; cv=none; b=F+vhUI+ehqJ+NTwZ3+lm4Ppd17Dw5oARJUQrQ7/Uf9okqT2TVkePJZJH3uiXNp2GwU+6/6c+66VVZdi1kOVUHMl1UaA8JMraGgoo1Rp0uWmAzW+vJCIqtMhUaJ52rUqmxC/XQOmFe1azBz4OYMnHIgdYs4Kt2+wvFlkNME1gcTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706004191; c=relaxed/simple;
	bh=DRzjUZpMnEyfYqnK/hMFJEZVdgXSRjS2y2t9cPDyl10=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cL0TFY5bliBntvKChRF0pqW1CYy6qQF+Wg5Cw5X75EkEyRYFMPpjEsZwjEllijBktp/zms3LFuIIIRnkaJUHaWWXJyY2osGDvuD5reD38pRo/q7xghE4jCZv2yhBTzqxQ+mOQAa+NtRXL7hQtBA6eSXARAhGuDNgh0C7Ipl+ZYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=n0ILPl0o; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="n0ILPl0o"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a2e0be86878so947101366b.1
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jan 2024 02:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1706004187; x=1706608987; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ae43qYI14FBpis8rKaqyzt3celd9sPypnwO7KLQNdI4=;
        b=n0ILPl0oR86WGa6qVuhYP4OiyV8sr0q3It0iwTMxiZACFMzK1NBl7P/Pdtciej+7UN
         +zbgA2NeorwQG8613rUMt7A/Yq2BXlDFNZ5h6qi3AdwXVrGzKtM+iFFW6Vxct84rhW+6
         pIm1QfXlhokVuooR3advBCWKQD0Kh5z80VOnQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706004187; x=1706608987;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ae43qYI14FBpis8rKaqyzt3celd9sPypnwO7KLQNdI4=;
        b=G4vFK+p6an8MIUXogxTvAepFtsbR3WC9PAzpjZPgzIT4e06acQQHIYkOsie45uRNig
         Z5ppy/xYEPIvYRBVOZm7v4pwucat16ojCvtPIsnHOHiEreiuod0C5mxTKfrFCduNOz2w
         H8e+3/3lzOQ3n72gFuiZILxw6OxyetinJZwtP8R8RnYhX01pc1YzpY6snCAF9AxMnv2H
         H+6UojI/ilJdmQ7V6wufe+/h7kcu5kunhdD/sHiE53R9y9Ul1gU8Y08oVDtxgIgT6oiM
         PMLVrv6xJanh/wCc6oUCnOUNIruDvxBJVc+xUlNDe9xRYh4v148ou3VlHOT17lRyC/om
         0+aQ==
X-Gm-Message-State: AOJu0YxFllMCCtbeOQi74fFEvNIz3wahsVIYDa78SNOBrQ4hKw9tzdYh
	lFkm7PW2kjRmrEPNDbeqhg4Lp7SPNslfbfz5pF1T4l1sRyQQd1BktwHtXe8fpG49/LnfgygW2YT
	MozLTe7cmjEynHAc9donsl1KaShlEb0cApJUNrShniReDBLyn
X-Google-Smtp-Source: AGHT+IEbPHoG1y+IByNIfpbRvMCEMwuBBbZKM755BlK4boHMIxdkvIMBiVZ1/RZAU6h2OnLnYUXlqOd0039r7Mhnwtw=
X-Received: by 2002:a17:906:2ada:b0:a30:d9ee:3db6 with SMTP id
 m26-20020a1709062ada00b00a30d9ee3db6mr337360eje.51.1706004186703; Tue, 23 Jan
 2024 02:03:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240122195100.452360-1-amir73il@gmail.com> <734d0570edb1a8150c902e6bdd509b597deea186.camel@redhat.com>
 <CAOQ4uxhQtCXPNzJcmnsH_B6_zM7JrTnUcmjrTxqLstkVcFdz6Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxhQtCXPNzJcmnsH_B6_zM7JrTnUcmjrTxqLstkVcFdz6Q@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 23 Jan 2024 11:02:55 +0100
Message-ID: <CAJfpegtJk9zU1PBzwaTtgOk=s4s2O88V1o4e-2oTS8tXQ534ag@mail.gmail.com>
Subject: Re: [PATCH v4] ovl: mark xwhiteouts directory with overlay.opaque='x'
To: Amir Goldstein <amir73il@gmail.com>
Cc: Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Jan 2024 at 10:53, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Jan 23, 2024 at 11:05=E2=80=AFAM Alexander Larsson <alexl@redhat.=
com> wrote:

> I think it does not because:
>
>     ovl_layer_set_xwhiteouts() is called before adding the overlay dir
>     dentry to dcache, while readdir of that same directory happens
>     after the overlay dir dentry is in dcache, so if some cpu observes
>     ovl_dentry_is_xwhiteouts(), it will also observe layer->has_xwhiteout=
s
>     for the layers where xwhiteouts marker was found in that merge dir.
>
> I hope I got this right (Miklos?).

I agree with the above analysis.  There's a possibility of false
positives since it just checks the intersection of the layer flag with
that of the dentry flag, and in case of false positives there's no
serialization.  But that doesn't matter.

The true positive case is indeed serialized by the initial lookup
setting both flags, hence checking the intersection is guaranteed to
yield positive.

Thanks,
Miklos


> I added this non-trivial comment above ovl_layer_set_xwhiteouts().
>
> > Anyway:
> >
> > Reviewed-by: Alexander Larsson <alexl@redhat.com>
> > Tested-by: Alexander Larsson <alexl@redhat.com>
> >
>
> Pushed to ovl-fixes.
> Pending ACK from Miklos.
>
> Thanks,
> Amir.
