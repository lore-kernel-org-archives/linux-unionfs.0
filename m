Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21E316C6A9
	for <linux-unionfs@vger.kernel.org>; Tue, 28 May 2024 11:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716896094; cv=none; b=tCznQlp7cmnvTGCvUsS8EZpIO0hfj7IAJ94h5k6NAuM21AWGW4mDIyc3jIe8aSiC3FXSG/BYX6+oVqAMywE8AoFdaUic2TQTzy/tV9nmcEsNjB0JLHzpEPnALm9K+ZmfpwQifHq6CsyhTOBaYajzUKZGJVDgYYFAXK7xsodFBAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716896094; c=relaxed/simple;
	bh=+IMT3oy+khlYOhfCmWyNhQu6C7RsA6PV8KydIqIUvwc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eQp9jRdKAzzYmkcCwiHb+uGFGnGayeQB1DoTCW623YLklq/Fcd7RNLH2mTSHLfTdlqD1nMn4lvHGlo1b/39KaGJKRWo1efC4ZOk/wNvPMFADXDF/4fRjw5PVhGPtx8eI3OGPeVWHtufzIFvthh+EVeFIUbEpuRPHVpVwkxZ2XSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=TD805cA3; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="TD805cA3"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a62db0c8c9cso76541766b.2
        for <linux-unionfs@vger.kernel.org>; Tue, 28 May 2024 04:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1716896091; x=1717500891; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gCYy2jNdMvPKnrla2fb3ATkGYJ/zA04/i1mAIeXjKzc=;
        b=TD805cA3bLFGReKmdr234oIEKph6/DdatMH4DKpWvJLHl3kawij+HbyrdaTf8/0sXR
         a7pdyteJ78Kv0NWk3Ocw2O/qh9dyjGkKlYwYqckakmQsP40Wx5LIHNhWeEDYGuVX+vTG
         kEAgB1w8+SzdrGnbTj4khSE8Em8mfw/9JRjLc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716896091; x=1717500891;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gCYy2jNdMvPKnrla2fb3ATkGYJ/zA04/i1mAIeXjKzc=;
        b=ptacEeK8wx2RtgpUXDxSn7BpgsfqyjcUP5fNPSvKQ4g+SGdWG8YLIUELXhsw5/1lJc
         v9HBJEauhqtM6f9TG+5ReIF2WF1jJmmUkb4vxVLfzqbnw73oM38l3jtkz483nGohT9Ei
         JKtntBxC/L2u4wmMtJP04NAgmKQpweELxCVJOltr3qWha2+RMi6HjeGcBddEB6g/wS0w
         dFsltS/1bKySBBz5zQQm4FnInE6z4Zz3y0Yx4qsu+L2d2HWeb92wpMMbd9sU6SPl2llK
         w7jCsfk4f9ia4V0Bq4bl/looAyTmCp7phMnaoV2vYcX0toIimSechToCtsn+1atL58LI
         LKPQ==
X-Gm-Message-State: AOJu0YzrSzKUlKdlLvJn/KOtJQxN994XC/ByeGhXDAQG443ZwLdT+sym
	/M8AdU9iRQlqhyKozcUxDK2jxl/IlqSNEskL/xyJrAGCnnhcTHkeUBdaJBVuz5/B+D0xVQZnbE+
	z4aLXMn7qe5cfVWKOwZ97JmGagLqvvPdyQvhE8w==
X-Google-Smtp-Source: AGHT+IGP0vupvmTEOhqz2XuFH7Xabl9E14maGrlpUyg/Yb+OW5T6+fzLgVYg8L0m3R5bOawhe95Bdf1O9P+7aH0yig8=
X-Received: by 2002:a17:907:7ea1:b0:a62:fcf7:8927 with SMTP id
 a640c23a62f3a-a62fcf78a7cmr719752966b.56.1716896091199; Tue, 28 May 2024
 04:34:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240528090244.6746-1-ecurtin@redhat.com> <CAJfpegvoao1jd7HhoPEeWCdS8jWEXhKTENbwvLdo=aMiNaLKQQ@mail.gmail.com>
 <CAOgh=FyHFE7qjfYq4BqGc20SYJ5FebhN2iYpJSsYYatO1TkqBw@mail.gmail.com>
In-Reply-To: <CAOgh=FyHFE7qjfYq4BqGc20SYJ5FebhN2iYpJSsYYatO1TkqBw@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 28 May 2024 13:34:39 +0200
Message-ID: <CAJfpegu+z2Nxvk2H9vfZ3nfzEEixUG4kEthVGHWUYw0wX5bgMg@mail.gmail.com>
Subject: Re: [PATCH] ovl: change error message to info for empty lowerdir
To: Eric Curtin <ecurtin@redhat.com>
Cc: "open list:OVERLAY FILESYSTEM" <linux-unionfs@vger.kernel.org>, Alexander Larsson <alexl@redhat.com>, 
	Wei Wang <weiwang@redhat.com>, Amir Goldstein <amir73il@gmail.com>, 
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 28 May 2024 at 12:55, Eric Curtin <ecurtin@redhat.com> wrote:
>
> On Tue, 28 May 2024 at 11:34, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Tue, 28 May 2024 at 11:03, Eric Curtin <ecurtin@redhat.com> wrote:
> > >
> > > In some deployments, an empty lowerdir is not considered an error.
> >
> > I don't think this can be triggered in upstream kernel and can be
> > removed completely.
>
> True... Just switched to Fedora Rawhide and instead we just see this one:
>
> pr_err("cannot append lower layer");
>
> >
> > Or do you have a reproducer?
>
> Run one of these vms:
>
> https://github.com/osbuild/bootc-image-builder

Apparently it is using the legacy lowerdir append mode
"lowerdir=:foo".  This works only on 6.5.

In 6.6 and later the same can be achieved with "lowerdir+=foo".

It's strange that there are not side effects other then the error message.

Thanks,
Miklos
