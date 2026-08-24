Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981E1366057
	for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2026 09:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787563814; cv=pass; b=NjwtuB5ILiWgpvLN/FRb9q2H94qSbX55oFDAyEQE+zPoqNrkxlr6J001WikDr8C9e7quw09JNikKD3JWq1232FlptJQTLS3C3FhuM/shDexRE8B/t7Pe4oVPIoy/nxKBkdAyxh/R+tTkCDJAj0HKIc4hY4NBEEObfcBggBcTBJI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787563814; c=relaxed/simple;
	bh=brmLQf8Ed8VfxPCT2os6/hcl71lv3/FJdsG3MvxPLeQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kCdbtMldXoU3CDQ2ubepYmDdX7Nqee5AF4EpytnIh/Q5bzeI9xwESg6IdV8s+pMGMlVrGeu667jaHqWuxfqEup/QwTR8d7O691sC/O7UZNyYHm58g6u/4F/nhwUn3Ln6RUcy2a/960S7tHPxKgMGM4Ae6vrTIX6Py2OfN/J0cIM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ccD+wHQF; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ccD+wHQF"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a173ad7cf4so5886292a12.3
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2026 02:30:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787563811; cv=none;
        d=google.com; s=arc-20260327;
        b=JzF58fc9XNeXzoU+8mqEGtLquZTn5VaevnFAAE5UmcTcT+vOfn5+rfzdMce8ja6cJu
         d1T+R/Tf6pzHG/mcJvimS3jPAhcU5SNtzThrGurc3yqYrKbBN8/oBT58fnFS87a/oPNm
         4rk4CrcD/k6ApWKb4cnIZzwla8YxzrXYqH0as9imsDN2xdUHXj7JE2sW3UkYC3Dc+VCb
         SH9gIeCIxDwDEN3xdvz9knUfM+ITLT70fIJEvjwP2hwh6q6u/RLJs/9v19XEwRsZ+HqJ
         vVlvKaQNI3RQBVzNx3S06oBj7gATpziakQeYI9+jGysUPo9EnR5xnp/Tj3xSn7EmIjAJ
         kI8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7Cuoes0/u76ZhjwH4LcYvrenr83FUTPinmsVWqM0LPs=;
        fh=6QuYF1Y/VLwmeJPZxvQIy6V40SQ0M0lH0gtlkdssOWA=;
        b=ZvD5KLhmtnNTtjv5NviCWS6xWJQDM4ocB45UxTNGq/Lr+gytbSiu97wdwTaFWEaZEl
         xVC71NLEXwNXw/6XX4QIfsfS5eQ6SNWnhFiwrb6viAirF1cVwS846M+Bbt+mqM8sqo7j
         jUTY4XsZy3AQJ0ZW7n/5lV1mCYQjJ24f8tgs2X+biT39z2Eeck94StbcLQ0672FuW0xa
         AzOsyB9CVOeGOdmTwh+gyiDXlEhPnEPl2v9dF4tO5Q2mvKmSo0bOYVUYbLpjExM/S8iy
         N7tSjSuVRnAzjlY9Ucs7v5zb6t7kJNksqoh09AQ8oML2j06BmoD3oxsKCmSdyzYIY1Pz
         s1tw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787563811; x=1788168611; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7Cuoes0/u76ZhjwH4LcYvrenr83FUTPinmsVWqM0LPs=;
        b=ccD+wHQFppTGjAPnzm8MQ+NI9E1DokSwtLfSNsBTNZWk3WRoJaAEyZ2TDgT4JhndAi
         DidLiV+kIAMhNu7OvcfuB5PJ1SVBqqlzZfInSRVZQ3OnhCCFWuAmYbn2O5ULIpHmIZhc
         lat2w2Y0i94oPP0o9eMQAgi/wlRJPW/pCPXWrRal2IHSjXir48gPchOt6+8IQDHlL4RT
         hmyP1J6CAWsX0yUGvvTQCWT9jM3eXs21gCpSExcKII/5lA8ie7cAhLq+OwbtlPk8GJSQ
         ELmIE1ltQSRorLzlLqQX6asAhVg2NMRUj20Q8V016ZnfjLagRUlDK3e5+J2pXUuu9SqO
         fMKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787563811; x=1788168611;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7Cuoes0/u76ZhjwH4LcYvrenr83FUTPinmsVWqM0LPs=;
        b=fPVCvJVIcwlV2rSAtT6b+pp+lpUG/VHv31n1su96r4foZ28nD3CeN458fIE/KBA52X
         haW5DfMUsZhc54II8WvnYuI4HzPw8GALOIfMRrXURZgC7ZD5owQRrZbAvf8SC/d04tPT
         7wY0Gi3ZzkdyauwTPQEnzHQwD3+uCnP2hwyL38IcNSaYeYQ81uqBO0tjOu1ybs3aWbIU
         ivLbuvcaMqK4nW4aKUI9GGHK4OGfbNV7XR3wxRJs56ceuOb/3IyegjogPi9AIjqnj9Ke
         uyAP7A7Pme8uOHinEratJs6T8xBfwMehZxvz9s9v9edbH/BsUETKTvKG5GGjFjR3QDEU
         NYLw==
