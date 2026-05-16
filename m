Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41F6387598
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 22:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778970564; cv=pass; b=FA5axBrbp683d4NaeXbIAe+c9ujwUM0aVvYQbp5q9dSSJGZc3lfFUt7+a0TDhZcdOQ8TTqMNVENLfMwv8Qo0Bx6ZH4jtea+3w+u3OTuffTFQDjPa5xKrkl/msreOTYyhSYdNv4oEEnrO7mhOksmLr3lGiYouY+9LebECRHgmJU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778970564; c=relaxed/simple;
	bh=Y7g/w+9AWXA5kg1j44KDL4S8Jg09RruR841N4UPuBJw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jPUT+c6e/MGY22BwVLtzf3bODPQODThcaOhbiuiWQk4Cy8/coNDraOe1E9WPf4jEHcN4bbfJAIQgRQu/o9xRM7nibPDsxOU5xAT0Efj9/FLa1b085Tv63SKZrzSae7t2rNReca3LjDxzHA70/OUYT6w4PtgzvtUcDnJqIEirRsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nrZVZ7Eu; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nrZVZ7Eu"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bcda7765d64so454316466b.1
        for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 15:29:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778970561; cv=none;
        d=google.com; s=arc-20240605;
        b=TaIl3NWySy7uyj4B7YUpbMEdGKvD6q7dBNP2cS/+MPd8qWJckA1G5NnBXoneKHoSNY
         gGYGAr6wnNLa0wIl2ABApgCKOhA20h5B8BEPPGgbiv78g2nogyDG01lZVOk05OhrI6AW
         48XOZauAMHaIFRqnEN9XfDoEiN2eP2VqFFmEeO9q3D2OfU+SkqQAXUnMmWyQ9UVy/UBj
         2wJz6w6JhQyPQu8te9HUO9CNilffSGKwpF09PS34/sh9PE/aBUfEKjiRf/X8rMiGQEpf
         in9Ko9XkZ+SZZOjP9L6LKTcdyaLSPKtlsjiNa8W9ZZOuDhzfE59zof1bei+Q3wBk5D9G
         yxWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Xm9URiwTfwNZYfRIur/Yjy8U1afMXVgJZJv7flVHF+8=;
        fh=G2WWi36HJClaWAmnt5uzuzPj3MryJKmMpgfsfiIIA1o=;
        b=TCykcmgNJDIR4yBDN6RdbR1nqRfO1wq6AsXT6cF6xu9cpXJhEZ2sk5GWQO98/K+dQS
         I3Gef6w2OJkqQxteUQh19hbnBPWNdZhM2GMjnXYdwpcK4X3qqHYY7eH3pE07p4A7qlWt
         uCn9ouinvmqzLLSM5a7TZQj16+yogEFM/V4f8+DMMXJNwDNWD4idWzWPWqfzSmFcB84v
         NeRim88mG1jSDadf4CkM34aMU4N69r8k5gXRpyGcjLpKAmWcPJRTlbrEY4NUgDmm2T7R
         jhkPUDvLFFWaOV1aNLeetdcMJRDOmRSvbLi5VZrpHZYzfhJ1qQXYB+qCS5XFioSCffBB
         6LEg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778970561; x=1779575361; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xm9URiwTfwNZYfRIur/Yjy8U1afMXVgJZJv7flVHF+8=;
        b=nrZVZ7EuQ9PJtF27Dad27s4a4oXvyxf4qNupvuTKcxo+sTMN8jMjQ2cgOjhopCTBTX
         uqvSSJ/+lhYjFLZsjk37FtAO+rk2bJFe+L/09Qe2A1tJwcaIwUcDRvhWnPR2JfsxufqP
         lx3oFNlj2iz0O96bvtMpnBBgW1EjRWBOmOk94Iyu+TuxQjbVLKStgY7s/Dox8gbhUXRz
         1mUmzaDhmexd4csyrR98mw8iZ/Zh76WTs4Tlfefm8ZaIw11gTWckYw44DmuZ6h9ynp2k
         z+tbV3bFxrQxu0HyC148ndMlgR8s/xiZs1dbTHgnrV5+c1YvQ8IW2UZfoLLxFXD2XY/f
         63lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778970561; x=1779575361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xm9URiwTfwNZYfRIur/Yjy8U1afMXVgJZJv7flVHF+8=;
        b=K+crtGI9X4Yd5H1iXWEuev++MUYVMfCy0gjOn1Hckda/qCXW21OqCsqegrIdgYgPKK
         7syoCucwBITHdXz25jpCR6bUyKYJ48kub4NfHydFpTD+xzB5vZ7ji4iwpMCJUPYQyT6e
         cxOW+4L0pdhF4FecpcFreLhuqvLgrP86nBlnXXwNkjOvOgZ8efSFUv/gZaZogDGxs1P3
         Ual4vTbmN+j4ierPw1MRlatgV82jPdduyhOro4D4o0Lv+k6dbqpLntoGSgfn35UtgVvB
         yXMZWPG76M0iPPWV2wDnJtW5289xFFsTqNAe9BvGF/TLjvi+CFikBIlb50OufNYjwHe7
         iJbw==
