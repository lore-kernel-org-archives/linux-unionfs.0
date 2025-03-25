Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073B11D959B
	for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 13:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742910247; cv=none; b=VYFdjPBKZX+Vw571oTOadHFuzLxAZ1Bv2N0GYUhQVMRp0H6MwxM4zkL17o/I+Tdk8q9JdKe5m8kEIzeb18Sj2CJ5WWVGz1ud76gZDKQPnbWtNeOQRjUJaufswdi6nAU4qQpk44x6HkRbHs55SnBMLdb583zfFTP36XyuJbdQcfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742910247; c=relaxed/simple;
	bh=8KIudKE6VvJiOdj4gr0OO++CrR3zbC/m+Ov/oFgj6E4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rErwjGEqPcI9k49ZUJ1rsxdkajY3zz68yzS0pprTo01OWUjtRE+dq0MuzcNN2TDscRK+osabxa+Eypfst/9KnZ618z/9B3HSDYhZZGe+8yZCv6sL10d2/k75vtsDTHFx0i0KhAYfxzaZLFq5nYqiBNl63E+TbB8cBc9d+DX/cns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZJylZkRk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZJylZkRk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742910244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yWXvvnLse6UgXyUHy/THOGh38nsz/8p45DMcYfJmDXk=;
	b=ZJylZkRkYFyBUVeng2Tm66DV67gSe6wolRSl7byMQmJcUsOongxgY7mf2rPLT6ggEEw6V4
	xpI02g+w43J25Ckx3g+Q8HjIq3/0Ud0ib7PTdZJVZTSm+xOX9ZvoQAIrHX+XsGzDWso1Ui
	T/rhbmeeeSn15C/I/FCD6akaI5vhmFU=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-doqHB3_6MYqQPr8X8esdDg-1; Tue, 25 Mar 2025 09:44:00 -0400
X-MC-Unique: doqHB3_6MYqQPr8X8esdDg-1
X-Mimecast-MFC-AGG-ID: doqHB3_6MYqQPr8X8esdDg_1742910239
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-54994e431dcso2576184e87.0
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 06:44:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742910239; x=1743515039;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yWXvvnLse6UgXyUHy/THOGh38nsz/8p45DMcYfJmDXk=;
        b=uvWzCmOCHWkCC71dsdpBB3saafrP9suD1M7k2phnG1c8szHtonj2ZX4hMNeLwRCEAU
         ht3pakdjPZ6ttABdD4Jf+S/EiKfYEjGKBwpL/jlnO2rqX1o4jzLo8f+BoQYYXjc4hA/4
         7guOd1MNVslzD8NasH9dWjMsfHJXs8U2/pTEGxt07KNPinEafiaKDkbQS59iFDCk2Gtm
         LmAUnd8XTXYPMqBhEop0sxIe4UTSK83Cy+Y+br6a2xBXAozZ/TZupdFiKcrU1dbB9bdk
         sHI9znS4wS78hDjy/kzp23OiBOjMgHRS7KUW2L3KvGTUitlQG+Lpy7PWze5WlTJfQtEn
         tEcg==
X-Forwarded-Encrypted: i=1; AJvYcCVUEfgOUZZsWVTXq2PpBtGzAPeI4cFItN6uCe5eZwwGuW8dZuayFy+OVdEbtiVU1EciH8TskXyYE9e02fqZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yyn2F7B2dQtz3zVVXUrM1Rs7Tc+gfvXUg0qzvI0UX91SjuAZCsy
	cPH+DASdnGgaf/2sk2IK/2zYV8DNRIXzn3u47fK4HsuuQSBWB/kkzXObE96Oej2HsRgp5R8YK6z
	68ifVF1fxsaUXXsVkK9anLIWCqcgLszMZt3Y8iK6xAwpGu+LxAcMwttJvVg1NnF8=
