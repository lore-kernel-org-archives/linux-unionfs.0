Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E503D973
	for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2024 15:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705937496; cv=none; b=dHzqw+Vg+IMCuxNUtFzlKZBJA7tTP8Ew9k9pxvyg/ZSDg+ZoiXtqG4bdT+v0xzBiPcZ2GhQ1t+epw7sLuZbc0znCNHYQHFewhdCzA+udfMDAoJUgwfMEKh3VkR0PtGiGuPRceKkBYdfd1F7Pd3r9fFMiOLF35yg4wJ/rW0y69Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705937496; c=relaxed/simple;
	bh=nqgCESf/hca5zlU/ETCEbY5nYPp9nqXd9WLk61/RNEI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J6+q9ZsG/Sp5kILXJx+1rEV3zZxhC8MN25YtlOWlfGJhlXzdWEW5rtOKGy62brGrfJSvq9hNCkQHEK2KaJPmZ0B82NQF2Dlg5YjJrysar0EbikvRYAA2mX79YAUmbHZPYZuFo+xTt3dOhkh7soxGIUKX0OQRqO4IT834gNES9L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iDIzoegE; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iDIzoegE"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-68198aa2c7fso16918106d6.3
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2024 07:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705937493; x=1706542293; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KKI6a4Stt2TNR45vT1EnoK9wgbvyTb0OQrkkOyhNz8U=;
        b=iDIzoegEIWiHwBlpI9AXiezKfo7na3sLYfVY8oxbCi2MCQkwoNwdRIoZivPMNJWTYZ
         MNtpNITh+Mdr/C9cQ4auZ1fuHZcMaALQ8wimhVcGCIsC26triSmkLw3ckKIdjH9eh8kO
         M742L8dc2+7H1YyxoKsSdigzRzSxtZ67HFW/4u9tLgzEf5+Eu8NstzO1Z0DLhQGVQU62
         iZekLHY7gqMCRKx8HSJsP8JzujU4ipYDQ53wRA3k3iWkMsrIOHQctOt456xqzhD/FCh1
         46xsRBRY8Aeo98n2fdwqKVoLoufSeJIKom67GBXN5/NreUX+vewtvL9AiMCXUqShUIo6
         2q/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705937493; x=1706542293;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KKI6a4Stt2TNR45vT1EnoK9wgbvyTb0OQrkkOyhNz8U=;
        b=Oqx6j1dm7KxSCHaZE28I83mUOgoF7A15VNTlfSjoY+5CoekVRgBeeRxmAHEM/R0USj
         FkrKzWGaVbSvllwVRg2TiSqki0ScQ36iInUn7mIwFcgeJTm6NHdTr02+6oI0I3/Wuuci
         wrse0SKW2wY0g1ZeYx00IEUdqsXcs2/1adkQH9HHc5nP8OPRtSmHvYgjT5sAkdoF3DN1
         znhDhW31hcrFIrvDoB0XfzHhdeWy2Nb/jHA2ywAnZtI57csubRZfTRIySuzYd0BBpT4K
         EjCe84AoxIgw/FduR+6+N7k6eq3O4/6tCm5T0+1oMPLfBcFqKbMQaIhrXARHadBb1tan
         6f1Q==
X-Gm-Message-State: AOJu0YynYMfdMUPvuLKiQJAVQpluGcyOUR5Jec4+jd3Tr+LUVE0WcqIT
	+lsdFCHPjlVwBz8DZhA2h/rku1G2m7V16ppGoBD6XIOEAwgeOz5OSrh30IyYqAm3TuQmA3MNe9h
	HQNoa0gAjzGwuOlzmlicV9d95lSpBtw/iknOg5Q==
