Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656883B47CF
	for <linux-unionfs@vger.kernel.org>; Mon, 27 Apr 2026 10:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777284644; cv=pass; b=Cq3ya/AK3J6EwxmRQQWp9jKFKpfJA7qq/shOht1Rra4skpXpNE9Zxc9arNRCbpyPLyMViW+BNDv85EX092RttCsK0sx8uGfXBTIBdMwu/xq2FRqjbfPkw69GayAVvM2uxc2Cm9Znv0l/F/ts1MLBRAw7/h8BsmtiBrs8+n5Knd4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777284644; c=relaxed/simple;
	bh=UE+DJnE2oj0vFOXp+m3XTb9AY/fwBqMnmmO9cLxXoJE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DpgPCwBAGNWeXiJ4GZINDMZy/ROHx8c72bfABsE4XscDYyyjdqAp4q0UMiWoyCUanodsWpwugMSXbgzD1qI7Cv8zQ4sbbW7t+/0jqLgAWMnTDSyMD8giWFsm/N9Y9Ly782+mcjt2DfyEGC3yU+5Ygx+hoLhmc56BX0G/NKnHjXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XWxtLhyu; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XWxtLhyu"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b9d9971d059so1418667166b.2
        for <linux-unionfs@vger.kernel.org>; Mon, 27 Apr 2026 03:10:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777284641; cv=none;
        d=google.com; s=arc-20240605;
        b=Eu5tbRmPiJXL4luLXVyRLUYHr15FAEMLXZ+WEz5PYIc2XHtVxp3fFqbP7NjI+SJsv/
         eSfyZhy4yvRGoJfWqj6b9U+hr6VICaWJr8zP6r6RSjgSt2IZaSJRoVMvqTONJqTCeSEZ
         spDteHV9ps3Kq0ZUg+7HgwJ1DxP9ggdBBIgNaf3c1Ag6DgjKTp2qhU5Kc85mRHRO2chs
         cJ+rDE73DvL7iY1RJrRIWDqeCKRSnkrZvrJn8fi9+O1xe2np3XgyptjmbanffWrTmo4r
         Bya2vCi7wogwnnFZ1bbkAvHM2hzq10Bi6hr4kqsgZRzimQxQdrgAiEPigh3I5yCDoPO2
         uJ+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iKRwDoHSf2+oXdi49CMbzE7n/0K7hTCuX9atPHgXxI0=;
        fh=AIY0PNnc7w8iY4N0VdQmFepOvRNbIyyshPOoRHZT6pM=;
        b=U9H9ORKRKxt/GRCmotRvi+CuD6yqw/fLScCAbSuvYGIr/twOUF+2holq5misE9TwU5
         Docu0Vo00KY3GObGPRd1FxGfv/o6VM9bEpq+W1AEochWXHjnofbvymbt/6ZhxRZ++bmF
         FT6V7utcJydgMN+7/pzoCgt28PTNal6PW9n9XEzGXzCFjg+lFBjpFKUyO3eaP4hvgyEe
         q0oY6WFfKPbzkcgYiH0ppWk4wTTKRkP4Rndc3OtV2/afOScJcUTYgMbKNtgLqLxL9oRj
         h/KcGekvvCY1DsO8hcw8MVsUtkGhwjm0ik92sZ0Hl6/BtMuzjvhXTHO0A7ic7lFrr2+Y
         WUAw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777284641; x=1777889441; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iKRwDoHSf2+oXdi49CMbzE7n/0K7hTCuX9atPHgXxI0=;
        b=XWxtLhyuTrbLekIie5/rVrfuMytoMDSx8Qf7TMBgHSgE8ZB91RgoGWETMZ048CaOvO
         zRby5VgYxvDRqlC0slSCp3xUOQxKpIpyraTPDWyx4j7pKgMz+X4AIJe9p9bu/QmT0pa9
         hWMF6BwqTU/VU8Qve9jQjiWu/fAcHnNguwdWLxWqzOTTdVOjgaX1HfSfYCuK9xKuMoKW
         TSVHQqM/r/E2cJF/sJ/iEgAEQ5Z7dK9oi20/j53FD/iTBpQflplhY8FzOHUYOXm/lfyI
         oK+uT/qR4V0TA1NmHHiYV+LB9zaCzZbTvgs80IfFEkkhO0kMwcoE6NYUbd1kO3Jljq2V
         u1bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777284641; x=1777889441;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iKRwDoHSf2+oXdi49CMbzE7n/0K7hTCuX9atPHgXxI0=;
        b=I/4jDDHuCikvSKoRMyspS+6An2fqh6uQdx4ycNAS1Wik+l0tBeL+Zf2PNVpWK1mCYb
         ibNcWS6Tchv21M9nmko3MaL2i/FWdgOXITuEUgXY1xwhRThs31gvJWZhTOqG3q+W//U5
         /6XOKOEiDiZDuL73UjFuEBuJKogCxGcCtcCZlL79/aRWIKQzN23clco/IgoTVdX+9xaO
         1Ij/7y0JuhM63Ts3HIhcrjQ23MrVmJY8T8oxc7RoQ62Hk0RnZJ+8YATsY4raxLzbI8hK
         zIzcP46L+aEBdOgHYzdbmoAZhD279eqvUEf6ZcSAMtHzTDHd9fQ6KZyyO/V7tEiZzteb
         fwOw==
