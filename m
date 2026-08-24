Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633343A450C
	for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2026 10:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787567107; cv=pass; b=QsutFYogmKwirqIAz5JsxbvXDxbt5HIW7yi5YFmJkxOG2OzYy77GBAMZ+jqnssn/AANBPR0udWQGSVaOv5ITbt7vkLUGHZQsh8jcuAWN9jlzGk5t4o31fnLeUws+Ce6gFavHPa56wp0I1i+Jsnv8eyrGTCx/Iyhx9kMhcMzga1g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787567107; c=relaxed/simple;
	bh=jRJL+B6j0aZfEM9lAWSydnaja8lrBWvr5WIn6RxtOjM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qR+ZWuMQjHJJJ/oGHZBowfg+n5MJeaox457tPNZ6UKzBBR5KsblWsjO+Q6hkqJI2MyVQ8EjIIJJ3euoJuh0Prm3LwpjurMSLRZoB9x2X+FKO0ahVcUVnsKqoW0pUVYVn4pDcaqT3LNRq2XqJgRebHoZZDS1fDF7LSfzZ5sKNGIM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RXwkXphs; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RXwkXphs"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-69fc9f25118so3517874a12.2
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2026 03:25:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787567103; cv=none;
        d=google.com; s=arc-20260327;
        b=Ife4dGiMA5TeBc+mKchtzfiBfH11l0Sk9DRuRIFgUEMXZjnjfCag5KU1LFewsvtDHz
         1CDG3q8QZEqhUVSh83GPmnv6LcxY/EUF7rrXqdZM40gndLhOw9qfZxb8mFtHxAjZy+C1
         BZhOHFnagf/g2Mz2clJLA5XPtz/4TesqxWpYZeo2vJB8CNP2emJW89idUZd9s6b34GEe
         Il4qJjW754xfbevtNkhCrkPcqSlReJVmspU2FDV4gd6+6v+hus7yV2v5RBoHteeY/5Aq
         y+Ge+4W6os5VdLqHG9/XZURo7zvgWIb+yqK8XVLremw4u6qbChID0tL5amysAT4TIJ8n
         0FvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LSumoM54yBXiaUL9AWh3ThNUFhGpK8Wl7lBf/KLJkXI=;
        fh=chbdOfnFdo3lrMxfO55pGejD2by4degkwxGq69eGaag=;
        b=NxUxuzwt1QleY+XPyTxXrOsFUxBMJOx7JnU+9V0YJZar2s32a+h9rPvLSxroRPZfEm
         JTvd35YKlQMVH1gD+MF5r+F0uiudxgI3Wg0sVQC+w+1EdDsbO3LasmScdGLU/aU97rps
         tRU2O4mh5V4dmlFr2DVFq2LaE3PFubRq7SsBonyv2i8FxcRsacECPlCDarDm3Ktx873/
         r8mXp2Cx1NxY8lkB9GNMFEbZL9ZuEQWAfMVsagqBpN5k0ZXkXJO7Opa8h4C3i0qzfID5
         c2K6BlCrTnPmeCUwvfyPFo34L1qwnPVncANBq9cZOqkwT9VLxzMGvxTNq2/rRVj2aPO6
         hVFA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787567103; x=1788171903; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LSumoM54yBXiaUL9AWh3ThNUFhGpK8Wl7lBf/KLJkXI=;
        b=RXwkXphscnFVjx1mhyrjMJNTDGthQAwJK5l+eSkMw+32GLuXbnCJKLvr+R5VZdCdp8
         mNL7up4FsjU9ZV9nH1UFV/f3kcbJ28e6QR1PiGpZ2d4xRIZDgarI3Hyv6vy627ROiPGk
         0KX7/HL+9FrIRcbuqSD7XP431miFg/u3sswWe71y7rlgrqsFHNjfhlm2MlUtgkjRn+GM
         Pj32kzhrpdVEWg7rCvafMDTVYvx30HPZ/Aud9PoXcPbJUMZs39rmkikpLrabtRCFwRwK
         F5web4QN6bUC8pOuX86nmcGh5bN5pDzUcmTn4krCxECYq4LHDg04OAQsTBCVPRBeufkX
         yVbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787567103; x=1788171903;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LSumoM54yBXiaUL9AWh3ThNUFhGpK8Wl7lBf/KLJkXI=;
        b=dRyw3s82ZaFtif+viS01YUbjsxEw/jXmJIDnoNqb+1W3aX994gi0UoSPnsGDemV04A
         PXkhByNLaAR6/TxBMKPDouH+ZbLr+e0bc0nN5uOXojph8pGo9Bv5V7+/ZzJpFki5WwqA
         SRGq5Ev+Sf2YOD18+fSh1I2enOaeDtBRLVupr3MFfsEPj6n36jRar2ZPpZkpMCUVeSyS
         t/1J3XANZUwNboxXiObN0duNYwBAQdn7NmAQsPSjtY3WxT/xrCr8K5p6W3tedy5AegOn
         vs+8ZahgjoWa9XO7QJ7oihk9c/NrHWC6OAxQDHWq0XTrEPOchsu4qr2IknmhYaE7alhz
         z1Gw==
