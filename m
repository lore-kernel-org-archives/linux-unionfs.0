Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B85D1FA82B
	for <linux-unionfs@vger.kernel.org>; Tue, 14 Jan 2025 15:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736868749; cv=none; b=U3Ca6aguviNBB2LSjVh88MVDCwAdJq29pq+Eenmhq4hiT9Npw6hgwRQ3vWHk8XCqJ5mYOhXEWy2JnDBS99pN8eU/8QKeRPGsVbMJDm8vYpIzxlel4N3I5FXpEseJ0H7jpCvbH9rQxc4r+ZYvqeEIqgHUUOZ/Hugc7jw8gxXWrrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736868749; c=relaxed/simple;
	bh=No/nXQfc8Oh/Uj7elL6IveAI7ZllL+zaTwEjilXXgHk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f3kaQAAapP3OvbDMnR64voPs/VLTqWPNkb96FT5UFpN0Zc+3jaEWz2EFOfbdw2ois4OlHgR8zFZ4JyrjCRkh9ITA+hxTyib0Z1SDethuDHCMPVvvcudOX/gHNCI0yLoUElH5e9uch2iIYzZ3/zGpRf9zyi0WhXUguMhWnv+PyYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=NQM9NILt; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="NQM9NILt"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-467725245a2so51140211cf.3
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jan 2025 07:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1736868745; x=1737473545; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=U9dPwxe/E84ogaw29ZtHhNanL/kQMTf0/avNES4Cj7M=;
        b=NQM9NILtBk5Oi5u4tpIyRwsMnjVwaaO/NDq1KJP4hPFmG4ikY+XE0vTLXWG7YvcthN
         s00ER3jMnRsV7hPsx67aZ+IED+76qqDNTvss14q6d91FLA1hkJqBFix4/NPP3Hn8Fjga
         jUu0eUFWXIEUQG/dDzZIGCHqMtzxruoA8025g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736868745; x=1737473545;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U9dPwxe/E84ogaw29ZtHhNanL/kQMTf0/avNES4Cj7M=;
        b=Fq593gxbXiaw0whzzDvwCHG45WaWhSkRruysVMSCbxx2DC7pRiJl6osD1BdZxjVBKp
         AsmDk3Jw82cwHz+/cRDlnafLWHKO8GbHsXpxE094O1jfsv0k6aiOv354lV7ASYflH15Z
         ke/XNPCsXjXBK0cbaYxlpY7r7jsLW/Tm6x3CX/KYXLlP6lhXEGR9OiRqZvWXZqBE0NTG
         jGFYjaSVpZPSWGizXdH7vnPyRnCuVkmGr0RkZjO0vpBcMVwMAKSfbRsQzGQbmmMpqazx
         TEc5EmzuZEAMJP2BkNV0ri+gLWBcUX94UrzGGSzcr229v0qW5ajirr6bFgUQkN4fTLqr
         wltA==
X-Forwarded-Encrypted: i=1; AJvYcCWhT5MxXqTXz5VS1Jreg1zD/XaAuuA4clDzUeCw+1GR4B44A0pWvvIm24ADfqOYr8qKgsc498lCriChMC5X@vger.kernel.org
X-Gm-Message-State: AOJu0YzECbLHVPRGcL5UF1VN55hDcsztlxO+z3W5VpmfZf2TBEAr891q
	mr/VYCbKwLTo2455cGVsyEDyG4udMedwx4HjOGXaZGLkVMpIuzy7w7iuTCZeSr6i1jPMjsvkHss
	cbyRBQ7w9gbD8MyaItF7ehiCiPpERz8aeC32QBA==
X-Gm-Gg: ASbGncsSV/3jZtaPQknNe8BjJp5lziHR/1RD+ppi0PNB72TY19Y71wSt2UGIEGQXUz6
	afjs2/66oFIla3knD6NOht5sXiZ2PJZoF3/2U
X-Google-Smtp-Source: AGHT+IEPiZ70N/g672/8Ebn72FMiq9c9viHSjEuSIenzdxqPBLOCePxe9QkqV+FUcRTYuFVI2HrmfFGsZReWlXxFBug=
X-Received: by 2002:a05:622a:1889:b0:466:a51b:6281 with SMTP id
 d75a77b69052e-46c7102ca25mr395927251cf.26.1736868745116; Tue, 14 Jan 2025
 07:32:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <111000.1736867714@warthog.procyon.org.uk>
In-Reply-To: <111000.1736867714@warthog.procyon.org.uk>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 14 Jan 2025 16:32:14 +0100
X-Gm-Features: AbW1kvb2bGtUfY43hElzeOuIlHlWqadAL-6mFDgHIGh1XTOI5-K5H6T4Df78aUw
Message-ID: <CAJfpegsUbvMB_tFbV283_JmK+wzFAECaLZgYAbmcBbBxWX=Ctw@mail.gmail.com>
Subject: Re: How to support directory opacity in a filesystem for overlayfs to use?
To: David Howells <dhowells@redhat.com>
Cc: mszeredi@redhat.com, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 14 Jan 2025 at 16:15, David Howells <dhowells@redhat.com> wrote:

> What's the best way for a network filesystem to make a native
> directory-is-opaque flag available to the system?  Is it best to catch
> setxattr/getxattr/removexattr("overlay.opaque") and translate these into the
> RPCs to wrangle the flag?

I don't know.  Out of curiosity, which filesystem is it?

There's "trusted.overlay.opaque" and "user.overlay.opaque" and are
used in different scenarios.   There was also talk of making the
"trusted." namespace nest inside user namespaces, but apparently it's
not so important.

Which one would you like to emulate?

Thanks,
Miklos
