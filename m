Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812563546EB
	for <linux-unionfs@vger.kernel.org>; Thu, 20 Aug 2026 14:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787236367; cv=pass; b=ehoIBoSFDHKRTjDl63TscPUxreSKNjpkXr+oYunBvzRtMMGUeBsLCAGwHyB9F0IXmjHc4Dwa3NJNgUglVswwKKm6ot65hDw4ThNERJD7EvdA8kXCqvY2LFzb+PxUALjq1Bc+GnqpgUhB5g2+Ojs/xtvCQEgJ3vRULTQAQTGbKic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787236367; c=relaxed/simple;
	bh=N9qRFu4WM8WnVsbLoreYprSqHgn/OjQDC6eflC7v4CM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=unxfUHki4ZbAqIN9+3EnrLGxsSUxFkDiolKqCAu6rd7/I0blHVm4mvcgwe96Yp4kD50bD7KBzlwB6+H9wn4+niEGwIZR/ED6fBKBRoRpiEfEe1EURPE4GxIzjpZJ8puQD3o9X0LZi5dZGMYdZjgUoJjJMHEncC+6Ww9I+M+EKHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nw+n33BA; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nw+n33BA"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a17cb94b26so3909744a12.3
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Aug 2026 07:32:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787236362; cv=none;
        d=google.com; s=arc-20260327;
        b=VR7N50SMCIRKf6IasBvv++Y0NVYDFhZ0zO7uqLJl53s5yFix5JinXk/7lRfHUbjYao
         YwAGaEWXtCUvnjI/CZhVpHYarUQ+w3FIb0nw9bmy676NNYOytBw5SRgMeJ3EsSrZUfBX
         0teLJO5RU37IDQxykUeOvRLbaN28Qv+EOXz6HK1zGW+s+7uOVxgjU1GMz3ouiiuFvw9Y
         y+TYAXbLBWaiaPYqVsmn29jC6dG3rLCD4GS8Z1AndMzhGdbUP8xX/wWlVrUDEb/C7JgM
         ji+5C7z2PVEV9Vt3TeY2vdXvuiIC+nLmKwHp+FyJNVBwErGZqCU+f/xB1QGOoDKehtpG
         nweA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+3owqiMuWuSPH/bhodOVPPoGcMgRZTIUNdlO0mdLdRE=;
        fh=dTXwkdmclQyuvf18GhW1rm1Gr80/G4eevfC6YF486XA=;
        b=iPpW7OvR4Lne79KVVfsXug3LcFsj/lj4Qo3pIvS4Auz8vZKTl1maKZw7IziDMg0Ve5
         QupkUk4IKL23tgmpXY9sPN/c5fS0SzIZkIyrmYMB1NN9ev56KPtsijWzlHIPO1h8ASv+
         cVJ1KAEdhXdCfGAJmswIhxQ1NhlzQ2nx9haP3dVyUT+rqQUCDN07erP5x8UDWXD0A0un
         GSqfLISo0QTDlH3NguShjiPkRX9/vO8tIGt3q5KMmSi/tuNiv95xKg+YiR1hKFr6eccy
         UMZplxOrhxVIVsI0A02ABVD7nALM4S9XRXKIRZmgVFz9KExVSnF0sHhYxxB5dQ5ebimq
         IHdg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787236362; x=1787841162; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+3owqiMuWuSPH/bhodOVPPoGcMgRZTIUNdlO0mdLdRE=;
        b=nw+n33BAxcbmIcTtLDMF4ZP4rgK2HZx+JLkvY8W+XXy9dFsoyMwYFpmoBPEDNFMZ6f
         Cp5jaOBVvcgy57gZy7CrzLtxvwNrxDcfLRFci5SF2bCKyKy62EnHr9WAeI+A4k+pI4Kb
         dsx2WXVOuLLev6LUgXvDXYDlqGhVE3heP4kX6EczFQkuSsQVnYESpuJenh2O5UWfAwHF
         oPTmqZ/BqpiuI1n1oSHDqi82IxX130BjBnUdu/Yb1Mtse7nZehMc4EcxZhlN5j4EUkPJ
         9wW6U1nB1V0IuwHNG1Tu7ocSQX3QYXz07XVlrFMN1NK0vk7dKk+452gDHSXX4dujdU+x
         E9VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787236362; x=1787841162;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+3owqiMuWuSPH/bhodOVPPoGcMgRZTIUNdlO0mdLdRE=;
        b=b8aNfzsieVygROls9T9Os4NolXgtkXMjAkYunJnYeA5Sd/SnGQHQ+zVzbP+LkZwVE8
         p1kwwvns2NJRMKSYDv8TOfjp+7XnP1YFIKYJfOBkL3Tgi/IE/4Kg0kJmXoxdcUp1vRdX
         BJvdDhDT003Prmc1RZd3j37Dt2wkc5j1nhqS2ctBTpcdiKvQY5D08myR9wAu9FioPLDE
         h8Q1WQd+ZjA0cjjuS4YKT9ooCcmwMwvER8SU2IDDna3clTC/fx8QSz45hLb/mUIg/eeB
         urhMPn8l7La6Dt2WskJzW34gBKpfEfoU6vsp3aHPW9f/biUCH7lBqvzmRILjjqo88AyJ
         fWRw==
