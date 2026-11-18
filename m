Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795024824;
	b=2HzCHCmcGMDQHYQ3wC8Yq1AU++G0x+H9vqoD/dgQFnYa8dP0Ts8eg6+XavagOjl1FRc0
	 mwjvYcmq/QcZxlNuEjKxqx10VG9tMfXsRY0/XOe2iI+/95QvyejOc0t0P6b7U/bRvRPPv
	 kkIYXj6H9AwSA9SjOKB7nvcPuWOvCT/pF0ABzTJiJMdDfFCIgHo5YgJDFFCtKxwEKCvDW
	 G88JonJ2030GArEiu0P2rmYafD2NoCe3AkTzkn3qWcpPC1ZpY3B9SsekvcJ4N38S1HqhM
	 TJFo58AQH58gnzIqaZzQXi5cwncZjhn7Hl1pA4ZzUuVHgmpD/YG6TBVj7DpQVcPSnbQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024824;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=u4qdZCxQUja0NlcjEdDck3V1blA80itO4i7W2ltfseg=;
	b=RXUbpQApXG9Rp4rdf5mbzGGuIVUQ3AKKlhR1usCRp1Irl+tKIf5Gk9YznjzLgMY4fVwP
	 2dOUoMc5JOcqi8rIgAMsSb7VssSram0L9BTnQayTp+umo820dwjUL1xiPNllRZsWY5T2J
	 o+ig2ccvl3F/9AbYx7SDOCOhHxWrxzWymsC5wy5p/cKPVU5AIlPvWB5vgauCVH12GFTgT
	 YVmx3V0eflq/yIvFbKXEyVIFNrdiyCzeZkdpKTNmcaZcYPWKg7OFUCKMLgwqadPNaKTZN
	 g/50vET9x3HDPhujtjouYUWM69HxYERtw1f+17nDgJyPJMe8MwvF3VRNPznp0U7g7/Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=K+Mjuum7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA2B606A32F
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 18:00:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DA2B606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=K+Mjuum7
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b87a92c17eso2280943a12.3
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 10:00:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795024823; cv=none;
        d=google.com; s=arc-20260327;
        b=OlsQPAma8G9zwLKn6OoLwXSCdEcyUvsN/kdek/v/iU82QI/f5TArxAEE4hoMqRvoxX
         or+HRAK873tAU/wr6omQhGKcOcLTp2OiAvtu/QYTlLU5bqHtd2kQOLRdMNvZzWA8c7HK
         TtLQ2R32ZnqzOFyPD835R5SY8CCKFMTcHlngMsj4reUwefFnU2HwLjaFknJr7vQnwBNE
         aD6iDO4OiYFbxP/YvpJHHy6H5LHatqdMQ6onf45h3Pc6n4Zw5GOigE33VJZxQT7mLcOS
         WlQwqzoJVM8vsR2CqNw40MagFLB2EFaNcOtnKTgrFWqSmmIRyfBfHycYMHnkNkGRigwb
         r1lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=u4qdZCxQUja0NlcjEdDck3V1blA80itO4i7W2ltfseg=;
        fh=Mi5sSeETGNYaqsm6vb3BYda4ZAXtYZWhLpgCcrchkAw=;
        b=kwEqNDMiwmWLUKpI224Y6OACVfhp0vWETuDIjxgWqBxcyk20tTCuXhYx5bVlT3bFHk
         p4sAl6TLb9NUwMe6qfWSQgTHKE6pUlx0rauW2Y+jvHNvZtHBN9lsUObHZTr4tVBoSUVN
         x0UtWCpuw792b4hwCYERG/P2O1mRsGV1c6txHoAZ2+Zcu6dk0ljElnfGO+JoSw0PAwYf
         t7PINmrEXwl0xINx2clR9IRqwGcDY40FuZi/MJSZP8vKjvJa5SEKh7lW5E/VB7noA1em
         cz4+fqNZn44kkTxvvP4v0RguhpI1NkQITcR0Pc5LyUdUO1Ol8IK78exz6gMI46WxR5hY
         P2EA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795024823; x=1795629623; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=u4qdZCxQUja0NlcjEdDck3V1blA80itO4i7W2ltfseg=;
        b=K+Mjuum7DZlbzQhj44dxy5A6maxZYAyZ29Ulwd8z8W13r5opinN8nQyga6gKKUTIn3
         irv8hTc3j4/gaqyiAXmOT+UTNk6HC+MY7Uf7a9b6WNEm5JkkOxWWEAKop9rvi+cr5sej
         mDDYfE32YCXVoQGoWcdnmed36eW/gsmlzt59+Dy3/XgVziXonW9SrTYu/k8rkGTUf3LD
         8YkjfAu0RpO36JcNXYdFoZwXhxqjZj12t2gRgljQWUSsmQJ05Bx1gGIw0cTe2lfCYBki
         DxIOJYRPP+azMglgRqXMkXmo+hGpR6ZcpcRAi7arTWNZ3zrHbx/75jBgltZUXBNNLpuB
         QlWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795024823; x=1795629623;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u4qdZCxQUja0NlcjEdDck3V1blA80itO4i7W2ltfseg=;
        b=0qdqOLYuz3VG3e3yBFSlFLcO7H4hq+BPq17SnUAAN+zQgKgXBk9djmZdv+MoX76+vr
         LeNWIMo6nTe34Pt2xjSr2G1G8423KPb0ZO7t5uyqxhIA0WVZJMEnYHxSMx/Ib41mdjrc
         nkU0l67DwSy1h5XfAXj9NMZgxGnqri/CQxPQwBDpb9lCL6EOEtDrncjzkBqdIejfkXB0
         y1VylnAuRTYFvgvLaQlsD6RvHajtxHRuJesbCskh3HSS0jDmvEKqC8nEWWYwFvJ0mix2
         m+vd2cNMU9jsd3yEhvLRe6ux29VNcjplDTjCJg3lDsl/1n0/v2/LVDs585Af1gVzDX2l
         p+iA==
