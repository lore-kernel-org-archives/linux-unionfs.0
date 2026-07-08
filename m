Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A4A38757D
	for <linux-unionfs@vger.kernel.org>; Wed,  8 Jul 2026 10:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783506311; cv=pass; b=N06691mX/1ue0Xbc0lbrb8BtamQ0GmMaRVVbAKGYL/nmD857LMnGDqeYCq9FYaFBDO89Lb5bd7R1BDDQI68QEAbZzoDQFikS2fI0/RMm7BOfoH+hA51tnHLncxc0HQI1hjUHIvRHmJntEKWkKM85GVadRQqMbWEbFnQ836Vpi9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783506311; c=relaxed/simple;
	bh=v2iptkwSmC7pfjv/tAPSoVfRUn3ZZPHoGdlB4QA7hqs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZXO6gvX1X0tLgOj/jULJ/TA6TTF6e4crelX8vIeYgwWcpqdOs6/gVVrrzb1SKRfqNKD3J/tgAQceKDJgdoh1i3NJ1hCGwn6htNJgyXqfA0sZkHQIVoOOm/Zt1G9pfxlooH6daIzSRwloW71AQZWHRO25dEqv0Y/1ewb3choge2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=Mg3hHQdB; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Mg3hHQdB"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c05dcdf49so4544601cf.0
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Jul 2026 03:25:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783506308; cv=none;
        d=google.com; s=arc-20260327;
        b=rz242RCmQkuHXxVU5UyRDTdq1oCe1fCSLtXiIlyvs6+BjTtTnnT/0aEnDGQeFCPUxg
         KmNtd7PaFXVIKnPghd4Jrvyn68Iuz9ACK1yzqF4y/oQc5roxWe87CFhw3/Hvt97FXCdm
         rSfH/ogz1eMey/RggIucX5oOeb14MhRbSLN/sI1HlRJxjsFgkOw3Aau4lrUylZQ2E/sf
         Y0ApUMiXTpC2y9kFynuGr9I/D9bD2oI2UqGe3Vro1Ry810QarG/9Idy03s4mnzeLD+hz
         WfkL5w82L/vXvBMqGQIwX4QSXNXsxTBE/c4PukK4O8jGw0zDu8IwNetiwBo1IMKsqwQA
         ZdGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=yQ494GWLnZ57cIKhXAy1AeNd/Rccg66OrqluMTPjUdM=;
        fh=NgwawyGSilGBm3xv9/QJv/TvgbuuCqS7kaE5Yh61Lr8=;
        b=XkumMk9YPxbjh+acyOk/r1ZV1PCXu//sQLDpwuqi7J1TsH2KOBiDHBUuYkPGhczkQ9
         XO6TgqskPFkJFW5g+eUtW/rkkaAZPLVH97h151bRNayiSWF4y+302MDhDptjZeDGT3EJ
         nqkWib6OS+OX5t7b27/MG01dzAAZa6DJ6mZiTWOUVPSFeBpe2znjSONl25Adb/3QHKJ2
         mFQN1KcK4CoZVW5xsjFbuOC4IVd0LTh/IqFZl3O8H+BoT4hD4GqZecERolGlAzMRI0ol
         L/jYAtp/u7m3E06kidW7VVGV12ZDnqSBuuKNCd8uo/5M+H2M8BtlHIOLSznCFYQ5zYJH
         m8Lg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1783506308; x=1784111108; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yQ494GWLnZ57cIKhXAy1AeNd/Rccg66OrqluMTPjUdM=;
        b=Mg3hHQdBKffZVJhW6YLkcvGtjjXB91BMFTVl6H2iE5b/QH5Nbmgx3zo8BP4c3l7kM6
         SwmNstjdVPqU+3PweEYhncYDXK508yMmQiWHh8TaZ73FZsseRKxhoUBvVNr6tNaG3sox
         ympDg+MP7NgjdQpTjAu0GQw/nUN38fegAoPLM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783506308; x=1784111108;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yQ494GWLnZ57cIKhXAy1AeNd/Rccg66OrqluMTPjUdM=;
        b=tJXRIkgVWy/pxvcn0LseU99HU8IbqVCYUzP8wXmX1mloz7x7JTakabSGTJZugnkt37
         T+skk63irFrQtmI3L8ZQo6+bDL73bo5af9vEPioivVJWTxMbVd1a9OtDNYEEnmWZoyVU
         EuW8zp5oUOLAMA+gn5YBIOt83jq+A4Py2iJufpYfhzx56xkydCCvcyAyBMa00Ebvsflz
         SFl/urw933Gz7oHMCupN9BqPhBtCASqMB0aJfIJIBIbMU8v1QsypKevrNo5OZ9KKKwo2
         69dQZ7ThvWnonrqvuLy0GSILhrSCeCNcGrp+C8dJglhTU3pWvZZGbvzPpdHouThgJDN3
         gvjA==
