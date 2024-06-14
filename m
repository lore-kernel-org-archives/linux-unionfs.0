Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBEA1487E9
	for <linux-unionfs@vger.kernel.org>; Fri, 14 Jun 2024 07:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718349086; cv=none; b=XOQuswVR1UbSlJeB3z1mdPbSWpEZa7uXjKAzaugUwreZHA7eTe+8PQAhzTTg3MBRjz2bnn1rDqqCQeu16ibr9CdC5FEqCSF5YImr2L52/yCgeRfwWP3TiNJcTgKNPW4nRY9MfRZdRul9BfEbOkZSnmIV0fMYGAzuNDgrsHJByN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718349086; c=relaxed/simple;
	bh=l8eGqwVlSZc035rRa1tMyKGo0mOKJB0fBLhyTI6e4BE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aiT5BYkJdRqgY6Mgv6zyA9AinkMTmI6KyA2y9mFSIbXF0Gd0eAXWf0BLztL0eMq6WoZsygqvhI6nkb1Khvqy+hWaTfoUMn+f6KiZQXRwTTydbeErwPqvsPYwQWaxrsR9aGlcxXMu/ET9e6S6CipW6inGJxto9JRs3VT7K7k6b2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=M+xXHm7W; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="M+xXHm7W"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a6267778b3aso176946866b.3
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Jun 2024 00:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1718349083; x=1718953883; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l8eGqwVlSZc035rRa1tMyKGo0mOKJB0fBLhyTI6e4BE=;
        b=M+xXHm7WJTr3jhQkJNbr72YvYlZvsSAmBb/UiPwFg7lZF5aR4GzJxxixHqNjN3e1rg
         PCfhPxWrPUlRIgIvKVefZrbI/C5oW20SfBqwPRI9poPNBqJaq7XsmlG0W9BKv3yUTbUX
         tyC2G7imBEQdmYPBwJceWwGRHgtHnaZvwcDg8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718349083; x=1718953883;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l8eGqwVlSZc035rRa1tMyKGo0mOKJB0fBLhyTI6e4BE=;
        b=TH2p8RR9SRox8Bg34YviZsQ3/hHl7p03EunFAxp85gh+7JefeVuFfsCeb5RV8nDt8Q
         n9wh9nkCcH5u/PCBn/1ONpgBNFcBX+L/MXetHvuaV4OTIzIj8HcnpV7TF3B3ueK8Fz3q
         /pHwfoYnbI+y71HaWhPDKOqgVaMrGlEy9kt9dHni3wBi+JilrgYaqvFPVY+Jf9vKLkW/
         hEainKUSlZWnF/v0ix/8vLzrxxih/0ObBjJD/Jh+JEhgDtmlfY3nZjzBp85EEURX76an
         mPlPMQApQiZwgrjpr2p/LeeqL+C2+UwArwv0m3h+luJR+NZJ3AYRvSvY2QaAZlKI8Lb9
         HlEg==
X-Forwarded-Encrypted: i=1; AJvYcCXUya4yH7Rx7gpf7t5W7Betx/45WY46tdM8jAc+ZiUULipMdImKyG0M1pHn/yqiBft8+VZrM63hrkLmf66YmuN/3q8CHfsDasRcyaDUYA==
X-Gm-Message-State: AOJu0Yz+9HU3Nk2QfoaEK/VQETgHq3oSPzw0gS6tvMaCAbuegf7ywZrY
	cOBYg1jve214OTuNSdP8jgVwePTG5UCg7H9lXJRlNzyKv07eVca8wsM8126Lk8yefV9fjGyC061
	hSRXU3afdjmQ6rFYTvLs9rbPFp1Z1Io9TuLurKA==
X-Google-Smtp-Source: AGHT+IFDNKdwAfXSEycKXGnTTBABM6FmRmjjX+FTRFKdGLxumAJ8MD9QB4DFtL1S00LVOzY3IYZuvZA5viN2JMztKFM=
X-Received: by 2002:a17:906:365b:b0:a6f:1231:a8be with SMTP id
 a640c23a62f3a-a6f60dc17a0mr105055766b.53.1718349082972; Fri, 14 Jun 2024
 00:11:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <000000000000871190061acd8fed@google.com>
In-Reply-To: <000000000000871190061acd8fed@google.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 14 Jun 2024 09:11:11 +0200
Message-ID: <CAJfpegvhMX_CoZ80Rkva_GCrWAXY=McAphHh3DyHgiukRV3BBg@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] possible deadlock in ovl_copy_up_one
To: syzbot <syzbot+b778ac10fe2a0cd72517@syzkaller.appspotmail.com>
Cc: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

#syz dup: possible deadlock in ovl_copy_up_flags
