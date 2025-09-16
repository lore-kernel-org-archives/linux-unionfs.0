Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E992F266B40
	for <linux-unionfs@vger.kernel.org>; Tue, 16 Sep 2025 13:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758029390; cv=none; b=McoTn31BHgSfaiy/JQyEyBR1DXxz/pO22PYRSCkkm5SrNpTv4gnbbLmUoxYeLl32k6htzrz1n2tRNQR6DFz/KYM2h39etc6qfdgekZS58LCdqcjKgx6jSNTNfXdP659YqwSCVgTOv1sOv61Oew3g3maLDRbfQJhWcHgjX4cXch0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758029390; c=relaxed/simple;
	bh=/dlRa3fJmDKHfHaLN7gvlMCOjbtBNW/Z1+IbKo1HKVw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Op00WmZYdUWgl5pxXhemTragN4eWFfZ/k0G4+7e/bEzLIrEx92Kjz0yb6a4ESYUVeZ+gUl9qgZsDgUdyPB1JtM2PLS1xZpDIBC/BGyL7ffv5pKkSVBGRhr+I2XAoQTxFvRx4jzh228XO3QXcydfKVFBSyFIpW+736dbMBO7FbTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YpzVsbJn; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YpzVsbJn"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-61cc281171cso9191895a12.0
        for <linux-unionfs@vger.kernel.org>; Tue, 16 Sep 2025 06:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758029387; x=1758634187; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8nUBl38KozCd2EM6dPQpNsN7WfMcH/uyK4YoPI5ee8s=;
        b=YpzVsbJnoFX/l+brAgnsXam5Tq79FkQm5NERsg2M3IMIz1h5/8wmAlaHgwd7M88rN8
         I3al5vkyhDoy4R8wnOfNTyUDjt54ABRBWy3znkYemO0ClP8TSo2B3UMbcFC28Z5W26a7
         xNsha9PDLH19lqhbbMV7R7cRVWTSJ5pjR9TN6KlRymBQh/GCUEqgrbD3DXpJTbJdmVOU
         ZRIeoixcXZ+NkL656p8AB4BJPJjxGLvDifEKq5ZEHLM4fCBSBlDWIKUEu0iIiuPtcUGl
         O2XAdmERgavlDO92bx9XqAnPn6pHZItVz1rnvRoHhNe4bqZ1tBZIUbgsTxbiIqz8kO5l
         d3nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758029387; x=1758634187;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8nUBl38KozCd2EM6dPQpNsN7WfMcH/uyK4YoPI5ee8s=;
        b=KxWjTu2VBIQjz58dRY3n2mjWtWS5wd6Fw0AVV0g9c09OziTZDBLEPW/3brD1EGH5tk
         Pup4lobomTfga4we+Hqef/emeJlSWTNJkoFRkEV16WSQbdPAc/z0YYCg9XekXIuaqs61
         rJ0MFzWXPwlfEDb5X2/EkKbYqR2aKq2pdQaUMbWi3s1t5K8bNcJD6mzFwiOXwsSTajAu
         HXMXmdZyFFM3Dn26qs80KAiVGRfwfY2og27SbzVExr8xjGd0aNYlmRpQDbRGRasUSPYQ
         R+/s5J9y0qNlA4GlzYo1+/l9lsVJQtDM06vdqYHuU9FbSYqbnVfj67o8OosxWZCFF5cD
         /oqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZ5Q4vRnlVwqEqOQDJm46z5ezs7o2TBiVV3lU8qOQBWL8+A/BJ6HwW/rkCcXD8po8HivxMizxB13glG1Ll@vger.kernel.org
X-Gm-Message-State: AOJu0YwjeM9UeyDIXUC/AC4E2MyxdHDn2ov0k/TFxLTrmlaNgH1JxWmg
	iLuCzCR1M7Hnh8jekQsuicX+Bj1ITagiQmjixlivmhzI+BTt9YpvBafjtbNO7F2p39JVY8V8XIy
	/eBnqy6NlTgW6Cjt4J3EJzi/Ma6Ts7/0m+IshrWg=
X-Gm-Gg: ASbGncttQDuDm/BaOuMvRZBbZu7LPSv0aHYy2AIUCuruoQKSQMR+61A31EzZHjkaNyX
	237hCkNVwoe3nAGYolEeyszkx4m+QDTI6lK1wO/xZBNAxrn98Cs2uAZavh1uNv1L0cmIEuoeS2f
	2mJ2Q3GCG4TV1Lr0R48ThamgLA02P5awnLIA9A3Pi5xoJ4DoOYHtaWAKsHERr7GitG18GpU101Z
	7B/k/wqTzRqBDsbkzjL+xfQB9366jmMFOY40XE4d8X8zGwpjX8=
X-Google-Smtp-Source: AGHT+IFx9yd4PB/vn4IjXsoACWwoeCb/LEf5nz0y3KpLeNZ2RitKABUZYjPvumidUpl8exgSkmnuKsZ7bjrh8cCbDhE=
X-Received: by 2002:a05:6402:a0cd:b0:629:54af:4f53 with SMTP id
 4fb4d7f45d1cf-62ed82c6656mr16233534a12.18.1758029386970; Tue, 16 Sep 2025
 06:29:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250915101510.7994-1-acsjakub@amazon.de> <CAOQ4uxgXvwumYvJm3cLDFfx-TsU3g5-yVsTiG=6i8KS48dn0mQ@mail.gmail.com>
 <x4q65t5ar5bskvinirqjbrs4btoqvvvdsce2bdygoe33fnwdtm@eqxfv357dyke>
 <CAOQ4uxhbDwhb+2Brs1UdkoF0a3NSdBAOQPNfEHjahrgoKJpLEw@mail.gmail.com> <gdovf4egsaqighoig3xg4r2ddwthk2rujenkloqep5kdub75d4@7wkvfnp4xlxx>
