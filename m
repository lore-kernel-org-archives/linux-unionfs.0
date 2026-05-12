Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7512371CEA
	for <linux-unionfs@vger.kernel.org>; Tue, 12 May 2026 19:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778613681; cv=pass; b=o0SbI10WwO/G/iGTcp08U38CuoGNd/BLfjbx/eCGNQd6N3/rH3HA0uxciWVvaSr1gH3Wg/ZOqd+AqYGKF/1+wZOjg+LDuGWXNlTsDK3ZQz6AoPpYvKuKltPqUp1Ruj+IECWlrVeSHFGwnxb/LbXvVsUd30dVBCzHyiZcnZsSRbY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778613681; c=relaxed/simple;
	bh=aJmapxcAV5rQ17uJ42HRGjJ3pbroQa6TS8OEvdO75sc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A4k7rMhY9OZP6N4cf6+/8NIFRFRAaiadJPIE++I5yBgtoM8kXYCd/S9QwVFsi3/4/8sR+egC2XBgg8wYQGpnD6/BOdnPCG/9C6622m+hUaLEMzB1BPPYcYUWAKQg0JitjEd6cnPXWFWUcprkQDEX1ONsQGq7yK+7pFQQ526MU+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FKNSqYp5; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FKNSqYp5"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-67bc6098640so9471921a12.0
        for <linux-unionfs@vger.kernel.org>; Tue, 12 May 2026 12:21:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778613678; cv=none;
        d=google.com; s=arc-20240605;
        b=RE7OpVcbWWJ3ov445bSAIzACT/6YnCkkq8qOtmt37FRn0q6xjdiEuDpvvJTxAXV05j
         FJvIqkdPC9OZ4jWe2QRir7DjnVkEgSuBZH3dNMrHa7+J609tqXEOZOzGHqq5RfU4vjFT
         y/2lsluReSgcauD9plL2ICfqSbEt8aB1I5btwCRX2hWTdMPaHAfnbumKthmT4OU31K+E
         uGAkS4VFWr2YWkp18rGH6qIpkjRKPwj5Cswm4ipLo2EUYhXoLal7VkPKFmkKnEXLGYu9
         Q/yMvR+5B9vxc2aaCNhJqK+HdCmJu16zwMv9PR3o0O90QAvVsggjku2G6z7oylk3xm9e
         6P/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TEEfsvwJQgUO1dW/I+cvIWnt5H2j0Af0ttJoiQjCLes=;
        fh=KZw8ue9KtlCL9O+QWQ7QId3q7ieblaH5+t06LYnsC+M=;
        b=dDIl9ONctY/RijE4T5oPqsKyJDPfsvMZzSOTGBiz43y4JGjXo3165LgLeo8AEI9Hcy
         ugIk6qkDd+aqdiUy3ESbyQZ+ZsgXegM3HjSEMdo6CoAmZwzND5CcqTikp/P/YHGuimi9
         AlIrtvETALqpvmBSXIMfL3G75HLD61NEtnPn7ocluLhzm/F+8e/EtIme+qhwUxR+w0li
         FgDacl1MxcMuEBvaXVmYtEx/tS6AVW3/qPjXb8HpYyG0T0a7jtD3cmZaojh1RbbG0nac
         2yXvsCYJ33NSDFPcCJy/sVODi0HsHhsgr9L4+5QZDttlmM9rCN2yBHBp7JDD0w2Y7Qqw
         tngg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778613678; x=1779218478; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TEEfsvwJQgUO1dW/I+cvIWnt5H2j0Af0ttJoiQjCLes=;
        b=FKNSqYp5j5E2z0FtMs9E3jNsMkgOS975uBF9/2gt9YZ9qXwSNhJaZ134LsLgRxfq2V
         96wyjmJvYh/dwUaacQIIuW6LYRk2yBB36ZwJAq37F1p79Py3aqsMAg6wpKafEoCPHvbe
         NBwJgwCTyGMHvWPURJKQwI9Fb8gRMgUVnOZSTV9K2IK5GiHxotHpIui6Z4/QBm3Iwo8+
         hPzZfUr5vzndyWJddPtEpT7G4GhgBS8yUIz4VopPkPJjyX1l/PK6BFnDVna9PJuVdZbU
         sqifxHKqsg0qRkfKSUjgfM5Z23HkQCmkCszQgzNDNtaJeM8pDyF2WywZnH4h5azEypOc
         rgDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778613678; x=1779218478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TEEfsvwJQgUO1dW/I+cvIWnt5H2j0Af0ttJoiQjCLes=;
        b=HDHzmdXyAolzfpgYZx/wcwEbK2wekhGEln2jI5F1IganJ7xKodlZ0dj4V796Zy95SV
         QfHe03Q5Jj2MjGHA9tRLA7ZDXw0pipfSamtrGQJypJhDP9M5ORy9PJT3mgFxxOrrBerm
         iakCc0aQG1XzCtZ2Fwvov6YEr6m34XmMUqBJV/7HyY9lCdFX8c7h+Wqu7pyR+zDJighh
         3EBIcp0zfNJsmJ3y+sBpRJJLGzWKaMzVN34x0NEtZ7iOi07QfE8TE0Jc29ZhmgqAh6DE
         K+Rl1m39WX0e+TXJwZuU8hFm8VdokolCmWih+rdIVL+4tAOpcqwRemw7mC06Yf8ffQll
         DgQg==
