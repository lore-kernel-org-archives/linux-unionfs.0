Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACF82D321A
	for <linux-unionfs@vger.kernel.org>; Thu,  9 Oct 2025 09:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760003819; cv=none; b=WVs2RZhVr6p0ikVoPARO7+nXc8YBoezCCOVFWYvJVRAp9xxWTfKG6R3poxxsCl5+7MlwfL0OPEeXZu/FodUHk6CVRGEjOfMZaasfjTOULK0bTP2S9JPxje28cPjQ8qpfcEM1OQZmWNSFBUb+DkHAiwxtwaU4JVtf82TgeJKUKSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760003819; c=relaxed/simple;
	bh=EaujaltYMrbtuVyQl8Ewzv9UPMfuBMqYvS2BiPsY2Fs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y9fIUqiD/RK7E3nyCc+Nll86Mtb6cHo83A7ucE78y0KWaf2/eFSrRyTjwPJKfInMgyTICASIUsmUDKsuyH2UGMnR5qiACgT3IXOgYKh/Snpzn+PRhHexCZSG9n5zYnxHQ8aHSMs/8k0GOya0BW1LINPO+OFJgI47xkEMDSGBjq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=TnbEwPpX; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="TnbEwPpX"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-883902b96c3so48048585a.1
        for <linux-unionfs@vger.kernel.org>; Thu, 09 Oct 2025 02:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1760003815; x=1760608615; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EaujaltYMrbtuVyQl8Ewzv9UPMfuBMqYvS2BiPsY2Fs=;
        b=TnbEwPpXY2UwH8tF3vMFCOXF021D81zS1Zdq71MREcP3m8D+yN4vBnW4Q4BtaV/Gb6
         pKpEB7ThKE8Dct31xMMXtaaU4oErF7cPBQqU6zLbtcEtIfWrTG2E7kflMx5ookD7+82Q
         HkgT1ieRVuwGlxOlsDEsXFgQfnDAJbiloOkaY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760003815; x=1760608615;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EaujaltYMrbtuVyQl8Ewzv9UPMfuBMqYvS2BiPsY2Fs=;
        b=wJW6lrI7F5nyGhWZpQ3HwEVz9LmN1cDjaIoNkbnnely7OUDcnmFBQK37UwFmJrovb1
         mSoZO2U6LX36bZsS1/90siNab82I+jbdt71z7D91YoChTWnvx8q3piiRhrqSnKZ/IANS
         DlEquNLAd3ffbidSxGsQ7zSWkBPz/Nkkasy5xgZdplMBb+fWs59m7+FjbsJHA0RY+kZ7
         8GmqFNkGqy0KSSme9BD+RJnR01P/7klIjvsOAlqsYltpmZWbeQbzaowqyTqnnJqvieqW
         eoF2a6lbcWRmceFqsCv/QHLuJ3yvJEuNe2UOk2NATIaM4m0A2vK62LkukTq6oE41QvYH
         umKg==
X-Forwarded-Encrypted: i=1; AJvYcCUxvbm6wkozUb0z/JDx/LEzJj0ZMvkr+7IfpmVfp2qvbStCPhUkrNqFBlkVwX5WCys99yni385Y854Ls3bP@vger.kernel.org
X-Gm-Message-State: AOJu0YzF9KV/p2PhVlv836EehvBivsaVv1RohJKsKQhaR5vK/lYO9vz6
	YSB/F8tCaJLyjLh9IJrwO7Ch10BxrmtEFBBDcdll1Y8m/0z0+AaMv7DFZczn2xBSJpF2PIKfJQ+
	kBOi8OFRMMVnD/kSvXhnD8Wh1Jcz1IHotIX3JyDnAyw==
X-Gm-Gg: ASbGncsqavk4vOCGFkI5NunUp0agDixu/a2F+twtqspBOq2Y1yN8/+kDax+g+fO+Lf6
	aAOgKHc8wjTHY0TIYiwDbSd27BlSdhAXZsuIbOz92ZrYXdqdalXg1i3/IQ33YfD+8tNwpVLcrDQ
	Moe5TzIMXVheQm1SjTBYxB6HZbdze5xZV2dcgeLucQ2NGY2I1JSNU3g6V9sco0pt8prNvrPWBEX
	oHYxV8O3QbCWqORkU/4RnpvlhHGKLdFhYU7/5sRyrSivmh3UBqlQ0ya/URG
X-Google-Smtp-Source: AGHT+IGq6pmF3s3G83lvtagMRISyMu463fiy99MSGk0x91mURHTek0qQw6R1QcNXV4Pgw+uYyuYQMDTcEZT1L8f2bMI=
X-Received: by 2002:a05:620a:4511:b0:859:17fd:a1a4 with SMTP id
 af79cd13be357-883544f1e34mr928382585a.8.1760003814923; Thu, 09 Oct 2025
 02:56:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251009054148.21842-1-heo@mykernel.net>
In-Reply-To: <20251009054148.21842-1-heo@mykernel.net>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 9 Oct 2025 11:56:43 +0200
X-Gm-Features: AS18NWCui-MS6pFH-QplokfxiEapGNIoNxUB8SR0J3SEjRSPnRVNIecNqCU_9n4
Message-ID: <CAJfpegtWcfaDooNgO9sxX2c30cfVJNibX4oev=3ZEJLrr4GrmQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: remove redundant IOCB_DIO_CALLER_COMP clearing
To: Seong-Gwang Heo <heo@mykernel.net>
Cc: amir73il@gmail.com, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 9 Oct 2025 at 07:42, Seong-Gwang Heo <heo@mykernel.net> wrote:
>
> The backing_file_write_iter() function, which is called
> immediately after this code, already contains identical
> logic to clear the IOCB_DIO_CALLER_COMP flag along with
> the same explanatory comment. There is no need to duplicate
> this operation in the overlayfs code.
>
> Signed-off-by: Seong-Gwang Heo <heo@mykernel.net>

Fixes: a6293b3e285c ("fs: factor out backing_file_{read,write}_iter() helpers")
Acked-by: Miklos Szeredi <mszeredi@redhat.com>

Thanks,
Miklos
