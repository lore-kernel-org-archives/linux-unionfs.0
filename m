Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AA533B6C9
	for <linux-unionfs@vger.kernel.org>; Fri, 28 Aug 2026 09:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787907934; cv=pass; b=cpbuIsKYlQB5k3swMTuLx21VQf+N2i+7ABfQQZ4/2TK76O9rsfE7X7F93dOjcrXEgYgrt++3uexUoc7W4dEqbmBFUgtZEYkTTFjMFFlQ2uFfiy8uZs81nX/P6rQ+lzqIOi63zZAlKcf0JvwGhtOSHPHrv/Ba87hufahWJbh/p3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787907934; c=relaxed/simple;
	bh=kcyY+NxYtD7T3O4Y9Nn6CHPlve9WbW1aHvF8C8OLgX8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q3gHKHj9UTPkI2YvlRIRMyODNw69I8fVPiJ+s8tcSm73b0OSYIPLMxP+9aUSW343kC6h77ZjqvxOCS5s3Jp/RylUo2CPvrtJdRMIh/YEQCmnktBLuLlODdNbwFZpMXSxnG4ESI/OFWnmo+35TslVUUZRsgZHfef8UXC3rhhs9NM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JWqB/sky; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JWqB/sky"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6a173ad7cf4so1083723a12.3
        for <linux-unionfs@vger.kernel.org>; Fri, 28 Aug 2026 02:05:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787907931; cv=none;
        d=google.com; s=arc-20260327;
        b=mG0bU/L380hQbNCqFHerx5aV8gNdMvc+g16PKpJkEGys7iWsVNccv4rYCaYVzyN0TO
         bXrX7nKzoUNTCH6SzhREBMVjiixrzoolWg16IXbNzCucTIrRovjcdfvyb2K460AC36s5
         6boaDEWuV7ECNBDhG3zFf3m1VXmA5ym0oE3p9p6e0JqBjYsbFQ+LyFuxnGQY36eTivBP
         RGGmpFbfej93UV2QiAZFWoJsjV5vol6FzRGuADJKK9SXQuFi77vNKsJ7JsFT6YNDxliV
         VQKK/An2QBxbwOGJiM6pnwvG9xz03fAE6D2izfLmchoEWqwIapwl7XbxZmS4rTLFJSPq
         nq3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iGb5RBnXDA+kbDx6QBFrMut47J0QFMd/GZl3kg+9bis=;
        fh=7VBHkiak8uv5XWnXFioLUWJAS5kyW51X92oyI3dIGS8=;
        b=FWBo0ZXUfg29jj6fKvjLHcNtrwllHaj1wJM8iolJGshnp984rqm0wa5W4ydGk4Ilnc
         CvDqXTaLaSsw1u7w3RQdToLWxErvQ+b5qRfPCp7aiilYBtJ5JJ/+QqTjLmbN0dERCHA3
         mOluzRlabEYz5MY9gMw2NoQQTmvB8jNkBUwndvH2c6QIdVHoLsyAQ2RyzxYiNrz7pw4R
         cNULProSTnAoofN38BO9BYb1jIYDmGeysxax6o/5yo9fTWzv3g7xa2CXGXYZCoWVSCQr
         NJ4IvQgwv8Q1T2xxgtLubzBS8xvVm2wc2megDsSpNutrJWFCIxVifB+T9O8rUATtcb3D
         8EwA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787907931; x=1788512731; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iGb5RBnXDA+kbDx6QBFrMut47J0QFMd/GZl3kg+9bis=;
        b=JWqB/skyHmfBvHnhrjw40ZDPyRfuh0PTuNhPCxIjWpIJ3pr/gcPIweFjwB7asklzhv
         6DRM1tZEco41nUTMJd58pG0Tsin5CJx/YOJn8RX1FqFaF4iQtacc+rp9NejZE/t9oams
         IURITUoHgHJ1Qqg0XD6LcOP4S7krazwj/6JB1Ju6xQDgaH92DFORSjZGXRe/nqqIe1ta
         2i/kpfHnJzOJAlCMX31DVgvYIE32p9oODuLi3U4ehSn5vBFvrEhhCpQuFYIxyhr1tDGG
         8S3teR7gAdys1LdmVXmY1xHN2mAK1g4GRU/XIcWtGC6AtHTJcm0rua+GqwjkC7C7luLu
         AomQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787907931; x=1788512731;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iGb5RBnXDA+kbDx6QBFrMut47J0QFMd/GZl3kg+9bis=;
        b=LTp2BgGbLZVG1kIZs9uHTFaPeSp4G8fS4jovhtXw7VImqPdvTTbrJvSeoywBv4j69T
         SsUev98NPVB7mD+q2MkveWoJirbtz2ODZw2GVOiX+Nfow1Fxtcs2CrWnfPDPj6wqYjwO
         nSzQYlXNWHiQsajbruO8hBoKxTxNKWFF6y1NSNd4ctu15CpYfZxPpa5/HQMxpcAreRge
         f/KRJFvFg1wLQKCdYQpREbLS6KsBu4aSLDMnOMP2S+GEFjub9W77NeZSs6KPnyqtRyxf
         aEJ+cHSKQGjxJPDGz3I3TratTX3KynYCUshYjxEa6DJOnx+bf4jDtaNL2qMNRJqUECjz
         xV9w==
