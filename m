Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D711F3B91
	for <linux-unionfs@vger.kernel.org>; Thu, 20 Feb 2025 11:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740050773; cv=none; b=GQgYyLRHaiIXY7+hIYhTthv9PV5DAFrgvwVfUEzi4gDftPbMrxzD0yfFafdz5RCZjCW/ulkN8ztCtNyuDAwkE3A9mt5UwLnDWAforyAIj3/1Z2OmHX71xIcj+ok7SyS1Ob9nCuMIlvILuTE/OzI6h6woLdsDI+n6o5/Rw4SqWSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740050773; c=relaxed/simple;
	bh=OqWxmG0X2zmiSbOcuJzgXWfv0gytiKlyeQYMLUwW7y4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ElBOLJpPO8slZ4oEnnnf1OAmzg5/JhW5DT7F8uPR4SL5QcRAWBTdj7N9mx/ZD6vpRslJnPQyDclpvUw/ttsm7CZZAiA8/QZnxscUPQ4lO0KG83yU3GMHYY8BBB450HBmKGTYdaYTIZVGt5Ud8sxHT2neyi1GlKx6LjJY7qKVSLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=e1JpUowz; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="e1JpUowz"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-472180fec01so4485041cf.0
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Feb 2025 03:26:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1740050770; x=1740655570; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7tn5uvF5vIdX/ny2QsORYRCD7GJpo0VnicZTBfCjVg8=;
        b=e1JpUowz6ZneVAZ6AIABhMO4+b/mrJDb6zvO2P0NBOTqgBLUWqienZOT/cNsHIFQXj
         /vcJOLCN3MItpPEZ3C9a9MZkEXJO2yIiTVZFGkMKiF/SLWgDvPQB3RxLERdO2sUdccNB
         tC+TJCQOZgQamyZ8t5l5upU9GVyee3otWlQHA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740050770; x=1740655570;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7tn5uvF5vIdX/ny2QsORYRCD7GJpo0VnicZTBfCjVg8=;
        b=Oo6v1ymXaVeiSpGyit60ewq2i4EaQnU1Hpw0ut1F3JjDD9qVw4JMf6xPvlfFtw95K+
         ykUn6rDrTBc/xKXIKGJQTmMrH3g5DQ1QRQXm4E2zX+X4I0RKJj1C1uYnhqoJHmdOnfDw
         WYM8D3wmHDwxwidIe/KsdCt/G+x7b3MDenp/qSo7ojD9Lq9XvC6hHt7qoNkGrzWH0ZLu
         QJWk78j6Ii8UUm+wDgUyHvd6b4C0hxVRHibSr3vlcvZlxAdnC1oyZ7ohVr8Xo8Y10mxo
         GFmcck1fNBRbcknIHRANggnojOCfM2F9NYXTNCGS0yNf989Jyhd6GxhfQV2xnwnsPfFX
         46DA==
X-Forwarded-Encrypted: i=1; AJvYcCURTL4S/W3BH79HUt/Jptjc6oRkWFFfU/g9ZowhNNhOra/WS1axcUEUVvYIq4pLMBfRTwxOuoVPZKCQvuQu@vger.kernel.org
X-Gm-Message-State: AOJu0Yxm5ZmX8RWilzhNMHColbntWLP0YtTN2w/F3f8qDsFTEO7Ph33O
	bE8BXpG7fvVXNAdRQGYtp4hJKmBjsPtd54qWaVsYq3dbuYv49ZumkN07cYRw+789gxZNDq7blOK
	/WX8/gGTQ9SlSyma1rr1uxKBXvr7STT1ZNGbpUw==
X-Gm-Gg: ASbGncv5NggxcCuIwBHj658x2fZwsk6WB4G/qHwuPovcz4Ia4LrcM+czGNCna96Dpwp
	ICk23dmtwiNbCiQq6L4mBdBWLwAq1k6KNFcav4F6KbFXrDmOGrdw6M1I85qkmNMP2KKYeLxQ=
X-Google-Smtp-Source: AGHT+IHvF6P4aO6ZDtZuWoXIRLKg2tXeGKPFOi4EbMc0JgwnaGVhObtiauHCdZFsgHzhxb8pMe5HIloumJ53UZj0Xag=
X-Received: by 2002:a05:622a:1a93:b0:471:c03d:cd6c with SMTP id
 d75a77b69052e-4720824ebb9mr100995291cf.19.1740050770314; Thu, 20 Feb 2025
 03:26:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250210194512.417339-1-mszeredi@redhat.com> <20250210194512.417339-3-mszeredi@redhat.com>
 <CAOQ4uxiqis6kawuv4pa6jxHYgpQPc18izFP8e0TORfA_mVu_-w@mail.gmail.com>
 <CAJfpegt=PWs8ZDF11p3nOCWHbWescE5nwVtUt82f=B6B+S0Miw@mail.gmail.com>
 <CAOQ4uxiQQV_O1MJgTksKycBjJ6Bneqc=CQbUoghvXc=8KEEsMg@mail.gmail.com>
 <CAJfpegsuN+C4YiA9PAuY3+-BJ959aSAaXTYBwKNCjEnhXVw0pg@mail.gmail.com>
 <CAOQ4uxjkBQP=x6+2YPYw4pCfaNy0=x48McLCMPJdEJYEb85f-A@mail.gmail.com>
 <CAJfpegvUdaCeBcPPc_Qe6vK4ELz7NXWCxuDcVHLpbzZJazXsqA@mail.gmail.com> <87a5ahdjrd.fsf@redhat.com>
In-Reply-To: <87a5ahdjrd.fsf@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 20 Feb 2025 12:25:59 +0100
X-Gm-Features: AWEUYZlvOFaY4Lb7C5iOdE8ZcCG0ff_5CqjAz6UfL79twoY1TEll-kecVyj_OgU
Message-ID: <CAJfpeguv2+bRiatynX2wzJTjWpUYY5AS897-Tc4EBZZXq976qQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] ovl: make redirect/metacopy rejection consistent
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 20 Feb 2025 at 10:54, Giuseppe Scrivano <gscrivan@redhat.com> wrote:
>
> Miklos Szeredi <miklos@szeredi.hu> writes:
>
> > On Tue, 11 Feb 2025 at 16:52, Amir Goldstein <amir73il@gmail.com> wrote:

> >> The short version - for lazy data lookup we store the lowerdata
> >> redirect absolute path in the ovl entry stack, but we do not store
> >> the verity digest, we just store OVL_HAS_DIGEST inode flag if there
> >> is a digest in metacopy xattr.
> >>
> >> If we store the digest from lookup time in ovl entry stack, your changes
> >> may be easier.
> >
> > Sorry, I can't wrap my head around this issue.  Cc-ing Giuseppe.

Giuseppe, can you describe what should happen when verity is enabled
and a file on a composefs setup is copied up?

> >> Right. So I guess we only need to disallow uppermetacopy from
> >> index when metacoy=off.
>
> is that be safe from a user namespace?

You mean disallowing uppermetacopy?  It's obviously safer than allowing it, no?

Thanks,
Miklos
