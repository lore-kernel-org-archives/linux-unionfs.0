Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187E7376E0
	for <linux-unionfs@vger.kernel.org>; Mon, 15 Apr 2024 08:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713168560; cv=none; b=mQf9FSFjlxugn+htJwdxlx8L5BVVzzvx6KC8uhPluuPMLkeyHpD1hI47yVpnvtil8UrQayshofoNDb9DRpKxs66NXw0rf/18WvIag7RkwtX8CBQI9yBeUmtpbRzP/dnm3+1bRgYQQvMbsd0QkBZrSRhPuziWgJ2TGW6e4qUL024=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713168560; c=relaxed/simple;
	bh=YwT+akiycT7zUiBlGUGl+TAPvveigRMKj7UEv7P0iyU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VpQGFW4ENwoJWA5GC8kMYS/vSHEiw2UEXTMpkuW0fevzmakkqFcO4j61jUB77MN3Sc30VN84Xv4bKFNSux23y69E9kJqVCF7tjSbYHc6jkcwHzLLwm/nn0hYOVFvtZwT82Rdg5z65A0NuJlkDHg3V1hsYKsKCDp86/jseJ9iTxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=JY7WVL3i; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="JY7WVL3i"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a52582ecde4so133152966b.0
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Apr 2024 01:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1713168557; x=1713773357; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pHvyqQ17Tn2O1Y0m3BirRC4u7vNkpQHjAXPedl5MpWU=;
        b=JY7WVL3iVR1YLrQJA7nhoQOedXkhesVg2XEwHh8rAUu/acPKqm0qf44vf+48wWkWTX
         +O6aby62bOxOX1VjWQBgTgy0fQX2rx9AYcF3Ds854NornsqjRUFMozqBVDanOliOXjaC
         ABMew1MNiWf/XcKre597vqyus32SD6AwiwqYA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713168557; x=1713773357;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pHvyqQ17Tn2O1Y0m3BirRC4u7vNkpQHjAXPedl5MpWU=;
        b=C6xv26UKr6bcdX2j1Yk6qOd8BoTwJg+Q3ug1WOSzKKSrhFpc63XmTwYuYyx6BoT2He
         D2h8DwBvgwo2lzurezBN3DmMSNFQKfCKrlP2/tQpGYhKecJqNGlARKRf9IpKKJM68j5l
         jauWKHtrzs/keIEWauTAnbPxcPuqtEivyruw0ayz47BYi1L3j07ntNEpVd34g/I3oLUN
         MMzSZZ/hyI4+vghQziydM5nP/4C2ww1ggrOxb0GClXIqKO85aoUovnz5QOUwjRg1L/00
         edKMYAEinFaR5kTNMv0VOcZePBjnu/O52fh32ce/OmD/lS/7pYzwQMUhNt/O8XFL1IsX
         GwjA==
X-Forwarded-Encrypted: i=1; AJvYcCWnvKtI1QQjzLdIymyMFXtEqMnO/kG/BqVQty9ABjLROFupQIDhoCffO6ldAgt6Cy6MfTr/v07vyi9UN4geayQ/HMVZS+/IqQub6/pueg==
X-Gm-Message-State: AOJu0YxObbXrnx1korm60d1/hmpWPtsfrJLsvKw0x7QtZT2d8i8IXpuA
	/U5HGellmMJruiuQtWr1YAYDnxf+5neinWDz8jwWHJxLadPextFP2Dv6bWORU1UOjzK/n+kN5lc
	Rk15WtGTdsmd+UdGfwJKKitX4B+qnsEpvbE/nHg==
X-Google-Smtp-Source: AGHT+IGoqJvq2Ws+YedI2hZHMr9V8PWREbeZlVZIRGIcxv9MlUvw5e4bwOV6DFMx4/NAgcd9Hj0J1HO6Mylueh0Bijo=
X-Received: by 2002:a17:907:7da1:b0:a51:b0e1:8640 with SMTP id
 oz33-20020a1709077da100b00a51b0e18640mr7941615ejc.9.1713168557383; Mon, 15
 Apr 2024 01:09:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240412140122.2607743-1-stefanb@linux.ibm.com>
 <20240412140122.2607743-3-stefanb@linux.ibm.com> <CAOQ4uxjDQO91cjA0sgyPStkwc_7+NxAOhyve94qUvXSM3ytk1g@mail.gmail.com>
 <89b4fb29-5906-4b21-8b5b-6b340701ffe4@linux.ibm.com>
In-Reply-To: <89b4fb29-5906-4b21-8b5b-6b340701ffe4@linux.ibm.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 15 Apr 2024 10:09:05 +0200
Message-ID: <CAJfpeguctirEYECoigcAsJwpGPCX2NyfMZ8H8GHGW-0UyKfjgg@mail.gmail.com>
Subject: Re: [RFC 2/2] ima: Fix detection of read/write violations on stacked filesystems
To: Stefan Berger <stefanb@linux.ibm.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-integrity@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zohar@linux.ibm.com, roberto.sassu@huawei.com, 
	Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 12 Apr 2024 at 21:09, Stefan Berger <stefanb@linux.ibm.com> wrote:

> I was hoping that this would be sufficiently generic to work with
> potential future stacked filesystems as well that would need to also
> provide support for D_REAL_FILEDATA.

I also have very bad feelings from IMA digging in the internals of overlayfs.

We should strive to get rid of remaining d_real() instances, not add more.

On a related note, D_REAL_METADATA was apparently added for IMA
(commit 11b3f8ae7081 ("fs: remove the inode argument to ->d_real()
method")), but there's no current user.  What's up with this?

Thanks,
Miklos
,
