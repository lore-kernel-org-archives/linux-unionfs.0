Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454E31D0BA5;
	Tue, 19 Nov 2024 15:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732029078; cv=none; b=rwZVR+zxvU4ERNEJ5TSewlOvcAcXaCsq6YDVxfu2qnBZJQmKH/NTDNhRnKnNTlEwN5u16iSBHWFU1s6ziM25Ue4ZD+53TYBlNqTqJ7gt1J7FgrreEbgzXAfFvj7g35RP/p/tRCGRBLTP98WnXH6sfMIgZ4byljBicpVKi+X49E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732029078; c=relaxed/simple;
	bh=XTJmiH0dvBZGzxVe9IIY7kRTyRmpntQSCFA9iSjij6I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LDzqCOX3hpKGsuuXhKCImdh9F1UKFu4/NikS5CydCrSFr3ocHRhcCMYDNr0nuDd2JLXwlpF4qBK2IkYtMQr4HpvLhn4u55/Lmk7T0rbnAL6iJ8PM0o/Gv0fnPkQV2uSIUQlaX4+ASZg5AJtV6ix4g3qDvkJKOR7oCP66+O/wcyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IPwpLolP; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IPwpLolP"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5cfc035649bso3709260a12.2;
        Tue, 19 Nov 2024 07:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732029075; x=1732633875; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HNGSamDl/8lrcN3ZW2EPN+VruAML4DSh4qgRSgophAg=;
        b=IPwpLolPVZGIor1u082PSTdLE8lXxLudblcEu/GrAKIILyvRxX026gwqu8KtN1+1o7
         rCdJFTqcAcPrlVCQQjBt4+977wJyJ1hPtQUxkaAwartFxz+4XyBfIpoxY5fO/UNfwd8i
         l6KkcAEftr3wIKy7phAALPVXODLz09gG21UzPEAD4iCMMv0I+97R3qygk+LG1swCXE5O
         kv3XOYPS3DGizH9lfV1k6Dtpqv/dh8ZmRj2osJJrwxafVZkJUkqHNpZzdrVrbUTTA0/D
         UpxjrdbuuZOjjKuGKOHlGwfotQ0U/PzzBzrBH4r9ANyQ9KazS6ii8DQ95VaLr6fY2inI
         Le7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732029075; x=1732633875;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HNGSamDl/8lrcN3ZW2EPN+VruAML4DSh4qgRSgophAg=;
        b=F2RTvjLl/XH1ZTGm8k3MulEoFFQ+XjMNOQFy+3UzBfQsAaXUDr2Iip8DEiUj6yXsGd
         GRLb0zEy8CIEQEE+V1vmgKqocOQEg9pOr3Dose2tDs6vQHaJOeIuAgocDJyotgy45Q4N
         +ijRpCP9ne1Dcy6jQ93uU89zZl0PMVbgfY5nriRhqAYqYYq2GKfrtYbb3EbwKRRJehn4
         GCL6P0NqNf91wvum3AzgKOpLiAxM1JHrZWXPK7YicPxJAiZLADbXv18ALDveHrNDOLBK
         C8UX0bar4k0PpilcJ3pFtlVOxMHLED1ZDMTKw4Q3d04mIqrWuijDAZITvnNEPhqHMaKY
         ERTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUV7YA3CD23PAq36ccOOm1joXU/w0WrS3bhjdt9arUfFfdR/IuCdtS0geHcNMpHXWro+Xu895iWHuqwUzSGbQ==@vger.kernel.org, AJvYcCVHNfO0VAsOYJc63YNWlnZUeEhFR8hoEtiACDxrHgHoRuXRfr2zu/lQ0KPliIlgODLJSdjxbBYUDC7Dz3I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBMxeflaGdkRKYmMMdnrAXiRnfwYgMJqpXGjUfurh+hxeJjZ25
	r8Bha7rZaDcXwZxKujfEGtzpnu0tPKVdYTFSE9UkMMyYZBsoG0UMECN2WXnmJjldyzRScbW4cyJ
	65JDhyoR1r7ZiboqYXUBeu56MkMo=