X-Forwarded-Encrypted: i=1; AFNElJ+GzapQ7MnTVLHN46z7cPOSsdEiHssqJIC/rneh2sfCiAUB9q04dY56YNCH0vD90iTbPvmeAxzTYfC7Xpyy@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8bxW0EmTpawGwyxkZG1R6x83DUUvEhzOM23mztMXQ2unR9RqE
	Do3UGOSf2PDFMvsgpOaSjS8FpSSZ/PoDyIqbjgh+i7Cqq3DF+Z6sVky4Cqw/Z2xDz+LYTzKPILq
	VgMkaYsV0KXpM+08gWnoYdDySHAhh4lc=
X-Gm-Gg: Acq92OEfkbqyiCmKz05MfeYiD/igBZEhp85B7aUJ5XuUssHNIRPN11Ck97y2O/hJe5W
	ZxVcmkUd9Spa1/DKOLLPe0w1XYMIkWTtOZ284531vZH3e0R5TJRZ46g2QIWH7ASJsFrQWOl1jMI
	pd1VDAVTSrPU9hf6rs1HU3lv2oRrMSEPjBcKaJ8iL4OUuYQfMXPnErYFv5CZQuzWEtm7FmwhBaw
	ElaoLajGjNSOZZmI0qtb/HRny2Wl23V5LB4dYbxUvcLnPCLDKocPkyUnPJhAdNiPijlvRAoH9uB
	3rHhYc1RKe+WeWnbJQOiituKrgwccQKrbAhKIsAg
X-Received: by 2002:a50:ec95:0:b0:67c:d93d:89ce with SMTP id
 4fb4d7f45d1cf-68257048ee9mr50559a12.23.1778613678077; Tue, 12 May 2026
 12:21:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260511062057.2365769-1-nirmoyd@nvidia.com> <CAOQ4uxh-1J2OBjnDVbrrrjy1puSOW0kABvghN85ih6dtKUBTyA@mail.gmail.com>
 <3d6a1a50-5937-47f8-9910-cae66ffab6ee@nvidia.com>
In-Reply-To: <3d6a1a50-5937-47f8-9910-cae66ffab6ee@nvidia.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 12 May 2026 21:21:06 +0200
X-Gm-Features: AVHnY4LZ0RPrnXP-XVtvO96Apt92-F6--re30gVLbF671-uhpRya22smth2mspU
Message-ID: <CAOQ4uxg+DkTuinnf9AMR6gdHqAydbD88+oBkTtQtABJfdC0vVw@mail.gmail.com>
Subject: Re: [RFC PATCH] ovl: keep merged and impure readdir caches separate
To: Nirmoy Das <nirmoyd@nvidia.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 12, 2026 at 8:28=E2=80=AFPM Nirmoy Das <nirmoyd@nvidia.com> wro=
te:
>
> Hi Amir,
>
> On 11.05.26 23:54, Amir Goldstein wrote:
> > Hi Nirmoy,
> >
> > Thanks for the patch.
> >
> > On Mon, May 11, 2026 at 8:21=E2=80=AFAM Nirmoy Das <nirmoyd@nvidia.com>=
 wrote:
