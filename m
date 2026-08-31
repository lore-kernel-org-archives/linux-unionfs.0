Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B2F563FCD
	for <linux-unionfs@vger.kernel.org>; Mon, 31 Aug 2026 13:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184082; cv=pass; b=bUjISWWjxJMsImMPEHkdBOkZXM+GqV8Je98tOKXGsy7BpeVj/XnzKUn2O0U6vI9yfvg31P8IPWOtdh7Mr6dz+qI31ASq1HAqLwq460q9J+rwxlKwmclRn4ouew1H11yImQ/CzlZdwjpmWgwe7xWvzJqfqgQOU5+w4S+UXxZTCNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184082; c=relaxed/simple;
	bh=6EmNPbgdthlv6HmYz6yjs79CFf+7Dk2QeNRcHQINiD0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u3h+NfnJ+78l4jI6nRdvrTyjnH0RC+AW7w2zSq/WLRIOde13Zn9LF5BOVzXN1F25xSfmrDhoZZFls0glXyxAuEEQjVs3blXyO1B6P6gwvel3PZ8p6GIwqL7KCSca67NbW7hHz8O8jk+Eij6D2ZEogycE48po9hkHab0IY/nYTTw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O3NnNCrv; arc=pass smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O3NnNCrv"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-6aa9606ddadso1164097eaf.0
        for <linux-unionfs@vger.kernel.org>; Mon, 31 Aug 2026 06:48:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788184079; cv=none;
        d=google.com; s=arc-20260327;
        b=q5E2rVslAItimcuEYhKEeEjzt1udgZCYTbpi71z1STPL4VPksl9nJ4b/mTXvLNLtXd
         hGVDMAVYzT25loBIZgxeAVsWpXzz2mKKL8V4RZml3LZcMTPCYYSS+D4EPb+OjgiBnYVp
         ERQMXhRIqeJ2A47PZYb3Goz4MMLY9TV1w1s3M3b29X9UN7kiizEyrY1TDPy1ZPh4kfnE
         Eap4k0dmqKBVrOwovCOYoGO7axLAMFudJB7IXdHzuITZFJPlfc0g1Cd1tDGg4MZPJIO2
         tEyIngCTubX3Mu/B9/BAnyZV97mwg1HsZ1gxMIi9/aDUJbkVyZUH/ak4D+4PW1wKphsQ
         AJsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3dOxHAFAAnCNkFLAXANF8z/KGOYsJeBy4b5mYI3CnXY=;
        fh=i7vAyg27dHw2Lorzcem2Kq0YxsZn1myhMlDzOfdloZU=;
        b=DsZNQr3sG21jJOX7emoz/fhDwLM9R54/siuPdgIkHUNnvWyC1YdfDk35x2cl2gS0N9
         6hqqaXPFAyEWQWOdFcaRmVC0D7aGOpa8drv38fKGZ1Gp3bNXcAEOGA82YZbwRgffD/Af
         fHfYFvMMOHEP+ycb/18ieOrEkgnkrS2u9920wv9cL6bSjQx38FvWIjgZWd+6+BTa0HvI
         Xczp7VHzzrE5re2cWhUUj2PkrM/7IqN6AxCaXDLNxDxtsXteL4yUeok8Z1abPM0ddx5k
         p6uH4LaixJBkY8KiHaAz/nnzW0UKD4eH7d4ENZg9JOwk46OI3qc37w7lXrmAHCGc85mo
         8X7g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788184079; x=1788788879; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3dOxHAFAAnCNkFLAXANF8z/KGOYsJeBy4b5mYI3CnXY=;
        b=O3NnNCrv8fE+NwgENRV1hTWmfNlmYQ04qnTpHeyCr23Fszt14vlRqOb1klG6VGPuIM
         r9JvptzArNTlUaDCIVnBbcOnJlAXLK0rOsOwNyeFRLDTJN7Ixj5DAyrBA3azQthyUG09
         VcYxjs4FbKX9TWSTCJOCoWJWTtMJfd9MGYJwhRIsmikqdUB6MSzZazHPeGV52sYQ89Pm
         rxusbQb1lj8/HjcHXMP8lJuOkl5EAfWJb61G9cesuVJwIP9CvBzcA2zdtsNX3eN60f7m
         BQ3xS2p/vG3UzbWx86PniiA04tVscsBreLzSJx5XMZRV/X0UoLfGYgGEz/jz90bICLKP
         NMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788184079; x=1788788879;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3dOxHAFAAnCNkFLAXANF8z/KGOYsJeBy4b5mYI3CnXY=;
        b=cKnGkREZtDkP5MN6cLNUT6u0VX5FBGMLNCl4I5EjrP87EHOIV5K5ullqMi1ZzPGsrW
         1MFCnK0W/LWxSxm8dwFKQnvo1bujxrz+ZcpHRSVdQX66iFMlJWkQdizgAj+5VQtmpY05
         aCywDkHn5LcLbZA+TtwF6rwSQjnqeGGhaUE1IGrPQ78KCF5FSvsDm1dNWfX77fxkqz8e
         JrmLElPAK3Rqgg83k13WZ/ABxzmen48aFmMzy47qC1B4WAt52TdakNI0JrUH5bkukFnv
         chxW5P8qe8ooNIf8+tERrEjAZCVyB4OFwIY4ZWOD2lebxFehnqLtO9LjWb0zhDoH57yB
         XmUQ==
