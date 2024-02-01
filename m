Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46972158D8C
	for <linux-unionfs@vger.kernel.org>; Thu,  1 Feb 2024 08:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706775839; cv=none; b=jlTo05U9JelRGjVA9zHhh82TAMW6FXsX4cddfLgaGMVLWES8cYxYmu7phSAmNYPCikcAWFjpVI/JZ02zDVA1fatAoBlUlYczYJ+IulD2OTWDrXqETaI0rDx33r9110n0CK3sonmpIgk2kpqrnzjtrd2zY3Rz/lZvx+K8e1eDhOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706775839; c=relaxed/simple;
	bh=dUMtkr8qKaifrH7Gk3MYoRUtYf4rG/FG8mYlXbIIck8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K3SyeglT9yLrbY7g82VHbeyc/JqhFK/f9z8tvv2j5edIi233Efc1d0rPSAHcIQLuPScEDD+1I9UQIR1nQQhwnCkkwfTBWjIT7BiK059duSyzLzIChYvojV9rHp6vWdy5evi/HvZDK7VvXxEQnP9near6MdDt8ylG8eAYo3FyKmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=IGIvhzm1; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="IGIvhzm1"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a36cb22869aso24516466b.0
        for <linux-unionfs@vger.kernel.org>; Thu, 01 Feb 2024 00:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1706775835; x=1707380635; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PSioIBr+5QXx6swWLeyhwTFF3UDD51st5fBW6mANAIU=;
        b=IGIvhzm1j7kbTPGY9ah4hTFofeolN+4jXS0KuAqhvgfP0Q1y9lffIwFKM7Uz1sqakP
         cjA54q1lXualmQAdsRJZedxzZL9nwvU+3tMlCIbTZLIep3aCFrHvFG3N0rtFsRJsCoV4
         Wjp3fZheIIGxqGNae+VGiVRIIWFBlVEEZINTA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706775835; x=1707380635;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PSioIBr+5QXx6swWLeyhwTFF3UDD51st5fBW6mANAIU=;
        b=NQcGVk70JrlXxjivO+QRSKv3fm/opjwurFNztpUjTNkLwnDvwrZPtd/k1zO7VduNWl
         o2s4CqJGHa9gwU7a5uX15pMqNQncJP7Gcd7QWkutB0X0BTNk75OLbid+zWmYTXvIIkht
         lr1Jlz+PhgptT7H0Kmvq8l9+ZBHGKoGhwouAsvaopl3SjknmCLKSfA0OYD7Mi01DHC8t
         Su5eIQY6jc/w+JUr1qTGdEKrNWHwHnSI5MvWowd4OygCqCy62DQUitdxdNMeJmKTapO2
         HYamWOhiEYtlZ/6mjaO7X7iuZjpslUTvZYfa9UCVY79UvaZ8XjmsXl9eAfz736ub1g+2
         HaFw==
X-Gm-Message-State: AOJu0YxIW2vvWnl+9Xb+v1f8GiTyEfzCfKqeaHu5vOia45yOzIWlPqO5
	UFiWFJXGuMO6k3L7mfUNc992q/dp6ljw9df8Y/B6Mbw4jViV5XhbA0VR16xcNrtKzz03pnrwZuU
	LHKj41nDdRUSbo3S13TW6if2+dKxoH+zJ4A9mdQ==
X-Google-Smtp-Source: AGHT+IFVGV1xVwRgNOpwZp3Z/mFdV95YyBXvk+yIVnanaYeFhb0E6hv1gJdvfh0b/hudkj0Uymz5hr9OPqkiEYxC4zk=
X-Received: by 2002:a17:906:4556:b0:a2d:7fb5:fc83 with SMTP id
 s22-20020a170906455600b00a2d7fb5fc83mr3220107ejq.71.1706775835119; Thu, 01
 Feb 2024 00:23:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <VI1PR08MB31011DF4722B9E720A251892827C2@VI1PR08MB3101.eurprd08.prod.outlook.com>
 <CAJfpegvBc+Md51ubYv9iDnST+Xps9P=g51NcWJONKy4fq=O8+Q@mail.gmail.com> <VI1PR08MB3101A133BDF889B35F14D28882432@VI1PR08MB3101.eurprd08.prod.outlook.com>
In-Reply-To: <VI1PR08MB3101A133BDF889B35F14D28882432@VI1PR08MB3101.eurprd08.prod.outlook.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 1 Feb 2024 09:23:43 +0100
Message-ID: <CAJfpegup8_Xm7rqbNgbxoZ0+5KnrJiiR05KLO3W4=mmQaRi+qg@mail.gmail.com>
Subject: Re: [overlay] [fuse] Potential bug with large file support for FUSE
 based lowerdir
To: Lukasz Okraszewski <Lukasz.Okraszewski@arm.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	Matthew Clarkson <Matthew.Clarkson@arm.com>, Brandon Jones <Brandon.Jones@arm.com>, nd <nd@arm.com>, 
	overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 1 Feb 2024 at 09:01, Lukasz Okraszewski
<Lukasz.Okraszewski@arm.com> wrote:
>
> > So this is a FUSE_IOCTL/FS_IOC_GETFLAGS request for which the server
> > replies with EOVERFLOW.  This looks like a server issue, but it would
> > be good to see the logs and/or strace related to this particular
> > request.
> >
> > Thanks,
> > Miklos
>
> Thanks for having a look!
>
> I have attached the logs. I am running two lower dirs but I don't think it should matter.
> For clarify the steps were:

What kernel are you running?

uname -r

Thanks,
Miklos
