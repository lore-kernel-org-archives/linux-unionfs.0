Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9719173;
	Wed,  6 Nov 2024 10:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730889267; cv=none; b=ojNNFFmtSvhflxFXIpN0EeEONdGhLNVb4hCygxHj0UXmhi2xzhLTDhMnE8Payw2iM8MtKNJRL1XkpXC4ArvIwADOOmpWIzbxflImnWYVWPAS73y2Fz3LPl2RogYXGJMJlkSyMPQTys+jguLyzH+JOLkRrse7ilSZkIPT+mrueq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730889267; c=relaxed/simple;
	bh=jLYcTWP7ycbUss0mFpIBYF0D5uo1nsf7Zv3XMVr1lUk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ou4MrfwLc+8YRzvyNmEs38ga0br2aHA2jhvYQbsG5bzu7F1SSPKsuJeiHgP7+vf4qp0MpmSvpB9Gd7x9eOoSVe8woWZvdZBhS9/3AB5tgX43i6gRg8xi3J8xLZBeXS06x1joXUWw4CD6sLXg2Myf7BTf4tK3KSCLf1/EJaI957c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VEe0G69y; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VEe0G69y"
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e0875f1e9edso8235619276.1;
        Wed, 06 Nov 2024 02:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730889265; x=1731494065; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OE3q1GvNioQeiRfUFxz5uhBFdp3vdG704Ksuu9Ul/wI=;
        b=VEe0G69yaSdBm5/mMAHS9YYXVpzpQHi8yQQmVwEYXP8tqC+nMM4kAqK8T9vQO1yWYO
         SSW2MyKOHziDFxx9bJmrflb0x3fSTytfEyfbWDfdcpzMUTU5MbEr0uNCncZGFR6HcV73
         cfo1zLRnsYT7j5k6azC4iRAf0UBPwfFe9TMM9tODVZ8OcA2c/DKexGLUs93f2mBbpd2s
         aKTnFVMl8PjrH6M/xJC7gh8wcP9XzCTmxhFpjYzI8kwj8OMO4BDlk1SiLu4ypj/UVQGL
         aks9woPExawfg0voDnESwNA/KC1vtikJOtNrLRjmw9BZLv+ah5K2oA8S+vtdry02V3kU
         8WIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730889265; x=1731494065;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OE3q1GvNioQeiRfUFxz5uhBFdp3vdG704Ksuu9Ul/wI=;
        b=qtOuhvZCjkq/bSm1PajCfGLTfcIJaNQEys2FCNh/O7tSGV1DzvzB+GSCxCYjrYF588
         Q9zj1MIUzXUbIS+Yc1h4QpQwyn2nLdW6uvIa0bYpRXRLeg2x8jHmcKlDaWKUNX9eXF6H
         JrZaqNRYC1kA/IMDpeXZHHdF94CaccYLe9ath/etdkTn6YvvjRXcdL0TsOU6T0A2Kabr
         6z2JFyOPTQyiDGNmtgMQSOkGV7oeuCMg0wujMsQHanOzJgYBPBT1HTvUHKFZu26LgyL9
         DWp2gwQaV5peiXqtifpXlnNk1nvP/cqQiL4L304AlhrpQlnee+w5IL2PJ9+6NinN3pOP
         A9sg==
X-Forwarded-Encrypted: i=1; AJvYcCUYpxIsR8++uXlk5X8Uy17hA2GnjJJlhD4AHLTStzSzee8ReC8Sa8WC3K+0aB65HK9xplZ5inPKM/dqXYUv@vger.kernel.org
X-Gm-Message-State: AOJu0YyptvGfTQ22Lh1F1AHi2yjZjWFEjfdTiH+HlQYhrDj4de6qW7up
	h62+yvD9oLKx5IVE7hn7Qlg2oMKlzWM+TijKZqak6Cun124FBj+gFypFYkQb8zjtERPeo7QLxuu
	xU50guvJDI9S/hpnkeMB0pEH0t6E=