X-Forwarded-Encrypted: i=1; AHgh+Rp3FegVJqYBmrEBafHr6t9OPNrHOMQkKeU/lBuQzTZqIZI2p2gsqrPPXzQM9Xxcp3gu4jyhrKNmZezROmEy@vger.kernel.org
X-Gm-Message-State: AFuF++nvN+1W6Xyy2i9tHJzOMUbaZykFPyJ+1+7ARz1JYKXLN+tlvXf/
	cAzkdTtTDGrkaUOhWohj0rbllvsV5DlD+MBWtMnTbbMVsaSu4zP1Pc0gGEyOwtLHj/JS6TsEfkD
	aCg+kU08CGBCqJ+h60p7/sgwpR/ECSTazYPnvQTo=
X-Gm-Gg: AR+sD11kdj6bnEgSbUcFZFdGLTC/TWz4cNOTHXKIflHEMNuZA7yYQJ5+1H7jVKwxe5r
	KxvQoTXejyORXoPZes9BYrNrNskMg6liP9rNHvg3qt0Xnmi8ud0fbf4M12hsP/QQl5UEFtouCwm
	B73UXTRCs11Z6L4tTcD4XWvXkBFEm1C7QpM4No7E9s9KES2+Gbm61C804egEpKu02ymK3iukkjn
	x1JEbxvFfHfKogzy2gBP8OFyTb93jTzBG1/LgOdwDqO+V2KzqdTyN4MhNA4cY+9sDYYuyG0On/8
	j6GUKXCjI9mig7gAZTcF3RbYNHUv9CByoi2sjChz6YmTIw==
X-Received: by 2002:a05:6402:50c8:b0:6a3:87b7:b516 with SMTP id
 4fb4d7f45d1cf-6a582b25777mr16233772a12.6.1787563810723; Mon, 24 Aug 2026
 02:30:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2026082150-autograph-perky-e3cb@gregkh> <20260823224256.2724025-1-fahad@codepure.com>
 <CAOQ4uxjhfpNVvoVrTayj46H2CViTOc3oxzM6xdb8+E7ikE2CSA@mail.gmail.com> <CAJfpegt1WinKmP5nOGv8Yx9VLf4Mk1ojg7e3xR5iUz=7yDAh0Q@mail.gmail.com>
In-Reply-To: <CAJfpegt1WinKmP5nOGv8Yx9VLf4Mk1ojg7e3xR5iUz=7yDAh0Q@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 24 Aug 2026 11:29:58 +0200
X-Gm-Features: AcwNN1XVLKbFP8dr-hAbBirsTfQuoNWIUIkzX0_mRSZPcTt9zWTctpn-bVvcDsQ
Message-ID: <CAOQ4uxj+GRa8CaCONwPQzLCjx=R8MRr6PTYYC+QW7VrK0PEhMQ@mail.gmail.com>
Subject: Re: ovl_copy_xattr() can write uninitialised heap into the upper
 file's xattr
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Fahad Alharbi <fahad@codepure.com>, security@kernel.org, 
	overlayfs <linux-unionfs@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2026 at 10:49=E2=80=AFAM Miklos Szeredi <miklos@szeredi.hu>=
 wrote:
>
> On Mon, 24 Aug 2026 at 10:29, Amir Goldstein <amir73il@gmail.com> wrote:
>
> >     size =3D ovl_do_getxattr(oldpath, name, value, value_size);
> >     if (size =3D=3D -ERANGE) {
> >         size =3D ovl_do_getxattr(oldpath, name, NULL, 0);
> >         if (size >=3D 0 && size <=3D value_size) {
> >             error =3D -EIO;
> >             break;
> >         }
> >     }
>
> Well, the whole retry loop is bogus.   Just use ovl_getxattr_value().
> That one could be fixed up to return -EIO in the "size doesn't match"
> case.
>

It's not really a retry loop, it is an opportunistic buffer auto grow
loop, see
e4ad29fa0d22 ("ovl: use a minimal buffer in ovl_copy_xattr")

Thanks,
Amir.
