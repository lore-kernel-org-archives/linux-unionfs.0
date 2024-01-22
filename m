Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458943A1A0
	for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2024 10:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705918480; cv=none; b=c4g8YL5S5ybDuEj/y4uLK0ALU80iJIlsdqXujnDSg9j1NKP42PiTDrJINRPWqHyCLtfdszN4b4L9RUsCHOd6C/jh4pxo62bm4ZUY7HPHvENaKxh6T+GwyrpdW9W/K2LV7Z9ZJhw67lE3o7j8oNQk0eziBNK6hEGkdNqq10eVvwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705918480; c=relaxed/simple;
	bh=INo229jy4qkoFlM1mB6TnjGAZ0YOaZbrFg2fy1rsVtg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pRJuE3uv+oWGTlAdGMs4ft7R5q4x0lbWrARlXUnqAvCCkRpT+crTaUvM9kfJpOYEhAtcyfgOhOcaGWjJsErubn7AFiaWCMUnKxaOdLLzN2WFhr/gQQby3KpPPibdcwGHh81QjNX0rwV04C75MMsld1dtTrKbKKgQXJnuHug5L2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PPLD4gN9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PPLD4gN9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705918477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TAnhLHLPL61x+6YHkfgT9yEQrEOEkyJsBz+/j1MgNAs=;
	b=PPLD4gN9VYsn8g7pQoWNpYo6InG+D8/ipJuwEUJpbKvWoaAHUAezZLKE+ZldwZlO3wGBJJ
	EflGZbs5oCsKm8JxjbSwV/Zx35XdU8iu+ZALhwKk//NmDuGFXDhY83F52q3bvmMu2gqaEg
	Q9AHApLp0GgnBhOoC3PTN6bqRfWKGL0=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-369-gbLdZXE2MouIe7Ho4EcBKg-1; Mon, 22 Jan 2024 05:14:34 -0500
X-MC-Unique: gbLdZXE2MouIe7Ho4EcBKg-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2cd0804c5e6so27662571fa.0
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2024 02:14:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705918473; x=1706523273;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TAnhLHLPL61x+6YHkfgT9yEQrEOEkyJsBz+/j1MgNAs=;
        b=hQxWGgsovLASKnNqRWxmjN0xr+NB97Uqymv7NizD20+BjO99ZOy/mt0sEmDLS4LaCk
         9jItpP0PryeeU4OWOxpW87GMZmz9L0eCWhvOWaJ7pKrJ4k6NehTDgfWqx9ZBNxBEKVJH
         0ZPkZGDk5lEMBcGKir6uUrLhCff8jRG9DUEofnUyydkA8DKKjM/gBKlKmp4l09NeVgeC
         o34ipeeb1R8td+IlAwx0bfItt58sR2g57SZoc7HbMGDSRZRN/5uvF/BnrQSBTWp9PIJh
         ahvz9E6uOx6Ou3FZmXJc7bIZmCjXqddoyGcULt308qL1KCQRxZonYyg0bogSnpjci/0t
         47pQ==
X-Gm-Message-State: AOJu0YyJsRD7YXBxmqX5z4jTe1oZtXw0VU2LNPmfiZD0eM0Li9tSPBvK
	qTV9JaTWZQQ9l8pnYKGS0qvhQeRM/l6mZTChqMHet3yT8nsyRNjuvbLUlxEozHSp9XoxogXgLVn
	fQ79JBUyzVimOdRZiFNMaTzR29tVMjc+gtY1kKfLAYGH6KeDcUvuJSw+BdGvQy3w+rYRCpjU=
X-Received: by 2002:a2e:9bd6:0:b0:2ce:aa5:3b76 with SMTP id w22-20020a2e9bd6000000b002ce0aa53b76mr1258899ljj.49.1705918473111;
        Mon, 22 Jan 2024 02:14:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGfdrFhky3ci9K+5LptKGM5oX+CSzSupoIayHGll5czy6VlSN88mpY8cub+7zHUbYLb5uq0nQ==
X-Received: by 2002:a2e:9bd6:0:b0:2ce:aa5:3b76 with SMTP id w22-20020a2e9bd6000000b002ce0aa53b76mr1258894ljj.49.1705918472716;
        Mon, 22 Jan 2024 02:14:32 -0800 (PST)
