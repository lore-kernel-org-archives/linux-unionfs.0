Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC494BEE50
	for <linux-unionfs@vger.kernel.org>; Wed, 30 Sep 2026 13:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790775372; cv=pass; b=Me08h8BvdoTANG7MNg2SERPwjwtSBsxben1JJkTa0m94ntcCLYqlDi82kZzPUWEgFuFTN2knjeYhpX3WOoVZRb0OEAF3ZUo+mYe+UASLApcaEnewY0AYdebzpWDcY3nE1yrB+q7L1yphIms1HbEFQk+2FWmaNTKc9XZ021aU8R0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790775372; c=relaxed/simple;
	bh=SXhpmvBhQ+TXtxniHLWeCSa452bmcr1rqYYurbJuz+I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HhZx9w9oVLdQWVrSSZ/alUiSUg5GotH32CTYwPllrTc0D/z/jxTbDMUWLIPqnVeTu5LSm+AMD1UV4oQVPx8zji/BCktYq5mPvwSB7SLkEnRSWq0MPbVKMBLzqpkoZgXi/rd3SAK10b62mKCzhnMl7m08zVIAZMNGaDRZi8RyZTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=evutIW/P; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="evutIW/P"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c20ce3c118aso291645266b.0
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Sep 2026 06:36:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790775357; cv=none;
        d=google.com; s=arc-20260327;
        b=CO/BbxWHaLMhRoqnImLsyG0drJ9NoCNsvaP35vsTDdbWxTkxoO7WGYUpCnTKTo9U5o
         VwGQa4nNWNzGCdHBlOKRb8w2tZ+osI11YuEedBdJ5r0M0z/2iSker0/WdLXSesTrVlGt
         J2Z9Ws6eM9woXvGZN1XQZeyzkNys8WuE+z7TJjOS+BJpwS+Mc0cOyz4MHliq5zM4bdCN
         4GUjCq/deInZQr7M6j3SaaU3ZrNRU6wZo3AkuutYzGNgFzqXzmNPDAOJZtgw/N76BTgv
         4L4s2CsT0WMM7divIajoSHziazrOgiMkpxBmm1zLSmw/MDYT50vRbAXE4VQmNRk9+Z1v
         wC6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4QchkhwI1w5bSASLXqcxUjuWuiosjQacZxJlQZryO/o=;
        fh=IkM/AvYszDezYNPHAulOWbnhx35hX1QujDMgVmOB5Ug=;
        b=iGdX4hGKtmrfJkxX2tDNMPRawF4lS6n2Ke/rIUz0Sg4mMKhPgyg3VtQwMuwo0X2/T1
         JSIi89PDcHehQTifV8FrB+tEM830dzgZFl6tUsYtuLLVWbFce1NPgSWN5PxpqoA2f5uZ
         j29ICV9i4Xibk55Gj53ZhXDGiomBGJ7HHwKJh4VjRlJfZp90z942Vpx1BOl0VWdJzc6C
         sZ7Gu0yBeZHEoj24WC6z3akx4KFARMJB0e5yvrs3a6zsruOgMnRkareC97TvCQjpDBvg
         QD3L8b/NhiN8a2vnS9TmlOI8+f06eewr/M4a3NiZHTHj616yGRjJxZPgDCxT17X6R1Zf
         sCRw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790775357; x=1791380157; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4QchkhwI1w5bSASLXqcxUjuWuiosjQacZxJlQZryO/o=;
        b=evutIW/PczIr77lL6OkJRMbForrjcor9PZ2o3hdDZRiEKRhK23mwBgAZwekT7qYfZi
         uNb5iE02N4k+EHRQYemqbPk6OxiLD4JWoTOxI+X9sZG6X09iq35KZKzDuBA5VN4EWor+
         R02FWb9NbrEaQ7wxNRFw3G7jHpv5iVUyOUYY6sUVzVmJMwY1R61zOgLllebu+kDoX3dd
         uQaMpgaDzn9dL0uJidEjF9TsLLg75irnMkLP41dJfAtAtLJXPaZDsFak8YsFehEUXcC+
         iX6sr2QR5wuPzKhF8SicP1fSJCGHGZgvylrU6v97f0h3xVult1azYrPjsCnr4UUKwhfI
         +AWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790775357; x=1791380157;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4QchkhwI1w5bSASLXqcxUjuWuiosjQacZxJlQZryO/o=;
        b=lRQb4oRRUr3N7DnZ5u8t/qT669CdfkuKfWmKZfIeqUiSc5INvOAvlldlwB3v4s+I4A
         cxcV2C4g/zV5/ICp8m03ECZpse6gPNA2+p2P25eHTJ+3WD06QUZ9P1w6Tx8GeuyjktAt
         Wut1xo+fvmKczi0JRPUK5F+ascfXbRKupw6cEbmk193zEuaei45Gb8+G1h3hD6mBAqN9
         d4ml6I9g5t6L7aa3QjeWBuW5Hrsjy+9m5e4Viuuqh+14lqcenL/iBxAde1zIcUC1ZTW/
         5P6r0QNwgggHSFf+Yu7nNxe0m16Gf6hlBzN0vCafv+jKcVVOQJOQ1J+LMpWf4v71IGfk
         J0Lw==
