Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F06418A21
	for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 09:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784798474; cv=pass; b=epS3YXWem/PpZaKQNOX7zSX1yn8c6QKnOb90k9q1w/D+BNz+sYYHyyjIt6+gLW4WwKh4FTKw/GDgQyPR11p+kfjYzPG8mOOdlcJSLTloNUp0ZhdbwTmmLnBWSfk0lrahBihJwx/dckjvrjV1Hw4+3TscxXaJtC7ZXbjvH/nkfR4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784798474; c=relaxed/simple;
	bh=sGg6RHbGOFfY3wrPJw9iaoWvo2EuJQxmnM6MAF2FK6s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jMxLpdWT/So4vp9KfFGaJdjutFjJj0pTKylO4vAyNd2bBQWLnjnOYK9edu/+Zc+Ay7vuY+nms5GO078zYYGdivChrzC0AsarLoRoGfjl1aPsA3FEhs95oI7Eu4wEfB0IOnoCxDKMtwyjYKLAdLL5WYwTBGheCSzwzdnS9DUT2jg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g/chcEIJ; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g/chcEIJ"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-698e5859a3cso609171a12.0
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 02:21:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784798465; cv=none;
        d=google.com; s=arc-20260327;
        b=Lh9hBRifLiJf5pzMlIx2qZxK5ZoHNGrj2ou6fid1YRrJIeqL4XaAf5TwqKlS4ikBsr
         T3jbZ0bsL2qwuBK2T7SiOCFVHcFnb0HHTK5aFEqIUhTPd0jCYhYGJ9d/PodMy/cpNBRs
         Idx8yT8ihLgIebzfnVwm8DQmNHEzlFB0htevO8E9d0RCKmDrBz5QCRHtthALtLkN20Iz
         HA+N5+4aiiV6iD1ltfMnZ0u/SoTlJrCdP+xvBLFsgCvCLCKPX7ezUkXUeZK5PWYNovPH
         j79ahjTbp3uzI2wNh8XRL3R8bDp+NEvk78lCjfnko7ztO1J9LnXDoKuGRAacFdh1sJ+q
         IgKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QUS1duImiuxRUZ48Ef5krHiYH/CmsP1C8hfnRFBWu6E=;
        fh=62vitDa0emw0bBr/MTfKtLoMhriCcf0U9ESRdEXr5qc=;
        b=PMdoMUT99a4mximAc9xLpPBDjJi4atdivKOJYaZG2AHJAN54S6MTbiJ9sePPtDPB5u
         tpLFBkRjZNoLloh1zEoGhXrqKyjLeN5dDnrVYNmnQfyzIPfWPx0HsjnDvZBhHQmDhwca
         Z+ekcO4OYxjrO4YvOL67wDVljHyhWjOeSTxrPDA/HSPE+rtK2ge8GOoSSzE98C82qa7R
         JJYU/gT1pa2nwTNGFLbPs8mgZSoG5OXK5pscfL70nxV61VW2hUV5jIh1CHE5wUj7MOU9
         i4ClI0NdCx8psPc0tkthQQjlU2x/6y5tbz3JPKpfI0dK9zGFZei8LEHk0EtulVocsYsb
         HVUQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784798465; x=1785403265; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QUS1duImiuxRUZ48Ef5krHiYH/CmsP1C8hfnRFBWu6E=;
        b=g/chcEIJ6/GuA081rNIAaKAaWX/CudeYHOxgArtcCJwkdcODlvQWpmc6AToa0FezFB
         c4Ww/SsHx2f7aIzZogx9iA46Il/dSKyEsoiMbglDvkb3erWvpix3+UIpa1fMsca9ACql
         8p02kztGDe3G5binL/egF7FcyOgO/RD2+PD8ueffzRXu6Bs8TETxxj2+TFVw7SUwGd9M
         bAY5PByaDoUgs3y84vKm9xSkd4DdfBimj60ERjE63BZ8fbDQSUgqtMxRXKIMNdoPU388
         nblSvNNqfdXi2OLmCzSOdhqT2uQwclp1bncG4vKEUJuV321S5AFRWGZK+KuZ1RGGTy7M
         fbHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784798465; x=1785403265;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QUS1duImiuxRUZ48Ef5krHiYH/CmsP1C8hfnRFBWu6E=;
        b=aSj+54y6OFAwpVwIspY458f1gL9tf4StZs6GtpsQaFnZyUZlK4uFmaJ3up+SXS2Wys
         ZPFFrs/3cKACtizguB6Q8jy2YqTcKyjpYPMV2bEOTXfb0udc02Gw9zJBjozsOKzqR4Fu
         IFrYZdOw6rePkLylagvzyYjzE6wbPwFQa7OJyY2Oaj9orhG6xJC2grngc7sp/MIRUJEG
         mCaTAxWpzarkndunNdn7ykRnjocHPgvSleEeGIksUOev6GzHrc33yM/paR9SYKRBcVxt
         cd1bG+h8IXR/bqbhgLL/LQRxUm0C02lzEUk0nqYNOCS84OIaXXO6p6Xh7BIvYtzY8nJg
         YgUg==
