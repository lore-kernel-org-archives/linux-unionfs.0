Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFBF1D79A4
	for <linux-unionfs@vger.kernel.org>; Mon,  7 Oct 2024 14:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728312931; cv=none; b=Kb86CG2bfpboFmGMxF8T7WenOnMPnb8WMA1YEUWS54djzfD0hR1V3t6HQWJ5mio/ZwCTn73efpduhMs3lIfSQzG4eIQ4WdE9FY2AszPAU9hJBIGtALFnoDkesJacn43+d8kEFHwgWWNYabhS9ZKc+9qaIl4y8WMQhue8lJQIa+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728312931; c=relaxed/simple;
	bh=9CwTgWElBJb0LcznUFDVpO7YSKyNZQkxv/GNCyKR/Vw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aDIQETJgBMbfdj3+L0N4M92JA3C6bZfDgFuKpdkRudAOfesEC3V2y8jhSS0dGtCgoFEeW/Jakekt0hca7fEfBylstSNqkADXvB9nOpuSSnDmoAmdAgag2pQ+asjf2tSmtoSw3lWrKYk8PkRGJ/FNcXkLXUXB6aet1gt2E7nwun4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=LIWPryA0; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="LIWPryA0"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a93c1cc74fdso784114766b.3
        for <linux-unionfs@vger.kernel.org>; Mon, 07 Oct 2024 07:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1728312928; x=1728917728; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=m5WRDXDsnn8xfUzvyZAlipJKvUJbHPqjoW3kJr/J9Wc=;
        b=LIWPryA0xf+PX3NRlOG8G8B6kla+upAe7zDaJ+qbgn7pyldsdFANeySr9eFrRSf231
         Un09v14WEKsf753LSDqg83VhFVC1fB4Fmov+XnGrLtXd1+OMv43EoVeQeA6j8lYxDdzf
         kp76/FTpOybhUmnAy/Wqiwis+47XBj9rdTRpw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728312928; x=1728917728;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m5WRDXDsnn8xfUzvyZAlipJKvUJbHPqjoW3kJr/J9Wc=;
        b=HjTPiQ+EJEhnsnfFqMOMOZwdrJ3dAWO5AZli/ajiBR/o/g1I1RWSPfvoVGbKqSHSIq
         u9C4cbQixFvCyXlSNascKDGutT9+iQXEsA8XZIMI81cq/5JKDt+nj9/QqV/iFHMJC/ka
         kU6D7jvnVfuhESczvD7uJLdh1BtLPkeOZMzWHytayH6hDTHzadldL12xI2e7I1RGHbj5
         Qpf51edzMibmD8NAmUWl6ImUbkn7sq53wA1mA8rYIVafV8o4fwRjYpEG4TWccCD65xFE
         NPBaxD+mgHPcqZuHPEjfHoaKuMJXc2o/1+3ClyAD4bYlWZkJd0pOP6U61/eMhILzX+uz
         CdZg==
X-Forwarded-Encrypted: i=1; AJvYcCXfnzXzdcOHXpof1Kmof/Hb2kMXG4YxbjBm4l+2balZNVBje60sc50PEP1w2L2HA5LgapXKVJ0/SdcNIqqc@vger.kernel.org
X-Gm-Message-State: AOJu0YzvubRpSnqE7nd6I/wqNBsRbXYkN1GAG/h8bFFgqyrTQizPVP/T
	rA0xYYrWHjCeRiyh+FHqVju9SFBX6MZg0XD8YrgecAlitaA3g95YnCp3ovIk2HrQUt1PbONQnYs
	upTu43rfsdlwTbuLrdxjDhxdhHT49CzwBZdgQSSEjXMCvveyK
X-Google-Smtp-Source: AGHT+IGkCl7U41DlnyVIm3YIZPuS3Zah00DcxXpjdIwWfD9jptoyPrrEo3T7JuSRwfhfqKWTkqcavZ1DAEcm3b3d1fs=
X-Received: by 2002:a17:907:9301:b0:a99:389a:63c2 with SMTP id
 a640c23a62f3a-a99389a66edmr753929166b.62.1728312928285; Mon, 07 Oct 2024
 07:55:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007141925.327055-1-amir73il@gmail.com> <20241007141925.327055-3-amir73il@gmail.com>
 <20241007144338.GL4017910@ZenIV>
In-Reply-To: <20241007144338.GL4017910@ZenIV>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 7 Oct 2024 16:55:16 +0200
Message-ID: <CAJfpegvsA=D_i3mRr9yLUBDQMmKhfbk1cs6Gcd+8Tpq=NVVVwQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] ovl: allocate a container struct ovl_file for ovl
 private context
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>, Christian Brauner <brauner@kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 7 Oct 2024 at 16:43, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Mon, Oct 07, 2024 at 04:19:22PM +0200, Amir Goldstein wrote:
> > Instead of using ->private_data to point at realfile directly, so
> > that we can add more context per ovl open file.
>
> Hmm...  That'll cost you an extra deref to get to underlying file.
> Cache footprint might get unpleasant...

Yes, that's an extra deref.  But stacking is bound to greatly increase
the cache footprint anyway, so this doesn't look a serious worry to
me.  I don't think overlayfs is at the point where we are ready to
optimize at the cache access level.

Thanks,
Miklos