X-Forwarded-Encrypted: i=1; AL+hErGdQ8lclHcxnWxbQXKZTxIHNybu48tvsD6AHLkfFxL1MKmDctfJGgsIS+cqJP9SD47BlzbRPGq4/2nKOstx@vger.kernel.org
X-Gm-Message-State: APuU4Z9ueSGGbHCrSKvJ6bMq6OWqrkLHWku1kd5QyMrK5glHeguy6mrS
	EakO7px2BxxkgNfbWi0CnezTWVhay8TWi7d7jdS7oi3UkEuSqKgKnuHuk/ah7Iq1V3LHBd8sAML
	f0mybRJwu1Z2TPKxgY29rEeSt1nWpVpc=
X-Gm-Gg: AYBFou3pfjpVbTJR/USZgf9lpdT9/cqIGGzqAqlQDlODzeoW1oKMUqylpA7NE53KQgi
	4Y23F08/sJn8neJS4SjXcua6Ilk7/UFl9wKAFp5NmxYsPRYJwEk4FafutA/uMSXM3ZY4kP8W7ih
	dRhHNkZCP2UKQ83QMOO4SAYbCrYRxPpX29BbTQ8Q2BajzCZ6FBp5FrH7TT3YRztfPBpXiOED0XY
	FDK3VUsCxDa+mEgRK5lNM600iYZy1fsbFZZxGkw+nuYSRLesFXl0GZWdyi+8jOawAQ99n6F4Jl9
	erdYKo0GA0MZII3FXI3svIr2GYW8eaHfKxmegGgjiMtqD+Flc2lxBSOKtGUGKgU3DNrgtK7d3ZD
	2kPyfmG6GkQJJ9V4U3SxWjjhOMeX8O8TPI7E52Pgws6DQVYhUu6eRoCm1WDks0ciZp0PyyHg=
X-Received: by 2002:a05:6402:1607:b0:6b6:4dcd:967e with SMTP id
 4fb4d7f45d1cf-6b887ebebb8mr2374799a12.20.1795024822234; Wed, 18 Nov 2026
 10:00:22 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261118-b4-ovl-containerized-sync-v7-0-54f45743fe55@toxicpanda.com>
 <20261118-b4-ovl-containerized-sync-v7-2-54f45743fe55@toxicpanda.com>