X-Forwarded-Encrypted: i=1; AFNElJ+UOARTevJV4Z/xJul6q5JRL7yqNaoatSPAZRm7r1MK4/sgWeldzdY8v0lzSu5FmlRedOufDGqFCOGIpR7y@vger.kernel.org
X-Gm-Message-State: AOJu0YzsqDv2lXMunk+n8ZM1N/ZO3fVW//y95nDRmeJjLP8xtAgnbndj
	cq7XBDlW51q1qaOrvTheQCTr7KGNT034gK4ccqBTpypCkFetJ4qK9/Wp1ffbksBXFWd521LO36p
	+6CFrN15yET49AR9Hvy06+wRCUfC5YJY=
X-Gm-Gg: AeBDiet6hmGpmVb7h/cmbKiRKawfM2/8e/txFOELahzZJnTNoX6x+Vck1tuzYQ7XDFB
	mKEk50Nd1LIko2iHvzT9t8DnVgsAYe8+uuMHTnj+lrWGeHoh8b95HczftLTX2EV+ijz31wGeLcv
	kM5gU+acVXuPSJyc4LULX0I1JN/CxXPRrgIERSTTBZUlLwfwXai1kzHcOZ8TpES2jB8Sj3CJF2q
	tmH7BrffxZfqVIZFQlcQtiinfJ69ja42uQKaCKdJ4yrVMG0GHOtIMyNbmRKxWojJ9AXpA/WH4wP
	zPeHofVaFUvUZ0/RQSr5JwOWgo1htCaNdJT8jO39yE5RTSBZkwqqDsFwIBW8854=
X-Received: by 2002:a17:907:806:b0:b9b:4519:7914 with SMTP id
 a640c23a62f3a-ba41a82618emr2176151966b.33.1777284640148; Mon, 27 Apr 2026
 03:10:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427040517.828226-1-neilb@ownmail.net> <20260427040517.828226-10-neilb@ownmail.net>
In-Reply-To: <20260427040517.828226-10-neilb@ownmail.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 27 Apr 2026 12:10:28 +0200
X-Gm-Features: AVHnY4JedWd56CMn-KycBPWg0ncqD2_jbR4uqG29qEFrdNMohyhNrM6UW-jNm2o
Message-ID: <CAOQ4uxidCcGpABkCtkn94i3U_u3OWK16zeAVDG2xuhh5e+ws9g@mail.gmail.com>
Subject: Re: [PATCH v3 09/19] ovl: stop using lookup_one() in iterate_shared() handling.
To: NeilBrown <neil@brown.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2026 at 6:07=E2=80=AFAM NeilBrown <neilb@ownmail.net> wrote=
:
>
> From: NeilBrown <neil@brown.name>
>
> lookup_one() is expected to be removed as it does not fit well with
> proposed changes to directory locking.
> Specifically d_alloc_parallel() will be ordered outside of i_rwsem
> and as iterate_shared() is called with i_rwsem held it is not safe
> to call d_alloc_parallel().
>
> We can instead call d_alloc_noblock() and then call the ->lookup, but
> that can fail if there is a lookup attempt concurrent with the
> readdir().
>
> ovl cannot afford for the lookup to fail as that could produce incorrect
> results, and it cannot safely drop i_rwsem temporarily and that could
> introduce races with handling of the directory cache.
>
> Instead we rely on the fact that ovl_iterate() has an exclusive lock on
> the directory, so any concurrent lookup will wait for the ovl_iterate()
> call to complete.  We allocate a separate dentry and if the lookup is
> successful, it is hashed with the result.
>
> When the concurrent lookup gets i_rwsem it mustn't do its own lookup -
> it must use the existing dentry.  This is found, if it exists, using
> try_lookup_noperm().

