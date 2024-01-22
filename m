Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6023CF42
	for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2024 13:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705929525; cv=none; b=iRdStqc48wqtng8uWHJoTq+HCpyumixVqnewHxYimiwYEYGWagDV+KHQOBbB0b8Sn380m0DNntAFfkj+MGaG6eiKybUwq5Qx9No+yklbAW726UWLN5HTGuBkAc9k7zrkXDUQ1CNfmwaSoVDpsaSwh0bAa/aDM/rArzhanqm/ons=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705929525; c=relaxed/simple;
	bh=vXGV5dMXsvNLf3JlKqIUWqbyPULJwJJdhJofoEej8Fo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qCmqlbHA9M9SijThmOdUIZXH/WxWE2iFkiw9/7vibYGHI1qQQoGFkpNsTRZCmK2jkfX/rh873Ekj3XIoQ2wvIWSVxLkNltUq5pINFnq47vDhHEUz5KDBzO2B6LrwKM8wHPvd2p3rjQT+ByD5RFnQtH1c+yM7qoFc1iogngFSORs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ISNWTr4J; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ISNWTr4J"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-78394b4e659so134856485a.0
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2024 05:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705929522; x=1706534322; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vB7GkRaHgMfKfN28kgjqr1PYJzweWMrn8S22P9nr+UQ=;
        b=ISNWTr4JteqniRslHZVSYRhrsMUuPY1bpPEt6mqI9zE2Hny4hC/9oFLGyIBUG0FN8M
         Bm9/KDEGLVu/rq5/2fnU656uoUkVZim3+EXJxQw5gE0InrF4ovfRWGeWy2OnMubhLlWX
         fVWHOu5h2TW4LQVQWjRywMGzw4RypEvAB1LA+AM3KDpgPmBdXfuxaImtgr+7YBH9iQ3b
         ex0/gYxFkbipOrhAhCEibek2KFeF9s28+uajHQTyMG0Kxt9i4SwO8QQaWRD2RC6bp9Op
         54XGPh9DEL/chX7mjQ69CTQYFr8cD84i9jfNjUHU4dmqjKmltwKMQLPa1139wTtz7mWL
         jVaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705929522; x=1706534322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vB7GkRaHgMfKfN28kgjqr1PYJzweWMrn8S22P9nr+UQ=;
        b=BxVOR4/z/UnKRFCaK/XgTRmoxFDfB1tl50kkJA9z/v7l9PSO6nh2L7QF1lx4vQp+iO
         ojRr1zTFXRN6FwX+SECJDobPlMAMSwbhN67o1g6jZjc5L9OYZsD8iqpaZOMRwvIhP6eP
         iZgw4qWNmGC4qLMAA6o8orFtrv2KbO6mPReT7KQD1KO3OiGDU9qU8FEBRfOuT0zD7Vc7
         A+b7y/oUB+H/f+/1b725epHvj8vuyu5GmZC/TPantTFdWHZbGBONLbC8P++Vf+Psa7AB
         OJSJhTq42iKPHoxExz0bobnQvMK+9Bfm13GuGy4qqo0fOjy6xJZ5uIbn2h9VTxK7JsE6
         ZrMQ==
X-Gm-Message-State: AOJu0Yyx8oYJHx54+0OpBqPsFspY7qaqhh0GJzQomerYz5xImFP02+vY
	Ii0FukSyf95f5xYWdfi4s9tWdEp9v7GA9GEst3HDoaQIxT6P/L6lkVSqyKoKG+DIzZX3XZJuNmg
	YFaAz1Bi3zo3fZQJb4SWfWmq4HCZr51lPaNPe8g==
X-Google-Smtp-Source: AGHT+IFGrBr69+AZf9dzW/3ga4eCjoRb/z0GG413t20SMUQrsRARL/suJBS993gqlaajBKnE4y7wFABawvqjCW/x4ok=
X-Received: by 2002:a05:6214:2687:b0:685:7c13:a0dc with SMTP id
 gm7-20020a056214268700b006857c13a0dcmr5984866qvb.61.1705929522304; Mon, 22
 Jan 2024 05:18:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240121150532.313567-1-amir73il@gmail.com> <CAJfpeguGdxktdFrp4ChW3wpVv-A=3HBSNy5HRdG=41H8h-4_DA@mail.gmail.com>
