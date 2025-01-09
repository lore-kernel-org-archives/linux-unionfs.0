Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE162185AB
	for <linux-unionfs@vger.kernel.org>; Thu,  9 Jan 2025 13:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736428438; cv=none; b=Uz38nH8XHXLFpVzup2p12fhuqnsgCakBkvu4koquePXtESD7v3dVESVkFMNbhM1VXk6bexHxCzphZEdE/CObGcPPDJL2f9vRdvPtVlius3w3kmnoIzmXrrFB6LWvxT7+Y/jBef7+9GmXu+DDn9fhI97kwaj/GLd+B+QHmipHflc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736428438; c=relaxed/simple;
	bh=TwqBlKCo/5ENazwKpYfsYMgEwFOcQaBDDaRLL6b7F0Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JhulrUwCEPpbNJFchp2BTfJ+BvkGB3JxQud3D9GAoP1Y0uuXMgB4lHJRPM2e3Sexxvel5j6/zt9JALmWeuwvG1CSlI96PHu2nJqDkX02lxKZ2aVaswz1acuiqFOn8v4ONWqQMjDSery3dQ8qEG7fGc1iTJKYTiBxzYZStzmZc8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=VZgq4P8M; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="VZgq4P8M"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-46785fbb949so6501661cf.3
        for <linux-unionfs@vger.kernel.org>; Thu, 09 Jan 2025 05:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1736428436; x=1737033236; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TwqBlKCo/5ENazwKpYfsYMgEwFOcQaBDDaRLL6b7F0Y=;
        b=VZgq4P8MzzCxCeL4uDMp4vnX5xbYFma5IQHgNdf2FJkHIxzJ8xIm2uIeSMLB4PWMfY
         uhkouWeV2ZKEoOTDKG5dkosJIe1wZBBTit3fTuTCROfG1bWQJuucu8dBTluU34PqdHad
         t8zXwi+XF4bOljc3v5otAc1pBORXchCox8+ws=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736428436; x=1737033236;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TwqBlKCo/5ENazwKpYfsYMgEwFOcQaBDDaRLL6b7F0Y=;
        b=JgifErqDg2b2AN2rOW6wDUMVxGO2ZbQa0lI++WP1utumY3LwoNVjXDhzuQCRu9kBxY
         MXxK+TDNjhsfHAUT0keshZ6KrUrlkPX3mQu+HqWVZIO8D0mGOw6BciYVRobRtOWVViNQ
         wiV/Z8z992QlbyE35QpJliYO5xR3V/dLb1Yg6M9h0eLZ9fBeK0njlOMuGpNJolDjiohr
         x7iRIUYYY5fmNS70qWfYcW/qGp+gxX6tvJ1tD+N/68tZXddW5qFkBKyI6GywrHKl8b0Y
         CggPQT3Ofooh4xCVKaXgPmBl1WH2PNx78rPVmU/27FRh6yzOjIIG+olZaEm2Lpv1Mogo
         EAkQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpGyk8R4azYpoZGScGvxqUaKs1a+RR5ATKIUiwUxBHeJM+BopRypWAYW2iEmmoMOSWKqRsiZs8M5dVuwzo@vger.kernel.org
X-Gm-Message-State: AOJu0YwmfUsv/c9m+aHfVDDajtdYN+ofsNkgKaAPExWxAS/KSbN00pVM
	Z0gkrq7EL9HeIZiMxX4ZMvLL9yoeh+b0P4sxRGWGlMeyAIClscl3USSFVIOwHcdXAuj3EL4RLIT
	QWGtOQditWRa5mSwGmGZYH/jvSbQEG9FIasN/jY+36eFscqUv6BdyeQ==
X-Gm-Gg: ASbGncubGPpf4XmbINbKkbrtYK/6IMrp3td+yg+5w5J0NrbKFOea1kJRn2h/4BmZalO
	ZXN58q76nWYS3kix5L8yWbTFikOLf+KK5XvIWGzk=
X-Google-Smtp-Source: AGHT+IFG9GJ09B4FJOZ+YFICJgZdpqOWtmk2iKM62UmCr1P+AGqCNFgZVmbiuXdIM4c1ctKzMWFGlhfolaoLVp2CoEQ=
X-Received: by 2002:ac8:5a48:0:b0:467:5712:a69a with SMTP id
 d75a77b69052e-46c7102fcb6mr96531341cf.29.1736428436036; Thu, 09 Jan 2025
 05:13:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0000000000003d5bc30617238b6d@google.com> <677ee31c.050a0220.25a300.01a2.GAE@google.com>
 <CAJfpeguhqz7dGeEc7H_xT6aCXR6e5ZPsTwWwe-oxamLaNkW6=g@mail.gmail.com>
In-Reply-To: <CAJfpeguhqz7dGeEc7H_xT6aCXR6e5ZPsTwWwe-oxamLaNkW6=g@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 9 Jan 2025 14:13:45 +0100
X-Gm-Features: AbW1kvavAsEfIUw5DyroXkQiIKTKKS9TDRTAdAT2RB5wVAD6b1Ef2WcW4M0Jvo4
Message-ID: <CAJfpegsJt0+oE1OJxEb9kPXA+rouTb4nU6QTA49=SmaZp+dksQ@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] BUG: unable to handle kernel NULL pointer
 dereference in __lookup_slow (3)
To: syzbot <syzbot+94891a5155abdf6821b7@syzkaller.appspotmail.com>
Cc: aivazian.tigran@gmail.com, amir73il@gmail.com, andrew.kanner@gmail.com, 
	kovalev@altlinux.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	stable@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

#syz dup: BUG: unable to handle kernel NULL pointer dereference in
lookup_one_unlocked
