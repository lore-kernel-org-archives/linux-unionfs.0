Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7CC19CC2E
	for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 13:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742910388; cv=none; b=rCr0X+06TB5xoHc01uaSlTw0EOd6U1g52VFRTzOxN5x3h3zozMmMj3WapVR2A2qvynXD2szKbBq6lOUiVRJPtGkCge63eVFU1YOYxySEZvA1KtrOQZS6ll5r3JLS3ZTmyvovKE+Vi2amG8nxn4X2V8RguJMV14Nm+Tcgyfxi/Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742910388; c=relaxed/simple;
	bh=mvsCn7sUzf5gZC7tZyC3+OYP4ixjXvgJxj7BoX2WPHQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RP7KxxH2cTd6LOTiA1j3msuNGJ/XGtxwR2kTjrc3aZpFPfhTQABL1d5euumTlj4SbCPtWnPz/FptwigOPk2iFZ4FSbyJ0D8tCkB+DlayPrEzK6wKquXwtNTA5aZoHinXwVgsA1zytocICyP6qnz0KPNYSwmESdo5i+KPqV+BTQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fb/yWQEC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fb/yWQEC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742910385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UEixVZlgDtvXsNJJVSS/WZZohk0QEnKwwNmHA7U3U/s=;
	b=fb/yWQECbQ9X7PBAblDiisXr4fyNPLQvBG/ChapvSnvHHbfl5iFPBNAYao+Pk/MgzuLlCz
	uXdhvYX+7h7s+89bkgD/jEOTmzk+nxW4r3Oxf06XGQeKgiw1Lm4odMMtP6lzDjl0IjlM0N
	9zRCwtqd0LAmQnbm0LJxkYlZZ+AuyJQ=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-ngeFNgauOWKxUSLkl3r-Lg-1; Tue, 25 Mar 2025 09:46:23 -0400
X-MC-Unique: ngeFNgauOWKxUSLkl3r-Lg-1
X-Mimecast-MFC-AGG-ID: ngeFNgauOWKxUSLkl3r-Lg_1742910382
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-30bf67adf33so31707431fa.0
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 06:46:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742910382; x=1743515182;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UEixVZlgDtvXsNJJVSS/WZZohk0QEnKwwNmHA7U3U/s=;
        b=oB9K6ioMdcp+sTxA7P8iOwC5mkg3ROnGFhRlEhgIVgrcIP0fNfk5fF/qvPXnGbaDz2
         CPI+W7SfGbIcTEaQ2JmVrygeTwpaggVKQRMuDiqUg76pzG9HTqxwGqvSnryar40RW5jI
         nQE7IjJtvZ40mC//l/flLpMrYjvYjdsaSFqKo256xMWuSLZfIoCMXCzNNnmNWZd9r1Cs
         Gne6dKJPtfbLYMxMmEVIZCyDKAA2mkaIwRx5YvVvEEkgdweM2t8ngYQ1HxXFfB6ZurWo
         rUlNIeRVDasXrIK575S+CVOyOdiarIt7lS7X+LeIRSZFysbeEieh1j8TZm4t/38+dSdW
         NBEA==
X-Forwarded-Encrypted: i=1; AJvYcCWoKyLrp3r+gO/yI+cPc5I9aH1liQUycNfXhffD+WaA/87bSMp+yurxAb4Qyknbq40Dwfd7iGoxdJoKgq24@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/W5oAMz+Tt4XVti3zgELGxE40v8ykGM/hTz41HGPClAvBXBeE
	jjhsd0+Hwb3CMK8EjryQKZExyRGWxejqYKegL3MIRkQ8DnQrvDLhmwe/xAo3l9xwBK6rNg57C1P
	J6KlZ4/ok9GxddC8DLsuR9rYolLy9mW/05xsBjCH523hJWYwxilIgBmor3XvYHFQ=
