Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620F63F5BC3
	for <linux-unionfs@vger.kernel.org>; Wed, 17 Jun 2026 13:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781704631; cv=pass; b=cFg0CkUxzi4ReBGzLvzQw70h0sYRHms1dogKsqW6GyYYVUL5TfVkrln6aQkzFY0uPUqcwEvhBG9zfub65STd1eJI/CjIlmyq0Mj41uk13H1cHL+HitKmCHmDPvkVEGsj1dxGJnEbr5Cp/YhhhzA6nXXKUs51dyo+BnuDRo+3VVA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781704631; c=relaxed/simple;
	bh=dE5QCB49gSg1E/RqRTQMAXzDMVbNpSI9Wu25lRSuKrE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WQNZp2J/K3+h/zXRa+Ewy/dqB4X63v/7+uMDxbbAEYBh8c/daL9lmG7/+O/IW9/9FReqJRafrgKtu9XDjAcl/tNyqHB6EjscBj7PrE42Xmk0PDuAm+WwMBrg9KpX9XW1tP6IP0T9K1WQQz5HPtzT0qRO7FmLeRAELZf+UYh1Zdc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kUelxZlk; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kUelxZlk"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-69583ca0499so846285a12.1
        for <linux-unionfs@vger.kernel.org>; Wed, 17 Jun 2026 06:57:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781704629; cv=none;
        d=google.com; s=arc-20240605;
        b=F0zE5crWk9JKIr7/fAtNdYkW6JTu4qaNyAdcibz6IrPjI0O6ILwb7f11ikHvvtr2/9
         XatVKxzQqLXix0YcOPVHXsEogXRlh4tNi03C0c4ThAx8ZEF81RvoA7B9e8mZ3S9fb5FR
         XlXGc6mBZo0J72S6ULuYSJDy1SEkveqrwRmNLKxZH7Rm4uwyIWm8lU0x3PncGO18s7Ov
         odm9+0NBR/Ke5rh28KTU7KP4fajzEi9SZFBe/ye3Nxbo7Fn9qTAcRUf+o3MfJbuyUcUO
         jQ+uzWRehw+95px43g82N2wRVYzbZrmUJd5AsHDVCpsdnxVwS40x4t86xfKLwXWbZ6iM
         EKIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+wp0SeU5SONpnRADKEmw1FslXvGN/FM0f3dCvuAH5VU=;
        fh=sc3kj5pSs5SZNzDLvxlWLd/Wk1N7wVXMaZf4uYXCJ0U=;
        b=VXYv4qgb3yV2lawf7BsRvT5fTTi+R0cw8bThCjMkAziePkmaTbo9/42yIMoblJc9rb
         o81D3jFUg9HTwKg3wM5JZRg5L+chuDsAWn0CZrqKXGcpCVRq5GRiXsuCLjZus1lvyh7i
         1RNGGxxSNY/khMZQgUTFbXnMzKRI8aCthsO5e6rSk7lkP79aHU4+p/Y2HjGyhSv7QYBb
         wSJEsINqhpME0c0ekPrDC9EzjMw43mE3oZXKPozh6qX4i2jR7wnzaeZ8TkqYMEmSOp6A
         +VlnqHkOGzKJqUEYKE66qK6dIQL5qU8b7OqCdkPc5iGywAQuK9YuhUug+Z8GoGoqBaYV
         O/jw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781704629; x=1782309429; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+wp0SeU5SONpnRADKEmw1FslXvGN/FM0f3dCvuAH5VU=;
        b=kUelxZlkwIHbfz5fnhT976luhMbfUekPLZOAEFTci1N8RM2ZW71hOvNJ9CVzugTqVZ
         6C+GlEhDYA16Xq3byQpwCMcXCPwpm1aNRoADRrFPvXW8uvEfOsG8cQnoUWJzcWQEZlL9
         g/Ni7HUJ/PSQUyB/Htpc/1kCCNi888W15VAFrIaDz/N2BL7Y+5zY0puqN7awKX2jZ6xl
         j2Ee3OVS9O0WlpA3WuZ7JrQ1uB6YCdNVHixDDy8jYOJu8mwc/PZ9LDu8lAEwHQmuNzP3
         fx6+yyW+wlk1/hiCNByCjiWyTfpKDO5LRXwu1wTArC3LjVFvQ7ifYc7S13cgcSZ1CwFO
         anzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781704629; x=1782309429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+wp0SeU5SONpnRADKEmw1FslXvGN/FM0f3dCvuAH5VU=;
        b=b30ineQHYGIOpflzDfjgFpC2+Dv9fAcoA5/R1Z4zaO59nNmPUBPaBFqinLsQLCYksj
         UWFpiQmOvdRyJrMLcS62GO0+JiPSs67gS7eipD+2LUNovF0b2C+dicAgn1prKg8LeGsm
         amsATm2nvENoKFTRgIiQ+iI7BK/fgT6GxZcrxAWwWi8xvZNrPA/hd7wGhoDD1sijxxXX
         P5HDd/pFI+gk/E67/ipfuCjAyQSbWgrG1F27lnHH18Eiffjes9xSBmSdaBpwbnNLuB2L
         5zKkMeIDCT8tWcAErn5gNFBvqJEveZVlSDozqkRX9QAavEYXo0CA2ppbLX+PSVrtuM0+
         OItQ==