X-Forwarded-Encrypted: i=1; AHgh+Ro8YopvxL0A8BgiJ20pnY/qEWM85VrWMpHE585RNA45WTrYs9gZTfnKEHf+Uxy+p9Z1OEinQ7yDYWUB9T2J@vger.kernel.org
X-Gm-Message-State: AFuF++lCgphAr9oHr+ZrzkwnhrOEeVUEtgf4r+DXrRue/hiWUDDmznoR
	uILc+KKAcRifs4Ez/1wp+/rU7gP/FH6p62eiInqHIFPwRFuVxMiwHt8AMvD8RZI3wng9P8u8wpV
	xZ2tffYIWxu80iszANsOkP/5/VgS6dZc=
X-Gm-Gg: AR+sD13h2KxqlWc6wsucILopIVefLZC9F7ZzqOyNKYv4K14x/zU7mSiu5VX1q2/gZfz
	/Ty+od/JRhagYxvSmySO5T9Gev4f8NK4nAxmnPHqWI2r/vQTuhgkSadUE2MdDH25WowCG1vGYvR
	x9Sfx2HVCSlG8Qi6QtMv5PsusTFDOK+Y6301fY13VP6EkHi7gV40SdzouEJkYSyUo0gR3GzjzQv
	llmvu9dAUr9R/ixTSy61Ba19EJB8ZNR+E7VenqRS2MUd1Ejii8xU79SI9PNXFQekAVMEBHLGAvk
	41YYIqmbxqg0K3WwWHKeFxzDVwJS9xSMU1xPAIM73vcqFT+bdfUeZyl6
X-Received: by 2002:a05:6402:454a:b0:699:728e:48c3 with SMTP id
 4fb4d7f45d1cf-6a4032fc5c5mr7757816a12.9.1787236361471; Thu, 20 Aug 2026
 07:32:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260820061349.10542-1-kmehltretter@gmail.com>
In-Reply-To: <20260820061349.10542-1-kmehltretter@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 20 Aug 2026 16:32:28 +0200
X-Gm-Features: AcwNN1XBsXitogIEUq0ntdJxL2LGIShvPphxQse83cuHfD_u0whlH1Af-ei3Mks
Message-ID: <CAOQ4uxhgMNvFxauLzm2PQif_D164+rJqmGdU5T+XDfhMJTVJnA@mail.gmail.com>
Subject: Re: [PATCH] selinux: preserve user SID across nested backing files
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: selinux@vger.kernel.org, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 20, 2026 at 8:13=E2=80=AFAM Karl Mehltretter <kmehltretter@gmai=
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
> ---
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
>  security/selinux/hooks.c          | 4 +++-
>  security/selinux/include/objsec.h | 2 +-
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 1ead2eee1944..8b96934e9992 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -3849,7 +3849,9 @@ static int selinux_backing_file_alloc(struct file *=
backing_file,
>         struct backing_file_security_struct *bfsec;
>
>         bfsec =3D selinux_backing_file(backing_file);
> -       bfsec->uf_sid =3D selinux_file(user_file)->sid;
> +       bfsec->uf_sid =3D (user_file->f_mode & FMODE_BACKING) ?
> +                               selinux_backing_file(user_file)->uf_sid :
> +                               selinux_file(user_file)->sid;
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

Sigh, this is so confusing.

The fix looks correct to me but I would use a helper selinux_user_file() ak=
in
to file_user_path() instead of open coding the condition above.

Thanks,
Amir.