X-Gm-Gg: ASbGncsjtIKyUpmKovC0kE6rApL9XcNkQNKKv2xaBEwAx2ld66t3Q2eXjBnxaYiPP2T
	Xtu9fpHTyAWOvul7Jd2dU4lRf8aPBKP5OOuoXLPYI6S55eNhz5Kqf8hYti2myBRdTWdljXeVVtl
	S+r5O2xm5jCBsSlEZrjcPG8eXHwrOVhIB+aF1RtjtBD8UcNOX2o2t8UqoRvdiRtIwWFSMdfBfnM
	hjKZAY/wVf5K/vG8MvC/dGMdSipBwSFaC9YD4qWyPSeIwoEQxvxlhiLUN2C26NzNTwFGSDZM5/d
	7Zw6RGcWr009lM1RBud/YTcXEoDb1gds5y40A99lMjoUlzlEunCzoos=
X-Received: by 2002:a05:6512:10d4:b0:549:50da:7ac4 with SMTP id 2adb3069b0e04-54acfadccdbmr7278150e87.18.1742910381987;
        Tue, 25 Mar 2025 06:46:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH03BeLa7nfAfLGIO6qa0QnyqiUOxR+c1gvqRXPZVP2aONtaG11sBdpFI1PQfly/DqPJhYz4g==
X-Received: by 2002:a05:6512:10d4:b0:549:50da:7ac4 with SMTP id 2adb3069b0e04-54acfadccdbmr7278138e87.18.1742910381495;
        Tue, 25 Mar 2025 06:46:21 -0700 (PDT)
Received: from [192.168.68.107] (c-85-226-167-233.bbcust.telenor.se. [85.226.167.233])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54ad6508158sm1505271e87.185.2025.03.25.06.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 06:46:20 -0700 (PDT)
Message-ID: <5cd880ed009985cb2c85cd5f755e72cc6b595f25.camel@redhat.com>
Subject: Re: [PATCH v2 4/5] ovl: relax redirect/metacopy requirements for
 lower -> data redirect
From: Alexander Larsson <alexl@redhat.com>
To: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, 
 Giuseppe Scrivano <gscrivan@redhat.com>
Date: Tue, 25 Mar 2025 14:46:18 +0100
In-Reply-To: <20250325104634.162496-5-mszeredi@redhat.com>
References: <20250325104634.162496-1-mszeredi@redhat.com>
	 <20250325104634.162496-5-mszeredi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-03-25 at 11:46 +0100, Miklos Szeredi wrote:
> Allow the special case of a redirect from a lower layer to a data
> layer
> without having to turn on metacopy.=C2=A0 This makes the feature work wit=
h
> userxattr, which in turn allows data layers to be usable in user
> namespaces.
>=20
> Minimize the risk by only enabling redirect from a single lower layer
> to a
> data layer iff a data layer is specified.=C2=A0 The only way to access a
> data
> layer is to enable this, so there's really no reason no to enable
> this.
>=20
> This can be used safely if the lower layer is read-only and the
> user.overlay.redirect xattr cannot be modified.
>=20
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Reviewed-by: Alexander Larsson <alexl@redhat.com>

