Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794235912;
	b=dzgUaI/j/LI32nrJE1JQZFXAevXEr5YclBFAM71IIdaK9POrRlJoJNchnrPQO0cgQ0XL
	 ltAAUio1E2jBWORqKtYaxymHaZ4nkMQmgqOvkrPsg7xf35NyD5k4fKffAWmpyu6qehehn
	 BMzmJjMFAWoAVdGgvIWt6Sr5E5Wy1C3fjoadOB6BXKpJsk0YSQ5zQtOn7g3ViVqls9SQo
	 tUJhJ2JtgMiUGJw0tWh8PYhe2vjqbLwDOt7rzbsqSv7KvCSzsqlSi5mMLDPOblTis7kRa
	 /dYeBKGcc2puLwmpMbhfvU75QDEVmaB/Vsasa7gd7TZXWwyOPDOAf91qfNBWgq+m7VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794235912;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=J/ON+kd3JZ2PEUk7mTIiSkX+r3bemsj8teqmqV8x0KE=;
	b=p0wQgwYZD1HEjUyy7XUY5i9oXwWKhghMSum185J/swnpxZL091OvM0TCjvSeRJMn+bEH
	 WzAPhqHeE8AWO8tscbo/rADa/PKhGxiP4c0xJg+nD8m284xookWFr8vWvpC+LW6T4bisy
	 xcafjFGg+am0bYbnPC8jIen0qbZajdkG4JjXwTCiBFDN2Fnh20bH8GjCipDXI51L72GOm
	 WnZfxnitNDO3wb0p4E7F9vuLgC/sRcz2xvH85ef7aAjn53eRlaLLHt0UgTeBGXoeTWhfC
	 PGS1spimHQ/ZmrWYmidctiIj72EPwGPfmj9yw8+yvWivW97LEWV+rf4WO3exZvclm0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PkleYFAc;
	arc=none smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F72606A31C
	for <linux-unionfs@vger.kernel.org>; Mon,  9 Nov 2026 14:51:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17F72606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PkleYFAc
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b633ddfad6so1252971a12.3
        for <linux-unionfs@vger.kernel.org>; Mon, 09 Nov 2026 06:51:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794235910; x=1794840710; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=J/ON+kd3JZ2PEUk7mTIiSkX+r3bemsj8teqmqV8x0KE=;
        b=PkleYFAc+0BvCXsJXVq3M/zBPc+eyFBW6hC4WYb2ML24PLhITX2DmlX3mLQNASXS1N
         nc5jJqreb/r14U3fqpOlQvSvR1Nb/tmPlVv7VniorSqIYqocbkm6ZOIU838NH2hN2oZ4
         SFgYWXIBafbDJB9SqchXjKumyuKVdXMex6/5jmglbujr/AlM7HnnXm96IdSthgrZkDXn
         GGaQ3sgNTyk9FHxWLk2lX2BQm5sQ7F4wQMv9FqGaKlP8K2jWsptRBQ4YkAqwSzBlFg+4
         PcChdGXGfFcegdYid+AA+XUylPI7d2UcVlQokEUL6HsSjvO3geAVocKtk8nAnG7xU0kU
         354A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794235910; x=1794840710;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=J/ON+kd3JZ2PEUk7mTIiSkX+r3bemsj8teqmqV8x0KE=;
        b=NtJlSSSomLetiLE4T3oZ8ILOZTyPIv7oz7zwhzniGHP7AlulTg7sc3YlgWZB83Sebl
         TG2AbuB2xeE7P261Eo8gA9AVXPlzx34C5WASSd4STVg4qn+Sqbg9jejgJkznOz4wAUaK
         BJNsMFGs6soc5rAh/buEBtrbFjnjW14ugjyFL8kdX/YRVwlQmzyPeKTRmjk66pz2FZcd
         4i23v9aS3fsgqXrSf69d2csUwRSf5Hk2ghKbgEaCka6kPoxOkLwbXosUxuUslIBJt7vc
         Wp8Z80d/mHezJIU4VyI33dw8N88sbmHETRIKI4tdQ7/v31/dgdDVcTVuwEAJw/HfUoQK
         UT3A==
X-Forwarded-Encrypted: i=1; AL+hErEz7PUJFFIpkNupH1Y1pxwNRqBv7AxhzLJrBR7JGLO9i3ZbTm2IA/cI3l0hlsebyjpHhhAP6spxNUf4S9da@vger.kernel.org
X-Gm-Message-State: APuU4Z/wNGj+kQDj31nhfya9/k3PflOk749KhX11ij1TKIjVe/B1GJ9B
	blloA5HMg03W3Ji1jH5jHhOagCfcBDudd7yW6UBOPWfhnQyh75h5H6dW
