Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4638438DC6B
	for <linux-unionfs@vger.kernel.org>; Mon,  5 Oct 2026 20:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791233553; cv=pass; b=K0anF2BYJOD9/vcvwHi66borojxP/ISORjN49hC9k3V1ed/9iAlIp1hbDhilrG8SiOIsWe6pK3VOQ/ekPSt7U4QuEo/kn72OyBq+20+3cmqivQZy+a5NJrMnJUC0iylWWlWXOpXL+v1SOCsftazJ9K/UmtmbVG3f6k+r2xsNCGU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791233553; c=relaxed/simple;
	bh=VItA9svt54X2p8ukz7v2udIkGi4MSLlzhR4/ovmNvCI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qGcTBEDOMiiyWa9XVg5FNqXHU4JltpalXV6jdi7/vreKwQDtTfZ+a/9mFgEESsXWkeBCIXss9Ub5n7kdIZfddjBP96bDlI3R3JAkRpqVY/6vroyPQnJO5jKgeEfElqnqcv1PgsgmaSr+F3noAzqAqVIi4YsBhxLM/vHwoCviY70=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i9BaR4BG; arc=pass smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i9BaR4BG"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2d8fd7a3f38so8735ad.1
        for <linux-unionfs@vger.kernel.org>; Mon, 05 Oct 2026 13:52:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791233547; cv=none;
        d=google.com; s=arc-20260327;
        b=cGeCDg1aVRI8q2sXGtEZWm8ayPjHXasFTEN25bQ21gDb5zjZpALQF304j4fxy6oLrN
         HvDlsa+G53lHBoj3qCy7z+sYwPOUGjRT2qYGIptjLlmx4Q7VaezVLbayLBcB66mo4/PV
         SNAkOZ6YQW41LHE+apgTr+63lCE7SDyezGhd+t33ajL1aMFmI14rCSegoqtZES/1btzQ
         QsP7HH/UMCtnZS8qVk15l0yU37bi6+XfJ5kk8luxo9auPGkag7bhdxW+FoGO3kaIr8r2
         wx7XPE9CtTGhiGO1/AD1uDP3M7vIhsD1d3hxtcQ1cFYQlbjJbPGTCA2MM+g2X13lc2fe
         QbSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VK5/gVHTnnmzAn8uoVMuEMOtdCleTwQvx3WA5tRDVC4=;
        fh=l7N1dm24lGrmfEz53IjFo6H1G+gQkqAndUvShRz2EdE=;
        b=Au2NhB2fVRAHQemvQuW2xzpOIV2V6b6tgAFyfIvyP54dLU5w83PmsYeYZZ2hSUohdh
         78EnXuZKGEaWWAJiW0Hl8VBTgK6IWGEQvRK5739KJ3kWBj2aF3jnEBiNUggw/GFIvIjZ
         S7Nanmqj06HK+O0UgZQnrqgnCynUGVctWurZKLF0HJiHkGaKLTPE+8RkfEUDgs4nreMD
         wN1H3/GZ3NdqiR7lZL9dcjqIvp8TZfr68MLCPbeFlP35/q3OoDI2N4D1wEDVlh3ufxe5
         2pm9j842gEoqHrYmXYSeM4Yw6LSRWXJhab/ljFlqPbHaBLGKRRZYVCk8nXaCav6Wvnhe
         TeYw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791233547; x=1791838347; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VK5/gVHTnnmzAn8uoVMuEMOtdCleTwQvx3WA5tRDVC4=;
        b=i9BaR4BGqfFdVSUg7CoN3rhhiWz1xsrR/8jsDicEnsd0X7BamOyoQJU5nqw5E91iTF
         3YSZvGSK8dklJzHkAP0tsyJNXJzwfPrV1x+HYOAEqrMuDqOwD7+Xl/O2b0M8rRjiUFoF
         p6apbKKuvHGB/jvnSeVyqby3wDmO4fzwk1NOoss0aGo12vzQk3V2epNCDVimUzhuegPe
         9k5ezgOFNSOiuZ2xVUyKiJxbI5a04FXrfvpq6gXZExo/KF5/GJOCDmykZ7tmMUysVKky
         I/MEiUPDxjzYb6M5VZyeRioC7jl5cbc1XCHYLG+ezVvyWQ/2SjBQJkOL6Qrfe3a12maw
         PLJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791233547; x=1791838347;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VK5/gVHTnnmzAn8uoVMuEMOtdCleTwQvx3WA5tRDVC4=;
        b=sXD3/+mbHEVr8/amUsVTBxmTIzI1vyGa9vJJRzdF9MfLMSPmcsfkHXOrhqaZ+/Nc65
         Bu9Yyz7vu0Z0qhNRZkxWCuoCxedn8aVHX2jmr4r5fTrhXK9Qy2j1eA+AG3QThQrn/GIX
         h455lKktz6k582ljnLHkNwP3eARIzaHm1X5UUyUDUfdbtYpuN7QjUQMZvOrZmFgESEaL
         0KK64FshGUSphBzgVi4J7dL0wgcFwtO3uMN6F3j92ojhLLA0b0bJEQDbWexVXmApQ0Bi
         0xkwAQoVWJchJ18s3NqZnTpzA5TmTCXD/ndQuM4EdfXsfIscB0vIAcVq5qF9w4bozHou
         r9/w==
X-Forwarded-Encrypted: i=1; AKwUvBzwU8cXSsux5k70euDCg338le3hiezePyoiGuXceqsAg+ajda8PPG/j5NJu/12tbgPFOb/pU1dEH7ByBejz@vger.kernel.org
X-Gm-Message-State: AFq9FYK2dOMAK/re1PqDeaH5MVSmxno+ZOQzpBixiid4NzVnHzzYeNFH
	sqCgim1ir0axGriLVRbORInGWy0zrXlOkKRUJzie4kZ/FsfOjmvNaZmNCRtbgfDBOQndUhagdP9
	PKjKgR8SNfVxeNrF+VyW1IzpGBMDkyiq66v5cvo7S
