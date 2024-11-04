Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720391C2309
	for <linux-unionfs@vger.kernel.org>; Mon,  4 Nov 2024 16:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730738492; cv=none; b=VxxnX2RXULOGM0BBNWRgb+NJZhNQ4gfaYmaSf+xz4UHdCQZS6hi/6IPOSNVdPn30T+jPVKzool+9cBu0cO8UmN3ASbHey99ch6SqTJ86ItDOIipNWIUjjj4/6uvgVHN8Cy7v/12IZoXDhP+MsHGnirfOYR6sdjkc1FoEpCOuQy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730738492; c=relaxed/simple;
	bh=lGjaQ5Xw+37UJO/G3qI7xX09rqXHYT2TaXgIa/JhJfs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eFarw1BOETua8uSpZKhIDdwQOI/gX05bqWn/m9zjCPf/c+6HANWvxWB2rbi+4p9uYgos9JiZE9MyRR5qXXmIJSzFwJItkQdvyVl9Vpp99W2WDJPDjXTiT2WkDGTiceA1la5cwuhH0Hoap4xicZlxJSB3uXJkiXd9Fx1cBl2Y57I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=jGuEaHGx; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="jGuEaHGx"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-460e6d331d6so27257501cf.2
        for <linux-unionfs@vger.kernel.org>; Mon, 04 Nov 2024 08:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1730738489; x=1731343289; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WQXsgRgZL61fSdftXLtb0TZd60MgNOTbkKPoNO6zHDw=;
        b=jGuEaHGxUY/KHRhV7y335bbHgf4wNZNgIi4lMI+CubWCcgzK0MO8nkyH1A1inQkWYg
         e5E48gROEDXYbvI02NVzLcykOmt1sYqZTrx18I5n3Q1h4mBNB/XwEumg3mALgpGY10t0
         nItEqgvK2/k45lPArdC2KmXPjo/SEsImDnL3c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730738489; x=1731343289;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WQXsgRgZL61fSdftXLtb0TZd60MgNOTbkKPoNO6zHDw=;
        b=UuVnQRkHln81CpGrvs8+XE0BoEC+oc5SURyetM2es5V3jEyq3nmThIiqhc9p+uZUJZ
         aRgo7agaxY0fJMlG+nH9WeH2fRMVqEtgb3mEfBN+yePURUv1xYhPKHss5PgdZ0nDUTNT
         rlAPb6SFxWWTS5E3PC2RjlWxy0VwvJn0PR8gRmLDgr5iw3kdRzM/Y2JQiGlLcqXf8tb5
         umtxprPwlOcOiTO+iX96ZbQD6hGQxKR8jdbXXuNrslPjQV6vRkdzsah9Gc6EUqYe9RiT
         L7dBvfY4pW1Z6eoa5kTc+qndO5xwNzPRI6kIhffZYUEi8ffsq1YOanfMV8O/yUGDz2xY
         08MA==
X-Forwarded-Encrypted: i=1; AJvYcCWz7Qb4bKQyRe84CSPmyhkCLs3WP5xThd4B7UhBXC+3iOP7aA9XccYEGkIE1Fs89e1QcOelmETPLLsi0oUS@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4PZma88nMUPsUuXrur04T7VsFg6DuAH2AURXTgYXZVr95Wdf+
	VVWV5jX316Hvdg3M9sg+xUz9B4NzcFU+QtH+le4xzw8hvpMZL5o+Y0jkJB7iNbfFP8AGmgXAbV0
	wP/ZyM7ZCRV1rznSwdxkFBHAqA2+HF65PtbpiGA==
X-Google-Smtp-Source: AGHT+IFVJyReK5bVXzWjO5h35VTka3io1/CmckTKc5iMxvvPQ0EFjpu6oaadbZ1FOjOHvg3W5HyH1GlG8XwoVgibKYo=
X-Received: by 2002:ac8:7dcf:0:b0:461:653a:ea8 with SMTP id
 d75a77b69052e-461653a1400mr332654781cf.12.1730738489030; Mon, 04 Nov 2024
 08:41:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241026180741.cfqm6oqp3frvasfm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241028-eigelb-quintessenz-2adca4670ee8@brauner> <9f489a85-a2b5-4bd0-98ea-38e1f35fed47@sandeen.net>
 <20241031-ausdehnen-zensur-c7978b7da9a6@brauner>
In-Reply-To: <20241031-ausdehnen-zensur-c7978b7da9a6@brauner>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 4 Nov 2024 17:41:18 +0100
Message-ID: <CAJfpegtyMVX0Rzgd6Mqg=9OxqJzrGufqOK4iBU2TSSDrt36-PQ@mail.gmail.com>
Subject: Re: lots of fstests cases fail on overlay with util-linux 2.40.2 (new
 mount APIs)
To: Christian Brauner <brauner@kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Zorro Lang <zlang@redhat.com>, 
	Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Ian Kent <raven@themaw.net>
Content-Type: text/plain; charset="UTF-8"

On Thu, 31 Oct 2024 at 11:30, Christian Brauner <brauner@kernel.org> wrote:

> One option would be to add a fsconfig() flag that enforces strict
> remount behavior if the filesystem supports it. So it's would become an
> opt-in thing.

From what mount(8) does it seems the expected behavior of filesystems
is to reset the configuration state before parsing options in
reconfigure.   But it's not what mount(8) expects on the command line.
I.e. "mount -oremount,ro" will result in all previous options being
added to the list of options (except rw).  There's a big disconnect
between the two interfaces.

I guess your suggestion is to allow filesystem to process only the
options that are changed, right?

I think that makes perfect sense and would allow to slowly get rid of
the above disconnect.

Thanks,
Miklos