X-Gm-Message-State: AOJu0Yyzqw4GdfTNe0kjNgV1d9LEMvLdjBBgDy9HlQPxMtCAGCrlaoRt
	yzJFhNMvVgaIyjIslGbwd1nlAbkeg9O4qquKgDBVZOe7kx6Jf7RLXxBIOGLCWQO5kfKAdTKsYkg
	WBbej8hacqrWU4nv5qcvAsgIJ8XVZfDGcXwv7sAasGw==
X-Gm-Gg: AfdE7cmECf33ZpP8KyyHOWldzC/RiAPbYxFPVdFtZS3OiT3qG3OGfKQM0NTvKez3Lz7
	8gBJ6d2C/MysoHyRuS31HDzzvUiPArc3Qufi18+K8/gLWAj8Dyc6Js8mcZ1sNXVNDh4VGcgWpzu
	IN+j4iRhBxUUE1oOHb0CpRWZDyj97N3J4DZYUREx7VwazXFLEVg8cGqEtunu7y8eRsvql42dOEE
	ba6LAYLFCDiHOFiVW+AsNZfq2OP/TuufepfPZRRQRcQuK5SeMDZjfbDrwydKKZ9TRljMvoKHGEt
	YGaaTxWimbNQFQVMBtmPuBBjXVk=
X-Received: by 2002:a05:622a:2282:b0:51c:7b12:5fcd with SMTP id
 d75a77b69052e-51c8b40a23amr19083641cf.73.1783506308598; Wed, 08 Jul 2026
 03:25:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260708095831.3381978-1-gscrivan@redhat.com>
In-Reply-To: <20260708095831.3381978-1-gscrivan@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 8 Jul 2026 12:24:56 +0200
X-Gm-Features: AVVi8CfCXklAzPR7aDHbzayp-qscildNngPjuk9ohznhtjXLzwjf1tF6bysoZxo
Message-ID: <CAJfpegsJON=1_84PCGMjASYPFL=Wqsz7dnTAbO3Tdz5DfRQU+g@mail.gmail.com>
Subject: Re: [PATCH] ovl: add ioctls to retrieve layer file descriptors
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 8 Jul 2026 at 12:00, Giuseppe Scrivano <gscrivan@redhat.com> wrote:
>
> Add two ioctls to overlay filesystem to allow userspace to retrieve
> information about the overlay layers:
>
> OVL_IOC_OPEN_LAYER:     return an O_PATH fd to the root of a layer.
>                         arg == 0 returns the upper layer (-ENOENT if
>                         no upper is configured), arg >= 1 returns
>                         lower layers (-ENOENT if index is out of
>                         range).

We could do this with a plain open() call.  Something like the magic
symlinks we have under /proc/PID/fd/.   Question is where could these
live...

> OVL_IOC_GET_LAYERS_INFO: copy a struct ovl_layers_info to userspace
>                         with numlower, numlowerdata, and has_upper.

Isn't this info obtainable via statmount(2) already?  If not, it
should be there, instead of a specialized ioctl.

> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -35,6 +35,8 @@ struct ovl_layer {
>         struct vfsmount *mnt;
>         /* Trap in ovl inode cache */
>         struct inode *trap;
> +       /* Keeps the original fsmount file alive for OVL_IOC_OPEN_LAYER */
> +       struct file *origin;

Don't need to keep the file open: the only info missing is the
original vfsmount, everything else is already there to reconstruct the
file.

Thanks,
Miklos
