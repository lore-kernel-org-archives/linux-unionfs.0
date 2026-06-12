Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8CA3DA7C3
	for <linux-unionfs@vger.kernel.org>; Fri, 12 Jun 2026 07:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781250208; cv=pass; b=CwLIJsnpttZ6a3h4QflyDpE0+h3vXj8i9pvZPdafbFvybX9ZmpRwR3IhnTu2rjq7uFqyjSZLWEvaUfDvZE8eSb0HVbb7L0UdqbQpqve5T6xWLD8ZTtSlxHMT2nytGUY7w4G8fv451ez2op6oGM3hcu1C2+0WJLmJ/SQOiMtmZMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781250208; c=relaxed/simple;
	bh=VrH4UKHRvTmB/2CptIwHtfPA2ScYldlqyYcLfApLtK4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JIpvLBt5Ziw7e9YRZ3X9uHKkRkWsBZLSku0NvwhYQx0vs0qbJEqx65Sd0x3nWCVDzT95iACqYzszFZ9UFVs/jR0hVz9EmFkj2KaxdnkW81J/mOWXFLpsBMwOJRECkcijIXTQHc/r9kZkdFkJHANLpg4XtvX9rKxvKCNx8OYY1Cw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ShitvveZ; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ShitvveZ"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-68d232ed3f9so1119568a12.0
        for <linux-unionfs@vger.kernel.org>; Fri, 12 Jun 2026 00:43:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781250205; cv=none;
        d=google.com; s=arc-20240605;
        b=SLtWKLbBcwz9IBaRuM6CLTMDcF2ZWkMMSBXNJNvxGmx+lCIJPJ2KXxoD+nyrNErVno
         EMa0IS1FTVZbbXTD/kN7n7T/TZdH1jiOgU4CmLD/OjS0rnM4ofZu/3CrUDB09echCaxv
         aDZJ/qDjH6KSQ7/lnDDchuf0vF1eZplaoanFQz12YNSrH60grDO4DzmWkZqKV9wj0a50
         K7JFidslMQ9Ye0/AVxwIirYAjVjabEbVLqRTTYan+P7j43M9Q8xX1MJHZvdBH8HqV6iM
         xPHXf18GVxFryjBFj0cv9fVjQelsPTLAPLAJxfZB/mcVE4y/jdoAbZBWqG7+VmH44EYF
         Cf8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=un+XV168Qec4A0LpZpVP4rjWX9m0fs7Zzq7wZ4T4rgQ=;
        fh=sWyE+G8dALG8tPhLLlqvG1GEm07HhCfrWZyTtJ4GX2o=;
        b=dgyEq5BanOrGt/XYnInwMJroMDS2iR4KgUdQMnMbdT1ehIMAB2iEa/KwyjIKfxk4Ce
         MV25TlGBowwtrYZNix/PLeMzMusd+8oLaLxZUzszu7Nchh8A9D+WRX22P5La+XQzSyq7
         jCadIc/zcGqgIwHSuudCOSNbXGBw+8NYpCNUQW2IyZSBCeCtqjWEJ7x4f6l0ps7P3Pfw
         OnyXNESMpgqyYRSC2vkMrinnlUEjigoMWqAGLxW3oM3zWgm8Z5iMslmyhUsbEoZd4Wrp
         djYp13+rGgvC5Jjw8F+Mj/WzEb9keB0uh/5PGyWTDxbtIk2JmzbREOzFEVtgGzp72gGG
         FfPw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781250205; x=1781855005; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=un+XV168Qec4A0LpZpVP4rjWX9m0fs7Zzq7wZ4T4rgQ=;
        b=ShitvveZr6CwxzGJqA27RIoHbV4cCFHslOGbvbzwYxi+TFvfUXTLCLSBQKYR3mGCA/
         CMUug4YwdzgGNTY0LKITZtWwm+CXP4mquA2IC7d5MpaAMF7YkZcfOG02EoW1naHYb339
         Umbi4EyxBNxvKgBu29XFaNCxlcoAslKKc3x5+3+J6OOPXUPdOA2B0+VFXR6OByzTaGeN
         bhb5Y8RCrq3P9IlODJjbm9bPIiGiUYqh/oPgfTPQer5FisQwAEHbPmd0OV15829SXxLH
         Qx39jzLjR+exTPMTmq4MM1JDC8IS5Z/aPjzm2JoQXt7oCvQmlVG9V9qEPiyukb5jJK/B
         5x6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781250205; x=1781855005;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=un+XV168Qec4A0LpZpVP4rjWX9m0fs7Zzq7wZ4T4rgQ=;
        b=pxdLGm16dOsJDcv4idgmJEB0YVMbLLXoaGzN0ODMywIBiNA+zlkHwUqy7DXIEwr60w
         K2axThCeQK+pn+7k2S9IvMApIfjcAOQ68ny4lz6lVyMrATnGVockuoG0v9Vgd4PkqN5F
         HeFuX7dJ1o3Q5Zjc8QhBj/NRpKsJ28OTknvS2AF6p9iB4J+fjnpmSQ3GAagJPOXrt8xL
         t9svG9WCrLjHinzmoToiGs4zDyAT6KIrRnlVKqx4hIsbVKHZ1tB9sLFNo1Xt64zkPDzT
         11EvQUuEjy7wRRzT4jITdRu2l9NNtLyfDumnVyQd3Tr/rGAiIpe3M1TAvJSWp/JxnOXE
         78YQ==
