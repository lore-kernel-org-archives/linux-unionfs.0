Received: from mail-ed2-f35.google.com (mail-ed2-f35.google.com [74.125.228.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75D536AB5A
	for <linux-unionfs@vger.kernel.org>; Fri, 25 Sep 2026 14:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790345893; cv=pass; b=Gu76GMv1uUrDTpjhLmbaVoa2KqOia5VdLMFnmTkl0TAb2uFPTJY9HyRxNdkdm4kTIwiTqgwQMtJw1aum1ikEjVTGMhtDwRLyjXwmOfYT95YegivKrSzIGPMhvLHXfLLf4C89Mrhtc2dWH5F2BWkRDk0QLSKE/p00DbIkS/JwZ7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790345893; c=relaxed/simple;
	bh=HzRDzGxPdLFi5j4KurtnMU+p04zWtDF2RczOJoLxtX4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sqSf5/EsPxksbdE7TP96L/qO42p6muor23h9BuNM/gK3gzjp+GupF3xpY+w91MHGCWtGHzP6NF0+mEdva3eR4dBZeJgPr9sMRVq6W5RumP0k/AR6HGMyfI8UVTQD9MEUJoXTaDqxkRURANTSBE6ogLBYMXm3pQcK72xLZCAG0Wg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yx0GhbgK; arc=pass smtp.client-ip=74.125.228.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yx0GhbgK"
Received: by mail-ed2-f35.google.com with SMTP id 4fb4d7f45d1cf-6a6056ac81fso1429918a12.2
        for <linux-unionfs@vger.kernel.org>; Fri, 25 Sep 2026 07:18:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790345890; cv=none;
        d=google.com; s=arc-20260327;
        b=Z7hZpZzksj9WCQ7V7wJJ7XYt9rMozslRqEv8k3fG+mtVu73C0N6fvit77JM5jiI1oQ
         8M1mIBe7qSaHmmLWaL1QS/ZbpLZXcjm9NjjGGth+1vxyhXfeYXTV5z/1BZ3XzRwaTmbF
         rosSwt1bbHLw+IKUyJCqA+sjvwm0DRsnOxVJQFKmsUXjZt1fTynR0ly8C0p8h/I9DEhX
         NLst42NO4oFJXqXWFHoA3ywXghcimHigR5LZLoGxZoWxcc3Y5FZbfe9qktq6PlWOc4lU
         lqE7+gxhLaXbDA1IEj3ckFa0su7oPYLi/7pKMILp8p5JeWt+B2WP2867KBSAhkDX1MI3
         OGLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9lqdUBBVi5EVqQ9eVcAWulKAG76roFDwGZOPzKPPlr0=;
        fh=W/7zMm3CJ+ViTWyl3FNiJsaLu5wm86BvG//6YOmYO6E=;
        b=U0D8bAoESAnQL7PXVAhXG+8Md/DiLaLwTHiVVfDwcutEXqcBZHr4ZxrqLYc7Pq2rHw
         2FhCEWfxNEi2zx5vHyG8S9gW+drJPXip1GMBTFliltnuddq9stMCJq58mLZHEw1N8XcR
         sD/2nMlj9nAh/2bMiZ2exjAhzh3rle01yBfVjVVAkrNk97VgnCM+6wnc4GJZdUygzTVz
         jeDLKZ5509dAaqzJD85RkisqUTm2UmLY5DaY492qa1ZxU2Hlrej1busCG8xNhaKPOOA3
         MQkRQgbVCj21F8jAG/IGr3PF0njhhu9PLs9OvZ5oosmYABSiYelSd2UQLg1CiK9FRBdn
         /k2A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790345890; x=1790950690; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9lqdUBBVi5EVqQ9eVcAWulKAG76roFDwGZOPzKPPlr0=;
        b=Yx0GhbgKwDii+NBsPcEpw3413wCeOsPKq2+Sc4B6YTFkdeM9LicPjxmjZkPYJ1hP7j
         GzqBD1LuUpYw0qMVtvd522tgMtFlnz07OnHgfw8czbC2qj0Rx3ljRzgd/W/pPgVe9GNi
         aTwtOkXPJMm7Vtmc/Et82b0HXGg9UhjSd5vHoveobMHgBDsMJr88iV3FKy9CDdRYIwkI
         p6vN8CMv/XVu5idCcuIPBFKdJXXyf1+jskOcpswaMhv0a5a5VFcpDNut9MoSJAY+T2ha
         zuPbDZUvy/Wx1alh0k04Y1Pqrwb/Cx/jUKjyTQxyTReHW824YXunw5warbtAbsXNW8KK
         IoeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790345890; x=1790950690;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9lqdUBBVi5EVqQ9eVcAWulKAG76roFDwGZOPzKPPlr0=;
        b=JaUOeM8ovbCIbg5qVSyT/xp5ZUk79LSgRkZEm+RXYc5+YJQHXchjykDwnCEKQ4L+YP
         VnespJaTpvDuqwjwMRutGKQCSDbATtxfuFp+/pzkuY73WFaiQZEcbptCO5MHs67dLu6J
         Nzey/Yk7IplKWmwQvkRRC66xWgvhlUZc8R+j0u22+aKBddrm8UK8OHFG8JCCMFf9kw0n
         piEdLVBRriaGnepwOCukTAIWYw3ORN9594IP5idWfF+5EOgDquRGzw3TfUTmdr5Gc5Ux
         tk9Aul5KdyFl0fVpJw60pCiMGn9MMDQGr/2C+jWHf06XZOLJNTgJshHF9S+MgthTEKUT
         M18Q==
X-Forwarded-Encrypted: i=1; AKwUvBxP1CooNgZ913IdjX5PDpgjsKlCTVGqKyFGMVOgfytFWzhgIj9RdOxxJW74QnQm8T1WXRgwu5vnVkARgAdQ@vger.kernel.org
X-Gm-Message-State: AFuF++llvxWEWBFbsrAqoAqZKyBlk47I6MlAC59lwUhBmak9TVV2/Mm/
	bp9AU40/Bxqutefxo8WaooNqo+U94kt8hGWGbQ8p0JngCfbEHLCFl22uGR849B6QYshufYT4NqG
	6EvOiBWaLWLaZ9zGVW6Y8ZVDg4gva7Bo=
X-Gm-Gg: AYBFou02+o/KhII3ZdRxzxsj3JGssMGYRfYWi3gSG2NSZ6W9wyxHuK/SvZ5n944aN3r
	Y1pUTW5LuC1djGw+euoStrsSmvhdGl434/Ng7ICvzACQFU4lgR87K6b8OAhyd2hY3582yit9eMu
	3YlRF9/zz87Yq+bR1WfK5EcYTIgzvXU8mcZlSpUaiJpir85Nt87MAMf8mtoIB4dFLGd0olHIF/+
	qK4fZYasdDkTQG7aAf6KSFYyjvl0SZy+IZKfyNzu16fa5untgLcP4QS3gIe0ViBf9q4pXfmkMQW
	trXr+xLNXzs+FRssVojyJ3QFn9qXBMqrIeEdSr2ggiP9cs2g2dxaQbfPhKwDeENFbzA=
X-Received: by 2002:a05:6402:21d2:b0:6aa:b1b8:cf25 with SMTP id
 4fb4d7f45d1cf-6aac8f72c30mr4970341a12.29.1790345889236; Fri, 25 Sep 2026
 07:18:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260920203239.2876221-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <20260920203239.2876221-3-Jeremy.Jean@oss.cyber.gouv.fr> <CAOQ4uxhyc5x3LDzbJtRhQJ+JNQ-hES2k45jcxeGsfEWPB24TKA@mail.gmail.com>
 <20260925-server-hager-riskieren-06116eded213@brauner>
In-Reply-To: <20260925-server-hager-riskieren-06116eded213@brauner>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 25 Sep 2026 16:17:58 +0200
X-Gm-Features: AclHuK-IJUoX3UXBLkix4xrF2loPfjQs3Rtc7YqgEUoLWMaqcNXRbcRyYaVgVqg
Message-ID: <CAOQ4uxhdP4XeHfbKfOg+3XRF8oLhPMmbU9xHp7pV2w=snQk-+w@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] ovl: disable nfs_export for same-sb lower layers
 with different idmaps
To: Christian Brauner <brauner@kernel.org>
Cc: =?UTF-8?B?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>, 
	miklos@szeredi.hu, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 25, 2026 at 3:51=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Mon, Sep 21, 2026 at 10:10:28AM +0200, Amir Goldstein wrote:
> > On Sun, Sep 20, 2026 at 10:33=E2=80=AFPM J=C3=A9r=C3=A9my Jean
> > <Jeremy.Jean@oss.cyber.gouv.fr> wrote:
> > >
> > > Overlay file handles identify a backing filesystem, but not the lower
> > > mount used to decode it. If lower layers share a superblock and use
> > > different idmaps, a file handle can decode through the wrong layer an=
d
> > > initialize the overlay inode with the wrong owner.
> > >
> > > Track the first lower idmap seen for each ovl_sb and disable nfs_expo=
rt
> > > when another lower layer on the same backing superblock uses a differ=
ent
> > > idmap. Keep index enabled: copy up starts from the overlay dentry sel=
ected
> > > by lookup and does not need to decode a lower file handle through ano=
ther
> > > layer.
> > >
> > > Fixes: bc70682a497c ("ovl: support idmapped layers")
> > > Assisted-by: Codex:gpt-5
> > > Signed-off-by: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> > > ---
> > >  fs/overlayfs/ovl_entry.h |  2 ++
> > >  fs/overlayfs/super.c     | 28 +++++++++++++++++++++++++++-
> > >  2 files changed, 29 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> > > index 80cad4ea96a3..2a6e12a0d4dd 100644
> > > --- a/fs/overlayfs/ovl_entry.h
> > > +++ b/fs/overlayfs/ovl_entry.h
> > > @@ -24,6 +24,8 @@ struct ovl_config {
> > >  struct ovl_sb {
> > >         struct super_block *sb;
> > >         dev_t pseudo_dev;
> > > +       /* Idmap of the first lower layer on this fs */
> > > +       struct mnt_idmap *lower_idmap;
> > >         /* Unusable (conflicting) uuid */
> > >         bool bad_uuid;
> > >         /* Used as a lower layer (but maybe also as upper) */
> > > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > > index bd0a3f9039d2..8e78da420b75 100644
> > > --- a/fs/overlayfs/super.c
> > > +++ b/fs/overlayfs/super.c
> > > @@ -944,6 +944,24 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs=
, const uuid_t *uuid)
> > >         return true;
> > >  }
> > >
> > > +/*
> > > + * Lower file handles identify a lower fs, but not the mount whose i=
dmap was
> > > + * used to decode them.  Remember the first lower idmap seen for eac=
h fs so
> > > + * decodable export handles can be disabled if another one appears.
>
> I find this behavior counterintuitive. Shouldn't we just fail the mount t=
hen?

I would love to fail the mount if you confirm that setting up an ovl
with several
lower layers some on the same fs with different idmap, is a non-feature.

I don't know can't /home/amir and /home/brauner be on the same fs with
different idmapping?

Could it ever make sense to compose an overlay from two such directories?
If not then I would gladly remove this setup from the test matrix.

Thanks,
Amir.