X-Forwarded-Encrypted: i=1; AFNElJ9r+jdsHp9qT5TzrN+6lI843JXHR0YN3T/UU0KaDscPMk/CIDfBkP5T0s8pIke+9oWXjgtmJ5Z+AM2yh1KF@vger.kernel.org
X-Gm-Message-State: AOJu0YzILhA9WdVaDTvrIO9yisKgfKeFAkjwtMc6TPRh4cAKoMtLROHZ
	1oALiOAKpKESFv3PCa4lV6cTL/FlqrCb7fTVoTO9YwqISXHsS3+iPyJMg9YFDTOw54KJ+q3NIkR
	101o+8/SmRrjgKZF9yX8f6s7zk+BlRfBaY0JnvQw=
X-Gm-Gg: Acq92OHkGUPDC/RVaUOXMuUEDwmBdZWNjz4P1VPc1ui7x4D3lf3zupkT5526oMJF0Xh
	16NQ9qFYRnfNJeUVCxKPzW4pREAoL61KvwwiOjE1szPM2yoKYnEMiFd6ZHHFO74oE5HhH1aYwjz
	TnXxcFKYHOAoQDSgsjdoAhGbobg7cu9hzmnP27b3OgsI/XNCB5k9IVwF1xJ+jCzHoikpdxoRecw
	zEEjGDcdp68BeyzL/5QZHyLi2CL8+SWczYoZQ0DuEt3YuB1HbXbYAd25/XPvJhMmaRxMTSGjKnY
	PscNj6CMR/Rlh9gCIt14oDNw20gr1mJyocqt7XYd1w==
X-Received: by 2002:a17:906:fe08:b0:bd5:1605:e1c3 with SMTP id
 a640c23a62f3a-bd51605e354mr447801566b.1.1778970560643; Sat, 16 May 2026
 15:29:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com> <20260516004004.1455526-20-joannelkoong@gmail.com>
