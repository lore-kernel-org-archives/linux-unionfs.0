Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795183364;
	b=2ksBY9J4S0WlB5/fkIU9CxP2Ogq85+nHXS4WN7YXVKLtJjPjJmXtuPA6W5zB9ZLbXh+S
	 aCdQqNits2Q7dtoc7aSR65gMn+Wxq9OFx82gzn5EJVzlg4YUySPgxE2Cv7/c9L78JIR9n
	 Tj6lK/bS/C8IDgxRNYDzjuz6t6jIaHgMfUcE4Jqel4vgUfracHDmSlj5ryar7VzM6vptx
	 58w5MblDpERSQrftqHp2rees50E50mdw6MDy3Fc6YnnEB6CwVtaWejj2xSewwwXtiS1qC
	 MQNICVvq0cpghTmaXIGJ0XbtBLrUsvsjEuE35Iivtv7mBPJQ8giUA6SCywudJLruHkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795183364;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=qSIDkyNLpFJKk0/zs7wtThTlgXHE/iwI1tQ++yL3Pqw=;
	b=fOpErgHw+ikioLhF0fwGOzbAZqGEAziGGPJojbBGql7C5hotJCVArXXxGbEEGX1e6VnP
	 71/TjjkjnLm3A0vU/N5CTVpsxc/A1tqi22h7irrTzAlSFqiVc3Tz1bFFf/2HsoyH1kUrH
	 jwRkHFoGXxEhW2jjcCko5q1+H7nMITjXOyLZ+cMMwLG5KUtLjPymtKFc5RIqv49AFc9Sf
	 Eo90Vf+vDDPHAvNIhu90OaG7NEbzUdNW3sWxUYtmk+S63PlPl7jnHhO4CL0StifvORQN1
	 UHnF31jdF2PB+dPLo/fvNoXOU45MbOVN08mh0hSa21dW63ZKnUpQJkm2XI46mqip5Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nmpzs9ik;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E05606A32A;
	Fri, 20 Nov 2026 14:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nmpzs9ik
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA7B1F000C4;
	Fri, 20 Nov 2026 14:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795183363;
	bh=qSIDkyNLpFJKk0/zs7wtThTlgXHE/iwI1tQ++yL3Pqw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nmpzs9ikR9Czg8LuZfBHMFXo299lzCh37VmcNsgp4VIZQ21JhgCuMo8HN5ZznvNhq
	 V8EMLZ9oAkMRDUj/Bk9zPUvvxn+v2jWJLEBKC2rM9ySGg3KfmDU2JmLty0FtwrZ5S6
	 sTvQWZf/8P54f+GGNLDi8ecpl0RyRYcfMqeXxYAK7a/6/soS1RFT5SqitWdtP7DM7z
	 pzv8PEAJ0qnYvbEYUE0uoN3K91B0mq6zWVRbQ3jUiMGw+JdS10crDfFcU1KvFd3HeZ
	 VvKs2inu6RAqQje9Mrsv7iuXx2amuFWLe1GRADkMmlbHPp/9K3UNJuron6dVo5yyQi
	 4FL2U5isD4PlQ==
Date: Fri, 20 Nov 2026 15:02:39 +0100
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Ding Feng <dingf3ng@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Josef Bacik <josef@toxicpanda.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: ovl: sync_file_range() does nothing on overlayfs files
Message-ID: <20261120-waten-freunde-warnung-77aa6a3aa14e@brauner>
References: <CAOQ4uxg5baphOjo+_A=3nZBmFEmMV7KOiv_W=rjEVYV41eTEaA@mail.gmail.com>
 <20261118113241.29101-1-dingf3ng@gmail.com>
 <CAOQ4uxgk=Teyci_b1PVaTgDip-UHXXsnXFCQQatFTSVxSHynYw@mail.gmail.com>
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
In-Reply-To: <CAOQ4uxgk=Teyci_b1PVaTgDip-UHXXsnXFCQQatFTSVxSHynYw@mail.gmail.com>

On Wed, Nov 18, 2026 at 01:18:44PM +0100, Amir Goldstein wrote:
> On Wed, Nov 18, 2026 at 12:32 PM Ding Feng <dingf3ng@gmail.com> wrote:
> >
> > Amir Goldstein wrote:
> > > Like this?
> > >
> > > Completely untested.
> >
> > Thanks, Amir. I tested it on v7.4-rc3 (20eef29b7c84), where it applies
> > with an 8-line offset in mm/filemap.c.
> >
> > Setup: arm64 defconfig in QEMU; overlayfs with lower and upper on one
> > ext4 disk; periodic writeback off (dirty_writeback_centisecs=0). Each
> > case writes 64 MiB (16384 pages) through the overlay and calls
> > sync_file_range(fd, 0, 0, flags). Dirty pages are read with cachestat()
> > on the upper file's ext4 path, before and after the call.
> >
> >                                    before patch       with patch
> >   ext4 file, flags=7              16384 -> 0         16384 -> 0
> >   overlay new file, flags=7       16384 -> 16384     16384 -> 0
> >   overlay new file, flags=2       16384 -> 16384     16384 -> 0 (4096 under writeback)
> >   read-only fd opened before
> >   copy-up, written via another
> >   fd, flags=7                     16384 -> 16384     16384 -> 0
> >
> > cachestat() on the overlay fd reported cache=0 dirty=0 before the patch
> > and cache=16384 dirty=16384 with it, in all three overlay cases. All
> > calls returned 0, and the kernel log showed no warnings.
> >
> > Tested-by: Ding Feng <dingf3ng@gmail.com>
> >
> > Two questions:
> >
> > 1. FUSE passthrough also keeps data in a backing file
> > (fs/fuse/passthrough.c) and already forwards ->fadvise(). Does it need
> > ->f_real() too? I have not tested that.
> 
> Yes it does, although FUSE does not have d_real(), meaning
> that nobody probably tested uprobes with FUSE passthrough
> I don't know if IMA/EVM/IPE are applicable to FUSE.
> There is no obligation to implement FUSE f_real() from the start
> if sync_range doesnt work now it can continue not to work.
> 
> >
> > 2. In the copy-up case, sync_file_range() on a read-only fd can now
> > open the upper file and return that open's error. The man page lists
> > none of those codes. I assume that is acceptable, as a write would see
> > the same error, but I wanted to mention it.
> 
> The man page never covers all possible errors
> especially general errors like EIO, EACCESS, EPERM should
> always be anticipated.
> I am sure this is documented somewhere but I don't know where.

It's shameful that we need all these special-sauce overlayfs ops but
what other fscking option is there. So yes, looks ok.
