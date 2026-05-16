Received: from smtp04-ext3.udag.de (smtp04-ext3.udag.de [62.146.106.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179AA30E0D5
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 19:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.146.106.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778960218; cv=none; b=d7e9jHYe5eDt0ntChQDJCrKHihk6kc2XM785IXFyDAUrfPpFqzRN6noGSSNiFXCvGbfTOd4wGWBxW8uasHsiXylF8aTNPrzf2CshXHexDxQADihbS2g48i99R0DxK21Y8iwmpZJx2N2+kYKTX83N/DY9G0WdmUrGmTDgrIkfNn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778960218; c=relaxed/simple;
	bh=qbI3lt0Gy+5fvdW1oji/B0+Cui+yqOS9P32neTKtue8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XusMhdZMLaUmJb7qUkMXvlxGoTwMjDevNIHVc/rRTDTuvYFViqseff9J/Vq7/K7HIcpVfPR/hV05oFU7FDQbkwRCmkpuvlUGamD8CNis24zEyjmeIXwlFTQNiwS0BvRu9YM3NZkNwCPSxe15KXlInoTnKeL24t4ufiWy51Ga1ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=birthelmer.de; spf=pass smtp.mailfrom=birthelmer.de; arc=none smtp.client-ip=62.146.106.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=birthelmer.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=birthelmer.de
Received: from localhost (075-132-067-156.ip-addr.inexio.net [156.67.132.75])
	by smtp04-ext3.udag.de (Postfix) with ESMTPA id A4FF5E0251;
	Sat, 16 May 2026 21:29:37 +0200 (CEST)
Authentication-Results: smtp04-ext3.udag.de;
	auth=pass smtp.auth=birthelmercom-0001 smtp.mailfrom=horst@birthelmer.de
Date: Sat, 16 May 2026 21:29:37 +0200
From: Horst Birthelmer <horst@birthelmer.de>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Joanne Koong <joannelkoong@gmail.com>, miklos@szeredi.hu, 
	fuse-devel@lists.linux.dev, linux-unionfs@vger.kernel.org
Subject: Re: Re: [PATCH v2 12/21] fuse: add struct fuse_entry2_out and
 helpers for extended entry replies
Message-ID: <agjDGBQPG2WpDTWO@fedora.fritz.box>
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
 <20260516004004.1455526-13-joannelkoong@gmail.com>
 <CAOQ4uxjMPPp-R37yKoOs1kGUdAOmnp3keVWvfuxi1r8jrxAcTA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjMPPp-R37yKoOs1kGUdAOmnp3keVWvfuxi1r8jrxAcTA@mail.gmail.com>

On Sat, May 16, 2026 at 07:25:05PM +0200, Amir Goldstein wrote:
> On Sat, May 16, 2026 at 2:52 AM Joanne Koong <joannelkoong@gmail.com> wrote:
> >
> > Add struct fuse_entry2_out, which is a new extended entry reply struct
> > that carries a backing_id and statx attributes. This will be necessary
> > for setting fuse passthrough on inodes.
> >
> > Add helpers that subsequent commits will use to process fuse_entry2_out
> > for passthrough support for lookup, revalidate, and create.
> > fuse_statx_to_attr() is also moved to earlier in the file to avoid
> > forward declaring.
> >
> 
> I think you had a discussion with Miklos about whether
> it makes sense to do a compound response for LOOKUP+STATX.
> I don't remember the conclusion, but if this can save us all the
> if (use_entry2) { } else {} all over the code, then I think it is worth it.
> 
> Can you give me the bottom line from your discussion or was there
> no conclusion reached?
> 
> If we do that, where do we return backing_id?
> Could make use of the reserved[] fields in fuse_statx_out.
> 
> I happen to have a test patch at the tip of my fuse-backing-inode-wip
> branch:
> 6e296625eafd6 fuse: support setting backing inode passthrough on getattr
> 
> It's not using the statx response, and it was just done for testing,
> but in theory,
> if a server wants to  change an inode from non-passthrough to
> yes-passthrough mid lifetime
> doing this on attribute cache expiry may make more sense than on entry
> timeout expiry, because backing_id is an attribute of the inode not the dentry.

Hi Amir,

I see there is a lot of talk about using the compounds in a couple of different contexts.
I really have to apologize for not having the latest patch ready by now, but I'm 
a bit unsure how to do it.

I'm not entirely sure if compounds will only be a thing for fusex or if it will ever
be accepted for the classic FUSE.

I actually have a patch that I have not tested well enough, since I have to maintain
our own version and then have to do the fusex one and probably the new verison for 
the classic FUSE version.

So, sorry about that, but I'm not having enough clarity on what to focus on.

> 
> Not sure if this is making any sense.
> 
> Thanks,
> Amir.
> 

Horst