X-Forwarded-Encrypted: i=1; AHgh+RpJEcVEepUo/R6VpsHcN19t1vQZo3ABymL8iz5KIzyd29q4Uc+16VswUZDW7K6uYzs+XzLZfDyHdw8TPoxF@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9Www0GufRJlFi07Skob29P5V1+lTwsZHuaNaHaoB5371KXcUq
	7Dg0RdifQruDdtR7v27qZ5TP6O+ysM+xKOpWb4cXd2BVAFAbmXAHZKJYCT4kBF1gtcvlVA9IOCG
	ehueY592KIBMtoOf1Bl6J5SQHHiXjNyg=
X-Gm-Gg: AR+sD13fstvRcbo+97wVuByiUBYSm6sBjVUCu/RcYd6v7OiUP9JI7tKAkVErF8hxbwh
	YX3+UeGCxwxNZwwZT7zSPZqKCqCOHc4sSS7QZUj33RENTwEK/hEJ+oLP+eStWSPRuLUdvz0oDWe
	Dpu9xr/QEZ56yMTXYSRDGjaWppSP+VBe/yxeAmAcVG+KRekvqrmUf95WNHRUfzoHHfHonFtv5v1
	gIbeAuu2Bbn0Z2zKv2vJpZJkqzeGaA0WnjsnnJjJKdVv6i4t8OUvXYjDO6zRec=
X-Received: by 2002:a05:6402:2c5:b0:698:a9fe:2eb3 with SMTP id
 4fb4d7f45d1cf-69f7473bb1emr481810a12.9.1784798464605; Thu, 23 Jul 2026
 02:21:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715101107.973997-1-mszeredi@redhat.com> <20260722-fundort-zogen-kormoran-09fb867f1b59@brauner>
 <CAJfpegs9Mzx2bPTmWWzGWv7D2jF5Nspns-U6jf=KeAufiFMXyA@mail.gmail.com>
In-Reply-To: <CAJfpegs9Mzx2bPTmWWzGWv7D2jF5Nspns-U6jf=KeAufiFMXyA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 23 Jul 2026 11:20:51 +0200
X-Gm-Features: AUfX_mzGhC5ulgDl4H2_S8AB0-LW8RqyX4r61JB4nfZ8oT5YdWhv684RFp1OggQ
Message-ID: <CAOQ4uxhqmh47w46x0zhOzqJ54iiL0KDpuuAqr2oPyjm4AOgDYQ@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <mszeredi@redhat.com>, 
	Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

> > And the smaller details really show how inelegant this model is and why
> > Al and I have opposed it multiple times before. Scalar options are
> > modeled as symlinks and non-path options are dangling links whose
> > readlink still returns the value while for path options readlink returns
> > the option string but following the link jumps somewhere else entirely.
>
> Hey, this is was a prototype to show that this can do what Giuseppe
> needs.  Not with nicely polished interfaces.
>

I want to do a sidebar regarding "what Giuseppe needs".

As I wrote I am all for introspection of overlayfs layers, but I was never
fully convinced that getting an open fd was the correct API.

The starting point of the use case is a userspace daemon that wants
to reuse mounted erofs images, which are used as lower layers.

When considering a single daemon (e.g. composefs) this reuse
would be better done completely in userspace without kernel involvement.

The reason for a need for kernel UAPI for introspection of layers was
to allow cross daemon optimizations, so that containerd could reuse
erofs images mounted by composefs.

This optimization works under the assumption that the image file
or the image file hash is a unique identifier of the desired lower layer.

But what if composefs mounted the image with idmapping or some other
property?

And how many container runtimes are there out there?
Is it really worth the elaborate effort to provide introspection
to this level?

My intuition is that introspection should provide static information
like uuid/fsid/fhandle rather than an open fd.

I am willing to be convinced otherwise with the proper arguments.

Thanks,
Amir.
