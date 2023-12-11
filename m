Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iEJ6RHjC"
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB250D5;
	Sun, 10 Dec 2023 22:47:42 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id 6a1803df08f44-67a338dfca7so31581836d6.2;
        Sun, 10 Dec 2023 22:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702277262; x=1702882062; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ahj3xPAOvkfJO7zgy7vthTdNzIyPpQXutD5MkcdgZ9s=;
        b=iEJ6RHjCRSXRUS9mAFdVVisEYM8dz/yue21YppFYFhZG51eQ/DcR1Qbl8/AMUYev+2
         +NycYRxFlAeBpPlFLdP+Fb+FQkgBHnqjFCJ2vEr0hFuW05hzeg0a5gWymC6dDEjNTM7T
         bTJlocXaoRtTQQ+FZm2kTKejjam+pe2pI8hL3VRNDfyVNgxK2IO0XFBN0E1Iqc/MMADr
         zbsc/yfvF+R4JOu15REfXchZKbZRZDAxzONrGuhy+yS7L9UMvu3a2//TwLwLvAzG53q7
         ay6mzy8HM0eeDx1jmWQ3lR24bSXsefDBiAmJj+7bsHhULRkeIDgYX7o28StxCS2j5jew
         RoSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702277262; x=1702882062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ahj3xPAOvkfJO7zgy7vthTdNzIyPpQXutD5MkcdgZ9s=;
        b=GgeYPVp2WgG9jZ2Ya041Zk6NFoMyEOPJsG8he1zgFgEpIzzVc9mVFKUcRmxnB+7rK5
         3LIfN8gyivW3Lu4u1af+aMHr0/8Gl4GYb96VtLA4HkYnkzQfZ0LZNMb1zeo9E2o3JKdr
         qWkX5FwuBGe+xTDWMX1NoUPgnKMJTX9VFD58lOAvZEFbzZxsc0v3bwDyxj05JSgX6zN0
         6YVBY650yNbmF8jBI93dgRIEFvMf6MtINkf4f3DPpXDRCpsc2VjJ4AQLEwRPf7Hchwfo
         fr1+wMvOyAw36egWnBTn3ZxKroAPVk2/pkueBkHBwxVEaRVq+ZRDDoJEDW7PFAnDwhW9
         QqoQ==
X-Gm-Message-State: AOJu0YxI09W0z4E8H96648wKYoJTk6AKGB4LEx/pYKYjLHcELT6WjFAU
	vp4uajLLvJ5KjguBdT7xHF4GdgzAeHYMg/xY8xX+ig4m
X-Google-Smtp-Source: AGHT+IF5TfrZV0twBcbE0rJVSek0qOZ8pHKrg+5v0ErRm7P1d7SonCIcI+rp0D+EjBZJD8ux2FttGeFpJ54BomFqW0E=
X-Received: by 2002:a0c:c482:0:b0:67a:a721:f311 with SMTP id
 u2-20020a0cc482000000b0067aa721f311mr4867654qvi.81.1702277261845; Sun, 10 Dec
 2023 22:47:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231204185859.3731975-1-amir73il@gmail.com> <20231204185859.3731975-2-amir73il@gmail.com>
 <20231210133526.ei7thr54dff6zjbz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxgkb4XfStSZkK0ZLk0tAdN60rf5YCMhaXrHzm-wJsP6hg@mail.gmail.com> <20231210204503.poggjg4z57eg2nn7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20231210204503.poggjg4z57eg2nn7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 11 Dec 2023 08:47:30 +0200
