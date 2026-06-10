Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63D53DEFF1
	for <linux-unionfs@vger.kernel.org>; Wed, 10 Jun 2026 11:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781090793; cv=pass; b=qmE8JdKAHcPb5ElU4TaSt8q2J//iAuRdoEukM1MhxOTRRbe+P2pJAR2mrPQr4yGT3kZwHtloLWGjd6s7UunGFoXMUfy+nviMfKkn8nbQID/sPexI88bN3Q5qevoP4TjyU6el84rDntoYmLCh+YVecoxUn2axgOgx8o6tDFyQpFU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781090793; c=relaxed/simple;
	bh=2aaujS1GBFRX6Q5jOjboaRMIxVZnOhhXsuUQ4jqqCOs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F85FcSniPq8hHiBAbfGbEqUtXLMNBlyg8nu+3sUM25XFozOF9GDvuJ459fTM7xoo0/NVlIVLG68AFuk3pPN8RJgMdDJI8GgvZJVfvhDaNslkK1exnnzpeFE/COLFP8alTye8WFRft2fY+LA27FXnnD6/QFd/+xhdiFnVxhNyg6o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=WKtdXB8j; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="WKtdXB8j"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8cce26ee1e9so99592616d6.2
        for <linux-unionfs@vger.kernel.org>; Wed, 10 Jun 2026 04:26:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781090791; cv=none;
        d=google.com; s=arc-20240605;
        b=LF7/CXVmfncTtG79Gm5hSYGFcjfn6r2QhhCGJAd36E9EvOE8g2IXqUW+7pp66iwQCg
         bf3/6vLtxCm2XRFYgKRFVyalM4zLJvkh+QnufnDqlgiulqh+D9mzW2tVUiYF7gXI7/yt
         4kEZGo7z94wA5Ynuxo+nzpt4uCefamnoeDp9hgUQ4xYuRTOeW+nuPo4KOrp5FUFcIZUW
         rIvH/7GRIUsfTWCvwsVw32bLJz0indi2UZ8VPqavsnNt4Vd1m+RNFtBY9sSxJtXQRrTZ
         PJx0Aj5kPI0+23gDkZFbR8EQ7xFn046BkvQpXk83EN2WTDMQBJTwJKkV2YQA1tWKxz5B
         MdtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KwpbCI+rGfMKsie1cbjw3OobD3YXJBn7+ixKB5TpcMI=;
        fh=lY853aLOhgRrmzBAddcylI0S12LkPWRg0lyAQZBfwe8=;
        b=kH16I3z319hz0Qf/krfp0TLoW/+P73BZOLOFSM+buBnh1nditazatV/HJlRXfP8fzT
         prWhgSQ2PRk1YU++96AYS78N0IAspPnwPvitQRR1B9dIPKRDauTpcy9gReMU67FgRS8H
         LEVCTtl4d9pwvTcFjfH/lJ5Hg/Ma53J3NXw0ldsQ5X8ZEBlAshK9w7TovPcOsq4BjZLn
         6s7D2OfnhITnueJgz4TGwUuGMJpIrpUEr/2LiuFFz6/jsE85iTrZrXb0b92cfERqRzTm
         ahoRb0OWF+FTGtv5UccoX36EzpEfq85mc7nRp6Dtnvr9H2IWeUJhcC6UNhCXbL/VF7iX
         3tvA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1781090791; x=1781695591; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KwpbCI+rGfMKsie1cbjw3OobD3YXJBn7+ixKB5TpcMI=;
        b=WKtdXB8jGww4N4vaXjc23iE//thOwpKiZebGM8NRULuWpKXCg2oaeLKChppes4SvYe
         K0VfHW4DvVHPdGoJulIZh9WxGkSjs56GqZBL019qzkf0R0dMCOrZQhm8+d5ghMsLb2M8
         4Kw7G42MJKBQ3sdTx4BcqULRpT+0leVUmBQho=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781090791; x=1781695591;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KwpbCI+rGfMKsie1cbjw3OobD3YXJBn7+ixKB5TpcMI=;
        b=pwxLVc6/GqCzfkFWWqu7/Hd2UCoRMuRlvjfJwISt/gtRpm6CxoJPLRyNjDpoqhplG5
         fGUiizA5AOU5eDhmlSgBr/nRMOgNT7gmeW7hXjw7q9SPUQ4bgW8jk7QCDdI5go1CCNeV
         VR+uI/4y7gzub2xEqZaS3ZQsRowRm7QVpAPm0ulsyC0VKhU1zxRxg8W9gGAO5AnogH3p
         yqkf7SkgwUOzRM9AE/o0Bw9RZYhL+hS2CgTUW6XotND7u30vPa/C38IlZTt0QSDQYteV
         43/ON1lz2sUpatg5/uoCqWI2KGO2STSL6iu4C6F3lfvNmPquUnt/D3sdUr/vn2ufJQep
         XP2g==
