Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE8F12B94
	for <linux-unionfs@vger.kernel.org>; Mon, 10 Aug 2026 09:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786353326; cv=pass; b=gFosPMMXEG+dHwLgBaFgH8LUKQ05r5iKAUwNM0edgnRlBPmJKOdn2xUd9WhJa8L1f7+KBTJeJITTdawJRcL2rP4niqMr59mxlO+6aZxI7QlCNA4qcdJR7fJD5fdYF2JxhwNmtFpDO++FvSvufj3Iv2jCtAsgTJmvknpPPQ69Z+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786353326; c=relaxed/simple;
	bh=o5G0Zcy7sHVm1gE0JnQBefYO/WTPXUEBfTEx9SCAFkA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pQ5MLZVrz8+OA3tznLBObuE6HpwmyfAkxaDrBzUuCznmxvG/WeT/R3oENQVgtgjbhfGBVUk4ft6Yvz+g/ObrXyKfazaNufTw52GkUOqvZkzGqWKxRvzoVK+eFj9yC9xzo7tICCW5wyXwkx/vdcNOcB7zyzj3eDTEmaI4q/e8AOI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FcKQpe6O; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FcKQpe6O"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6a051904222so1753748a12.2
        for <linux-unionfs@vger.kernel.org>; Mon, 10 Aug 2026 02:15:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786353323; cv=none;
        d=google.com; s=arc-20260327;
        b=fYOt/iEG3W2GYyohAxKw42AfPGiWrMXffKI9As2u9IALWfvaJX5mMw3zHlo05Py5r5
         tM62NuGC+StM0F0h8LWCBydnIHkZMp262sdEgHv22HJJgyjInnVFve+G6MRNrcbKsoEf
         7p0mk3mv0BxrLq6phHNwqVp4I/ZRdGNtUMYDZVu6uUnnH0636okdb9LXUICNhZlIfd5V
         z+xGm0dpASiO5wlsmUBIIWwYm4ZacidF63uLLYFFXxgRTtKm5w84XGQ2u3AYc2LdVCKY
         0oc+erxbqlM2PMa4ct/YIwfhJrga4ElvWL6B8M02IXBqJKtzGOXQ07ptJ9e/Ni7Xgbbp
         4nEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LTFByqnQi1kWXDSzDHe+kTNA6IO1jhkvAauO0MSqkJs=;
        fh=HfnMIbS6yrOnwpgJyTPFXj3IBpk6BTqTlRr4JRpX+nQ=;
        b=Q0iL/HVmrYGiFIlWGcmGJ3Y+Bd+bcRdCXgx4ltLx9xoa9Z84ajvs4aR7XuGNFojFc8
         pr/0Lrd/TvM8oW5KwsJ9L68mhPyTuAu0cTIfACjdV/LRe1ZGjRMJO7QHyyI4XqX2vQMG
         U0k7IXirw0bhr05NV/OjJluLalglrFZ1RF4YHsnyBCcPGbGCcrLFvKJsXXSK94sqr2PD
         WGiqT00eCCQlUCdDgkfhcAN9uY1jA6B/r7BFhGbaXCgC4XawTcnyBQKfBVydVl7uJGBD
         QpMhzApELtldQxRioubm3rrNXrmiG8Sr6yewin1oLgq9qXd/dQ8DacRZf6DB1wKId83k
         Dp8w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786353323; x=1786958123; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LTFByqnQi1kWXDSzDHe+kTNA6IO1jhkvAauO0MSqkJs=;
        b=FcKQpe6O1bLjRA0BviknKiE5U7Dqvfu2YL623gUfGXHOwPF0cYOLzP5Xj6SS8M6+o2
         eXPnNUERGG9neQy2nHOqgy3Iyssp631Mb/m8jPl66vL7fM1HICg+NLBqBvPyJjhRtEzZ
         mtP1ji9KldwkULUjQY+wZ9zFCTr1C3fHDmXboPLZl+XhK6MOWZ23EH9tItqMiJppT0tc
         t8U+IOEDLmYmQW6bfiHg+z3+JZ0+HfHyfdH1p6C8eTX2sIbPSWG9Pr2RjPhnTT5nXeeg
         uvOvFHx6OxBSkIJ+tdSTFpXn3qPQnfmL4J8K2Oavva8MAkg/HHs/xCFYc5Z4JEQmOV84
         B02Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786353323; x=1786958123;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LTFByqnQi1kWXDSzDHe+kTNA6IO1jhkvAauO0MSqkJs=;
        b=Kuq36CAepXoFEAVTsBKYAyzWe2VN74OL6J/XZ7kP8s4GISv1zmP1gJxztLOo0KCjr9
         PPf74ykqSgxXXkUGsBa7pkv5XYyYpnMNTYdeT9m3tcVUKHa/ptS12YPN9lxX3wkI9fRP
         WXIyYI8kWxZ1G1lhT+O+Ov9/gnHTbrsUfx014NwchesxIFo5+x902IpOadKL7q4SFdHP
         Zh8LkOpRVmh/h/lKkw79MZeEH1leGmSGH60+yWqvt7xClJjdvI7TnCzY8p1/sB8FyCVv
         s1FCraSbpN00cu/DujN+Eazd6tkk+6veXvfWla8cl7uALzJ9gNKPo/n8yb7/GYg/XDNn
         9d2Q==