X-Forwarded-Encrypted: i=1; AHgh+Rp2jDPtcXSRacMd9oitAxgJ33X2n2NUjZFZ+vpvmYr9Tqeh+VLbVN6PV3ABoFhpVv9K/BnTqubElBTlOFLd@vger.kernel.org
X-Gm-Message-State: AFuF++kcZPRqr11w02gp02q8xftwG5qR4diEcWHWJ0IxgrGxnIGfdoa1
	kdtQfp3s3SeBw4fOW3hR7D/JiVT56v93ytdfyU8hWAru2nfi4SvcDUJcx3a9ZB7TQQXS13Vx1qG
	LPgr5H3zCpuPyXlpL50LhMj0SmVVE8N0=
X-Gm-Gg: AR+sD13kYy/q+MVXN5O+/baFN8ePzmnNd34VC+ziDi5kS/bA9+trUWlnIBPFGyS805P
	Pa4P14FSdiXlFVGsOSju9neh+nAYLjKbwel8tKz376jZyGpeEBonPMNL/KCL19DSJeVbypgRrVR
	Ok38Hqr89MXzLd9ajk0fw1UmZC9bSM3XJlbvXNP2D5NWNyrTuWmoOZkO2tfEoOXAtJY5D72G0cC
	lUPZHxgmMjXtYuVxmMLWMfZQFnMT9z24u6docPIQbXImBIYvPAh/P6ZhdJDeB5Y1KEMDCASXzcr
	yAAXFhqdPyvXXGrXot94hN90SUP51BBcEe1/AUYH/iMzqqBp033dv5X6ZMp/cA==
X-Received: by 2002:a05:6402:3805:b0:6a1:1bea:8ea0 with SMTP id
 4fb4d7f45d1cf-6a42f0f7634mr31264358a12.3.1787567103269; Mon, 24 Aug 2026
 03:25:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260824091040.155481-1-vladimir.riabchun@virtuozzo.com> <95d27da3-8fa1-44c0-bba7-b6e0adc77d7f@virtuozzo.com>
