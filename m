Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.159.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794165172;
	b=QcRK0NFFgq7RJy8Z07HddRIYnZ3jwI7knsndlzlI24BN4es6sJgen1UaAorQP9WvRTMZ
	 5zULlG2azKXS805TGiJOYbFYqMXgbI/vFmeSSoKMbVdXRCj6HSqen4vrjwB0tGrB7TGPk
	 XmZdC6Kc499Q2EvBvfWXJhBUY7/NSoLb4SXdn6ej5Vo0WykYh4ZxUYkbnl/8I9HunX1/8
	 t/bzyfhZIC+ld1mkv8LGWSun0vmC4nWRwJ4dWVnS36ULbtYPlp37do37rBf0hbiug6AXI
	 EwLeOJTYrs6Ns1KrSgwvUjnXsG/wb1C0O3Va1iN1WdbK15lyjEeOtuAH6Tlkle9FVvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794165172;
	h=DMARC-Filter:DKIM-Signature:Received:MIME-Version:Date:From:To:Cc:
	 Subject:In-Reply-To:References:User-Agent:Message-ID:X-Sender:
	 Content-Type:Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:X-Get-Message-Sender-Via:
	 X-Authenticated-Sender:X-Source:X-Source-Args:X-Source-Dir;
	bh=McfMCz6eQlBObDy4m27qyrAO1TC4PYnrNJ01NCaWbu0=;
	b=t6LlsKJqOQG8qN4rq4q6tEUHrgNoJzjnWKW8IXt565gETHzW7x3IJVBLxcuyil2I/y2E
	 1pTkpqWJ21HfasSINUEQK7R2Lb74Gq6QBc+CC675+QboCNV+JNqB3fhl3VqeiWTr52Izn
	 +Zrc8aJdElsCpgQ8RmM+yjxu3qy/bO8Dynu7IaDRT+eaPUShbMNeRIFaDVfqd5T3IyUU+
	 /HPFNFg+iMQMufm/FWZ+EJVHjrQOTqIc7WN5tiL+UYSprkZualcFOVMeXe1kYlWij67jP
	 hDEyWp+833bfngXkd57pvGH3RONTVhKANnDsxwYVokwb8rZd9bx/epwUJdrLx1LGZzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.cyber.gouv.fr;
	spf=pass smtp.mailfrom=oss.cyber.gouv.fr;
	dkim=pass header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=WzGJdpIW;
	arc=none smtp.remote-ip=51.159.188.251
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70A0606A31C;
	Sun,  8 Nov 2026 19:12:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E70A0606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=WzGJdpIW
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:
	Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=McfMCz6eQlBObDy4m27qyrAO1TC4PYnrNJ01NCaWbu0=; b=WzGJdpIWKo05Hh1T/S6juD8uym
	bdfipT6ypibUoWBj1+UHgAAuvvqpA3dcbiLMXQsRCC4QICdO6Qmd27CvcdtsdvGkv8SOqDUC1wcOo
	IYwVTjvTcfypV1vFz46TBJ9+jG0ArUxxkn44Rsir/EXVru06TZViKnsGoAdqaHgxlWEGmS8mInz+F
	iwvgSCOptRQ4bvE6zdX83+IOpmm/0EFtVNxHQiILlqrr4WGq31CdZVpXXcWNn1aM1pKso1gkaDlut
	Sed6aUciT4Jfvj7SYQMdzPll2xb0CmugbIAvNromPGPtc2hbLNU2oaNB5mRgVsj6QVi2p7tlWQ9QV
	tQ8B+G2A==;
Received: from [::1] (port=44842 helo=pf-012.whm.fr-par.scw.cloud)
	by pf-012.whm.fr-par.scw.cloud with esmtpa (Exim 4.100.1)
	(envelope-from <jeremy.jean@oss.cyber.gouv.fr>)
	id 1xQ8Jt-0000000Gu7u-3qnR;
	Sun, 08 Nov 2026 20:12:49 +0100
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Sun, 08 Nov 2026 20:12:49 +0100
From: =?UTF-8?Q?J=C3=A9r=C3=A9my_Jean?= <jeremy.jean@oss.cyber.gouv.fr>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, miklos@szeredi.hu,
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] ovl: disable nfs_export for same-sb lower layers
 with different idmaps
