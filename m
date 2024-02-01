Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C41515AADD
	for <linux-unionfs@vger.kernel.org>; Thu,  1 Feb 2024 09:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706779696; cv=none; b=Ifcy4a4jbm/RLZhw8L1pDydmd8WlKV0tXNsvSjD1ZJZLRASGWw4slEGgPDeDa367ZnLQQITjSMbmhgKv178n7k7JuJt621SnTT9tqBo7rGuu1uV6D4L6gopKPwCdIc1O/i/yLXWczf6BY6fZMJkM2phKxjEc2101BZ1KA+Qs+qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706779696; c=relaxed/simple;
	bh=uQpjHn/k8LhRaWfdodt0dBqKXXzAvGqKt+BKjv1aSl8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ahk7lAO94uaEmUuoEVlZIizwZj9uXhh22mcrR1La2YHBMqDFqmQUO1dh5N6OZO/ixGb9ds0fQ0ZP8+EnsRq1+Vz+6b1RPH0WrclXtyxmYhF95xVZYA9Z/je5Fh9ffX6UZU1TkE2qq93Inuiq0JQZkq1D0JEzR7Ow+AaEixlcNVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=k+UjBpU6; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="k+UjBpU6"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a2d7e2e7fe0so118039766b.1
        for <linux-unionfs@vger.kernel.org>; Thu, 01 Feb 2024 01:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1706779692; x=1707384492; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AomKnOYIuoieQS/ihA4cKdwcwSZOo5BeW4PVPnqVgY8=;
        b=k+UjBpU6FBRZ77naIQ9QlzK080lbPUzBeX3fBH7nGZdcWDtxXYAVIxfPVPD8HtSJ2f
         00HCCpXJkOpVzZ1dAo5LlVfFrg4idFmjRYMAB8Rgps4+vdZ/0iDub5/GonlfOL5xIbp7
         exCMREjCI1+LDBgNjha+6A3tikaLqcKHJqUpQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706779692; x=1707384492;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AomKnOYIuoieQS/ihA4cKdwcwSZOo5BeW4PVPnqVgY8=;
        b=eOFOaTKhuhKY7/nOYm/6cVQd4dxi9hMtq8NXKEJNnsVXLjB3aJ4WTgG8szJsdAT8UB
         0quE09+Y+E/yZnIsDYPVKnMuz/w6CdLRLEy3HsmdUZLrjxKJog3OfJntLAFhjIkhTWa3
         dNKIgfPnB2F3JbiHqBCnl15UhOJF0VztEo5sA/AKgULyvP+4pU5CRUhcjkHcMrSwD+0P
         wWFXzq0HX5eJEQps1ZKJYW/C1grmPyf/zzA1Ob8F/0Xrpo/o4Rnli77Ptpi6awsIqP7v
         vkvD4NAr3MJ5VFU7rrWBrX+wWcV4+ef4M1ZgChqexBtRO8GUwzyKiql03ghxRaLOJM3l
         qAHg==
X-Gm-Message-State: AOJu0YwsD4h9dCeEVw0nq86bGuf3LooCIUfukd9yiW+4xMP2R1irjx78
	xI5z2pmuaD4kT09YdL2UALkCURcKwQRUIIs3SL4rJu6lUMINDjg/Hof30eBcERHmPFtw2aJmcaZ
	75cWKkbm34Qz9aOtlcKaGqBZ0gKFG3SFtngIf0aeVNx3D271I
X-Google-Smtp-Source: AGHT+IEamRgeJz3jGdb2eDDc4tN5r+rp6qV8ZOXHbn3Ij+XsYl9jubtmuM0adIZ95h2nHr6nkj9LK6dgPbqAO0/qnW0=
X-Received: by 2002:a17:906:c12:b0:a36:3cd0:232a with SMTP id
 s18-20020a1709060c1200b00a363cd0232amr5368561ejf.21.1706779692674; Thu, 01
 Feb 2024 01:28:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <VI1PR08MB31011DF4722B9E720A251892827C2@VI1PR08MB3101.eurprd08.prod.outlook.com>
 <CAJfpegvBc+Md51ubYv9iDnST+Xps9P=g51NcWJONKy4fq=O8+Q@mail.gmail.com>
 <VI1PR08MB3101A133BDF889B35F14D28882432@VI1PR08MB3101.eurprd08.prod.outlook.com>
 <CAJfpegup8_Xm7rqbNgbxoZ0+5KnrJiiR05KLO3W4=mmQaRi+qg@mail.gmail.com> <VI1PR08MB3101AA24E1406DBCA133DC7782432@VI1PR08MB3101.eurprd08.prod.outlook.com>
In-Reply-To: <VI1PR08MB3101AA24E1406DBCA133DC7782432@VI1PR08MB3101.eurprd08.prod.outlook.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 1 Feb 2024 10:28:01 +0100
Message-ID: <CAJfpegv+jknMnAAYKnZvemvjqi26X59HRRg7-JhDYVFe4MG93Q@mail.gmail.com>
Subject: Re: [overlay] [fuse] Potential bug with large file support for FUSE
 based lowerdir
To: Lukasz Okraszewski <Lukasz.Okraszewski@arm.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	Matthew Clarkson <Matthew.Clarkson@arm.com>, Brandon Jones <Brandon.Jones@arm.com>, nd <nd@arm.com>, 
	overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 1 Feb 2024 at 10:24, Lukasz Okraszewski
<Lukasz.Okraszewski@arm.com> wrote:
>
>
> <miklos@szeredi.hu> wrote:
> > On Thu, 1 Feb 2024 at 09:01, Lukasz Okraszewski
> > <Lukasz.Okraszewski@arm.com> wrote:
> > >
> > > > So this is a FUSE_IOCTL/FS_IOC_GETFLAGS request for which the server
> > > > replies with EOVERFLOW.  This looks like a server issue, but it would
> > > > be good to see the logs and/or strace related to this particular
> > > > request.
> > > >
> > > > Thanks,
> > > > Miklos
> > >
> > > Thanks for having a look!
> > >
> > > I have attached the logs. I am running two lower dirs but I don't think it should matter.
> > > For clarify the steps were:
> >
> > What kernel are you running?
> >
> > uname -r
>
> On this current machine it's pretty old: 5.15.0-89-generic (Ubuntu Jammy).
> We have seen this on Arch with 6.6.12-1-lts, if you give me some time I can set up the repro on that again and get the logs if that's helpful.

Please try on a recent vanilla kernel as distro kernels can have
patches that modify behavior.

Thanks,
Miklos