In-Reply-To: <95d27da3-8fa1-44c0-bba7-b6e0adc77d7f@virtuozzo.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 24 Aug 2026 12:24:51 +0200
X-Gm-Features: AcwNN1Xs_qLBBhNAVxziekZSTd1UtG9oWXxBqKNYPBFx3OcWCY-VBlVvhitmZks
Message-ID: <CAOQ4uxgVb48iYiHgiq+gH2CoAunjJtOE2i0TvTtGmeuUiMmgAw@mail.gmail.com>
Subject: Re: [PATCH] ovl: Fix NULL dereference in ovl_get_index_name_fh
To: Vladimir Riabchun <vladimir.riabchun@virtuozzo.com>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, wangzhaolong1@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2026 at 11:22=E2=80=AFAM Vladimir Riabchun
<vladimir.riabchun@virtuozzo.com> wrote:
>
>
>
> On 8/24/26 11:10, Vladimir Riabchun wrote:
> > We observed several crashes in overlayfs with the following trace:
> > [ 2300.870181] BUG: kernel NULL pointer dereference, address: 000000000=
0000005
> > [ 2300.871537] #PF: supervisor read access in kernel mode
> > [ 2300.872577] #PF: error_code(0x0000) - not-present page
> > [ 2300.873595] PGD 800000010a18f067 P4D 800000010a18f067 PUD 10730c067 =
PMD 0
> > [ 2300.874900] Oops: Oops: 0000 [#1] SMP PTI
> > [ 2300.875742] CPU: 1 UID: 0 PID: 5419 Comm: criu ve: 0 Kdump: loaded N=
ot tainted 6.12.0-211.39.1.16.6.vz10.x86_64 #1 16.6 PREEMPT(voluntary)
> > [ 2300.878057] Hardware name: Acronis OpenStack Compute/Virtuozzo, BIOS=
 1.16.1-1.vz9.2 04/01/2014
> > [ 2300.879684] RIP: 0010:ovl_get_index_name_fh+0x18/0x70 [overlay]
> > [ 2300.880859] Code: 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90=
 90 66 0f 1f 00 0f 1f 44 00 00 41 54 49 89 f4 be c0 0d 00 00 55 53 48 89 fb=
 <0f> b6 7f 05 48 01 ff e8 bc 42 2f ea 48 85 c0 74 33 0f b6 53 05 48
> > [ 2300.884128] RSP: 0018:ffffd32582e0f7c0 EFLAGS: 00010246
> > [ 2300.885153] RAX: 0000000000000010 RBX: 0000000000000000 RCX: ffff8ba=
4497480a8
> > [ 2300.886480] RDX: ffff8ba45535dc00 RSI: 0000000000000dc0 RDI: 0000000=
000000000
> > [ 2300.887824] RBP: ffff8ba68f9daa80 R08: ffff8ba4497480a8 R09: 0000000=
00000030e
> > [ 2300.889139] R10: 0000000000000000 R11: ffff8ba44862d6d0 R12: ffffd32=
582e0f800
> > [ 2300.890498] R13: 0000000000000000 R14: ffff8ba497cb0110 R15: ffff8ba=
517548cc0
> > [ 2300.891838] FS:  00007f5a2f492880(0000) GS:ffff8bab9fc80000(0000) kn=
lGS:0000000000000000
> > [ 2300.893376] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ 2300.894476] CR2: 0000000000000005 CR3: 000000033403a005 CR4: 0000000=
0003726f0
> > [ 2300.895807] Call Trace:
> > [ 2300.896397]  <TASK>
> > [ 2300.896938]  ? show_trace_log_lvl+0x1b0/0x2f0
> > [ 2300.897854]  ? show_trace_log_lvl+0x1b0/0x2f0
> > [ 2300.898748]  ? ovl_create_index+0x82/0x260 [overlay]
> > [ 2300.899766]  ? __die_body.cold+0x8/0x12
> > [ 2300.900582]  ? page_fault_oops+0x148/0x160
> > [ 2300.901562]  ? exc_page_fault+0x7f/0x150
> > [ 2300.902406]  ? asm_exc_page_fault+0x26/0x30
> > [ 2300.903298]  ? ovl_get_index_name_fh+0x18/0x70 [overlay]
> > [ 2300.904435]  ovl_create_index+0x82/0x260 [overlay]
> > [ 2300.905406]  ovl_copy_up_workdir+0x30a/0x330 [overlay]
> > [ 2300.906427]  ovl_do_copy_up+0x10d/0x2e0 [overlay]
> > [ 2300.907387]  ovl_copy_up_one+0x456/0x720 [overlay]
> > [ 2300.908376]  ? xa_load+0x7b/0xb0
> > [ 2300.909090]  ? _raw_spin_unlock+0xe/0x30
> > [ 2300.909913]  ? list_lru_add+0x11b/0x160
> > [ 2300.910736]  ovl_copy_up_flags+0x81/0x110 [overlay]
> > [ 2300.911740]  ovl_create_object+0x51/0x130 [overlay]
> > [ 2300.912719]  vfs_mkdir+0x194/0x250
> > [ 2300.913470]  do_mkdirat+0x14c/0x180
> > [ 2300.914223]  __x64_sys_mkdir+0x46/0x70
> > [ 2300.915019]  do_syscall_64+0x7d/0x160
> > [ 2300.915798]  ? do_sys_openat2+0x9c/0xe0
> > [ 2300.916672]  ? syscall_exit_work+0xf3/0x120
> > [ 2300.917540]  ? syscall_exit_to_user_mode+0x32/0x190
> > [ 2300.918518]  ? do_syscall_64+0x89/0x160
> > [ 2300.919316]  ? syscall_exit_work+0xf3/0x120
> > [ 2300.920181]  ? syscall_exit_to_user_mode+0x32/0x190
> > [ 2300.921173]  ? do_syscall_64+0x89/0x160
> > [ 2300.921991]  ? exc_page_fault+0x7f/0x150
> > [ 2300.922814]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > [ 2300.923823] RIP: 0033:0x7f5a2f8de3eb
>
> Seems to be the same case as in
> https://lore.kernel.org/all/20250429001308.370040-1-wangzhaolong1@huawei.=
com/#t
> Please, take a look at it as well.

Thanks for finding this partial dup.
Miklos' comments partly apply to the fixes in fs/overlayfs/copy_up.c
Those seem to be moot when passing 0 size to ovl_*setxattr().

