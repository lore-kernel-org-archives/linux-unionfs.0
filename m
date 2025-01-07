Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F2F148838;
	Tue,  7 Jan 2025 11:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736248421; cv=none; b=Tm3SalvoIMUw2zRmGnnoIwenxLHXrZJ+/Qsg9QLkQIlQC7qMbdLjlGHObjNbk3Iu8jDkMvUTDA92WDBpm7jSaPu5WdEIk2LYgIgQO48HGaKhZTSlC4zWjKrrqCNVEOolP0SXLPJNQzK7TC5GaFh/c0IMcoDDFoAuXU9F92bT7CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736248421; c=relaxed/simple;
	bh=6XE/aliWGr+W26o2fjUc7Z25p+2CU6ECbOVEjcYQUIo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eoPkNf5L5kzc39ULOHt0cB03drBj72CKsfUWD9KHDyWQdJO5uu/v13tC4GInj2Dnqpw0Sb4KWA6uzUebcbO7/8VDFGgvjGwKE4bcAUzWyGDsMvu7IVEsoi4pPukQRN4xJ6tNvp4PStqie9KnyJfP43Q0E5ENiluZ7xAXIyVRxVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f2jBYZxG; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f2jBYZxG"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5d7e3f1fc01so3149572a12.2;
        Tue, 07 Jan 2025 03:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736248417; x=1736853217; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mr/GzVDnk1vhkDYSLmfDLR/Vh+afBQJAWF7/ClflUCc=;
        b=f2jBYZxGwdZA+IyB2BNEEIk6jKkUIc8tOht0pllgCegkrJcHH2phQ0rzI0erGCQ9oA
         gIkii9X+yqEamrUccoSg+sizpmEVrenGxfBC4rD+PJlvzhEO4VI2GsJaKp5D8wR2sv3H
         gFdURjtlpxE8IZEin5oXuGGEqwhW9atweqobULzscrJ+c4J2EV7XN9aHhpE3s07YePKD
         oxj9l7blapODNCuDLPp9iA/Pic7SGnG9SHo53uXFsFk29gAUo+Kis9IFx2bU+VE2VmH8
         O8Zp014bFudDIcxsKM3B6WaCLfXo4Cb68Hn7X8UmdQ4+nYBZcyNeP9sveJr05sLqwHS5
         FUHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736248417; x=1736853217;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mr/GzVDnk1vhkDYSLmfDLR/Vh+afBQJAWF7/ClflUCc=;
        b=c/k2UTJva6KAK7ai/+M+iB6ld4pIYAm1H17jnxoMn2KH+3m37twEVa1tqUcIzqAz2b
         +bkTo4VvlCN9Lm4nMuoL3mBlvWwRIsBpVD0HSolqHyHdbN8VK3oNZd9lUV6L+NLa0iBP
         4QRzfrT1nGsjJGRy3Cq27Iww2Je8HNuNLdAfscXa2AqedVxnR5KkodJ/iDzC02LrMbjb
         8dkTVKDsdPWkzOC2JK3iWD7PtnB9ia58NdZXmeXejXQvwXyY+PM44q9qJMQ92l7TwkXH
         Cbl9s6CcUveyJso0UjEtqGp+/+lgflgwaKIAvU3I60MgP+Wwfibz1Bew2pifD2ktEPuu
         JIjg==
X-Forwarded-Encrypted: i=1; AJvYcCUC/phCYDZO2CW0ZEWLI89nmB1fy9KXRz3Jsc4zEh7LBqhzmPnjxUWwgxj5Fm+sh0tKf1dTTGXVUjdcCcL9@vger.kernel.org, AJvYcCUQK17cfA5rzAo8mYCw/kS4YTP+wvjmrg0RgGnir4bObV6T8vaLPsEH0wlkJsisjUCEOlV5Rp/IJQOCc6lcyA==@vger.kernel.org, AJvYcCVYZ3FFWKv2PBL/frv3en6oPRNEZsgQHkwxdDhh/Fq/yd/AX+IQAfiylD9n4DAztf9nH226t+w8Zno=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYJx14wH2MHxT13zJm8O6OHPV9gt1dhRwYVYftaS8aqR9b3uxn
	bDssxbQFHx/6R0rxgtj36pwXP6t1wJ7WEllBbFyqzRGyqlv3mg0PFq03BRrApyiPH7MF0XfOi8p
	BV8n5dzdqDbCg0FWFj7QJg83MqSpxMZRi+H0=
