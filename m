Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5EA1CC881;
	Mon,  4 Nov 2024 19:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730748654; cv=none; b=VEgw7NfxW8OWyj30ASKRcgBehvNHoz78752NcXwYLE7Q1xy9CoF2943pwPY0C+3beprpnaOJq7cNAgmvANXT2izzLadxseJ/knQxXCXT3B68wBXWXnTcMNLPeBDOomq4y2ChbFWPzbv6ZelyLh3bqsLgMq3EHqJL8g18t7LH0k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730748654; c=relaxed/simple;
	bh=Fo60uWswFcnSmzVpKdk+u0eNERCEyxQs200F0GCVyJw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uu4beA3iUjLyi2gTi8Ec3l+SndUl0czNugs3Mw4mv9N9/imqSBSXJpGUXsAgbEgeQ87QP8wvkqgKDrm+hO3yUavmQjM4B/zzd3SYHcn499zLlXsycdQ5LFfQW2KuM0UOJaGXlyK+4TEoDKS5oTIvD+9zjKWFgiU2e0RDAW10MHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dCJtqDV9; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dCJtqDV9"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6d36f7cf765so18011976d6.0;
        Mon, 04 Nov 2024 11:30:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730748652; x=1731353452; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aMEsUOUwX1QVPl2y9CeAdxcmUznBmp9LvekDGjDQcDs=;
        b=dCJtqDV9Cg07sG3pGcZ6ye8SN2dcudGYH3XrpTT0sRnZ3+/d5A00sypTXr4g/e5uIv
         SFoZrh8x+PGJliClZEzRV4wO5h9kVqA+WGvDH1rvMJdmMvZQsG+DdWTCDf4w6QAYjfzi
         VSylvJ/gaVJfcW/a9AYJfETOVVCrlW8YWufoSQweykak61OZd2ehS8IW7bx1RjO6x3Hg
         +KrtAbbj1hLNDGR5R4hm0dEStYTvQVzJPYLLL63qWbVec7Al1VMJdXIMEP+8MNn/J7vB
         8r8eZYH4+bEqckzC8Rq4rr6/1hglntkcTpKF2NmH6eCEI6F2mzGhxD+Liym7X2JprAt2
         3AAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730748652; x=1731353452;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aMEsUOUwX1QVPl2y9CeAdxcmUznBmp9LvekDGjDQcDs=;
        b=Mksf75hlWxIwDDDBKLoQs3t1ounu3yRrVscBKmyyvYJLzCXOVusbvDpn2oR4/VwAAy
         A9MWMM3RwxUcrrSyvFrv8zY0izdPYKZ1O5KSQuIPfIwcpAMLElIjdyCwkfj4IZjnq59g
         c3VjJLieQo8HnNiRuGF1wGSWxXX1a5TBY1vlcSFYAoKYVwQCpQ7M77aE7BUq/ZkJjqQs
         +i8ocZE6RGd4Ap3EBjfVWaWVbVySquoTasZ3xLqkE8WDYPQNJv8zcjaopWD5O7XyYCuu
         +i3sWuccVqF4Lm2+AhUwdohpamGTkCJBILpyzzo9wnsv4PyKW92kRM6yn2ub5gS8EqoY
         qFCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSdyvw3RuifpHtdib10P6AUueox/AmzzBmKK6DeH5IIaGIjk2sVeEe4FcBzKWx7VHaiA/1sy0+TJJBtH4=@vger.kernel.org, AJvYcCXNn+H0trzrjvTN/tr0Gz6jL3Hrv0t1Z8I2omIqMudkkTBIs1DjqceJfm0Y2nVYFgTUaxiojMSgLh0ejLj3cA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzVR7R6HSMwcS5G1JZ8SaU93osQ2Q3xa6ozzzBGgMqCNlkpxUBJ
	fq7KY9HURAVwM3HwuGdxyDqHarSDBnkFEtfOTrZaX/jTSuMBl6ORj46hfxUtSox/mzMndy7JcYl
	JrOF+TNlpnuGnxXI9+yB9QJc9VEtEQX1g23M=
X-Google-Smtp-Source: AGHT+IHjDExevzcVEqh6dylFKl0DUThxz+Syms9Ht8lS/L10WWwnnFGLfT+vDD8lmI0PGVk41Nc7fAV/B0Usdgdk97c=
X-Received: by 2002:a05:6214:3bc5:b0:6ce:26d0:c7b4 with SMTP id
 6a1803df08f44-6d35c19bf44mr200872936d6.44.1730748652032; Mon, 04 Nov 2024
 11:30:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <671fd40c.050a0220.4735a.024f.GAE@google.com> <tencent_93E0C66D49BEAEDE6ECA0C9FA7C786D2D206@qq.com>
In-Reply-To: <tencent_93E0C66D49BEAEDE6ECA0C9FA7C786D2D206@qq.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 4 Nov 2024 20:30:41 +0100
Message-ID: <CAOQ4uxi36iUbYa27c81pNpO7T0vR=rY63b7KACJLP6b4HTJGXQ@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] WARNING in ovl_encode_real_fh
To: Edward Adam Davis <eadavis@qq.com>
Cc: syzbot+ec07f6f5ce62b858579f@syzkaller.appspotmail.com, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30, 2024 at 11:32=E2=80=AFAM Edward Adam Davis <eadavis@qq.com>=
 wrote:
>
> When the memory is insufficient, the allocation of fh fails, which causes
> the failure to obtain the dentry fid, and finally causes the dentry encod=
ing
> to fail.
> Retry is used to avoid the failure of fh allocation caused by temporary
> insufficient memory.
>
> #syz test
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 2ed6ad641a20..1e027a3cf084 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -423,15 +423,22 @@ struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *of=
s, struct dentry *real,
>         int fh_type, dwords;
>         int buflen =3D MAX_HANDLE_SZ;
>         uuid_t *uuid =3D &real->d_sb->s_uuid;
> -       int err;
> +       int err, rtt =3D 0;
>
>         /* Make sure the real fid stays 32bit aligned */
>         BUILD_BUG_ON(OVL_FH_FID_OFFSET % 4);
>         BUILD_BUG_ON(MAX_HANDLE_SZ + OVL_FH_FID_OFFSET > 255);
>
> +retry:
>         fh =3D kzalloc(buflen + OVL_FH_FID_OFFSET, GFP_KERNEL);
> -       if (!fh)
> +       if (!fh) {
> +               if (!rtt) {
> +                       cond_resched();
> +                       rtt++;
> +                       goto retry;
> +               }
>                 return ERR_PTR(-ENOMEM);
> +       }
>
>         /*
>          * We encode a non-connectable file handle for non-dir, because w=
e
>

This endless loop is out of the question and anyway, syzbot reported
a WARN_ON in line 448:
            WARN_ON(fh_type =3D=3D FILEID_INVALID))

How does that have to do with memory allocation failure?
What am I missing?

Probably this WARN_ON as well as the one in line 446 should be
relaxed because it is perfectly possible for fs to return negative or
FILEID_INVALID for encoding a file handle even if fs supports encoding
file handles.

Thanks,
Amir.
