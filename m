Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442890;
	b=0m40fcd4XQQdetNzgltKpIQ0Cjbs4po/agziPnFnhrJAk7ZlKjWiShmxWOLuLRy7ML4W
	 NJrZ4BA1M6qKJaIOfpk+Eeu+8zGmo5k4tthGEUr05xbamyrbYMiDbwA0EmrsDad8FA69Z
	 n3lLWkCG2Mw0hkq1B3D6QHGZyp+BoHcJHLpkoMNvvCs6wUrwo3RgPIiMNekk8Gq2ES1b8
	 O8WwrXqhUp+L+JzJzAAO2/GB2TZ48wVm/rYz+KmCyB2Lcjl5z3P0848FTUHrDRy87WaIc
	 zWixQnHTBuOCUL9805SxMze9dIZC2UyFqJzEjgH5wHJrnhq3SPsgxgAoTMdS1PJsqjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442890;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=Uz1t2WKqlXJVIyc0jqpnA6TrFMwUBuQ3w8Lin5TW0wo=;
	b=CShlkoUMkR2QfJSKrAEwnpIXBdSCAaD45OmBbzzr90vAveqcVaV+2ERR/RSxw4ptLZts
	 3wKw/KItvubaBb12gUmEaZsYHK7NCo4MIHoAu8IpDZkaEnYL4duJyDahMveMYI0jpj5DB
	 wdl1uOlws5T5FtFgJ05o6N2uC36I+deYIPKOpEpA8E7ekZe4QipO9oeys6sGozRQAScOD
	 vN1xlOejaveMRN+PLKf+AFHWZTVaGk/5PekPYlW3ThCwg1GWl+4LRhQN1DYVp+9l56qFi
	 iQHI3xctaOmnW0E8HY6CZomP12gORQzuYRVMlB/COMy70wRXpNdwJ6SHakJ5U6deo3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=o1duoT41;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EE9606A321
	for <linux-unionfs@vger.kernel.org>; Mon, 23 Nov 2026 14:08:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58EE9606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=o1duoT41
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4bb6adaf0f1so29237155e9.0
        for <linux-unionfs@vger.kernel.org>; Mon, 23 Nov 2026 06:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1795442889; x=1796047689; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Uz1t2WKqlXJVIyc0jqpnA6TrFMwUBuQ3w8Lin5TW0wo=;
        b=o1duoT410yfYPOkeOEqglCp3ucRjy9hZ52w3OD/hNUBkzgp8+marZhEP9j2b9DSsKj
         rvOlrGrueumhV3qIVTe5RlKFFtSIlZx2CsoCJzzjIBoG7aQ6K9ckODNMmnM3CqWt/swZ
         HI0sYk1bTW6+xdK0aGcFvkAbtCYUPkyU6wy4fWN88qieSUneMUodWPbyRMiN9uEHWQuc
         pt1G6pPI6l9hZSZe3Y9ulmQzEvNpjgGvOSGZU8OS08J1C5wukblXL4yFduVFZOwPcofk
         QvWoOCyZq1RMKWUQiak2+o6FMkhizRkFnRTKSM/m8uFrNG0VOG3qeuN9myw6wFupglGA
         KNNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795442889; x=1796047689;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Uz1t2WKqlXJVIyc0jqpnA6TrFMwUBuQ3w8Lin5TW0wo=;
        b=xxLVSSYPwj+zuFbTmPK4VPjQsziSwJ+nISlT04r1i69xXR0N0UkKNhxU/cThZUazrL
         2I/oOO+BHkQAXX/GJukD0KfOYUdvbpdLW9beHhK1FQOiJpp9fOIE+dErcR9tjlcKo/Vp
         gP2COBv1BraKN7k/0BkucOvXimMnvKTaxSkuY4GwHk+7H1+ioRROvmP2w8feGIS0m5TB
         x0SiBo/eiCCRwQL8qg9q54yNDzdZpQicSJa8NX8gvOJvl/u86DeYFVGUiB1thW8WSdkJ
         3/zlqjyuJfQOmcCYBmjk5YR3JcdGfZNc9EeX/PnTMJC+6rg+Ie7iE0VzRVRyDi5v3Ho9
         ca/Q==