In-Reply-To: <gdovf4egsaqighoig3xg4r2ddwthk2rujenkloqep5kdub75d4@7wkvfnp4xlxx>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 16 Sep 2025 15:29:35 +0200
X-Gm-Features: AS18NWAPAV01WXyNb64OPEzkKEyOkzIVEVp3wm-eCN6oWp1E8_sj0VUWGpMMb0M
Message-ID: <CAOQ4uxhOMcaVupVVGXV2Srz_pAG+BzDc9Gb4hFdwKUtk45QypQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: check before dereferencing s_root field
To: Jan Kara <jack@suse.cz>
Cc: Jakub Acs <acsjakub@amazon.de>, linux-unionfs@vger.kernel.org, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2025 at 1:30=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> On Mon 15-09-25 17:29:40, Amir Goldstein wrote:
> > On Mon, Sep 15, 2025 at 4:07=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
> > > > > diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> > > > > index 83f80fdb1567..424c73188e06 100644
> > > > > --- a/fs/overlayfs/export.c
> > > > > +++ b/fs/overlayfs/export.c
> > > > > @@ -195,6 +195,8 @@ static int ovl_check_encode_origin(struct ino=
de *inode)
> > > > >         if (!ovl_inode_lower(inode))
> > > > >                 return 0;
> > > > >
> > > > > +       if (!inode->i_sb->s_root)
> > > > > +               return -ENOENT;
> > > >
> > > > For a filesystem method to have to check that its own root is still=
 alive sounds
> > > > like the wrong way to me.
> > > > That's one of the things that should be taken for granted by fs cod=
e.
> > > >
> > > > I don't think this is an overlayfs specific issue, because other fs=
 would be
> > > > happy if encode_fh() would be called with NULL sb->s_root.
> > >
> > > Actually, I don't see where that would blow up? Generally references =
to
> > > sb->s_root in filesystems outside of mount / remount code are pretty =
rare.
> > > Also most of the code should be unreachable by the time we set sb->s_=
root
> > > to NULL because there are no open files at that moment, no exports et=
c. But
> > > as this report shows, there are occasional surprises (I remember simi=
lar
> > > issue with ext4 sysfs files handlers using s_root without checking co=
uple
> > > years back).
> > >
> >
> > I am not sure that I understand what you are arguing for.
> > I did a very naive grep s_root fs/*/export.c and quickly found:
>
> You're better with grep than me ;). I was grepping for '->s_root' as well
> but all the hits I had looked into were related to mounting and similar a=
nd
> eventually I got bored. Restricting the grep to export ops indeed shows
> ceph, gfs2 and overlayfs are vulnerable to this kind of problem.
>
> > static int gfs2_encode_fh(struct inode *inode, __u32 *p, int *len,
> >                           struct inode *parent)
> > {
> > ...
> >         if (!parent || inode =3D=3D d_inode(sb->s_root))
> >                 return *len;
> >
> > So it's not an overlayfs specific issue, just so happens that zysbot
> > likes to test overlayfs.
> >
> > Are you suggesting that we fix all of those one by one?
>
> No. I agree we need to figure out a way to make sure export ops are not
> called on a filesystem being unmounted. Standard open_by_handle() or NFS
> export cannot race with generic_shutdown_super() (they hold the fs mounte=
d)
> so fsnotify is a special case here.
>
> I actually wonder if fanotify event (e.g. from inode deletion postponed t=
o
> some workqueue or whatever) cannot race with umount as well and cause the
> same problem...
>

Oy. I was thinking that all event happen when holding some mnt ref
but yeh fsnotify_inoderemove() does look like it could be a problem
from sb shutdown context.

How about skipping fsnotify_inoderemove() in case sb is in shutdown?

> > > > Can we change the order of generic_shutdown_super() so that
> > > > fsnotify_sb_delete(sb) is called before setting s_root to NULL?
> > > >
> > > > Or is there a better solution for this race?
> > >
> > > Regarding calling fsnotify_sb_delete() before setting s_root to NULL:
> > > In 2019 (commit 1edc8eb2e9313 ("fs: call fsnotify_sb_delete after
> > > evict_inodes")) we've moved the call after evict_inodes() because oth=
erwise
> > > we were just wasting cycles scanning many inodes without watches. So =
moving
> > > it earlier wouldn't be great...
> >
> > Yes, I noticed that and I figured there were subtleties.
>
> Right. After thinking more about it I think calling fsnotify_sb_delete()
> earlier is the only practical choice we have (not clearing sb->s_root isn=
't
> much of an option - we need to prune all dentries to quiesce the filesyst=
em
> and leaving s_root alive would create odd corner cases). But you don't wa=
nt
> to be iterating millions of inodes just to clear couple of marks so we'll
> have to figure out something more clever there.

I think we only need to suppress the fsnotify_inoderemove() call.
It sounds doable and very local to fs/super.c.

Regarding show_mark_fhandle() WDYT about my suggestion to
guard it with super_trylock_shared()?

Thanks,
Amir.
