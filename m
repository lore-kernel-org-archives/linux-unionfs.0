Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039E8319608
	for <linux-unionfs@vger.kernel.org>; Wed, 19 Nov 2025 07:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763536406; cv=none; b=FADQvjd9c/eJUi/Lw57dKcsYCrv6MCRmPUYVFbWO49aF4MIL62kvuX9ze3OZn+ktJEBpxoT2sigp5Crp2ZKu6tzKh2ZEogY/KizkS9KcFqkzpX+7ojoHhHcMP9Id4G9mk7wOY147eVtZe4yS6x8kX874aszScJh6RkQZFkTqOGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763536406; c=relaxed/simple;
	bh=VhO9Zv+AshAVCPbGJujeRwRjVu+5kKh1p4fbomxPCkw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YVT5cunUHkE+bKh2IzWM3b2al2CqUQDS402xcF0P4jZfQDwHY/5v+1kBh4KflacF9Rvnwm0s2IjBoLAPnfuLKEXU7Z6r/vSiupi5bL3SgqPmIVsytzIdfkWgHbTOyEiJuGQD5ZXj1wVVJs+ewcQoyT3VN7h2m+/r0u5p5CcA5Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i4mjqmFJ; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i4mjqmFJ"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2980d9b7df5so68574775ad.3
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Nov 2025 23:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763536404; x=1764141204; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OQGO1sUYeOJV39MAKgwIerIEJtSj6DSenu+RgUcxLNU=;
        b=i4mjqmFJB5uLI1cWpMFRkBn7TSYrspQB/wNj9HTSjaCAhBqHMjWGWrr0HdBAF4GJJ+
         EgmkNNxdL7xjkhoXyr4FLebulK6HR3Wn/no7srCPqs8HnmygvWHaIpAVVGpwmrBnueGh
         m4nCdwVWEpoeOziNj4yOWIVhwMHBw9EV4oi5qnMfplcYwI6qHMzRz9pXkEWWuXr9xZ9e
         pFq1YUp8Fojr5mvtD3uOH1i56CksFNkQQip+laBo9wtuUfZ6qZWHZuq5RiY5RCS3pUmy
         QvR9v2Nh9OHskAXOWbOqINP/ryy2WnEimDmeWvx6tqCOUMngRJ5p0/fEyJSMYzsl0f5w
         aBrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763536404; x=1764141204;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OQGO1sUYeOJV39MAKgwIerIEJtSj6DSenu+RgUcxLNU=;
        b=wk+an3nNo4QxYhGK/ZkR1OD29QQSLZXGGAi3hJoErdVJKBD5pKI7qJs8VKosw1GCUG
         xOj+WC4+AMucMZI3dgPUs7gQpYp6f63r4y4RFskt6hm3/VrY2egmQxDLY51ODLdt5zsT
         JaRlRuZJTs/K2fewTMdD1n60FkNJpNhvvs5lf6CKFbZQwIbL9QFuTML5K7NgTDl7VJJZ
         45NeuniUoahMJjMrkT9ZJycJ7KH7gt5wc2v3A1ci2+D2ekAV5GakYxEuPnmASflMn8zM
         hA+hgEsTn8xkwM+baBq7PJi5iTovta5ePjCjN8phJWYIegrHirdKZp9ppl1hZFrhk5tf
         6kBw==
X-Forwarded-Encrypted: i=1; AJvYcCUDpCvVvc1f8DPsMmaQovJyvm2tlLlN+VQ47Q/zNTNj16Kme+npiQTqmIiRfVpNOtrDow3fxgIg7m6y9AQz@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8bS6jTWUOIHBTtNqR7TvWAyznpSh/0Gh7rHK8uxYyFDHF7YvQ
	tMImCIU8yY65hM8yW3c3hPOJlg9cZuDAyx0SuI/teMrmru3YjVGZnz3B
