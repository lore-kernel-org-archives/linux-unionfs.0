Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC7A1F2BAD
	for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 14:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763043428; cv=none; b=GvrRC0DHurFJ36kU1DYwmsQv+Nx5j71EjNNLyR28etC26pp6lDaLa3ddE2VQ8rlLVH0ZB7vS3DWJa1TARuLbbnyTe4XENW0Kvkr0sNUu27M/E/Wc8qm7mhqMzD8Gfvq4hbGu7agSbayVfGvBhXvAOxanvDzFrpj0iB3a6NlI6kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763043428; c=relaxed/simple;
	bh=ifIKSHrKuO2Pld3ZI0baMsAtJwYUfHddyW3/tMDWO5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mQ91xSGKXGIbVyDiuF694j2Kn+y2324Lhheo4Uc9DTOj9SdaZlAlaptI5nssVjoLnvvZ4Hwtjq5zTwwvMzJvw6oK+bBnLvzFDmqbZaYuEFBIqK2MS51q9CNWJpMuM4wVOlLvXLsi5Jnsie9ylXVOtgHe6X94Svmf4jl1BINcwNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VjRy/Ggi; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VjRy/Ggi"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b735487129fso110483566b.0
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 06:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763043424; x=1763648224; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kf7ThiMraNwXowWFJz0pBJSyHZFbZPMESpkLpsWy2Sk=;
        b=VjRy/GgiHqFxuipWKjxvjbx0Y/98PGSrUSpkRnt+CK7HUiKOdqkPQP4EKki7QH5TEj
         marXrnuSJx/zkB+r5krSWkRMddn9eBHyWvSR9/HP8z4BqDPcyzI/DFGBow3Q3gvsGW9t
         toRyiOAmqJT8oV7O7RudIyzRfNctUm/WGA3AO9t7kKkEugs1E28F4YaP/KYUUlqYsSIC
         EadCm0kfnHd24nxvB9wmcQYDd9V+q2czwmtYejtAHtWffFESKFR/dvyRAYyh0uoQvdeP
         0zrBOahQ+QfOHMGrPeij8PexmOUjab4oignII28MDPPCtXGfyQpwfKZBHD/o/KaZX4pv
         oeig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763043424; x=1763648224;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kf7ThiMraNwXowWFJz0pBJSyHZFbZPMESpkLpsWy2Sk=;
        b=xB3Xg7nppAyAkjAHp73ygP8KzoEzOIi3P/7fifgOexQlsut38H+vWKgxhSq63UVSg3
         7H6eVaslCEZ8hDHS2Jw4RbMAfgU9f2M0YP3M3yuB4YpZQbzyq/Dcggoz47qp7ZhKoGV9
         zZqtRDJ2TC8Md6eH5drH1Vof3WKFU/EZysjo1fcIQZMBzgNMLPJ/ZEnw6CanMkkExXQc
         tgfGOO2mEEJmK+z1JFI2c8rsWYySKyLgXqVPMNUPfroxUCmWHeD4Bq7z84ynI7dI9rGs
         dnwXyR+FdceGWk+foGg6UBYhrFLzp8kN/LtnO5Za0kza3gI505lY+RG2ajei0vQFirE+
         GEpw==
X-Forwarded-Encrypted: i=1; AJvYcCVUTgpSwebZ7I/fa6v5wG7G0n84XlhaYkxlHSruvmytrq9I6v2F2aO/Td+TmuP82O02HRxAOZp9KdEM9rnM@vger.kernel.org
X-Gm-Message-State: AOJu0YxrXB4L2/5B2S5+qZsJjR/BiQNwFUDIgVaSTL/bL5BusR6jF1Cq
	QdRvC98xng+gNWQv0SZZ3A9UTDXtpFNOMi4fw24mCyxvdqzpUaXvYmFQKtLG74BRaPh96xrB4h9
	MlEcWzqwRUU9f1un8RJexKk4TI5gTEmBjB5H0ap+DgA==
