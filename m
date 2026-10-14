Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0CC480DC4
	for <linux-unionfs@vger.kernel.org>; Wed, 14 Oct 2026 08:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791964905; cv=pass; b=YO+hCtU293cEoKOgk2BjztrAqP5bKYSM3Hqxe10cRhMuhl/LvO8fmpHscA100A6Gk7lAkc7yX9hVx6+2OjsOGYbd5kmyvAAO03ZMuP/fRCwcWEX66t2W6GqZIC/729VJrGzGvSi97WbmnBLKh+NwcKv3gOVfu4b1INkTtuDBGls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791964905; c=relaxed/simple;
	bh=nMvl9L4ZWyeWCWMnzrSRSNz62jXyePEuRw0RiGMN1T4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jEvLOmWJculFbw5qSFiatgc+n9YeKy1TeKV1C39BbcMo4Qnjpugx7sImr5Emb6eqCFzcueSUTjPqQ7Dk8zrTpMglHIxjxPxZk1EXnfMrSA+qmboqTVgmY9cUWIS342dvz1vsaNtm7t0aWhRUde4A3nR8NNXkTkIruMIhGlbrZlI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tz4A/h8Y; arc=pass smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tz4A/h8Y"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c38ac26cc5dso145290566b.2
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Oct 2026 01:01:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791964902; cv=none;
        d=google.com; s=arc-20260327;
        b=AaDDL3/hlCtaTNyPwxDbamTiD734AXTQbB9UeFQUy+8xSzpgtg2nbFQiMU41tx9iJj
         jtucALs5KzwJdPbr5Mn2dqfTi/0E5Mp52MurP9pJ46xui440mrhx0tZDlxSKS4afVWjC
         xIJ7ZUSkshIX1/IjxrCo8B7NbpX7g1qqwWdRhMeRjC1f0AugFUIgfzGv1fhWhLa5o0lt
         P72DTrHseyX9luZY47pdV8hn8kHecgSwoC9at7jALlqz/G9QCsvukL4eyIVFF8SMfpln
         ePiyB3F+ZLygqSoUZWcpLM4Ej7feS61OCqn47baZt4oof6vMEMHCjtUgF1EWr/BJh+nd
         SzUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TuVX93VSPxAJP7ElsVTKgltaXKj5eUf/FR0XKa+LcPQ=;
        fh=eXU9ZyOoCTdT+n3i10cL3KUU6NnaK2V2ciGMSuPxL4M=;
        b=VF8myMmT9PT9HQWzQQ5ADTeIOgszpGeG67fRtYyu/aB3+ODkTZXqaYy+JguRjpcoaJ
         wvvMMDGF65GaBEgTPvXeAvuAgXJhNFIu0bq0z47Zh+sclXOpWH9LJ9UvUTg0P12Rn26O
         anu+7JQzW6oyeTxcZvTLraxi8srxZFZK97vuJ7fK1aeDYbmqSA6ydtjLuWqBhS0LQaN6
         JVGV9qpqgc9qWRgfkjbQZNLfQe0kfbtfaQpBv+Yb8sb3QjtlmpoKXLOOLgCv4M3mf9Ls
         h6n+/ZK2lfhEYmfMNLr+1RCs1KrxcnZJuJZkGLoYYm78aWDshXa1OTD3zWaNcRb70eQt
         VW2g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791964902; x=1792569702; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TuVX93VSPxAJP7ElsVTKgltaXKj5eUf/FR0XKa+LcPQ=;
        b=Tz4A/h8YfKlVTM8keF1y6QJFLx4So5YKI8I3fKadm3+WzefV1j7Y6W9FKP3iTxclH9
         uwoCat3yph675VDT8b+j/hoVJMSnoORJ/Ja/UOgkQG9TgbfyprBb+w5QSw3KX/+QkLHs
         WTJ6Qc/VLvhhJPKG38sPG693Gsm8r3UZiQOlqNgxcWHxeRW7inkYDh05TirRipRz6APE
         bCqluY7NK+0lYlorp42uR8Z4XU2EuFhs66EXgjiG1TONhVNyWnE/MamzRXbF34AJGVGV
         lLUmKsfZygqXJL9DyI21xeuDlIgdd2OjJgKspDc6SK3ocigoevSuu04qZZpicjI2pBiO
         WmDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791964902; x=1792569702;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TuVX93VSPxAJP7ElsVTKgltaXKj5eUf/FR0XKa+LcPQ=;
        b=MHOaw3wOgtYKP6+3w3knMcNnsKI5G7oY1Nqa2aSrHgenX46h55llJt9bzYYaYYAiqU
         mN37i7/4cwmz0UFW73xHC2zvSMLE97S11NDwAq8g+trpAppfhun/5qt/W4lHwLukL9aR
         uXqDjE3Oo6hOuG6Y3IFgvdjm8nOkQ3+iOJQOdk1rRtQ7ihoERdcYyTUrVeHNDXgYSdHy
         /Ffe90lHipwl3VOwqooIBIOmuUVeD1yWmG5E0e0T7dfTRspQymGw6Pd2x7F40jM/QHwp
         aIFZ+WoM+qp19FgeamGvyZsVTorfklfD+024QGznEUFY0kNlzysTeOMnR2wXSnQ9aZ1w
         0smQ==
X-Gm-Message-State: AFq9FYIe9cDD5rOMqezHN86u5qIQjjxRQ+57Ndk1LPqwHb3n/KMOMqFC
	Yn4Aic8jaMeHzvI7CPRsq7MSsI61LNV29244utecK/Jbi96kAx40hcGTgw1aZY+kLesrNWnga7g
	GeYY/BvzOM2shBEJC5NKknF39evC4qUngJ3JeaiA=
