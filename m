Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D69272626
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Jun 2025 01:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749172354; cv=none; b=KGHOhb9duA0ujkl6lBUUiRwySdIqZ7CfcI9QM3CbdjvWrR0zlyr0M63kKbkRu0EHRHmGPK0L6R/mQHTRMPaE3w9hX/5k2fjEKAZgPYXFOL2qBS33S62wVZZWfpQQXC437Jt8qo3ix0ra1uNc1gEAiMaTH+8WlnOg78INBZXLHgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749172354; c=relaxed/simple;
	bh=3ooHI6FPJCMRAm0ovcKFxMkkwTrgKIpsMgehJU/U3vs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ib5EsUkKC/YFhXlNGa0B6zAuFpBjIGLOaRNj1aWaL1mxtsVtaSJDoGonytyzURZ/lbRfk9m+Cydj52ySCaJ/zuF8dxDAD7eaZOFEXAtev8by6aScZMaPzQoVUeShDQK1tDf0X0ioLxXZz+ZvRtvPj0dG+YaBD0aJRG3KmQf88mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fvx8g/yb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fvx8g/yb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749172351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HX95HB5ptWt/448FfKgC0KXRWGbuJEkBSek2hhmcx6c=;
	b=fvx8g/ybzakescWhbWpYMKz/i812Jm224ejmvd9Cq9+pwxLNvXVqerZw8mvr2b+0yPlEeI
	Uj+6u3nYlV68l1x3zeWOdmJ6Jju7kiaCe+DOSlWLJ5L+v8O6j7i58JLvb/M8oXtI38Bovf
	wYuJlh/Zp2RuFWUBcmxVthlkq3A8EjQ=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-etkGyX3GOS-saUnGwVkNaA-1; Thu, 05 Jun 2025 21:12:30 -0400
X-MC-Unique: etkGyX3GOS-saUnGwVkNaA-1
X-Mimecast-MFC-AGG-ID: etkGyX3GOS-saUnGwVkNaA_1749172349
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-23494a515e3so12022155ad.2
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Jun 2025 18:12:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749172349; x=1749777149;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HX95HB5ptWt/448FfKgC0KXRWGbuJEkBSek2hhmcx6c=;
        b=sPjdby/NhYWibENpG4jJa9Rv3/2KB+3uXL/Wxma8fA05KlzDQDbzwR9X6kf4YB55JI
         wpOE+ZLyhdqwrraNpdQM86leNgf3s+6omy7mf9ULEEXEwnSEkwHW4rgdfreYJbegsUkh
         cnSJ77gYrAj1oxSgoyBgKFli9RwYlf6NPdH3eyZw7GoRn6CC0+YKm/35h/HZUXPTcRIi
         FZv27eqNY1bykPx8+Frr7EvoFfqmDmn3oDvpsMr5eEpl5dCfwEg6Eo+20bV9Oa00pTfg
         WwWj6dnBhdbKY//YSNG/AFSILeh91iCu/1I0cjlnX4zBIgrpOHdw/9wpdOYT5kL7Ws/g
         nJCw==
X-Forwarded-Encrypted: i=1; AJvYcCWaR/EPRamm6Fs0eBK/imLfudlZ7If8FmLTM6wg2r7GIoq6sSoM7KzAWV6nUREuc8Uxjik08+k1BHiLyCot@vger.kernel.org
X-Gm-Message-State: AOJu0YyOyw6nZ6A9Il75xp71BlGi0gMahtQjCX8eXl9wLAMm7A4S+oU6
	rjTKN2K1rWzSbvTcONPklE46HsgOy6Hf/UQYGJmNiVyO+s+Duv/BiV+/C0MI2cZ96Gn55dzskdQ
	OHNPMW+tAFIzzOanW1L1ssKWOR1FGJBFvhk2WCZw0KZfW3bz6eNUwnwr76IFDWaMegq8=
