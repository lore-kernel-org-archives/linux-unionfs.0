Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793824726;
	b=GvSAA672PpZfYLKkbqefOECzvtNTCx1Rs9IMEHfhBOC/1BcajqqVSIqgYSlLU69tQKts
	 FvFGQRjtgY2xOig82SN8ycshKlTUIzs9uTZZBz821eX630gPX7px1gZPgeNfgoWjM8brs
	 ufgtEbse2pbIx02xgqmOOcbQXm98S5F7JGrdFfvkU3DxYYt0+O8cZhfMTbVLXg0taPBHR
	 dPdKhnozxeEWQKfCRmEYEeQN8c5zBLVYbP2vDv6/DoJGlm+1t8Hk7LALErKfPSr6mFsZC
	 UftNgvIB+4g13a940EFbDaFaOqNyKodc3p0UeBbm5z3WLWUi8hK++7w6GIfhsnM7cDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793824726;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=ycRLp6ci/7TqbrAP641Fmqu92RF6ANUgfXGhTuWgflw=;
	b=gl7jF0vt/BhqPxFmzFppc6IblqJPmAWdcyG0CqjaBENNL78MJX+Xj5NhhgVQH0+6EbuT
	 9/gNhU5UXiqcbipW2ZqK/j9pAfOa7fheLodt2oAw/2SYzUNZUE5Xknq1vRCqd1BTp4xgx
	 OS/nvMGtDX4fFaGdHlrdYmI2qZGCk81aGmKRbfUhzhOTD929R1xhV6WgHkM7yW98SPmc7
	 PZpGzgqk0z0CHshahxoouXhFKGy7RkqdwbLGKXWU5zPn9SD+XpbLv0VRqDD4/MNHKZgvB
	 kUHFHRpz8qYw9Z9X85bPN4sFeH3gHnI4jjL+al6uO/e+heyoCoyO4WgNz6vxZXMdVwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uyVRkStS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193C2606A864;
	Wed,  4 Nov 2026 20:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uyVRkStS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974791F000C1;
	Wed,  4 Nov 2026 20:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793824725;
	bh=ycRLp6ci/7TqbrAP641Fmqu92RF6ANUgfXGhTuWgflw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=uyVRkStSs0NW8T5BjydiQwlVhFwqewFfhR5vMiW72yKn4BwhH0vt3ywW8PN+0x4e/
	 PYxzwnsOtL3GCRtSQQF0cry1iFYWvO6Lmmi2u5+USvZwJo9WTLR//ay+yyJaadUwvx
	 dD8fx7VABbp6ZZ1835LtGyJxGd05+vsPgDsHNcJI=
Date: Wed, 4 Nov 2026 15:38:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 6.1 2/3] ovl: skip copy up of empty security.capability
Message-ID: <2026110432-vanish-cadillac-209e@gregkh>
References: <20261104185536.3631167-1-amir73il@gmail.com>
 <CAOQ4uxhi3aM57BrXmM238TO3baeN75JduY4fQ8km8bLOx_SXyQ@mail.gmail.com>
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
In-Reply-To: <CAOQ4uxhi3aM57BrXmM238TO3baeN75JduY4fQ8km8bLOx_SXyQ@mail.gmail.com>

On Wed, Nov 04, 2026 at 08:47:40PM +0100, Amir Goldstein wrote:
> On Wed, Nov 4, 2026 at 7:55 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > commit 50912a1715b8a7c614b654011a0db750e372b43e upstream.
> >
> > ovl_copy_xattr() gives up if it can't read an attribute that
> > listxattr() has named.  An empty security.capability, which anybody has
> > been able to store on any file for a long time, is such a case: it is
> > listed, and getxattr() has nothing to return for it.  A file in a lower
> > layer that carries one can't be copied up: it can't be written to,
> > renamed or have its mode changed.
> >
> > There is nothing to copy if there are no data.  Go on with the next
> > one.
> >
> > Fixes: 8db6c34f1dbc ("Introduce v3 namespaced file capabilities")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > [amir: treat -EINVAL as no capability too, and do the same in
> >  ovl_copy_up_meta_inode_data()]
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> > [ backport: context: no blank line before the ovl_getxattr_value() call;
> >   depends on e6b9117076fb ("ovl: fortify ovl_copy_xattr() against
> >   underlying layer modifications") ]
> 
> Greg,
> 
> Sorry for messing up the send of this series.
> 
> This one depends on patch 1/3 from Message-ID
> <20261104185356.3631002-1-amir73il@gmail.com>

Not a problem, thanks for all of these, now queued up.

greg k-h