Received: from [172.31.0.10] (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.gmail.com with ESMTPSA id q5-20020a2e5c05000000b002ce096da5d6sm698374ljb.83.2024.01.22.02.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 02:14:32 -0800 (PST)
Message-ID: <3679657b0589ee31d09fb9db140fe57121989a69.camel@redhat.com>
Subject: Re: [PATCH v3] ovl: mark xwhiteouts directory with
 overlay.opaque='x'
From: Alexander Larsson <alexl@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
Date: Mon, 22 Jan 2024 11:14:31 +0100
In-Reply-To: <20240121150532.313567-1-amir73il@gmail.com>
References: <20240121150532.313567-1-amir73il@gmail.com>
Autocrypt: addr=alexl@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 (3.50.3-1.fc39) 
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sun, 2024-01-21 at 17:05 +0200, Amir Goldstein wrote:
> An opaque directory cannot have xwhiteouts, so instead of marking an
> xwhiteouts directory with a new xattr, overload overlay.opaque xattr
> for marking both opaque dir ('y') and xwhiteouts dir ('x').
>=20
> This is more efficient as the overlay.opaque xattr is checked during
> lookup of directory anyway.
>=20
> This also prevents unnecessary checking the xattr when reading a
> directory without xwhiteouts, i.e. most of the time.
>=20
> Note that the xwhiteouts marker is not checked on the upper layer and
> on the last layer in lowerstack, where xwhiteouts are not expected.
>=20
> Fixes: bc8df7a3dc03 ("ovl: Add an alternative type of whiteout")
> Cc: <stable@vger.kernel.org> # v6.7
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>=20
> Miklos,
>=20
> Alex has reported a problem with your suggested approach of requiring
> xwhiteouts xattr on layers root dir [1].
>=20
> Following counter proposal, amortizes the cost of checking opaque
> xattr
> on directories during lookup to also check for xwhiteouts.
>=20
> This change requires the following change to test overlay/084:
>=20
> --- a/tests/overlay/084
> +++ b/tests/overlay/084
> @@ -115,7 +115,8 @@ do_test_xwhiteout()
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mkdir -p $basedir/lower $based=
ir/upper $basedir/work
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 touch $basedir/lower/regular $=
basedir/lower/hidden=C2=A0
> $basedir/upper/hidden
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 setfattr -n $prefix.overlay.whiteou=
ts -v "y" $basedir/upper
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 # overlay.opaque=3D"x" means direct=
ory has xwhiteout children
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 setfattr -n $prefix.overlay.opaque =
-v "x" $basedir/upper
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 setfattr -n $prefix.overlay.wh=
iteout -v "y"
> $basedir/upper/hidden
> =C2=A0
>=20
> Alex,
>=20
> Please let us know if this change is acceptable for composefs.

Yes, this looks very good to me. (Minor comments below)
I'll do some testing on this.

>=20
> Thanks,
> Amir.
>=20
> [1]
> https://lore.kernel.org/linux-unionfs/5ee3a210f8f4fc89cb750b3d1a378a0ff01=
87c9f.camel@redhat.com/
>=20
> =C2=A0fs/overlayfs/namei.c=C2=A0=C2=A0=C2=A0=C2=A0 | 32 +++++++++++++++++=
++-------------
> =C2=A0fs/overlayfs/overlayfs.h | 17 +++++++++++++----
> =C2=A0fs/overlayfs/ovl_entry.h |=C2=A0 2 ++
> =C2=A0fs/overlayfs/readdir.c=C2=A0=C2=A0 |=C2=A0 5 +++--
> =C2=A0fs/overlayfs/super.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 9 +++++++++
> =C2=A0fs/overlayfs/util.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 34 ++++++++++++=
++--------------------
> =C2=A06 files changed, 60 insertions(+), 39 deletions(-)
>=20
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 984ffdaeed6c..caccf3803796 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -18,10 +18,11 @@
> =C2=A0
> =C2=A0struct ovl_lookup_data {
> =C2=A0	struct super_block *sb;
> -	struct vfsmount *mnt;
> +	const struct ovl_layer *layer;
> =C2=A0	struct qstr name;
> =C2=A0	bool is_dir;
> =C2=A0	bool opaque;
> +	bool xwhiteouts;
> =C2=A0	bool stop;
> =C2=A0	bool last;
> =C2=A0	char *redirect;
> @@ -201,17 +202,13 @@ struct dentry *ovl_decode_real_fh(struct ovl_fs
> *ofs, struct ovl_fh *fh,
> =C2=A0	return real;
> =C2=A0}
> =C2=A0
> -static bool ovl_is_opaquedir(struct ovl_fs *ofs, const struct path
> *path)
> -{
> -	return ovl_path_check_dir_xattr(ofs, path,
> OVL_XATTR_OPAQUE);
> -}
> -
> =C2=A0static struct dentry *ovl_lookup_positive_unlocked(struct
> ovl_lookup_data *d,
> =C2=A0						=C2=A0=C2=A0 const char *name,
> =C2=A0						=C2=A0=C2=A0 struct dentry
> *base, int len,
> =C2=A0						=C2=A0=C2=A0 bool
> drop_negative)
> =C2=A0{
> -	struct dentry *ret =3D lookup_one_unlocked(mnt_idmap(d->mnt),
> name, base, len);
> +	struct dentry *ret =3D lookup_one_unlocked(mnt_idmap(d->layer-
> >mnt), name,
> +						 base, len);
> =C2=A0
> =C2=A0	if (!IS_ERR(ret) && d_flags_negative(smp_load_acquire(&ret-
> >d_flags))) {
> =C2=A0		if (drop_negative && ret->d_lockref.count =3D=3D 1) {
> @@ -232,10 +229,13 @@ static int ovl_lookup_single(struct dentry
> *base, struct ovl_lookup_data *d,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0 size_t prelen, const char *post,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0 struct dentry **ret, bool
> drop_negative)
> =C2=A0{
> +	struct ovl_fs *ofs =3D OVL_FS(d->sb);
> =C2=A0	struct dentry *this;
> =C2=A0	struct path path;
> =C2=A0	int err;
> =C2=A0	bool last_element =3D !post[0];
> +	bool is_upper =3D d->layer->idx =3D=3D 0;
> +	char val;
> =C2=A0
> =C2=A0	this =3D ovl_lookup_positive_unlocked(d, name, base, namelen,
> drop_negative);
> =C2=A0	if (IS_ERR(this)) {
> @@ -253,8 +253,8 @@ static int ovl_lookup_single(struct dentry *base,
> struct ovl_lookup_data *d,
> =C2=A0	}
> =C2=A0
> =C2=A0	path.dentry =3D this;
> -	path.mnt =3D d->mnt;
> -	if (ovl_path_is_whiteout(OVL_FS(d->sb), &path)) {
> +	path.mnt =3D d->layer->mnt;
> +	if (ovl_path_is_whiteout(ofs, &path)) {
> =C2=A0		d->stop =3D d->opaque =3D true;
> =C2=A0		goto put_and_out;
> =C2=A0	}
> @@ -272,7 +272,7 @@ static int ovl_lookup_single(struct dentry *base,
> struct ovl_lookup_data *d,
> =C2=A0			d->stop =3D true;
> =C2=A0			goto put_and_out;
> =C2=A0		}
> -		err =3D ovl_check_metacopy_xattr(OVL_FS(d->sb), &path,
> NULL);
> +		err =3D ovl_check_metacopy_xattr(ofs, &path, NULL);
> =C2=A0		if (err < 0)
> =C2=A0			goto out_err;
> =C2=A0
> @@ -292,7 +292,11 @@ static int ovl_lookup_single(struct dentry
> *base, struct ovl_lookup_data *d,
> =C2=A0		if (d->last)
> =C2=A0			goto out;
> =C2=A0
> -		if (ovl_is_opaquedir(OVL_FS(d->sb), &path)) {
> +		/* overlay.opaque=3Dx means xwhiteouts directory */
> +		val =3D ovl_get_opaquedir_val(ofs, &path);
> +		if (last_element && !is_upper && val =3D=3D 'x') {
> +			d->xwhiteouts =3D true;
> +		} else if (val =3D=3D 'y') {
> =C2=A0			d->stop =3D true;
> =C2=A0			if (last_element)
> =C2=A0				d->opaque =3D true;
> @@ -1055,7 +1059,7 @@ struct dentry *ovl_lookup(struct inode *dir,
> struct dentry *dentry,
> =C2=A0	old_cred =3D ovl_override_creds(dentry->d_sb);
> =C2=A0	upperdir =3D ovl_dentry_upper(dentry->d_parent);
> =C2=A0	if (upperdir) {
> -		d.mnt =3D ovl_upper_mnt(ofs);
> +		d.layer =3D &ofs->layers[0];
> =C2=A0		err =3D ovl_lookup_layer(upperdir, &d, &upperdentry,
> true);
> =C2=A0		if (err)
> =C2=A0			goto out;
> @@ -1111,7 +1115,7 @@ struct dentry *ovl_lookup(struct inode *dir,
> struct dentry *dentry,
> =C2=A0		else if (d.is_dir || !ofs->numdatalayer)
> =C2=A0			d.last =3D lower.layer->idx =3D=3D
> ovl_numlower(roe);
> =C2=A0
> -		d.mnt =3D lower.layer->mnt;
> +		d.layer =3D lower.layer;
> =C2=A0		err =3D ovl_lookup_layer(lower.dentry, &d, &this,
> false);
> =C2=A0		if (err)
> =C2=A0			goto out_put;
> @@ -1278,6 +1282,8 @@ struct dentry *ovl_lookup(struct inode *dir,
> struct dentry *dentry,
> =C2=A0
> =C2=A0	if (upperopaque)
> =C2=A0		ovl_dentry_set_opaque(dentry);
> +	if (d.xwhiteouts)
> +		ovl_dentry_set_xwhiteouts(dentry);
> =C2=A0
> =C2=A0	if (upperdentry)
> =C2=A0		ovl_dentry_set_upper_alias(dentry);
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 5ba11eb43767..410b3bfc3afc 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -70,6 +70,8 @@ enum ovl_entry_flag {
> =C2=A0	OVL_E_UPPER_ALIAS,
> =C2=A0	OVL_E_OPAQUE,
> =C2=A0	OVL_E_CONNECTED,
> +	/* Lower stack may contain xwhiteout entries */
> +	OVL_E_XWHITEOUTS,
> =C2=A0};
> =C2=A0
> =C2=A0enum {
> @@ -476,6 +478,8 @@ void ovl_dentry_clear_flag(unsigned long flag,
> struct dentry *dentry);
> =C2=A0bool ovl_dentry_test_flag(unsigned long flag, struct dentry
> *dentry);
> =C2=A0bool ovl_dentry_is_opaque(struct dentry *dentry);
> =C2=A0bool ovl_dentry_is_whiteout(struct dentry *dentry);
> +bool ovl_dentry_is_xwhiteouts(struct dentry *dentry);
> +void ovl_dentry_set_xwhiteouts(struct dentry *dentry);
> =C2=A0void ovl_dentry_set_opaque(struct dentry *dentry);
> =C2=A0bool ovl_dentry_has_upper_alias(struct dentry *dentry);
> =C2=A0void ovl_dentry_set_upper_alias(struct dentry *dentry);
> @@ -494,11 +498,10 @@ struct file *ovl_path_open(const struct path
> *path, int flags);
> =C2=A0int ovl_copy_up_start(struct dentry *dentry, int flags);
> =C2=A0void ovl_copy_up_end(struct dentry *dentry);
> =C2=A0bool ovl_already_copied_up(struct dentry *dentry, int flags);
> -bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, const struct path
> *path,
> -			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 enum ovl_xattr ox);
> +char ovl_get_dir_xattr_val(struct ovl_fs *ofs, const struct path
> *path,
> +			=C2=A0=C2=A0 enum ovl_xattr ox);
> =C2=A0bool ovl_path_check_origin_xattr(struct ovl_fs *ofs, const struct
> path *path);
> =C2=A0bool ovl_path_check_xwhiteout_xattr(struct ovl_fs *ofs, const struc=
t
> path *path);
> -bool ovl_path_check_xwhiteouts_xattr(struct ovl_fs *ofs, const
> struct path *path);
> =C2=A0bool ovl_init_uuid_xattr(struct super_block *sb, struct ovl_fs *ofs=
,
> =C2=A0			 const struct path *upperpath);
> =C2=A0
> @@ -573,7 +576,13 @@ static inline bool ovl_is_impuredir(struct
> super_block *sb,
> =C2=A0		.mnt =3D ovl_upper_mnt(ofs),
> =C2=A0	};
> =C2=A0
> -	return ovl_path_check_dir_xattr(ofs, &upperpath,
> OVL_XATTR_IMPURE);
> +	return ovl_get_dir_xattr_val(ofs, &upperpath,
> OVL_XATTR_IMPURE) =3D=3D 'y';
> +}
> +
> +static inline char ovl_get_opaquedir_val(struct ovl_fs *ofs,
> +					 const struct path *path)
> +{
> +	return ovl_get_dir_xattr_val(ofs, path, OVL_XATTR_OPAQUE);
> =C2=A0}
> =C2=A0
> =C2=A0static inline bool ovl_redirect_follow(struct ovl_fs *ofs)
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 5fa9c58af65f..0b7b21745ba3 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -86,6 +86,8 @@ struct ovl_fs {
> =C2=A0	/* Shared whiteout cache */
> =C2=A0	struct dentry *whiteout;
> =C2=A0	bool no_shared_whiteout;
> +	/* xwhiteouts may exist in lower layers */
> +	bool xwhiteouts;

This comment is a bit off, this is now only used for the root dir.

> =C2=A0	/* r/o snapshot of upperdir sb's only taken on volatile
> mounts */
> =C2=A0	errseq_t errseq;
> =C2=A0};
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index e71156baa7bc..edef4e3401de 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -165,7 +165,8 @@ static struct ovl_cache_entry
> *ovl_cache_entry_new(struct ovl_readdir_data *rdd,
> =C2=A0	p->is_upper =3D rdd->is_upper;
> =C2=A0	p->is_whiteout =3D false;
> =C2=A0	/* Defer check for overlay.whiteout to ovl_iterate() */
> -	p->check_xwhiteout =3D rdd->in_xwhiteouts_dir && d_type =3D=3D
> DT_REG;
> +	p->check_xwhiteout =3D rdd->in_xwhiteouts_dir &&
> +			=C2=A0=C2=A0=C2=A0 !rdd->is_upper && d_type =3D=3D DT_REG;
> =C2=A0

Maybe we can move the is_upper check to where we set in_xwhiteouts_dir?

> =C2=A0	if (d_type =3D=3D DT_CHR) {
> =C2=A0		p->next_maybe_whiteout =3D rdd->first_maybe_whiteout;
> @@ -306,7 +307,7 @@ static inline int ovl_dir_read(const struct path
> *realpath,
> =C2=A0		return PTR_ERR(realfile);
> =C2=A0
> =C2=A0	rdd->in_xwhiteouts_dir =3D rdd->dentry &&
> -		ovl_path_check_xwhiteouts_xattr(OVL_FS(rdd->dentry-
> >d_sb), realpath);
> +		ovl_dentry_is_xwhiteouts(rdd->dentry);

Now that the xwhiteout flag is on the dentry, it will be set for all
layers. Maybe we can avoid setting in_whiteouts_dir for the lowermost
layer?

> =C2=A0	rdd->first_maybe_whiteout =3D NULL;
> =C2=A0	rdd->ctx.pos =3D 0;
> =C2=A0	do {
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 4ab66e3d4cff..81f045025c96 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1026,6 +1026,7 @@ static int ovl_get_layers(struct super_block
> *sb, struct ovl_fs *ofs,
> =C2=A0		struct ovl_fs_context_layer *l =3D &ctx->lower[i];
> =C2=A0		struct vfsmount *mnt;
> =C2=A0		struct inode *trap;
> +		struct path root;
> =C2=A0		int fsid;
> =C2=A0
> =C2=A0		if (i < nr_merged_lower)
> @@ -1068,6 +1069,12 @@ static int ovl_get_layers(struct super_block
> *sb, struct ovl_fs *ofs,
> =C2=A0		 */
> =C2=A0		mnt->mnt_flags |=3D MNT_READONLY | MNT_NOATIME;
> =C2=A0
> +		/* overlay.opaque=3Dx means xwhiteouts directory */
> +		root.mnt =3D mnt;
> +		root.dentry =3D mnt->mnt_root;
> +		if (ovl_get_opaquedir_val(ofs, &root) =3D=3D 'x')
> +			ofs->xwhiteouts =3D true;
> +
> =C2=A0		layers[ofs->numlayer].trap =3D trap;
> =C2=A0		layers[ofs->numlayer].mnt =3D mnt;
> =C2=A0		layers[ofs->numlayer].idx =3D ofs->numlayer;
> @@ -1272,6 +1279,8 @@ static struct dentry *ovl_get_root(struct
> super_block *sb,
> =C2=A0
> =C2=A0	/* Root is always merge -> can have whiteouts */
> =C2=A0	ovl_set_flag(OVL_WHITEOUTS, d_inode(root));
> +	if (OVL_FS(sb)->xwhiteouts)
> +		ovl_dentry_set_flag(OVL_E_XWHITEOUTS, root);
> =C2=A0	ovl_dentry_set_flag(OVL_E_CONNECTED, root);
> =C2=A0	ovl_set_upperdata(d_inode(root));
> =C2=A0	ovl_inode_init(d_inode(root), &oip, ino, fsid);
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 0217094c23ea..fb622995fb28 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -456,6 +456,16 @@ bool ovl_dentry_is_whiteout(struct dentry
> *dentry)
> =C2=A0	return !dentry->d_inode && ovl_dentry_is_opaque(dentry);
> =C2=A0}
> =C2=A0
> +bool ovl_dentry_is_xwhiteouts(struct dentry *dentry)
> +{
> +	return ovl_dentry_test_flag(OVL_E_XWHITEOUTS, dentry);
> +}
> +
> +void ovl_dentry_set_xwhiteouts(struct dentry *dentry)
> +{
> +	ovl_dentry_set_flag(OVL_E_XWHITEOUTS, dentry);
> +}
> +
> =C2=A0void ovl_dentry_set_opaque(struct dentry *dentry)
> =C2=A0{
> =C2=A0	ovl_dentry_set_flag(OVL_E_OPAQUE, dentry);
> @@ -739,19 +749,6 @@ bool ovl_path_check_xwhiteout_xattr(struct
> ovl_fs *ofs, const struct path *path)
> =C2=A0	return res >=3D 0;
> =C2=A0}
> =C2=A0
> -bool ovl_path_check_xwhiteouts_xattr(struct ovl_fs *ofs, const
> struct path *path)
> -{
> -	struct dentry *dentry =3D path->dentry;
> -	int res;
> -
> -	/* xattr.whiteouts must be a directory */
> -	if (!d_is_dir(dentry))
> -		return false;
> -
> -	res =3D ovl_path_getxattr(ofs, path, OVL_XATTR_XWHITEOUTS,
> NULL, 0);
> -	return res >=3D 0;
> -}
> -
> =C2=A0/*
> =C2=A0 * Load persistent uuid from xattr into s_uuid if found, or store a
> new
> =C2=A0 * random generated value in s_uuid and in xattr.
> @@ -811,20 +808,17 @@ bool ovl_init_uuid_xattr(struct super_block
> *sb, struct ovl_fs *ofs,
> =C2=A0	return false;
> =C2=A0}
> =C2=A0
> -bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, const struct path
> *path,
> -			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 enum ovl_xattr ox)
> +char ovl_get_dir_xattr_val(struct ovl_fs *ofs, const struct path
> *path,
> +			=C2=A0=C2=A0 enum ovl_xattr ox)
> =C2=A0{
> =C2=A0	int res;
> =C2=A0	char val;
> =C2=A0
> =C2=A0	if (!d_is_dir(path->dentry))
> -		return false;
> +		return 0;
> =C2=A0
> =C2=A0	res =3D ovl_path_getxattr(ofs, path, ox, &val, 1);
> -	if (res =3D=3D 1 && val =3D=3D 'y')
> -		return true;
> -
> -	return false;
> +	return res =3D=3D 1 ? val : 0;
> =C2=A0}
> =C2=A0
> =C2=A0#define OVL_XATTR_OPAQUE_POSTFIX	"opaque"

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
=3D-=3D-=3D
 Alexander Larsson                                            Red Hat,
Inc=20
       alexl@redhat.com            alexander.larsson@gmail.com=20
He's a deeply religious small-town paranormal investigator searching
for=20
his wife's true killer. She's a strong-willed French-Canadian single=20
mother operating on the wrong side of the law. They fight crime!=20

