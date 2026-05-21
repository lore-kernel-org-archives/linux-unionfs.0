Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB64437BE81
	for <linux-unionfs@vger.kernel.org>; Thu, 21 May 2026 09:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779356543; cv=none; b=FAiNd5t5vesNOtriOMSM54jei4J4UQiscBQv8QvxqC2GUh7sneBntTUeILtAHOVYGtGsi/axgnHcOLNg5TScnwYfbFCICpQeaBze8Z4jXT1ucBldrgla8I64a/fPWAjnpYb5OTFqV5/zhC9I8RW2FeiymTFB4eT8nrhXX10+bBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779356543; c=relaxed/simple;
	bh=/n6YuXXsfcsk7J7Yb0y1thOCuPSSvlN7WSB70uhim0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XiffwUgKro0up86RCd95kjC9gMkN4FTR9Qb9BWA5++CjgdqRfXkvFGnHOQjzysft2+w9zqqIdhG99dJzLnQA5Neppq1/HbEq3SJ4C+CcAsklIO/CX/9UZKczQMNOx/F+ZgbhID5I4+GZgAns0aqSoL4f8VYncwukV3VgeTs98Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BCaLQxYv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gE2mTH44; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BCaLQxYv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gE2mTH44"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779356541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0WzMLsQukLw8E3UhBm+/KFb/Fo3mZZq0u+Zrumr4RyU=;
	b=BCaLQxYvbeX0m4kd7hh/rCMYMx9yhOMpuuNpbUJ7Eq1Hm6TSKdlEenbz/vI48KI1+o4T18
	Ll6K96HKzKxEOHouCUdQiAfVH5GVx1XAyA3TuOgpnf6/h5MyVtZxCrrHniy08f4PzEbvWg
	et8RHKtll0A9vlEUTcr7cfjT0qzKCzU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-rEwsy9tnPeemCPMeQzKhHA-1; Thu, 21 May 2026 05:42:17 -0400
X-MC-Unique: rEwsy9tnPeemCPMeQzKhHA-1
X-Mimecast-MFC-AGG-ID: rEwsy9tnPeemCPMeQzKhHA_1779356536
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-44a71109b94so4410606f8f.3
        for <linux-unionfs@vger.kernel.org>; Thu, 21 May 2026 02:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1779356536; x=1779961336; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0WzMLsQukLw8E3UhBm+/KFb/Fo3mZZq0u+Zrumr4RyU=;
        b=gE2mTH44GayFr9mtAkmJVfSU67d3tm+/YLoN17BfGZH3Kca71yP9gzWsOKPeIsBvRD
         laEPjmCECV77JeVn2SVjFX74IqeEWHDMu8tUR8rhrshkr5wxfi2XcsVJccvbpbFEoWPv
         T0aUIqhFrL5b/ffdNRMW5j4OnaKfqZS5jKXSx8i7zQFOkQn+EJQ/EZi9N9/nAPflgD+5
         dy6pfrWDU14zulEvGUGFZnzpcbEeVydktffcHNVHMhfkzW3gi8amUGywq1wodNRvSV7A
         SWesHKw5+EIirgvWil3KTxyyGqJCG5WJq03iNKYm/EYtJ/BjPsF9U4QLV9nW/dOAZEDz
         6nnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779356536; x=1779961336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0WzMLsQukLw8E3UhBm+/KFb/Fo3mZZq0u+Zrumr4RyU=;
        b=sY6DLOmSFFTZI0hLGK1+lYynpCwT31JddERrev7vjm5DQ8TzvGlvgJ+4C+PZ6hxSgv
         VlMMyPlsU5EYCSwZ98rYSS0aMabSqKD8ZAZx6HDgex9OcIJ2R9wCDzR5hiOdg3Q9AESx
         OHHV12lQmzCeVgbwN7sRFl9guwGvgTs0TG13+9OYQ74YdEeaxYOGTi7gqK7zkxpeg1dI
         sWo7M5o+PfBCvZoPR1UVObJBrSxPz+EUNpKFuWK9OQvkpAxdTUobILR8N9Q2va5GbiVy
         2S3HQdhPDiODFrMyv2+VphAitmem6Iop+p2BB34Wj+PQeZIgYfzDQ+6EMvK2JQFf7dGq
         awTw==