X-Google-Smtp-Source: AGHT+IGoHv3BPMY/LsdfLDzlnwrLrRn6St1kkn2P81UfOGZSwfMVx1XMZ2fokR4vyvgbg76wMjL6CDG4Z/9ygoODJQs=
X-Received: by 2002:a05:6214:29cb:b0:67f:30b2:4cf2 with SMTP id
 gh11-20020a05621429cb00b0067f30b24cf2mr6211769qvb.42.1705937493539; Mon, 22
 Jan 2024 07:31:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240121150532.313567-1-amir73il@gmail.com> <CAJfpeguGdxktdFrp4ChW3wpVv-A=3HBSNy5HRdG=41H8h-4_DA@mail.gmail.com>
 <CAOQ4uxjm-Di_R=BZi4eou79kJSMLOKkQ3qqvYjfMyEOYj52WHg@mail.gmail.com> <CAJfpegsQBqjACrnzRcv4TyXdRaWURgBDFXjzmiiKxBSGpZh69g@mail.gmail.com>
In-Reply-To: <CAJfpegsQBqjACrnzRcv4TyXdRaWURgBDFXjzmiiKxBSGpZh69g@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 22 Jan 2024 17:31:22 +0200
Message-ID: <CAOQ4uxgbNU1cDVar5zc0N=FeZmwaCptyHaEqJ9O-QGW0X-NkJw@mail.gmail.com>
Subject: Re: [PATCH v3] ovl: mark xwhiteouts directory with overlay.opaque='x'
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 22, 2024 at 3:35=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Mon, 22 Jan 2024 at 14:18, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Something like this looks ok?
> >
> > --- a/Documentation/filesystems/overlayfs.rst
> > +++ b/Documentation/filesystems/overlayfs.rst
> > @@ -145,7 +145,9 @@ filesystem, an overlay filesystem needs to record
> > in the upper filesystem
> >  that files have been removed.  This is done using whiteouts and opaque
> >  directories (non-directories are always opaque).
> >
> > -A whiteout is created as a character device with 0/0 device number.
> > +A whiteout is created as a character device with 0/0 device number or
> > +as a regular file with the xattr "trusted.overlay.whiteout".
>
> It should also refer to the "whiteouts and opaque directories" section.

ok.

>
> > +
> >  When a whiteout is found in the upper level of a merged directory, any
> >  matching name in the lower level is ignored, and the whiteout itself
> >  is also hidden.
> > @@ -154,6 +156,11 @@ A directory is made opaque by setting the xattr
> > "trusted.overlay.opaque"
> >  to "y".  Where the upper filesystem contains an opaque directory, any
> >  directory in the lower filesystem with the same name is ignored.
> >
> > +An opaque directory should not conntain any whiteouts, because they do=
 not
> > +serve any purpose.  A merge directory containing regular files with th=
e xattr
> > +"trusted.overlay.whiteout", should be additionally marked by setting t=
he xattr
> > +"trusted.overlay.opaque" to "x" on the merge directory itself.
>
> I think it's worth noting that this can have a performance impact on
> readdir, so people don't think xwhiteouts are a drop in replacement.
>

Ok, I will write something for v4.

> > Alex already did that:
> >
> > https://docs.kernel.org/filesystems/overlayfs.html#nesting-overlayfs-mo=
unts
>
> Indeed, thanks.
>
> > We do not currently have per-directory-per-layer flags in ovl_lowerstac=
k().
> >
> > Your patch was optimizing only per-layer check_xwhiteout.
> > My patch is optimizing only per-directory check_xwhiteout.
> >
> > The important thing is that for the common case (no xwhiteouts)
> > xwhiteout will never be checked.
> >
> > Are you concerned about optimizing check_xwhiteout in a multi lower
> > overlayfs nested over a composefs overlay mount for the case that
> > one of the merge dirs in the stack have xwhiteouts and the other do not=
??
> >
> > I guess we can use a combination of your patch (v2) and my patch (v3)
> > and do something like this:
> >
> >               if (last_element && !is_upper && val =3D=3D 'x') {
> >                        d->xwhiteouts =3D d->layer->xwhiteouts =3D true;
> >
> > ...
> >
> > to mark the dentry as OVL_E_XWHITEOUTS
> > AND mark the layer as having xwhiteouts
> > and then in readdir we check that
> > BOTH dentry has xwhiteouts (in some layer)
> > AND the layer has xwhiteouts (in some directory).
> >
> > Is that what you meant?
>
> I didn't think it through, but yeah, this sounds good.
>
> This way we can also remove the checks against layer not being upper
> and lowest, right?

I think we can.
Let me try this out.

Thanks,
Amir.
