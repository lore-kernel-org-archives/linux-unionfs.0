Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40773603D5
	for <linux-unionfs@vger.kernel.org>; Sat, 12 Sep 2026 16:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231967; cv=pass; b=PkjCNERVDKO8bTcCu01eG6qh9uE7IcwzYmE0iFioBJTBpxHyBQJTCqeMw1uvLoltOjWchH4dEMHuINYhS8nnlVOO0GDRgkvduzAXPYjS7WaiUCwhTBai8v23H2YAbwc5dWCxgD4y1gWHUMeZFPfw5SEZdHxKL8swLdETBfJkeAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231967; c=relaxed/simple;
	bh=Mn3bV2YTV3fY3wgcVkjvDuSV16K+mD+3WN4ZrWA9Sio=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YkLxinjJGBmden8FqO7g6bblfIA1WNmS2CtT8wxFm0v9Nc0z615Ly0GqfKPMhwjItytvi5UsmOjJJtB1LWaYmNQvjpkHLUDFAJE7ecT9p7sXZ3HKM281uATODZkpTgpT5FBHoH3Bla9IC4gaj7K3b4ibs3dUfaeMSD++cWp48S8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EmG0vUHZ; arc=pass smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EmG0vUHZ"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c2946dc8dbfso276925966b.0
        for <linux-unionfs@vger.kernel.org>; Sat, 12 Sep 2026 09:52:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789231962; cv=none;
        d=google.com; s=arc-20260327;
        b=lsvDdy6l3ejLkAnFrwn3m2/XyDaGb3AnrG93b2IcCsYzRhJQcvlP6e01xMcvf0+iHv
         QQCZoI6K/9BTttdkjZcY+OzMAG66Y8XqgQDV49+SOlf4qYGgBaGmAVIJht3aFHQ0Hffp
         YrL/5IaJCYF+0QR+nDnb2dPhwCUpN3Y7bJSiKlg7dTowPtDMLH85k1VKEkxhgF3Qhc76
         Kkk/Ex7v1x+uyx5zULgO1AE4km3QcoZLTPxP3TJ3wNZSRd4eOtFJFNa2/T+3IQlMYNEJ
         Nb2UVjLVuPh8qT+2NA6yX+6E0KobvFrbAffAasfr7Bm+gAnfO40cOjgRHTe38cVZ2DiV
         HufA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WYjmIdJ8LduD7wlvhhTNqhhpsCJcLpX0vY1PJ++UAE8=;
        fh=Q5P8IAz5An+xHXmWVQTk48A6FAbqABHGFJzxdFx7HjU=;
        b=CGCIn/IoXBt+O8kW27FE+lACvqXr8QHqeofQbhT2u9jxR/eueWkCOcW3tN7nizjK06
         85jSVszGjZHtRGPySIPwaYPDLx6ciVOwj1mRXCk2dIzI5/zxl3Npv6NitY+ziOfobBIN
         IsHFpGfw8U6FzpmZ+d/B6vSafY+/qIvHyXZdisJKrr6n7iI3E9LwW1CzJgv6NU4b7JZ+
         5A/7DSvBqV2FNDoP2vqt0NckPR0OCNkG+04dPI3B4VI990NuFtuF36/TDwx2WctgEyUo
         daG9xmAOS7j5HVgG7BYtae4Wh/o2+PCpqaHgVYmW570uVd1LO4TTfZRw3DtxtyoRFI+U
         v4GA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789231962; x=1789836762; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WYjmIdJ8LduD7wlvhhTNqhhpsCJcLpX0vY1PJ++UAE8=;
        b=EmG0vUHZvJfJpze8V/5BkRsKaw65yDjBt+jX5Iq2HmvrH5zUU68EYRFX77M1iZoDhj
         5bUrg8J9dkDuOdjANk2PTGfoPPID364czNO+AtbT3oDD1ADY/VjrOehPrc1YogSVbxCC
         h5qyE6kJLFR78EkTkek5wU2Slo7w6A9J39NpXlCpgGCYNDBs4iKujM0Kb4G1CyiweTQj
         0+9URfOSECOYH2UxyVyI5UHb9UgnNPBzD904r0vbLpoCBQvtzTOfNs7pyMLQZN5sM2+1
         0/H3vm25RwUGJutcDRuwWgdYrToivjholjuY2uZAagxXTgjSJcTZsIO4W9W+buWBB5k9
         oCMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789231962; x=1789836762;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WYjmIdJ8LduD7wlvhhTNqhhpsCJcLpX0vY1PJ++UAE8=;
        b=Or9gM+TqOY4qdzDbjEM3oSNBwdaw1m46LxWJasi89Yt3fjymVtka3wJgFF2BrvKqMB
         3cJscmkB7ym0XOi7Q8t90hxahCZ2SOeUfNOEBEHWHs+3/WVL4yn7Rz/m25JfBAad3GTc
         BoSIcHlZ+MQ3wGfHcb1CN3YWSJcGc/D1ki9dXB+EC+vZ/GopQZ1K6ER+dQbKTW0R9rnS
         bAHYKj9O/ExQyu47aUy5b9X11X5nYZYJB4U+tgosso16dy1zhcg706OPQ9+hXF3toh6t
         Vpq8wGT9tHzB10RyyLRvb3EaTFPxQZ4Yuif+zp3CLACEQEq4WLOayyT/kT4r9IDIc2EH
         AGDg==