X-Forwarded-Encrypted: i=1; AHgh+RoVnXDW9Nu4Puwx+RxufAP1BYpMqM9M3bryQsGzh317Yz5EvPv2t3sgOrNtAIWeBGfv3JvDhHmOVx2uQMG+@vger.kernel.org
X-Gm-Message-State: AOJu0YzflELPZCF6b8T0/jS0YlyyRJ+jpxC2KRIAfHo18+BzdE+uDNMO
	aNJJHi1fzWdI4xRpgz8+B+7OsSAFyCYdRy8ikNDHAqTDVPB7xQcBh/0+xgHBJA4zj4oYOPisXse
	Bw75/xn1Gq4DAtzLsTbtrcin5Ww3hiDD8EuRYXyE=
X-Gm-Gg: AR+sD10666sdriFLmHafsnGXG2ynXNBEClV8qlXmyT0igFdVVK5qzBd+JSOZP/IMrfY
	QTNlzpDZInG7tLpCJZACoeUY3x+rVWgLMlSPrv7VsmAGxU+ea2T2IIet78JFSget5Jbgor2f1uL
	HJcfwGVx3IpdEb3ouOs34fmUqKY8IUX7GrkiwaVoDi0nX5o8mX5Nw9/nCX4OumJluM1wGFDxPvM
	wicNPgF4tKX3uL0uU4AjaD6hxifN9vWR9NT3gwKuAb6tlcgmU0z/AXAPHBKhf3dQE4jr6g5GtrQ
	3HqIz80JqK1igFWDoPj+TiygtTIFHwY4tat7n0dNCsM1GQ==
X-Received: by 2002:a05:6402:28c5:b0:6a1:dbd:bfe with SMTP id
 4fb4d7f45d1cf-6a14f0badf1mr20065456a12.7.1786353323008; Mon, 10 Aug 2026
 02:15:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260807-kasan-v1-1-50da6e58cc20@oss.qualcomm.com>
In-Reply-To: <20260807-kasan-v1-1-50da6e58cc20@oss.qualcomm.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 10 Aug 2026 11:15:11 +0200
X-Gm-Features: AUfX_mxOOOch9AOz5VO1lclI0_03muckuyYM2TPL6OIe9AtqSW91bux7GOIJYEY
Message-ID: <CAOQ4uxjKzqH6g41_Gtx_WWE8y69cUrzg8VVsVhg-4PgkOLxLoA@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix NULL pointer dereference in ovl_i_path_real()
To: Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Miklos Szeredi <mszeredi@redhat.com>, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 7, 2026 at 9:05=E2=80=AFAM Varadarajan Narayanan
<varadarajan.narayanan@oss.qualcomm.com> wrote:
>
> KASAN reported a NULL pointer dereference in ovl_permission() when it
> called mnt_idmap(realpath.mnt):
>
>         BUG: KASAN: null-ptr-deref in ovl_permission+0x150/0x190
>         Read of size 8 at addr 0000000000000018
>
> ovl_i_path_real() can return a path with a valid dentry but a NULL mnt.
> This happens when the inode has an upper dentry, but ovl_upper_mnt()
> returns NULL, for example on an overlay without an upper layer. The calle=
r
> then dereferences realpath.mnt and crashes.

An overlayfs without an upper layer should not have an inode with an
upper dentry.

>
> Also avoid dereferencing lowerpath when it is NULL.
>
> Fix this by checking lowerpath before using it, and by clearing
> path->dentry when no upper mount is available. This makes ovl_i_path_real=
()
> return NULL and lets callers use their existing error handling path.
>
> Call trace:
>          ...
>          __kasan_check_read+0x1c/0x24
>          ovl_permission+0x150/0x190
>          inode_permission+0x7c/0x204
>          may_open+0x84/0x14c
>          path_openat+0xdf0/0xf60
>          do_filp_open+0xbc/0x148
>          do_sys_openat2+0x268/0x2bc
>          do_sys_open+0xd4/0x108
>
> Signed-off-by: Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.=
com>
> ---
>  fs/overlayfs/util.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index b41f4788e4f0..ec423e16cbbd 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -380,10 +380,16 @@ struct inode *ovl_i_path_real(struct inode *inode, =
struct path *path)
>
>         path->dentry =3D ovl_i_dentry_upper(inode);
>         if (!path->dentry) {
> -               path->dentry =3D lowerpath->dentry;
> -               path->mnt =3D lowerpath->layer->mnt;
> +               if (lowerpath) {
> +                       path->dentry =3D lowerpath->dentry;
> +                       path->mnt =3D lowerpath->layer->mnt;
> +               } else {
> +                       path->mnt =3D NULL;
> +               }
>         } else {
>                 path->mnt =3D ovl_upper_mnt(OVL_FS(inode->i_sb));
> +               if (unlikely(!path->mnt))
> +                       path->dentry =3D NULL;
>         }
>
>         return path->dentry ? d_inode_rcu(path->dentry) : NULL;
>

This patch is wrong because it defends against conditions that should
not be possible.

If this is reproducible, then there might be a bug somewhere else that
needs fixing,
use after free or what not.

Thanks,
Amir.
