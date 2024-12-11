Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECC6236FB6
	for <linux-unionfs@vger.kernel.org>; Wed, 11 Dec 2024 09:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733910242; cv=none; b=e8z1HvWbmYN6yn8LfOF+4ARjmCWA3u3bVnVFuktkvwtOPqEDjkFNgffvKLYZIjoodzjuHH8iZ2xDLeIy7T0Xr/jetpf800zZaVZZoHpTCSi3knNwex/9ledVhuFXNAiXApi5MAL6/+VABXICZx4RTEEq9LPCA5EMSPEPWtbSXcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733910242; c=relaxed/simple;
	bh=8KRm8o1zV0wpv3H2yQZEvl8+GD82G48SNSueUdOBDz0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I79FebgEl6LXxA/kbr7VZfqDogywdgH1rDaMC2bRN3TccwP5YzZXN5DOJAN2osubrFFkbKE4uaRwnnh6NmUep0I50jIxs06PfO+weI43bt0tY2QVwOfauTj+VLEPRxk+d6MuBfltIUOIym0lmcaznj8pCEj9zNo6ac8Pj37PhB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ilr63LQ+; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ilr63LQ+"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5d3d0205bd5so5933177a12.3
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Dec 2024 01:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733910239; x=1734515039; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k0J1AWg+bzB1T7PXoJrhM6/zrY07tqFzRe4i5kAQBdA=;
        b=Ilr63LQ+ia8cV9BJ1XEXzw0FsMKqKp4lqXTSUxhpM2qYjxlWstX5Acr9sUVmQIVvGZ
         dnZOVgI8l+ZDk36OrBcFji98Vn6A9clzrKfb8FOouTzlmV0LWBU+3bydGvDyVOQa8YeY
         IuJACRl5dJw8CwdzOABX2hzoE+Xd2tDeQlZrw/SN4rD+ckjpgVZCv/Y1ZlHMl/fP14+E
         VQ8j85N0JptJveM//6uHwyMxiUhk/z81+0VyrC4S5ZrnfQDeVtRGQd3gEXzRqwKmRe6Y
         9++EvPMSszi8ArZ9IR8JBX7oyfvmeagPs3vq02HMx4yr4mGlQrWNtGp7BEWIAR8sH4MN
         tFrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733910239; x=1734515039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k0J1AWg+bzB1T7PXoJrhM6/zrY07tqFzRe4i5kAQBdA=;
        b=bz8Br/EQcBcm9vrJJPdc6/VQr8GJw96hc5gOq2cqbPYFksABt0ciIn6nE1BqcZg4hv
         a3F8KmiruW59CmkCYkg0ma9CjrskTJ4XrKCsiQItVhbdgquG7zHrYy42QdeMWFUDhQmx
         77jAaTM2d+riayrVU1Y5Ht6hjYOs3459CKll70VcrIfMBp2kQOu3TwkYoxuNobadbYyo
         J/2t6j46rM49D0tCRdJvEDfm/KAmDR9U7VklgXQXltFizt8XXK0RyWR5ar5pjMHuiwE0
         qu8Ge4UbZckEyx/x3llGyn6ohvcf9SNdJBt2vlM4e+vhvk/wq1Y9EagBw3qStFUrz6Tj
         pXfg==
X-Forwarded-Encrypted: i=1; AJvYcCW6VtoglxNlWALgDIzpfvh8/9UAv6s7qDdNa+2CHls4pvhpNEILOFvBcHUdgXKjC73FrVIrmjfruhyHGPUh@vger.kernel.org
X-Gm-Message-State: AOJu0Yxs8zsX0vfNotsTuX4Ac6v9boBKuAEk673aKC5R0Ct+XGe5wjyW
	l7zhW/dzYkA04lhtb6EkxxWfiFj4xSxpHoG8ssm4GpJlp0GYi19rZQ8RER3MXxKBXlwArt9ZyjZ
	B5Oi0mNdO9ZzJCHPEwO+pe7bJVQY=
X-Gm-Gg: ASbGnctQ9wShNX6pU3C8ZlHriMFDLUkxr4pjDPL/zsSqVl3aWurxLeG0ME3/psYn7OX
	A9skvi9EZmC77s8W9+r/oPiAO1jFZmqo+aOc=
