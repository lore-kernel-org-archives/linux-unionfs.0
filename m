Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3547213A404
	for <linux-unionfs@vger.kernel.org>; Mon, 27 May 2024 09:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716802397; cv=none; b=Kye+AbzAyVPXEfQ/wtv6z9spklUYMd63+nKaFgVeFL/3t8phbQ9AYbNprSyWNCk2nurnfQYO+jvjUpFRmkHlhlmDLA/vhBwclBn0yjTE6BFd+M9FHNJqrGAve2f++t2GuIwQAGcJ5zoBsHBVce8yi4qbL+69huJdGN52GMfK+qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716802397; c=relaxed/simple;
	bh=Tj542Ql3NJjfsqzKkHdQSa2YLnrfQwlEirm8q8wFYEE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fF85hYC1OS18cV5mM8bnPciy08nJKzhzJQeuGkff5RTCMZEoxBOIAKtMYK3ZCgz7A6GmQ2fj8e9S45ce4RfPEyZQ7dfIcXBto/VTxPtkwiQDsUcvELV4S97t8SaG8RNi2C82OMLCann6oATKm345lEPUnXYf49/rgjWW6fM/9QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=UWXDMtyd; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="UWXDMtyd"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-529614b8c29so4524158e87.2
        for <linux-unionfs@vger.kernel.org>; Mon, 27 May 2024 02:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1716802393; x=1717407193; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kyqsMalQEV+9l0Conlo3kxuFIzX2TPTLRyUlJoVzZhE=;
        b=UWXDMtydM3KmhAobcJxrDXLIBvaOkx8VT4IBboAfv/LLFbEcvqIZq1ok+vNsyOHPFB
         H+OkaLHEy57JMz2OvdwyHwZNnGImY3+8/9tu1G9o59omWSSIl4HuegAHA9sit+CZZQtf
         C/y6AuBzR9gB8nf8XFe6h1ir3ljzcRqjOzt0o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716802393; x=1717407193;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kyqsMalQEV+9l0Conlo3kxuFIzX2TPTLRyUlJoVzZhE=;
        b=axxEOg9hIuljUK1y6pDx98L2WoEms2uVasDvqpzuMgS0vXsfdo2Lc5qHUJbnkd8iDR
         Th6yM61FKi18ziFXwv38c5LUfIBMZGOSxUFk81Cg2RgI3pFFYK/tAzoHUcEM2GPnAX+Y
         yzNtm0OA5zSfGXeBvabuMjdmgq5JgoARUSm9O1Jro66NiS/rq6kS4rQXS5qzTCm3igj5
         iPhy1qiDiV+DWwHu1A/kMStFsWEAFyvIUfssahE0NxfCtMhGjrcTRa2zQ3do44u4Mr+p
         JR3PAAAeyo8wUsQATaT2WC2LiggWG2Azz3dR2y6sAwjIOV9INLA4yL/1pfKs2kkj0/7b
         +D/g==
X-Forwarded-Encrypted: i=1; AJvYcCUU7lyH87W/QCqpvwiwq4tI8Zp2itlYD0/bsni320FF42V1poMjq83tY0iFgSzIqx4HgKZHrIIIfTiXddiCBuBNMcqo7AkfzVhH3W3bRA==
X-Gm-Message-State: AOJu0YyZ/IpQfF9A10WjoCJK4wFiwmnFZJm5Cw0svhpxG430eQm25iQm
	kC5/0q51ot2gUvK97Fw87hRvWquc3CMkZ0KSauMvxxs5mqk0xbWfqgtOEbASsKfZ/gaZF44uZFo
	iYeK/UFTGB+0D9Zz6rvjRdCokWUwCK5zvMwtPeA==
X-Google-Smtp-Source: AGHT+IEi8JlRPopO8DJkGromiP7EPtR3oTQlYMDIwWpliTsfbENXpGmoToZgmtMb2h5j7tLDJVTyjz3Cs8MdoaCtfhs=
X-Received: by 2002:a05:6512:acc:b0:523:97bc:ea88 with SMTP id
 2adb3069b0e04-5296736b9d8mr8970330e87.51.1716802393007; Mon, 27 May 2024
 02:33:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <000000000000abc6c5061969e3a5@google.com>
In-Reply-To: <000000000000abc6c5061969e3a5@google.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 27 May 2024 11:33:01 +0200
Message-ID: <CAJfpegutd_duD=jFoFFG1GY4pvmBOSBmiO6A1uGXJj8_3vxYWg@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] possible deadlock in seq_read_iter (4)
To: syzbot <syzbot+fcdd1f09adf0e00f70b1@syzkaller.appspotmail.com>
Cc: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

#syz dup  possible deadlock in kernfs_seq_start
