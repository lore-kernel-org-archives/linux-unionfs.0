Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A228925DCE5
	for <linux-unionfs@vger.kernel.org>; Wed,  9 Apr 2025 11:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744197160; cv=none; b=rxgKwNf32MohJM/Vt+ORb276WiJxwcYoI0ib1eSImmB2dRRIu7dYBm3/wsAueNeX1zT2jZG4tK9hPZAdJgzjyw5txjmE2AcQ8rZaYD9467KGFHkVoTmgZJb26fR2x32ugBTxOvvqeWrB6okPj2yX7ey8+1gMZpbw67szhg1Df+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744197160; c=relaxed/simple;
	bh=jReOz4zTlDC+vp4+1C79SPrvtefHrjCMTGFO5ZFNR1g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dNgYBqJtg8e+DAIA3TMMjHE3QCrDFCezkaXviUWOue4PMGKbbyyf0/nZET4XJXS1RXxVgrm32CCxTRBJ31jb+J+VDg7q4XaIOG35aNutzhskk3YbqPZugJE5AkWeYzlaB9Px0nernl0U7jC5RkJ6ibHHCzPkiTrgC93ukRM2ypk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=DafZc5pQ; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="DafZc5pQ"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7c6a59a515aso408278785a.0
        for <linux-unionfs@vger.kernel.org>; Wed, 09 Apr 2025 04:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1744197156; x=1744801956; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=L8zsW3p1jBNAHNun3l5be4SanrUasHqeykfYH6FqnEU=;
        b=DafZc5pQnPXbnyykZqw3YlHMpSJmkxHUc8AoMnPnKMB0RL5O6lD85gQkJSnhLGASyc
         Iaeo4hhxrSZ4cIMMxNlK+MRYft1a1zth8dC60oZZbgH0xg9WJqWpbNYkqmXpe/fOCWf/
         bKxl3KZpAx1KMNFo2mufzxXmJE/ezQWUNEcow=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744197156; x=1744801956;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L8zsW3p1jBNAHNun3l5be4SanrUasHqeykfYH6FqnEU=;
        b=LCcmMBI4Q8FhELafh1UVEjIWjB/ebGAh9uNnjdgdgD0avnBiLJU17WjRFVNDRdVPc7
         I0lUhjLFpY95l3kdtUGtxPi5nayPJIsb3HKJa7JCI8mQc2mbT6Zfhfeqm2uaOvZsEZLn
         ZKIvnynmqH0DQGEB7bygqJiqa/Ua5PknGO6378ICN1zx9Wl98vXWHDB53VOCaoMslUMG
         hQuAUYoGNv0sCzstQM79y4tv4igV2ozb/DF+s4LwOoLMWR0ghABb4H8uxP3K/UywZEdl
         tqLvamJRNuxGNpPH8mYhTpUUc8qpbLYYZtDfXuFzdpu54c6SUeU4nB2gH7JGi9j68JEG
         CPmA==
X-Forwarded-Encrypted: i=1; AJvYcCXhX0Y2nSqha93xmvuZm7Oy44WnLdVzdimDvfRXFIR7yK4hfurZxfeGSMCTHWhQHRCTVi5nbh9hkx9MqzfG@vger.kernel.org
X-Gm-Message-State: AOJu0YwsIahAJGcTIjqzKutHTrd9EPJx5k5P1hKy+Z8jF4SiZoSfKBsg
	GctuTMWziM2yLd7WoPteCgBZOoMDPFAZsl9BCLEMpY9OYlX8zmHZAGQ1/zZ6lku/qTLfcyzKMmm
	hGYZmQRwyfFm4QYPfaE/+ViHaJXKEHwI0DDDdgg==
X-Gm-Gg: ASbGncuW5iqr52N7dcnUOTZqkx8XCnUNK027WV2eTZOwUQ95m2gfvJHSpH7TMVODX+2
	XrZxqagjLgmQSEbSp7KDBWE3QKU9qjThFSaCKv6xu1cgGKBMVEtpA0BznK5yzv0KfaqSCTO6zif
	bKl2bJcKBGva+dCMWxPtKfvsk=
X-Google-Smtp-Source: AGHT+IFCBgrParqX0ZG9CNIMWiic4Ir0oxdyqswfZdFAmyVwVuOSJkQOYeEm1stvtQWP8T1Vue7LLE8yCoz+pDLEfU4=
X-Received: by 2002:a05:620a:8396:b0:7c0:9f12:2b7e with SMTP id
 af79cd13be357-7c79cbc982dmr390955985a.11.1744197156157; Wed, 09 Apr 2025
 04:12:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250408154011.673891-1-mszeredi@redhat.com> <20250408154011.673891-2-mszeredi@redhat.com>
 <CAOQ4uxjOT=m7ZsdLod3KEYe+69K--fGTUegSNwQg0fU7TeVbsQ@mail.gmail.com> <CAOQ4uxhXAxRBxRh9FT0prURdbRTGmmb4FWSs9zz2Rnk6U+0ZTA@mail.gmail.com>
In-Reply-To: <CAOQ4uxhXAxRBxRh9FT0prURdbRTGmmb4FWSs9zz2Rnk6U+0ZTA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 9 Apr 2025 13:12:25 +0200
X-Gm-Features: ATxdqUEAcTzVg4sJVoHeL5Fk3obPSpX5b0DIQNje9s51kPl6cVWASYAguFsEsd8
Message-ID: <CAJfpegsKAsNFgJMK4oS+gjD_XmhscjdTtmx0uW2GkCPC+kf6ug@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] ovl: make redirect/metacopy rejection consistent
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Giuseppe Scrivano <gscrivan@redhat.com>, 
	Alexander Larsson <alexl@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 9 Apr 2025 at 10:25, Amir Goldstein <amir73il@gmail.com> wrote:

> On second thought, if unpriv user suppresses ovl_set_redirect()
> by setting some mock redirect value on index maybe that lead to some
> risk. Not worth overthinking about it.
>
> Attached patch removed next* variables without this compromise.
>
> Tested it squashed to patch 1 and minor rebase conflicts fixes in patch 2.
> It passed your tests.

Thanks.

One more change:  in this patch we just want the consistency fix, not
the behavior change introduced in 2/3.  So move the
ovl_check_follow_redirect() to before the lazy-data check here and
restore the order in the next patch.

Pushed to overlayfs/vfs.git#overlayfs-next

Thanks,
Miklos