X-Forwarded-Encrypted: i=1; AFNElJ9BWLsjhFBuWkjO8AvxaqJPYERx5b97+SPFvge/Tq5xUMw4FxP1dQwJ3w4CslZ1mNSnw2Mlz2AspX6WEuLV@vger.kernel.org
X-Gm-Message-State: AOJu0YxEzPoNXlQiTfHheLGTYThBdttSU/JvKzlfnsrJUTM7hGy01lkz
	cbnRc4teEU4Jj+Bw20J1Uzw5iOZjM1duuLDC0EYwfCoV4pnZhItWdAnb3ba059AO5PE2ypQFwWw
	lHn5ELLI0fuzKswbc8SbstuOs3y2ciMxrQp6BbkkOpQ==
X-Gm-Gg: Acq92OGpjw+2tg3ZfPDmwEGtyqcxTRTsLu/9Z3AeRLAsVD9CPTEuuXB1rfLnkAdSXAx
	BHqPO/cZVpVvM3cawS7xX9cVIZ0aQMWpxQmnUVtkrIykR5SdZMrpDIXp/yW+g5M1cZ4fyH19+jV
	AVVkKFqLXSfKiRibS7KBCwi+7oNBs8/PQ5ALstc4SBAKcjtMfPAvzPgf7Z7TNjKE6GBBqxXO9W3
	TGjVri1NWDozPatU+WXrVMba8B9L7GbWE23/OFeuOLBdrQCyOsKwR3H8emThlYA8cOMRCrY1ZNc
	tqAb+iU/+l8VS9dw3vOgiMXHL5kGQpZ2L0peOj9FEcZYM32Z08Q=
X-Received: by 2002:ac8:57c2:0:b0:517:5f04:f24c with SMTP id
 d75a77b69052e-51795c79c8amr367684721cf.39.1781090790667; Wed, 10 Jun 2026
 04:26:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260501232735.2610824-1-souvik@amlalabs.com> <CAOQ4uxh6YUJEh75sASqi1gOaQYKpWhftz4to1j8s2Y9Jef-XQg@mail.gmail.com>