X-Forwarded-Encrypted: i=1; AKwUvBwLuPMB0yMltLNQ3rirUqpcFvGT+aRfUch5kKtSKz/yNv5SMFW8uqm0/S6AxhpZksMVxrsH+3vh6VTWz3CJ@vger.kernel.org
X-Gm-Message-State: AFuF++mvdJv+zgRzEu8U7MUIKb9+Fcb9A7QaIshHpG5TZqshFYVmTEaI
	dPvMKD/YgdbRRcH8w59kzUhs8q/PrmrCQg2Q/KUjjcKTTA9tisqkIlAe3F9Qjepb9Oaosn0GsAS
	rB2HyX0d6+Gjm2GfRAhF3t5wzeIYRExg=
X-Gm-Gg: AYBFou1SBimrhjvIYIFWBHYBN/Ts21xXhehml9GixgPhwbq3ks0EqoV2pj2Ke1S3iBU
	AhBKzXEaxjr1CsOQCsPdO3zBj321M58ns98MZHOqqR7th2e/UyCw1s/Be4wcFSj3+77oa74zIe1
	n0mwug4sogoMlW7mAkrF4QkoEyDrUqq6k7i+26T3kmHour1HkI7d0S4eFLkto5d2VKx7worJPGi
	oHsx21Av0VNAcZXfjy6nHCVDDe/OOXG4vedgn3S0mow1e0TsKpc61aGB+OKSInkb7nwAzoF2p6w
	9+N2JUvluE2Jktc4qcw6ALBITG5DMxqPv1gOsZeAXrnAtu9u5McwXIRcv2d3WBlL7q3k
X-Received: by 2002:a17:906:6a05:b0:c2d:b9b4:f4de with SMTP id
 a640c23a62f3a-c2e23d9207amr125564266b.18.1790775356627; Wed, 30 Sep 2026
 06:35:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260929034158.1455429-1-neilb@ownmail.net> <20260929034158.1455429-8-neilb@ownmail.net>
