Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A9251C322;
	Tue, 29 Sep 2026 14:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790692847; cv=none; b=tDgDOgOzl052H4vOcojNmp4ECUXHaXFPbjQdDnLGxNXhFVxOEgRMDfZXZ8ekGPH56X6+dAqgqgx4IQBpPnRzlxEFtI6QM1gWCMUwoe+Nsz0Wnz4i66jRogVyMSWs2a/kraKFKBRlPOOcOzM7KL72hOFZitjs5wwYoxWH6XOFQLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790692847; c=relaxed/simple;
	bh=pdg8fO7+sYzEICSiHorL6u51qpr7bbziZPeIRJ8DnII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WE9hTnT9ysIXs+qrLcpQ+jmEeFSKPY/JogRffjDjLSB9fr1xvlTd2suaVxDUeV0zwiqH4jBr/0VoxHz0UCSXxmx0dQptPVxO/oymp05fJGgyYiATXk2oeXs8hg48mp3CXGg4RAYFYDpJGhB1CoeSy9Xrsceb8c1573AMRoPOAM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PxZmXfC8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PxZmXfC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915A41F000FF;
	Tue, 29 Sep 2026 14:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790692841;
	bh=a5cHwHJWG+PdvObG6mgULv2DV2MwXG2ifabqUSsYM9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PxZmXfC8YqsppmyjCnfb95WGea1J5Ah6N6sQjZWQXl/5JzSDueg34gZDFv7g3ur2h
	 1CmLjdRUdmbpi0euwALi+zBhQSH9VAeLqHEPb4R0TawXcdwix0M9MAwKZmMeyUu7M3
	 aKD7+yipa6i9FzKrAmi5lZelkEcHC50IC6JorSHnGcsE2OOswpeNV3m9l8TrxmxtGK
	 shWYRf06U05ReKL3CjR1G1goxX7VXGSZlbyaNjAXMK9/t9eCxPTR/VLbP4JAWiOmRd
	 cQBCY789a33BoVd4deCWQglUV0mTgTQoHnjvahwb3xyjR/zEg8esHSJgWi6QDhoAYl
	 sC1Gf/urvDITw==
Received: by pali.im (Postfix)
	id 9882A5F9; Tue, 29 Sep 2026 16:40:43 +0200 (CEST)
Date: Tue, 29 Sep 2026 16:40:43 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>, Hugh Dickins <hughd@google.com>,
	Daniel Tang <danielzgtg.opensource@gmail.com>,
	linux-ext4@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org, linux-mm@kvack.org,
	Chuck Lever <cel@kernel.org>
Subject: Re: [PATCH 4/4] ovl: Expose the filesystem encoding through sysfs
Message-ID: <20260929144043.5rg4zf7uth333qke@pali>
References: <20260928213155.2612039-1-krisman@suse.de>
 <20260928213155.2612039-5-krisman@suse.de>
 <CAOQ4uxj7Vx-UGvgGGr9hPC0qUgJZ_WRAv1ZLi=gJ6r=ZJW0QAQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxj7Vx-UGvgGGr9hPC0qUgJZ_WRAv1ZLi=gJ6r=ZJW0QAQ@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Tuesday 29 September 2026 16:15:04 Amir Goldstein wrote:
> On Mon, Sep 28, 2026 at 11:32 PM Gabriel Krisman Bertazi
> <krisman@suse.de> wrote:
> >
> > This patch reproduces the same interface from ext4/f2fs to have feature
> > parity, so users don't need to rely on parsing dmesg or trying +F on a
> > temporary directory just to check for support.  Note there is no
> > encoding_flags file, as none are supported by ovl.
> >
> 
> Gabriel,
> 
> I am not ok with this API.
> It is wrong in several ways.
> It is not generic, we have already file_getattr() to get casefold status.
> There was a suggestion by Pali [1] to get the supported xflags - statx style,
> which can be a way to say if a fs could return FS_XFLAG_CASEFOLD.

Yea, sorry for that. I have not finished it, I did not have time. But I
would like to address this as this is something was was asked more times...

> In Chuck's v2 [2] FILEATTR_CASEFOLD_TYPE was already suggested
> as an extension to file_getattr(). I think we can still do that if we include
> proper versioning in the casefold type.
> 
> TBH, I don't think anyone requested this - you only mentioned
> the need to know if tmpfs was mounted with casefold on and that
> doesn't mean that etx4/ovl patches are justified, but ext4 can decide
> for themselves.
> 
> The point is that this sysfs is not going to be the standard for all the
> fs that can return the FS_XFLAG_CASEFOLD, so I see no reason
> to add this sysfs interface to ovl.
> 
> Thanks,
> Amir.
> 
> [1] https://lore.kernel.org/linux-fsdevel/20250216164029.20673-4-pali@kernel.org/
> [2] https://lore.kernel.org/linux-fsdevel/20251211152116.480799-2-cel@kernel.org/
