Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FF01E5B60
	for <linux-unionfs@vger.kernel.org>; Mon, 28 Jul 2025 17:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753724398; cv=none; b=D01pKSJ0uXX3M18wpAs5z2KNPfNN6jxarwxrYC7HLwV4l8+mvPDp4edE8qlIxeoP77VGphK8CHeWv9QYyyLJNKqGf9H2gicYF6MshrGLaUF/iYsqMA4ER7WZYymLmWBxba2JF0VeYOm9+mT74CdgtTOBFMgvV4AqGTGV5U8WyFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753724398; c=relaxed/simple;
	bh=Y+kNUq4ZPRmkrX498AIodgGW8XPdbitOsOr4sY8+TV8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C2YwI7yMmj6iXTSCuSQ/TAv6gXIchTPhl8E1ESUyshB/lpEZAC713eEy0E387nsmJbzOJNtP4Vgnhkgepa2Z7CGilGVtQvXxz+Rs2utv+Korru5XHN9U+JXBkn0sxPTIP0Ef2ne3yZmXmnwJnrRcVN1SAuSmm4pryc4hobYUl1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WhWbuDJU; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WhWbuDJU"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aef575ad59eso752994466b.2
        for <linux-unionfs@vger.kernel.org>; Mon, 28 Jul 2025 10:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753724395; x=1754329195; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+qMN8+Un2GI5MA5S0SzMWTPtkp24QrVR24GLesrMPNU=;
        b=WhWbuDJU/xMS6CdJ4vCathj2SoVn+nx4ptDM7uFF/evdgR2TQg7qYcaUlRiW84/0ZC
         6L+aUxKMERZXtSzUZKi70iBFJmyC0eAbVTSH+MpC65iFC7OEfeh/D3vXIdk/hgs9yns9
         VHr0qCLWTasDqF8YNZTHxIBx9glUOwPtZvaarzvwP1BvP3avApgx/osHh7wSJdUiOBZR
         dfMy3FfdP8sX1Zl+92LvUcA4UcOgRFK4n7HPwOW9yjSLexlSDvD3dmO0BTds8Pdna2Lt
         +SLuPHw1nhh/kGPwzgm4hmkC32fWACqFztaLE63sNF3mA70nEEbwU++b7Kp4L0WYvVwj
         odFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753724395; x=1754329195;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+qMN8+Un2GI5MA5S0SzMWTPtkp24QrVR24GLesrMPNU=;
        b=am/lx6+wMQMjPjzLDVDCz50wHZa2h2daKb28V6h2lhr2awFU0ahrXgl6Bi60X/6PvC
         z8pA05456k2Fs0nY+VtFuPaA8BJy377sL3VCd30U2mxEtR1i70gp/HiyhQnkGaLthKfi
         B/lNQE41auC+3uAmlutm132NyVDfBHqU3aZslY1Rvin74vB289nbvEbq47Ggo1+hyMjv
         dOl6IDCrpI6v+ldh5WFFD+lXkdasJF320s/4XDyjV33cveKXAcQicpY9QOiDAbxb4Rq6
         8gAjTeB1/dA+MMkQSiJR+CvC+ZbesxWN+CnrlAOXDp7RmYVBh6ldRl1q9AuyflSvdKKj
         37bA==
X-Forwarded-Encrypted: i=1; AJvYcCUgtcHBoUOvKHDdJPh6Fl4jiVelXev8ocaJHKoQ81RiMewQlRw/qbpv3ZEfM/oLeqlaxf2bipRn+sSktRSC@vger.kernel.org
X-Gm-Message-State: AOJu0YxDcoORpS4bgIt6sVz04AdFhF4tBTtvOKvkp5+J9wuhLvN+JqPx
	UO3GwJ/UEKjfNlZLDopcn+lziRafFu2LtEKGI3ejtTSenf6HrVAok0f+IFN9olpGBcb493fLjZO
	xHQEcmqXslTCBa36DMa7KBN8G/qEDdLE=
