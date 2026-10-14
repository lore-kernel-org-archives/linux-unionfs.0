Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB7048FF71
	for <linux-unionfs@vger.kernel.org>; Wed, 14 Oct 2026 10:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791972241; cv=pass; b=nrudx44I8CQAIeLNiefwRyyOaurr9voPvI+czwQV1UxMSav5185Mt5jBmA4mdVX3bjnrVfsinv0R0OcJfab93n3GPP3Ou5R6aezNQAEwTAyNgfx7DveYFqVS5oOmH2QMjVw546akQKHJPTvK5zaNSqCgK9ABTBf6LkuKLJHif/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791972241; c=relaxed/simple;
	bh=UZrCYuaUTQMamg1VqCT1HPzV2dT0XAOB0sGgHU48HvM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bUaSKTfdG4dBYQgPaxPFT6SHm/NIKYFUcbyt/7MU+6WpQkAWdJaOmRRn5vdDD65A7AKw9T414mJlwsYrv2om+9Nyb+2SKit/9E3gUH+pVGxw0aJEH/N8CeKwzv6bv+P/XgN8JZqMoA/PyDunlOIunZIkmDvp+Y/FWbuHDFYeLDc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=studiomoob.com; spf=pass smtp.mailfrom=studiomoob.com; dkim=pass (2048-bit key) header.d=studiomoob-com.20251104.gappssmtp.com header.i=@studiomoob-com.20251104.gappssmtp.com header.b=Au4soWdg; arc=pass smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=studiomoob.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=studiomoob.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=studiomoob-com.20251104.gappssmtp.com header.i=@studiomoob-com.20251104.gappssmtp.com header.b="Au4soWdg"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-93e56c287b3so15234685a.0
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Oct 2026 03:03:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791972238; cv=none;
        d=google.com; s=arc-20260327;
        b=FadJOcCnFFirZ5PuRCPp2qtrKtzQO9kA4PIIq6Z7hUmudYpbpAU48Du4YGVC89Cc74
         2ghfXs1duagGyLdp0iwdiF4h/9Lf76zpG3Wb5Q9bfxIFFBFFp+SODsBxK7HJC5b2bdbF
         jJ8sJIIM6kuHM+npWQBzpBdBAlv/KKEKlQyDO/egLNpNNZfgAnFg1esWxsHlQc2ZRzEM
         YQ2YEUpPZRJB1kXfZDWbUI4p1GIdmoqLj7fRyeJ5VwqBD+opBKltfWcnsK3UH+WZ55s/
         b0t63yDeC7eoGdUqdSixGSJ8lcfFenJqh3hcNbaTaB66aMAkPG72vpobOgAOFMANHAol
         26vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=thchtoRfpRattPd+CiIPEW5SsXn7q/xW7mGzqNSoohQ=;
        fh=fomwzveE/Xjk3gStLLJro6nEI5DVJGG0mv/WGRreJEA=;
        b=gopdaPZQLeMgu4nJetHtLmJFcCbsa/1Kl/kYSe+kmlbuxJ9KGpJ8bI60mPfkFrF3l+
         ZJmBoeFo1wzQLVrdThWjF5Ur4Q6icU2mwiUuAICwF70oTk5j+TuaOlMMqj0zMBF1p02J
         4mcdmFyLGc7ot8cQw+V0079D0++v2cKO6PQa1pXtNh7xftPiQ9a0pECUOkTvVXaIDdik
         MxrnVyS5yeveE7Vgm7QaTVimllNpkaGpQcSlbE6iBc10zT2/FlN48xLFwxpaUrOtHZFE
         jLRYUHnfBdGw0VmXOFddnZGpzSLEsRsyEYWOjtOQw5Z/BO6YE5TVm06S8O9AkzJs78Xm
         sL4g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=studiomoob-com.20251104.gappssmtp.com; s=20251104; t=1791972238; x=1792577038; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=thchtoRfpRattPd+CiIPEW5SsXn7q/xW7mGzqNSoohQ=;
        b=Au4soWdgrHPoOCNlzaVvoDyv5hp8v/eXU0N4W0PkprKsittMbef5VYqC9g22oQ8zhE
         hrcyk0YxEUJQ+gauFzq8GsqQgdfRc1B0IqHyrNph6fHX4fUcfrely9id6R2CBrZWAd6D
         2UmyCn/XtyjM85v+LohcTOS06u+d/VvJPgfGhUM1zGueG3WNs26QG2G5H81cCPAimzbn
         iEBOu5n2rhSP5ZYPFHDLJkPtwrFiljKgTpIG11CEm/LwNXyeJX1nCHhSaohh62L68o6y
         M+fCb2f3t2RM7TGrDtWNoIPCRiP8YXsRxojYRH7hwSjyIZh1p+ITyEr8uIedfmJ6Ie2X
         +yPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791972238; x=1792577038;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=thchtoRfpRattPd+CiIPEW5SsXn7q/xW7mGzqNSoohQ=;
        b=neuHNzRvUPuRPyoMerbAPqcUCNPW7e8yNiMy8JGajsMKEJv+atsla+Arfn4+ydUWMw
         I0osyz7kNQoErXAMOmrcSUeast0Ym6i6fDjj/7LbHM1iMSQIwluynBy88Qzxv8olZAE7
         km87vQFH/pGK++Okn/sArGAWXMVMurQrd2QirgdNk2ydmqzT9Sn41KvpE4MvLEoWWpzf
         p/XH1PkX8N8ypvRWCmlWd0XLj0Ij0VUrJBEbHGxIIMY3CdozpCJFzlRLKPOJ+mVNdlaV
         buG7ngZBuC/fAYuIJeZ+XwU9tTsfgN99A/GqRwUc+tLXwhLygyazOSnql7STP3m2qZOz
         zwLA==
