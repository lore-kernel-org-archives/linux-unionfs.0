Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28187299AAB
	for <linux-unionfs@vger.kernel.org>; Tue, 24 Mar 2026 23:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.125.188.122
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774393291; cv=pass; b=SGWTx7AtV8BwsUYFqWI3WDu3Ncwph5MRZtCpV0RNL1nZg2optVyLJi+2JOrwlqw7QE1XyE4QEiEYWIUHQfo9eZ4Y3BxfnEqhrRGant87/p4YLetJUE47y2L4l6jZEMosgL/r7Q1FRRbSQ8jUvnmpg/ElpFg+KlOa6JH76iGS4XM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774393291; c=relaxed/simple;
	bh=zPXShbPgosZoHe5pAE5fGOBodDfMV+ixzFvPWXVs4BA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UQmB8kxDtMbHKVxTiyrXwHi2FBTg6PO5+zIlw1dqrBmshxp1hUpNBC6mcN53u/gQU7fRGBms3bxku7K38RMvAa9cSnewPIBze5CKY8C9QwxNfDZ+iL33JXG1is51arC4ycsiwBBrQtoXc4ZX5y7RXS/9E/jLTVeNGXPqonhaJdw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=TSWdIfQ7; arc=pass smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="TSWdIfQ7"
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com [209.85.128.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 6E9F73F295
	for <linux-unionfs@vger.kernel.org>; Tue, 24 Mar 2026 23:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1774393285;
	bh=AwdoEY1F/l28w/Q5u9i/rviM7wNalH6iYcS5/c3UjfM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=TSWdIfQ7eQumc7UX3R/9fGYU9bMR5cHQt0OieppHzmqh8TqssnwDH0fm+PQHR8TQ3
	 r80OOnpKI61o+yirMycJPJsHc65W7uKtuuVlMDp8rShlWmErgkYsSe2RLCQdppOu+F
	 5jgW8uwA7nSrKk3SNEw/dDgSY7BtAWzzzbRoHvizfJXF5snOcV3Ze7Jqz8qqfXz2yW
	 K2wjUyHABvfrZyZItPnyw6qQYQQzFupaZKwf3+OWKUaYCS8YC9c9nLVr6UB8gsfsp5
	 S3jUQrN6zY9YcwO7JAQadvg3Gm0jwr2lEExgQvE+qRSdh4qytu30l8Ddh7SHFKU5SH
	 7WWl+k6ibCOGVDr9lcyqMSf3W8vL2yDx5njSsb9Q5P4nS1xGJx3LGyKGtW43gE/ycT
	 td2KzgfRdb30SLLojGzKHQVrR0TtdVXmIAZ3BM55tY0oaC+ra51QJutIX5bhsSQVzK
	 BhbP0QQHhapfuLs/7RMASkw8Pc/yf5qoddJMUoBkPeYq1KK8Ky5EhHIFZkPwac0iSp
	 M6uS8c0z+U7goG/slyRTC82M9LLvZXuw9AKH6m4NNN40howiUkKnmoMee36uU7U0uZ
	 aG75qAKAF/Fn+/DoR/O+QPB0t+IqG4GP/pCCgZjxL+GPG8UOWowd7M57JXNBt8F4f7
	 5wS2tQBpM+maoTJOODeyhZj0=
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-79878791ec6so106773917b3.3
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Mar 2026 16:01:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774393284; cv=none;
        d=google.com; s=arc-20240605;
        b=JK3nQbkGy7yte82K2RfhJTuYolh6HurIijdd8mIAweCK4skelkU6ryvK0Ir4iXwqq5
         wUVsGABUEcGbWzFZG0gmGvDKEC/PTamy5zK4uv56FXsjx60Dz5a3N8YoA4iOg14n/SsJ
         fBX/gB8fsyn6FMFPx/Usi/3uHOIwr/4tuwkv9fEYstHMBoIr9ktMm23ChfPelGw+Jmrg
         SDvEkCpg5nCefe505u5GabXdchmwStn4TqgJ7FxhraiLmDb7SCbtyq7R2pr2ctbdgLGd
         byIA8pLKQb6zqMisM8kIuWYsm23Le4Ar1/Nrk7Vt9UOOoznSq9TzVhelxFDXwut4LlGz
         nP9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=AwdoEY1F/l28w/Q5u9i/rviM7wNalH6iYcS5/c3UjfM=;
        fh=AFDTkL2IWWgG7RKZwGp0291RKbxc17yLST9l4SDocxE=;
        b=M+8ok2m+ns9QDyOEMdEaOPRWSwNUMCqYzyO8we31axLCF1Fhts/Vkc0lK82N8ynrcp
         dtt4nZdSh6yxYfYSwsioEFX+BjPqzCUTKCpoWevL2TPnG0wWzlXkEKXt8sZXcsQd42uM
         teZFT4Cxc8SUl/XRqKeLQhu1aPh9KRcBHi6HEjWnBPK+rL5ybAfo5DfNv3Rl1XpcVTbu
         bAI5qX0mB+T+qoY82XpSYnLow3eY4CG4opizTcgaO3QTHAs13x7D3OecI3VUWZ72BRrM
         eXjd0nQZloo6YBnT7U3nwBwuE/+/ZwWSh7ZVs1lwedw6LXKgSjnxH9taOIjB4KcRDC0L
         KZog==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774393284; x=1774998084;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AwdoEY1F/l28w/Q5u9i/rviM7wNalH6iYcS5/c3UjfM=;
        b=Dx7KCnIFNHHx5hytG3WLd25+9tWBGetdbkaySkuGFnBVbRaNRcwXA8d7027k2ixoql
         VGGvGOQAfUOzRFeMA7+W2cExtfGT8eTiOAT6eNq2TjwgHz8d6n5/YaMH3xGwl6SAYRT3
         EUzRXxrqqLDFOakWmmK6qTldRQnQXQvtdkMiGQQ8h7JzrEojpo4W1g9xv4+f3OICplrk
         8/CAGKvwM7jYS497lPghQGmhECFImN+VV/qr1ne4PHyeBTMaNp+hXD4wcQZmFS+I6xHE
         taNTzPGUSVXkeBPRfp56MaJWVw7d0Q1mcrOpC2mMp/OVCYYjn8N/hcRvIz2MNSI9gS9T
         Su2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXajFEW3Rnk/YlfsR8IH1WxGTGCy0jschk8FaFaLertSYWAmc8yYvM9AWVD74mJYOOxN8elzKvspaWT7Rum@vger.kernel.org
X-Gm-Message-State: AOJu0YxkewiUeqjEqg4wBsTBtyQSusrZwQOYuYJ0AkgdDU1oCIwAZIMg
	0f7MhkMKrB54UaIaDhOMYcojk6fqBG7+D/9N1AbjYDKwX//q8wwfFTXR4sbypXlW8N0hzpO5bFB
	bO2ZMqSxykfu1zFHe/45eOv4vWWpewCy9epdzCFdhRYRkcT7naztyrsBLkaMWVbVMTlfonfN3Ws
	Kv4fTwuGhLAW+ibnPeSKnIZORm5LA83Q8z/WJFgrbKZxy/K0Ejswc8vfUHWQ==
X-Gm-Gg: ATEYQzxEPw1QUZO+dslNfNPefZpOUejcp4ihrjt+hgHMLbR/+CL3qOfFQIjsYH6ZFL0
	4BAJykojdTfytWRDnoDQ1Vuvck0tfpZv6g5MwmfUnMhlLZBNh/TDggNROCAER2sTm44dFA0/odt
	IH6JpHeD4asp0phLKWAFb5ZgqeqMFczON30V2CHemZ3HHamgJWqgZzKDCc5AHwSiWWXJdNzcUIO
	NM9Jp57iXD/PGpsTsAPIThI9JniCk8Cl7DgEtzCq3JkGlu5aDIcrskcAjvEAosUNw==
X-Received: by 2002:a05:690c:22c3:b0:79a:1b3a:e91f with SMTP id 00721157ae682-79acf66f88bmr16057727b3.52.1774393283977;
        Tue, 24 Mar 2026 16:01:23 -0700 (PDT)
X-Received: by 2002:a05:690c:22c3:b0:79a:1b3a:e91f with SMTP id
 00721157ae682-79acf66f88bmr16056907b3.52.1774393283202; Tue, 24 Mar 2026
 16:01:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260323042510.3331778-4-paul@paul-moore.com> <20260323042510.3331778-5-paul@paul-moore.com>
In-Reply-To: <20260323042510.3331778-5-paul@paul-moore.com>
From: Ryan Lee <ryan.lee@canonical.com>
Date: Tue, 24 Mar 2026 16:01:11 -0700
X-Gm-Features: AaiRm53IvpHFr_cpg8NQ6QasTA8epM0si3tWGsWSd60gLeKLuXcXbMDYslFLFYY
Message-ID: <CAKCV-6t=m-8eu1xoTORnLwhG4kQB5u1v5diJDQDFcat=tH8WgA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/2] lsm: add backing_file LSM hooks
To: Paul Moore <paul@paul-moore.com>
Cc: linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>, 
	Gao Xiang <xiang@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Paul,