X-Gm-Gg: ASbGnctC7c0YXaEDnt7bO1wwfPGUaWZyMLAdQplla+Gf1QrEPM4WyyueibkLBeRh3nM
	y3WdadU6Qrl+gDaZ5RclsPAwnQOPyWynbRPIAuYY7wViwkVw03Ty8RLI7hTpyTKxkxKTd836a2E
	kcy/tMhh4ObRUaBXHiXJqOsw9BnpoX6gkXdrgrNltWMoR+k9FSh+6xbmAsqaEkXcptIbfVX5n/h
	jdg8l77LsSMR7pt+w==
X-Google-Smtp-Source: AGHT+IFWgxPyKtFqr+5TJG3Wfp67jFvsGcMWFY5QMORCo1CTUSuLOP6WGkh0fT1Pr4tNjdNCgKu765sHg22EwR93PL8=
X-Received: by 2002:a17:907:3cc8:b0:adb:4342:e898 with SMTP id
 a640c23a62f3a-af61cd9dd85mr1431703266b.28.1753724394945; Mon, 28 Jul 2025
 10:39:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250721203821.7812-1-antonio@mandelbit.com> <542b0862-7f66-47ef-9ced-c66719842710@mandelbit.com>
 <CAOQ4uxiEBxFL1qD4p70UxjB67j9y8RX2r74LX5wDZ5aDDDZirw@mail.gmail.com> <a81e93e8-8292-4b8a-922d-15b770687f46@mandelbit.com>
In-Reply-To: <a81e93e8-8292-4b8a-922d-15b770687f46@mandelbit.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 28 Jul 2025 19:39:43 +0200
X-Gm-Features: Ac12FXxbz-J3C3LcAOYjYI3zhEPG1uv2LpUBVADFCrYc5aLOnqJja-jV90J-Gto
Message-ID: <CAOQ4uxgs+=-4KVaHZU2z1f57pC14NW0MYmj1Va81ftmRkASHkw@mail.gmail.com>
Subject: Re: [PATCH] ovl: properly print correct variable
To: Antonio Quartulli <antonio@mandelbit.com>
Cc: NeilBrown <neil@brown.name>, Miklos Szeredi <miklos@szeredi.hu>, 
	Christian Brauner <brauner@kernel.org>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2025 at 2:45=E2=80=AFPM Antonio Quartulli <antonio@mandelbi=
