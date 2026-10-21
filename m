Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792580171;
	b=O3YjOsPN0kfTA6FPb5qNZoiK4hgTbQNuGs55vj97QRLinR251vc/wv4FR6su/FXugRLo
	 FEm6I8/6SlbwgCDtjNhagQrkOWBdFKFRpJQNFaDgN7dMZ3i25yUEmxZLJHlG9qw8qlsrU
	 zoR2ubjAEGCmjKM0ztEZPSpOoXcHado29SQqf21ixC0UEjHQ75Edssjb7mfHs4fEsHFGH
	 s66cveynSo6mQPiPZ2NWOEsC5j3hIiqBKLhTFlQJcOjLw96A1Rl0ILh79cSRxxhWO2a3V
	 tcJwUUzOUj0llm5TYT/A8IblTj9RK2LgjVJ+p8Cy1rQJDwYtgCPVaEsjfXvRZTrvbOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792580171;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=4LQcLx3+n5TnXnnlAWpBkySMYw+53giT2E6ez02siXk=;
	b=Civ60L5r9ey1T0tpNAActwjtZ3kxEvtUP52jIn8cOIBc9+/osrMmRYjf+GIwj/idNYCA
	 u0LgrCx6wRRViwNcs0GE+5u1PsZp0YGj98uisY9XZIvgz2Ll2e0Ezp/8RiFXphna7w89s
	 8jqluzbj2BCJW2fMy5mA8VZQ6LZT3s9oOcWcfrf68VBruD6DfqUdzi9RwiMb8APeufKGP
	 /nLfaCoBkoFXKx6U0Uvxh29an7lytJkLiLyVCwI15LinWyoFNKaLbDPTGrDIyGxz/mOzs
	 4dIHA43Cql6fJU0FI4Gg5xZvDw58vPtsNsaKGC/LorZyJt5BwvYK/CiNcVsLHIsvsaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UU21fO2j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F21606A31B;
	Wed, 21 Oct 2026 10:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UU21fO2j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54EE81F000D1;
	Wed, 21 Oct 2026 10:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792580170;
	bh=4LQcLx3+n5TnXnnlAWpBkySMYw+53giT2E6ez02siXk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UU21fO2j5G0aSYeidDVFM3gpaRpwWYrrnuE6RBYB9+VDbiavCEj/WVh9uVhhcX66S
	 LTduuBydkK3+KdRyB7NK1bR6qYKSr0mdl+BQshMZGCuTRbVqiiHKOFqcZ0hHIgzWWY
	 Ih8P6396MVPtHyn6bSdVnKvDsaJDqOFzUMk+8tJjOXKmJlKYs4z2iZQDuWiYoScDry
	 rWvrHeDUwyNE1G/l/3/BPzdT+CrPNvysrbmzIHFp1E1VvE1o+XkrIiV55XYxl73eUP
	 bR3YmwehYDdh+2RHZ4ERhFAPFha/jyAGblNvbsjCjnNcMHu6TFpDTFKPrFqihI47Yn
	 bmA1coOBRCrBw==
Date: Wed, 21 Oct 2026 12:56:05 +0200
From: Christian Brauner <brauner@kernel.org>
To: Disha Goel <disgoel@linux.ibm.com>
Cc: miklos@szeredi.hu, amir73il@gmail.com, viro@zeniv.linux.org.uk, 
	jack@suse.cz, shuah@kernel.org, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 2/2] ovl: fix wrong layer paths in mountinfo for detached
 mount FDs
Message-ID: <20261021-erbschaft-gefahndet-erklangen-085a518222a3@brauner>
References: <20260924112858.51392-1-disgoel@linux.ibm.com>
 <20260924112858.51392-2-disgoel@linux.ibm.com>
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
In-Reply-To: <20260924112858.51392-2-disgoel@linux.ibm.com>

On Thu, Sep 24, 2026 at 04:58:58PM +0530, Disha Goel wrote:
> When overlayfs layers are passed as detached mount file descriptors
> (opened with open_tree(OPEN_TREE_CLONE)), ovl_parse_layer() uses d_path()
> to record the layer's path for display in mountinfo.
> 
> d_path() walks up the mount tree to the process's filesystem root.  For
> detached mounts this walk stops at the anonymous namespace root instead
> of the real system root, producing a short incorrect path like "/l1"
> instead of the full absolute path.
> 
> Export mnt_is_anon() from fs/namespace.c to detect detached mounts.  In
> ovl_parse_layer(), use dentry_path_raw() for detached mounts instead of
> d_path().  dentry_path_raw() walks the dentry chain independent of mount
> namespace and returns the correct fs-relative path.  The path is
> display-only; the actual layer_path used for mounting is always correct.

I think that's nonsensical you might end up with complete garbage. We
should think about a custom format so userspace can "label" the file
descriptors instead? Amir?
