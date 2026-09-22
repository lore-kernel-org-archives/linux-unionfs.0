Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3705221EB
	for <linux-unionfs@vger.kernel.org>; Tue, 22 Sep 2026 08:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790067377; cv=none; b=WRDYcCjwCuJrmkFcipSRe9P/Ezhl4iBYT8qkA64ikc7A6NgRw63GJTw/grIVGVPob6LSdsXOsGfGnWulkIxJi5W0QPPkXQr5gFlMVD2dvwYu+wwyVHY0K+BjVB0kXBY0/dBeaXKEkLXFKH4F3ps4d5rTrSmNoDxjluP2vK7sv8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790067377; c=relaxed/simple;
	bh=dTZ74AujbnWToEkdYNhWDDknBgtfEGUv+/3pS6per/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BhoOZCML32V3EvskorSRlwNhQr4cq6VV4pL6HmgZ8zcDhLZPLBx27HBZ6OZ4kIJMcScsR0g+f9SOS42hL3GFl3TTZzYz8xOas2BPUhHPoWaPqc86agj4dI88TElONqQum80whCaOpNRrcbghFCtZxWGwBsrIgyzEikTngcGrmFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PoYEMg4x; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=eZbtqite; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PoYEMg4x";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="eZbtqite"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790067375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ovEqrxQiNC1fApdCYwkn/e/ow08kQkdi30NnfIiXj3g=;
	b=PoYEMg4xgpD82I1/3VKm5OIVh16Wbys/KxeOlU/iQ98sOKzrjvZJdI4EPX3bx+wKrbO1fS
	CSw/KpoIOYrFVydf7397n9ktvov65gIZ03mBMTfo5p1DQmMLQ8LLc+ie3EHxzZ83KOu74r
	XwVdBz21gpjxJSCh1nQxfojxWt5Lyyw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-XMlfp-dLMrKReA0qO-OMgQ-1; Tue, 22 Sep 2026 04:56:12 -0400
X-MC-Unique: XMlfp-dLMrKReA0qO-OMgQ-1
X-Mimecast-MFC-AGG-ID: XMlfp-dLMrKReA0qO-OMgQ_1790067371
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4870a0f802cso3664379f8f.0
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Sep 2026 01:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790067371; x=1790672171; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ovEqrxQiNC1fApdCYwkn/e/ow08kQkdi30NnfIiXj3g=;
        b=eZbtqitewffqEAtbuZvziZPr1toNvg5J/UstrD6538H1I0iyAiiDGGPPbtWAM1HcGV
         lIUnJ1EHJIfDGY5LMGVjjjKJKB2Zuc1ec7j8tAHuhGiwKkIleUKRFjUZx24t3DTpSswJ
         TH7+eZYGzF0+CQS4EhY0FqhNpjCuAat9FgJRxyY/hgBa9Cgt2YvpXv9hH/5rGcWAxwZ5
         WpA6ceg3/mjQL4E9xXnCjMSakIMxHEq6CXZ0n5RYFtAuMebBxuP/AE9hEy+pGFGIrXUJ
         oMwULrLe6l2XCjRk9u3et+3lf/vrFxFYu5cm3x5q3k0pvP8xg9tb1a4X3gCqUYhh6lG9
         UEHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790067371; x=1790672171;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ovEqrxQiNC1fApdCYwkn/e/ow08kQkdi30NnfIiXj3g=;
        b=dbscyWB+qevDlAO40BI8y6TWT1ylmgOvFaKla9TVchBnPx2+msyrYqXqxibQF+kBm4
         X9qZ+8+sMuCMc2KttLMxIbzfnpJvZ3oeNo17Ooso5ZCfXMDRvqTHwW1zItQPwHU0Z0JK
         lFgzLWGhnz4C9JaBqh6UIem1HETnayGtvj6neYt07jjx1ChQ2Q2XRJCwb4HT6FgLshQF
         CXocRfjCP2LLH7+DkPloq999Et9Ms+IQ8+kDPCe6MKtQ0oRKp7gbNB9mLPigk8PhIBEo
         fttykT38Zj2nfgzaNLvvovqOXmjB/BZrIRaCoHmR/xJtx+7B5MG80TzEqXaQ0nEPsPzh
         k1dw==
X-Forwarded-Encrypted: i=1; AKwUvBxZVGEZ75Kja2lPu2+66mXNVPTjZAoLIo6WX8N8myaRFWd/n9aNEpud2HIGwhuyojOBU/mzEBNQ/NWKWKcY@vger.kernel.org
X-Gm-Message-State: AFuF++l9sHlW6YJ3cmpF+d5FoD3DMqfu10yqWpXmIYW1GzRRLBcjSRkQ
	78Otta/6dBMvqynfZKH0B12Vc5xqGWR5MnI2KApA+F7NSr5T99Z3gQlmT41s/htnQvKd3WYtyZK
	F735omhIL8yiPJm98kcpoCjsTB9XSkHHfh+BgCV2tDwV+/ctW3Xu84twKZA5bbHosGg==
X-Gm-Gg: AYBFou23ETQPTr4A/WuJIPvzmnQRh0CeZ/Nbra5ZQnVPmsMa+jSPd7Fp8EPnS8jo7+k
	ONj7mV9qZes7Z7VbY5GwBTC6QCtAtA6W3igjG6AN1EUSYHJPecceQuy0cvES/jjX/4Z3sttvzwR
	EdxO5vQTayOLpDKtCHfo4f42aVui97SQDWBEzV7OOkMpN5Zf6V8hee6XSMpfQmF9uHNzMjG8wfl
	K4gXvhnHXMxKj6dxg3zbpg4ZATivneOIjP7YzyOAEVNpnx0/iA1pa0OIpYHaWyh2O++WcBMwsf6
	mfs5wGHr9EQsnQfTz9Iha+IKAEgFMn5cVuHNKy34bvRSVdf9apjqRYujitMUYxRBwgt7Ng7tfqW
	5nw8PyEreJ24oEPo3zVbZoLp9gc0MLeBO0A==
X-Received: by 2002:a5d:64e8:0:b0:484:3310:f394 with SMTP id ffacd0b85a97d-4871e25c7f7mr20485479f8f.23.1790067370988;
        Tue, 22 Sep 2026 01:56:10 -0700 (PDT)
X-Received: by 2002:a5d:64e8:0:b0:484:3310:f394 with SMTP id ffacd0b85a97d-4871e25c7f7mr20485428f8f.23.1790067370461;
        Tue, 22 Sep 2026 01:56:10 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48862795083sm3236382f8f.33.2026.09.22.01.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 01:56:10 -0700 (PDT)
Date: Tue, 22 Sep 2026 10:56:09 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, djwong@kernel.org, 
	ebiggers@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 15/21] xfs: add fs-verity support
Message-ID: <arI-5Ejg0Xw7OVmH@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-16-aalbersh@kernel.org>
 <arIszDCcy0VbRVFp@infradead.org>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arIszDCcy0VbRVFp@infradead.org>

On 2026-09-22 00:22:52, Christoph Hellwig wrote:
> On Fri, Sep 18, 2026 at 01:15:27PM +0200, Andrey Albershteyn wrote:
> > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +	xfs_trans_ijoin(tp, ip, 0);
> > +
> > +	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));
> 
> We can't call truncate_inode_pages with the ilock held.
> 
> I also don't see what this is trying to protect to start with.
> 

I added this to remove stale pages created post-EOF, so, writeback
doesn't try to flush them latter (but now I see that writeback will
fail to map them to extents anyway). Also, if EOF gets extended
these pages would be exposed as they are up-to-date which would be
unexpected garbage.

-- 
- Andrey