X-Google-Smtp-Source: AGHT+IFIuZlBTzsY7QmQZ8OFkr+/SPnJUWs77uPzNNbCoTJyFakWzCJEzuPSW2ghUAyzTa0SVhaoaIaYZ2cUEHa1lOk=
X-Received: by 2002:a05:690c:3584:b0:6ea:84e9:15fb with SMTP id
 00721157ae682-6ea84e91ae7mr124782297b3.24.1730889264870; Wed, 06 Nov 2024
 02:34:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOQ4uxi-G3u0fXDdD4a_5p_HAFSh7oJ5C0w5RZeDh=jM353qvg@mail.gmail.com>
 <tencent_73EE0DCC923DDDAB5DD8995C4F958DE92507@qq.com>
In-Reply-To: <tencent_73EE0DCC923DDDAB5DD8995C4F958DE92507@qq.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 6 Nov 2024 11:34:13 +0100
Message-ID: <CAOQ4uxgU0fdEtksACCmvrUEU+hhsBJqK+HSVEhW9vqcvAakCrA@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] WARNING in ovl_encode_real_fh
To: Edward Adam Davis <eadavis@qq.com>
Cc: linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzbot+ec07f6f5ce62b858579f@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 6, 2024 at 11:18=E2=80=AFAM Edward Adam Davis <eadavis@qq.com> =
wrote:
>
> On Wed, 6 Nov 2024 09:20:24 +0100, Amir Goldstein <amir73il@gmail.com> wr=
ote:
> > On Wed, Nov 6, 2024 at 3:43=E2=80=AFAM Edward Adam Davis <eadavis@qq.co=
m> wrote:
> > >
> > > On Mon, 4 Nov 2024 20:30:41 +0100, Amir Goldstein <amir73il@gmail.com=
> wrote:
> > > > > When the memory is insufficient, the allocation of fh fails, whic=
h causes
> > > > > the failure to obtain the dentry fid, and finally causes the dent=
ry encoding
> > > > > to fail.
> > > > > Retry is used to avoid the failure of fh allocation caused by tem=
porary
> > > > > insufficient memory.
> > > > >
> > > > > #syz test
> > > > >
> > > > > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > > > > index 2ed6ad641a20..1e027a3cf084 100644
> > > > > --- a/fs/overlayfs/copy_up.c
> > > > > +++ b/fs/overlayfs/copy_up.c
> > > > > @@ -423,15 +423,22 @@ struct ovl_fh *ovl_encode_real_fh(struct ov=
l_fs *ofs, struct dentry *real,
> > > > >         int fh_type, dwords;
> > > > >         int buflen =3D MAX_HANDLE_SZ;
> > > > >         uuid_t *uuid =3D &real->d_sb->s_uuid;
> > > > > -       int err;
> > > > > +       int err, rtt =3D 0;
> > > > >
> > > > >         /* Make sure the real fid stays 32bit aligned */
> > > > >         BUILD_BUG_ON(OVL_FH_FID_OFFSET % 4);
> > > > >         BUILD_BUG_ON(MAX_HANDLE_SZ + OVL_FH_FID_OFFSET > 255);
> > > > >
> > > > > +retry:
> > > > >         fh =3D kzalloc(buflen + OVL_FH_FID_OFFSET, GFP_KERNEL);
> > > > > -       if (!fh)
> > > > > +       if (!fh) {
> > > > > +               if (!rtt) {
> > > > > +                       cond_resched();
> > > > > +                       rtt++;
> > > > > +                       goto retry;
> > > > > +               }
> > > > >                 return ERR_PTR(-ENOMEM);
> > > > > +       }
> > > > >
> > > > >         /*
> > > > >          * We encode a non-connectable file handle for non-dir, b=
ecause we
> > > > >
> > > >
> > > > This endless loop is out of the question and anyway, syzbot reporte=
d
> > > > a WARN_ON in line 448:
> > > >             WARN_ON(fh_type =3D=3D FILEID_INVALID))
> > > >
> > > > How does that have to do with memory allocation failure?
> > > > What am I missing?
> > > Look following log, it in https://syzkaller.appspot.com/text?tag=3DCr=
ashLog&x=3D178bf640580000:
> > > [   64.050342][ T5103] FAULT_INJECTION: forcing a failure.
> > > [   64.050342][ T5103] name failslab, interval 1, probability 0, spac=
e 0, times 0
> > > [   64.055933][ T5103] CPU: 0 UID: 0 PID: 5103 Comm: syz-executor195 =
Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
> > > [   64.060023][ T5103] Hardware name: QEMU Standard PC (Q35 + ICH9, 2=
009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> > > [   64.063941][ T5103] Call Trace:
> > > [   64.065199][ T5103]  <TASK>
> > > [   64.066296][ T5103]  dump_stack_lvl+0x241/0x360
> > > [   64.068028][ T5103]  ? __pfx_dump_stack_lvl+0x10/0x10
> > > [   64.069939][ T5103]  ? __pfx__printk+0x10/0x10
> > > [   64.071667][ T5103]  ? __kmalloc_cache_noprof+0x44/0x2c0
> > > [   64.073756][ T5103]  ? __pfx___might_resched+0x10/0x10
> > > [   64.075720][ T5103]  should_fail_ex+0x3b0/0x4e0
> > > [   64.077525][ T5103]  should_failslab+0xac/0x100
> > > [   64.079341][ T5103]  ? ovl_encode_real_fh+0xdf/0x410
> > > [   64.081295][ T5103]  __kmalloc_cache_noprof+0x6c/0x2c0
> > > [   64.083282][ T5103]  ? dput+0x37/0x2b0
> > > [   64.084758][ T5103]  ovl_encode_real_fh+0xdf/0x410
> > > [   64.086578][ T5103]  ? __pfx_ovl_encode_real_fh+0x10/0x10
> > > [   64.088687][ T5103]  ? _raw_spin_unlock+0x28/0x50
> > > [   64.090550][ T5103]  ovl_encode_fh+0x388/0xc20
> > > [   64.092281][ T5103]  exportfs_encode_fh+0x1bd/0x3e0
> > > [   64.094122][ T5103]  ovl_encode_real_fh+0x129/0x410
> > > [   64.095883][ T5103]  ? __pfx_ovl_encode_real_fh+0x10/0x10
> > > [   64.097852][ T5103]  ? bpf_lsm_capable+0x9/0x10
> > > [   64.099620][ T5103]  ? capable+0x89/0xe0
> > > [   64.101064][ T5103]  ovl_copy_up_flags+0x1068/0x46f0
> >
> > I see. it is nested overlayfs, so a memory allocation failure in the lo=
wer
> > overlayfs, causes ovl_encode_fh() to return FILEID_INVALID.
> >
> > > >
> > > > Probably this WARN_ON as well as the one in line 446 should be
> > > > relaxed because it is perfectly possible for fs to return negative =
or
> > > > FILEID_INVALID for encoding a file handle even if fs supports encod=
ing
> > > > file handles.
> > > >
> >
> > As I wrote, the correct fix is to relax the WARN_ON from
> > fh_type =3D=3D FILEID_INVALID and fh_type < 0 conditions because
> > those are valid return values from filesystems.
> Oh, You mean is following diff?

> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 2ed6ad641a20..32890cc0dd4a 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -443,9 +443,7 @@ struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs,=
 struct dentry *real,
>         buflen =3D (dwords << 2);
>
>         err =3D -EIO;
> -       if (WARN_ON(fh_type < 0) ||
> -           WARN_ON(buflen > MAX_HANDLE_SZ) ||
> -           WARN_ON(fh_type =3D=3D FILEID_INVALID))
> +       if (WARN_ON(buflen > MAX_HANDLE_SZ))
>                 goto out_err;
>

No. sorry, what I meant with "relax WARN_ON" was to remove the WARN_ON, so:

       err =3D -EIO;
       if (fh_type < 0 || fh_type =3D=3D FILEID_INVALID ||
           WARN_ON(buflen > MAX_HANDLE_SZ))
                 goto out_err;

Meaning that error should definitely be returned in those cases,
but there is no reason for the assertion which is what syzbot
was complaining about.

Thanks,
Amir.