In-Reply-To: <CAOQ4uxh6YUJEh75sASqi1gOaQYKpWhftz4to1j8s2Y9Jef-XQg@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 10 Jun 2026 13:26:17 +0200
X-Gm-Features: AVVi8Cc5nyPpov-4yxMA02Z7Wm5x-BSYPxwNQXgevyHJGdk5NCb-4_ru_xxa7-U
Message-ID: <CAJfpegtnj0wmQ_mJCwJ+UKqzG_LTrUCwhRyc_NAhHj2T9Jr8uA@mail.gmail.com>
Subject: Re: [PATCH] ovl: use linked upper dentry in copy-up tmpfile
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Souvik Banerjee <souvik@amlalabs.com>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 3 May 2026 at 22:37, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Sat, May 2, 2026 at 1:27=E2=80=AFAM Souvik Banerjee <souvik@amlalabs.c=
om> wrote:
> >
> > ovl_copy_up_tmpfile() stores the disconnected O_TMPFILE dentry as the
> > overlay's upper dentry reference via ovl_inode_update().  vfs_tmpfile()
> > allocated this dentry via d_alloc(parentpath->dentry, &slash_name), so
> > d_name is "/" and d_parent is c->workdir.  Local upper filesystems
> > (ext4, btrfs, xfs, ...) immediately rename it to "#<inum>" via
> > d_mark_tmpfile() inside their ->tmpfile() op; FUSE and virtiofs do
> > not, so both fields stay that way.  Neither identifies the destination
> > directory and filename where ovl_do_link() actually linked the file.
> >
> > When the upper filesystem implements ->d_revalidate() (e.g. FUSE or
> > virtiofs), ovl_revalidate_real() calls it with the dentry's parent
> > inode and a snapshot of d_name.  The server tries to look up "/" inside
> > c->workdir, fails, and overlayfs reports -ESTALE.
> >
> > This causes persistent ESTALE errors for any file that was copied up vi=
a
> > the tmpfile path, breaking dpkg, apt, and other tools that do
> > rename-over-existing on overlayfs with a FUSE/virtiofs upper.
> >
> > Before commit 6b52243f633e ("ovl: fold copy-up helpers into callers"),
> > the tmpfile copy-up path used a dedicated helper ovl_link_tmpfile()
> > that captured the linked destination dentry returned by ovl_do_link():
> >
> >     err =3D ovl_do_link(temp, udir, upper);
> >     ...
> >     if (!err)
> >         *newdentry =3D dget(upper);
> >
> > and published it via ovl_inode_update(d_inode(c->dentry), newdentry).
> > The fold inlined ovl_do_link() into ovl_copy_up_tmpfile() but dropped
> > the dget(upper) capture, and rewrote the publish line as
> > ovl_inode_update(d_inode(c->dentry), dget(temp)) =E2=80=94 where temp i=
s the
> > disconnected O_TMPFILE dentry.
> >
> > Fix by keeping a reference to the linked destination dentry after
> > ovl_do_link() succeeds, and publishing that dentry at the existing
> > ovl_inode_update() call site.  The non-tmpfile/workdir path continues t=
o
> > publish the renamed temporary dentry.
> >
> > Reproducer:
> >   - Mount overlayfs with virtiofs (or a FUSE fs whose server advertises
> >     FUSE_TMPFILE) as upper
> >   - Run: dpkg -i <any .deb>
> >   - Observe: "error installing new file '...': Stale file handle"
> >
> > Fixes: 6b52243f633e ("ovl: fold copy-up helpers into callers")
> > Cc: stable@vger.kernel.org # v4.20+
> > Signed-off-by: Souvik Banerjee <souvik@amlalabs.com>
> > ---
> >  fs/overlayfs/copy_up.c | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index 13cb60b52bd6..e963701b4c87 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -853,7 +853,7 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_c=
tx *c)
> >  {
> >         struct ovl_fs *ofs =3D OVL_FS(c->dentry->d_sb);
> >         struct inode *udir =3D d_inode(c->destdir);
> > -       struct dentry *temp, *upper;
> > +       struct dentry *temp, *upper, *newdentry =3D NULL;
> >         struct file *tmpfile;
> >         int err;
> >
> > @@ -889,6 +889,14 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_=
ctx *c)
> >         err =3D PTR_ERR(upper);
> >         if (!IS_ERR(upper)) {
> >                 err =3D ovl_do_link(ofs, temp, udir, upper);
> > +               if (!err) {
> > +                       /*
> > +                        * Record the linked dentry -- not the disconne=
cted
> > +                        * O_TMPFILE dentry -- so that ->d_revalidate()=
 on
> > +                        * the upper fs sees the real parent/name.
> > +                        */
> > +                       newdentry =3D dget(upper);
> > +               }
> >                 end_creating(upper);
> >         }
> >
> > @@ -903,7 +911,7 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_c=
tx *c)
> >
> >         if (!c->metacopy)
> >                 ovl_set_upperdata(d_inode(c->dentry));
> > -       ovl_inode_update(d_inode(c->dentry), dget(temp));
> > +       ovl_inode_update(d_inode(c->dentry), newdentry);
> >
> >  out:
> >         ovl_end_write(c->dentry);
> > --
> > 2.51.1
> >
>
>
> Hi Souvik,
>
> Thank you for the analysis and the fix.
> Looks correct to me.
>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>
> Christian,
>
> Could you pick this up for vfs-fixes?
> I do not have any other ovl fixes queued up.

Reviewed-by: Miklos Szeredi <mszeredi@redhat.com>

This seems to have slipped through the cracks.

Christian?

Thanks,
Miklos