X-Gm-Gg: ASbGncvfBQZTrdXFPAxJChNRKvCjfJLjWeUVW6zhHePVvl3YVzd+6x3NEyWj1xtjrSq
	F7aTxss2qmYjlq8jzYkAhr4KYAklkb2qxmpu3JX1Gw7gNd6AVPPxPwHHhnR9BuXUtea1QY9ZPTL
	SBwN4Oqlynt0F+jPt6zf2JytpTOiu2mEJZyIjFs5MArqgvHeJ+hMzauXfMIMcuGifrQkwgzOzHy
	mJqOQ1if/BxmAeAto36+U2ksRhB7myq3OHoAoW5y1zrAVqYFqKAeQ0uHu8V2ZN0nEVYcBra75ce
	GX8+OSlBRuHX85siaEd8vm4QMVq1DY541tzGU+FBL2pHkZUZfu46KATuFExJXAs=
X-Received: by 2002:a17:903:244e:b0:235:f3e6:4680 with SMTP id d9443c01a7336-23601cfddb7mr19419135ad.21.1749172348992;
        Thu, 05 Jun 2025 18:12:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFRZTPON9QJBicej79aRZ7HeLcdoBXyrItjBPAYiGaQ/jSTv7WXBpAacXCL7dgvaln1F4t4QA==
X-Received: by 2002:a17:903:244e:b0:235:f3e6:4680 with SMTP id d9443c01a7336-23601cfddb7mr19418915ad.21.1749172348671;
        Thu, 05 Jun 2025 18:12:28 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3134968358bsm361111a91.0.2025.06.05.18.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 18:12:28 -0700 (PDT)
Date: Fri, 6 Jun 2025 09:12:23 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org,
	Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH v2 1/6] overlay: workaround libmount failure to remount,ro
Message-ID: <20250606011223.gx6xearyoqae5byp@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250603100745.2022891-1-amir73il@gmail.com>
 <20250603100745.2022891-2-amir73il@gmail.com>
 <20250605175129.oqqzr5qluxv52m6b@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxg2D-ED3vy=jedEKbpEJvWBLD=QYtfp=DCU3pQGGCaGog@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxg2D-ED3vy=jedEKbpEJvWBLD=QYtfp=DCU3pQGGCaGog@mail.gmail.com>

On Thu, Jun 05, 2025 at 08:30:53PM +0200, Amir Goldstein wrote:
> On Thu, Jun 5, 2025 at 7:51 PM Zorro Lang <zlang@redhat.com> wrote:
> >
> > On Tue, Jun 03, 2025 at 12:07:40PM +0200, Amir Goldstein wrote:
> > > libmount >= v1.39 calls several unneeded fsconfig() calls to reconfigure
> > > lowerdir/upperdir when user requests only -o remount,ro.
> > >
> > > Those calls fail because overlayfs does not allow making any config
> > > changes with new mount api, besides MS_RDONLY.
> > >
> > > We workaround this problem with --options-mode ignore.
> > >
> > > Reported-by: André Almeida <andrealmeid@igalia.com>
> > > Suggested-by: Karel Zak <kzak@redhat.com>
> > > Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-2350b1493d94@igalia.com/
> > > Link: https://lore.kernel.org/fstests/CAJfpegtJ3SDKmC80B4AfWiC3JmtWdW2+78fRZVtsuhe-wSRPvg@mail.gmail.com/
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >
> > > Changes since v1 [1]:
> > > - Change workaround from LIBMOUNT_FORCE_MOUNT2 to --options-mode=ignore
> > >
> > > [1] https://lore.kernel.org/fstests/20250526143500.1520660-1-amir73il@gmail.com/
> >
> > I'm not sure if I understand clearly. Does overlay list are fixing this issue
> > on kernel side, then providing a workaround to fstests to avoid the issue be
> > triggered too?
> >
> 
> Noone agreed to fix it on the kernel side.
> At least not yet.

If so, I have two questions:)
1) Will overlay fix it on kernel or mount util side?
2) Do you plan to keep this workaround until the issue be fixed in one day?
   Then revert this workaround?

Thanks,
Zorro

> 
> Thanks,
> Amir.
> 