In-Reply-To: <20260516004004.1455526-20-joannelkoong@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 17 May 2026 00:29:09 +0200
X-Gm-Features: AVHnY4IJtDRqENxZ5yafH4xjuZwDeWgfB_Pc82vXmpsqRKVfkfdyTsCH9GbbJxs
Message-ID: <CAOQ4uxgxXMYjptBMggikrEfnhKmdGKxEauD4waT8JotKtgYs-A@mail.gmail.com>
Subject: Re: [PATCH v2 19/21] fuse: add passthrough setattr
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 16, 2026 at 2:53=E2=80=AFAM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Add passthrough setattr which sets attributes directly on the backing
> inode through backing_inode_setattr() instead of sending FUSE_SETATTR to
> the server.
>
> Passthrough setattr is checked before the
> handle_killpriv/handle_killpriv_v2 suid/sgid stripping because the
> stripping is handled natively by notify_change() on the backing inode.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/fuse/dir.c             |  3 +++
>  fs/fuse/fuse_i.h          |  3 ++-
>  fs/fuse/passthrough.c     | 28 ++++++++++++++++++++++++++++
>  include/uapi/linux/fuse.h |  1 +
>  4 files changed, 34 insertions(+), 1 deletion(-)
>
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 4c7e3e1604af..b67b3b334e69 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -2506,6 +2506,9 @@ static int fuse_setattr(struct mnt_idmap *idmap, st=
ruct dentry *entry,
>         if (!fuse_allow_current_process(get_fuse_conn(inode)))
>                 return -EACCES;
>
> +       if (fuse_passthrough_op(inode, FUSE_SETATTR))
> +               return fuse_passthrough_setattr(entry, attr);
> +
>         if (attr->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID)) {
>                 attr->ia_valid &=3D ~(ATTR_KILL_SUID | ATTR_KILL_SGID |
>                                     ATTR_MODE);
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 89c9333e9702..0d978a9837a0 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -1279,7 +1279,7 @@ ssize_t fuse_direct_write_iter(struct kiocb *iocb, =
struct iov_iter *from);
>
>  /* Inode passthrough operations for backing file attached to inode */
>  #define FUSE_PASSTHROUGH_INODE_OPS \
> -       (FUSE_PASSTHROUGH_OP_GETATTR)
> +       (FUSE_PASSTHROUGH_OP_GETATTR | FUSE_PASSTHROUGH_OP_SETATTR)
>
>  #define FUSE_BACKING_MAP_OP(map, op) \
>         ((map)->ops_mask & FUSE_PASSTHROUGH_OP(op))
> @@ -1367,6 +1367,7 @@ static inline bool fuse_passthrough_op(struct inode=
 *inode, enum fuse_opcode op)
>
>  int fuse_passthrough_getattr(struct inode *inode, struct kstat *stat,
>                              u32 request_mask, unsigned int flags);
> +int fuse_passthrough_setattr(struct dentry *entry, struct iattr *attr);
>
>  static inline bool fuse_use_entry2(struct fuse_conn *fc)
>  {
> diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
> index ae0137caa06d..c083ab68537e 100644
> --- a/fs/fuse/passthrough.c
> +++ b/fs/fuse/passthrough.c
> @@ -9,6 +9,8 @@
>
>  #include <linux/file.h>
>  #include <linux/backing-file.h>
> +#include <linux/backing-inode.h>
> +#include <linux/posix_acl.h>
>  #include <linux/splice.h>
>
>  static void fuse_file_accessed(struct file *file)
> @@ -275,3 +277,29 @@ int fuse_passthrough_getattr(struct inode *inode, st=
ruct kstat *stat,
>
>         return 0;
>  }
> +
> +int fuse_passthrough_setattr(struct dentry *entry, struct iattr *attr)
> +{
> +       struct inode *inode =3D d_inode(entry);
> +       struct fuse_conn *fc =3D get_fuse_conn(inode);
> +       struct fuse_inode *fi =3D get_fuse_inode(inode);
> +       struct fuse_backing *fb =3D fuse_inode_backing(fi);
> +       struct path path;
> +       int err;
> +
> +       err =3D setattr_prepare(&nop_mnt_idmap, entry, attr);
> +       if (err)
> +               return err;
> +
> +       path.mnt =3D fb->file->f_path.mnt;
> +       path.dentry =3D fb->file->f_path.dentry;
> +
> +       err =3D backing_inode_setattr(entry, &path, attr, fb->cred);
> +       if (err)
> +               return err;
> +
> +       if (fc->posix_acl)
> +               forget_all_cached_acls(inode);
> +
> +       return 0;
> +}
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index 3963631558f9..040fee549bb9 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -1158,6 +1158,7 @@ struct fuse_backing_map {
>  #define FUSE_PASSTHROUGH_OP_WRITE      FUSE_PASSTHROUGH_OP(FUSE_WRITE)
>  #define FUSE_PASSTHROUGH_OP_READDIR    FUSE_PASSTHROUGH_OP(FUSE_READDIR)
>  #define FUSE_PASSTHROUGH_OP_GETATTR    FUSE_PASSTHROUGH_OP(FUSE_GETATTR)
> +#define FUSE_PASSTHROUGH_OP_SETATTR    FUSE_PASSTHROUGH_OP(FUSE_SETATTR)
>
>  /* Device ioctls: */
>  #define FUSE_DEV_IOC_MAGIC             229
> --
> 2.52.0
>