X-Forwarded-Encrypted: i=1; AFNElJ9RQ4BFnA8twYMkIvTXyV7ZrXmexyvHyZ9QQ3Cux24pWCqNwlA5BqrVgoGbgdqhQ1znrl15c8Gr+DOnIWsL@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9frAPa34UCCwxnK3f2h/jzoIR4j9JCo9dEGS3awi228YxAEs4
	+KbD0wP57jtNr22IocXFsVcaW04xOwjGx49w6uSAuZUicSi7gXyJNgDDBV9n+hBP4SsXG7m0Ywu
	xjmtV9vA7i/RoEZjfAtfDqSCLHNhLjJ66XDlt+lw=
X-Gm-Gg: Acq92OHtCl9hBnCYDSP80DShQ64P3CsEpeGInGLEkyrjSOnR4DgsDjYQ21MZpftOyEG
	nHtBWrD2EhouuCVmOeCIklkxesytRLqJdpyDm1161H9Xri21aCHD2Oy3M7eAZkfciD6RsbeU6ji
	GkyVRtr7T5glRiO0RnVJ9R9K/axdFpfxUZ56lWGvhb7m9HrIICNCmMo0AsQSGCBnB79xntc68wy
	nhwvzzrYK5Kjnw+cQHPl3W6U9Q7HZqbIr6/7h3YfivIB11EVnnnLpaIsOLVTHoiGqPLEey7Jt6u
	JplmX3NFbU8PV5WFVSQDH8XfGNZznsQG40F1SVmv
X-Received: by 2002:a05:6402:3891:b0:691:affa:38da with SMTP id
 4fb4d7f45d1cf-693784f79d7mr698652a12.1.1781250204504; Fri, 12 Jun 2026
 00:43:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260501232735.2610824-1-souvik@amlalabs.com> <CAOQ4uxh6YUJEh75sASqi1gOaQYKpWhftz4to1j8s2Y9Jef-XQg@mail.gmail.com>
 <CAJfpegtnj0wmQ_mJCwJ+UKqzG_LTrUCwhRyc_NAhHj2T9Jr8uA@mail.gmail.com>
In-Reply-To: <CAJfpegtnj0wmQ_mJCwJ+UKqzG_LTrUCwhRyc_NAhHj2T9Jr8uA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 12 Jun 2026 09:43:12 +0200
X-Gm-Features: AVVi8Cfsd00rG_CuZ-3XJb7ocjHsCW2AA5Bpj46lwTBlumbSNluLhGMMoUvO0ww
Message-ID: <CAOQ4uxiv7yKyuLX_cTdu6f_Gnzk4XR+R4NAuTa_kDhJRV7i=ig@mail.gmail.com>
Subject: Re: [PATCH] ovl: use linked upper dentry in copy-up tmpfile
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>, Souvik Banerjee <souvik@amlalabs.com>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 10, 2026 at 1:26=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Sun, 3 May 2026 at 22:37, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Sat, May 2, 2026 at 1:27=E2=80=AFAM Souvik Banerjee <souvik@amlalabs=
.com> wrote:
> > >
> > > ovl_copy_up_tmpfile() stores the disconnected O_TMPFILE dentry as the
> > > overlay's upper dentry reference via ovl_inode_update().  vfs_tmpfile=
()
> > > allocated this dentry via d_alloc(parentpath->dentry, &slash_name), s=
o
> > > d_name is "/" and d_parent is c->workdir.  Local upper filesystems
> > > (ext4, btrfs, xfs, ...) immediately rename it to "#<inum>" via
> > > d_mark_tmpfile() inside their ->tmpfile() op; FUSE and virtiofs do
> > > not, so both fields stay that way.  Neither identifies the destinatio=
n
> > > directory and filename where ovl_do_link() actually linked the file.
> > >
> > > When the upper filesystem implements ->d_revalidate() (e.g. FUSE or
> > > virtiofs), ovl_revalidate_real() calls it with the dentry's parent
> > > inode and a snapshot of d_name.  The server tries to look up "/" insi=
de
> > > c->workdir, fails, and overlayfs reports -ESTALE.
> > >
> > > This causes persistent ESTALE errors for any file that was copied up =
via
> > > the tmpfile path, breaking dpkg, apt, and other tools that do
> > > rename-over-existing on overlayfs with a FUSE/virtiofs upper.
> > >
> > > Before commit 6b52243f633e ("ovl: fold copy-up helpers into callers")=
,
> > > the tmpfile copy-up path used a dedicated helper ovl_link_tmpfile()
> > > that captured the linked destination dentry returned by ovl_do_link()=
:
> > >
> > >     err =3D ovl_do_link(temp, udir, upper);
> > >     ...
> > >     if (!err)
> > >         *newdentry =3D dget(upper);
> > >
> > > and published it via ovl_inode_update(d_inode(c->dentry), newdentry).
> > > The fold inlined ovl_do_link() into ovl_copy_up_tmpfile() but dropped
> > > the dget(upper) capture, and rewrote the publish line as
> > > ovl_inode_update(d_inode(c->dentry), dget(temp)) =E2=80=94 where temp=
 is the
