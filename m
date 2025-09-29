Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B60E30507F
	for <linux-unionfs@vger.kernel.org>; Mon, 29 Sep 2025 12:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759150600; cv=none; b=XLc5F75Dkph5gDm0YaCHu0xGOhEMRk/tliMKx1F/GSHurPgadwFioWEFpFyeZ1kZNM0RAGKH4vp2mB1xrWrgS9tHwWG6c6wLr1xtN5LLd/as3jW/5ZYiEAcmiMC3F/krlb24KWC3fGyi1NYrj6qBGWtlLZ1aKWUdXvbUtZyZu20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759150600; c=relaxed/simple;
	bh=czoR4K1G+s7y76NbjlWpJJ4z4V3QKtSDAu6HI/RHErw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PK2+XS0JIUlignIaq9B1j6cX12njqT+8Xm1WGmpz+jH2cFZP2bYN4hIduZigXJyEvMrEr7wPqKDvqlGtQ5t79U2KLmOFUAh5gtqpbydAms7OrihQezDLBNOh3qmhhNOudj8C7MFh1KKWB5zSSbRDDmgoz6aKH1Bs3Zvg2H0RUls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FCgn4P2K; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FCgn4P2K"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b3b3a6f4dd4so331660866b.0
        for <linux-unionfs@vger.kernel.org>; Mon, 29 Sep 2025 05:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759150595; x=1759755395; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vT64PoBlF5OmMwmdMDL2m5IBI9zs1VxmhdKVWW/7dn8=;
        b=FCgn4P2K1bIgFAJoDuau++Y6+Tu6orG3eYikQptlTbn2qk5fvnEX7rNz9xsa4ZIAk9
         TNz6RZf1mVEJ+Su1njyT9bIYaseGuw0JWXQMPRpP00jx3gM9a4BJqrnV9kYHqPXbJaOq
         dhlEb8pqe7t8ANKhDaOdu1T1Y/mpR47EeDuatvBM511yYbhWL6Uu/rIc2s4AYq5Ndc0a
         fop7n/Pv7EAT0po0BdS0IYOt4RiIvQ6Mn+1uZG2p8wrWzsrtqds8fVEJ48NrNm2Iofnq
         nfDx40KqhrUAlKvyAFMaZdew5N8LuEja0ysIg0wwj2ntDhoqum1eyE8GcCYO/dnVabBV
         mIUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759150595; x=1759755395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vT64PoBlF5OmMwmdMDL2m5IBI9zs1VxmhdKVWW/7dn8=;
        b=pcm7F4jctgZC7kwpPeHxxx7hZZPRxTBLy6WsSHgrv6R67bZC5ducnBKeyHfjuIiZ8v
         ieehJVOAP9XdXeHj2x89Kf/ouSGpScKR4qnQGlvbEozYqbgez9n4HiFfxc2XIiN7YjoG
         u3vU36PScNihGDGUL+YJvBav2DtYB7kEhq9FLmr2EfwWQ6tIfJFSRDW2UDbJG1vE5D6w
         jWmj+hXLwgxFVjbmdxWW7o+QFa7SE4FbTMFtoU51o6Rh0BAWPOyTSDKL805FVavP+mQ1
         ZH20euXV8LzRcpzJCcXzNH3Eam4LzT41IaBoTK6LKw5S3p1I36N8/uwa977c3/+9BSMn
         hK4w==
X-Forwarded-Encrypted: i=1; AJvYcCWNUt+GY5Q5pS3wOrRsZHB+osmvBMmCY2sCUMKtPW/DTeAcBydm1wcBZbRIfmT+znyAM3wCBECDVQ3Ne10c@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2BLs7fN3JzxEoSizlBdt7m17/wBgHVooWxBmkbOYJZxDdK1xk
	IW6ocRFwswMX9+3x5ahLS/2VLFRtpoirz3ScTQ64UA/Js2Z3kPP9wbUbS0NealHuoodH8aP0lKS
	+i02AgCuljYPe9Gu7WnRDwAVK6u+iFbE=