X-Forwarded-Encrypted: i=1; AFNElJ8KHdLSKj8Ux9JjpHmYBr9oAN62WDcab3CfyZUToJ2uGasO6kj4Ifon7YBNmeL7i7PGYfp053bGDGo3ihgw@vger.kernel.org
X-Gm-Message-State: AOJu0Ywdt6jFdXjCfgRkgCU/hms9Qey69U1d0sC/tzC3+q17yVDxGPLa
	G9xbredqajOBJdKeIw5ed27/0I6ZbwJEc/Kv4sfs9sXF3pvE18bnuVbDbe7qpXC5vcMicFWdXUP
	WynJot3XW6mwvGERyiU93GCLZSPHdeB+6sKVxBB6xwk0i+e0yzFoDmsHIqFfrvPy2Tg==
X-Gm-Gg: Acq92OFfei2LuXnog//AoesNOEww0j7UE7ftmaqnrPCKDC6EgbV1ZBPS34pcGaG55ef
	+r1u48tHBlKAj0dVZ1GuOMr2MJZegcBWvCVYXNdjkm4r1PlMKOuny/55rKs08r4xRnNoo0W5BAF
	57d7HQOl/WBLgW/AkzSOngtvchp/t9cRJX0GanYi+btkIaXC9vOqiOLcKrGBFjmNBgGwvadcZSr
	VwP2PAQGukRPO8ivzJiv4ub5EbCuavpWFeHfIlKFOw8UmqzhBJuUT2fE8J5QthW04e6ox3NmnDk
	LkaW54LNarW2kbAKlp88Hx5CMAz/cdxAbKTmTW8UX7zcsBtcYykti1krEG+lSRx15/4F7AxvBQ3
	3snjrITKSyjRiY1sxeD2VXd8wZpvwPPVSaoxWNdYPkFzhtLoLMkDBJ8U=
X-Received: by 2002:a05:600c:81c9:b0:490:3cec:52f5 with SMTP id 5b1f17b1804b1-4903cec55f5mr9776015e9.2.1779356536318;
        Thu, 21 May 2026 02:42:16 -0700 (PDT)
X-Received: by 2002:a05:600c:81c9:b0:490:3cec:52f5 with SMTP id 5b1f17b1804b1-4903cec55f5mr9775515e9.2.1779356535822;
        Thu, 21 May 2026 02:42:15 -0700 (PDT)
Received: from thinky (178-221-68-189.dynamic.isp.telekom.rs. [178.221.68.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4903c9abbadsm13930015e9.8.2026.05.21.02.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 02:42:15 -0700 (PDT)
Date: Thu, 21 May 2026 11:42:13 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, djwong@kernel.org, 
	david@fromorbit.com
Subject: Re: [PATCH v10 00/22] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <gcw7zcg6p4s2egpufwizfig72g6ren7jfmuz5mqskkpb7xepww@e3v35j7bk7dc>
References: <20260520123722.405752-1-aalbersh@kernel.org>
 <20260521090705.GA14254@lst.de>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521090705.GA14254@lst.de>

On 2026-05-21 11:07:05, Christoph Hellwig wrote:
> On Wed, May 20, 2026 at 02:36:58PM +0200, Andrey Albershteyn wrote:
> > This series based on v7.1-rc4.
> 
> How are we going to merge this?  It touches at three subsystem trees
> (fsverity, vfs/iomap, xfs) so some coordination will be needed.

As most of the patches are xfs, it's probably make sense to go
through xfs tree

Carlos, what do you think?

-- 
- Andrey