X-Google-Smtp-Source: AGHT+IEUKHQQVnswgTDP7dRM25/yryEOc47K7DrcMsw8Zkv8nPiaUEo7Na1ONOkTipmySXlVXVz/nv/m8y4iIYiQM0s=
X-Received: by 2002:a17:907:5c4:b0:a9e:26ad:d0a with SMTP id
 a640c23a62f3a-aa483555382mr1562418866b.58.1732029074227; Tue, 19 Nov 2024
 07:11:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118141703.28510-1-kovalev@altlinux.org> <CAOQ4uxjxXHX4j=4PbUFrgDoDYEZ1jkjD1EAFNxf1at44t--gHg@mail.gmail.com>
 <CAJfpegvx-oS9XGuwpJx=Xe28_jzWx5eRo1y900_ZzWY+=gGzUg@mail.gmail.com> <6fb27fea-3998-0fdf-9210-d7479baf0570@basealt.ru>
In-Reply-To: <6fb27fea-3998-0fdf-9210-d7479baf0570@basealt.ru>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 19 Nov 2024 16:11:03 +0100
Message-ID: <CAOQ4uxhc9-MMF1nEpoxC5X41FRqSygGdVcTuvdJKurMxWU1U0Q@mail.gmail.com>
Subject: Re: [PATCH] ovl: Add check for missing lookup operation on inode
To: Vasiliy Kovalev <kovalev@altlinux.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 19, 2024 at 3:33=E2=80=AFPM Vasiliy Kovalev <kovalev@altlinux.o=
rg> wrote:
>
> Hi,
>
> 19.11.2024 12:05, Miklos Szeredi wrote:
> > On Mon, 18 Nov 2024 at 19:54, Amir Goldstein <amir73il@gmail.com> wrote=
:
> >
> >> Can you analyse what went wrong with the reproducer?
> >> How did we get to a state where lowerstack of parent
> >> has a dentry which is !d_can_lookup?
> >
> > Theoretically we could still get a an S_ISDIR inode, because
> > ovl_get_inode() doesn't look at the is_dir value that lookup found.
> > I.e. lookup thinks it found a non-dir, but iget will create a dir
> > because of the backing inode's type.
> >
> > AFAICS this can only happen if i_op->lookup is not set on S_ISDIR for
> > the backing inode, which shouldn't happen on normal filesystems.
> > Reproducer seems to use bfs, which *should* be normal, and bfs_iget
> > certainly doesn't do anything weird in that case, so I still don't
> > understand what is happening.
>
> During testing, it was discovered that BFS can return a directory inode
> without a lookup operation.  Adding the following check in bfs_iget:
>
> struct inode *bfs_iget(struct super_block *sb, unsigned long ino)
> {
>
> ...
>         brelse(bh);
>
> +       if (S_ISDIR(inode->i_mode) && !inode->i_op->lookup) {
> +               printf("Directory inode missing lookup %s:%08lx\n",
>                                                 inode->i_sb->s_id, ino);
> +               goto error;
> +       }
> +
>         unlock_new_inode(inode);
>         return inode;
>
> error:
>         iget_failed(inode);
>         return ERR_PTR(-EIO);
> }
>
> prevents the error but exposes an invalid inode:
>
> loop0: detected capacity change from 0 to 64
> BFS-fs: bfs_iget(): Directory inode missing lookup loop0:00000002
> overlayfs: overlapping lowerdir path
>
> Would this be considered a valid workaround, or does BFS require further
> fixes?
>
> > In any case something like the following should filter out such weirdne=
ss:
> >
> >   bool ovl_dentry_weird(struct dentry *dentry)
> >   {
> > +       if (!d_can_lookup(dentry) && !d_is_file(dentry) &&
> > !d_is_symlink(dentry))
> > +               return true;
> > +
> >          return dentry->d_flags & (DCACHE_NEED_AUTOMOUNT |
>
> I tested this addition successfully.
>
> Additionally, fixes for BFS seem to be discussed reluctantly.
> For instance, this patch set [1] has remained unanswered.
> Perhaps it would be worth considering discarding invalid inodes at the
> overlayfs level?

Sure. please send proper patch following Miklos' suggestion

Thanks,
Amir.