X-Forwarded-Encrypted: i=1; AKwUvBwESr95ugORVe997poZ1d3NvT/Y7YJ3vt69aGN8owTooy5aBOOvUv5AfsXuLnk8dZij3TIuNuDK2puFe+XM@vger.kernel.org
X-Gm-Message-State: AFuF++m+MjGVyen6dm9tSRMwfS60LB5K92ufLj5xV37tXzRslDK1hayW
	yr8eZVAtdenADM8s5HIhG4B+4WLA+SvjFMtwofsfkNV58iwEkNf8FlSgbPF2Vu6IYKlBTfRxESQ
	3f9llppcEFbodlziAUs/+vrNLLj+Ezg5Xxsz4UmU=
X-Gm-Gg: AYBFou0l0T39alrDNzxhekYt+cj6GaYk1BlhF4cBvt3dVyQNlQFCouAz7qWYwyuJ/Wi
	hZ+gMXZuyc8DTAqrdxH+KXf5p/WxBFwDKJ7P4+ESPOesko31ql7bfsedwSSgTWnzzWhCOWXyXyI
	lJWDW7yD84NEkE9WKorptcIZ4aBLLY1sU9UigrvFFmXkczWQAhDrgkqDY+oKJczIlFrJ3Cb4NqR
	KiiL9YVZ77fX4SRajB8dyD1N9rs80jQ0CJXeXY/vcYL4yjjq8uHxXtrvYvpnkh5Q1P9xv4+BElR
	RX0MGXkLw15KD8qTyDICmRaBedy0gF2mqoWFUDTT4x9vOvvS3cXeMSWi
X-Received: by 2002:a17:907:6e8e:b0:c29:57c4:cb92 with SMTP id
 a640c23a62f3a-c29661bfe7dmr492375566b.0.1789231961918; Sat, 12 Sep 2026
 09:52:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260911194201.1334086-2-Jeremy.Jean@oss.cyber.gouv.fr>
