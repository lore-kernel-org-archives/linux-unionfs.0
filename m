Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C058C23393A
	for <linux-unionfs@vger.kernel.org>; Thu, 28 May 2026 14:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779979854; cv=none; b=l1kvwwmQIUVFv15SqatGXVLJCIQcsmLSOmSfcDEwRalczem1XWj8/wXRiD7InqzkAlC886vTGMpS2kOat6MuNyam3czGaT9WJj/tf8UdZINQVibVXawM9gKqyoTtCTikvdK1WE6uAX5oHU/A7zM35/2h7ChfOdMQzK1RGbtlLrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779979854; c=relaxed/simple;
	bh=XTdh+SCtDlOb+7DDE8GqAquXCqeELh5PH2AOrxbg70Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=izZxJRTvhEg0LsNaBf9HDdPfGYcTbBNGMlu5RYugVdyqOxFr9LrTf8f+pDWDDWy+JlU40O6eDtQNzoftXgF5DkEseFHN2btChjhHmDnzpPdbzUeXQAPiTFgDzqMnPRxrvBHLqw9iNxiZOH1vIDTUL5LYzm33tdBVRZegRxHxUnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PDbLJxh8; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tg4ZnT5P; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PDbLJxh8";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tg4ZnT5P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779979851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UBtkZg2KzsdpXCtGBF+S9Fg8Iz8UrMjxsxZEct4ck8E=;
	b=PDbLJxh8YRqrrvjPYxj7RmYcNHwPu8ivAXRe/GjNMqp4wmeIt8cOq6rsDtLD8BfGbqMFvr
	r64nMcVvuIi533I/RQ94DLnKs5BD2roybqHcaecVIpbQgFh/nRM4PlB0bJSJM1AzadWGWB
	wnToAyLctZe2sPbwe9eGX/s1U3cF2po=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-TbGNRZp2MyePvXBNHg1DvA-1; Thu, 28 May 2026 10:50:50 -0400
X-MC-Unique: TbGNRZp2MyePvXBNHg1DvA-1
X-Mimecast-MFC-AGG-ID: TbGNRZp2MyePvXBNHg1DvA_1779979849
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-447f2ce5556so9564198f8f.2
        for <linux-unionfs@vger.kernel.org>; Thu, 28 May 2026 07:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1779979849; x=1780584649; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UBtkZg2KzsdpXCtGBF+S9Fg8Iz8UrMjxsxZEct4ck8E=;
        b=Tg4ZnT5P/BrBgyQ1D+0wy/ynyGwDBviEXN7xLMQP+ozMnGUfEKVGR40bOfRb0OILYo
         9/qm11lxJO/WmKkq+++Gk8tsjEqO4mBIeirRGDEHnpA3AStiHjrKqLZZxRChwxyucbUl
         4Gwyc5SdRLrWg2Y7noTYRx2WyhnVf0n6vesqUcHsVy8ac97Z4uRe085mW14Qp5HCJbsa
         2+K6FmmhH6D9gwwe3KBxmiBC/L5AgSnbdCJllS9Utc1xG6SFflms68E5RPgLWuOvjD8S
         uYmb1DFTK1Lry4hjkv3a9lof0Vvinp3xH7IHZMVwJSGQIrVodfzdkWm77cp4d4TMa5QR
         /RBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779979849; x=1780584649;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UBtkZg2KzsdpXCtGBF+S9Fg8Iz8UrMjxsxZEct4ck8E=;
        b=VkIzhGUIBUhzn1hAMhlQPr6Y3Eb4KIG4kFvvYlnc406SbWdpGm09Wvic/hBZaVL32I
         k7pVBizM9metR5WXVL3hhHuBJn+Edg4rVG5XJWd5xmMQ/zjxwQbyZmNDRqSTocX31IAW
         wzF8+oZjwg/FP07oFNdABKGVZLhby/m007iBiQtyPhgP5lXWKLAKGHxGbLQppMZeH2JE
         Hv+MnU0CPjWmiRIXEu3xtHfKuUG6FWwOV2OjL9Zn+owtuKgc6jFZMaQuAXpqFnmM5OCy
         pLSYEvjnBentqhfjKl6CY9iuR+X630fqMb5VAwWqYI7bwzMAzVRaHG3eaSqUfDZ9Xr1C
         DBwA==
X-Forwarded-Encrypted: i=1; AFNElJ8MbK6+w83RrsAscvRjNd+nYfzHTAi7MgRuIXImVY072DM7jcYbWqSzCX0VMrryiXt4Q04BIS27sxpCYv3P@vger.kernel.org
X-Gm-Message-State: AOJu0YxlJFnsxc60m7gRwUv6Jt3EEUfJrItn+5ynxPXF2jXSnq3Q3d3s
	bVasu8cy797D9m13qbr03mGOjyfO2CedAGHi6L2ZAYP7KlhXDP5htd4Ik4WsesS29gq8WWV3cIP
	cYFHMw2O6mvoQ6ca62oj1POyEmKyrTVfaWTv1NZIUkaaNhjNQdLEeKLL0RJQf61rohw==