X-Google-Smtp-Source: AGHT+IECwjvvXTCm18ZNhzpNsVfvMgAYb0Igg1GaZbhBstEzIex/MmnE2qw17IwrVw7WFaTAWc2QyexN13LFArF2wy0=
X-Received: by 2002:a05:6402:234f:b0:5d2:7346:3ecb with SMTP id
 4fb4d7f45d1cf-5d433081e4amr1775865a12.12.1733910238320; Wed, 11 Dec 2024
 01:43:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
 <69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local> <041dcc1a-0630-27b9-661b-8c64a3775426@huawei.com>
 <a39ef271-dc1b-4f61-ba01-dde5b127bef2@lucifer.local> <f2668332-78ac-4dc1-abcc-440e38964ccc@huawei.com>
 <CAOQ4uxh5azF6As6TvV2eCKpnbct0-vNwJLTAwSiKc6QjK5TUBw@mail.gmail.com> <568698a0-c2f2-45d8-9d8b-e22e942fa422@huawei.com>
In-Reply-To: <568698a0-c2f2-45d8-9d8b-e22e942fa422@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 11 Dec 2024 10:43:46 +0100
Message-ID: <CAOQ4uxjBB7EUOnHB2n9BUGJ_TrHqvqJLksVyxcnpOUCR+7Tfyg@mail.gmail.com>
Subject: Re: [PATCH -next] ovl: respect underlying filesystem's get_unmapped_area()
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jinjiang Tu <tujinjiang@huawei.com>, miklos@szeredi.hu, 
	akpm@linux-foundation.org, vbabka@suse.cz, jannh@google.com, 
	linux-mm@kvack.org, linux-unionfs@vger.kernel.org, sunnanyong@huawei.com, 
	yi.zhang@huawei.com, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 10, 2024 at 8:19=E2=80=AFAM Kefeng Wang <wangkefeng.wang@huawei=
.com> wrote:
>
>
>
> On 2024/12/6 20:58, Amir Goldstein wrote:
> > On Fri, Dec 6, 2024 at 11:45=E2=80=AFAM Kefeng Wang <wangkefeng.wang@hu=
awei.com> wrote:
> >>
> ...
> >>
> >> So maybe use mm_get_unmapped_area() instead of __get_unmapped_area(),
> >> something like below,
> >>
> >> +static unsigned long ovl_get_unmapped_area(struct file *file,
> >> +               unsigned long addr, unsigned long len, unsigned long p=
goff,
> >> +               unsigned long flags)
> >> +{
> >> +       struct file *realfile;
> >> +       const struct cred *old_cred;
> >> +
> >> +       realfile =3D ovl_real_file(file);
> >> +       if (IS_ERR(realfile))
> >> +               return PTR_ERR(realfile);
> >> +
> >> +       if (realfile->f_op->get_unmapped_area) {
> >> +               unsigned long ret;
> >> +
> >> +               old_cred =3D ovl_override_creds(file_inode(file)->i_sb=
);
> >> +               ret =3D realfile->f_op->get_unmapped_area(realfile, ad=
dr, len,
> >> +                                                       pgoff, flags);
> >> +               ovl_revert_creds(old_cred);
> >> +
> >> +               if (ret)
> >> +                       return ret;
> >> +       }
> >> +
> >> +       return mm_get_unmapped_area(current->mm, file, addr, len, pgof=
f,
> >> flags);
> >> +}
> >>
> >> Correct me If I'm wrong.
> >>
> >
> > You just need to be aware of the fact that between ovl_get_unmapped_are=
a()
> > and ovl_mmap(), ovl_real_file(file) could change from the lower file, t=
o the
> > upper file due to another operation that initiated copy-up.
>
> Not sure about this part(I have very little knowledge of ovl), do you
> mean that we could not use ovl_real_file()?  The ovl_mmap() using
> realfile =3D file->private_data, we may use similar way in
> ovl_get_unmapped_area(). but I may have misunderstood.
>

First of all, you may add to your patch:
Acked-by: Amir Goldstein <amir73il@gmail.com>

I think this patch is fine as is.
w.r.t. question about ovl_override_creds(), I think it is good practice to
user mounter credentials when calling into real fs methods, regardless
of the fact that in most cases known today the ->get_unmapped_area()
methods do not check credentials.

My comment was referring to the fact that ovl_real_file(file), when called
two subsequent times in a row (once from ovl_get_unmapped_area() and
then again from ovl_mmap()) may not return the same realfile.

This is because during the lifetime of an overlayfs file/inode, its realino=
de/
realfile can change once, in the event known as "copy-up", so you may
start by calling ovl_get_unmapped_area() on a lower ext4 realfile and then =
end
up actually mapping an upper tmpfs realfile, because someone has opened
the overlayfs file for write in the meanwhile.

I guess in this corner case, the alignment may be wrong, or just too strict=
 for
the actual mapping, but it is not critical, so just FYI.
There are worse issues with mmap of overlayfs file documented in:
https://docs.kernel.org/filesystems/overlayfs.html#non-standard-behavior
"If a file residing on a lower layer is opened for read-only and then
memory mapped
 with MAP_SHARED, then subsequent changes to the file are not reflected in =
the
 memory mapping."

Thanks,
Amir.