X-Forwarded-Encrypted: i=1; AHgh+RqbPVanvJmLJWgf+aiXpd+ItJ3MaiXhj/WsugFZK6kIiNTz5L7Ph/wSe+lUWftfNMEbllwWwM9e8rBrDcyN@vger.kernel.org
X-Gm-Message-State: AFuF++ldneYUT0yRcQYN+UwLcdD4E3fXRmjNrHrTDPCaXxWRWHgZSYEl
	O/bUNwHQkhK2YWPS7yaznU/idx/SdYDGayJxM6RGrAOjtFpavPiQ7i3slhZQ/rfY8K6yohfVSJh
	O2hYfAYi6FhXvQj76sQMJ0JS7lx3HqxI=
X-Gm-Gg: AR+sD12S49X+bDQDJt6hv1ZtXacPYYomN17CjPXXfV7I1sQJspvruz0tP+GFEve9Fyh
	D8H7ZoZtbIsCXlybdXbECfXb7hEO6vTzqkjMk3tolp6mYuCtbMVi9ATB0hh2Z+Zy0MvjBCuOnzm
	7LiOzHil3udyMEgGc4s0BY+bpVe5WNyJlIfqYMPb8zLPpF6Yh+WVXHlMeYyqd+8EKwtMKXIu7KB
	qbyWQQyfUYXZvvyMveq1GHrhRdiBMZ/dd/F0+4NrO7tYBdzey/EuZI7NOyUcH4oLp2jQj5omVVL
	awY+6LLrWeu+L9jeTY6CUXEZtRhDCAegapB4Zx96GoDr3A==
X-Received: by 2002:a05:6402:3812:b0:6a3:6d83:ba44 with SMTP id
 4fb4d7f45d1cf-6a60d2f3663mr3556066a12.2.1787907930829; Fri, 28 Aug 2026
 02:05:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260820175832.44512-1-kmehltretter@gmail.com> <5fa5ef078f41cd57d0e52ab2ab023094@paul-moore.com>
