Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6C31D8DE1;
	Wed,  6 Nov 2024 08:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730881238; cv=none; b=nRTst1xVJlPNnilCE2taWcMOdQeCtM+HGkw0UBY/NstukUVXp7CLLXGBuEB+Y/yAUwSc5UVORl3HDFpkYQi+xvLlIS8+1B8QUL5vY9cJVczlI6CCAuHSbWJLs+xab1DBTqfemhn3kEssta4qqe/PbPvJvuG6MzZH96Apg3ixzSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730881238; c=relaxed/simple;
	bh=G68askeglz0Zycs/ZtvuBkulP5B1kE34vWfd5VV4eaI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aqVxAQV8gDUFfptzrZOATW2xQw235AlFAoy/KzoBOVpy3jrBR5zUwMZJB280UvwVFjeJzeZUjNMpm1ZH5t5d8+lFKtiQCzfwCtGhSlXAUuvMdx7oVylI5i5sx8v+txSPCfV5nQyW2nCsCpy4REVkKexHDINxn03oso/OG6eQhA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NXUX+5Yl; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NXUX+5Yl"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6cbce8d830dso41937896d6.1;
        Wed, 06 Nov 2024 00:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730881235; x=1731486035; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9liWDNx4iphIAePTwPX4+XTvgFUOWAVBEnwX8vIu5vo=;
        b=NXUX+5YlbyFvWICynm7XRGbB2jvQBiL2z+LZ5OOz0gT7R6LjBL1B83DnD5YzhDD4CW
         TP5qUqsi5TkuCU1lfCX7HHc4kPI6uPj0au6nZfp/evn6x4HiuME/mDSAcipYwnVxj9MO
         dhEz7OslBbsV4pmtmwLJ86u3aKoUBqDmN1lZGI5jmpx591KGgX47qxMVRnswjafjQIsd
         wLPwT/BvZoIawcVQs6i9h/01yEL9C5Wcdh+8D4Kop7M+23i0b8cdQdJTNo++a+m1/c3D
         vOxygm6qnYzvPKsoxI9+pVzq/zZ1T6eJerZJb5ENWaGzBXuVv66QX/DSwX9j0yYyIz7J
         rDCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730881235; x=1731486035;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9liWDNx4iphIAePTwPX4+XTvgFUOWAVBEnwX8vIu5vo=;
        b=l4dtklIsStN3DAq9ID1PaRKgpiHaVmEM1+8n2j4iIu7Edu7HNu68ggd8/LtFkgsCK/
         Jl3+7m2GcWvXszzdx7vdVMfqXNS0O5tWmql6V9s6lfKnO7/aTsXl5YkqfM+vrwpbgpLw
         1DehA9+8sBjP2sh1s9FYEhpt2ANlANYlv+/L6tzYzVmLDKFkCu+NM9MW+U34MyRCXNd3
         YCcEQrn6VTKzJcvuO2/uVF+q3s8yejMaxUaQj+dhPpU6QpLWKWRubZkAEdM+xsqSKrUs
         r2Fe3b+qcoo8a2IsQznF56lyJao7dC2hfXBdLNAhBp8uDYeE24k7UM3iO2MurI3YR669
         /7Iw==
X-Forwarded-Encrypted: i=1; AJvYcCX053i24nKtfTh+FEsh37uo6uKLqoLVBP8dVWeYO858Y30gtPLgGtdfiTFaIu+ZWY7i43KEMLcgw57OKCdJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5AwW/fcR6PqEhQezAN7EPNJed23Kx4HXi99880phZZOkKOjMc
	DaPn50pGk5RIbBAE+9AJQ83nDqH5z5E9AyAIxCzSn9F86y9SDWJaLN2zalxIrmso1y/99CM7LdQ
	jrLKkiWErF9HpM6QZc5YnP+Toibg=
X-Google-Smtp-Source: AGHT+IGPQp/P6EbblcA1XsCvVA7c6e1OroBMyYoa1OCNRugD2V0+QX4orBfHxTKkeRKPbOoUwqRYvHYBCok2SXeNnEs=
X-Received: by 2002:a05:6214:3c8b:b0:6ce:3cfb:d158 with SMTP id
 6a1803df08f44-6d35c14e8bfmr268227306d6.26.1730881235243; Wed, 06 Nov 2024
 00:20:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOQ4uxi36iUbYa27c81pNpO7T0vR=rY63b7KACJLP6b4HTJGXQ@mail.gmail.com>
 <tencent_08A4E8A2ED86CE7C793E6CC02FBD6FF0960A@qq.com>
