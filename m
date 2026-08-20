Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92173911BD
	for <linux-unionfs@vger.kernel.org>; Thu, 20 Aug 2026 19:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787253181; cv=pass; b=CkXbtYeJ1cIw1X9x6//sI1sM8GifF9K2R4MnsO13ndunttNRj1WcUxkqI+9PBwldnRf8QSGYpT4z71qTWCZzinjLXbaZTpuOKY3aRmmEMFbCPn578qX3S8fx6+xD5VjviVaB/a2orFMH7BF6mpL2hr9ktooBXOv9BbWrLIx9KPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787253181; c=relaxed/simple;
	bh=EBJqidiCcHqzIqgjqJGYqBp8ou/sDr6lv1shRSRmZ0k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n2S3kXlKnLyuUjhs9mRZteDq6XvzUwCfnggS2PUXJSWOpETCCw+qYfzmj5ld6q5PQAq8FC8t58Vh5qVB6VXfEuC4o+Knybe7nN8SZA8RW/r8OQoihCuDppJKZyPQhmn5TIVu+cIseL6CU+PHdEZv7V3WUJfvzFKWqlugVzZgPtI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HjtxiRk/; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HjtxiRk/"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-698ae09e356so499956a12.2
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Aug 2026 12:12:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787253178; cv=none;
        d=google.com; s=arc-20260327;
        b=Y691GcxxEu9EgEv7+BlgB7vrANf9EJP5UiWrYpRlqKuRBc0YHkzXl/0DOOf24wnMX5
         DOua4lMRk4ykfvn6IC1Bdmlu+pG1m9v59/T6qeD5WVV5ku99oHIjyA38My21pRyNOdeJ
         mMKIbRiezmuHhnGC+BTfGIXomFseUu4rwTZRL5mxCiPuAhKmopPuO8A6pcL05L43nUsY
         O9yjt9W+7Tc03OHkD2/30F67QjvIgq45JB2jB+/wZlMW15zBIrnXVxxVxGEZhhvCVNju
         t76GsRqvPzZ7eoL3aEsKiUn2BFcv9cDHYy/xaeIkaJtnHWGpNeQzXnfG0OcFf6DMKiFt
         v5cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=u+vZFL9QCUrHQWNeywdrmX/CGS7XIPcGZmcJEdaeksA=;
        fh=PU7eTn/EfPpaYG8OjQxdcZISp/NxAXSWU26/rE7xa4c=;
        b=hhUfFGqgRGv1os2FTcJ6KOvBrv4JErogGz7Ux7xXVfiX0nSCV0aJBl73yrT2lhrxCD
         ZinVMcR5NuTCuvLz2uwr5jWRpTM5neCtKTO2SdZeI3KcV5P8q9+hKX0vI9ALwCvu4BSO
         3LYORdRA4TIQDOiExEUNIGdPapoRUv7YaNAFSbTPvcUMdpprJXYm+SEuwR3mUYlopWIQ
         i3ghaemcORMUMrAPe01SIosBsAzQ7X6qFbMCGScgurOgrq1eC/AZ+aQoGXadJLVwOJal
         Uv9jQRsnSmeXnQUd4J/wLXnVlDGxe12h35Z5H6ZCf1C5X45PF5ReIHyB7PPTxrA37sBW
         HXyA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787253178; x=1787857978; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=u+vZFL9QCUrHQWNeywdrmX/CGS7XIPcGZmcJEdaeksA=;
        b=HjtxiRk/0YfnOV09MlXe0Pfo0XYkO8wCmAN59X9bYO1GQi35prQemChY4NLZhVlLw2
         HVS/N+fvbYBhFREreghfMAHH1z0MxyrHc3oeDxHPPXpPf/S9kp7qIXnxxqDeNK9hSu3u
         65FwLR7TslEzv/zupeh3ceQTAZTxoNnJGWq5LNx0sJB02AlKQzX0cTPs/c3fg1Z3QpRg
         dXhB9r46Pwvse5Qn2o3mQJfFsqtEA4i7BK+sw1zQqntH5xe9IDvwgHTW3ftE+3wIMVoz
         EMTEH82F4xWv0qD2sq8SsqlugnnMo7DhPN8twOZ1PemNCDBYnHrU5xwzEhF4jrdisLS3
         uP/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787253178; x=1787857978;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u+vZFL9QCUrHQWNeywdrmX/CGS7XIPcGZmcJEdaeksA=;
        b=iRVLJX8WFv3an7eR8qzZwly7ugSjmCYEdcQkNKsJLkAsBZFaU4ZDl8OQeSiiRVo9wy
         tiWL/dZ1AJRTM1/cZj++BVooFGXdzD72pj6NQu1y0BOENkaLoaqnnBQ65SrwF5QfOjVa
         jUmDb6cRoKOOK42RXgx5XrMCWkgJzCFj43mqgY9pUbYO4x04EjOwEMT8AmfSEsh92/LJ
         RZcmRcYB66qewqrXDjCM9C9jp+lE1VkyQkWft0N83Tcsgc0QYNelnCYb0ecpQ9N2nrCv
         wHwVvcP6C4hdvZbjZjm+sdAixCti23QjZLHaMDN/uhkNbIb9xwKrnkpgxb+NvOE8R+eP
         j9cQ==
X-Forwarded-Encrypted: i=1; AHgh+Rosz4gfmNBM5QP3KNUfo2/jLH08fYQKz3bbPdyLRVEMT/CJY7qBBXktjSMHLZOueZbBP0S4pvDH03CWWYYM@vger.kernel.org
X-Gm-Message-State: AFuF++mMEG1/DvcgfXXdVqjsCM5VmzzVsCbkYd7JcwHtrfTV32d/aXgY
	D+d3etzjarcMOX8ERSMc5ip9A9cjs399xCgYJWZkABU4SVDaCDXvQs+zMIAvwrbM4hhoUclN/Yy
	bRmC3itmyj8CTtUJ+dGdAPdJKPQRvbLo=
