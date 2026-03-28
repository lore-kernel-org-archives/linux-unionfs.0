Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5887537756B
	for <linux-unionfs@vger.kernel.org>; Sat, 28 Mar 2026 08:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774686562; cv=pass; b=kyEuf7vRqkdsqhyljSY8EGP5enDnIwUecGyv5BuC0pCKxCTtT/Yd41IqQ1RDulawk6QtussO1rqfF/YR9P1K4cOJHQTwju31IPORHpPSPhVoSnDRmL0P0xwQ4GZJlyxPFR2tzH2NSXBEPO00ivyutGqM87B838mhUj5A/NFjotw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774686562; c=relaxed/simple;
	bh=SmbKe2I7cXpD8jC45EfnzoMMfNCRlApjjuVHgPGCxKY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UdxGxwb5bGqVDXFPgc5mLsJt0ejRShjpJ705Ea/1Egeerql/E/L6s78NhboFkSSTwMXOlUWFbBzFFwmCfzKn5id6E4ymsYx3F8ke1VDD4e74wFM02s9sRJk+y9F6RbnhuCfJV1p4W1iSs4+62JEUJF/JTYs9DwpA5zSzy0kreZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f+vtzra+; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f+vtzra+"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-66b32fd9f26so1789518a12.0
        for <linux-unionfs@vger.kernel.org>; Sat, 28 Mar 2026 01:29:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774686555; cv=none;
        d=google.com; s=arc-20240605;
        b=DTSnfJdqZ/PTltN/SC3ztblsvlgK4LzRqAzGaW4/twWOFWzcYOn8E7uTCYtF4OxzAJ
         2wXzE098OTaXwRzArzVAM0kKNJuzGdoolUjVqn42wo8D4FCAlfg6voLx8d3wgbQg96n8
         L+QcfAt47S2B2I5/iVB/kIjF4hJ8Cztisv5wRtquU6xKM0Og1OKwkt3Q8cZOTHfUuhx/
         Ee8TWUo6yjEjsfcglUNwRvxhzVjKRCM/uWOxcsrauGAG8P/6QHCuZY61wQazuFWVZc1f
         kD26ZW/rqGltSNDTwyBJTZ0Ftve+MLHVQCOxUVpw8zAGnXsqI3CnW5fBa6QbW4kCA0tm
         ssMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LGi2J//y1hCXUvY1HptrsZDMHcxRStO1eH7BsZpdzbg=;
        fh=1cnjlk5YhYTPXJCA2yticYF50G8mRbXwDzXps9bLp+A=;
        b=QZhh0c2YndULKmJ2icygieMp0VC8cGC0dVD3bVDfYkb7nQ+5YxyNeAidhbJ7ipUv17
         N+pPTlQcI9FK4mZ+YERmekb9LkN7dP5jHMYKq/IES6ITCrnD2IryjFzH9KbdpTRg12Xa
         t/G6aAtpWbfl7gF17u6jos1998UDSE2RoadFTLqv6g+9g07tWzdK6PzDIhDcd5yeOmcY
         5HVq/nYsTkgISCxvBeMceHL8OA3g6IIGkZPUATZm5JACAmHhobrFQDj2q5Lhc7y0HIbq
         Eczbi6lsu57vXoyheHpELgV9CrmsgYrqGIwLpIzZoBEZa7YjrN9eNj0vmdcwRf75GeJZ
         5Mrw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774686555; x=1775291355; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LGi2J//y1hCXUvY1HptrsZDMHcxRStO1eH7BsZpdzbg=;
        b=f+vtzra+Na4IzmV4h5cTVKtHTbLOSM85f70vmGSnbyK2p6B9By4qx4UxBRYaUiyolO
         sRZ81awyFWad3mfVlU9nRmlb/Q+VgXnntOd0ff4oNjDkGnIFm1RbPICOi8J5xdfFysYF
         qCL/0LYKzEiqg581gwoXQP/s/5aE7DqtNpdlGIIV3AWJef+3DQjSbAROdGgIxqBL3S6Z
         e3pV/mN8bM751YzFo8v23Ys4UEgLtGSYHhycdmXKunT60Rh4rT82Xd1VG8x4L92jrzlM
         6rFoq0nfZseGcYysIwYA8lpCSh0y2JprwxOb51or/vrrdoDrnGI68GPgJXaHqfV6Yvmp
         1YAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774686555; x=1775291355;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LGi2J//y1hCXUvY1HptrsZDMHcxRStO1eH7BsZpdzbg=;
        b=mtjZSeHJCAz7yJnFfqD5Hh9j5OA+R3fC7RiM65gbfJiW5Wat0c8l7g+4Oy/LUibDOD
         scKBR0bGWkBXvCAP2seoJyph24rK58J8DiJPKjWyu1lHOankkqn+Fld/TPGFOWtYX2gV
         +OUziO9k9cBePFboTbKRfHh1gIy1UQpsrXcQ2SlQEwZXyCiCjuXVfVRBY6sb/9H+o4Wv
         yGUThDYune5M8kZKIGXwQIxTHgp2uJtRhuypdLVCMNb9OCG1sBYXHButTtZL/3KSiXjJ
         +4SAfyNoLqZR3Z9Y3ZV6uomhzwpVViUmGcze/A3I4wzj6VRR5IhQzRlVZgtigxGg+Cxx
         pkkQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/OedrhLUdaN2bsDhqKUfYv8BtHq3x5Y6mZ78yx52V/X0W4yKreOST5tI64pVtZaS1ecTnkhOEKbMD6HGX@vger.kernel.org
