Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CB13E5599
	for <linux-unionfs@vger.kernel.org>; Tue, 17 Mar 2026 22:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773787371; cv=pass; b=Kz3G2Z9wqUAQAuhtcQHmUxe+judVl3SH6dGMieH/pYoHLlMn1hEVpqWr+NMOzJukRc7BMG2KLsY06QXHGkpEUxzuZhG3YmS1mT7UOTSgoGUN8EMFCl3hsOauTZoosLhUyzDJuBY8LQhhbL3UfOO+751QbeFnWgT/aPQqlGM7J74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773787371; c=relaxed/simple;
	bh=oScUuIjIjb/tZulbsi2FkIBZwopgeujtHsSn1k3PGiQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DQQpJVJ2inCPKrJblUlJ7SP05UVdPLkKSOutsRfusr2uXGT3J9/C9wPtEsl0TNb7sHOYrWD3TNY4ZnTokj4HOQy51AcYrSL19/68hlCF3LhJqR5lBXtIBh083hKgt7eqbMGdF2iPR2wubo7BPQeo0TO1ZClXw6pcvW0VN2ANCRM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=Rp4KChT/; arc=pass smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="Rp4KChT/"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-82a67ce6969so395241b3a.1
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Mar 2026 15:42:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773787369; cv=none;
        d=google.com; s=arc-20240605;
        b=bK1jxSUHCLCQXuAfhFTKnJh87mGXIrLLHWksglOWtLJ0AUeeca9wGGWqvsvjc/QLWK
         MFZ5oiekz01dL65mgMCnqqsSaQX2j6X2ubH7uz6Myq6ReibehjxYT3tdOwleVPWdFQQe
         q/m6Z6c95x5zqTllRczNnPf2jgK8S+7vYi4aDohP0yhv+ReJao0nDzSIvouVQl68V4Zy
         Dy/sSqoWIuzLNyLqgr9oL25hOxNGMDn37Jv0/uEOV45nwlsm0eGNlRb/N8jR/edHoYa9
         +gzZglMiAPFxeM5tnuJYLqlgrLKbXXegDMZI2t6p3ujnMYrDIy/DUKFEEwhhXVyw6kyt
         n4Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=B8weZ6sz5Sw0SJMaIbsh0p66JDKF/4Vt78zNnjgP+G0=;
        fh=aj2wSRwYANM4mCvFN8O6JfvKiJ57WVjQCUV247ouo24=;
        b=XabEzOk51BlMo8Lk9BZjXK4oXj5aZYSpd2p9mpRsmrQ7/c6rRyimz7w/MhfWsX2236
         pI1NmqpoEDSJjbILuplr/yq3U+pCrSeU2L7gTQDoavJSZmp96n8LGaPqIR3rsIO7299J
         cW24jclUAcoi+b7UwVPTEu6sX7enCqjBOv1XlpO7Od8rds3thTlzWCYT3kgMsWYMPZqt
         irC/t0ZN4kymfQBYcf9H/vdp/YyhldRaW+CUSS3Q1YSykxIHBJX59+jNRTapGsFv4++n
         WmxqQ32cFrLnj1AM25F5jiU5YShEj6AzE+QUG0uiig2DAcmScfX13D0JH9apBW32L4i2
         vpfQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1773787369; x=1774392169; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B8weZ6sz5Sw0SJMaIbsh0p66JDKF/4Vt78zNnjgP+G0=;
        b=Rp4KChT/WWpTu8I8ai/ucT9lIndTLNcnHKlKHGJEhA9cz9/jOtKHRfTj8Mt4k99hLz
         /I89gTL4UvFCXEXQ+emW/vqxpORQl6tRIFW8QI509j2GTSrVZtaum8vUBrpYmpT8jd0A
         wISeWETh5lykScg+b9x3/WRqzlb+SKvIZCRY3dNv6Dl6SFOWy6A033zHv7EsB5rYeEko
         x5aPlsVTKpmigGziLqh1SSMCTlzwf+Rl1EejgXkWvWLlaOaqd9ELuzLTq9ZeivFTN19l
         O/ftWife1HLsD1vxt+eBkShi1+KqmNcKNpSCyVKzgaGVSMOMFeuIaCIQZbGea997OFsZ
         J51Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773787369; x=1774392169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B8weZ6sz5Sw0SJMaIbsh0p66JDKF/4Vt78zNnjgP+G0=;
        b=VxJyPSgtusnV7kq0azgRURYk13+4FirHZLzx4ZuTTf+NWEVV7vWhFG8tpePPjL9o1B
         14EFwb4Q6zA5KtGCQk3dq+mZuhOiAxCEJnbXz4+D6cr7uOCcaYNpKR/hXGPUWkqArSD4
         Mg46oTUSFHlFtKZaerULCfNjpCMbu2jgiozJNDfyB2M5ub12tCrQ9EmHgZIDYe+O3/AD
         1J+cCIy/UeNLeNeMAsMAyjvChidH2DlP8R3DiyMeU/QuexZ5jZ4dseTVBgZwH4hNBpo6
         M4/laAf167TZjGV5Mvpt1LKOPO55FtbH5keXzNWy20kUqhh+s2ypHyH7W3klyny80+ex
         CNxw==
