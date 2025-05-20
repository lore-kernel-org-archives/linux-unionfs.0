Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B63226F473
	for <linux-unionfs@vger.kernel.org>; Tue, 20 May 2025 16:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747759249; cv=none; b=aKMwtXs14iBWwL4dmiuymhu5gGol1ziw6Zo0qZZqlebFHUNm6RwddO7WGVaq23kAu52c3plh91Tp7s4lWROLgcmiOxdeEg+3u9M1ctT1aojq4gxPzky6bLFenZhBLufBnFKX/9936T5wsHodtFfaHTkZh+0ipnDGJMrjMHh1Cqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747759249; c=relaxed/simple;
	bh=Fe3SQr1Tgdxaicu5cMlLYaBvQLQauJdBDwx6I3UeaTA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FI4hXDeh9+d12h/rXUozn02Y9WeG/LSViX1Fj9Rf828A6ybrgPiBeAhFyc+Tk7JXXUUrhYm9X54+4tfDe+TbJ9wvPiZ47zu90uZ3BHKtzhsh4jQ2WD+SSbtHgs/h8XLb2iNryrJUndyRQBp+P1sCqnBTcu/VQbBxTnZVWgu8Y84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=NPIHoEP8; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="NPIHoEP8"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4772f48f516so73746451cf.1
        for <linux-unionfs@vger.kernel.org>; Tue, 20 May 2025 09:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1747759246; x=1748364046; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Fe3SQr1Tgdxaicu5cMlLYaBvQLQauJdBDwx6I3UeaTA=;
        b=NPIHoEP8I0v4jVfOFQgeBnsfO2dMGrxStkdVOCjql1tFy997FZrjPtZb5Yel48sVqW
         WbtjdNXvtydcwO7tXDbARo4XUWmNMiEqBytQjx62bN5eP5aRkreHA4kNMWqQQY2d+1E9
         n4uNwrcI1sbC/jf++m+/Q8oQJ+LsYKRWJWEqk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747759246; x=1748364046;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fe3SQr1Tgdxaicu5cMlLYaBvQLQauJdBDwx6I3UeaTA=;
        b=iI/so0Lx0Z6Jt8F/3lNZY/1ENuZq5UgyKgOfdINigZil7u0va6KQj4M/gXoeIAJzFr
         wFHtGW0wK0efZc8nzU8uLmgEZpZgQZCC3dlwlRtbYVDh0ewmLtByemmpitpptFw4unnH
         NJsNFi232bgGdp3s00P5qZ67AeF8eEfldur9/97FMjw9xRx4qrg5g7nOwiiGGHsAXHyp
         DDBywFns9QXp8WbJjJke4lRv5teJq++9MCGSBTJnI3zCEIugqA68r/BQzWNzz9kXQyIq
         MIyOqByEHx9Ic6xEIgdDkkGzb3CsMkrkJcaP32lvUmAxOUijO4z6QyvrOSUdhuqXmTm6
         +n0Q==
X-Forwarded-Encrypted: i=1; AJvYcCW6wE+f7m+dyo/iQ3BQH6MMbj2fpcb+0qv3DCr8aO7TiySZHlLuIhTGrQ+Q/lPL29qJPX3Uc+DJ+z9vxyvV@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+iBIb+hYbM1aSWSX8Y5Twg7tJVCCbqrghAbkafz4OSUnbrfuL
	sMNm6cpg5jow6XgGM41UVdrjACKCYrd2krE6Mtkx3VZ77cR0FAK5JxfPfSjGgHX8v3b+X29ETJo
	4AP2HZDaYOFEQEvZaIKI3MX2Rgzw4LpQZxPpIYHxS8A==
X-Gm-Gg: ASbGnctE6Qgo9q2fBB89mikmeqvU7L2HSYsEuY8txyJAuGTBYRn/U0G/iwWA67o0oNx
	HOHBiEp4SBAUpfgyh5rgvhTdWA901qK9GXGhHWxlguSB7L4iKfsc5w26VUcR2wn+O0/MOGf82kf
	/9DwAuQpD/0xp+e5sl5YTXic24DeEF344MXlXBYs2+kNv9nA==
X-Google-Smtp-Source: AGHT+IGTCe96EYzLfgh7qgkaiolx8qzDK1c7n7H14UCJuDGekDjcM0Kg4qSMxoWF61rkkDgWe1ioI2e3TjQwy9nHcEs=
X-Received: by 2002:a05:622a:6118:b0:494:a7b8:d63c with SMTP id
 d75a77b69052e-494ae314548mr330690061cf.0.1747759246134; Tue, 20 May 2025
 09:40:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250520051600.1903319-1-kent.overstreet@linux.dev>
 <CAOQ4uxg8p2Kg0BKrU4NSUzLVVLWcW=vLaw4kJkVR1Q-LyRbRXA@mail.gmail.com>
 <osbsqlzkc4zttz4gxa25exm5bhqog3tpyirsezcbcdesaucd7g@4sltqny4ybnz>
 <CAOQ4uxjUC=1MinjDCOfY5t89N3ga6msLmpVXL1p23qdQax6fSg@mail.gmail.com>
 <gdvg6zswvq4zjzo6vntggoacrgxxh33zmejo72yusp7aqkqzic@kaibexik7lvh>
 <CAOQ4uxg9sKC_8PLARkN6aB3E_U62_S3kfnBuRbAvho9BNzGAsQ@mail.gmail.com>
 <rkbkjp7xvefmtutkwtltyd6xch2pbw47x5czx6ctldemus2bvj@2ukfdmtfjjbw>
 <CAOQ4uxgOM83u1SOd4zxpDmWFsGvrgqErKRwea=85_drpF6WESA@mail.gmail.com>
 <7sa3ouxmocenlbh3r3asraedbbr6svljroyml3dpcoerhamwmy@gb32bhm4jqvh>
 <CAOQ4uxjHiorTwddK98mb60VOY8zNqnyWvW=+Uz-Sn6-Sm3PUfQ@mail.gmail.com> <ztuodbbng5rgwft2wtmrbugwo3v5zgrseykhlv5w4aqysgnd6b@ef56vn7iwamn>
In-Reply-To: <ztuodbbng5rgwft2wtmrbugwo3v5zgrseykhlv5w4aqysgnd6b@ef56vn7iwamn>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 20 May 2025 18:40:35 +0200
X-Gm-Features: AX0GCFtCQXc8dfOCmu22fg-gXqXE1YObKOZAbGs4WfDGBDzTD5kto0juBR50CeE
Message-ID: <CAJfpegs1AVJuh1U97cpTx14KcnQeO2XmtvrOwbyoZ8wvqfgqPA@mail.gmail.com>
Subject: Re: [PATCH 0/6] overlayfs + casefolding
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"

On Tue, 20 May 2025 at 17:21, Kent Overstreet <kent.overstreet@linux.dev> wrote:

> Docker mounts the image, but then everything explodes when you try to
> use it with what look to the user like impenetrable IO errors.
>
> That's a bad day for someone, or more likely a lot of someones.

Wouldn't it be docker's responsibility to know that that won't work
with overlayfs?

Any error, whether at startup or during operation is not something the
user will like.

What am I missing?

Thanks,
Miklos
