Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8B74ACC90
	for <linux-unionfs@vger.kernel.org>; Tue, 22 Sep 2026 08:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790065954; cv=none; b=UU15vnsbCx4CYMLp7zkr0FA8pOWflp/MlVldTlITEMOGuMPfhON/G1Az1yulO79u3XQFxGaT7w/PNBRYRaeSjbtykZQxPZej9ei2cDwE+4KLWUKYpBH8phPYSQpw23YGlGWq5Kq8EchI/c12ULwTardYJVLzOqj7MfZrm4ndnuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790065954; c=relaxed/simple;
	bh=bxOLRyx+TtzIaCObuWShkyjhDbes/LDLjKEl4CexuEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mpIFzkIILrlm89ymhQjvDXHZGb3G8FZGOStOh+xwd2qNofc19nakcXRObvZwysRTZqHsD4qY8YTGHc5FQNWh4uUEJMYwZjEyRDVK4CaTVuOcRk1TGQmsnX3KMf/Dt2i7fv7B3SIjXPr2r809I9CLLjHB0WU1ioBT6gi6HaNQ4n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OaX3zQe1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qz4gOev9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OaX3zQe1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qz4gOev9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790065951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v6HyFSOK4HYSfvcwVKnaiUCa+pWXMNUUzDe6nYFstxk=;
	b=OaX3zQe1A/i6f2euJs4tg+AxapSpwR/3HNRrlUjSYIpC9Mpdqm+Kj2SRngRipSkoiPwBFa
	zKsoxQVrgM/M7HDYboV9viAOVrd+eXclj+dPXexYRpPt2rIFqfz5jy2ytcX+46/V8uP7+C
	M88uKc11snPa14dasNqQJu3m5Pg4bAk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-VOzj7sWePq-_EZZybMjJLg-1; Tue, 22 Sep 2026 04:32:29 -0400
X-MC-Unique: VOzj7sWePq-_EZZybMjJLg-1
X-Mimecast-MFC-AGG-ID: VOzj7sWePq-_EZZybMjJLg_1790065949
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-490a767c7dcso28731745e9.2
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Sep 2026 01:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790065948; x=1790670748; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=v6HyFSOK4HYSfvcwVKnaiUCa+pWXMNUUzDe6nYFstxk=;
        b=Qz4gOev9TgVra5iOJWfTnbYEokCVKsZZUgM98FD6WKxETb+2CICQBG8jcqxWFdPrbv
         cf6wdt+ujB5YeEcHJYuRkn8CK4IsSIsaeQgLb1AOid1GU2VkOBDgM6zaLxKBN4kVfebZ
         amF/j7UhBtdBBIGHGO2yMskam0cpjPpF4kbhtgkJXJ5mXjX44+faUpCgF3EYfu/VgdIH
         7WG8dtTdaLbsPxPTWd5NZW52Xep/pfo/msijT/oEnpLZZZ6uLBvrDMpJ+X/+BYLPMFb7
         CjYY2bCexHm1KLIM93NpZ9JciGGb0Ay6sFee16y+WNwGJLKVcjV63Q1i25pBPCXdMsLf
         L68g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790065948; x=1790670748;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v6HyFSOK4HYSfvcwVKnaiUCa+pWXMNUUzDe6nYFstxk=;
        b=Q7fz4uBm3dF7FOOCfP0CSsJN9wf8bDBvK1mbNAZStJ2HQ4moLcsnV4+a3QJYv3itvA
         qyuT8DfNKhbKKGY66q1PW/gMiZaWp2N0rSSNwaPrXSVER2Kz8N8CuhsGX+XScObGDTzT
         7cSEnAbztlDq8ppbFaFnPqr0zQS6oD6nJlTi8TAhfyWzh7YQyNQtbdRe/JRTbAm6w9Kb
         SdBKu55KRQnv4XFNnE9ENE4xhFTi8CqMjUsrnnY9Jo5pJcEmk2MKNM6pRt7Puq7GQd0K
         GEbZkANbTOB7FM/guTmlmpjomfrtRLOvJezK2bUlBM0jh6ewwHzQG67g7fFQPzAuXFRW
         sxEA==