X-Forwarded-Encrypted: i=1; AL+hErFfzrq0wIrTDLbXp5ijP+mVPjt/KZ6jClPmCplyrhHZgeRjUqYedhCzD33iGa9KN1hos2rj7LaFc1pjYlLu@vger.kernel.org
X-Gm-Message-State: APuU4Z+K4/su+1VnIE3OFC4tX+jRylUKDo5fc7UIbPu0CFOzRNxrjI5Q
	ZXdd7PFkck0yUjbsp9ATW7JA8WjZs2DdJMf0Q9QcCPOtWVVLfINLePVDA0ViMJcuepTE
X-Gm-Gg: AZFdTZfQOjSUoA7wuN2UHFKabvOghQH0yo+zz5ZmIhm4aBOiuNKV5bU8D4rbm5rEY4E
	/nF61qM0RwWquprfZnsABpFlvr8bnP223D9KDaqtvbO4+yPs+eWE9Pp3KAFKV11xe63JrjryNZ6
	oSA2S+a2XRDdPgzYr6pLko4prj9e9OliEqPfRbPAZDN359sZlsHURnkuO6ToRK7F/dXAAvtyVDd
	0xEC53oOxjYojOSI89aIhl0NfzmXMYAxYOYX6vUaFqvUFer7IVekEswBqFw7Y6iUcZDWcmv1jur
	5iaRvs8c6WCNRv6RmYfLblKb4jGLU3wVDIxgsnWr67rLTS2/lP3MEdlVxQhltO73za2VBckTbGZ
	AWKNzb8nmAP8dxqFjE1Qru78AJrP9C3/4TPTGNdbao/dojjBnHxlNn/ZhED35oqhQDEozBccUoq
	EcE77dui8dewdA++ewktyYUZW7dDgBwizCcdFh6cPgM6MI4V/SIBZ+eqvLXEUGGJvnGMB2n7tPb
	Eo7r3af7+2F6RasZufrM6b8MZN9NZeYPfbAMosnsOBRlcNYbU23koU/NDMZdEZSjkssRjqzcLe7
	+H4okW37OoFh28nq1HI4XgOfuak/WlBUYVuiZ6OJaSIMEq7C8iUJfimBFluq/srGrjCUU6gwisP
	L3noHKouoYK7nIyL80p60KGkC8nlIWAfmwtNSPoVPtFG1D0Z6lvs=
X-Received: by 2002:a05:600c:3e1a:b0:4bb:6814:7391 with SMTP id 5b1f17b1804b1-4bb8881921cmr230462625e9.25.1795442888314;
        Mon, 23 Nov 2026 06:08:08 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:799:2965:d32:cc64? (p200300cf572c2800079929650d32cc64.dip0.t-ipconnect.de. [2003:cf:572c:2800:799:2965:d32:cc64])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b09bsm659142555e9.4.2026.11.23.06.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 06:08:07 -0800 (PST)
Message-ID: <9de7d49b52769206709d87749085cc453aabf104.camel@amutable.com>
Subject: Re: [PATCH] xattr: enforce the name and size limits for in-kernel
 callers
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Amir Goldstein <amir73il@gmail.com>, Christian Brauner
 <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Chris Mason <mason@kernel.org>, 
 Christoph Hellwig	 <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, Carlos
 Maiolino <cem@kernel.org>, 	linux-fsdevel@vger.kernel.org,
 linux-unionfs@vger.kernel.org, 	stable@vger.kernel.org