X-Gm-Gg: AR+sD13La4LOvbLgGclqi3Tt3XKyytkvW41uJwa/vSW39cDoU+CTpwJ9ewTr5O38M1X
	lq+EdXHd40Y3AwmPXotqYdBligWrK1OZPr3uUAjorpFnEfbbpnRTRN9OfFLmAzavTRLj7udoFYS
	9aGCfYeyjUuX7EyocARgDlPf3ed4LmO1tVpngBpmCPNCbkSSsWaz5rt3ZZHJSF7NeBrIY/6cfv/
	QrAw/+GqH5M7jT1nILKDOeMH31gKhfo/L74vaIfbqJBc/YCtuCmPA6czffF7hKyw+BStZ+6pucK
	N5u7TND+xi8pAWDLqX5MLfbKeVAQQR39zdV/iTJ096maJQ==
X-Received: by 2002:a05:6402:e09:b0:6a1:f95b:8cff with SMTP id
 4fb4d7f45d1cf-6a42f14d945mr881033a12.1.1787253177867; Thu, 20 Aug 2026
 12:12:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260820175832.44512-1-kmehltretter@gmail.com>
In-Reply-To: <20260820175832.44512-1-kmehltretter@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 20 Aug 2026 21:12:44 +0200
X-Gm-Features: AcwNN1VoTb8-Y4yAhAEdExFUOY6_E29SmGdgjuOoDLFC6HRxDrS8gXBvh8R9q5E
Message-ID: <CAOQ4uxj+uFAR3YjE+XX98iJAdxNNqnaM6pptsqPaXnqJk4OXWg@mail.gmail.com>
Subject: Re: [PATCH v2] selinux: preserve user SID across nested backing files
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: selinux@vger.kernel.org, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 20, 2026 at 7:58=E2=80=AFPM Karl Mehltretter <kmehltretter@gmai=
l.com> wrote:
>
> SELinux saves the user file SID in a backing-file security blob so it
> remains available after mmap() replaces vma->vm_file with a backing file.
>
> For nested backing files (overlayfs over overlayfs, or FUSE passthrough
> backed by overlayfs), user_file may itself be a backing file.  Its
> fsec->sid is the SID of the mounter that opened it, rather than the user
> that opened the top-level file.  mprotect() then checks fd { use } agains=
t
> the mounter SID.  This can incorrectly deny access without a domain
> transition, or check the wrong target SID after one.
>
> Copy the saved user SID when user_file is a backing file.  Keep using the
> regular file SID for the first backing layer.
>
> With two nested overlayfs mounts and SELinux enforcing,
> mprotect(PROT_READ) returns EACCES with an fd { use } denial against the
> mounter SID.  With this change, mprotect() succeeds.
>
> Fixes: 82544d36b172 ("selinux: fix overlayfs mmap() and mprotect() access=
 checks")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
> Changes in v2:
> - Add selinux_file_user_sid() helper instead of open-coding the lookup
>   (Amir).
>
> Tested on arm64 QEMU at fd6e2388a3ea with SELinux enforcing and two
> nested overlayfs mounts. The policy omitted only
> base_t -> mounter_t:fd { use } among the relevant cross-domain allows:
>
>   baseline: mprotect(PROT_READ) returned EACCES with that denial
>   patched:  mprotect(PROT_READ) succeeded; test exited 0
>
> This patch fixes SID propagation only. backing_file_user_path() still
> resolves to the middle layer for a nested mapping, so the audit path and
> inode do not correspond to uf_sid, and that layer's mounter is not
> re-checked. Preserving the full user path likely needs a VFS-side change,
> such as having backing_file_open() store file_user_path(user_file).
>
>  security/selinux/hooks.c          | 9 ++++++++-
>  security/selinux/include/objsec.h | 2 +-
>  2 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 1ead2eee1944..171b90412ff1 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -3843,13 +3843,20 @@ static int selinux_file_alloc_security(struct fil=
e *file)
>         return 0;
>  }
>
> +static inline u32 selinux_file_user_sid(const struct file *file)
> +{
> +       if (unlikely(file->f_mode & FMODE_BACKING))
> +               return selinux_backing_file(file)->uf_sid;
> +       return selinux_file(file)->sid;
> +}
> +
>  static int selinux_backing_file_alloc(struct file *backing_file,
>                                       const struct file *user_file)
>  {
>         struct backing_file_security_struct *bfsec;
>
>         bfsec =3D selinux_backing_file(backing_file);
> -       bfsec->uf_sid =3D selinux_file(user_file)->sid;
> +       bfsec->uf_sid =3D selinux_file_user_sid(user_file);
>
>         return 0;
>  }
> diff --git a/security/selinux/include/objsec.h b/security/selinux/include=
/objsec.h
> index 3c0a16ec978b..853f7266ed18 100644
> --- a/security/selinux/include/objsec.h
> +++ b/security/selinux/include/objsec.h
> @@ -87,7 +87,7 @@ struct file_security_struct {
>  };
>
>  struct backing_file_security_struct {
> -       u32 uf_sid; /* associated user file fsec->sid */
> +       u32 uf_sid; /* top-level user file fsec->sid */
>  };
>
>  struct superblock_security_struct {
>
> base-commit: fd6e2388a3ea55e58cbbbef840c1d8aa2067dbb3
> --
> 2.39.5 (Apple Git-154)