X-Gm-Gg: AYBFou32yPpc3VIQ5qg4YlOVLFuJlA7/vOFtyGCOJq3bTK5nfVaCB1LYLdl0BPtJZmk
	COOyYvdGdNwLq4aom573Ayq5nmi6EyWmaTQSo2yoDHhcGO/vRGn4d7f99RZdzcSXuYTZkjoN+jH
	yS8BS+V3gVKGSieZMWiPkMfhhj1usujPiUmMD7XjII1DgpIOtquCVQfrWtDPtQkEOyGsUsLqKxp
	OciSyt036F9WgVbjBJnFuoJE++l3dmfiSP98+jjq42entlEPlSKd1s6rHwE5BSA9UJQ1eeDt9PA
	H2xaZplMn9scXxwqaVqg5eqnJQIZyjw6GLejcMRTqG7NDnnbiOD1+I7+0sQ2dot7RSzyLqqut3B
	kUugxquotN228Q8ms+A4pUWIO095+G0clUj8proqBlLnRlalO6vXXWg6lEKtYd5rTuVkLCk+bwa
	UZjuMtUe542Lx1INt90PklyjcIo1MTfhbFLM750FF8ybkTHQlUubDjf0lkjedQe1o30BCdUyaIh
	tOkd42H/q34LszQ/5iuk0kD+arDDaCc+X34IlAkYrw4I4HBxlVH8CxDCvqCAdFVUXWkjXTHK7hp
	EXRC0fKXbLkiTJVv7FpYj8f1GhbxjfQ+w3Aa2wng3p8g8B30DSkHkkIkAIffDvL+Gh71/fwnefl
	zYDTyH+Jq8kI=
X-Received: by 2002:a05:6402:528f:b0:6b5:660b:70dd with SMTP id 4fb4d7f45d1cf-6b722484c1fmr3165155a12.21.1794235910318;
        Mon, 09 Nov 2026 06:51:50 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b721eedfd7sm1603106a12.31.2026.11.09.06.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 06:51:49 -0800 (PST)
Date: Mon, 9 Nov 2026 15:51:49 +0100
From: Amir Goldstein <amir73il@gmail.com>
To: =?iso-8859-1?B?Suly6W15?= Jean <jeremy.jean@oss.cyber.gouv.fr>
Cc: Christian Brauner <brauner@kernel.org>, miklos@szeredi.hu,
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] ovl: disable nfs_export for same-sb lower layers
 with different idmaps
Message-ID: <avHeBTeJlQfrSIPa@amir-ThinkPad-T480>
References: <20260920203239.2876221-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <20260920203239.2876221-3-Jeremy.Jean@oss.cyber.gouv.fr>
 <CAOQ4uxhyc5x3LDzbJtRhQJ+JNQ-hES2k45jcxeGsfEWPB24TKA@mail.gmail.com>
 <20260925-server-hager-riskieren-06116eded213@brauner>
 <CAOQ4uxhdP4XeHfbKfOg+3XRF8oLhPMmbU9xHp7pV2w=snQk-+w@mail.gmail.com>
 <5e8dff576ead72fa502b7cd38889e780@oss.cyber.gouv.fr>
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
In-Reply-To: <5e8dff576ead72fa502b7cd38889e780@oss.cyber.gouv.fr>

On Sun, Nov 08, 2026 at 08:12:49PM +0100, Jérémy Jean wrote:
> On 2026-09-25 16:17, Amir Goldstein wrote:
> > On Fri, Sep 25, 2026 at 3:51 PM Christian Brauner <brauner@kernel.org>
> > wrote:
> > > 
> > > On Mon, Sep 21, 2026 at 10:10:28AM +0200, Amir Goldstein wrote:
> > > > On Sun, Sep 20, 2026 at 10:33 PM Jérémy Jean
> > > > <Jeremy.Jean@oss.cyber.gouv.fr> wrote:
> > > > >
> > > > > Overlay file handles identify a backing filesystem, but not the lower
> > > > > mount used to decode it. If lower layers share a superblock and use
> > > > > different idmaps, a file handle can decode through the wrong layer and
> > > > > initialize the overlay inode with the wrong owner.
> > > > >
> > > > > Track the first lower idmap seen for each ovl_sb and disable nfs_export
> > > > > when another lower layer on the same backing superblock uses a different
> > > > > idmap. Keep index enabled: copy up starts from the overlay dentry selected
> > > > > by lookup and does not need to decode a lower file handle through another
> > > > > layer.
> > > > >
> > > > > Fixes: bc70682a497c ("ovl: support idmapped layers")
> > > > > Assisted-by: Codex:gpt-5
> > > > > Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> > > > > ---
...
> > > > > +/*
> > > > > + * Lower file handles identify a lower fs, but not the mount whose idmap was
> > > > > + * used to decode them.  Remember the first lower idmap seen for each fs so
> > > > > + * decodable export handles can be disabled if another one appears.
> > > 
> > > I find this behavior counterintuitive. Shouldn't we just fail the
> > > mount then?
> > 
> > I would love to fail the mount if you confirm that setting up an ovl
> > with several
> > lower layers some on the same fs with different idmap, is a non-feature.
> > 
> > I don't know can't /home/amir and /home/brauner be on the same fs with
> > different idmapping?
> > 
> > Could it ever make sense to compose an overlay from two such
> > directories?
> > If not then I would gladly remove this setup from the test matrix.
> > 
> > Thanks,
> > Amir.
> 
> Hello,
> 
> I'm digging this up: should I investigate to prepare a new version that
> simply fails the mount?

Yes, please.

Thanks,
Amir.