In-Reply-To: <CAJfpeguGdxktdFrp4ChW3wpVv-A=3HBSNy5HRdG=41H8h-4_DA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 22 Jan 2024 15:18:30 +0200
Message-ID: <CAOQ4uxjm-Di_R=BZi4eou79kJSMLOKkQ3qqvYjfMyEOYj52WHg@mail.gmail.com>
Subject: Re: [PATCH v3] ovl: mark xwhiteouts directory with overlay.opaque='x'
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 22, 2024 at 2:50=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Sun, 21 Jan 2024 at 16:05, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > An opaque directory cannot have xwhiteouts, so instead of marking an
> > xwhiteouts directory with a new xattr, overload overlay.opaque xattr
> > for marking both opaque dir ('y') and xwhiteouts dir ('x').
> >
> > This is more efficient as the overlay.opaque xattr is checked during
> > lookup of directory anyway.
> >
> > This also prevents unnecessary checking the xattr when reading a
> > directory without xwhiteouts, i.e. most of the time.
> >
> > Note that the xwhiteouts marker is not checked on the upper layer and
> > on the last layer in lowerstack, where xwhiteouts are not expected.
> >
> > Fixes: bc8df7a3dc03 ("ovl: Add an alternative type of whiteout")
> > Cc: <stable@vger.kernel.org> # v6.7
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Miklos,
> >
> > Alex has reported a problem with your suggested approach of requiring
> > xwhiteouts xattr on layers root dir [1].
> >
> > Following counter proposal, amortizes the cost of checking opaque xattr
> > on directories during lookup to also check for xwhiteouts.
>
> Concept looks good overall.
>
> overlayfs.rst needs updating with the new format.
>

Something like this looks ok?

--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -145,7 +145,9 @@ filesystem, an overlay filesystem needs to record
in the upper filesystem
 that files have been removed.  This is done using whiteouts and opaque
 directories (non-directories are always opaque).

-A whiteout is created as a character device with 0/0 device number.
+A whiteout is created as a character device with 0/0 device number or
+as a regular file with the xattr "trusted.overlay.whiteout".
+
 When a whiteout is found in the upper level of a merged directory, any
 matching name in the lower level is ignored, and the whiteout itself
 is also hidden.
@@ -154,6 +156,11 @@ A directory is made opaque by setting the xattr
"trusted.overlay.opaque"
 to "y".  Where the upper filesystem contains an opaque directory, any
 directory in the lower filesystem with the same name is ignored.

+An opaque directory should not conntain any whiteouts, because they do not
+serve any purpose.  A merge directory containing regular files with the xa=
ttr
+"trusted.overlay.whiteout", should be additionally marked by setting the x=
attr
+"trusted.overlay.opaque" to "x" on the merge directory itself.
+
 readdir
 -------

> BTW the nesting
> format should also be documented, but that's a separate patch.
>

Alex already did that:

https://docs.kernel.org/filesystems/overlayfs.html#nesting-overlayfs-mounts

> > @@ -292,7 +292,11 @@ static int ovl_lookup_single(struct dentry *base, =
struct ovl_lookup_data *d,
> >                 if (d->last)
> >                         goto out;
> >
> > -               if (ovl_is_opaquedir(OVL_FS(d->sb), &path)) {
> > +               /* overlay.opaque=3Dx means xwhiteouts directory */
> > +               val =3D ovl_get_opaquedir_val(ofs, &path);
> > +               if (last_element && !is_upper && val =3D=3D 'x') {
> > +                       d->xwhiteouts =3D true;
>
> Maybe I'm missing something, but can't we set the flag on the layer?
>

We do not currently have per-directory-per-layer flags in ovl_lowerstack().

Your patch was optimizing only per-layer check_xwhiteout.
My patch is optimizing only per-directory check_xwhiteout.

The important thing is that for the common case (no xwhiteouts)
xwhiteout will never be checked.

Are you concerned about optimizing check_xwhiteout in a multi lower
overlayfs nested over a composefs overlay mount for the case that
one of the merge dirs in the stack have xwhiteouts and the other do not??

I guess we can use a combination of your patch (v2) and my patch (v3)
and do something like this:

              if (last_element && !is_upper && val =3D=3D 'x') {
                       d->xwhiteouts =3D d->layer->xwhiteouts =3D true;

...

to mark the dentry as OVL_E_XWHITEOUTS
AND mark the layer as having xwhiteouts
and then in readdir we check that
BOTH dentry has xwhiteouts (in some layer)
AND the layer has xwhiteouts (in some directory).

Is that what you meant?

Would you like me to make this change?

Thanks,
Amir.