X-Gm-Gg: ASbGncsV9glNgMbmTaBMfMHXEq9JxhCq8EiX9ZZxg+Ev0ct/ztOIB1rSRRux5dYW47B
	TCr07LfXXkaQw3ig23zFBsfLgvPv0Hpe9Q/mjBcY7jnbWxAVD3h7dBcPT5pnQp/UUTFv2gtHM01
	sTi0DG2Bqi1KMYN4ML5KnsLhliU5lul2G83jYCaP63l1NvYVyaZeSXIWqjo8cvxkpI0Azz+xSKZ
	jBo8f2vgtfHRrpTwnjE3ARBDWzrT005dEIB1XhKsswJDhYVtC9nUKoPoP1F9v9TyKbFkTTQX5dL
	OWtxOdBWY3csYx+BSOE=
X-Google-Smtp-Source: AGHT+IHrMpN3dAJN01UM4KDGYImAmUKLICqul1xRJJTCBTR0/RZhatHzml6fh8lgTpLMp0+E4abJcnCzzxNfFslHWII=
X-Received: by 2002:a17:906:6a1b:b0:b70:df0d:e2e9 with SMTP id
 a640c23a62f3a-b7331aa2724mr682956066b.44.1763043423337; Thu, 13 Nov 2025
 06:17:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113-work-ovl-cred-guard-v1-0-fa9887f17061@kernel.org>
 <20251113-work-ovl-cred-guard-v1-3-fa9887f17061@kernel.org>
 <CAJfpegt9LQe_L=Ki0x6G+OMuNhzof3i4KAcGWGrDNDq3tBfMtA@mail.gmail.com> <20251113-laufleistung-anbringen-831f25218d61@brauner>
In-Reply-To: <20251113-laufleistung-anbringen-831f25218d61@brauner>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 13 Nov 2025 15:16:52 +0100
X-Gm-Features: AWmQ_bk0g7Zh7feMbKmFC_jX1W9SvL7N2ZAFWsrsyXhWa-GhNehAwVb0sghOIFU
Message-ID: <CAOQ4uxhRaYZALD0o46-=nP+VP2BY7Egtp+j33vrMDGfOV7beQQ@mail.gmail.com>
Subject: Re: [PATCH RFC 03/42] ovl: port ovl_create_or_link() to cred guard
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 2:45=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Thu, Nov 13, 2025 at 02:31:27PM +0100, Miklos Szeredi wrote:
> > On Thu, 13 Nov 2025 at 14:02, Christian Brauner <brauner@kernel.org> wr=
ote:
> > >
> > > Use the scoped ovl cred guard.
> >
> > Would it make sense to re-post the series with --ignore-space-change?
>
> Yeah, I can do that for sure!

While on the subject of making patches easier to review, I often use forwar=
d
declarations in refactoring patches like this one:

+struct ovl_renamedata {
+       struct renamedata;
+       struct dentry *opaquedir;
+       struct dentry *olddentry;
+       struct dentry *newdentry;
+       bool cleanup_whiteout;
+};
+
+static int do_ovl_rename(struct ovl_renamedata *ovlrd, struct list_head *l=
ist);
+
 static int ovl_rename(struct mnt_idmap *idmap, struct inode *olddir,
                      struct dentry *old, struct inode *newdir,
                      struct dentry *new, unsigned int flags)
 {
        int err;
-       struct dentry *old_upperdir;
-       struct dentry *new_upperdir;
-       struct dentry *olddentry =3D NULL;
-       struct dentry *newdentry =3D NULL;
-       struct dentry *trap, *de;
-       bool old_opaque;
-       bool new_opaque;
-       bool cleanup_whiteout =3D false;
        bool update_nlink =3D false;
...
+static int do_ovl_rename(struct ovl_renamedata *ovlrd, struct list_head *l=
ist)
+{
+       struct dentry *old =3D ovlrd->old_dentry;
+       struct dentry *new =3D ovlrd->new_dentry;
+       struct ovl_fs *ofs =3D OVL_FS(old->d_sb);
+       unsigned int flags =3D ovlrd->flags;
+       struct dentry *old_upperdir =3D ovl_dentry_upper(ovlrd->old_parent)=
;
+       struct dentry *new_upperdir =3D ovl_dentry_upper(ovlrd->new_parent)=
;
+       bool samedir =3D ovlrd->old_parent =3D=3D ovlrd->new_parent;



To make review of refactoring much easier.
Otherwise, the refactoring patch review becomes a review of deleted
and added code which is
not easy at all.

Thanks,
Amir.
