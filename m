Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F90D15B555;
	Wed,  4 Sep 2024 19:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725478352; cv=none; b=e/43Xk+EQja+n89ki31bnwlMwy+LYUq8Favu+mfbUglojMALJ50ZPUm29XMApIlW9LDz8HZBCmA1UM1llJE9ied4BRvWvJ+CuMtXJA/L1t7NC/SbbvDsoDgXdnpzCocYWGoMKlcCTP6LoS4i+ElQ1+juW06px6KxgkU56d6jIqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725478352; c=relaxed/simple;
	bh=PyQrDfXI4pIKyfzh+YcSygARqjBWQaMniKKisbOo8oQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LPw0FY08YlE30jSuuoDUbmDI4hXpI0+9QPu5yOiRWYebpmej2Ez7TEXNNhFhX8pCYm1UkkyaclbX9vmWeDzhXRMtrrPoa28i4+DFP3v4guoy28vTNTaJzjo4JI623sJUp3MKSgIWGjODqxIJYpnadX+9JUEoT3338FmB6HBhjSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G1ykBlfb; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G1ykBlfb"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6c35427935eso29383516d6.3;
        Wed, 04 Sep 2024 12:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725478350; x=1726083150; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UQs3zpvLguyufYMw2L58yxG9r/VbEIBK+iwTQGmJNWY=;
        b=G1ykBlfb7wtJ7vzSlemTTVucSO5PXduzqLp2+Jsyfeif7306HT3AstSxb1S/rjx32C
         0wr2kNISp7zxldOLdvq5SflqU0LUTh59WULJJAXotAIhfA2RBe5i5+OrLwd3JFkegjy1
         un9TflTYqfP5jRf2j+vw4HLOpRQlBQr18We2g+1z8/3oUwTVZ0Pqug66x04WcU3pZ+j/
         KV9xzeDNrhOAYTiV4kZIW9G3KpvvHvJ2YZ9gfBUzOQvWeYKBF5h49vqQVUStcWj8rqR3
         fnUPyupgawYh6CP3AnODdiZw60bdnmzWb++T0mtJxxRt54oCWnQCbsDy88Z37TVRkTbU
         jKSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725478350; x=1726083150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UQs3zpvLguyufYMw2L58yxG9r/VbEIBK+iwTQGmJNWY=;
        b=rZLKz+ALHljXJCUCAMtDPWYE+ZOvzwYIO6mx3fy7XIrMrbLINyrXYTnsZhcHk3YEOT
         PQAE3bs/eoYEFcOPoZiMpEqVuVJGasG6GchRCIWaT7Nh1Vqt0RDq5R0y7UYkuYpQyiRj
         9ogMF23IPu0ZwvyzfrGVy6DM6Z+mkLSL9hFSP4bJ4dmoFAAhN+2a7VfzYKWrkaUnzKcI
         IP3SGIspqE6j5hBxKGXROGDI8Dy6mHiiXBFVPGyqNpqxSfBfpJZreXMkaF/30bZzl42J
         kZl39RDzmjUonfRIWQsF5Qd/+2k9fUxFrw7cyvhKIPnKBZkjgs3lPMt4vZBJLV3X5sLs
         7/mg==
X-Forwarded-Encrypted: i=1; AJvYcCU/g1YN/ZNqfYR+tmHMa+pQogPikuX8q3Ab9HUTe36AxzRGJKcvNlG1aeFSvibobLpSQ718Rcx8qBMUBhorYg==@vger.kernel.org, AJvYcCUWpCxibm9XPN7OkWA1g0Sas4eKvqNbCk5Rg5nHJGUUC8Dz6riPdlp02t4qJTSa1lbjf5++UpAbHvKElwT1@vger.kernel.org, AJvYcCVwIDmpnh1ciQRcaeJyRATkYZ8pz0KCTxodUEaF3aUra4nJmm8cDvG63DFa2UD4s6tWtcr9Myf2GWY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9hhaH3Wp6Pru8qYDzsemFXa3+VWcUI0v6DcmDp5RjCcSiLVDN
	Fm15oXcTpT6pwp6r+TwSSXXHVCjm6G2FpVShYuo0X9Wj4JnfPCM3RS3hlwaqde0Yby5AGxUypOF
	71TXn1PPUMrP/gbLWcpfvEyNCndw=
X-Google-Smtp-Source: AGHT+IGRHjuOzYuw5iOar6gfXgnmHzCjlMooE6P9uwZGw4HYM+s7dZ/ezw4PlCGXkIkz6W4zgKk7VvfRZHckbaxEa1E=
X-Received: by 2002:a05:6214:4585:b0:6c3:53fe:8182 with SMTP id
 6a1803df08f44-6c355836c09mr204191836d6.44.1725478349745; Wed, 04 Sep 2024
 12:32:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOQ4uxiRGcPNsad==MtLFGrrwg_Sv-6g0tNwSVtvoSH+2VR5Lw@mail.gmail.com>
 <20240904165431.13974-1-yuriybelikov1@gmail.com>
In-Reply-To: <20240904165431.13974-1-yuriybelikov1@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 4 Sep 2024 21:32:18 +0200
Message-ID: <CAOQ4uxiaokAp4P+ADxX40onTxqBjR=2Gc=iagtVN3MW66QSc9Q@mail.gmail.com>
Subject: Re: [PATCH v2] Update metacopy section in overlayfs documentation
To: Yuriy Belikov <yuriybelikov1@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, 
	"open list:OVERLAY FILESYSTEM" <linux-unionfs@vger.kernel.org>, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 6:54=E2=80=AFPM Yuriy Belikov <yuriybelikov1@gmail.c=
om> wrote:
>
> Changes since v1:
> - Provide info about trusted.overlay.metacopy extended attribute.
> - Minor rephrasing regarding copy-up operation with
>   metacopy=3Don
> Signed-off-by: Yuriy Belikov <yuriybelikov1@gmail.com>
> ---
>  Documentation/filesystems/overlayfs.rst | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
> index 165514401441..e5ad43f4f4d7 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -367,8 +367,11 @@ Metadata only copy up
>
>  When the "metacopy" feature is enabled, overlayfs will only copy
>  up metadata (as opposed to whole file), when a metadata specific operati=
on
> -like chown/chmod is performed. Full file will be copied up later when
> -file is opened for WRITE operation.
> +like chown/chmod is performed. An upper file in this state is marked wit=
h
> +"trusted.overlayfs.metacopy" xattr which indicates that the upper file
> +contains no data. Full data will be copied up later when file is opened =
for
> +WRITE operation. After the lower file's data is copied up,
> +the "trusted.overlayfs.metacopy" xattr is removed from the upper file.
>
>  In other words, this is delayed data copy up operation and data is copie=
d
>  up when there is a need to actually modify data.
> --
> 2.43.5
>

Pushed to overlayfs-next with minor rephrasing of commit message.
(v1 is irrelevant in the context of git history)

Thanks,
Amir.