X-Gm-Gg: ASbGncuTFh+YY3T6LZQtIV9FGk6sRj0SkWFfJIzFPRUNzUOrZq95WNPuRvqetDv0ALK
	yWhmkGnSVbjNWfj4nuD+OZ6iOU4RqM80kG6m2Z/9o8drCi/wpZF6C67BM8nn0Dti1N1RO4A/Ul7
	UuOv4JI3ZxPQz8x+CrnezbPh8EjlwcusQjQpiMgy1+V22HZzxvLqfGYhJLWhMROEAMirgyMkZuk
	MOQoMGjyyLb68TXS2GEfA309OfNYrNW32JP4Z8tGuN7jNOPeF/iGJzUPXQgyg4=
X-Google-Smtp-Source: AGHT+IHwgU6a7k1Tl/htBp66waMHN4IzraB7wwO8zA//bOHkHjYwuv41WV4gECwjjXP36V6Dgiwj6qkk1Bdqwjmi4TU=
X-Received: by 2002:a17:907:7291:b0:b3f:9eaa:2bba with SMTP id
 a640c23a62f3a-b3f9eaa2f1dmr276916766b.63.1759150595150; Mon, 29 Sep 2025
 05:56:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250923104710.2973493-1-mjguzik@gmail.com> <20250929-samstag-unkenntlich-623abeff6085@brauner>
In-Reply-To: <20250929-samstag-unkenntlich-623abeff6085@brauner>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Mon, 29 Sep 2025 14:56:23 +0200
X-Gm-Features: AS18NWAQppLQGH4Q4QepXGfVar_40_jU-wol-wjJISWMpqe1GoM3Cv27IqmClpo
Message-ID: <CAGudoHFm9_-AuRh52-KRCADQ8suqUMmYUUsg126kmA+N8Ah+6g@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] hide ->i_state behind accessors
To: Christian Brauner <brauner@kernel.org>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, josef@toxicpanda.com, kernel-team@fb.com, 
	amir73il@gmail.com, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This was a stripped down version (no lockdep) in hopes of getting into
6.18. It also happens to come with some renames.

Given that the inclusion did not happen, I'm going to send a rebased
and updated with new names variant but with lockdep.

So the routines will be:
inode_state_read_once
inode_state_read

inode_state_set{,_raw}
inode_state_clear{,_raw}
inode_state_assign{,_raw}

Probably way later today or tomorrow.

On Mon, Sep 29, 2025 at 11:30=E2=80=AFAM Christian Brauner <brauner@kernel.=
org> wrote:
>
> On Tue, 23 Sep 2025 12:47:06 +0200, Mateusz Guzik wrote:
> > First commit message quoted verbatim with rationable + API:
> >
> > [quote]
> > Open-coded accesses prevent asserting they are done correctly. One
> > obvious aspect is locking, but significantly more can checked. For
> > example it can be detected when the code is clearing flags which are
> > already missing, or is setting flags when it is illegal (e.g., I_FREEIN=
G
> > when ->i_count > 0).
> >
> > [...]
>
> Applied to the vfs-6.19.inode branch of the vfs/vfs.git tree.
> Patches in the vfs-6.19.inode branch should appear in linux-next soon.
>
> Please report any outstanding bugs that were missed during review in a
> new review to the original patch series allowing us to drop it.
>
> It's encouraged to provide Acked-bys and Reviewed-bys even though the
> patch has now been applied. If possible patch trailers will be updated.
>
> Note that commit hashes shown below are subject to change due to rebase,
> trailer updates or similar. If in doubt, please check the listed branch.
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
> branch: vfs-6.19.inode
>
> [1/4] fs: provide accessors for ->i_state
>       https://git.kernel.org/vfs/vfs/c/e9d1a9abd054
> [2/4] Convert the kernel to use ->i_state accessors
>       https://git.kernel.org/vfs/vfs/c/67d2f3e3d033
> [3/4] Manual conversion of ->i_state uses
>       https://git.kernel.org/vfs/vfs/c/b8173a2f1a0a
> [4/4] fs: make plain ->i_state access fail to compile
>       https://git.kernel.org/vfs/vfs/c/3c2b8d921da8
