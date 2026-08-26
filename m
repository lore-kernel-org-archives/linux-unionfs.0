Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175F03B9920
	for <linux-unionfs@vger.kernel.org>; Wed, 26 Aug 2026 10:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787739480; cv=pass; b=XTMQshT84YlDFmngu58HJ/2iIV9FzXdxZ8JMwyU5+lVcFlhn/7x5MT364C/rsPK+AOt0HRl3XsCvAiyx8j3rErpwCRlMeTZbwxoeOHLdi4P8W5HDcA/sCdUJmPjusvX7ehvX4GhFBXeYUbK5ryGDW0RVPfGDE9HMO6FdVDa+33U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787739480; c=relaxed/simple;
	bh=ZeiSEUKT4z5Mw3WNs8W0vShBh+1rt/uRApGrpXKu5ns=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mOzVTVToaRZjpSuvmLPQstb6pb4GD1q+Oq6texHcYljSEIn7vTXvJAOcQmyNrnJmHaWgDRBVdlFgxfC76TmsePVlmGA76uNM5ojwWj16YUOYKiuemdKxlU5C1kjGLAOuW+rYGVXzy7Ja6WFx6yP0nLTXzwbTLIEwsKlQ5e+216o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WPNgE2rC; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WPNgE2rC"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a1a546a6bbso1254706a12.1
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Aug 2026 03:17:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787739477; cv=none;
        d=google.com; s=arc-20260327;
        b=UiF9irVsNNtcKZ9OSxmsZ9UUYuw3WhSRsSm5obwRoNP9oKhCtERXVVGK2vTb9TNsw+
         fYJqiAjHgNKUAxkZvq893nNQhNhZVc0n3Dv3dX0DNPsK5nCpQ5Pt7NMW+Ve1McPwWrNp
         DmnddQcIyXumFoQeQRVrF4OFqgI12f8Do0p5A45texDulwDwClOCk/L+4y5QJr4nJOyl
         3disXeiGsQvlpjCmtjY6rEu01HkdkfK3O+2cpRtzU+iRIC5tSowI0Fa17IvjKqxaoyIW
         su8KCDTDy/CwjF4DLJ2LThy+9xe6Bw7aZs8/elqBSdVVIQKlFWfhKss2Q7uiHaORl3/Z
         6kPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aWfSlIwivjnfTyVGZ6Ff0fZkRHSJBAEY2wIv1e/I7R8=;
        fh=lTAzyggsb/v/3DVMx6c80ngeblHG+sAOtmnnmf4BH5U=;
        b=l4mjZlvUiXDgpQt0AVuW9bc+n3un2T0q7pk8b3p1zXJfcF8yAGNkdA5Yh7ed+8fOjC
         CJKwQg+zajH7usbi/pibt095IfbPjEw9haO9MovAUBcC3KfGC6/yYSW/ADeHMA5JCpLz
         K10grc0cQ/WNw5stbku8E/5Ri7rHwJ/hRPz2985WNruXut8Y3lBwy6bcvWnueUkkdrs1
         /RxwgUS4cwylwEecO/GZhQoD+5frXma5+/Roqb5SNl2pJV6QCAoOOmlOJCfYZpqn5q9B
         yazn/H/bRKRCBkqbybjPJQ0SpMEdb3YhiiP45QvKUSZ9Mmn9DeHUh75gUoI9FXIfnnNh
         K2ew==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787739477; x=1788344277; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aWfSlIwivjnfTyVGZ6Ff0fZkRHSJBAEY2wIv1e/I7R8=;
        b=WPNgE2rCGVNjA+Ufx6wxSCyyNr10KxQRxlOybOjkae3We0KGe0yeQL8G8XCBu/HGsq
         QJwQoMEBUVLodulQNOPsnXuM5+/Ay75RTQY4Kb4HD3TGuEgpByjhYt+CH+XZH33CixrP
         sggRKxq1FCi+mxkwYAKkYdyLqgTPtCiFKLn5gvA+3IVUnkskT9UTUwWpW2GgPJyuSZGA
         wDH0tr2peXlrK/4oUbrbbjuU+ppRy6y2Ns2JdOrnxU3CtEQUjvO6PqEDxUQv0uMpxYRJ
         gS94gqDX/jVpxvSF+JMvn9cNY+rqRmx49ZcAP2SJWJiWfFpn7STYMLaSzg/BtDw1Pubk
         Pwcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787739477; x=1788344277;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aWfSlIwivjnfTyVGZ6Ff0fZkRHSJBAEY2wIv1e/I7R8=;
        b=r4c/elKLW+KqLr3I/P46QVKrxh226s2eq+MtMWGvFW5UTp9OPDbk36E5HCf9z4YN54
         11UrAuiExq93aDTaywephkqD3lgzL4MKV1O5p4+Q1yNbnmXgwvY0stLB4+Nwkada3iPX
         92H2IffkEU2dVjlhJc8Fqzjwcc6XBoFzLv/xPXiD/wBcZQnu7lV7RAvFfzspSOIZWeKC
         0xCVM0IEEaA6V53qiJnz88PThZej3xkg4m5qs3wL+zmdVllgNokQyfmHeLup1/VIQKbm
         zyrvOQffUQMbd6Dd6vcrzZqNDkjq1DhvkIEbf8STQo7xzMTt3whgg08wjwHnKT4pprEs
         gq+w==