> ---
> =C2=A0Documentation/filesystems/overlayfs.rst |=C2=A0 7 ++++++
> =C2=A0fs/overlayfs/namei.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 32 =
++++++++++++++---------
> --
> =C2=A0fs/overlayfs/params.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 5 -=
---
> =C2=A03 files changed, 25 insertions(+), 19 deletions(-)
>=20
> diff --git a/Documentation/filesystems/overlayfs.rst
> b/Documentation/filesystems/overlayfs.rst
> index 6245b67ae9e0..5d277d79cf2f 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -429,6 +429,13 @@ Only the data of the files in the "data-only"
> lower layers may be visible
> =C2=A0when a "metacopy" file in one of the lower layers above it, has a
> "redirect"
> =C2=A0to the absolute path of the "lower data" file in the "data-only"
> lower layer.
> =C2=A0
> +Instead of explicitly enabling "metacopy=3Don" it is sufficient to
> specify at
> +least one data-only layer to enable redirection of data to a data-
> only layer.
> +In this case other forms of metacopy are rejected.=C2=A0 Note: this way
> data-only
> +layers may be used toghether with "userxattr", in which case careful
> attention
> +must be given to privileges needed to change the
> "user.overlay.redirect" xattr
> +to prevent misuse.
> +
> =C2=A0Since kernel version v6.8, "data-only" lower layers can also be
> added using
> =C2=A0the "datadir+" mount options and the fsconfig syscall from new moun=
t
> api.
> =C2=A0For example::
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index da322e9768d1..f9dc71b70beb 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -1042,6 +1042,7 @@ struct dentry *ovl_lookup(struct inode *dir,
> struct dentry *dentry,
> =C2=A0	char *upperredirect =3D NULL;
> =C2=A0	bool nextredirect =3D false;
> =C2=A0	bool nextmetacopy =3D false;
> +	bool check_redirect =3D (ovl_redirect_follow(ofs) || ofs-
> >numdatalayer);
> =C2=A0	struct dentry *this;
> =C2=A0	unsigned int i;
> =C2=A0	int err;
> @@ -1053,7 +1054,7 @@ struct dentry *ovl_lookup(struct inode *dir,
> struct dentry *dentry,
> =C2=A0		.is_dir =3D false,
> =C2=A0		.opaque =3D false,
> =C2=A0		.stop =3D false,
> -		.last =3D ovl_redirect_follow(ofs) ? false :
> !ovl_numlower(poe),
> +		.last =3D check_redirect ? false : !ovl_numlower(poe),
> =C2=A0		.redirect =3D NULL,
> =C2=A0		.metacopy =3D 0,
> =C2=A0	};
> @@ -1141,7 +1142,7 @@ struct dentry *ovl_lookup(struct inode *dir,
> struct dentry *dentry,
> =C2=A0			goto out_put;
> =C2=A0		}
> =C2=A0
> -		if (!ovl_redirect_follow(ofs))
> +		if (!check_redirect)
> =C2=A0			d.last =3D i =3D=3D ovl_numlower(poe) - 1;
> =C2=A0		else if (d.is_dir || !ofs->numdatalayer)
> =C2=A0			d.last =3D lower.layer->idx =3D=3D
> ovl_numlower(roe);
> @@ -1222,21 +1223,24 @@ struct dentry *ovl_lookup(struct inode *dir,
> struct dentry *dentry,
> =C2=A0		}
> =C2=A0	}
> =C2=A0
> -	/* Defer lookup of lowerdata in data-only layers to first
> access */
> +	/*
> +	 * Defer lookup of lowerdata in data-only layers to first
> access.
> +	 * Don't require redirect=3Dfollow and metacopy=3Don in this
> case.
> +	 */
> =C2=A0	if (d.metacopy && ctr && ofs->numdatalayer &&
> d.absolute_redirect) {
> =C2=A0		d.metacopy =3D 0;
> =C2=A0		ctr++;
> -	}
> -
> -	if (nextmetacopy && !ofs->config.metacopy) {
> -		pr_warn_ratelimited("refusing to follow metacopy
> origin for (%pd2)\n", dentry);
> -		err =3D -EPERM;
> -		goto out_put;
> -	}
> -	if (nextredirect && !ovl_redirect_follow(ofs)) {
> -		pr_warn_ratelimited("refusing to follow redirect for
> (%pd2)\n", dentry);
> -		err =3D -EPERM;
> -		goto out_put;
> +	} else {
> +		if (nextmetacopy && !ofs->config.metacopy) {
> +			pr_warn_ratelimited("refusing to follow
> metacopy origin for (%pd2)\n", dentry);
> +			err =3D -EPERM;
> +			goto out_put;
> +		}
> +		if (nextredirect && !ovl_redirect_follow(ofs)) {
> +			pr_warn_ratelimited("refusing to follow
> redirect for (%pd2)\n", dentry);
> +			err =3D -EPERM;
> +			goto out_put;
> +		}
> =C2=A0	}
> =C2=A0
> =C2=A0	/*
> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> index 1115c22deca0..54468b2b0fba 100644
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -1000,11 +1000,6 @@ int ovl_fs_params_verify(const struct
> ovl_fs_context *ctx,
> =C2=A0		 */
> =C2=A0	}
> =C2=A0
> -	if (ctx->nr_data > 0 && !config->metacopy) {
> -		pr_err("lower data-only dirs require metacopy
> support.\n");
> -		return -EINVAL;
> -	}
> -
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
=3D-=3D-=3D
 Alexander Larsson                                            Red Hat,
Inc=20
       alexl@redhat.com            alexander.larsson@gmail.com=20
He's a one-legged overambitious farmboy who hides his scarred face
behind=20
a mask. She's a psychotic communist mercenary who don't take no shit
from=20
nobody. They fight crime!=20

