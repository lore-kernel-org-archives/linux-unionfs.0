Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DBD483804;
	Fri, 25 Sep 2026 13:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790344307; cv=none; b=YLVsim8Vc5V0DdxBm9OwNzsD9JBE2e3nu0Cm89dme3+nMJrVwR/zZEisTzJ+iR22eqvki7OslVMngn1PifKo7mf4wI1FygDfP1ny3JOxN6UO2bC1oZLQXiSNwwyb/T0sqnzNGyeyiOErTD88DnXsj0piS8wrZU4bX5gm+Thr4Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790344307; c=relaxed/simple;
	bh=MVPDMkTEBaH2xLmbzLMGIuTZSwftq6ZqRfGcqKqi1Ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JiXzHhYulS5LGZNxkIB8hCsbQJAmUtzFqM/Cs9TIGmw3RJ2hPgE1wpJcYkh/LnZ/yz+CLGCPxxNsdKPW4F/BMBqih3MzzWzPFZ6E+AXMZa0tgEsPXOfGUKxL9YDbVxHTzjF6m+NlgQ+OOp/e2ABkAgt1zO0bsu7meCtTHD2hWkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ECs9OXEs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ECs9OXEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865121F000FF;
	Fri, 25 Sep 2026 13:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790344306;
	bh=G7HDmJbPCJLehqABPQ2p7b1+tW8heMz7xkz3xsol4UA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ECs9OXEs4ADwfd6PfMpy+N5eymGTOzI18voDDtavYc+tjyAS0aw/W0kkCYC3RlJAd
	 rhK5EEv1e6LrXNywCXPoAdX7qJ0k0YWUIwtAKa5wgap9l00sKHtCBua7EaFQ06bgPf
	 W5r3dvelZpbfK7EeuhUIeaG2heRf8EzzMaQ+BcRYGz/g/r3C+ZKpPqUVHQK6dt+EqT
	 sktvuGF3WMNZ4v0rCI/ULMS7z49z0phtyjUMWKQAb1evHhlOTEfALpX+8+WuVU9Nkh
	 Pkt8XaLtBz92L2uA5IA/Nyz0IYfad5PFeT0bx95Y2Y39ZzWn3r+Z+rYeCJxsWcSi0C
	 4n8AJuGmiHLNg==
Date: Fri, 25 Sep 2026 15:51:42 +0200
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: =?utf-8?B?SsOpcsOpbXk=?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>, 
	miklos@szeredi.hu, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] ovl: disable nfs_export for same-sb lower layers
 with different idmaps
Message-ID: <20260925-server-hager-riskieren-06116eded213@brauner>
References: <20260920203239.2876221-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <20260920203239.2876221-3-Jeremy.Jean@oss.cyber.gouv.fr>
 <CAOQ4uxhyc5x3LDzbJtRhQJ+JNQ-hES2k45jcxeGsfEWPB24TKA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxhyc5x3LDzbJtRhQJ+JNQ-hES2k45jcxeGsfEWPB24TKA@mail.gmail.com>

On Mon, Sep 21, 2026 at 10:10:28AM +0200, Amir Goldstein wrote:
> On Sun, Sep 20, 2026 at 10:33 PM Jérémy Jean
> <Jeremy.Jean@oss.cyber.gouv.fr> wrote:
> >
> > Overlay file handles identify a backing filesystem, but not the lower
> > mount used to decode it. If lower layers share a superblock and use
> > different idmaps, a file handle can decode through the wrong layer and
> > initialize the overlay inode with the wrong owner.
> >
> > Track the first lower idmap seen for each ovl_sb and disable nfs_export
> > when another lower layer on the same backing superblock uses a different
> > idmap. Keep index enabled: copy up starts from the overlay dentry selected
> > by lookup and does not need to decode a lower file handle through another
> > layer.
> >
> > Fixes: bc70682a497c ("ovl: support idmapped layers")
> > Assisted-by: Codex:gpt-5
> > Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> > ---
> >  fs/overlayfs/ovl_entry.h |  2 ++
> >  fs/overlayfs/super.c     | 28 +++++++++++++++++++++++++++-
> >  2 files changed, 29 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> > index 80cad4ea96a3..2a6e12a0d4dd 100644
> > --- a/fs/overlayfs/ovl_entry.h
> > +++ b/fs/overlayfs/ovl_entry.h
> > @@ -24,6 +24,8 @@ struct ovl_config {
> >  struct ovl_sb {
> >         struct super_block *sb;
> >         dev_t pseudo_dev;
> > +       /* Idmap of the first lower layer on this fs */
> > +       struct mnt_idmap *lower_idmap;
> >         /* Unusable (conflicting) uuid */
> >         bool bad_uuid;
> >         /* Used as a lower layer (but maybe also as upper) */
> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index bd0a3f9039d2..8e78da420b75 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
> > @@ -944,6 +944,24 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, const uuid_t *uuid)
> >         return true;
> >  }
> >
> > +/*
> > + * Lower file handles identify a lower fs, but not the mount whose idmap was
> > + * used to decode them.  Remember the first lower idmap seen for each fs so
> > + * decodable export handles can be disabled if another one appears.

I find this behavior counterintuitive. Shouldn't we just fail the mount then?