> >
> > It seems that after commit 5b02bfc1e7e3 ("ovl: do not encode lower fh
> > with upper sb_writers held") fh may be NULL and it is dereferenced
> > without check in ovl_get_index_name_fh.
> > In our case NULL value came from !capable(CAP_DAC_READ_SEARCH)
> > in ovl_can_decode_fh.

The index feature should not be enabled if the mounter does not pass
the ovl_can_decode_fh() permission check in ovl_make_workdir() and
ovl_copy_up_one() should be called with mounter creds, so what is
really happening in your splat?
Why did !capable(CAP_DAC_READ_SEARCH) fail?
Do we have a bug upstream? a bug in 6.12 LTS or a bug in vz kernel?
Please explain.

> >
> > Fix this by checking fh before using its fields,
> > if fh is NULL - use buf =3D NULL and len =3D 0.
> > For ovl_get_index_name_fh use empty string with length 1 so
> > the following bin2hex and kfree(name.name) are fine.

That's no good.
The index has to be a valid fh name
An empty index name makes no sense that's why those helpers
are gated with the index feature which pre-checks the can_decode
condition on mount.

Thanks,
Amir.

> >
> > Fixes: 5b02bfc1e7e3 ("ovl: do not encode lower fh with upper sb_writers=
 held")
> > Signed-off-by: Vladimir Riabchun <vladimir.riabchun@virtuozzo.com>
> > ---
> > There is one more place where I can see the possibility of this problem=
:
> > ovl_get_indexdir calls ovl_get_origin_fh which can return NULL, fh is
> > then passed to ovl_verify_origin_fh -> ovl_verify_set_fh -> ovl_verify_=
fh,
> > which doesn't check fh for NULL and dereferences it.
> >
> > I'm not very familiar with the code, so I'd like to hear what should be
> > returned there in !fh case (my guess - return 0 if ofh is NULL as well
> > and -SOME_ERROR otherwise).
> >
> >   fs/overlayfs/copy_up.c | 5 +++--
> >   fs/overlayfs/namei.c   | 6 ++++--
> >   2 files changed, 7 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index 4388004a319d..63a783473b60 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -492,7 +492,7 @@ int ovl_set_origin_fh(struct ovl_fs *ofs, const str=
uct ovl_fh *fh,
> >       /*
> >        * Do not fail when upper doesn't support xattrs.
> >        */
> > -     err =3D ovl_check_setxattr(ofs, upper, OVL_XATTR_ORIGIN, fh->buf,
> > +     err =3D ovl_check_setxattr(ofs, upper, OVL_XATTR_ORIGIN, fh ? fh-=
>buf : NULL,
> >                                fh ? fh->fb.len : 0, 0);
> >
> >       /* Ignore -EPERM from setting "user.*" on symlink/special */
> > @@ -510,7 +510,8 @@ static int ovl_set_upper_fh(struct ovl_fs *ofs, str=
uct dentry *upper,
> >       if (IS_ERR(fh))
> >               return PTR_ERR(fh);
> >
> > -     err =3D ovl_setxattr(ofs, index, OVL_XATTR_UPPER, fh->buf, fh->fb=
.len);
> > +     err =3D ovl_setxattr(ofs, index, OVL_XATTR_UPPER,
> > +             fh ? fh->buf : NULL, fh ? fh->fb.len : 0);
> >
> >       kfree(fh);
> >       return err;
> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > index efa2a072aa69..81607a24589f 100644
> > --- a/fs/overlayfs/namei.c
> > +++ b/fs/overlayfs/namei.c
> > @@ -721,12 +721,14 @@ int ovl_verify_index(struct ovl_fs *ofs, struct d=
entry *index)
> >   int ovl_get_index_name_fh(const struct ovl_fh *fh, struct qstr *name)
> >   {
> >       char *n, *s;
> > +     size_t len =3D fh ? fh->fb.len : 1;
> > +     const char *buf =3D fh ? fh->buf : (const u8 *)"";
> >
> > -     n =3D kcalloc(fh->fb.len, 2, GFP_KERNEL);
> > +     n =3D kcalloc(len, 2, GFP_KERNEL);
> >       if (!n)
> >               return -ENOMEM;
> >
> > -     s  =3D bin2hex(n, fh->buf, fh->fb.len);
> > +     s  =3D bin2hex(n, buf, len);
> >       *name =3D (struct qstr) QSTR_INIT(n, s - n);
> >
> >       return 0;
>
> --
> Best regards, Riabchun Vladimir
> Linux Kernel Developer, Virtuozzo
>