X-Gm-Message-State: AFuF++leotUPEy+KqZ746+qt1fPQATDsf89qIzPyVSXovOF63bIl4DWb
	D7cpibzheIp7lQr6Y2xG6QNeeq5LzNmPT8mnVcFeSdTICXvw1YaPXWmg4QNDwrxJFAZvAksIC1d
	IrV9bDqLzfouyCbjvli2l0G6RDBCqme0=
X-Gm-Gg: AR+sD12rBheUYvgkdEOJq2V9vu/k7I0B9J0Qz0/82kDlpMmtWDBUktB8NluUH+c9U5a
	sXSzPc48CZeRLt0wQQh9himNjZJvKFaCacnFS7tHcYlw8Q+tssX6ZIAj3Ffg8I033sYgDptqk8A
	bYjUohbMwTRo+MJoqPdVj9w0GRM9N/K6nhi8AVSkI+Q709TpxW3Rs4WPPfEFwLBNBmfsW//Jxg6
	0Wyk/7CUMQfyuRio8KXzENawk1gqY+rkW3ezVxiWxeKZzkFBslEeyyv+lNQObI1/R147KsYmROe
	2di8p0I3gNNxAjCQBw+6fbfikW2fQWOnrUXOUaGQj6SEpQ==
X-Received: by 2002:a17:906:fd87:b0:c16:13e7:fd63 with SMTP id
 a640c23a62f3a-c250b993c7dmr773463566b.0.1787739476868; Wed, 26 Aug 2026
 03:17:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260825152330.850645-1-mszeredi@redhat.com>
In-Reply-To: <20260825152330.850645-1-mszeredi@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 26 Aug 2026 12:17:45 +0200
X-Gm-Features: AcwNN1X0PyJipNtx1_0DlUbo0zx7SraIyCIYQ4IvKUkWrtxjwmygScSxMxugF40
Message-ID: <CAOQ4uxh5bL6=sedRE7vdsXehoOe8CkUHAtdO8hHB0Xpm05L8KA@mail.gmail.com>
Subject: Re: [PATCH] ovl: return EINVAL instead of EIO in case of mismatched user_ns
To: Miklos Szeredi <mszeredi@redhat.com>, Christian Brauner <brauner@kernel.org>
Cc: linux-unionfs@vger.kernel.org, Christian Brauner <christian@brauner.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 25, 2026 at 5:23=E2=80=AFPM Miklos Szeredi <mszeredi@redhat.com=
> wrote:
>
> The EIO was used to signal an internal error (commit 9efb069de4ba ("ovl:
> add warning on user_ns mismatch")), which is no longer the case.
>
> Fixes: 63981fc786da ("ovl: don't warn when the mount is completed from an=
other user namespace")
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/overlayfs/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index e487597337e8..bd0a3f9039d2 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1543,7 +1543,7 @@ int ovl_fill_super(struct super_block *sb, struct f=
s_context *fc)
>         struct ovl_fs *ofs =3D sb->s_fs_info;
>         int err;
>
> -       err =3D -EIO;
> +       err =3D -EINVAL;
>         /* The fscontext fd may have been passed to another user namespac=
e. */
>         if (fc->user_ns !=3D current_user_ns())
>                 goto out_err;
> --

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Christian,

Will you pick this up?

If you do, please also take my other ovl fix patch from:
https://lore.kernel.org/linux-fsdevel/CAOQ4uxhX_neohTAjZDOT0oSWC-JNiqNWqnfE=
5YSa7Ln05QPQ-A@mail.gmail.com/

Thanks,
Amir.