X-Gm-Message-State: AFq9FYJUm1rok2UEoP/Qj8Zqi0SOlp/AsIj+FH3uV4o8WpsTfagq3KQ9
	osMGCO5/br4dKf3g2pkm+NiRrT4nf0LcXMhGd/PdpdWwPGKjuvSgOdsBCjEuK8mMW7I6IJ0EeHw
	mVdBYllecL23++DVhanIY66MMKGMZgOxYDaUYmacdyYjcOEKiEGuspoo=
X-Gm-Gg: AYBFou24FcKvm4VrU+jn7HeCLqTEqzZrdLX5XHrWu9UaZdknuDbHokO9ZAv3dsADK0k
	bczj7dsISs+NbAT0CTfvGUAq+OCo9qQzRihsVtCJQb+tYqIVT8chfZIoRWF5ClyB081WveyhjI6
	zlTbWEzGtEDLSO9N+Kiwa6tmy9DG/iYYhfLzfe41GBZLBfZ2fVTAmnz3gYLX7CvXgzI7M6W/FnZ
	w3wgb17EHNqJf3RtQ2uNh7btkoyq+l5Ib5+FZS/qR/nXguNRIfd2e38nDU3F87PsgqipGUOO/Ww
	kaa6ALPt9cSEg6JnyBobjWeDb5g/EWNel5TGFtE/tlcSLXX2saPBNN00aIO7oyUo38gYpYFoSvj
	U5RlXYkNbomvm
X-Received: by 2002:a05:620a:4456:b0:93b:be6d:4f3e with SMTP id
 af79cd13be357-93ebd1b7386mr2535918485a.25.1791972238079; Wed, 14 Oct 2026
 03:03:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACU5Mh9eozKjrTdsLq1bzsO8Ceg9rtBXoS7YUyCkieZq1JRESw@mail.gmail.com>
 <CAOQ4uxg7wLF2VvK8b5Rqn3KX=DUC7MueprVVu5GhPDUtiFb_sw@mail.gmail.com>
In-Reply-To: <CAOQ4uxg7wLF2VvK8b5Rqn3KX=DUC7MueprVVu5GhPDUtiFb_sw@mail.gmail.com>
From: =?UTF-8?Q?Cl=C3=A1udio_Fernando_Pinto?= <claudio@studiomoob.com>
Date: Wed, 14 Oct 2026 07:03:45 -0300
X-Gm-Features: AclHuK_Gw9ob23eMayD0yBTqPV_33tqMlwZIK9fxES14CtIFUhUdiUp452BZ28E
Message-ID: <CACU5Mh-6MzpLT-hY0WoZsEWve+bAA7WvV877YhfyhkKFWhoadw@mail.gmail.com>
Subject: Re: [RFC] Stacked fs, mounter creds: caller checks in the lower fs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Oct 2026, Amir Goldstein wrote:
> This is an incorrect over simplification of the permission model.
[...]
> There is no distinction between data and 'name' operations.

Thank you, you are right, and the error was mine to check. I read the
"Permission model" section and fs/overlayfs/dir.c in 6.12.112: every
access is checked against the caller on the overlay inode and against
the mounter on the real inode, and the real operation, name operations
included, runs with the mounter's credentials.

So what MoobFS does is its own model, not the overlayfs one:

- name operations (create, unlink, rename, setattr, setxattr, ...) run
with the caller's credentials on the real inode, so the real fs
checks the caller, DAC and LSM, and nothing checks the mounter;
- data operations on an open file run with the mounter's credentials
on the backing file, after the caller passed the open.

I have corrected our design record, which made the same wrong claim.

> Terminology nit: [...] If we refer to the underlying fs objects as
> 'real' or 'backing' there is less confusion.

Noted. MoobFS has one writable backing filesystem and no copy-up; I
will say "backing" when writing here.