> > > disconnected O_TMPFILE dentry.
> > >
> > > Fix by keeping a reference to the linked destination dentry after
> > > ovl_do_link() succeeds, and publishing that dentry at the existing
> > > ovl_inode_update() call site.  The non-tmpfile/workdir path continues=
 to
> > > publish the renamed temporary dentry.
> > >
> > > Reproducer:
> > >   - Mount overlayfs with virtiofs (or a FUSE fs whose server advertis=
es
> > >     FUSE_TMPFILE) as upper
> > >   - Run: dpkg -i <any .deb>
> > >   - Observe: "error installing new file '...': Stale file handle"
> > >
> > > Fixes: 6b52243f633e ("ovl: fold copy-up helpers into callers")
> > > Cc: stable@vger.kernel.org # v4.20+
> > > Signed-off-by: Souvik Banerjee <souvik@amlalabs.com>
> > > ---
> > >  fs/overlayfs/copy_up.c | 12 ++++++++++--
> > >  1 file changed, 10 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > > index 13cb60b52bd6..e963701b4c87 100644
> > > --- a/fs/overlayfs/copy_up.c
> > > +++ b/fs/overlayfs/copy_up.c
> > > @@ -853,7 +853,7 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up=
_ctx *c)
> > >  {
> > >         struct ovl_fs *ofs =3D OVL_FS(c->dentry->d_sb);
> > >         struct inode *udir =3D d_inode(c->destdir);
> > > -       struct dentry *temp, *upper;
> > > +       struct dentry *temp, *upper, *newdentry =3D NULL;

This init is not needed and confusing because never in this function
using a NULL newdentry is correct.
We rather get an uninit variable warning if that happens in the future.

> > >         struct file *tmpfile;
> > >         int err;
> > >
> > > @@ -889,6 +889,14 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_u=
p_ctx *c)
> > >         err =3D PTR_ERR(upper);
> > >         if (!IS_ERR(upper)) {
> > >                 err =3D ovl_do_link(ofs, temp, udir, upper);
> > > +               if (!err) {
> > > +                       /*
> > > +                        * Record the linked dentry -- not the discon=
nected
> > > +                        * O_TMPFILE dentry -- so that ->d_revalidate=
() on
> > > +                        * the upper fs sees the real parent/name.
> > > +                        */
> > > +                       newdentry =3D dget(upper);
> > > +               }
> > >                 end_creating(upper);
> > >         }
> > >
> > > @@ -903,7 +911,7 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up=
_ctx *c)
> > >
> > >         if (!c->metacopy)
> > >                 ovl_set_upperdata(d_inode(c->dentry));
> > > -       ovl_inode_update(d_inode(c->dentry), dget(temp));
> > > +       ovl_inode_update(d_inode(c->dentry), newdentry);
> > >
> > >  out:
> > >         ovl_end_write(c->dentry);
> > > --
> > > 2.51.1
> > >
> >
> >
> > Hi Souvik,
> >
> > Thank you for the analysis and the fix.
> > Looks correct to me.
> >
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> >
> > Christian,
> >
> > Could you pick this up for vfs-fixes?
> > I do not have any other ovl fixes queued up.
>
> Reviewed-by: Miklos Szeredi <mszeredi@redhat.com>
>

I applied the patch without this init to NULL to ovl-fixes, so that it
will be in linux-next.
Kept your RVB. Hope that's ok.

> This seems to have slipped through the cracks.
>
> Christian?

I don't think it is particularly urgent to merge this patch for 7.0
this late in the cycle, so I will hold off on sending an ovl-fixes PR.

Christian,

If you take this ovl fix (and the other one [1]) to vfs-7.2.misc
let me know and I will remove them from ovl-fixes.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-unionfs/20260609184656.1916631-1-amir73il=
@gmail.com/