X-Forwarded-Encrypted: i=1; AKwUvByM0iGj2B4oJ6HA7VTrRijUvelUo65pEsapNAifCOgMBrS2+7xHHvrn5CctAiGFDEcyS0FbyM6e4g0UQnXV@vger.kernel.org
X-Gm-Message-State: AFuF++nEqpMUubo1guMRGYQ49AO7qDH307ArDhhM4JaOx/SussjMG/YE
	5thKsTnjoAbZPx8LFkqnJ56oaKrnTU7YZtPH+zPIdB1zwMJCwh5Py1kpVbN6GVL1DLU9rNamXvU
	FugVeNbp9AAt0MoiEflEq/IgSk5+3aVWf1a4siuwN+m8DDKwxGxt0yn3Xo3UStjGYtA==
X-Gm-Gg: AYBFou069WbuUg8N+2pUToyuFWXhCsXqwW1RJnHhakZlSG4iE7JUsM1LT1ZiLeI4H8G
	LG4glGe7VNEpg0h1+hL0rXU2B2PlqZ8z8q1pSh0TQrXSK5sToEGEbHNxSLWpAhKsr2IFT/TdJel
	8hOge9ytjqEaBQSTkL/tBjjHmrV1aAbe8nbKjGuh94+jAkoUJFS0zEw7EoX8PbnhCixciS0+qi8
	LEddiYT8q7xSOoMtJm36PiIzBYbr3PVnYkrd4Ah8q2qWTKd2Fp07qXhvL2hW6iLx7YL6DRSndzh
	Ptab68ibA7DKuQwLO1DPG+fS34WPTBlqMLJSm1GepOgssf9mYi/0RUQr9o1JjCi/bYri+3J5dPB
	hJi6p/X53YUyo+XbNpCQciNCThVo3fiHNvA==
X-Received: by 2002:a05:600c:3f0b:b0:49d:1df6:2592 with SMTP id 5b1f17b1804b1-49fc5750c61mr161767005e9.21.1790065948515;
        Tue, 22 Sep 2026 01:32:28 -0700 (PDT)
X-Received: by 2002:a05:600c:3f0b:b0:49d:1df6:2592 with SMTP id 5b1f17b1804b1-49fc5750c61mr161766615e9.21.1790065948022;
        Tue, 22 Sep 2026 01:32:28 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fdabe8a2asm32746655e9.4.2026.09.22.01.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 01:32:27 -0700 (PDT)
Date: Tue, 22 Sep 2026 10:32:24 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Andrey Albershteyn <aalbersh@kernel.org>, ebiggers@kernel.org, hch@lst.de, 
	Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 13/21] xfs: add XFS_BMAPI_UNWRITTEN to unmap
 unwritten extents in __xfs_bunmapi()
Message-ID: <arI8cvh8rgIwmv9V@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-14-aalbersh@kernel.org>
 <20260922043402.GM2705364@frogsfrogsfrogs>
 <arIsIhrWltHi9Aej@infradead.org>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arIsIhrWltHi9Aej@infradead.org>

On 2026-09-22 00:20:02, Christoph Hellwig wrote:
> On Mon, Sep 21, 2026 at 09:34:02PM -0700, Darrick J. Wong wrote:
> > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > index cc48f6e20e80..7ba76017ae56 100644
> > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > @@ -5280,6 +5280,10 @@ __xfs_bunmapi(
> > >  		if (del.br_startoff + del.br_blockcount > end + 1)
> > >  			del.br_blockcount = end + 1 - del.br_startoff;
> > >  
> > > +		if ((flags & XFS_BMAPI_UNWRITTEN) &&
> > > +				del.br_state != XFS_EXT_UNWRITTEN)
> > 
> > Odd indentation?
> > 
> > 		if ((flags & XFS_BMAPI_UNWRITTEN) &&
> > 		    del.br_state != XFS_EXT_UNWRITTEN)
> 
> Yeah.
> 
> > /me again wonders if bunmapi ought to have its own flags instaed of
> > reusing *some* of bmapi.  But I concede that ought to be a different
> > cleanup, because figuring out which flags are for bunmapi.  I think it's
> > REMAP, ATTR_FORK, NODISCARD, and UNWRITTEN?
> 
> I think that would create more confusion than it helps.  OTOH asserting
> the valid flag would be helful.
> 
> Sashiko complains about interactions with the weird rtextent bunmap
> behavior.  Should we disallow fsverity with a larger than fsb
> rtextensive to not bother with this?  Btw, did you test this series
> with RT classic and or zoned?

yeah, I will disallow it

I did many revisions back, but haven't tested recent versions, I
will test with rt for the next version

-- 
- Andrey