> The resulting access permissions should be the same.

That gives me a better test than a list of checks. Without copy-up the
equivalent is a bind mount of the backing directory: the same
operations, run by an unprivileged user through MoobFS and through
"mount --bind", should give the same results and errors, except where
MoobFS documents a difference. I will write that test.

> If you find gaps between the overlayfs permission model and the
> implementation, bug reports and fix patches are welcome.

Understood. If the test turns up something that also applies to
overlayfs, I will report it here.

Thanks,
Claudio


Em qua., 14 de out. de 2026 =C3=A0s 05:01, Amir Goldstein
<amir73il@gmail.com> escreveu:
>
> On Tue, Oct 13, 2026 at 3:45=E2=80=AFPM Cl=C3=A1udio Fernando Pinto
> <claudio@studiomoob.com> wrote:
> >
> > Hello,
> >
> > I maintain MoobFS, an out-of-tree, experimental GPL-2.0 stacked
> > filesystem for 6.12. It is not proposed for merging and this is not
> > a patch. It was developed with AI coding assistants; I review and
> > test the result, and nothing in it has been externally audited.
> >
> > It follows the overlayfs credential model: name operations run with
> > the caller's credentials, data operations on an open file with the
> > mounter's.
>
> This is an incorrect over simplification of the permission model.
>
> See 'Permission model' section in Documentation/filesystems/overlayfs.rst=
:
>
>  a) check if current task is allowed access based on local DAC (owner,
>     group, mode and posix acl), as well as MAC checks
>
>  b) check if stashed credentials would be allowed real operation on lower=
 or
>     upper layer based on underlying filesystem permissions, again includi=
ng
>     MAC checks
>
> There is no distinction between data and 'name' operations.
> For example:
> ovl_write_iter() -> ... > vfs_iter_write() -> .. -> security_file_permiss=
ion()
> calls the LSM hooks with mounter creds.
>
> Your (or the AI) description above describes the UNIX DAC
> permission model where permissions are checked at open time and
> not at data access time.
>
> >
> > This week fstests showed that our copy_file_range and clone paths
> > called the lower as the mounter without file_remove_privs first.
>
> Terminology nit: in overlayfs 'lower' refers to one of the immutable unde=
rlying
> layers, unlike in ecryptfs where 'lower' refers to the mutable underlying=
 layer.
> In overlayfs the mutable underlying layer is called 'upper' and IIUC
> your experimental fs is 'upper' only.
> If we refer to the underlying fs objects as 'real' or 'backing' there is
> less confusion.
>
> > The lower clears set-user-ID bits and file capabilities only for a
> > caller without CAP_FSETID, and the mounter has it, so they survived.
> > overlayfs calls file_remove_privs at that point; we now do too.
> >
> > Question: besides the cases below, is there another decision that a
> > lower filesystem takes from the caller's capabilities or ownership
> > during a data operation, which a stacked filesystem must take itself
> > before switching to the mounter's credentials?
>
> Short answer: I don't know off the top of my head.
>
> The *expected* behavior is maybe best described in the doc:
>   Another way to demonstrate this model is drawing parallels between::
>     mount -t overlay overlay -olowerdir=3D/lower,upperdir=3D/upper,... /m=
erged
>   and::
>     cp -a /lower /upper
>     mount --bind /upper /merged
>   The resulting access permissions should be the same.  The difference is=
 in
>   the time of copy (on-demand vs. up-front).
>
> But we may have bugs here and there and some behaviors (e.g.
> CAP_SYS_RESOURCE, mprotect) are hard or impossible to
> implement with full fidelity in overlayfs.
>
> >
> > Already checked, against the 6.12.112 source:
> >
> > - file_remove_privs before write, splice, fallocate, copy, clone;
> > - CAP_SYS_RESOURCE dropped from the mounter's credentials;
> > - dedupe: allow_file_dedupe runs on our files with the caller;
> > - removal of security.capability (cap_inode_removexattr);
> > - open: may_open on our inode, permission asked of the lower inode
> >   with the caller's credentials;
> > - only S_SYNC, S_NOATIME, S_APPEND, S_IMMUTABLE copied to our inode.
> >
>
> To be clear - this is *not* a list of the only cases where call
> credentials are used.
> Most of the time it is generic vfs code that enforces the overlayfs layer=
 access
> with caller credential.
> This is a list of checks/actions where the vfs generic implementation
> falls short of enforcing the overlayfs layer permission models.
> (or remnants of redundant code from times when vfs fell short)
>
> If you find gaps between the overlayfs permission model and the implement=
ation,
> bug reports and fix patches are welcome.
>
> Thanks,
> Amir.



--=20
Cl=C3=A1udio Fernando Pinto
claudio@studiomoob.com
www.studiomoob.com @studiomoob