In-Reply-To: <20260929034158.1455429-8-neilb@ownmail.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 30 Sep 2026 15:35:45 +0200
X-Gm-Features: AclHuK-7IYZDCVZREHuHZMSP_wgME-NMrM9tsJnpybGevda7U-xOXfVzEqygZdo
Message-ID: <CAOQ4uxjv3Ziqy+CjbCO7noAPse+a0066UO7pkFhStnnW9FFSPg@mail.gmail.com>
Subject: Re: [PATCH 7/7] ovl: stop using lookup_one() in ovl_iterate().
To: NeilBrown <neil@brown.name>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Kees Cook <kees@kernel.org>, 
	Joel Granados <joel.granados@kernel.org>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Breno Leitao <leitao@debian.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Jan Harkes <jaharkes@cs.cmu.edu>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Hyunchul Lee <hyc.lee@gmail.com>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-um@lists.infradead.org, 
	codalist@coda.cs.cmu.edu, coda@cs.cmu.edu, linux-mm@kvack.org, 
	ntfs@lists.linux.dev, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 29, 2026 at 5:43=E2=80=AFAM NeilBrown <neilb@ownmail.net> wrote=
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
> We can instead call d_alloc_trylock() and then call the ->lookup, but
> that can fail if there is a lookup attempt concurrent with the
> readdir().
>
> ovl cannot afford for the lookup to fail as that could produce incorrect
> results, and it cannot safely drop i_rwsem temporarily as that could
> introduce races with handling of the directory cache.
>
> Instead we rely on the fact that ovl_iterate() has an exclusive lock on
> the directory, so any concurrent lookup will wait for the ovl_iterate()
> call to complete.  We allocate a separate dentry and if the lookup is
> successful, it is hashed with the result.

Please document this assumption with:

rwsem_assert_held_write(&dir->d_inode->i_rwsem);

and comment in the code. Having it in the git commit message is not
enough for future code reviewers.

Other than that, I have no further comments, but I would like
to have a review from Miklos before this patch lands, because
I don't remember him reviewing any of the revisions and this is subtle.
I am a bit concerned that we have no test coverage for this subtle code.

>
> When the concurrent lookup gets i_rwsem it mustn't do its own lookup -
> it must use the existing dentry.  This is found, if it exists, using
> try_lookup_noperm().
>
> Signed-off-by: NeilBrown <neil@brown.name>
> ---
>  fs/overlayfs/namei.c   | 12 ++++++++++++
>  fs/overlayfs/readdir.c | 26 ++++++++++++++++++++++++--
>  2 files changed, 36 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index ca899fdfaafd..f56e33fd4d6b 100644
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
> +        * The existence of this in-lookup dentry might have forced
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
> index e7fe29cb6028..bc41da4bace8 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -574,8 +574,30 @@ static int ovl_cache_update(const struct path *path,=
 struct ovl_cache_entry *p,
>                 }
>         }
>         /* This checks also for xwhiteouts */
> -       this =3D lookup_one(mnt_idmap(path->mnt), &QSTR_LEN(p->name, p->l=
en), dir);
> -       if (IS_ERR_OR_NULL(this) || !this->d_inode) {
> +       this =3D d_alloc_trylock(dir, &QSTR_LEN(p->name, p->len));
> +       if (this =3D=3D ERR_PTR(-EWOULDBLOCK)) {
> +               /*
> +                * Some other thread is looking up this name and will
> +                * block on i_rwsem before it can complete the lookup.
> +                * We will do the lookup in a new dentry and when that
> +                * lookup gets a turn it will find and return this
> +                * dentry.
> +                */
> +               this =3D d_alloc_name(dir, p->name);
> +               if (!this)
> +                       this =3D ERR_PTR(-ENOMEM);
> +       }
> +       if (!IS_ERR(this) && d_unhashed(this)) {
> +               /* Either we got an in-lookup or we made our own unhashed=
 */
> +               struct dentry *alias =3D ovl_lookup(dir->d_inode, this, 0=
);
> +
> +               d_lookup_done(this);
> +               if (alias) {
> +                       dput(this);
> +                       this =3D alias;
> +               }
> +       }
> +       if (IS_ERR(this) || !this->d_inode) {
>                 /* Mark a stale entry */
>                 p->is_whiteout =3D true;
>                 if (IS_ERR(this)) {

How do you test your patch set? Do you have tests that exercise
parallel create/lookup/readdir?

It would be irresponsible to merge code without showing that the `alias`
branches have been exercised. Do you have an idea how to do that?

Thanks,
Amir.