t.com> wrote:
>
> Hi,
>
> On 26/07/2025 20:27, Amir Goldstein wrote:
> > On Fri, Jul 25, 2025 at 10:33=E2=80=AFAM Antonio Quartulli
> > <antonio@mandelbit.com> wrote:
> >>
> >> Hi,
> >>
> >> On 21/07/2025 22:38, Antonio Quartulli wrote:
> >>> In case of ovl_lookup_temp() failure, we currently print `err`
> >>> which is actually not initialized at all.
> >>>
> >>> Instead, properly print PTR_ERR(whiteout) which is where the
> >>> actual error really is.
> >>>
> >>> Address-Coverity-ID: 1647983 ("Uninitialized variables  (UNINIT)")
> >>> Fixes: 8afa0a7367138 ("ovl: narrow locking in ovl_whiteout()")
> >>> Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
> >>> ---
> >>>    fs/overlayfs/dir.c | 5 +++--
> >>>    1 file changed, 3 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> >>> index 30619777f0f6..70b8687dc45e 100644
> >>> --- a/fs/overlayfs/dir.c
> >>> +++ b/fs/overlayfs/dir.c
> >>> @@ -117,8 +117,9 @@ static struct dentry *ovl_whiteout(struct ovl_fs =
*ofs)
> >>>                if (!IS_ERR(whiteout))
> >>>                        return whiteout;
> >>>                if (PTR_ERR(whiteout) !=3D -EMLINK) {
> >>> -                     pr_warn("Failed to link whiteout - disabling wh=
iteout inode sharing(nlink=3D%u, err=3D%i)\n",
> >>> -                             ofs->whiteout->d_inode->i_nlink, err);
> >>> +                     pr_warn("Failed to link whiteout - disabling wh=
iteout inode sharing(nlink=3D%u, err=3D%lu)\n",
> >>
> >> while re-reading this patch, I realized that the format string for
> >> PTR_ERR(..) was supposed to be %ld, not %lu...
> >>
> >> Sorry about that :(
> >
> > No worries, but its not %ld either. the error is an int.
>
> PTR_ERR() returns long - this is what the patch is printing.

Doesn't matter what PTR_ERR returns, this is conceptually an int
error code.

>
> >
> >>
> >> Neil should I send yet another patch or maybe this can be sneaked into
> >> another change you are about to send?
> >
> > Please test this fix suggested by Neil and send a patch to Christian.
> >
> > --- a/fs/overlayfs/dir.c
> > +++ b/fs/overlayfs/dir.c
> > @@ -116,10 +116,10 @@ static struct dentry *ovl_whiteout(struct ovl_fs =
*ofs)
> >                  inode_unlock(wdir);
> >                  if (!IS_ERR(whiteout))
> >                          return whiteout;
> > -               if (PTR_ERR(whiteout) !=3D -EMLINK) {
> > -                       pr_warn("Failed to link whiteout - disabling
> > whiteout inode sharing(nlink=3D%u, err=3D%lu)\n",
> > -                               ofs->whiteout->d_inode->i_nlink,
> > -                               PTR_ERR(whiteout));
> > +               err =3D PTR_ERR(whiteout);
> > +               if (err !=3D -EMLINK) {
> > +                       pr_warn("Failed to link whiteout - disabling
> > whiteout inode sharing(nlink=3D%u, err=3D%i)\n",
> > +                               ofs->whiteout->d_inode->i_nlink, err);
> >                          ofs->no_shared_whiteout =3D true;
> >                  }
> >          }
>
> Actually I think Neil was suggesting to make `err` local to the two
> blocks where it is currently used.
>
> This way the compiler would have caught its usage out of scope in the
> first place.
>
> It should be as listed below (including the format string fix).
> If you guys are fine with it, I'll send it as PATCH.
>

Sorry I do not like this suggestion.
I prefer not to reduce the scope of err var
and not have to define it twice.

Thanks,
Amir.

> Thanks!
>
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -80,7 +80,6 @@ struct dentry *ovl_lookup_temp(struct ovl_fs *ofs,
> struct dentry *workdir)
>
>   static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
>   {
> -       int err;
>          struct dentry *whiteout;
>          struct dentry *workdir =3D ofs->workdir;
>          struct inode *wdir =3D workdir->d_inode;
> @@ -91,7 +90,7 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
>                  inode_lock_nested(wdir, I_MUTEX_PARENT);
>                  whiteout =3D ovl_lookup_temp(ofs, workdir);
>                  if (!IS_ERR(whiteout)) {
> -                       err =3D ovl_do_whiteout(ofs, wdir, whiteout);
> +                       int err =3D ovl_do_whiteout(ofs, wdir, whiteout);
>                          if (err) {
>                                  dput(whiteout);
>                                  whiteout =3D ERR_PTR(err);
> @@ -107,7 +106,8 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs=
)
>                  inode_lock_nested(wdir, I_MUTEX_PARENT);
>                  whiteout =3D ovl_lookup_temp(ofs, workdir);
>                  if (!IS_ERR(whiteout)) {
> -                       err =3D ovl_do_link(ofs, ofs->whiteout, wdir,
> whiteout);
> +                       int err =3D ovl_do_link(ofs, ofs->whiteout, wdir,
> +                                             whiteout);
>                          if (err) {
>                                  dput(whiteout);
>                                  whiteout =3D ERR_PTR(err);
> @@ -117,7 +117,7 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs=
)
>                  if (!IS_ERR(whiteout))
>                          return whiteout;
>                  if (PTR_ERR(whiteout) !=3D -EMLINK) {
> -                       pr_warn("Failed to link whiteout - disabling
> whiteout inode sharing(nlink=3D%u, err=3D%lu)\n",
> +                       pr_warn("Failed to link whiteout - disabling
> whiteout inode sharing(nlink=3D%u, err=3D%ld)\n",
>                                  ofs->whiteout->d_inode->i_nlink,
>                                  PTR_ERR(whiteout));
>                          ofs->no_shared_whiteout =3D true;
>
>
>
> --
> Antonio Quartulli
>
> CEO and Co-Founder
> Mandelbit Srl
> https://www.mandelbit.com
>