Date: Mon, 23 Nov 2026 15:08:06 +0100
In-Reply-To: <20261123113513.1910906-1-amir73il@gmail.com>
References: <20261123113513.1910906-1-amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Mon, 2026-11-23 at 12:35 +0100, Amir Goldstein wrote:
> The xattr system calls refuse a name longer than XATTR_NAME_MAX and a
> value larger than XATTR_SIZE_MAX, but the VFS helpers do not. An
> in-kernel caller may pass a name or a size that it got from another
> filesystem, such as overlayfs copy up from a lower layer.
>=20
> Check both limits before calling the xattr handler of the filesystem,
> and fail with the errors that the system calls return for them.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> =C2=A0fs/xattr.c | 31 ++++++++++++++++++++++++++++++-
> =C2=A01 file changed, 30 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/xattr.c b/fs/xattr.c
> index 0705801a62cc5..824e8349e8c10 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -178,6 +178,18 @@ xattr_permission(const struct mnt_idmap *idmap,
> struct inode *inode,
> =C2=A0	return inode_permission(idmap, inode, mask);
> =C2=A0}
> =C2=A0
> +/*
> + * The xattr system calls refuse a name above XATTR_NAME_MAX and a
> value above
> + * XATTR_SIZE_MAX, but an in-kernel caller may pass a name or a size
> that it
> + * got from another filesystem, such as the lower layer of
> overlayfs.
> + */
> +static int xattr_check_name(const char *name)
> +{
> +	if (strnlen(name, XATTR_NAME_MAX + 1) > XATTR_NAME_MAX)
> +		return -ERANGE;
> +	return 0;
> +}
> +
> =C2=A0/*
> =C2=A0 * Look for any handler that deals with the specified namespace.
> =C2=A0 */
> @@ -209,10 +221,17 @@ __vfs_setxattr(const struct mnt_idmap *idmap,
> struct dentry *dentry,
> =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size_t size, int flags)
> =C2=A0{
> =C2=A0	const struct xattr_handler *handler;
> +	int error;
> =C2=A0
> =C2=A0	if (is_posix_acl_xattr(name))
> =C2=A0		return -EOPNOTSUPP;
> =C2=A0
> +	error =3D xattr_check_name(name);
> +	if (error)
> +		return error;
> +	if (size > XATTR_SIZE_MAX)
> +		return -E2BIG;

Hi Amir,

> +
> =C2=A0	handler =3D xattr_resolve_name(inode, &name);
> =C2=A0	if (IS_ERR(handler))
> =C2=A0		return PTR_ERR(handler);
> @@ -416,6 +435,8 @@ vfs_getxattr_alloc(const struct mnt_idmap *idmap,
> struct dentry *dentry,

Don't we want to have xattr_check_name() in vfs_getxattr_alloc() too?

Kind regards,
Alex

> =C2=A0	error =3D handler->get(handler, dentry, inode, name, NULL, 0);
> =C2=A0	if (error < 0)
> =C2=A0		return error;
> +	if (error > XATTR_SIZE_MAX)
> +		return -E2BIG;
> =C2=A0
> =C2=A0	if (!value || (error > xattr_size)) {
> =C2=A0		value =3D krealloc(*xattr_value, error + 1, flags);
> @@ -434,16 +455,24 @@ __vfs_getxattr(struct dentry *dentry, struct
> inode *inode, const char *name,
> =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void *value, size_t size)
> =C2=A0{
> =C2=A0	const struct xattr_handler *handler;
> +	ssize_t ret;
> =C2=A0
> =C2=A0	if (is_posix_acl_xattr(name))
> =C2=A0		return -EOPNOTSUPP;
> =C2=A0
> +	ret =3D xattr_check_name(name);
> +	if (ret)
> +		return ret;
> +
> =C2=A0	handler =3D xattr_resolve_name(inode, &name);
> =C2=A0	if (IS_ERR(handler))
> =C2=A0		return PTR_ERR(handler);
> =C2=A0	if (!handler->get)
> =C2=A0		return -EOPNOTSUPP;
> -	return handler->get(handler, dentry, inode, name, value,
> size);
> +	ret =3D handler->get(handler, dentry, inode, name, value,
> size);
> +	if (ret > XATTR_SIZE_MAX)
> +		return -E2BIG;
> +	return ret;
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(__vfs_getxattr);
> =C2=A0