X-Gm-Gg: AYBFou2IVIBXOYBg05JpnM31Jf/cyBL8rhxKxaInozI7epcrp0pWd3aNQsQfbxEZBrn
	r1z23y5Qv5t4T+ohDKayp1/WAiljclEc6hhJdQc1SEvYburdt3YOOUYLBr57BB3w25vSxd8ynGb
	2EH6eWedNLVE7NDfJsZbmRjnRlgdoRfKg01kzpUH4OYmI7Xand5nsB0zP7SIw0XQx0NrTRMlMMP
	dX2Ud6hjyThNBfoeeQhS4zRTB5OhNmKBACEsj22n9cKeibPCwl5AzmC1cJfia7mu+3diZxDXIYh
	EqMVLraFAej0HCSR/3wrdT+j2ZkPGG7XR5gk4UknowyJGaHdDErUBCkV
X-Received: by 2002:a17:907:eccc:b0:c25:4f7c:8ec5 with SMTP id
 a640c23a62f3a-c31aa0291acmr1369714966b.23.1791964900893; Wed, 14 Oct 2026
 01:01:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACU5Mh9eozKjrTdsLq1bzsO8Ceg9rtBXoS7YUyCkieZq1JRESw@mail.gmail.com>
In-Reply-To: <CACU5Mh9eozKjrTdsLq1bzsO8Ceg9rtBXoS7YUyCkieZq1JRESw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 14 Oct 2026 10:01:29 +0200
X-Gm-Features: AclHuK9CSVZUJdflBjYQytL8TakpDrS_2u6WeNEQOBVYYpqCVgiefePpB6S4BA8
Message-ID: <CAOQ4uxg7wLF2VvK8b5Rqn3KX=DUC7MueprVVu5GhPDUtiFb_sw@mail.gmail.com>
Subject: Re: [RFC] Stacked fs, mounter creds: caller checks in the lower fs
To: =?UTF-8?Q?Cl=C3=A1udio_Fernando_Pinto?= <claudio@studiomoob.com>
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13, 2026 at 3:45=E2=80=AFPM Cl=C3=A1udio Fernando Pinto
<claudio@studiomoob.com> wrote:
>
> Hello,
>
> I maintain MoobFS, an out-of-tree, experimental GPL-2.0 stacked
> filesystem for 6.12. It is not proposed for merging and this is not
> a patch. It was developed with AI coding assistants; I review and
> test the result, and nothing in it has been externally audited.
>
> It follows the overlayfs credential model: name operations run with
> the caller's credentials, data operations on an open file with the
> mounter's.

This is an incorrect over simplification of the permission model.

See 'Permission model' section in Documentation/filesystems/overlayfs.rst:

 a) check if current task is allowed access based on local DAC (owner,
    group, mode and posix acl), as well as MAC checks

 b) check if stashed credentials would be allowed real operation on lower o=
r
    upper layer based on underlying filesystem permissions, again including
    MAC checks

There is no distinction between data and 'name' operations.
For example:
ovl_write_iter() -> ... > vfs_iter_write() -> .. -> security_file_permissio=
n()
calls the LSM hooks with mounter creds.

Your (or the AI) description above describes the UNIX DAC
permission model where permissions are checked at open time and
not at data access time.

>
> This week fstests showed that our copy_file_range and clone paths
> called the lower as the mounter without file_remove_privs first.

Terminology nit: in overlayfs 'lower' refers to one of the immutable underl=
ying
layers, unlike in ecryptfs where 'lower' refers to the mutable underlying l=
ayer.
In overlayfs the mutable underlying layer is called 'upper' and IIUC
your experimental fs is 'upper' only.
If we refer to the underlying fs objects as 'real' or 'backing' there is
less confusion.

> The lower clears set-user-ID bits and file capabilities only for a
> caller without CAP_FSETID, and the mounter has it, so they survived.
> overlayfs calls file_remove_privs at that point; we now do too.
>
> Question: besides the cases below, is there another decision that a
> lower filesystem takes from the caller's capabilities or ownership
> during a data operation, which a stacked filesystem must take itself
> before switching to the mounter's credentials?

Short answer: I don't know off the top of my head.

The *expected* behavior is maybe best described in the doc:
  Another way to demonstrate this model is drawing parallels between::
    mount -t overlay overlay -olowerdir=3D/lower,upperdir=3D/upper,... /mer=
ged
  and::
    cp -a /lower /upper
    mount --bind /upper /merged
  The resulting access permissions should be the same.  The difference is i=
n
  the time of copy (on-demand vs. up-front).

But we may have bugs here and there and some behaviors (e.g.
CAP_SYS_RESOURCE, mprotect) are hard or impossible to
implement with full fidelity in overlayfs.

>
> Already checked, against the 6.12.112 source:
>
> - file_remove_privs before write, splice, fallocate, copy, clone;
> - CAP_SYS_RESOURCE dropped from the mounter's credentials;
> - dedupe: allow_file_dedupe runs on our files with the caller;
> - removal of security.capability (cap_inode_removexattr);
> - open: may_open on our inode, permission asked of the lower inode
>   with the caller's credentials;
> - only S_SYNC, S_NOATIME, S_APPEND, S_IMMUTABLE copied to our inode.
>

To be clear - this is *not* a list of the only cases where call
credentials are used.
Most of the time it is generic vfs code that enforces the overlayfs layer a=
ccess
with caller credential.
This is a list of checks/actions where the vfs generic implementation
falls short of enforcing the overlayfs layer permission models.
(or remnants of redundant code from times when vfs fell short)

If you find gaps between the overlayfs permission model and the implementat=
ion,
bug reports and fix patches are welcome.

Thanks,
Amir.