X-Gm-Gg: AYBFou2lZH1Bfv/GMdbesIdxErFcdRi1EMN+MxZtNj2HDy8Qh5L1tIJB6r9vDmbjzsf
	H7I5vQ35vWgJ7ZAG7ioPqDdTfOv/Ko1h8Nv+H9R9BtWfJCz4ZvGP1ghN4GNa7szzrB4QRgbz/Ov
	vU/c6E8p8eM0raYNP1R2GVzILLqTLzDjceemyTVtaIEUO72RU+ImaSqd2PX9abFHtrprWcK4RWz
	oyqYRMJJVTSkd7kzMjl49Omnkc94S8KjDL7zsedZLsBu321ZyysKa0jI6uCyy+RBFO4m7maRjBd
	UmhKeqCxvVWlaq20umwodxzd0Q8rzD3/8MqoLA6qmgioU/ISCCtIj7yO3g6NVs132uZYiQrPm6b
	sFPCJ09wPWRmGUOjk/zjY648aCKIBY39jemzgjXOg5w==
X-Received: by 2002:a17:903:1207:b0:2e2:ba46:ce33 with SMTP id
 d9443c01a7336-2e5ccde7a72mr265345ad.8.1791233546315; Mon, 05 Oct 2026
 13:52:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org> <CAOQ4uxin8B4SbPjnNL-hUWX4EP3V=8jCO=ENt8SQ2D7wcCsdLg@mail.gmail.com>
In-Reply-To: <CAOQ4uxin8B4SbPjnNL-hUWX4EP3V=8jCO=ENt8SQ2D7wcCsdLg@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 5 Oct 2026 22:51:49 +0200
X-Gm-Features: AclHuK8Kw6sZ4uGUaoQnWi2jN-M7jOD9_cn8LurXhcZkMCfzVjRaQwrU8OFw-To
Message-ID: <CAG48ez1=Td8uDsjhd3TSL8iJ0tGjnbJYugbVOmuYHzfEKab9+g@mail.gmail.com>
Subject: Re: [PATCH 00/10] ovl: support idmapped overlay mounts
To: Amir Goldstein <amir73il@gmail.com>, Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 17, 2026 at 3:56=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
> On Mon, Jun 15, 2026 at 3:20=E2=80=AFPM Christian Brauner <brauner@kernel=
.org> wrote:
> > I've been asked about this feature multiple times and had actually
> > implemented it right when I did the initial idmapped layer support.
> > So here's a new version of this series.
> >
> > This series lets the merged overlayfs mount itself be idmapped via
> > mount_setattr(MOUNT_ATTR_IDMAP), in addition to the already supported
> > idmapped lower and upper layers.  It allows the same overlay tree to
> > be exposed under a different ownership view, e.g. a container seeing
> > the merged tree as 0:0 regardless of the on-disk or per-layer ids.
> >
> > Overlayfs already normalizes every underlying id through the relevant
> > layer idmap when it copies attributes into the overlay inode
> > (ovl_copyattr()), so the overlay inode's i_{u,g}id are "overlay-final"
> > ids.  The overlay mount idmap O composes on top of that pivot:
> >
> >     caller view  <--O-->  overlay-final id  <--layer idmap-->  on-disk
> >
> > O is applied at the overlay-inode boundary only - permission, getattr,
> > setattr, the ACL owner checks and inode_init_owner() - while the
> > underlying layers keep being accessed with the mounter's credentials
> > through their own, possibly idmapped, mounts.  The mount idmap thus
> > only changes how the caller sees the overlay inode and never widens
> > the mounter's access to the layers: the second, mounter-credential
> > check in ovl_permission() against the real inode stays on the layer
> > idmap.
> >
> > Most paths need no change because the VFS applies O to the overlay
> > inode before overlayfs runs (sticky/rename/unlink/create gating) or
> > after it returns at the syscall boundary (the POSIX ACL get/set
> > translation).  Overlayfs only acts where it bypasses the generic path:
> > getattr (it stats the real path), the setattr forward to the upper
> > (the requested id is rebased from O into overlay-final space before
> > being handed down), inode_init_owner() on create/tmpfile, and its own
> > owner checks in ovl_set_acl().
> >
> > FS_ALLOW_IDMAP is set last, once every operation honors O, so there is
> > no bisection point where the mount is idmappable but an operation
> > still ignores the idmapping.
> >
> > Note that fstests will be broken by this temporarily as they rely on th=
e
> > ability to create whiteouts for unprivileged device node creation. That
> > can be adjusted.
> >
> > Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> > ---
>
> Apart from the minor comments on the test, the entire series looks good t=
o me,
> so you may add:
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>
> The problem is that my review can only assert that your changes make sens=
e.
>
> I am not even close to being able to prove that this is risk free.
>
> This is the first time that we will have a combination of
> FS_ALLOW_IDMAP | FS_USERNS_MOUNT with fs which is a proxy to
> another fs, which to me sounds like Vulnerability Scanners heaven.

I randomly decided to point my human brain at overlayfs again, and
noticed this change. :P

I've noticed that the may_linkat() checks for
sysctl_protected_hardlinks only happen in filename_linkat(); not in
vfs_link(), which overlayfs uses for operating on its backing
filesystem. If idmap shenanigans allow being capable over the
overlayfs view of an inode without being capable over the backing
inode, that might break the hardlink protection. But getting a proper
understanding of idmaps into my brain is taking some time, maybe later
this week I'll understand whether this is actually a problem or not...
