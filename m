Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE74330B11;
	Fri, 19 Jun 2026 07:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781854398; cv=none; b=iLWCvkm62UjUIEavnd3OP6CgCV7Kw8pEWFQ2TDbnQ2Uh6ki1Ke8CinxV9dGSOCRM+EZ5tFHFl1oGXnqx1wEHFnsDKxmbhtD47wnoKCggVUvGZjdPdfjDlxOhJVIH3x5jA5OQWP4vhs8K4QTJyVTAx7PGJnY5HentXG/qObTrIA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781854398; c=relaxed/simple;
	bh=Nvf7s8qbyRw1/uBAH2ygZOoJrU0YdQnG2F5alFm27S4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V4x3NY1/kbvv6e+PkrEYxWGlWSQQEfXD4PQ7rEAGbu6n3nlJ+wNZY6LOKUA13PoU3bU1CNpTQk0qiZ9eESIasUbnVGIiEjgyxe6s/JO0j1bxe3iyegP5Ad3mdys3XHPXOkgFE0+6JdOMA8NY6fjVH8FgzpHeI6XESKdb5DGsKBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ivQAmwpD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ivQAmwpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1E81F000E9;
	Fri, 19 Jun 2026 07:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781854396;
	bh=JEjKWcpKusf3mWokJMCyl0kIQo1AvcxUADv+81h3wBk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ivQAmwpDStodbILtDQcSdWE5n6H48+QOB8qU/Zpr8jtnNfkLjdsbPpH67pe9T29Ea
	 u3k/jM/ZCCopf2+1k349UMZzdWqjnH/bJhLLDFMBRSbIsK23kqXnTGw+JDVqzReIE2
	 lZDTO9oChET1iacapQLC9EaUAv2mjNVp1VxH/GssXc0PS+t2GW7qYUHK5qhO1XXTYZ
	 54buvXACgU2qgp+Nwty4mS7SW3TSDAbwAovxAF6VO7EhK5+cGuxto4SzmHkhDYEju/
	 Dll2416ShNp3qlNi+TrHhEJ05+6/Km2+lbddFACbvLdLQ3HSf8H25JMMYVzKdnLsYj
	 tOHom28NBtm1A==
Date: Fri, 19 Jun 2026 09:33:12 +0200
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 00/10] ovl: support idmapped overlay mounts
Message-ID: <20260619-unsozial-ordnen-vorstadt-cdedd690b947@brauner>
References: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org>
 <CAOQ4uxin8B4SbPjnNL-hUWX4EP3V=8jCO=ENt8SQ2D7wcCsdLg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxin8B4SbPjnNL-hUWX4EP3V=8jCO=ENt8SQ2D7wcCsdLg@mail.gmail.com>

On Wed, Jun 17, 2026 at 03:56:57PM +0200, Amir Goldstein wrote:
> On Mon, Jun 15, 2026 at 3:20 PM Christian Brauner <brauner@kernel.org> wrote:
> >
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
> > Note that fstests will be broken by this temporarily as they rely on the
> > ability to create whiteouts for unprivileged device node creation. That
> > can be adjusted.
> >
> > Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> > ---
> 
> Apart from the minor comments on the test, the entire series looks good to me,
> so you may add:
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> The problem is that my review can only assert that your changes make sense.
> 
> I am not even close to being able to prove that this is risk free.
> 
> This is the first time that we will have a combination of
> FS_ALLOW_IDMAP | FS_USERNS_MOUNT with fs which is a proxy to
> another fs, which to me sounds like Vulnerability Scanners heaven.
> 
> Could we maybe ask our friends in Anthropic to unleash Claude Mythos
> on this work to try to beat the AI kiddies to it before we merge this work?

I would be happy if they did.

> Sorry for my lack of faith in human kind ;)

I will take this personally and I will seek in-person revenge in
September.