In-Reply-To: <20260911194201.1334086-2-Jeremy.Jean@oss.cyber.gouv.fr>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 12 Sep 2026 18:52:30 +0200
X-Gm-Features: AcwNN1X2hsG0LWaEdwwmkhExP2hV4_8kmcR6MDl78nbl3JF3NiU0DSwRS2ESr0U
Message-ID: <CAOQ4uxjF4xEFRMqb+Owex8Jx_QzeHyJd5LyN5H_SGvo23kMBHQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: disable index and nfs_export with different lower idmaps
To: =?UTF-8?B?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 11, 2026 at 9:43=E2=80=AFPM J=C3=A9r=C3=A9my Jean
<Jeremy.Jean@oss.cyber.gouv.fr> wrote:
>
> Overlay file handles identify a backing filesystem, but not the lower
> mount used to decode it. If lower layers share a superblock and use
> different idmaps, a file handle can decode through the wrong layer and
> initialize the overlay inode with the wrong owner.
>
> Disable index and nfs_export when this layout is found. Both features
> rely on persistent lower file handles, which cannot distinguish
> same-superblock layers with different idmaps. Without them, OverlayFS
> uses normal path lookup and keeps the layer chosen during lookup.
>
> Fixes: bc70682a497c ("ovl: support idmapped layers")
> Assisted-by: Codex:gpt-5
> Signed-off-by: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>

Hi Jeremy,

Nice catch.
Do you have a reproducer which shows privilege escalation?
Please add test cases to selftests/filesystems/overlayfs/idmapped_mounts.c.

> ---
>  fs/overlayfs/super.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index bd0a3f9039d2..00e1b9fccb4f 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -944,6 +944,22 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, co=
nst uuid_t *uuid)
>         return true;
>  }
>
> +static bool ovl_lower_mnt_idmap_mismatch(struct ovl_fs *ofs,
> +                                        const struct path *path)
> +{
> +       unsigned int i;
> +
> +       for (i =3D 1; i < ofs->numlayer; i++) {
> +               struct vfsmount *mnt =3D ofs->layers[i].mnt;
> +
> +               if (mnt->mnt_sb =3D=3D path->mnt->mnt_sb &&
> +                   mnt_idmap(mnt) !=3D mnt_idmap(path->mnt))
> +                       return true;
> +       }

I don't like introducing this potential quadratic search on all ovl mounts.
I prefer to store a lower_idmap field per ovl_sb, which is set to the idmap
of the first lower layer which is found to have this ovl_sb and then
ovl_lower_mnt_idmap_mismatch() only needs to match it.

> +
> +       return false;
> +}
> +
>  /* Get a unique fsid for the layer */
>  static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
>  {
> @@ -956,8 +972,16 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const st=
ruct path *path)
>         bool warn =3D false;
>
>         for (i =3D 0; i < ofs->numfs; i++) {
> -               if (ofs->fs[i].sb =3D=3D sb)
> +               if (ofs->fs[i].sb =3D=3D sb) {
> +                       if ((ofs->config.index || ofs->config.nfs_export)=
 &&
> +                           ovl_lower_mnt_idmap_mismatch(ofs, path)) {
> +                               ofs->config.index =3D false;
> +                               ofs->config.nfs_export =3D false;
> +                               pr_warn("different idmaps in same lower f=
s '%pd2', falling back to index=3Doff,nfs_export=3Doff.\n",
> +                                       path->dentry);
> +                       }

I *think* there is no justification to disabling index, only nfs_export.
It matters because some distros enable index by default and not
breaking hardlinks on copy up is not a "feature" it is a correctness issue.

While as you write "both features rely on persistent lower file handles"
I cannot think of any case where index=3Don alone uses decode of
file handles from the wrong layer leads to bypass permission checks on
lower inode -

The index to lower inode is created only on copy up of a lower inode
that has hardlinks.
This copy up is performed on an overlayfs dentry that was composed by
ovl_lookup() through the correct lower layers.
Copy-up reads uid/gid through the lower dentry's layer idmap and writes the=
m
onto the upper/index inode through the upper layer idmap.
After that, overlay ownership comes from the upper, not from lower inode.

It's probably worth adding some test cases to the idmapped_mounts
selftest to cover copy up.

If the same lower inode is visible from different lower layers
with different idmaps I do not consider that overlayfs job to deal with.
Whichever lower inode is copied up first is the metadata that will be copie=
d
to upper inode and to the overlayfs in-core inode.

TBH, I'm not even sure if there is a legit case for overlayfs mount
of lower layers with same sb and mismatching mntid, but there could be.

CC Christian for his thoughts.

Thanks,
Amir.