X-Gm-Gg: ASbGncsfpXhK3MuxKwp1cGJ/tG8ydr72Z6lhLhzGYacdtpXWLd7Zs7onjyJigmllGDh
	z7tMn+f+DhMkLWffimGpTwP4gR54Cqm8WPUvay1R/XRvNe+1ga8udaIvqxpl5VuqVLQkU4R0yqN
	zyzb52o8QKPO+bu2qb+w+IXCudCdOw8Oquofu7vOhG3Nkq6/G3XCba9ptXamqGeY11qIf7bjRS2
	+l+51JddcQL/1Dv4gzWj9qWtUMcFEY7d4WgQBRarOZXSMwecjpY7plr1/h/IqKa274k1AORU3J/
	0D0b1ew7+0/xd1ANDs6IxYRzIgm9KRDIRIWIQ+W6NoLSiNE12MDbB0E=
X-Received: by 2002:a05:6512:3f03:b0:549:6759:3982 with SMTP id 2adb3069b0e04-54ad64ef448mr6076310e87.37.1742910239218;
        Tue, 25 Mar 2025 06:43:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9q18eFyCOaGJ1t+z+GBKHu2RJGbCAkZIR6NhUEbbmrOsCPJ1/37sK95DPBH7K037653cJ4Q==
X-Received: by 2002:a05:6512:3f03:b0:549:6759:3982 with SMTP id 2adb3069b0e04-54ad64ef448mr6076299e87.37.1742910238760;
        Tue, 25 Mar 2025 06:43:58 -0700 (PDT)
Received: from [192.168.68.107] (c-85-226-167-233.bbcust.telenor.se. [85.226.167.233])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54ad6509736sm1514107e87.200.2025.03.25.06.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 06:43:57 -0700 (PDT)
Message-ID: <dc1cb5bd875491060a4f1eb1dae42865b95ae4df.camel@redhat.com>
Subject: Re: [PATCH v2 2/5] ovl: remove unused forward declaration
From: Alexander Larsson <alexl@redhat.com>
To: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org
Cc: Giuseppe Scrivano <gscrivan@redhat.com>, Amir Goldstein
 <amir73il@gmail.com>, 	linux-fsdevel@vger.kernel.org
Date: Tue, 25 Mar 2025 14:43:55 +0100
In-Reply-To: <20250325104634.162496-3-mszeredi@redhat.com>
References: <20250325104634.162496-1-mszeredi@redhat.com>
	 <20250325104634.162496-3-mszeredi@redhat.com>
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
> From: Giuseppe Scrivano <gscrivan@redhat.com>
>=20
> The ovl_get_verity_xattr() function was never added, only its
> declaration.
>=20
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
> Fixes: 184996e92e86 ("ovl: Validate verity xattr when resolving
> lowerdata")
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

Reviewed-by: Alexander Larsson <alexl@redhat.com>

> =C2=A01 file changed, 2 deletions(-)
>=20
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 0021e2025020..be86d2ed71d6 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -540,8 +540,6 @@ int ovl_set_metacopy_xattr(struct ovl_fs *ofs,
> struct dentry *d,
> =C2=A0bool ovl_is_metacopy_dentry(struct dentry *dentry);
> =C2=A0char *ovl_get_redirect_xattr(struct ovl_fs *ofs, const struct path
> *path, int padding);
> =C2=A0int ovl_ensure_verity_loaded(struct path *path);
> -int ovl_get_verity_xattr(struct ovl_fs *ofs, const struct path
> *path,
> -			 u8 *digest_buf, int *buf_length);
> =C2=A0int ovl_validate_verity(struct ovl_fs *ofs,
> =C2=A0			struct path *metapath,
> =C2=A0			struct path *datapath);

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
=3D-=3D-=3D
 Alexander Larsson                                            Red Hat,
Inc=20
       alexl@redhat.com            alexander.larsson@gmail.com=20
He's a deeply religious vegetarian gentleman spy in drag. She's a=20
pregnant renegade politician on the trail of a serial killer. They
fight=20
crime!=20