> >> Overlayfs uses one inode cache slot for two readdir cache users with
> >> different lifetime rules. Merged directory iteration pins the cache fr=
om
> >> open directory files with cache->refcount. Impure real-directory itera=
tion
> >> uses the inode cache as an unrefcounted lookup table.
> >>
> >> Those caches cannot be reused interchangeably. If merged iteration fin=
ds
> >> an impure cache in the inode slot, it can pin and seek through a cache
> >> that was not built for merged iteration. If impure iteration finds a m=
erged
> >> cache, it can walk an object whose lifetime is controlled by open dire=
ctory
> >> files. Either direction can leave ovl_iterate() using stale cache entr=
ies.
> >>
> >> Add ovl_dir_cache_drop() to detach the inode cache before freeing it. =
Keep
> >> refcounted merged caches alive until ovl_cache_put(), stop publishing =
new
> >> merged caches through the inode slot,
> > This is unacceptable - invalidating merged dir cache to paper over
> > another root bug, which was not really fixed.
> >
> >> and let impure iteration reuse only
> >> unrefcounted caches.
> > All those guards are nice, but how does a directory inode change from
> > being merged to impure or vice versa?
> > This should never happen.
> >
> > It took a lot of arguing with Sonnet about wrong leads to find the real=
 bug.
> >
> > Real bug was introduced by:
> > b79e05aaa1667 ("ovl: no direct iteration for dir with origin xattr")
> >
> > It changed the test from:
> >
> > od->is_real =3D !OVL_TYPE_MERGE(type);
> > od->is_upper =3D OVL_TYPE_UPPER(type);
> >
> > to:
> >
> > od->is_real =3D !ovl_test_flag(OVL_WHITEOUTS, d_inode(dir));
> > od->is_upper =3D OVL_TYPE_UPPER(type);
> >
> > But there is a race window in copy up of a directory where
> > upper is set and published before the OVL_WHITEOUTS flag
> > is set.
> >
> > an opendir() observing this state inside the race window will
> > wrongly start to iterate_real and another opendir later will
> > observe the flag and start iterate_merged - boom!
> >
> > Attached is what I think is a correct fix.
> > WDYT?
>
> This looks correct with my limited understanding of the overlay code. I
> still see the issue when running with
>
> the syzkaller-derived C reproducer in a loop inside an arm64 virtme/qemu
> VM with a KASAN/debug kernel.
>
>
> Let me try to debug it more and get back.

Thanks! I appreciate it.
I wasn't sure how reliably the reproducer works.

If you do find a fix to the root cause, do feel free to use my patch as is
or modified and post with changes and proper commit message.

b.t.w I am not against adding WARN_ON() assertions in readdir
code to make sure we do not hit a problem like this again,
but as assertions, not as code that looks like it should really
work in this situation (i.e. no dropping of wrong cache just error).

FYI, I had contemplated an alternative fix, but went with the
smallest one:

implement ovl_i_path_type(struct inode *inode)
and make ovl_path_type(struct dentry *dentry) a wrapper

static inline bool ovl_dir_is_real(struct inode *dir)
{
        return !ovl_test_flag(OVL_WHITEOUTS, dir) &&
                   !OVL_TYPE_MERGE(ovl_i_path_type(dir));
}

This fix is a bit nicer to understand and the OVL_WHITEOUTS
flags becomes an optimization for OVL_TYPE_MERGE()
in addition to handling the remnant whiteouts case.

If this happens to survive the reproducer for some reason,
do feel free to post it instead of my patch.

Thanks,
Amir.