In-Reply-To: <20261118-b4-ovl-containerized-sync-v7-2-54f45743fe55@toxicpanda.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 18 Nov 2026 19:00:09 +0100
X-Gm-Features: AclHuK_YmUY-cyrn8sPqESOYVBMGy_5scGhTZjCC06dq4P7IzI17kYjTkaWbeHw
Message-ID: <CAOQ4uxhp73OkM9-OUKXeO6Hrq2sV2oYYJ7CCzD=-mXHtRjBxDw@mail.gmail.com>
Subject: Re: [PATCH v7 2/7] ovl: no fsync=relaxed without data integrity
To: Josef Bacik <josef@toxicpanda.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
	Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 6:03=E2=80=AFPM Josef Bacik <josef@toxicpanda.com> =
wrote:
>
> A sync does not wait for a filesystem with SB_I_NO_DATA_INTEGRITY, which =
is
> fuse, so that a server that does not answer cannot block it.
>
> With fsync=3Drelaxed, syncfs() and unmount of the overlay are going to wr=
ite
> the upper inodes one by one and wait for each.  fuse_write_inode() waits
> for the server whatever the sync mode is, so they would wait for the
> server once for every inode.
>
> Do not resolve fsync=3Dauto to fsync=3Drelaxed on such an upper filesyste=
m, and
> fall back to fsync=3Don if fsync=3Drelaxed was asked for.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Ha I very much didn't want to include FUSE in this exclusive club
This was an oversight on my part.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  Documentation/filesystems/overlayfs.rst |  4 ++++
>  fs/overlayfs/super.c                    | 13 ++++++++++++-
>  2 files changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
> index 1a59500834a1..8a007fbc5257 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -870,6 +870,10 @@ The default is "fsync=3Don" instead of "fsync=3Dauto=
" with the module option
>  "fsync_auto=3DN" or with the kernel config option
>  CONFIG_OVERLAY_FS_FSYNC_AUTO=3Dn.
>
> +An upper filesystem that cannot guarantee data persistence on sync (fuse=
)
> +does not get "fsync=3Drelaxed".  "fsync=3Dauto" means "fsync=3Don" there=
, and
> +"fsync=3Drelaxed" falls back to it.
> +
>  If the upper filesystem has no writeback (e.g. tmpfs), a non-default mod=
e
>  falls back to "fsync=3Doff".
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 5960974c5af2..31a58e28968c 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -765,7 +765,8 @@ static int ovl_make_workdir(struct super_block *sb, s=
truct ovl_fs *ofs,
>
>         /* fsync=3Dauto that is not resolved to fsync=3Drelaxed means fsy=
nc=3Don */
>         if (ofs->config.fsync_mode =3D=3D OVL_FSYNC_AUTO && rename_whiteo=
ut &&
> -           mnt->mnt_sb->s_bdi !=3D &noop_backing_dev_info)
> +           mnt->mnt_sb->s_bdi !=3D &noop_backing_dev_info &&
> +           !(mnt->mnt_sb->s_iflags & SB_I_NO_DATA_INTEGRITY))
>                 ofs->config.fsync_mode =3D OVL_FSYNC_RELAXED;
>
>         /*
> @@ -1499,6 +1500,16 @@ static int ovl_fill_super_creds(struct fs_context =
*fc, struct super_block *sb)
>                         ofs->config.fsync_mode =3D OVL_FSYNC_OFF;
>                 }
>
> +               /*
> +                * A sync does not wait for such an upper fs, whose serve=
r may
> +                * not answer.  A relaxed overlay waits for each upper in=
ode.
> +                */
> +               if ((upper_sb->s_iflags & SB_I_NO_DATA_INTEGRITY) &&
> +                   ofs->config.fsync_mode =3D=3D OVL_FSYNC_RELAXED) {
> +                       pr_warn("upper fs does not guarantee data integri=
ty, falling back to fsync=3Don.\n");
> +                       ofs->config.fsync_mode =3D OVL_FSYNC_ON;
> +               }
> +
>                 if (!ovl_should_sync(ofs)) {
>                         ofs->errseq =3D errseq_sample(&upper_sb->s_wb_err=
);
>                         if (errseq_check(&upper_sb->s_wb_err, ofs->errseq=
)) {
>
> --
> 2.55.0
>