X-Gm-Gg: ASbGnct5zrbuLlsk9ZjF/ySC2Ui6aOZyAhd2nphp+f8pWsKFjqxPuDs3NHnsIi3biOz
	C2L2jwH40dCllh3DaW/NYhxUNy8+vkCH2ZFVUTpRHiZJZAGZTjk8xFmpG0+6ciXne7ZrHgj8Grr
	2vktGXint27lMn5i6iJ2+tSdmVX9JV72REeOHa1CyVl+Abuy/o8e2/OAcfMECbWcDpLRTzDYq38
	F3Z21/57F34DE6XlFwRcj8yOiL0ZKgkZ/NvCcf8sMibtFMgoAomNFOnswYLJeBrbUuUqfDhZtwb
	nt5glJdp1lmoirnk6OUEdDCR+HVqZ+zt4nuCQLfbGOH52wBX4HUHpjwNRLSX+OAS+w/ntkfk0W3
	zQWTKvixv70bCqSsNsczlGQsRDFGfvdcONJhNWg7rXIaBIaqUEel9YlHDwfPeGeYp7oiQFuHbnQ
	VeBgOQIuzy3Abhp+pJ3YZPfKqMe4eDdoWhoiemY5afqbm86p+zbxAd
X-Google-Smtp-Source: AGHT+IH/gL6yGt5V0h4Hj7irwb65r1xjme7MQ1YYoWKyR5w4/vb9/Mu1xnBn1mXIZIm+8ACUp3Px0w==
X-Received: by 2002:a17:902:f691:b0:295:6a9:cb62 with SMTP id d9443c01a7336-2986a73b4a7mr234874565ad.35.1763536404116;
        Tue, 18 Nov 2025 23:13:24 -0800 (PST)
Received: from ?IPv6:2401:4900:60d7:2218:52ea:a17:db14:a44? ([2401:4900:60d7:2218:52ea:a17:db14:a44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2bf158sm197406885ad.91.2025.11.18.23.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 23:13:23 -0800 (PST)
Message-ID: <0c11915eda500f12ed56dd77875c96f53c496fbf.camel@gmail.com>
Subject: Re: [PATCH v2] overlayfs: fix uninitialized pointers with free
 attribute
From: ally heev <allyheev@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>, Christian Brauner
 <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@linaro.org>
Date: Wed, 19 Nov 2025 12:43:18 +0530
In-Reply-To: <CAOQ4uxgLYwpwyoecazZovz490i3bPYSGRsi74NZQE4N4NT5q_A@mail.gmail.com>
References: 
	<20251115-aheev-uninitialized-free-attr-overlayfs-v2-1-815a48767340@gmail.com>
	 <CAOQ4uxgLYwpwyoecazZovz490i3bPYSGRsi74NZQE4N4NT5q_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1-1+deb13u1 
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2025-11-15 at 14:59 +0100, Amir Goldstein wrote:
[...]
> Christian,
>=20
> Mind picking this one?
>=20
> Thanks,
> Amir.
>=20

We might want to wait. There's an ongoing discussion going on about
this rule
https://lore.kernel.org/lkml/58fd478f408a34b578ee8d949c5c4b4da4d4f41d.camel=
@HansenPartnership.com/.
Mostly likely, I might have to revert to v1 of this patch
=20
> >  fs/overlayfs/params.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> > index 63b7346c5ee1c127a9c33b12c3704aa035ff88cf..37086f73ac3ecfcd1c09ae6=
eccbb69723006e031 100644
> > --- a/fs/overlayfs/params.c
> > +++ b/fs/overlayfs/params.c
> > @@ -448,7 +448,7 @@ static int ovl_parse_layer(struct fs_context *fc, s=
truct fs_parameter *param,
> >                 err =3D ovl_do_parse_layer(fc, param->string, &layer_pa=
th, layer);
> >                 break;
> >         case fs_value_is_file: {
> > -               char *buf __free(kfree);
> > +               char *buf __free(kfree) =3D NULL;
> >                 char *layer_name;
> >=20
> >                 buf =3D kmalloc(PATH_MAX, GFP_KERNEL_ACCOUNT);
> >=20
> > ---
> > base-commit: c9cfc122f03711a5124b4aafab3211cf4d35a2ac
> > change-id: 20251105-aheev-uninitialized-free-attr-overlayfs-6873964429e=
0
> >=20
> > Best regards,
> > --
> > Ally Heev <allyheev@gmail.com>
> >=20

Thanks,
Ally
