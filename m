Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA285A0FF
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jan 2024 09:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706003603; cv=none; b=BXSKmebhCFXThQGQ5Ye4WlFkenQVLJNFDMUMO4Jz6yr84MNAbtMc5sZXl6CSpWjN4yEpXb7wjmg1Luu7uHMqb11waFAxx41p4PZ4yjL5cBlpHm2FT91a8/qrpjGS654TKOKswkcDN1SJCl4p3ra+U+BnKSDSTGWVNM41OceHMXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706003603; c=relaxed/simple;
	bh=Cbpe3b5vXyyjLTG+zI+azqnIl2h1tzJ14GXkq4CVGtY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jy0yNWVH2NMTfqxXw4DpIZnkvJcRx+tgjzCgS0x1FHmLu1GhS7CUa9DiVIArpQPqmzyvxbYNqX7hUQ4Q4var7laKvlKKIoL3+H+6deez+U4hey79reesP74qGscN8uQUkXtXqMX1vsHnerJrbjnZsPtPGmQHzqtq0wk7EVIpZ1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M4CzbPk4; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M4CzbPk4"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6818f3cf006so23799226d6.2
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jan 2024 01:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706003601; x=1706608401; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LpOJuHQzEtMr1MdirefjSIHRP62wbe/xwCPcpcV0Q0I=;
        b=M4CzbPk4BVlD4vhGxxGbeN53G68Yg1Exmz6VdUbR4Dh0qSQq8hA7dFKLN8inwrM1Vs
         1Yry2o+rVi6SCIrlSgVKQYDsuG1HuGTSeBVXLYNZDWBV29BWTkl5w2ex/AIWEAOpOruc
         93A6x+yUiFhDXo64FiPn961dI9YmGAVh+cpBjSZf2PGJQwn6dfT8MbEJsCf+L6rFou7P
         F7lP02KHpQpZYUAa5JWG17OGV7HrlOa57J6t8NXdereZsb7SAe4bhXHmfxe4l6o87blq
         MTVIZUalobAtgoiH6F3NuUMRCTiyvGqxB3lUdK9AAM0qxFzQOW5r2QS/YKdviAm0cmzM
         69uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706003601; x=1706608401;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LpOJuHQzEtMr1MdirefjSIHRP62wbe/xwCPcpcV0Q0I=;
        b=TB1CxwPf3i/FoIYYxUzVzovTatT9yYmQ62MmaZiLOfvoPOKhBsNJtViERdTYHrZ1lh
         5dgSzY8eFZaKv4avJklkYiYlLygUNqDBYxgrUFqoMuEqCoN0kHX3RF6Q7yqFh9tY3a0s
         84q+yVUjyWg2RdsoVSJ86yjmyOTjRsYLtiv07uNcB+57xrPgu7zJm4W78U1A+b8rOk+D
         q9FZRvIpg3YY+yZ9mPW3uWN5FoiXyJOqTNXUmbI3mffFV0VWVpRF4CHMgGabH10hhTyu
         Fk0ydZG0J6/a3NKlkl54NPq+Rm+D35PO517Adi8gTjgb60ZQVT0l0XlAXk5/W01doDnl
         MJhg==
X-Gm-Message-State: AOJu0YzeqvK16VUVE0oTdT0RQVMqvUliKuzKSD9o2wiyptPS1Ox2UIDI
	AUjocHKngPp1pjPQFp2532EGmxbpqxaZvanDxXNEtjcF7krOz/mY52w6kPtJM761RkYyvUlx+OW
	ErP9y2Iq86Mm5kDfK6uLkwd5+TNs=
X-Google-Smtp-Source: AGHT+IFbtWUk604LgaaSiJQKsJboxU3QVgckZQ5m3oWSGEhjFujvnguo1/gbz5zTepCXsqiJc9j776xfZmvYR1McnsM=
X-Received: by 2002:a0c:e353:0:b0:684:bab7:6bdb with SMTP id
 a19-20020a0ce353000000b00684bab76bdbmr534221qvm.128.1706003601022; Tue, 23
 Jan 2024 01:53:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240122195100.452360-1-amir73il@gmail.com> <734d0570edb1a8150c902e6bdd509b597deea186.camel@redhat.com>
In-Reply-To: <734d0570edb1a8150c902e6bdd509b597deea186.camel@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 23 Jan 2024 11:53:09 +0200
Message-ID: <CAOQ4uxhQtCXPNzJcmnsH_B6_zM7JrTnUcmjrTxqLstkVcFdz6Q@mail.gmail.com>
Subject: Re: [PATCH v4] ovl: mark xwhiteouts directory with overlay.opaque='x'
To: Alexander Larsson <alexl@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 23, 2024 at 11:05=E2=80=AFAM Alexander Larsson <alexl@redhat.co=
m> wrote:
>
> On Mon, 2024-01-22 at 21:51 +0200, Amir Goldstein wrote:
> > An opaque directory cannot have xwhiteouts, so instead of marking an
> > xwhiteouts directory with a new xattr, overload overlay.opaque xattr
> > for marking both opaque dir ('y') and xwhiteouts dir ('x').
> >
> > This is more efficient as the overlay.opaque xattr is checked during
> > lookup of directory anyway.
> >
> > This also prevents unnecessary checking the xattr when reading a
> > directory without xwhiteouts, i.e. most of the time.
> >
> > Note that the xwhiteouts marker is not checked on the upper layer and
> > on the last layer in lowerstack, where xwhiteouts are not expected.
> >
> > Fixes: bc8df7a3dc03 ("ovl: Add an alternative type of whiteout")
> > Cc: <stable@vger.kernel.org> # v6.7
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Miklos,
> >
> > This v4 is a combination of your v2 and my v3 patches to optimize
> > xwhiteouts readdir for the intersection of a dentry with xwhiteouts
> > on any layer and a layer with any xwhiteouts on any directory.
> >
> > Alex,
> >
> > Please re-review/test.
>
> Looks good to me. The only thing I worry about is the atomicity of
> ovl_layer_set_xwhiteouts(). Doesn't that need a barrier or something?
>

I think it does not because:

    ovl_layer_set_xwhiteouts() is called before adding the overlay dir
    dentry to dcache, while readdir of that same directory happens
    after the overlay dir dentry is in dcache, so if some cpu observes
    ovl_dentry_is_xwhiteouts(), it will also observe layer->has_xwhiteouts
    for the layers where xwhiteouts marker was found in that merge dir.

I hope I got this right (Miklos?).
I added this non-trivial comment above ovl_layer_set_xwhiteouts().

> Anyway:
>
> Reviewed-by: Alexander Larsson <alexl@redhat.com>
> Tested-by: Alexander Larsson <alexl@redhat.com>
>

Pushed to ovl-fixes.
Pending ACK from Miklos.

Thanks,
Amir.