X-Gm-Gg: ASbGncszF77vi+Ta9sUKuLnZujXN0MS81aoTr5Y1O3mncR2+cw6cXr7OA0xWVL573vY
	q5UU7zmdUQlo9SfI7zZUUl4obUdJzaI1A66ZkWQ==
X-Google-Smtp-Source: AGHT+IHZOZuGh+Cq1RVbbzN662zcy1YLAMdsH19pgW8fy9okRskaf6pwCzHbHpwNVgGdw916i0lU9B/Y72Gdu/rdaCk=
X-Received: by 2002:a05:6402:528a:b0:5d3:f141:ccf6 with SMTP id
 4fb4d7f45d1cf-5d81de16c82mr57619463a12.32.1736248416238; Tue, 07 Jan 2025
 03:13:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cf07f705d63f04ebf7ba4ecafdc9ab6f63960e3d.1736239148.git.geert+renesas@glider.be>
In-Reply-To: <cf07f705d63f04ebf7ba4ecafdc9ab6f63960e3d.1736239148.git.geert+renesas@glider.be>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 7 Jan 2025 12:13:25 +0100
X-Gm-Features: AbW1kvYLrDdrgGevJS4mpM4stjr2b9nsS6FuxuvYsZ9qIZgGsUE-v-JWNUQx-d4
Message-ID: <CAOQ4uxjESOJsb2GDx-c==_cLtF=wqtDAprcDmjwiq25hyzQFwA@mail.gmail.com>
Subject: Re: [PATCH] overlayfs.rst: Fix and improve grammar
To: Geert Uytterhoeven <geert+renesas@glider.be>, Jonathan Corbet <corbet@lwn.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 7, 2025 at 9:45=E2=80=AFAM Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
>
>   - Correct "in a way the" to "in a way that",
>   - Add a comma to improve readability.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Acked-by: Amir Goldstein <amir73il@gmail.com>

John,

Please take this patch via the documentation tree,
as I have no overlayfs patches queued for v6.14.

Thanks,
Amir.

> ---
>  Documentation/filesystems/overlayfs.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
> index 4c8387e1c88068fa..a93dddeae199491a 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -266,7 +266,7 @@ Non-directories
>  Objects that are not directories (files, symlinks, device-special
>  files etc.) are presented either from the upper or lower filesystem as
>  appropriate.  When a file in the lower filesystem is accessed in a way
> -the requires write-access, such as opening for write access, changing
> +that requires write-access, such as opening for write access, changing
>  some metadata etc., the file is first copied from the lower filesystem
>  to the upper filesystem (copy_up).  Note that creating a hard-link
>  also requires copy_up, though of course creation of a symlink does
> @@ -549,8 +549,8 @@ Nesting overlayfs mounts
>
>  It is possible to use a lower directory that is stored on an overlayfs
>  mount. For regular files this does not need any special care. However, f=
iles
> -that have overlayfs attributes, such as whiteouts or "overlay.*" xattrs =
will be
> -interpreted by the underlying overlayfs mount and stripped out. In order=
 to
> +that have overlayfs attributes, such as whiteouts or "overlay.*" xattrs,=
 will
> +be interpreted by the underlying overlayfs mount and stripped out. In or=
der to
>  allow the second overlayfs mount to see the attributes they must be esca=
ped.
>
>  Overlayfs specific xattrs are escaped by using a special prefix of
> --
> 2.43.0
>
>