I'm currently looking at the patch more closely to implement the hooks
for AppArmor, but
here are some typofixes and the like below:

On Sun, Mar 22, 2026 at 9:26=E2=80=AFPM Paul Moore <paul@paul-moore.com> wr=
ote:
>
> Stacked filesystems such as overlayfs do not currently provide the
> necessary mechanisms for LSMs to properly enforce access controls on the
> mmap() and mprotect() operations.  In order to resolve this gap, a LSM
> security blob is being added to the backing_file struct and the following
> new LSM hooks are being created:
>
>  security_backing_file_alloc()
>  security_backing_file_free()
>  security_mmap_backing_file()
>
> The first two hooks are to manage the lifecycle of the LSM security blob
> in the backing_file struct, while the third provides a new mmap() access
> control point for the underlying backing file.  It is also expected that
> LSMs will likely want to update their security_file_mprotect() callback
> to address issues with their mprotect() controls, but that does not
> require a change to the security_file_mprotect() LSM hook.
>
> There are a two other small changes to support these new LSM hooks.  We
> pass the user file associated with a backing file down to
> alloc_empty_backing_file() so it can be included in the
> security_backing_file_alloc() hook, and we constify the file struct field
> in the LSM common_audit_data struct to better support LSMs that need to
> pass a const file struct pointer into the common LSM audit code.
>
> Thanks to Arnd Bergmann for identifying the missing EXPORT_SYMBOL_GPL()
> and supplying a fixup.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> ---
>  fs/backing-file.c             |  18 ++++--
>  fs/erofs/ishare.c             |  10 +++-
>  fs/file_table.c               |  21 ++++++-
>  fs/fuse/passthrough.c         |   2 +-
>  fs/internal.h                 |   3 +-
>  fs/overlayfs/dir.c            |   2 +-
>  fs/overlayfs/file.c           |   2 +-
>  include/linux/backing-file.h  |   4 +-
>  include/linux/fs.h            |   1 +
>  include/linux/lsm_audit.h     |   2 +-
>  include/linux/lsm_hook_defs.h |   5 ++
>  include/linux/lsm_hooks.h     |   1 +
>  include/linux/security.h      |  22 ++++++++
>  security/lsm.h                |   1 +
>  security/lsm_init.c           |   9 +++
>  security/security.c           | 100 ++++++++++++++++++++++++++++++++++
>  16 files changed, 187 insertions(+), 16 deletions(-)
>
> diff --git a/fs/backing-file.c b/fs/backing-file.c
> index 45da8600d564..1f3bbfc75882 100644
> --- a/fs/backing-file.c
> +++ b/fs/backing-file.c
> @@ -12,6 +12,7 @@
>  #include <linux/backing-file.h>
>  #include <linux/splice.h>
>  #include <linux/mm.h>
> +#include <linux/security.h>
>
>  #include "internal.h"
>
> @@ -29,14 +30,15 @@
>   * returned file into a container structure that also stores the stacked
>   * file's path, which can be retrieved using backing_file_user_path().
>   */
> -struct file *backing_file_open(const struct path *user_path, int flags,
> +struct file *backing_file_open(const struct file *user_file, int flags,
>                                const struct path *real_path,
>                                const struct cred *cred)
>  {
> +       const struct path *user_path =3D &user_file->f_path;
>         struct file *f;
>         int error;
>
> -       f =3D alloc_empty_backing_file(flags, cred);
> +       f =3D alloc_empty_backing_file(flags, cred, user_file);
>         if (IS_ERR(f))
>                 return f;
>
> @@ -52,15 +54,16 @@ struct file *backing_file_open(const struct path *use=
r_path, int flags,
>  }
>  EXPORT_SYMBOL_GPL(backing_file_open);
>
> -struct file *backing_tmpfile_open(const struct path *user_path, int flag=
s,
> +struct file *backing_tmpfile_open(const struct file *user_file, int flag=
s,
>                                   const struct path *real_parentpath,
>                                   umode_t mode, const struct cred *cred)
>  {
>         struct mnt_idmap *real_idmap =3D mnt_idmap(real_parentpath->mnt);
> +       const struct path *user_path =3D &user_file->f_path;
>         struct file *f;
>         int error;
>
> -       f =3D alloc_empty_backing_file(flags, cred);
> +       f =3D alloc_empty_backing_file(flags, cred, user_file);
>         if (IS_ERR(f))
>                 return f;
>
> @@ -336,8 +339,13 @@ int backing_file_mmap(struct file *file, struct vm_a=
rea_struct *vma,
>
>         vma_set_file(vma, file);
>
> -       scoped_with_creds(ctx->cred)
> +       scoped_with_creds(ctx->cred) {
> +               ret =3D security_mmap_backing_file(vma, file, user_file);
> +               if (ret)
> +                       return ret;
> +
>                 ret =3D vfs_mmap(vma->vm_file, vma);
> +       }
>
>         if (ctx->accessed)
>                 ctx->accessed(user_file);
> diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
> index 829d50d5c717..ec3fc5ac1a55 100644
> --- a/fs/erofs/ishare.c
> +++ b/fs/erofs/ishare.c
> @@ -4,6 +4,7 @@
>   */
>  #include <linux/xxhash.h>
>  #include <linux/mount.h>
> +#include <linux/security.h>
>  #include "internal.h"
>  #include "xattr.h"
>
> @@ -106,7 +107,8 @@ static int erofs_ishare_file_open(struct inode *inode=
, struct file *file)
>
>         if (file->f_flags & O_DIRECT)
>                 return -EINVAL;
> -       realfile =3D alloc_empty_backing_file(O_RDONLY|O_NOATIME, current=
_cred());
> +       realfile =3D alloc_empty_backing_file(O_RDONLY|O_NOATIME, current=
_cred(),
> +                                           file);
>         if (IS_ERR(realfile))
>                 return PTR_ERR(realfile);
>         ihold(sharedinode);
> @@ -150,8 +152,14 @@ static ssize_t erofs_ishare_file_read_iter(struct ki=
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
>
> diff --git a/fs/file_table.c b/fs/file_table.c
> index aaa5faaace1e..0bdc26cae138 100644
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -50,6 +50,7 @@ struct backing_file {
>                 struct path user_path;
>                 freeptr_t bf_freeptr;
>         };
> +       void *security;
>  };
>
>  #define backing_file(f) container_of(f, struct backing_file, file)
> @@ -66,6 +67,11 @@ void backing_file_set_user_path(struct file *f, const =
struct path *path)
>  }
>  EXPORT_SYMBOL_GPL(backing_file_set_user_path);
>
> +void *backing_file_security(const struct file *f)
> +{
> +       return backing_file(f)->security;
> +}
> +
>  static inline void file_free(struct file *f)
>  {
>         security_file_free(f);
> @@ -73,8 +79,11 @@ static inline void file_free(struct file *f)
>                 percpu_counter_dec(&nr_files);
>         put_cred(f->f_cred);
>         if (unlikely(f->f_mode & FMODE_BACKING)) {
> -               path_put(backing_file_user_path(f));
> -               kmem_cache_free(bfilp_cachep, backing_file(f));
> +               struct backing_file *ff =3D backing_file(f);
> +
> +               security_backing_file_free(&ff->security);
> +               path_put(&ff->user_path);
> +               kmem_cache_free(bfilp_cachep, ff);
>         } else {
>                 kmem_cache_free(filp_cachep, f);
>         }
> @@ -290,7 +299,8 @@ struct file *alloc_empty_file_noaccount(int flags, co=
nst struct cred *cred)
>   * This is only for kernel internal use, and the allocate file must not =
be
>   * installed into file tables or such.
>   */
> -struct file *alloc_empty_backing_file(int flags, const struct cred *cred=
)
> +struct file *alloc_empty_backing_file(int flags, const struct cred *cred=
,
> +                                     const struct file *user_file)
>  {
>         struct backing_file *ff;
>         int error;
> @@ -306,6 +316,11 @@ struct file *alloc_empty_backing_file(int flags, con=
st struct cred *cred)
>         }
>
>         ff->file.f_mode |=3D FMODE_BACKING | FMODE_NOACCOUNT;
> +       error =3D security_backing_file_alloc(&ff->security, user_file);
> +       if (unlikely(error)) {
> +               fput(&ff->file);
> +               return ERR_PTR(error);
> +       }
>         return &ff->file;
>  }
>  EXPORT_SYMBOL_GPL(alloc_empty_backing_file);
> diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
> index 72de97c03d0e..f2d08ac2459b 100644
> --- a/fs/fuse/passthrough.c
> +++ b/fs/fuse/passthrough.c
> @@ -167,7 +167,7 @@ struct fuse_backing *fuse_passthrough_open(struct fil=
e *file, int backing_id)
>                 goto out;
>
>         /* Allocate backing file per fuse file to store fuse path */
> -       backing_file =3D backing_file_open(&file->f_path, file->f_flags,
> +       backing_file =3D backing_file_open(file, file->f_flags,
>                                          &fb->file->f_path, fb->cred);
>         err =3D PTR_ERR(backing_file);
>         if (IS_ERR(backing_file)) {
> diff --git a/fs/internal.h b/fs/internal.h
> index cbc384a1aa09..77e90e4124e0 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -106,7 +106,8 @@ extern void chroot_fs_refs(const struct path *, const=
 struct path *);
>   */
>  struct file *alloc_empty_file(int flags, const struct cred *cred);
>  struct file *alloc_empty_file_noaccount(int flags, const struct cred *cr=
ed);
> -struct file *alloc_empty_backing_file(int flags, const struct cred *cred=
);
> +struct file *alloc_empty_backing_file(int flags, const struct cred *cred=
,
> +                                     const struct file *user_file);
>  void backing_file_set_user_path(struct file *f, const struct path *path)=
;
>
>  static inline void file_put_write_access(struct file *file)
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index ff3dbd1ca61f..f2f20a611af3 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -1374,7 +1374,7 @@ static int ovl_create_tmpfile(struct file *file, st=
ruct dentry *dentry,
>                                 return PTR_ERR(cred);
>
>                         ovl_path_upper(dentry->d_parent, &realparentpath)=
;
> -                       realfile =3D backing_tmpfile_open(&file->f_path, =
flags, &realparentpath,
> +                       realfile =3D backing_tmpfile_open(file, flags, &r=
ealparentpath,
>                                                         mode, current_cre=
d());
>                         err =3D PTR_ERR_OR_ZERO(realfile);
>                         pr_debug("tmpfile/open(%pd2, 0%o) =3D %i\n", real=
parentpath.dentry, mode, err);
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 97bed2286030..27cc07738f33 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -48,7 +48,7 @@ static struct file *ovl_open_realfile(const struct file=
 *file,
>                         if (!inode_owner_or_capable(real_idmap, realinode=
))
>                                 flags &=3D ~O_NOATIME;
>
> -                       realfile =3D backing_file_open(file_user_path(fil=
e),
> +                       realfile =3D backing_file_open(file,
>                                                      flags, realpath, cur=
rent_cred());
>                 }
>         }
> diff --git a/include/linux/backing-file.h b/include/linux/backing-file.h
> index 1476a6ed1bfd..c939cd222730 100644
> --- a/include/linux/backing-file.h
> +++ b/include/linux/backing-file.h
> @@ -18,10 +18,10 @@ struct backing_file_ctx {
>         void (*end_write)(struct kiocb *iocb, ssize_t);
>  };
>
> -struct file *backing_file_open(const struct path *user_path, int flags,
> +struct file *backing_file_open(const struct file *user_file, int flags,
>                                const struct path *real_path,
>                                const struct cred *cred);
> -struct file *backing_tmpfile_open(const struct path *user_path, int flag=
s,
> +struct file *backing_tmpfile_open(const struct file *user_file, int flag=
s,
>                                   const struct path *real_parentpath,
>                                   umode_t mode, const struct cred *cred);
>  ssize_t backing_file_read_iter(struct file *file, struct iov_iter *iter,
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8b3dd145b25e..8f5702cfb5e0 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2474,6 +2474,7 @@ struct file *dentry_open_nonotify(const struct path=
 *path, int flags,
>  struct file *dentry_create(struct path *path, int flags, umode_t mode,
>                            const struct cred *cred);
>  const struct path *backing_file_user_path(const struct file *f);
> +void *backing_file_security(const struct file *f);
>
>  /*
>   * When mmapping a file on a stackable filesystem (e.g., overlayfs), the=
 file
> diff --git a/include/linux/lsm_audit.h b/include/linux/lsm_audit.h
> index 382c56a97bba..584db296e43b 100644
> --- a/include/linux/lsm_audit.h
> +++ b/include/linux/lsm_audit.h
> @@ -94,7 +94,7 @@ struct common_audit_data {
>  #endif
>                 char *kmod_name;
>                 struct lsm_ioctlop_audit *op;
> -               struct file *file;
> +               const struct file *file;
>                 struct lsm_ibpkey_audit *ibpkey;
>                 struct lsm_ibendport_audit *ibendport;
>                 int reason;
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.=
h
> index 8c42b4bde09c..2c4da40757ad 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -191,6 +191,9 @@ LSM_HOOK(int, 0, file_permission, struct file *file, =
int mask)
>  LSM_HOOK(int, 0, file_alloc_security, struct file *file)
>  LSM_HOOK(void, LSM_RET_VOID, file_release, struct file *file)
>  LSM_HOOK(void, LSM_RET_VOID, file_free_security, struct file *file)
> +LSM_HOOK(int, 0, backing_file_alloc, void *backing_file_blobp,
> +        const struct file *user_file)
> +LSM_HOOK(void, LSM_RET_VOID, backing_file_free, void *backing_file_blobp=
)
>  LSM_HOOK(int, 0, file_ioctl, struct file *file, unsigned int cmd,
>          unsigned long arg)
>  LSM_HOOK(int, 0, file_ioctl_compat, struct file *file, unsigned int cmd,
> @@ -198,6 +201,8 @@ LSM_HOOK(int, 0, file_ioctl_compat, struct file *file=
, unsigned int cmd,
>  LSM_HOOK(int, 0, mmap_addr, unsigned long addr)
>  LSM_HOOK(int, 0, mmap_file, struct file *file, unsigned long reqprot,
>          unsigned long prot, unsigned long flags)
> +LSM_HOOK(int, 0, mmap_backing_file, struct vm_area_struct *vma,
> +        struct file *backing_file, struct file *user_file)
>  LSM_HOOK(int, 0, file_mprotect, struct vm_area_struct *vma,
>          unsigned long reqprot, unsigned long prot)
>  LSM_HOOK(int, 0, file_lock, struct file *file, unsigned int cmd)
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index d48bf0ad26f4..b4f8cad53ddb 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -104,6 +104,7 @@ struct security_hook_list {
>  struct lsm_blob_sizes {
>         unsigned int lbs_cred;
>         unsigned int lbs_file;
> +       unsigned int lbs_backing_file;
>         unsigned int lbs_ib;
>         unsigned int lbs_inode;
>         unsigned int lbs_sock;
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 83a646d72f6f..1e4c68d5877f 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -471,11 +471,17 @@ int security_file_permission(struct file *file, int=
 mask);
>  int security_file_alloc(struct file *file);
>  void security_file_release(struct file *file);
>  void security_file_free(struct file *file);
> +int security_backing_file_alloc(void **backing_file_blobp,
> +                               const struct file *user_file);
> +void security_backing_file_free(void **backing_file_blobp);
>  int security_file_ioctl(struct file *file, unsigned int cmd, unsigned lo=
ng arg);
>  int security_file_ioctl_compat(struct file *file, unsigned int cmd,
>                                unsigned long arg);
>  int security_mmap_file(struct file *file, unsigned long prot,
>                         unsigned long flags);
> +int security_mmap_backing_file(struct vm_area_struct *vma,
> +                              struct file *backing_file,
> +                              struct file *user_file);
>  int security_mmap_addr(unsigned long addr);
>  int security_file_mprotect(struct vm_area_struct *vma, unsigned long req=
prot,
>                            unsigned long prot);
> @@ -1140,6 +1146,15 @@ static inline void security_file_release(struct fi=
le *file)
>  static inline void security_file_free(struct file *file)
>  { }
>
> +int security_backing_file_alloc(void **backing_file_blobp,
> +                               const struct file *user_file)
> +{
> +       return 0;
> +}
> +
> +void security_backing_file_free(void **backing_file_blobp)
> +{ }
> +

Should these two placeholders be static inline functions, like the
other ones around them?

>  static inline int security_file_ioctl(struct file *file, unsigned int cm=
d,
>                                       unsigned long arg)
>  {
> @@ -1159,6 +1174,13 @@ static inline int security_mmap_file(struct file *=
file, unsigned long prot,
>         return 0;
>  }
>
> +static inline int security_mmap_backing_file(struct vm_area_struct *vma,
> +                                            struct file *backing_file,
> +                                            struct file *user_file)
> +{
> +       return 0;
> +}
> +
>  static inline int security_mmap_addr(unsigned long addr)
>  {
>         return cap_mmap_addr(addr);
> diff --git a/security/lsm.h b/security/lsm.h
> index db77cc83e158..32f808ad4335 100644
> --- a/security/lsm.h
> +++ b/security/lsm.h
> @@ -29,6 +29,7 @@ extern struct lsm_blob_sizes blob_sizes;
>
>  /* LSM blob caches */
>  extern struct kmem_cache *lsm_file_cache;
> +extern struct kmem_cache *lsm_backing_file_cache;
>  extern struct kmem_cache *lsm_inode_cache;
>
>  /* LSM blob allocators */
> diff --git a/security/lsm_init.c b/security/lsm_init.c
> index 573e2a7250c4..020eace65973 100644
> --- a/security/lsm_init.c
> +++ b/security/lsm_init.c
> @@ -293,6 +293,8 @@ static void __init lsm_prepare(struct lsm_info *lsm)
>         blobs =3D lsm->blobs;
>         lsm_blob_size_update(&blobs->lbs_cred, &blob_sizes.lbs_cred);
>         lsm_blob_size_update(&blobs->lbs_file, &blob_sizes.lbs_file);
> +       lsm_blob_size_update(&blobs->lbs_backing_file,
> +                            &blob_sizes.lbs_backing_file);
>         lsm_blob_size_update(&blobs->lbs_ib, &blob_sizes.lbs_ib);
>         /* inode blob gets an rcu_head in addition to LSM blobs. */
>         if (blobs->lbs_inode && blob_sizes.lbs_inode =3D=3D 0)
> @@ -441,6 +443,8 @@ int __init security_init(void)
>         if (lsm_debug) {
>                 lsm_pr("blob(cred) size %d\n", blob_sizes.lbs_cred);
>                 lsm_pr("blob(file) size %d\n", blob_sizes.lbs_file);
> +               lsm_pr("blob(backing_file) size %d\n",
> +                      blob_sizes.lbs_backing_file);
>                 lsm_pr("blob(ib) size %d\n", blob_sizes.lbs_ib);
>                 lsm_pr("blob(inode) size %d\n", blob_sizes.lbs_inode);
>                 lsm_pr("blob(ipc) size %d\n", blob_sizes.lbs_ipc);
> @@ -462,6 +466,11 @@ int __init security_init(void)
>                 lsm_file_cache =3D kmem_cache_create("lsm_file_cache",
>                                                    blob_sizes.lbs_file, 0=
,
>                                                    SLAB_PANIC, NULL);
> +       if (blob_sizes.lbs_backing_file)
> +               lsm_backing_file_cache =3D kmem_cache_create(
> +                                                  "lsm_backing_file_cach=
e",
> +                                                  blob_sizes.lbs_file, 0=
,
> +                                                  SLAB_PANIC, NULL);

Shouldn't blob_sizes.lbs_file here be blob_sizes.lbs_backing_file instead?

>         if (blob_sizes.lbs_inode)
>                 lsm_inode_cache =3D kmem_cache_create("lsm_inode_cache",
>                                                     blob_sizes.lbs_inode,=
 0,
> diff --git a/security/security.c b/security/security.c
> index 67af9228c4e9..651a0d643c9f 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -81,6 +81,7 @@ const struct lsm_id *lsm_idlist[MAX_LSM_COUNT];
>  struct lsm_blob_sizes blob_sizes;
>
>  struct kmem_cache *lsm_file_cache;
> +struct kmem_cache *lsm_backing_file_cache;
>  struct kmem_cache *lsm_inode_cache;
>
>  #define SECURITY_HOOK_ACTIVE_KEY(HOOK, IDX) security_hook_active_##HOOK#=
#_##IDX
> @@ -172,6 +173,28 @@ static int lsm_file_alloc(struct file *file)
>         return 0;
>  }
>
> +/**
> + * lsm_backing_file_alloc - allocate a composite backing file blob
> + * @backing_file_blobp: pointer to the backing file LSM blob pointer
> + *
> + * Allocate the backing file blob for all the modules.
> + *
> + * Returns 0, or -ENOMEM if memory can't be allocated.
> + */
> +static int lsm_backing_file_alloc(void **backing_file_blobp)
> +{
> +       if (!lsm_backing_file_cache) {
> +               *backing_file_blobp =3D NULL;
> +               return 0;
> +       }
> +
> +       *backing_file_blobp =3D kmem_cache_zalloc(lsm_backing_file_cache,
> +                                               GFP_KERNEL);
> +       if (*backing_file_blobp =3D=3D NULL)
> +               return -ENOMEM;
> +       return 0;
> +}
> +
>  /**
>   * lsm_blob_alloc - allocate a composite blob
>   * @dest: the destination for the blob
> @@ -2417,6 +2440,57 @@ void security_file_free(struct file *file)
>         }
>  }
>
> +/**
> + * security_backing_file_alloc() - Allocate and setup a backing file blo=
b
> + * @backing_file_blobp: pointer to the backing file LSM blob pointer
> + * @user_file: the associated user visible file
> + *
> + * Allocate a backing file LSM blob and perform any necessary initializa=
tion of
> + * the LSM blob.  There will be some operations where the LSM will not h=
ave
> + * access to @user_file after this point, so any important state associa=
ted
> + * with @user_file that is important to the LSM should be captured in th=
e
> + * backing file's LSM blob.
> + *
> + * LSM's should avoid taking a reference to @user_file in this hook as i=
t will
> + * result in problems later when the system attempts to drop/put the fil=
e
> + * references due to a circular dependency.
> + *
> + * Return: Return 0 if the hook is successful, negative values otherwise=
.
> + */
> +int security_backing_file_alloc(void **backing_file_blobp,
> +                               const struct file *user_file)
> +{
> +       int rc;
> +
> +       rc =3D lsm_backing_file_alloc(backing_file_blobp);
> +       if (rc)
> +               return rc;
> +       rc =3D call_int_hook(backing_file_alloc, *backing_file_blobp, use=
r_file);
> +       if (unlikely(rc))
> +               security_backing_file_free(backing_file_blobp);
> +
> +       return rc;
> +}
> +
> +/**
> + * security_backing_file_free() - Free a backing file blob
> + * @backing_file_blobp: pointer to the backing file LSM blob pointer
> + *
> + * Free any LSM state associate with a backing file's LSM blob, includin=
g the
> + * blob itself.
> + */
> +void security_backing_file_free(void **backing_file_blobp)
> +{
> +       void *backing_file_blob =3D *backing_file_blobp;
> +
> +       call_void_hook(backing_file_free, backing_file_blob);
> +
> +       if (backing_file_blob) {
> +               *backing_file_blobp =3D NULL;
> +               kmem_cache_free(lsm_backing_file_cache, backing_file_blob=
);
> +       }
> +}
> +
>  /**
>   * security_file_ioctl() - Check if an ioctl is allowed
>   * @file: associated file
> @@ -2505,6 +2579,32 @@ int security_mmap_file(struct file *file, unsigned=
 long prot,
>                              flags);
>  }
>
> +/**
> + * security_mmap_backing_file - Check if mmap'ing a backing file is allo=
wed
> + * @vma: the vm_area_struct for the mmap'd region
> + * @backing_file: the backing file being mmap'd
> + * @user_file: the user file being mmap'd
> + *
> + * Check permissions for a mmap operation on a stacked filesystem.  This=
 hook
> + * is called after the security_mmap_file() and is responsible for autho=
rizing
> + * the mmap on @backing_file.  It is important to note that the mmap ope=
ration
> + * on @user_file has already been authorized and the @vma->vm_file has b=
een
> + * set to @backing_file.
> + *
> + * Return: Returns 0 if permission is granted.
> + */
> +int security_mmap_backing_file(struct vm_area_struct *vma,
> +                              struct file *backing_file,
> +                              struct file *user_file)
> +{
> +       /* recommended by the stackable filesystem devs */
> +       if (WARN_ON_ONCE(!(backing_file->f_mode & FMODE_BACKING)))
> +               return -EIO;
> +
> +       return call_int_hook(mmap_backing_file, vma, backing_file, user_f=
ile);
> +}
> +EXPORT_SYMBOL_GPL(security_mmap_backing_file);
> +
>  /**
>   * security_mmap_addr() - Check if mmap'ing an address is allowed
>   * @addr: address
> --
> 2.53.0
>
>