In-Reply-To: <tencent_08A4E8A2ED86CE7C793E6CC02FBD6FF0960A@qq.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 6 Nov 2024 09:20:24 +0100
Message-ID: <CAOQ4uxi-G3u0fXDdD4a_5p_HAFSh7oJ5C0w5RZeDh=jM353qvg@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] WARNING in ovl_encode_real_fh
To: Edward Adam Davis <eadavis@qq.com>
Cc: linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzbot+ec07f6f5ce62b858579f@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 6, 2024 at 3:43=E2=80=AFAM Edward Adam Davis <eadavis@qq.com> w=
rote:
>
> On Mon, 4 Nov 2024 20:30:41 +0100, Amir Goldstein <amir73il@gmail.com> wr=
ote:
> > > When the memory is insufficient, the allocation of fh fails, which ca=
uses
> > > the failure to obtain the dentry fid, and finally causes the dentry e=
ncoding
> > > to fail.
> > > Retry is used to avoid the failure of fh allocation caused by tempora=
ry
> > > insufficient memory.
> > >
> > > #syz test
> > >
> > > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > > index 2ed6ad641a20..1e027a3cf084 100644
> > > --- a/fs/overlayfs/copy_up.c
> > > +++ b/fs/overlayfs/copy_up.c
> > > @@ -423,15 +423,22 @@ struct ovl_fh *ovl_encode_real_fh(struct ovl_fs=
 *ofs, struct dentry *real,
> > >         int fh_type, dwords;
> > >         int buflen =3D MAX_HANDLE_SZ;
> > >         uuid_t *uuid =3D &real->d_sb->s_uuid;
> > > -       int err;
> > > +       int err, rtt =3D 0;
> > >
> > >         /* Make sure the real fid stays 32bit aligned */
> > >         BUILD_BUG_ON(OVL_FH_FID_OFFSET % 4);
> > >         BUILD_BUG_ON(MAX_HANDLE_SZ + OVL_FH_FID_OFFSET > 255);
> > >
> > > +retry:
> > >         fh =3D kzalloc(buflen + OVL_FH_FID_OFFSET, GFP_KERNEL);
> > > -       if (!fh)
> > > +       if (!fh) {
> > > +               if (!rtt) {
> > > +                       cond_resched();
> > > +                       rtt++;
> > > +                       goto retry;
> > > +               }
> > >                 return ERR_PTR(-ENOMEM);
> > > +       }
> > >
> > >         /*
> > >          * We encode a non-connectable file handle for non-dir, becau=
se we
> > >
> >
> > This endless loop is out of the question and anyway, syzbot reported
> > a WARN_ON in line 448:
> >             WARN_ON(fh_type =3D=3D FILEID_INVALID))
> >
> > How does that have to do with memory allocation failure?
> > What am I missing?
> Look following log, it in https://syzkaller.appspot.com/text?tag=3DCrashL=
og&x=3D178bf640580000:
> [   64.050342][ T5103] FAULT_INJECTION: forcing a failure.
> [   64.050342][ T5103] name failslab, interval 1, probability 0, space 0,=
 times 0
> [   64.055933][ T5103] CPU: 0 UID: 0 PID: 5103 Comm: syz-executor195 Not =
tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
> [   64.060023][ T5103] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009)=
, BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> [   64.063941][ T5103] Call Trace:
> [   64.065199][ T5103]  <TASK>
> [   64.066296][ T5103]  dump_stack_lvl+0x241/0x360
> [   64.068028][ T5103]  ? __pfx_dump_stack_lvl+0x10/0x10
> [   64.069939][ T5103]  ? __pfx__printk+0x10/0x10
> [   64.071667][ T5103]  ? __kmalloc_cache_noprof+0x44/0x2c0
> [   64.073756][ T5103]  ? __pfx___might_resched+0x10/0x10
> [   64.075720][ T5103]  should_fail_ex+0x3b0/0x4e0
> [   64.077525][ T5103]  should_failslab+0xac/0x100
> [   64.079341][ T5103]  ? ovl_encode_real_fh+0xdf/0x410
> [   64.081295][ T5103]  __kmalloc_cache_noprof+0x6c/0x2c0
> [   64.083282][ T5103]  ? dput+0x37/0x2b0
> [   64.084758][ T5103]  ovl_encode_real_fh+0xdf/0x410
> [   64.086578][ T5103]  ? __pfx_ovl_encode_real_fh+0x10/0x10
> [   64.088687][ T5103]  ? _raw_spin_unlock+0x28/0x50
> [   64.090550][ T5103]  ovl_encode_fh+0x388/0xc20
> [   64.092281][ T5103]  exportfs_encode_fh+0x1bd/0x3e0
> [   64.094122][ T5103]  ovl_encode_real_fh+0x129/0x410
> [   64.095883][ T5103]  ? __pfx_ovl_encode_real_fh+0x10/0x10
> [   64.097852][ T5103]  ? bpf_lsm_capable+0x9/0x10
> [   64.099620][ T5103]  ? capable+0x89/0xe0
> [   64.101064][ T5103]  ovl_copy_up_flags+0x1068/0x46f0

I see. it is nested overlayfs, so a memory allocation failure in the lower
overlayfs, causes ovl_encode_fh() to return FILEID_INVALID.

> >
> > Probably this WARN_ON as well as the one in line 446 should be
> > relaxed because it is perfectly possible for fs to return negative or
> > FILEID_INVALID for encoding a file handle even if fs supports encoding
> > file handles.
> >

As I wrote, the correct fix is to relax the WARN_ON from
fh_type =3D=3D FILEID_INVALID and fh_type < 0 conditions because
those are valid return values from filesystems.

Thanks,
Amir,