Message-ID: <CAOQ4uxhqPzDYtws2_13cLUpb+yVFmM2_SOZwwpHhPH3ZNmZhNw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] overlay: Add tests for nesting private xattrs
To: Zorro Lang <zlang@redhat.com>
Cc: Alexander Larsson <alexl@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 10, 2023 at 10:45=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrot=
e:
>
> On Sun, Dec 10, 2023 at 05:28:34PM +0200, Amir Goldstein wrote:
> > On Sun, Dec 10, 2023 at 3:35=E2=80=AFPM Zorro Lang <zlang@redhat.com> w=
rote:
> > >
> > > On Mon, Dec 04, 2023 at 08:58:56PM +0200, Amir Goldstein wrote:
> > > > If overlayfs xattr escaping is supported, ensure:
> > > >  * We can create "overlay.*" xattrs on a file in the overlayfs
> > > >  * We can create an xwhiteout file in the overlayfs
> > > >
> > > > We check for nesting support by trying to getattr an "overlay.*" xa=
ttr
> > > > in an overlayfs mount, which will return ENOSUPP in older kernels.
> > > >
> > > > Signed-off-by: Alexander Larsson <alexl@redhat.com>
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > ---
> > >
> > > Hi Amir,
> > >
> > > This test passed with below kernel configuration at first:
> > >   CONFIG_OVERLAY_FS=3Dm
> > >   # CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
> > >   CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=3Dy
> > >   # CONFIG_OVERLAY_FS_INDEX is not set
> > >   # CONFIG_OVERLAY_FS_XINO_AUTO is not set
> > >   # CONFIG_OVERLAY_FS_METACOPY is not set
> > >
> > > But then I found it fails if I enabled below configurations:
> > >   CONFIG_OVERLAY_FS_REDIRECT_DIR=3Dy
> > >   CONFIG_OVERLAY_FS_INDEX=3Dy
> > >   CONFIG_OVERLAY_FS_XINO_AUTO=3Dy
> > >   CONFIG_OVERLAY_FS_METACOPY=3Dy
> > >
> > > Without these configures, this test passed. But with them, it fails a=
s [1].
> > > The underlying fs is xfs (with default mkfs options), there're not sp=
ecific
> > > MOUNT_OPTIONS and MKFS_OPTIONS to use.
> > >
> > > I'll delay merging this patchset temporarily, please check.
> > >
> >
> > good spotting!
> >
> > Here is a fix if you want to fix and test it in your tree:
> >
> > diff --git a/tests/overlay/084 b/tests/overlay/084
> > index ff451f38..8465caeb 100755
> > --- a/tests/overlay/084
> > +++ b/tests/overlay/084
> > @@ -50,9 +50,10 @@ test_escape()
> >
> >         echo -e "\n=3D=3D Check xattr escape $prefix =3D=3D"
> >
> > -       local extra_options=3D""
> > +       # index feature would require nfs_export on $nesteddir mount
> > +       local extra_options=3D"-o index=3Doff"
> >         if [ "$prefix" =3D=3D "user" ]; then
> > -            extra_options=3D"-o userxattr"
> > +            extra_options+=3D",userxattr"
> >         fi
> >
> >         _scratch_mkfs
> > @@ -146,9 +147,10 @@ test_escaped_xwhiteout()
> >
> >         echo -e "\n=3D=3D Check escaped xwhiteout $prefix =3D=3D"
> >
> > -       local extra_options=3D""
> > +       # index feature would require nfs_export on $nesteddir mount
> > +       local extra_options=3D"-o index=3Doff"
> >         if [ "$prefix" =3D=3D "user" ]; then
> > -            extra_options=3D"-o userxattr"
> > +            extra_options+=3D",userxattr"
>
> It works, so it's about the CONFIG_OVERLAY_FS_INDEX=3Dy.

Yes.

the nested overlayfs setup requires that either the inner
overlayfs has nfs_export enabled, as is done in tests
overlay/068,069,070,071
or that the outer overlayfs has index disabled.
The latter is easier for this test, because there is no need
for the index feature in these test cases.

> I've released fstests
> v2023.12.10 version, this patchset will be in next release. Will send a n=
ew
> version with this change?
>

Ok, I will send a new version of test 084.

Thanks,
Amir.