In-Reply-To: <CAOQ4uxhdP4XeHfbKfOg+3XRF8oLhPMmbU9xHp7pV2w=snQk-+w@mail.gmail.com>
References: <20260920203239.2876221-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <20260920203239.2876221-3-Jeremy.Jean@oss.cyber.gouv.fr>
 <CAOQ4uxhyc5x3LDzbJtRhQJ+JNQ-hES2k45jcxeGsfEWPB24TKA@mail.gmail.com>
 <20260925-server-hager-riskieren-06116eded213@brauner>
 <CAOQ4uxhdP4XeHfbKfOg+3XRF8oLhPMmbU9xHp7pV2w=snQk-+w@mail.gmail.com>
User-Agent: Roundcube Webmail/1.6.20
Message-ID: <5e8dff576ead72fa502b7cd38889e780@oss.cyber.gouv.fr>
X-Sender: jeremy.jean@oss.cyber.gouv.fr
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

On 2026-09-25 16:17, Amir Goldstein wrote:
> On Fri, Sep 25, 2026 at 3:51 PM Christian Brauner <brauner@kernel.org> 
> wrote:
>> 
>> On Mon, Sep 21, 2026 at 10:10:28AM +0200, Amir Goldstein wrote:
>> > On Sun, Sep 20, 2026 at 10:33 PM Jérémy Jean
>> > <Jeremy.Jean@oss.cyber.gouv.fr> wrote:
>> > >
>> > > Overlay file handles identify a backing filesystem, but not the lower
>> > > mount used to decode it. If lower layers share a superblock and use
>> > > different idmaps, a file handle can decode through the wrong layer and
>> > > initialize the overlay inode with the wrong owner.
>> > >
>> > > Track the first lower idmap seen for each ovl_sb and disable nfs_export
>> > > when another lower layer on the same backing superblock uses a different
>> > > idmap. Keep index enabled: copy up starts from the overlay dentry selected
>> > > by lookup and does not need to decode a lower file handle through another
>> > > layer.
>> > >
>> > > Fixes: bc70682a497c ("ovl: support idmapped layers")
>> > > Assisted-by: Codex:gpt-5
>> > > Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
>> > > ---
>> > >  fs/overlayfs/ovl_entry.h |  2 ++
>> > >  fs/overlayfs/super.c     | 28 +++++++++++++++++++++++++++-
>> > >  2 files changed, 29 insertions(+), 1 deletion(-)
>> > >
>> > > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
>> > > index 80cad4ea96a3..2a6e12a0d4dd 100644
>> > > --- a/fs/overlayfs/ovl_entry.h
>> > > +++ b/fs/overlayfs/ovl_entry.h
>> > > @@ -24,6 +24,8 @@ struct ovl_config {
>> > >  struct ovl_sb {
>> > >         struct super_block *sb;
>> > >         dev_t pseudo_dev;
>> > > +       /* Idmap of the first lower layer on this fs */
>> > > +       struct mnt_idmap *lower_idmap;
>> > >         /* Unusable (conflicting) uuid */
>> > >         bool bad_uuid;
>> > >         /* Used as a lower layer (but maybe also as upper) */
>> > > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> > > index bd0a3f9039d2..8e78da420b75 100644
>> > > --- a/fs/overlayfs/super.c
>> > > +++ b/fs/overlayfs/super.c
>> > > @@ -944,6 +944,24 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, const uuid_t *uuid)
>> > >         return true;
>> > >  }
>> > >
>> > > +/*
>> > > + * Lower file handles identify a lower fs, but not the mount whose idmap was
>> > > + * used to decode them.  Remember the first lower idmap seen for each fs so
>> > > + * decodable export handles can be disabled if another one appears.
>> 
>> I find this behavior counterintuitive. Shouldn't we just fail the 
>> mount then?
> 
> I would love to fail the mount if you confirm that setting up an ovl
> with several
> lower layers some on the same fs with different idmap, is a 
> non-feature.
> 
> I don't know can't /home/amir and /home/brauner be on the same fs with
> different idmapping?
> 
> Could it ever make sense to compose an overlay from two such 
> directories?
> If not then I would gladly remove this setup from the test matrix.
> 
> Thanks,
> Amir.

Hello,

I'm digging this up: should I investigate to prepare a new version that
simply fails the mount? Please tell me what you'd prefer.

Regards,
Jérémy
