Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D663BF685
	for <linux-unionfs@vger.kernel.org>; Wed, 22 Apr 2026 08:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776848288; cv=none; b=AEUG98RwuG4d5fkAKCJe4VlCn3pAqsosTua0w7rhCVs2JD1fLOhyA98mnudbnRAbAKxF2dTrSwHgZ39ZUpakW2VzeakYjs1Z7AsuVIV1/LMjNdLf7Lr5uUVGxomyMdeS8SgCsGvYtVRo1OlW7f7UoAIi+k2BhoPErFDgXQZrCOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776848288; c=relaxed/simple;
	bh=uF63Ms8AACR/oFWxgd+uFy3hlr2NIcQ7At05T0KyQug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V9F4vXq71lfSDhOrFNpXCKf8GpEA4TvCgI7ln3mUvNYuWkJdghx0TJcENc8q3Z05SbqikbABMDhUSibt+CWz7wca+L/gIqanDR7zoNGjE/i6ro0Ivr07L6bYwddG+SOIYIZarZAjXyxXcYzAdXdpmckqld4wy6LcMmqZkI3FCYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cHQHEGn4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cxPgpXd1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cHQHEGn4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cxPgpXd1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776848286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FFaygBUBXXsgixj3eSOd6CMo0lj7K6zPcakxuhrDzd4=;
	b=cHQHEGn4d65uGcHveSIfcaCYX+F8OuoMacUm1MAOmqirZSK4FaBJJv5JD4WXXd/psgrLV4
	AyeNE1L6dGikldh6xPKHp9tapFPxBEeg5jZczq2A419pFkp0K5EdnG6cEGSDAAe63btKjy
	0tAeHahRUjaQ4pK45Cde+QMyNuzt6lE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-8DtnieBmO8Gi2IPzNFUhJw-1; Wed, 22 Apr 2026 04:58:05 -0400
X-MC-Unique: 8DtnieBmO8Gi2IPzNFUhJw-1
X-Mimecast-MFC-AGG-ID: 8DtnieBmO8Gi2IPzNFUhJw_1776848284
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43ff0eb2b2aso2763689f8f.2
        for <linux-unionfs@vger.kernel.org>; Wed, 22 Apr 2026 01:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776848284; x=1777453084; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FFaygBUBXXsgixj3eSOd6CMo0lj7K6zPcakxuhrDzd4=;
        b=cxPgpXd1U2be8oz6XUshGUwOibc9axYIPHrFBQMSuZiwknsMCpp4TPaR8V7HmHlTAY
         /dCsgZVFDwyccB3y60KfRvoGnvNlg2iIqUs25ma3UOS+vz/Zsg2LlbyetF/NjsQvTjys
         aJuVv7sS9y+rpV64vhwHsfrlc4dqmdxrJWV1l4wJrJpAQhYrfJcu/hMHFG5ggFE775LB
         W+UX1yNE383mH/kP7SWPY7TcZmnlXH43S7rc0l7ZvA4bsx2363D3RxTy9WLYClkKW2eM
         LCp79CUbrLb03Zm4ngKEbKKygpkSgf9aAmySoGIq7OXDFIImQGBZnG2jEb8jKTcln3vQ
         Z9vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776848284; x=1777453084;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FFaygBUBXXsgixj3eSOd6CMo0lj7K6zPcakxuhrDzd4=;
        b=KJKuCq/jyOsKtSBbBtO3iU/QBqZ7496BxjXAhTRIz7vY5bynXqguDX0sx+j65r875z
         lQuY2zlYU7tq9bQeDFLm9gBdNVuw1qoFdxcrvv/FSPy9haXfp1oObsg14uPR3ziMyhtl
         /NiWuTHsit6pFwaXzKDkSCnJeewS8XSX7cK3747ZYDz/xzzNRhcIWCKSkYVnmHg05HFH
         oSsJ/Jwj0ZJND3kgGpWE/wpGZtfLc9bvHKlcHZQEEHNW279TW2zSdbRjyj8GboplcfCf
         I50sre3IZAqm9chas4pMA/rV2xcKTi/eTuWtvvt1zf243w0ToI7W3/ALRtdgDQ4aAlsj
         KRqQ==
X-Forwarded-Encrypted: i=1; AFNElJ8LbfTNnpazcZjRrZ9LAO0otOxfTy6FamDkiSEvXZeM8m+rIEye5MxC2qlEv7lzQmR10joWUk9ibAKI6pVL@vger.kernel.org
X-Gm-Message-State: AOJu0YwS6HsJ5PXotU5I2GsE2+kNhJR//sy/kpWJkqosE4stlF+fTzSZ
	oKVqfKh4RzsbVc8rngq4MNPSfZs0g1yJwpQn//NeMQwgH0MNazfgFki8oNEncCTJv6AgoDnY6BG
	24+p5QSxirgo7yTSaWXjjKH4EnNFVJT/zPpxuUPBYS7O8sDki3L267xf+61+tn5q8bQ==
X-Gm-Gg: AeBDieuEgcNzOzR3LmErDBwm2T91d+bnoLJaJqD6JWqgMfuLC0f/vExhmr6l1sBdhXF
	aOCJ+6L3wlxP1rU+nbCq29Ftn91gl+m82Ig2/M9lVI5gmFtcnB+giM5LdTsg8CJ+Au5+4uVkLhY
	YZkg9fWrh3qu6aM3VxAGtQIEBOzSXqgzMGjNE8Gq9cCFa2FZwb2H4isemjV0IsN4ZkHQiZRuLdx
	tneyRrbdNeK7a0yddNrDf9HVc9UfFmSyKtNpUOlDJmdR384WlM9fPxiOzzZAOGHr/IH6X4tbytt
	acI4xviT7eydK/0KMuj5/CgNgt5DluPWbKQSCjVKIgw9PlUpNqOAXvo6oPs8c7pAwxWKcwIrhY4
	iVfEqP7w6uH6IbPm1uXrIYg==
X-Received: by 2002:a05:6000:4022:b0:441:2439:bef2 with SMTP id ffacd0b85a97d-4412439befdmr4594382f8f.24.1776848283790;
        Wed, 22 Apr 2026 01:58:03 -0700 (PDT)
X-Received: by 2002:a05:6000:4022:b0:441:2439:bef2 with SMTP id ffacd0b85a97d-4412439befdmr4594342f8f.24.1776848283286;
        Wed, 22 Apr 2026 01:58:03 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e3a341sm47712138f8f.24.2026.04.22.01.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 01:58:02 -0700 (PDT)
Date: Wed, 22 Apr 2026 10:58:02 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, djwong@kernel.org, 
	david@fromorbit.com
Subject: Re: [PATCH v8 00/22] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <iads77qkk2wjkqfezd4vtqsga6btlkqdyephqojyv76herp6by@l24e2hm2ebas>
References: <20260420114714.1621982-1-aalbersh@kernel.org>
 <20260421214316.GB37143@quark>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421214316.GB37143@quark>

On 2026-04-21 14:43:16, Eric Biggers wrote:
> On Mon, Apr 20, 2026 at 01:46:47PM +0200, Andrey Albershteyn wrote:
> > This series based on v7.0 with Christoph's read ioends patchset [1].
> > 
> > kernel:
> > https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfs-linux.git/log/?h=b4/fsverity
> 
> FYI: the git repository doesn't match what was actually sent out.  For
> example the patch "ovl: use core fsverity ensure info interface" is a
> bit different.  The version in git (incorrectly, I think) ignores the
> error code, while the patch returns it.
> 
> - Eric
> 

Thanks, you're right, I forgot to push

-- 
- Andrey

