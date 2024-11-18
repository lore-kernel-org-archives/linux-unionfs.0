Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C2D1DFD1;
	Mon, 18 Nov 2024 18:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731954066; cv=none; b=cWf7tFMSGW+LPNR6T5fCsndF6SVYEGZgeuCIS4Lbb85eatAcRk113ePZY4H9IGDBQqQCqqkI5YSXFpraVRcUhnFaiIeJDu7UP2fDe7bs1x0S572N96eFdOgSDz9RVqqzyGe2rjZko+Jh1fXexqjdggwhoM2HLUE+Vbn7k9bN3iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731954066; c=relaxed/simple;
	bh=Ifz6ll1kWwF6NqROMr2/4icSY3LHmpPaoSvVtk4lTJ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K/RTO7Uv1oLR1O/oLeVS0gb7Eg9+YLV+1ivPRH0/Jel/D5BBfLCHxiPN3dVqvRgNXSAVzLYfWJIsTvcxZxtVkFoMXkFaA9fAUBcPXw7y6bJtF5DulvtEPP2mCQjSOT2vD0hdKvwxBA5xxx4I6XcDdqIEAdAbhmh2/RHm3wivkic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RvWca04m; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RvWca04m"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a9a850270e2so461143866b.0;
        Mon, 18 Nov 2024 10:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731954063; x=1732558863; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4lKXYtHkcL95i4UI7uiZ3CUOmGk+PvyJuJo1wQg863E=;
        b=RvWca04mOmx2aE2YOctyvlThBuXt1ZdGTDNzY5ieipXI/q4NiKJrnU9RZwTjeKR771
         bgDOtusT0oeeM7iwRYRoFsokjmP2Xf62ewyEI4aznVWQfw8Aca2tIVRIEVP5ksTRIIrr
         K8oGUfkK3N1x3bV4w/R1jBOM4tPxDCjL2jxKCHn6Z5ZSSDWc4y/SPhor89CTSNtsXJ0j
         kzzi+iayfs0pBMnqXNW8NjKRM5wbjGaAym/MyniXa4i62NGPOUbIyncb0HduEN8/OoF9
         I61piVG9Vi/k/GufZcWLBrGfJyx/cwWGRzg6XDPSJlMoa6OarT0FG3khR6heHq7X0oEx
         ThKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731954063; x=1732558863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4lKXYtHkcL95i4UI7uiZ3CUOmGk+PvyJuJo1wQg863E=;
        b=VJ/hZ5aL5UclUusNeJroj6xu/Uq7TaUPkb2KtPw41iH0nT2/11bmNuG6ikvLzyDmjb
         EOvkZiToZMWhtPsMAkxP57HUu/9Fkz9Cs5kzeDUxRWCW6lXEFg/zFA+8tHeBTIZlgBBP
         XJoxmdZ2GJ4ufQSac8ooHxj912r0jbLxYbda8apEMSAZCRJBN1ajNR/4Jci1RLo/JKdS
         NCMbObS2f0zZUwx4zG6vlu0xap6egNpSOt7L0/95CbZqhoixmnmwJHqntF4x8TdDew7m
         9htLhl2Mc2Kqq0B4wJaIF9L8ZtTf2PLm1C2ojWP69fmvUWpjP+zRh3q2rWXy32UqRgYx
         BGYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWb4f9CIoU1ne6EvO6EFN5OkTTfkVbvkwFFJQEsgdk6m2niFIQgmQEA2ozarpxWpHrtkaBOr0KpKX915Jye/Q==@vger.kernel.org, AJvYcCWeg6axfaaVRpHkSmzf0yZC3NKSE0C60Bus3wPzYNo3soUl8Pizle4r9rpj6TD4DY4YBU1eDYWJ8HTqEvQJ@vger.kernel.org, AJvYcCXT9Xouq0b8Hf95Bx6Hagxqvor79ky7a1vTOCt8+EMG+Mo3y2r/gk42qXKoLPah8Hk1bMp04ni4vPnRMAFgzMs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQAdMCnSQGo3cjO0dEkMkQFXb1hirUmpxTVPMMj0jgWXl/GlJL
	Xj/TJxLI7kQDUbd9HnUArtp1kmYc5VAvWyZzotVB8d7K0UUDB1YzgOOpRDSJienWD2uw0n7Y+x0
	GSXqSOeKH59+QeitNOhKmoeidxMg=
