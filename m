Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033091;
	b=ftyXU2nwKIKewNJMPm7E0LZod1kR7cvdONYi+Q8kqYwBdngM23wsGqwjte24y1ivpQpM
	 EJn/1dU5TBalwvYns0GKIsBWj7WXxFYGz6BKafRS1TLqWCnSSIgEawKUfIomHk7lbqKpH
	 pTulDHmKajhCrV8aHdXIgSXM4nPYYFRJqSD58WRSQOxs3/zIekA1kJbiFvg8mlsSj9Shv
	 D22qEq3jwC2KXeYY1iV1GUUfORwy5GsMMGWAVxx9WLwg9i8Q6nrxFN8UvwQQr6Oh3CLYo
	 CUQcPy5NB5uYkG4zaFehnqRUeU2Le3rt7EqgEcPAwOgNBKQwNCWYcRkhR7hXqPI5WBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033091;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=f+vx1peZcQmn5oFx/haBULDmioBqC/Qx2fCbF/YfpzU=;
	b=NteV6tr6U1B/v5FGkHIL5q/LVRUk8SwNRSjcbnWGHHW/6oUG2WuVeAyfhcaLat6CYZ1l
	 wfTnF8cNnrmntp2fH8wGX2YGxGbFH3Gw7fz/dXoxruGh30l29pSNaw4OQ/r8pd/P0GSpz
	 LXpvNfO4HT6YIcQPu5qIge/cCgDGGDjoBuZWVckDJSr1bMCOgHU87vGuCsqfCK/I/OWvO
	 xWh4h1pdPS1Bg17h0+QfDuSfpCzxclOFu7XV68EUr3KHYNTJ+fV8F37VGzDeTiZyYigI2
	 /TvQZvZtEYChalds61HapTFGvWvLFMvmxcKffqnukUpjvl/x+428/Qj5FuIqJJYdrlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=auuRC7Wz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0B9606A330;
	Wed, 18 Nov 2026 20:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=auuRC7Wz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CEB1F000C7;
	Wed, 18 Nov 2026 20:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795033091;
	bh=f+vx1peZcQmn5oFx/haBULDmioBqC/Qx2fCbF/YfpzU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=auuRC7WzSWOxgcx3dO6ybMSx7EvHoZEbVenqbSc+6HVnWTROvrZG4apciI3xcYi7V
	 O8hw0za3biBNPc/x9zf84J5rHXcbKI7LTf8vV/JKfOzDMtq+xaJv4EAVuJcAgQFrVz
	 S676R1IG5HJtlBKBQ1B5KtJpK4PZKsTViajM+aw9zTfaBmf1hSA735oDDUU3uqxD4b
	 cZP5J8NcCn211UVNEVBVQcsVfbG7YkCF8EZWQ7LZ6iKJ7XodFn42ZKoB+MCZlIlw7u
	 gTX9I0gulu4Urc/0XuvrfFJ/EjEnUKN+0x32xPTioEtVhs8MJBsc07qQi5HjbROrsJ
	 9iXKDuSd2WvgA==
Date: Wed, 18 Nov 2026 21:18:07 +0100
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org
Subject: Re: [PATCH 4/6] ovl: refuse pseudo lower layers unless offline lower
 changes are allowed
Message-ID: <20261118-einmal-weckt-umgibt-78c16c8bab39@brauner>
References: <20261118073102.1216568-1-amir73il@gmail.com>
 <20261118073102.1216568-5-amir73il@gmail.com>
 <20261118-wildwasser-raketen-hierbei-10c9d844ca6f@brauner>
 <CAOQ4uxh7ri8hF_4+2p4M5rotQ5UF9bKEXr_mQLQU2DDLe6NdOQ@mail.gmail.com>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxh7ri8hF_4+2p4M5rotQ5UF9bKEXr_mQLQU2DDLe6NdOQ@mail.gmail.com>

On Wed, Nov 18, 2026 at 05:54:04PM +0100, Amir Goldstein wrote:
> On Wed, Nov 18, 2026 at 5:26 PM Christian Brauner <brauner@kernel.org> wrote:
> >
> > On Wed, Nov 18, 2026 at 08:31:00AM +0100, Amir Goldstein wrote:
> > > -             /* Pseudo filesystems don't hold data for metacopy files. */
> > > -             if (i >= ctx->nr - ctx->nr_data &&
> > > +             /* Pseudo filesystems don't mix with new overlayfs features */
> > > +             if (!ovl_allow_offline_changes(ofs) &&
> > >                   (l->path.dentry->d_sb->s_iflags & SB_I_PSEUDO)) {
> >
> > sashiko.dev <sashiko@sashiko.dev>:
> >
> > [Severity: Medium]
> > Does checking ovl_allow_offline_changes(ofs) here run before
> > ofs->config.index has been finalized?
> >
> > [...]
> >
> > Because most pseudo filesystems do not implement export operations,
> > evaluating ovl_allow_offline_changes(ofs) before those fallbacks run
> > causes a regression where mounting with an upperdir over a pseudo lower
> > layer fails with -EINVAL instead of falling back to index=off, and makes
> > multi-layer mounts depend on whether a non-exportfs lower layer appears
> > before or after the pseudo layer in lowerdir.
> 
> This has the opposite effect of what I want to achieve with this patch set.
> 
> If I could ban pseudo layers completely I would have but I am afraid
> to cause a regression to some legacy use case.
> 
> index=on which falls back to index=off is not a legacy use case.

So it's stricter your way. Very nice.