Hi Niel,

One nit about the subject -
Please change it to "ovl: stop using lookup_one() in ovl_iterate()"

Apart from that, I let Claude do the review, because it has surpassed
my abilities in reviewing such subtle api changes.

I will copy its output verbatim, if for nothing else, to encourage you
to start applying Claude review before sending out your patches...

>
> Signed-off-by: NeilBrown <neil@brown.name>
> ---
>  fs/overlayfs/namei.c   | 12 ++++++++++++
>  fs/overlayfs/readdir.c | 24 ++++++++++++++++++++++--
>  2 files changed, 34 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index ca899fdfaafd..69032eb2b1e2 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -1385,6 +1385,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct=
 dentry *dentry,
>         struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
>         struct ovl_entry *poe =3D OVL_E(dentry->d_parent);
>         bool check_redirect =3D (ovl_redirect_follow(ofs) || ofs->numdata=
layer);
> +       struct dentry *alias;
>         int err;
>         struct ovl_lookup_ctx ctx =3D {
>                 .dentry =3D dentry,
> @@ -1399,6 +1400,17 @@ struct dentry *ovl_lookup(struct inode *dir, struc=
t dentry *dentry,
>         if (dentry->d_name.len > ofs->namelen)
>                 return ERR_PTR(-ENAMETOOLONG);
>
> +       /*
> +        * The existance of this in-lookup dentry might have forced

"existance" should be "existence" in the namei.c comment

> +        * readdir to do the lookup with a new dentry.  If so we must
> +        * return that one.
> +        */
> +       alias =3D try_lookup_noperm(&QSTR_LEN(dentry->d_name.name,
> +                                           dentry->d_name.len),
> +                                 dentry->d_parent);
> +       if (alias && !IS_ERR(alias))
> +               return alias;
> +
>         with_ovl_creds(dentry->d_sb)
>                 err =3D ovl_lookup_layers(&ctx, &d);
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 1dcc75b3a90f..e03b32491941 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -574,8 +574,28 @@ static int ovl_cache_update(const struct path *path,=
 struct ovl_cache_entry *p,
>                 }
>         }
>         /* This checks also for xwhiteouts */
> -       this =3D lookup_one(mnt_idmap(path->mnt), &QSTR_LEN(p->name, p->l=
en), dir);
> -       if (IS_ERR_OR_NULL(this) || !this->d_inode) {
> +       this =3D d_alloc_noblock(dir, &QSTR_LEN(p->name, p->len));
> +       if (this =3D=3D ERR_PTR(-EWOULDBLOCK)) {
> +               /*
> +                * Some other thead is looking up this name and will

"thead" should be "thread" in the readdir.c comment

> +                * block on i_rwsem before it can complete the lookup.
> +                * We will do the lookup in a new dentry and when that
> +                * lookup gets a turn it will find and return this
> +                * dentry.
> +                */
> +               this =3D d_alloc_name(dir, p->name);

Claude suggests this as the simplest fix to NULL deref bug below:
                    if (!this)
                            this =3D ERR_PTR(-ENOMEM);

> +       }
> +       if (!IS_ERR(this) && !d_unhashed(this)) {
> +               /* Either we got an in-lookup or we made our own unhashed=
 */

The condition should be d_unhashed(this) (without !), matching the comment
which says "Either we got an in-lookup or we made our own unhashed".

d_alloc_name() calls d_alloc() which returns NULL on allocation failure.
The original code checked IS_ERR_OR_NULL(this), but the new code only
checks IS_ERR(this). A NULL this would pass the !IS_ERR(this) check and
then crash on !d_unhashed(this) (or d_unhashed(this) with the fix).

> +               struct dentry *alias =3D ovl_lookup(dir->d_inode, this, 0=
);
> +
> +               if (alias) {
> +                       d_lookup_done(this);
> +                       dput(this);
> +                       this =3D alias;
> +               }
> +       }
> +       if (IS_ERR(this) || !this->d_inode) {
>                 /* Mark a stale entry */
>                 p->is_whiteout =3D true;
>                 if (IS_ERR(this)) {
> --

Claude (Opus 4.6) review summary:

The patch has a critical condition inversion (!d_unhashed vs d_unhashed)
that would break impure readdir entirely and cause use-after-free corruptio=
n
in the dcache. It also has a missing NULL check for d_alloc_name() failure.

Thanks,
Amir.