X-Google-Smtp-Source: AGHT+IFSsZTy095W0foFVPdW/HtKWRBZITkWoNj6K/qYOyKdlRMA7EQr39EUOLvRkdOFYkUGKNlvJoMIO7FqCaee1LQ=
X-Received: by 2002:a17:907:9802:b0:a9a:1778:7024 with SMTP id
 a640c23a62f3a-aa483421c64mr1322039766b.20.1731954063079; Mon, 18 Nov 2024
 10:21:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241117044612.work.304-kees@kernel.org>
In-Reply-To: <20241117044612.work.304-kees@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 18 Nov 2024 19:20:52 +0100
Message-ID: <CAOQ4uxg8rNPUTk8dqz2HmvT9Avy_6WMW4xOMPtG0b8tSUWAKcQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: Check for NULL OVL_E() results
To: Kees Cook <kees@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 17, 2024 at 5:46=E2=80=AFAM Kees Cook <kees@kernel.org> wrote:
>
> GCC notices that it is possible for OVL_E() to return NULL (which
> implies that d_inode(dentry) may be NULL).

I cannot follow this logic.

Yes, OVL_E() can be NULL, but
it does not imply that inode is NULL, so if you think that
code should to be fortified, what's wrong with:

 struct dentry *ovl_dentry_upper(struct dentry *dentry)
 {
-       return ovl_upperdentry_dereference(OVL_I(d_inode(dentry)));
+       struct inode *inode =3D d_inode(dentry);
+
+       return inode ? ovl_upperdentry_dereference(OVL_I(inode)) : NULL;
 }

TBH, I don't know where the line should be drawn for fortifying against
future bugs, but if the goal of this patch is to silene a compiler warning
then please specify this in the commit message, because I don't think
there is any evidence of an actual bug, is there?

Thanks,
Amir.

> This would result in out
> of bounds reads via container_of(), seen with GCC 15's -Warray-bounds
> -fdiagnostics-details. For example:
>
> In file included from ./arch/x86/include/generated/asm/rwonce.h:1,
>                  from ../include/linux/compiler.h:339,
>                  from ../include/linux/export.h:5,
>                  from ../include/linux/linkage.h:7,
>                  from ../include/linux/fs.h:5,
>                  from ../fs/overlayfs/util.c:7:
> In function 'ovl_upperdentry_dereference',
>     inlined from 'ovl_dentry_upper' at ../fs/overlayfs/util.c:305:9,
>     inlined from 'ovl_path_type' at ../fs/overlayfs/util.c:216:6:
> ../include/asm-generic/rwonce.h:44:26: error: array subscript 0 is outsid=
e array bounds of 'struct inode[7486503276667837]' [-Werror=3Darray-bounds=
=3D]
>    44 | #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(=
x) *)&(x))                       |                         ~^~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                 ../include/asm-generic/=
rwonce.h:50:9: note: in expansion of macro '__READ_ONCE'
>    50 |         __READ_ONCE(x);                                          =
       \
>       |         ^~~~~~~~~~~
> ../fs/overlayfs/ovl_entry.h:195:16: note: in expansion of macro 'READ_ONC=
E'                           195 |         return READ_ONCE(oi->__upperdent=
ry);
>       |                ^~~~~~~~~
>   'ovl_path_type': event 1
>   185 |         return inode ? OVL_I(inode)->oe : NULL;
>   'ovl_path_type': event 2
>
> Explicitly check the result of OVL_E() and return accordingly.
>
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Cc: Amir Goldstein <amir73il@gmail.com>
> Cc: linux-unionfs@vger.kernel.org
> ---
>  fs/overlayfs/util.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 3bb107471fb4..32ec5eec32fa 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -213,6 +213,9 @@ enum ovl_path_type ovl_path_type(struct dentry *dentr=
y)
>         struct ovl_entry *oe =3D OVL_E(dentry);
>         enum ovl_path_type type =3D 0;
>
> +       if (WARN_ON_ONCE(oe =3D=3D NULL))
> +               return 0;
> +
>         if (ovl_dentry_upper(dentry)) {
>                 type =3D __OVL_PATH_UPPER;
>
> @@ -1312,6 +1315,9 @@ bool ovl_is_metacopy_dentry(struct dentry *dentry)
>  {
>         struct ovl_entry *oe =3D OVL_E(dentry);
>
> +       if (WARN_ON_ONCE(oe =3D=3D NULL))
> +               return false;
> +
>         if (!d_is_reg(dentry))
>                 return false;
>
> --
> 2.34.1
>
