Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794324526;
	b=M6sz0wYzahGN1BgRvp8Q8K5T2/7jROmp3xs+7eSvSmDokTpo4MEASRLHWuwO1p7X6rCD
	 ArBykeI1ud6CVnrLBJpk9GpEPM8ytH+ireUfjW5zbErjrIso9ar8c1Km3adkKo79hXAer
	 NIxc01v6SPRwl8zQ+klo5nHcfUeC7nl92dBYOy/A6VDltG+DwkFqFBq++gc7s3VfMhKiy
	 xhPDfwv+LfOwy6vqEfFNLMJYmS1wBpEhJh7JrIHJSzBZtYrWzwiAOW5k+fgwDisGieuWf
	 47tCNWbz7c3F34Eyv8gaueG2bNhn8LG6yE9JU6txT86aOIL9AgMWZJlkfMwgwU+Ke+Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794324526;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=N/pL52fuDy805O1oezgAmGq/06s1o7MBJVwaW8uXKM0=;
	b=JR3QbeoVNZliBwWd3QMz9ZH4J8Zobhm4Vy5ZXmk0DojVMnCCcLxeRwkXni+Pqpk/Zq9V
	 uulxQPokpYF/xHX2rdFnGJNcZbz5Pv4CWeT9zOgRwaiASiY52ejAxpdfXx6z0BI2BSN+W
	 MLM+jFvso+fPh9/tJNghS/6EOUJaftsk0jTQpodvop9DVGk/4RL1tTzHQydwkOoIUpUlu
	 zAtFemSGtKiOuH7z6lHIqxvBoSxD01Ch/L3r7FRI4xI6Cc1ngvCGSvPNcaNL0OIJh3SCI
	 eok1HZoJF/p+PGvBfBPPFVxR3EYYpYQt8jfoOHnwYdhuVoizfmi73u+mrTUkkgRss4Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dt4XSpXK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F9060A260D
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 15:28:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8F9060A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dt4XSpXK
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b58cb69927so3399443a12.0
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 07:28:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794324524; cv=none;
        d=google.com; s=arc-20260327;
        b=ovrR7+ePj7pxDVJuMwu4U09Eld1XhjEv7Eiy7wWVJRR/g5eSvMRFRh20RAWLY+5T/0
         Emg9yB/0VKmkIfwxpWQ9vbKGGlajLTDFfaaHvyvUs4nlfjGW7bUMz2OUUPTxEK/zm4n2
         CZX6QvzYlaBjRtXrLXqs9IJZ7es+wmG4qMfrq+m7QUjIr9UCUffXXJxcsL2ryCdDR5jC
         REJZwsyAv8QeBENwf+31VDaDy2GN/i8fxMqVnlOM+q8aLYTDOp3MQIdDYrpOYBIIpLAx
         9CIPyUPoqRRgdwoYXDZX8TiXuGv46Y2LQcx1EdkJ/7V/bNaQ5IZ2rLJre5X7Bwz1iX60
         WLeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=N/pL52fuDy805O1oezgAmGq/06s1o7MBJVwaW8uXKM0=;
        fh=eKLxAHI1kEXJnmASUqXxhMzamyctcHinZN+YGC9B34M=;
        b=D0sGqMdPMiJQ4PEgiLYtRhyriNhdpsdWb0Q1HzreAtzLIfihtgAB3HHEIIkdzt8LCw
         SW8tq0mAVpjGG+PTJE8LaBZ1dvmPrS0l0Eq6kxmic/RMVkM/dGvacWLgeBFm8ESFJiKX
         cCaqsuBw5YCBCiJtuBcKIUFud3BnBJVjIDHOdpJqA+Q3X6T96MTXoMLWdnxkEpe2W1sV
         e3RWM3uN26nMrr5VpkVp84d6jguy8EvtgMI3ACJBuYIuCgp7d4tjGE6TkaWD1EATYcXr
         rHlFUpv/6baC78f7fCET2WfR230/EDuoSwEok4X60Rjjbb3yhbTl/WAOa6Un2zLS2xkJ
         e9yA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794324524; x=1794929324; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=N/pL52fuDy805O1oezgAmGq/06s1o7MBJVwaW8uXKM0=;
        b=dt4XSpXKWEC/lAY8Ij1wOS2+4YRasGVBXJlQicjWv1F3MuF7qz8m85ymapZS/ZE89T
         GUqu0sQFEdRi4ssDsjt3QAm6UnBH6S8gsHQHT5KqpjGRPL7srRrIrD/D3fZjf6ixSj1m
         ojvIQS6znvNR4BQU+3pDKM25w56hsCYVZ0BUppFlAivu1mHyJVSwUfcJhgFu7ShY2SZ6
         5l+mNoptQWPgHT5NA8HIQGlRoRsG2uG81D+t/xt6c4VUxqgHyOxnuF2Hybzv/v4wot/s
         /kqHpZdeCxUIxcTrQjSiCzHMJGzpNhAaH9CpaKtVDeO7EaeMCMYQOlYUcZE4MgY6EPNm
         gSng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794324524; x=1794929324;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N/pL52fuDy805O1oezgAmGq/06s1o7MBJVwaW8uXKM0=;
        b=rH4ZnqDaLW+JjKDSurYpFm6Fvx2yD9UlHDSybz4oyAVFG4IuZM+1xuuMzsiD+5yNk9
         baOpS3eHV5GxEYA8AzyJafab9mNT9hPibO+V9Nz/2auGWdMqt5Z5jpW/WKFWysR/+z+L
         jdkc4K9s1DxjLIPrZCVBY+fLH1XwB/2ZtkbJsy+RISiipB9kOwrZ2agQp6EmkYtQ5Ijd
         /NkTpWZfZUf1qZSEtTqAaoclHdVDpZTiF1gJQK3vexYHcmNUXaDfVZdbShYZigKwchIx
         FVIK91eruGPQZT1cGLl8c08Ep6aJYHkAf4F5N9heuybS9WHdTSCU53y9ypHxNSAh3aSi
         YoSg==
