Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DAA3B7A0
	for <linux-unionfs@vger.kernel.org>; Fri, 19 Apr 2024 07:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713510196; cv=none; b=dBnAbF+TeRUTN+aIQqtIu/1F3H71EiH2YE6HuuEIKnMArQgcMjn76F8I+XPOmwTgpH1nVwmZeT1+njRorPLEaj4HGfnhvx2zCXDhA9fpuhRAm5XhFMLgjGJbvmuTQFIzWKoHZsZrolhdPO7Ryfln3zfdOPy90FiVyFben5amgaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713510196; c=relaxed/simple;
	bh=1KrvB4xP70N8g9WohZTwaHNc8WTwZCpkVPlckvQf3UQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HtGHAbFvGg2j/RypuJOEKBpgrBMMXqhIGZvekysPJc83KSAACXlJqYkDcsIvXUDoh/WWEDs7My8y+6UL/aV/gLfPFJ6BZEPkbO7r3Vh7F4YP53paCQGdEzho99t6StGwF9EbGLw2rDDD6bxzNTulFGq3bdY2eluHqfkBm4aO6Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=QRuMp+In; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="QRuMp+In"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-571d8607163so63823a12.3
        for <linux-unionfs@vger.kernel.org>; Fri, 19 Apr 2024 00:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1713510192; x=1714114992; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1KrvB4xP70N8g9WohZTwaHNc8WTwZCpkVPlckvQf3UQ=;
        b=QRuMp+InEmSVlRLbshacp9Vb2Tz4uWaPjwi+g54DcyYLbjwVZR5NjNSRvhC+Mq56Lm
         RSfX0P7cg3j4t358ZI0hjCN5csrzAzZFUk2Urb4lQolkXIHlHGwC8cnEdwwmSfMWspXW
         owoKFFfxPJfjQ/iuKWVR7qgKwiniGS2NHsqYo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713510192; x=1714114992;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1KrvB4xP70N8g9WohZTwaHNc8WTwZCpkVPlckvQf3UQ=;
        b=sA8EFWDNiaVA7bN7FRrd43Kq6ZzqYA1vwDKDjnrP0boUbMdCY3g0viNfPznTqUzMA5
         FxxyT1aB5WEZlAFozSmjwMra+psA2DGvms9UoF4Ay+2d067nqZ0WpJcME0iV4I9y/SlV
         E5pSQ1dDhUvQtFcmxmAbMmCVsJ2fBm2CF8EFFApx91Mjnt/VHo0/R++6WZ9k3WGdaAwj
         XYIVPTnQHyZ0aZQNx/v7vxSHDy+YBmWC2nu89cjF3zSBnXOtqCi5eZV3C370oTEcLpxv
         qgLqL9a48TPDm1abSTkAFd9jp4xrDOIjg//PucodGb0EBslELwsMZhwajkm4mjIWScnE
         A2mA==
X-Forwarded-Encrypted: i=1; AJvYcCUNPy47iQ+7ljXxmeQhkyJp5SsH9tn7V5SyYVAhMTP7uGc7bdvbNCwp3hsQj1oAbi448QdR7OepKmCTb03OMN9T5GfvzfIdZldIVqu5jg==
X-Gm-Message-State: AOJu0YyOpOQIsmaP76VFJ3VSwcbRb05I5Rxruuy0mVh5kDEOh+nPvE8B
	2wIW2YxozLw0beK+fV7GJ70HQyJxNQTYPk4yp5cQBuhifrpf3OiGc/kTB0jEiafIqWH1dWZeo7S
	XKiDyJAuTPtlXiJ5bN2iXM1PjK76xRKyHtEktZQ==
X-Google-Smtp-Source: AGHT+IH3tRDQTulqCGMpfmCAFTFNH+od70SwwdrUrSA6qQtwCH3uw4FkqvfBp0PHrarTrt0l/Vxtc1TP3mMpHSe8yDo=
X-Received: by 2002:a17:906:298a:b0:a51:98df:f664 with SMTP id
 x10-20020a170906298a00b00a5198dff664mr784164eje.76.1713510191793; Fri, 19 Apr
 2024 00:03:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0000000000002615fd06166c7b16@google.com>
In-Reply-To: <0000000000002615fd06166c7b16@google.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 19 Apr 2024 09:03:00 +0200
Message-ID: <CAJfpegutFNPRU+L0XAyryRETL9_qbcKj7ARBuTzgR4tnK8sOiQ@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] possible deadlock in ovl_nlink_start
To: syzbot <syzbot+5ad5425056304cbce654@syzkaller.appspotmail.com>
Cc: amir73il@gmail.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

#syz dup: possible deadlock in kernfs_fop_llseek