X-Forwarded-Encrypted: i=1; AJvYcCVakfvbRPl+AcMcZtT2vbdMGIHZaH3xCNfMvsz6ZHU30wk79q8XEqNwQ7oVavrOH07VDoxt4lGlsPPwamoC@vger.kernel.org
X-Gm-Message-State: AOJu0YzkNny/Im8WpKgLhCRvRBDZeiqvfKiN5F6taQBounLzN5J3UtKa
	Qv6dGi3kQywMvXncw0zTWpNFwoGk5714fz8iQ9ee+mA0pKZGmx6k0vTYyA/qbU3hJzkAuqddEc2
	r2f5b/SRmRrXQHcifgoFvSF9ITGm4Hc87p0FOz43q
X-Gm-Gg: ATEYQzykP/QqecQkbLqbx7eajbHRWpbto+4jPmaQ0JVWGtSFqD8CUlp/sQ1xKDrzvjS
	6+hMw6TySp6SUSTh3lkEOjnduHU6FKXc9jSUE15Yh9sXUBV9tuuay10YILdSKs71Wd+FXBCVTCj
	MCUtQ5ziRNyc7Tw1Rvvfa+wTJtoOznP4qByTUsKpEQNs085lj+XENgySwJDxvhFry5VH+eqh8Xz
	SxQ3MhIOXWeWIsHYapcaFUvM+RwLhuigjxL/yMzCvA0jbtXEd08OpL3EobDnGLRh9bA7E3UfcAi
	eSpn6Ss900p8xWor0Q==
X-Received: by 2002:a05:6a00:1816:b0:827:2ec9:e1bc with SMTP id
 d2e1a72fcca58-82a6af3b680mr1004833b3a.61.1773787368885; Tue, 17 Mar 2026
 15:42:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260316213606.374109-5-paul@paul-moore.com> <20260316213606.374109-7-paul@paul-moore.com>
In-Reply-To: <20260316213606.374109-7-paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 17 Mar 2026 18:42:37 -0400
X-Gm-Features: AaiRm51ktGDW1-usZMxMHsT1xbcaRYx3q6Ml_vERE0ki9AcWlEliFtDWBIy0vmI
Message-ID: <CAHC9VhTiB73F9fB1o3K4NfJ-Fa50MsVA_=79kn6X34L62J_TwA@mail.gmail.com>
Subject: Re: [PATCH 2/3] lsm: add the security_mmap_backing_file() hook
To: linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org
Cc: Amir Goldstein <amir73il@gmail.com>, Gao Xiang <xiang@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 16, 2026 at 5:36=E2=80=AFPM Paul Moore <paul@paul-moore.com> wr=
ote:
>
> Add the security_mmap_backing_file() hook to allow LSMs to properly
> enforce access controls on mmap() operations on stacked filesystems
> such as overlayfs.
>
> The existing security_mmap_file() hook exists as an access control point
> for mmap() but on stacked filesystems it only provides a way to enforce
> access controls on the user visible file.  In order to enforce access
> controls on the underlying backing file, the new
> security_mmap_backing_file() hook is needed.
>
> In addition the LSM hook additions, this patch also constifies the file
> struct field in the LSM common_audit_data struct to better support LSMs
> that will likely need to pass a const file struct pointer from the new
> backing_file_user_path_file() API into the common LSM audit code.
>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> ---
>  fs/backing-file.c             |  8 +++++++-
>  fs/erofs/ishare.c             |  6 ++++++
>  include/linux/lsm_audit.h     |  2 +-
>  include/linux/lsm_hook_defs.h |  2 ++
>  include/linux/security.h      | 10 ++++++++++
>  security/security.c           | 25 +++++++++++++++++++++++++
>  6 files changed, 51 insertions(+), 2 deletions(-)

...

> diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
> index 17a4941d4518..d66c3a935d83 100644
> --- a/fs/erofs/ishare.c
> +++ b/fs/erofs/ishare.c
> @@ -150,8 +150,14 @@ static ssize_t erofs_ishare_file_read_iter(struct ki=
ocb *iocb,
>  static int erofs_ishare_mmap(struct file *file, struct vm_area_struct *v=
ma)
>  {
>         struct file *realfile =3D file->private_data;
> +       int err;
>
>         vma_set_file(vma, realfile);
> +
> +       err =3D security_mmap_backing_file(vma, realfile, file);
> +       if (err)
> +               return err;
> +
>         return generic_file_readonly_mmap(file, vma);
>  }

The kernel test robot helpfully pointed out that this patch was
missing a security.h include for the newly added LSM hook.  The fixup
below has been applied to the patch in lsm/stable-7.0.

diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
index d66c3a935d83..f80925b66599 100644
--- a/fs/erofs/ishare.c
+++ b/fs/erofs/ishare.c
@@ -4,6 +4,7 @@
 */
#include <linux/xxhash.h>
#include <linux/mount.h>
+#include <linux/security.h>
#include "internal.h"
#include "xattr.h"

--=20
paul-moore.com