X-Forwarded-Encrypted: i=1; AFNElJ8ORR8Z1SRHeUy74QHejm6XcRMIIu6bRXelZ+X0qChNLaGmWZFq5/yX1uiLUVvMz2hZyIEsEwHBGIi5oM8n@vger.kernel.org
X-Gm-Message-State: AOJu0YwGnCtYbmod1ripZ5NesNmmnDEFrAZ1ESp93kWaKP6pL4V+gsjO
	QeKq6zaiuj2/W5WALbklTtru/ayBv3+RCZiO7Sryx+HxiIg0YSiuMUjVyYNxqZR2X8UX4BZLzfv
	G6LLnom1BfnYn9EY/YrSY0m6/q1W61Ynd73LOYXc=
X-Gm-Gg: AfdE7cmv7uzpsi7oG0nyb+nVg4WMCSyEP9nhvsf2ZREngPlO4PtBK8zvvPoQbH8XCPB
	0oETjV4ScXwst/5xNOPIpFvDMzuWUcJ0f53VdSmbbky2WCw4oiOFWFBjjbn5OWueG9MpXnRwc2m
	QPDaOnh8lgJHm+Yjgcjeyiu9UQRoGpHdQ7U3T4pyT4gwwakMlNbYND4wGKDSKhY6mGDi/MA6M+c
	pQ33aWvlYNOJilR1VnCKicBlJXuLhyhNeV4Thslug98/mxMdHWmykrd9itjMNpwM4NKDiFGw99v
	AH8tm6UW46aP7A8N7Ja0YyYgq1GO0tA=
X-Received: by 2002:a05:6402:43c6:b0:691:6fc9:da9b with SMTP id
 4fb4d7f45d1cf-695476f12f9mr2346333a12.23.1781704628533; Wed, 17 Jun 2026
 06:57:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org>
In-Reply-To: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 17 Jun 2026 15:56:57 +0200
X-Gm-Features: AVVi8Cc91CYxE7YUj4wWZdM6y9_jyZ_C5AaQRG7SM4wSoRtc5uIGg_0FUc1ceTc
Message-ID: <CAOQ4uxin8B4SbPjnNL-hUWX4EP3V=8jCO=ENt8SQ2D7wcCsdLg@mail.gmail.com>
Subject: Re: [PATCH 00/10] ovl: support idmapped overlay mounts
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2026 at 3:20=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> I've been asked about this feature multiple times and had actually
> implemented it right when I did the initial idmapped layer support.
> So here's a new version of this series.
>
> This series lets the merged overlayfs mount itself be idmapped via
> mount_setattr(MOUNT_ATTR_IDMAP), in addition to the already supported
> idmapped lower and upper layers.  It allows the same overlay tree to
> be exposed under a different ownership view, e.g. a container seeing
> the merged tree as 0:0 regardless of the on-disk or per-layer ids.
>
> Overlayfs already normalizes every underlying id through the relevant
> layer idmap when it copies attributes into the overlay inode
> (ovl_copyattr()), so the overlay inode's i_{u,g}id are "overlay-final"
> ids.  The overlay mount idmap O composes on top of that pivot:
>
>     caller view  <--O-->  overlay-final id  <--layer idmap-->  on-disk
>
> O is applied at the overlay-inode boundary only - permission, getattr,
> setattr, the ACL owner checks and inode_init_owner() - while the
> underlying layers keep being accessed with the mounter's credentials
> through their own, possibly idmapped, mounts.  The mount idmap thus
> only changes how the caller sees the overlay inode and never widens
> the mounter's access to the layers: the second, mounter-credential
> check in ovl_permission() against the real inode stays on the layer
> idmap.
>
> Most paths need no change because the VFS applies O to the overlay
> inode before overlayfs runs (sticky/rename/unlink/create gating) or
> after it returns at the syscall boundary (the POSIX ACL get/set
> translation).  Overlayfs only acts where it bypasses the generic path:
> getattr (it stats the real path), the setattr forward to the upper
> (the requested id is rebased from O into overlay-final space before
> being handed down), inode_init_owner() on create/tmpfile, and its own
> owner checks in ovl_set_acl().
>
> FS_ALLOW_IDMAP is set last, once every operation honors O, so there is
> no bisection point where the mount is idmappable but an operation
> still ignores the idmapping.
>
> Note that fstests will be broken by this temporarily as they rely on the
> ability to create whiteouts for unprivileged device node creation. That
> can be adjusted.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---

Apart from the minor comments on the test, the entire series looks good to =
me,
so you may add:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

The problem is that my review can only assert that your changes make sense.

I am not even close to being able to prove that this is risk free.

This is the first time that we will have a combination of
FS_ALLOW_IDMAP | FS_USERNS_MOUNT with fs which is a proxy to
another fs, which to me sounds like Vulnerability Scanners heaven.

Could we maybe ask our friends in Anthropic to unleash Claude Mythos
on this work to try to beat the AI kiddies to it before we merge this work?

Sorry for my lack of faith in human kind ;)

Amir.