X-Forwarded-Encrypted: i=1; AHgh+RogjJYDxtiENeKa6+nSPV/lEgk999FKuMH1sA71f7D0gismqsxAxcrqNAy0BGZ6pYtjm2Hx2qOG4vdZ/ntK@vger.kernel.org
X-Gm-Message-State: AFuF++mLJ+NerM175V4xb0+VanXmGJ0xZHTm/Jenex1wM8D1QD3qZnTL
	S2DNfMXR8rb2Jnx5PDEGpZl2YIL9FNZBLhP0LDUiNjg8P9eyXBlTZQOFyylyrth4Cj5o933qJdu
	wJNoNB4pgn5DniqsmcQZoW/+efvoc56Q=
X-Gm-Gg: AR+sD11gKGz/IIoHl4BbsteJgiDi8joJrSjQYUFq7LpRUIbPo60u2MuFwu2zUR8w9LV
	wM2r8y+D854qlurPUlIm2nAhFzNe+GXCVrPioM1zpo6UW5a1g8WS1LafBZCCpGip+FESOi7pt4z
	v6OPmiUA2oYl8OFqV+wwrcTmXFZFtQExIbMLflM6OjgtxoSzsOpR+35jg7/OlloNmASGTd0oDNi
	44O4usgUZfs9IPRVVR5eRlylSIzF4KQOTZDPmRoyPdl7d4DNasXenHlDsOTZoSaZq9CKxJDCDGT
	oWGq69IaYHWfdhfSD+4b0GJcu152SwRpi6/QT1k09wzyxa9nUDnVo7vg
X-Received: by 2002:a05:6820:26a:b0:6ae:c68b:3a7 with SMTP id
 006d021491bc7-6b1c6753623mr18493696eaf.16.1788184078901; Mon, 31 Aug 2026
 06:47:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260829213256.51527-1-kmehltretter@gmail.com> <20260829213256.51527-3-kmehltretter@gmail.com>
In-Reply-To: <20260829213256.51527-3-kmehltretter@gmail.com>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Mon, 31 Aug 2026 09:47:47 -0400
X-Gm-Features: AcwNN1W99CqXWvenoG8rROnmu5fRwQuT08OeAJUbXEa2X-h97G_VigU5iiBhoYc
Message-ID: <CAEjxPJ6TRV5CZyuMHatON021ptwzfhsniVKER-vE6ASh0qhpRQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] selinux: recheck intermediate backing files on mprotect
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: selinux@vger.kernel.org, Paul Moore <paul@paul-moore.com>, 
	Ondrej Mosnacek <omosnace@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, Christian Brauner <brauner@kernel.org>, 
	Baokun Li <libaokun@linux.alibaba.com>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 29, 2026 at 5:33=E2=80=AFPM Karl Mehltretter <kmehltretter@gmai=
l.com> wrote:
>
> mprotect() can be used to bypass the SELinux checks that mmap() performs
> against the intermediate layers of a stacked filesystem.
>
> mmap() checks every backing layer as the request descends through the
> stack.  mprotect() only has the lowest backing file in vma->vm_file, so i=
t
> rechecks the top-level user and the lowest mounter, but skips the mounter=
s
> of every layer in between.  With two nested overlayfs mounts and a policy
> denying mounter_t -> middle_file_t:file { execute }, a direct
> mmap(PROT_EXEC) is denied:
>
>   avc:  denied  { execute } for  pid=3D71 comm=3D"nested_exec"
>     path=3D"/payload" dev=3D"overlay" ino=3D9
>     scontext=3Duser_u:base_r:mounter_t
>     tcontext=3Duser_u:object_r:middle_file_t tclass=3Dfile permissive=3D0
>
> while mmap(PROT_NONE) followed by mprotect(PROT_EXEC) succeeds.
>
> Preserve each intermediate path, mounter SID and file-description SID in
> the backing-file security blob, copying the saved entries when another
> backing layer is opened.  Allocate the array only for nested backing file=
s,
> and release it and the path references in the backing_file_free hook.
>
> During mprotect(), recheck fd { use } and the requested inode permissions
> for every saved mounter, and include the intermediate layers in the execm=
od
> checks.  Policy for nested stacking may then need to grant intermediate
> mounters what a direct mmap() already requires, and execmod on intermedia=
te
> labels for binaries using text relocations.
>
> Tested on arm64 QEMU with a small BusyBox initramfs and a purpose-built
> SELinux policy, on a mainline tree containing
> commit f2381b546e7e ("fs: fix user path of nested backing files").
>
> Fixes: 82544d36b172 ("selinux: fix overlayfs mmap() and mprotect() access=
 checks")
> Cc: <stable@vger.kernel.org>
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