X-Gm-Gg: Acq92OFDoRuCTW1W3mOLMhvez5gkRmpdoRRP76t1CS9hXWUlnetTPko83hF99kGCCB1
	c25qGlDJZcEO8JGwekkfUs1Ut/zQIXw+2JB4A8Evs8T37ntFag8hoMSRFk9XhkHfxOhxtNj1UxQ
	+5b+qqGGeV0doB30YGRoxnZF7nwhwRPBGqstrJG1bOWy8eFdqXGutw1vIDtR1aG3gDjshL+n3e8
	tYsctRpQwc9fOlCJgnuysSw5HBVDnS9Hrz3s/1d7ANNWkgEC8bT1kf4Folwqhlt5U7Kgj+igwbb
	Sd7c1Bi5FUpAnpK7INAsbNTSX9awipv9Qqw6DIUs2EDjdOFZh7cpJ8C87MGt/iyvTXv/Qb13cx6
	Sai6nD0tVwghozXez2MvLSz6nonriEO5EYSVVMUidyTxdCg31LIWsSZpaERhQ5s2hzg==
X-Received: by 2002:a05:6000:26c1:b0:44d:1338:46b4 with SMTP id ffacd0b85a97d-45eb36731d0mr47511224f8f.9.1779979848944;
        Thu, 28 May 2026 07:50:48 -0700 (PDT)
X-Received: by 2002:a05:6000:26c1:b0:44d:1338:46b4 with SMTP id ffacd0b85a97d-45eb36731d0mr47511162f8f.9.1779979848360;
        Thu, 28 May 2026 07:50:48 -0700 (PDT)
Received: from thinky (178-221-68-189.dynamic.isp.telekom.rs. [178.221.68.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eeb36c40asm3352619f8f.13.2026.05.28.07.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 07:50:47 -0700 (PDT)
Date: Thu, 28 May 2026 16:50:45 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	djwong@kernel.org, david@fromorbit.com
Subject: Re: [PATCH v10 00/22] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <fjdfwhwi4aogyiaoijwvw6w4npuu5mbt6ua6fkhwcp5ajlm543@ume2fkxg36cb>
References: <20260520123722.405752-1-aalbersh@kernel.org>
 <20260521090705.GA14254@lst.de>
 <gcw7zcg6p4s2egpufwizfig72g6ren7jfmuz5mqskkpb7xepww@e3v35j7bk7dc>
 <ag7uW7KQ5mVyCGEv@nidhogg.toxiclabs.cc>
 <20260522-unbehagen-baumethode-erlesen-811a4065eeac@brauner>
 <20260522120757.GA21041@lst.de>
 <ahVzkf8JoKP-kSC2@nidhogg.toxiclabs.cc>
 <20260528-offiziell-luftleer-misswirtschaft-3503bda2ad70@brauner>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528-offiziell-luftleer-misswirtschaft-3503bda2ad70@brauner>

On 2026-05-28 14:20:08, Christian Brauner wrote:
> On Tue, May 26, 2026 at 12:19:43PM +0200, Carlos Maiolino wrote:
> > On Fri, May 22, 2026 at 02:07:57PM +0200, Christoph Hellwig wrote:
> > > On Fri, May 22, 2026 at 12:03:20PM +0200, Christian Brauner wrote:
> > > > > I was expecting this to come through xfs tree too if Eric and Christian
> > > > > agree.
> > > > 
> > > > You may take it through the xfs tree if there are no conflicts with
> > > > vfs-7.2.iomap. If there are I want to add the iomap changes into
> > > > vfs-7.2.iomap that you can pull in.
> > > 
> > > Merging the iomap bits through the iomap branch might make sense, given
> > > that iomap usually tends to see quite a bit of activity.
> > > 
> > 
> > That sounds good to me. If you want to go ahead and pull in the iomap
> > bits, do so, and give me a heads up when you do it so I'll pull your
> > branch locally.
> 
> Great, can the series please be resent based on current vfs-7.2.iomap
> then please? Because the iomap changes in this series don't apply
> cleanly on vfs-7.2.iomap so we already have merge conflicts...
> 

hmm do you mean this branch?
https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/log/?h=vfs-7.2.iomap

patches 07..09 seems to apply cleanly. The only conflict I see is in
the overlayfs patch 03. This is because [1] (is in -rc5) is missing
in vfs-7.2.iomap.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/fs/overlayfs/util.c?h=v7.1-rc5&id=0c8c88b8eb82a2a41bec5f17c076d6312dc40316

-- 
- Andrey