In-Reply-To: <5fa5ef078f41cd57d0e52ab2ab023094@paul-moore.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 28 Aug 2026 11:05:19 +0200
X-Gm-Features: AcwNN1W4dZ0jbuPGgh02j4F1QLJuW5SvC4XfY9m2qygWs-rWNLFgcF97xFGTv1w
Message-ID: <CAOQ4uxjn3sWjkrV8KbA-V+eno3E4OskTnCznNBex6FOstEbJ-A@mail.gmail.com>
Subject: Re: [PATCH v2] selinux: preserve user SID across nested backing files
To: Paul Moore <paul@paul-moore.com>
Cc: Karl Mehltretter <kmehltretter@gmail.com>, selinux@vger.kernel.org, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 27, 2026 at 9:39=E2=80=AFPM Paul Moore <paul@paul-moore.com> wr=
ote:
>
> On Aug 20, 2026 Karl Mehltretter <kmehltretter@gmail.com> wrote:
> >
> > SELinux saves the user file SID in a backing-file security blob so it
> > remains available after mmap() replaces vma->vm_file with a backing fil=
e.
> >
> > For nested backing files (overlayfs over overlayfs, or FUSE passthrough
> > backed by overlayfs), user_file may itself be a backing file.  Its
> > fsec->sid is the SID of the mounter that opened it, rather than the use=
r
> > that opened the top-level file.  mprotect() then checks fd { use } agai=
nst
> > the mounter SID.  This can incorrectly deny access without a domain
> > transition, or check the wrong target SID after one.
> >
> > Copy the saved user SID when user_file is a backing file.  Keep using t=
he
> > regular file SID for the first backing layer.
> >
> > With two nested overlayfs mounts and SELinux enforcing,
> > mprotect(PROT_READ) returns EACCES with an fd { use } denial against th=
e
> > mounter SID.  With this change, mprotect() succeeds.
> >
> > Fixes: 82544d36b172 ("selinux: fix overlayfs mmap() and mprotect() acce=
ss checks")
> > Cc: stable@vger.kernel.org
> > Assisted-by: Codex:gpt-5.6-sol
> > Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> > Changes in v2:
> > - Add selinux_file_user_sid() helper instead of open-coding the lookup
> >   (Amir).
> >
> > Tested on arm64 QEMU at fd6e2388a3ea with SELinux enforcing and two
> > nested overlayfs mounts. The policy omitted only
> > base_t -> mounter_t:fd { use } among the relevant cross-domain allows:
> >
> >   baseline: mprotect(PROT_READ) returned EACCES with that denial
> >   patched:  mprotect(PROT_READ) succeeded; test exited 0
>
> If you could share the distro and some more details on the testing
> methodology that would be helpful.
>
> > This patch fixes SID propagation only. backing_file_user_path() still
> > resolves to the middle layer for a nested mapping, so the audit path an=
d
> > inode do not correspond to uf_sid, and that layer's mounter is not
> > re-checked. Preserving the full user path likely needs a VFS-side chang=
e,
> > such as having backing_file_open() store file_user_path(user_file).
>
> Additional comments below, and while this patch is useful in fixing some
> of the problems (thank you!), we obviously need to fix the others as
> well.  Is this something you think you will be able to work on?
>
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index 1ead2eee1944..171b90412ff1 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -3843,13 +3843,20 @@ static int selinux_file_alloc_security(struct f=
ile *file)
> >       return 0;
> >  }
> >
> > +static inline u32 selinux_file_user_sid(const struct file *file)
> > +{
> > +     if (unlikely(file->f_mode & FMODE_BACKING))
> > +             return selinux_backing_file(file)->uf_sid;
> > +     return selinux_file(file)->sid;
> > +}
>
> I'm a little concerned that this only works for one additional level of
> filesystem stacking.  Yes, I know that OVL_MAX_NESTING and
> FILESYSTEM_MAX_STACK_DEPTH are currently set at "2", but it's not an
> unreasonable concern that at some point in the future that number will
> increase without proper notification or testing and we will once again
> have a problem.
>
> At the absolute minimum we should have a BUILD_BUG_ON() for the stacking
> depth.  It would be good if we could watch both the overlayfs and vfs
> constants, but the overlayfs constant isn't available outside
> fs/overlayfs/inode.c (thankfully it is currently set to the vfs limit).
>
>   BUIILD_BUG_ON(FILESYSTEM_MAX_STACK_DEPTH > 2);
>
> Ideally, the code would be written to keep diving down the stack until
> it hit the true backing file.  No one likes to see recursion, but at the
> point where this function is called there should already be a reasonable
> bound on the stacking depth and the work involved.

Unless I am missing something, stack depth should not matter.
file_user_path() should hold the user visible path, for all the backing fil=
es
in all the depths of the backing files stack.

This is the issue that was fixed with commit
f2381b546e7e6 fs: fix user path of nested backing files

This patch makes uf_sid behave the same way and also documents this:

struct backing_file_security_struct {
-       u32 uf_sid; /* associated user file fsec->sid */
+       u32 uf_sid; /* top-level user file fsec->sid */
 };

[*] For me the "user" visible file is always the "top-level" but if
this comnment
    change helps others understand better it's fine by me.

Thanks,
Amir.