X-Forwarded-Encrypted: i=1; AL+hErHV9B1OWCTLTdqWEy34MhMo+JnTDGZai/voNHkO7W/YoJZszw5G95pnFptKEpRsi2ZRoYbY0M1xtX7urzUD@vger.kernel.org
X-Gm-Message-State: APuU4Z/tESAgNalzvCCCMkaX1UTUrRAHZOMh8J4X+gNpYA/hL7wd3YjE
	d/EU5BjJE+qMCtN2+8L6MTWhjx3whWzltx7aO/s7KUHzrHnTazLITrEoM+Un2UuM6xXLPV4aQ8n
	3AtB0UF1pF2Wk2BhXnBYgu0GyMBU0cDA=
X-Gm-Gg: AYBFou0OkmvzFs2akX+iDN3x/x9QbYWkaDw6FWfacsTlBINYmXhEjJeAHrX0Gh2NKAs
	ShO4YNMdlKBkqEakf97ccw6Za6xWaw2fRWhZGqR8hFX/AZWdKtqYlE2EQp8eWKC6G09NGEKNiNe
	LmHyVIN6Zc7G5T4kNgw8WIiDDnu4WLsO48EwAHMsrK9afI2PLP53O1IEAuvJQinv9/OZdZkeLDa
	67NJdD1k9kEPY4nGJ/Mf+UAQnUwM7QAUrTdP/0eAkzaGGEZflElCvXy6G2dLNMQNXbLumdDR/yQ
	Dj4Fi6+FQk/gzrH3guxwwrJqq4Swk4e9xaLSI9Fx1SB+LeA72t/JvxEu+jQ/rUFHe/kWGovkEJB
	gk7OS+tFtboyXjzO1whC6ECUmTiEIWvDyxNBsKlYe9ZPdivWBjbEYDKNs72f2jA0+kVxaXQ==
