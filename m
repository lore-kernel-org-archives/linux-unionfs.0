Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D085925E44B;
	Tue, 10 Jun 2025 19:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749582125; cv=none; b=SoezuFk+sNF1dkEprYODb1LpLgAva5vPi17L3AwKo26Cd1FVHNYZ8cy5df+/JN2gCf+QKMZl8ma7v4pnrwsgtIHfrDTvPRJs/Z67Xj/a7z4ok5niVsxfRfujsTYFrdjGcDiFa8RvzI6u+FzFAxlVt1vFTSrpSWhIIQMJq1SpgOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749582125; c=relaxed/simple;
	bh=Z0j9548OZRBQ11K5GbnnrVj8JDhvmVtot3IuCk0eANw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TeuOQJreyYfU/2qVIFTlELe3i5QjYSQ97EoO9+ZXzgNT9eaDckkacE5J5CR1JLWhCgJ5We+nAtYchdcUSvfmv4YfuxoqYwhI2JZ7khzRozADETxrH1hZh/tzYQ+YWtxFOKns0KfD9bYQVMYUX7H7YK6vxk+LKVwwIPVgs/0OqRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G+1i8qVi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G+1i8qVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF7FC4CEED;
	Tue, 10 Jun 2025 19:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749582125;
	bh=Z0j9548OZRBQ11K5GbnnrVj8JDhvmVtot3IuCk0eANw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G+1i8qVi8OX2jhbB8n5Z2wKgp8JBDfQE/ElDqm5riOu7l55pxGM1mcmmQ2k1t/n7W
	 +1MRGQNTg6pTwjTal7tRNRqIIRVBeLO9Uoxebtz+9BnpiiXx43o6MyLzgk+G02R687
	 FzV3DBXdS081pKH6oXC5/0IQarOM7NubTlpYvbobWDAEOGLxm9mYUqsPhTmH0Aw3Fn
	 J04aMKaSzqhPl69EyeXEwmsoCgJG2DAQ/hKjLjPy0LrBZyP4GR3+79kOCIF6tgrq/t
	 3D+pylOadMjjVHEFKytofjqYafU285soStVKgpugqLU3Lj/l/t0nRr4NcsJ/QKm+I3
	 1JHBM+ElL4SrQ==
Date: Tue, 10 Jun 2025 12:02:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Zorro Lang <zlang@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/3] fstests: add helper _require_xfs_io_shutdown
Message-ID: <20250610190204.GG6179@frogsfrogsfrogs>
References: <20250609151915.2638057-1-amir73il@gmail.com>
 <20250609151915.2638057-3-amir73il@gmail.com>
 <20250610144206.GB6143@frogsfrogsfrogs>
 <CAOQ4uxiyAu7vkf1WK4f=FPOWLGT5iish4KpscqK=GpTAX6HSQw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxiyAu7vkf1WK4f=FPOWLGT5iish4KpscqK=GpTAX6HSQw@mail.gmail.com>

On Tue, Jun 10, 2025 at 08:34:01PM +0200, Amir Goldstein wrote:
> On Tue, Jun 10, 2025 at 4:42 PM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Mon, Jun 09, 2025 at 05:19:14PM +0200, Amir Goldstein wrote:
> > > Requirements for tests that shutdown fs using "xfs_io -c shutdown".
> > > The requirements are stricter than the requirement for tests that
> > > shutdown fs using _scratch_shutdown helper.
> > >
> > > Generally, with overlay fs, tests can do _scratch_shutdown, but not
> > > xfs_io -c shutdown.
> > >
> > > Encode this stricter requirement in helper _require_xfs_io_shutdown
> > > and use it in test generic/623, to express that it cannot run on
> > > overalyfs.
> > >
> > > Reported-by: André Almeida <andrealmeid@igalia.com>
> > > Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-2350b1493d94@igalia.com/
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >
> > Makes sense to me, assuming you don't want to try to integrate the 'open
> > shutdown handle' dance into this test.
> >
> > ioargs=(-x -c "mmap 0 4k" -c "mwrite 0 4k")
> > case "$FSTYP" in
> > overlayfs)
> >         ioargs+=(-c "open $(_scratch_shutdown_handle)" -c 'shutdown -f ' -c close)
> >         ;;
> > *)
> >         ioargs+=(-c shutdown)
> >         ;;
> > esac
> > ioargs+=(-c fsync -c "mwrite 0 4k" $file)
> >
> > $XFS_IO_PROG "${ioargs[@]}" | _filter_xfs_io
> >
> > (Though I don't know if you actually tried that and it didn't work, or
> > maybe overlayfs mmap is weird, etc...)
> 
> I did not try it.
> I had briefly considered trying and decided it's not worth it.
> overlayfs doesn't have an aops of its own, and mmap results in
> a memory map of the underlying file directly, so the test will essentially
> testing the base via overlayfs which does not add much test coverage.
> 
> I do not object to making this test run on overlayfs, but I do wish to
> keep the helper around for future tests that will not do the dance.

<shrug> If fstests were written in a modern hipster language then
passing around a lambda would be easy and trivial...

...but this is bash.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> Thanks,
> Amir.
