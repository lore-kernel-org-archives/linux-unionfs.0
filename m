Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12A324A07C;
	Tue, 20 May 2025 14:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750378; cv=none; b=FSD2tzmMWvcEpOJMs/rkv/NAueMGc53fR4r3sm7MNBQf8RcR/Og2H3hkZLgWXqMEoIYpaaYlI0e7G6c8jRCztGFqPfsC4dcOAR2I1nrMMnYtIKZ52v0pXUfk1M1QT3kFArFBNjupAUdpW8PcGI7IQfUtbGi+LePKeflmskq9nm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750378; c=relaxed/simple;
	bh=6R/ifOTC6mhoWQNYVYEChCOtxwiETwG6sLcxI3wonZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qPwnMypnvl+3cBUAiczEpgmw8D8/Q3/cmAkiC2qDlbYEmBLRMuTGzUu+M46kfstD0DOpNR2vKkQAbyK95qkibXJDdl5iNMcsgkH3TyYV4ADtdKFYJvmyN917NfHNDBw6iug64wKPy8cfJt+Y0a/L7Bm+RHl6VABMi7E/1uM1mCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m7im/9Nr; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m7im/9Nr"
Date: Tue, 20 May 2025 10:12:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747750373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uWdgshAxQBDMuyVdErketAUpJfsOIAIWM/AFJcX/jG4=;
	b=m7im/9Nr32MQB+DZuFeKUqm4oelCd8K8Y0Wx+KLy2yUEg1epKjE3u/JXLLjKoFQ/fb7EHv
	2lfibNtxVrHi1rV2gzIHcwJGjuxkq62u3VMx1bLBE2rpwVfSJhVoOrG2Fhw9zO1oxaPAku
	7NLmtGG4mJhULniDZvHBHuLCD3cNYXo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/6] overlayfs + casefolding
Message-ID: <rkbkjp7xvefmtutkwtltyd6xch2pbw47x5czx6ctldemus2bvj@2ukfdmtfjjbw>
References: <20250520051600.1903319-1-kent.overstreet@linux.dev>
 <CAOQ4uxg8p2Kg0BKrU4NSUzLVVLWcW=vLaw4kJkVR1Q-LyRbRXA@mail.gmail.com>
 <osbsqlzkc4zttz4gxa25exm5bhqog3tpyirsezcbcdesaucd7g@4sltqny4ybnz>
 <CAOQ4uxjUC=1MinjDCOfY5t89N3ga6msLmpVXL1p23qdQax6fSg@mail.gmail.com>
 <gdvg6zswvq4zjzo6vntggoacrgxxh33zmejo72yusp7aqkqzic@kaibexik7lvh>
 <CAOQ4uxg9sKC_8PLARkN6aB3E_U62_S3kfnBuRbAvho9BNzGAsQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxg9sKC_8PLARkN6aB3E_U62_S3kfnBuRbAvho9BNzGAsQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, May 20, 2025 at 04:03:27PM +0200, Amir Goldstein wrote:
> On Tue, May 20, 2025 at 2:43 PM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Tue, May 20, 2025 at 02:40:07PM +0200, Amir Goldstein wrote:
> > > On Tue, May 20, 2025 at 2:25 PM Kent Overstreet
> > > <kent.overstreet@linux.dev> wrote:
> > > >
> > > > On Tue, May 20, 2025 at 10:05:14AM +0200, Amir Goldstein wrote:
> > > > > On Tue, May 20, 2025 at 7:16 AM Kent Overstreet
> > > > > <kent.overstreet@linux.dev> wrote:
> > > > > >
> > > > > > This series allows overlayfs and casefolding to safely be used on the
> > > > > > same filesystem by providing exclusion to ensure that overlayfs never
> > > > > > has to deal with casefolded directories.
> > > > > >
> > > > > > Currently, overlayfs can't be used _at all_ if a filesystem even
> > > > > > supports casefolding, which is really nasty for users.
> > > > > >
> > > > > > Components:
> > > > > >
> > > > > > - filesystem has to track, for each directory, "does any _descendent_
> > > > > >   have casefolding enabled"
> > > > > >
> > > > > > - new inode flag to pass this to VFS layer
> > > > > >
> > > > > > - new dcache methods for providing refs for overlayfs, and filesystem
> > > > > >   methods for safely clearing this flag
> > > > > >
> > > > > > - new superblock flag for indicating to overlayfs & dcache "filesystem
> > > > > >   supports casefolding, it's safe to use provided new dcache methods are
> > > > > >   used"
> > > > > >
> > > > >
> > > > > I don't think that this is really needed.
> > > > >
> > > > > Too bad you did not ask before going through the trouble of this implementation.
> > > > >
> > > > > I think it is enough for overlayfs to know the THIS directory has no
> > > > > casefolding.
> > > >
> > > > overlayfs works on trees, not directories...
> > >
> > > I know how overlayfs works...
> > >
> > > I've explained why I don't think that sanitizing the entire tree is needed
> > > for creating overlayfs over a filesystem that may enable casefolding
> > > on some of its directories.
> >
> > So, you want to move error checking from mount time, where we _just_
> > did a massive API rework so that we can return errors in a way that
> > users will actually see them - to open/lookup, where all we have are a
> > small fixed set of error codes?
> 
> That's one way of putting it.
> 
> Please explain the use case.
> 
> When is overlayfs created over a subtree that is only partially case folded?
> Is that really so common that a mount time error justifies all the vfs
> infrastructure involved?

Amir, you've got two widely used filesystem features that conflict and
can't be used on the same filesystem.

That's _broken_.

Users hate partitioning just for separate /boot and /home, having to
partition for different applications is horrible. And since overlay fs
is used under the hood by docker, and casefolding is used under the hood
for running Windows applications, this isn't something people can
predict in advance.
