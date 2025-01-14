Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8019A15C15C
	for <linux-unionfs@vger.kernel.org>; Tue, 14 Jan 2025 16:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736871801; cv=none; b=qQWg/x2NbJKqon5Y19OO/OXeLLdZrzcq38gY1rG0AtUiaOnjVfu0BO/pROQYiUREfq8Kf/GCWoMxRyFm6JLdCPxw0PCkDk8Y+nrqyjChi7SntV/W3JQxfsBpY5oemOwSfHEL5ZAyd/UHuQ1E5jAqmUuXMpWpR5t+JQp24fRJz84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736871801; c=relaxed/simple;
	bh=/L9TBX0CQQ8SuXNxpOomB7eGii4794qEyB0dEBPxVtE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SfWR13h6wAWbJWmDVV7uYBLkK/XJJh9LTPt5NQTSRVvjzN801TUWyKArWFCl/Pdxy+L6JprQAmKw8vfrKxTJov4a+YqA9zT4fNaZ7w5NijPRaqaWWtP9RaEnc55YGVEHS/HHjzE90OVYdHl9bKFWp+0glAanh06VSf+vsp9D3gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=QPEPjwmx; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="QPEPjwmx"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-46b1d40ac6bso45032701cf.0
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jan 2025 08:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1736871798; x=1737476598; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rFn73jXMvA2FyDXCU06fe8ifMIIvo/f4kYn2Q+exZQI=;
        b=QPEPjwmxUt7hunPstyDvh5yZ3OwpkSkoMTo2FzoG09nY/b7U6CjWkp/OR9kWUvggQq
         7WGBOqvbAE603suIyrU6tc1OTkcz/gE+5A9FEC/jcwbauGrRTcKEBHT0pdMiT/C3VCM3
         sPcx/XxjE5EisTvHtTPGt5vHta0vpZ2uLcAiE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736871798; x=1737476598;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rFn73jXMvA2FyDXCU06fe8ifMIIvo/f4kYn2Q+exZQI=;
        b=ezHZ3BUA6vDI7q7uTSzqg5cZ8Vi2vI5xwtypbh0BwXsv+wKv7Zbnl1ncvO8oB3KdgY
         ZBoWPUfKmNJoRZgsLQJC2VGpr3/PM9xv4LuhWQQj/AEBnWoank1AbCMlmOAt9TxVmEa1
         B9UwNzcj3wzt59uYImMHMuZhO1irXXxaEw0okaY7eTMSOM44GaiLTI87h5YSakjeXFDY
         wdpnO6pk5HE9M8JDmzSiPN4DanJFw2VZc75qtPDzOmKXNQgsNoR5yHAyatw1E4yyUmTP
         M7dEcT8v9fZBJKTZ8EFEmDxQ19SGjuYW023JcpKBnamAoNqD3CEHWGutAsBTk6gK7GDP
         06yA==
X-Forwarded-Encrypted: i=1; AJvYcCVH6Sv5gJPZTlSL3O78L7SbYl2sBC6cEiEZsESJk3jQlTLcg23FReyRvJLxGDDkC6eBReybOrCQxACbrR0I@vger.kernel.org
X-Gm-Message-State: AOJu0YwRk0lImgKQiGVXxx2Hr2NtsjieefKyddnrtkApHv3kwQboSu+v
	RCpVgplR13voPY9aeiEWkfguiEU3runU8uTcobJ20xj/y2uTpEOzmLNZlSrB3AqTClNkpzK34uL
	nlzsLV7gJ57cA7R1p1SrkNuX96WiZJcbyKoXctfL66DQQT6uJVJg=
X-Gm-Gg: ASbGncvnCT6vzqXor4299WrtPNaD4ONPUh2hZyNP8N2q3VCVO3Jss09yh8yrDBmAe81
	BW5LRO1uNwndUcHyKmBRziFly1lQscUm5Cncy
X-Google-Smtp-Source: AGHT+IG2PivUfHYgTsDBqn1iPwHDv0NJqIEkWtIUjp/OGAoL2qJZ4UdDmQziYocafBo+D9zb1JAwFG0Pm8OI0kxsMOQ=
X-Received: by 2002:a05:622a:610e:b0:467:5e69:2e1e with SMTP id
 d75a77b69052e-46c7b0854dfmr338633901cf.26.1736871798467; Tue, 14 Jan 2025
 08:23:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <111000.1736867714@warthog.procyon.org.uk> <CAJfpegsUbvMB_tFbV283_JmK+wzFAECaLZgYAbmcBbBxWX=Ctw@mail.gmail.com>
 <112184.1736870193@warthog.procyon.org.uk>
In-Reply-To: <112184.1736870193@warthog.procyon.org.uk>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 14 Jan 2025 17:23:07 +0100
X-Gm-Features: AbW1kvYv_NTZjOr1FC8p1RGSD4OgnXWInmr9jPbz_bAAonKQqfyIX5I91jeTaCg
Message-ID: <CAJfpegsVd3MyHBuGXApbwY3pYz5H2+2Xxm3O8FrJgboi2S5CWw@mail.gmail.com>
Subject: Re: How to support directory opacity in a filesystem for overlayfs to use?
To: David Howells <dhowells@redhat.com>
Cc: mszeredi@redhat.com, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 14 Jan 2025 at 16:56, David Howells <dhowells@redhat.com> wrote:
>
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> > On Tue, 14 Jan 2025 at 16:15, David Howells <dhowells@redhat.com> wrote:
> >
> > > What's the best way for a network filesystem to make a native
> > > directory-is-opaque flag available to the system?  Is it best to catch
> > > setxattr/getxattr/removexattr("overlay.opaque") and translate these into the
> > > RPCs to wrangle the flag?
> >
> > I don't know.  Out of curiosity, which filesystem is it?
>
> One of the varieties of AFS.  Unfortunately, xattrs aren't a thing and can't
> easily be added because of the volume transfer and backup protocols and
> formats.
>
> > There's "trusted.overlay.opaque" and "user.overlay.opaque" and are
> > used in different scenarios.   There was also talk of making the
> > "trusted." namespace nest inside user namespaces, but apparently it's
> > not so important.
> >
> > Which one would you like to emulate?
>
> Um - I don't know the difference to answer that question.

"trusted." needs CAP_SYS_ADMIN in the init user ns, while "user."
needs write access on the object, which for an overlayfs mount in a
user namespace practically means CAP_DAC_OVERRIDE in the user ns.

So for plain, privileged overlayfs you'd want to implement
"trusted.overlay.opaque".  I don't have a better idea, than to add the
xattr callbacks to the filesystem and return -EOPNOTSUPP for
everything else.

Thanks,
Miklos