X-Gm-Message-State: AOJu0YzT96n7DziLFOqxg1s505qoBIDCGMFCim2DoYIR8LVzkmbGIU3F
	MUcQ1IHeIVUNWtjAZ6vZUzkFomeLEEBmcg9sNL1h5pJJKSfBcC9bZhmMgli6IlL/0xIlaCbQNlG
	7RNjqenUM5LP6jKD+4XrnEKT60UZuY5I=
X-Gm-Gg: ATEYQzzlTVJMWVRp30STXCx049CR7sQp1wydc8lun+4kL4gKJn/Y1Juna3RuGkQbVZ+
	ZlqLZgpfqMdVdFPrWKJLgTMInwqsFYrj0YSBtcKwhbFNTcfAS/F6p/0WMOqV1cLeWZrfHA6UDXC
	AXFclIFvg4CTWPYmI7b9Wbk0CZVWJG5qXsM8Wb26XBPQ2qBPhdQkEj+j82na+giKhZ7LD12aEHU
	9STaz5FuZG/+jz3ZIOpG1WempFe6JlE6oeTEnEGTofgDGMTgnQWV2VldWHOIDNz84/foX+eDnBF
	24jfn6LUjbhebasQ3YCT3TJN0iRyxV8MwZHp2oJAQQ236UP3B+CB
X-Received: by 2002:a05:6402:370b:b0:669:b5be:1202 with SMTP id
 4fb4d7f45d1cf-66b2a652236mr2888591a12.5.1774686554915; Sat, 28 Mar 2026
 01:29:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260327220446.353103-4-paul@paul-moore.com> <20260327220446.353103-5-paul@paul-moore.com>
In-Reply-To: <20260327220446.353103-5-paul@paul-moore.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 28 Mar 2026 09:29:03 +0100
X-Gm-Features: AQROBzAoJBb9PaDQrv_VGBI3UwjLF6z0_gtOD5OkJ5W93T7oeHAkRvcB2FVGKn4
Message-ID: <CAOQ4uxjvCYRLcRM-JGgtCPXKRB1agCBacN1tmR7hDR9TLdVS4w@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] lsm: add backing_file LSM hooks
To: Paul Moore <paul@paul-moore.com>
Cc: linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Gao Xiang <xiang@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 27, 2026 at 11:05=E2=80=AFPM Paul Moore <paul@paul-moore.com> w=
rote:
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
> Acked-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> ---

I 100% agree with Christian.
This is much better than my O_PATH file hack
It is also what Miklos had initially suggested.

I have a minor suggestion for API change though

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

Shouldn't we wrap this with
#ifdef CONFIG_SECURITY

> +       void *security;

please initialize it in init_file()

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

I think LSM code should be completely responsible for this ptr
assignment/free so you should export

void **backing_file_security_ptr(const struct file *f)
{
       return &backing_file(f)->security;
}

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

Why do you need to add this in vfs code?

Can't you do the same in security_file_free(f)?
        if (unlikely(f->f_mode & FMODE_BACKING))
                security_backing_file_free(backing_file_security_ptr(f));


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
> +       error =3D security_backing_file_alloc(&ff->security, user_file);>=
 +       if (unlikely(error)) {
> +               fput(&ff->file);
> +               return ERR_PTR(error);
> +       }
>         return &ff->file;
>  }
>  EXPORT_SYMBOL_GPL(alloc_empty_backing_file);

Maybe, and I am not sure,
alloc_empty_backing_file() should call ONLY
            error =3D security_backing_file_alloc(&ff->file, user_file);

Instead of security_file_alloc() AND security_backing_file_alloc()
and security_backing_file_alloc() can make use of
backing_file_security_ptr() accessor internally?

I think this will further abstract LSM implementation details from vfs
and avoid the need to spray #ifdef SECURITY in vfs code.

WDYT?

Thanks for following through with this elegant and clean API!
Amir.
