Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BA5435AAA;
	Wed, 12 Aug 2026 15:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786550200; cv=none; b=SR3g7571/1iMsgptCI7yn5tlhTfxwjQKq7+pDcBYTFy7Vw33yIvjr4jX92axKeOrpJi2sHqkXL8Aa5YBgZMcWeF84xjjZrqBCpU+pkBxeKo1QnhFEGCEccBwCHOHeH2UFj//hH5o4XsC6SMiELZM9U8EVKRK0agyGSzXc/W/HPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786550200; c=relaxed/simple;
	bh=UXOT7UfYAmTDExcTvUrH03rt3P6CCxFC1eG27pxtvlg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YpCNROXCCl7fYTTb7X6XC1M0p7OLXNl/z7XXwHwo17Va7mDImaqBaufbmNAcAqxCCkUa939EPndnFpFETGCGpws1HQUQTeI79qhvjT0O3VvvC+axjXT8hdjgazflUP5rqXnl1M2vyqCjwcz5SnBWf9BCVpbCLKpoJpV/9/IC4t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I3YZhT4g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I3YZhT4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6221F000E9;
	Wed, 12 Aug 2026 15:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786550198;
	bh=lgNtBeh/+/UdWsvoe7xMVluV4NtZC4OzReKJyZrcEeM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I3YZhT4gJX4OVP+Rl6xOHpD0i9hgu6QtLixA2jkE7L1R19AQFhT+cs3wQY1+P7qNC
	 q613k57GmuQNg1c4iU63c8z1N0AZkFqZ4TsGSCNwiqQG7PTH1Z9FHc4Tta50mw2aoM
	 oh5xIr32ve8PZU0ulcwA1PaxILUYd0DlP4RVBWApqYUcf1V1G05NoPbZdM2mohoaN/
	 /6wK35wHWrbbGL8aggGW14TQuFYdfH1c0Mb2mad7MjSESg2qcbkoFzyhMUmoQO80sS
	 h1HCAj9we4SerTpnQ47lrC/riVLZheumvYwMgN0gKNspwXnWspCbsxLaiiRDhVwGkN
	 uVihMK7WMjtAw==
Date: Wed, 12 Aug 2026 23:56:31 +0800
From: Zorro Lang <zlang@kernel.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Christian Brauner <brauner@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] src/vfs: probe O_TMPFILE support on the base mount
 in the idmapped tests
Message-ID: <anyWAp6UjfojZtAL@zlang-mailbox>
Mail-Followup-To: Qu Wenruo <quwenruo.btrfs@gmx.com>, 
	Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	fstests@vger.kernel.org
References: <20260615-overlay-idmapped-vfstest-v1-0-c6b3b2228092@kernel.org>
 <20260615-overlay-idmapped-vfstest-v1-1-c6b3b2228092@kernel.org>
 <fbfbafef-2b42-4f5e-ac8e-9c680a0be5ad@gmx.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fbfbafef-2b42-4f5e-ac8e-9c680a0be5ad@gmx.com>

On Mon, Jul 20, 2026 at 06:15:31PM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/6/16 01:03, Christian Brauner 写道:
> > openat_tmpfile_supported() in the idmapped mount tests probes O_TMPFILE
> > on the idmapped mount (open_tree_fd) as the test's fsuid -- but that
> > fsuid is not mapped by the idmapped mount under test, so it really asks
> > "can this unmapped caller create a tmpfile through this idmap?" instead
> > of "does the filesystem support O_TMPFILE?".
> > 
> > On overlayfs this is a false negative: the backing tmpfile ends up owned
> > by an unmapped id, overlayfs opens it with O_NOATIME and may_open()
> > returns -EPERM, so the tmpfile sub-tests are wrongly skipped.
> > 
> > O_TMPFILE support is a property of the filesystem, not of the idmapped
> > mount or the caller's mapping. Probe info->t_dir1_fd, the base mount
> > that the caller owns, exactly as the non-idmapped setgid tests already
> > do. The probe then succeeds on every filesystem and the tmpfile
> > sub-tests run as the mapped fsuid.
> > 
> > Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> 
> Furthermore, since kernel commit 539dce114465 ("fs: refuse O_TMPFILE
> creation with an unmapped fsuid or fsgid"), even without overlayfs the
> involved tests will fail due to the extra checks.
> 
> So this is not only affecting overlayfs but all regular fses now.
> 
> I hope we can at least merge this one asap.

Hi Wenruo,

Before merging this patch, I've merged your:
  commit 1cca2bc0d7a9462bb1b59edb108bac7c9e7c424d
  Author: Qu Wenruo <wqu@suse.com>
  Date:   Fri Jul 17 16:37:17 2026 +0930

      fstests: vfstest: skip rejected tmpfile creation

Since (Christian's) patch seems to replace yours (I think), so do you mind
if I revert your patch and merge this one instead?

Thanks,
Zorro

> 
> Thanks,
> Qu
> 
> > ---
> >   src/vfs/idmapped-mounts.c | 12 ++++++------
> >   1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/src/vfs/idmapped-mounts.c b/src/vfs/idmapped-mounts.c
> > index ed9992f9..8f8441c9 100644
> > --- a/src/vfs/idmapped-mounts.c
> > +++ b/src/vfs/idmapped-mounts.c
> > @@ -3838,7 +3838,7 @@ int tcore_setgid_create_idmapped(const struct vfstest_info *info)
> >   		goto out;
> >   	}
> > -	supported = openat_tmpfile_supported(open_tree_fd);
> > +	supported = openat_tmpfile_supported(info->t_dir1_fd);
> >   	pid = fork();
> >   	if (pid < 0) {
> > @@ -4014,7 +4014,7 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
> >   		goto out;
> >   	}
> > -	supported = openat_tmpfile_supported(open_tree_fd);
> > +	supported = openat_tmpfile_supported(info->t_dir1_fd);
> >   	pid = fork();
> >   	if (pid < 0) {
> > @@ -7733,7 +7733,7 @@ static int setgid_create_umask_idmapped(const struct vfstest_info *info)
> >   		goto out;
> >   	}
> > -	supported = openat_tmpfile_supported(open_tree_fd);
> > +	supported = openat_tmpfile_supported(info->t_dir1_fd);
> >   	pid = fork();
> >   	if (pid < 0) {
> > @@ -7947,7 +7947,7 @@ static int setgid_create_umask_idmapped_in_userns(const struct vfstest_info *inf
> >   		goto out;
> >   	}
> > -	supported = openat_tmpfile_supported(open_tree_fd);
> > +	supported = openat_tmpfile_supported(info->t_dir1_fd);
> >   	/*
> >   	 * Below we verify that setgid inheritance for a newly created file or
> > @@ -8181,7 +8181,7 @@ static int setgid_create_acl_idmapped(const struct vfstest_info *info)
> >   		goto out;
> >   	}
> > -	supported = openat_tmpfile_supported(open_tree_fd);
> > +	supported = openat_tmpfile_supported(info->t_dir1_fd);
> >   	pid = fork();
> >   	if (pid < 0) {
> > @@ -8536,7 +8536,7 @@ static int setgid_create_acl_idmapped_in_userns(const struct vfstest_info *info)
> >   		goto out;
> >   	}
> > -	supported = openat_tmpfile_supported(open_tree_fd);
> > +	supported = openat_tmpfile_supported(info->t_dir1_fd);
> >   	/*
> >   	 * Below we verify that setgid inheritance for a newly created file or
> > 
> 