X-Received: by 2002:aa7:d0c5:0:b0:6b1:b9e9:6cfe with SMTP id
 4fb4d7f45d1cf-6b75721642amr1700577a12.14.1794324524002; Tue, 10 Nov 2026
 07:28:44 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261110-ovl-impure-stale-v1-1-1a4c2039e89d@samsung.com>
In-Reply-To: <20261110-ovl-impure-stale-v1-1-1a4c2039e89d@samsung.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 10 Nov 2026 16:28:32 +0100
X-Gm-Features: AclHuK_ARv3jHUu-hk69apU85BgeSLTjG62PZe0bEwlU6YBkA1bnmg3heLSI8k4
Message-ID: <CAOQ4uxgxYZqE=rv5ZYrbyB0cYi_qS-bv_4UCbDwGJoMGg1iNhQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: skip stale entries in impure dir iteration
To: daejun7.park@samsung.com
Cc: Miklos Szeredi <miklos@szeredi.hu>, Hungyu Lin <dennylin0707@gmail.com>, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2026 at 9:03=E2=80=AFAM Daejun Park via B4 Relay
<devnull+daejun7.park.samsung.com@kernel.org> wrote:
>
> From: Daejun Park <daejun7.park@samsung.com>
>
> ext4 returns the entry that did not fit in the previous getdents buffer
> first in the next call, even after it was unlinked. The rebuilt impure
> cache no longer has it. ovl_fill_real() then reports its upper inode
> number. overlay/077 hits this.
>
> Remember the entry that did not fit and look it up before the next
> call. Skip it if it is gone, as commit 9011c2791e63 ("ovl: skip stale
> entries in merge dir cache iteration") does for merge dirs.
>
> Fixes: 4edb83bb1041 ("ovl: constant d_ino for non-merge dirs")
> Reported-by: Hungyu Lin <dennylin0707@gmail.com>
> Closes: https://lore.kernel.org/linux-unionfs/CAGEkeHcg06kHshHQ=3D9U6Yrs_=
wm8W9H28o9bcC2Qh3fw3tANbWA@mail.gmail.com/
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---
> With the fstests change "overlay/077: check a stale entry in an impure
> dir on any hash seed", overlay/077 fails on 3 of 3 random ext4 hash
> seeds before and passes after, also with index=3Don,nfs_export=3Don. The
> test checks both a removed and a recreated next entry. overlay/quick on
> xfs passes.
>
> Not covered: names on the same hash collision chain as the entry that
> did not fit also come from the cached tree. A removed entry with origin
> there is still listed with its upper inode number, as before this patch.
> ---
>  fs/overlayfs/readdir.c | 120 +++++++++++++++++++++++++++++++++++++++++++=
++++--
>  1 file changed, 117 insertions(+), 3 deletions(-)

Daejun,

I am sorry, but this is way too complex to deal with a problem which
is not important enough IMO.

POSIX does not define the exact behavior of readdir of a directory
being changed in this way and I don't think that the current behavior
of ext or overlayfs+ext4 is a gross violation of POSIX or that it could
break applications.

I would be happy to be proven otherwise.

If anything should be fixed then it would be ext4 and not overlayfs
which just relays the stale entry that it gets from ext4.

The only thing to deal with is the spurious overlay/077 failures.
I will address this issue in the test patch review.

Thanks,
Amir.


>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 4cd4af097e5c..0ebc4fe477b7 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -58,10 +58,25 @@ struct ovl_readdir_data {
>         bool in_xwhiteouts_dir;
>  };
>
> +/*
> + * An impure dir entry with origin that the caller of the previous getde=
nts
> + * did not take. The real dir may return it first in the next call, even
> + * after it was removed or replaced.
> + */
> +struct ovl_dir_next {
> +       u64 version;            /* dir version when it was refused */
> +       u64 real_ino;
> +       u64 ino;                /* d_ino to report */
> +       bool gone;              /* removed since, skip it */
> +       int len;
> +       char name[];
> +};
> +
>  struct ovl_dir_file {
>         bool is_real;
>         bool is_upper;
>         struct ovl_dir_cache *cache;
> +       struct ovl_dir_next *next;
>         struct list_head *cursor;
>         struct file *realfile;
>         struct file *upperfile;
> @@ -413,6 +428,8 @@ static void ovl_dir_reset(struct file *file)
>                 od->cache =3D NULL;
>                 od->cursor =3D NULL;
>         }
> +       kfree(od->next);
> +       od->next =3D NULL;
>         is_real =3D ovl_dir_is_real(inode);
>         if (od->is_real !=3D is_real) {
>                 /* is_real can only become false when dir is copied up */
> @@ -767,6 +784,10 @@ static struct ovl_dir_cache *ovl_cache_get_impure(st=
ruct file *file)
>  struct ovl_readdir_translate {
>         struct dir_context *orig_ctx;
>         struct ovl_dir_cache *cache;
> +       struct ovl_dir_next *next;              /* refused before */
> +       struct ovl_cache_entry *refused;        /* refused in this call *=
/
> +       u64 refused_ino;                        /* its d_ino from the rea=
l dir */
> +       bool next_refused;
>         struct dir_context ctx;
>         u64 parent_ino;
>         int fsid;
> @@ -781,13 +802,24 @@ static bool ovl_fill_real(struct dir_context *ctx, =
const char *name,
>         struct ovl_readdir_translate *rdt =3D
>                 container_of(ctx, struct ovl_readdir_translate, ctx);
>         struct dir_context *orig_ctx =3D rdt->orig_ctx;
> +       struct ovl_dir_next *next =3D rdt->next;
> +       struct ovl_cache_entry *p =3D NULL;
> +       u64 real_ino =3D ino;
> +       bool is_next =3D false;
>         bool res;
>
> -       if (rdt->parent_ino && name_is_dotdot(name, namelen)) {
> +       if (next && next->real_ino =3D=3D ino && next->len =3D=3D namelen=
 &&
> +           !memcmp(next->name, name, namelen)) {
> +               /* Looked up before this call if the dir changed */
> +               if (next->gone) {
> +                       rdt->next =3D NULL;
> +                       return true;
> +               }
> +               ino =3D next->ino;
> +               is_next =3D true;
> +       } else if (rdt->parent_ino && name_is_dotdot(name, namelen)) {
>                 ino =3D rdt->parent_ino;
>         } else if (rdt->cache) {
> -               struct ovl_cache_entry *p;
> -
>                 p =3D ovl_cache_entry_find(&rdt->cache->root, name, namel=
en);
>                 if (p)
>                         ino =3D p->ino;
> @@ -798,10 +830,63 @@ static bool ovl_fill_real(struct dir_context *ctx, =
const char *name,
>
>         res =3D orig_ctx->actor(orig_ctx, name, namelen, offset, ino, d_t=
ype);
>         ctx->count =3D orig_ctx->count;
> +       if (!res) {
> +               if (is_next) {
> +                       rdt->next_refused =3D true;
> +               } else {
> +                       rdt->refused =3D p;
> +                       rdt->refused_ino =3D real_ino;
> +               }
> +       }
>
>         return res;
>  }
>
> +/*
> + * The dir changed since the previous call refused this entry. Look the =
name
> + * up as ovl_cache_update() does, and report what stat() would return no=
w.
> + */
> +static int ovl_dir_next_update(const struct path *path,
> +                              struct ovl_dir_next *next)
> +{
> +       struct path statpath =3D *path;
> +       struct dentry *this;
> +       struct kstat stat;
> +       int err =3D 0;
> +
> +       this =3D lookup_one(mnt_idmap(path->mnt), &QSTR_LEN(next->name, n=
ext->len),
> +                         path->dentry);
> +       if (IS_ERR(this))
> +               return PTR_ERR(this);
> +       if (!this->d_inode) {
> +               next->gone =3D true;
> +       } else {
> +               statpath.dentry =3D this;
> +               err =3D vfs_getattr(&statpath, &stat, STATX_INO, 0);
> +               if (!err)
> +                       next->ino =3D stat.ino;
> +       }
> +       dput(this);
> +       return err;
> +}
> +
> +static struct ovl_dir_next *ovl_dir_next_new(struct ovl_cache_entry *p,
> +                                            u64 real_ino, u64 version)
> +{
> +       struct ovl_dir_next *next;
> +
> +       next =3D kmalloc_flex(*next, name, p->len);
> +       if (!next)
> +               return NULL;
> +       next->version =3D version;
> +       next->real_ino =3D real_ino;
> +       next->ino =3D p->ino;
> +       next->gone =3D false;
> +       next->len =3D p->len;
> +       memcpy(next->name, p->name, p->len);
> +       return next;
> +}
> +
>  static bool ovl_is_impure_dir(struct file *file)
>  {
>         struct ovl_dir_file *od =3D file->private_data;
> @@ -863,9 +948,32 @@ static int ovl_iterate_real(struct file *file, struc=
t dir_context *ctx)
>                         return PTR_ERR(rdt.cache);
>         }
>
> +       /* Even if no longer impure: od->next was its last origin entry *=
/
> +       if (od->next) {
> +               u64 version =3D ovl_inode_version_get(d_inode(dir));
> +
> +               if (od->next->version !=3D version) {
> +                       err =3D ovl_dir_next_update(&file->f_path, od->ne=
xt);
> +                       if (err)
> +                               return err;
> +                       od->next->version =3D version;
> +               }
> +               rdt.next =3D od->next;
> +       }
> +
>         err =3D iterate_dir(od->realfile, &rdt.ctx);
>         ctx->pos =3D rdt.ctx.pos;
>
> +       if (!rdt.next_refused) {
> +               u64 version =3D ovl_inode_version_get(d_inode(dir));
> +
> +               kfree(od->next);
> +               od->next =3D NULL;
> +               if (rdt.refused)
> +                       od->next =3D ovl_dir_next_new(rdt.refused,
> +                                                   rdt.refused_ino, vers=
ion);
> +       }
> +
>         return err;
>  }
>
> @@ -908,6 +1016,7 @@ static int ovl_iterate_merged(struct file *file, str=
uct dir_context *ctx)
>
>  static bool ovl_need_adjust_d_ino(struct file *file)
>  {
> +       struct ovl_dir_file *od =3D file->private_data;
>         struct dentry *dentry =3D file->f_path.dentry;
>         struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
>         struct dentry *parent;
> @@ -925,6 +1034,10 @@ static bool ovl_need_adjust_d_ino(struct file *file=
)
>         if (ovl_is_impure_dir(file))
>                 return true;
>
> +       /* An entry the previous call refused may still need adjusting */
> +       if (od->next)
> +               return true;
> +
>         /* If parent is merge, then need to adjust d_ino for '..' */
>         parent =3D dget_parent(dentry);
>         type =3D ovl_path_type(parent);
> @@ -1073,6 +1186,7 @@ static int ovl_dir_release(struct inode *inode, str=
uct file *file)
>                 ovl_cache_put(od, inode);
>                 inode_unlock(inode);
>         }
> +       kfree(od->next);
>         fput(od->realfile);
>         if (od->upperfile)
>                 fput(od->upperfile);
>
> ---
> base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
> change-id: 20261110-ovl-impure-stale-af33421a0977
>
> Best regards,
> --
> Daejun Park <daejun7.park@samsung.com>
>
>
