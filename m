Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE7E13AD3E
	for <linux-unionfs@vger.kernel.org>; Tue, 28 May 2024 10:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716892491; cv=none; b=qgGG512auaNp20Qap2+M75r2kaTmFZJXrvIonXJbymatAPxPFcsy785ve3yJeu/GTGxVwAL8ouOS/ibxteuIzemuocAKxOMZhjVSeRx6sjVdslkcSvrQM+m/kUT+PzNo+HEMtY1xPy5BOcLB6hDGzHQyrWAlFFQRa8o+URbKXYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716892491; c=relaxed/simple;
	bh=rMIZmynHxQlTJRn0wXZDXuqK/c1wUSB5d1m9RwF0rDE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ESoJL8JY+NyAChA1KWGcBW/9rekHCsbkZ4Jq/w4Liy8L22fGW7AkfOJS7ZSXz9MKtipmEsTKaBEiV/J7Gsc8RsR36E4cUo/KKUCv+0EmaV66goYUx1ONJFSIp+7tVw33CDznvkreD4Jun89AwB4d/rpKEWl9SC8+ftyOsW3e6wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=VRfbWyuf; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="VRfbWyuf"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-57869599ed5so754011a12.2
        for <linux-unionfs@vger.kernel.org>; Tue, 28 May 2024 03:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1716892488; x=1717497288; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rMIZmynHxQlTJRn0wXZDXuqK/c1wUSB5d1m9RwF0rDE=;
        b=VRfbWyufqqK5ZZsb1lGQI2YarBtNiVxgRz3DDwAUB3bgbojF3tGCj4eDQlSQcRGMa7
         //mLg3qsOEKJ4Zhdmp/gySnVXkA4o4Ln/7D4pIJYBGPOS99VUye86v/j5mJnmB0Giq93
         5TmRTRf1NnJ/LmeYzyoTDPk/kRftCDdITZTe4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716892488; x=1717497288;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rMIZmynHxQlTJRn0wXZDXuqK/c1wUSB5d1m9RwF0rDE=;
        b=h/l6Z7i/aSomm2Ax+U2AIe1uf30IU+CsIvxdHMh71g6Xwv0DS7zicZRYit1wAqN0lc
         WoFFKTmgm0bIAPztiYfQ3VMLVWUUbfDidmrq6xOlvkQPtMt0BUVzH3Eta8Wl77gjVNwy
         IAOqO2ROMEusY9tJ092A2A3fR7TehpVIgdVLppuZ84qCuNaVWQPqHG07MKFeBm75HRIo
         YdTYBEY5LG0hEK7+f8fPsIrwibTsS28RaPdz5ZH07OR9MnddR/3tweBCoKxgBorZSZHY
         GiWJt3VMyAWifh6UgyLHzaTuRrYzpY6IEZA3yWWrCfyaoN13u7ouENJqVieU/YNCgLxp
         4vdw==
X-Gm-Message-State: AOJu0YyefErdOjOsZQoc61VgnV/0kwAIYXJjMJ5VMbHWK50ew6ycsoZy
	F0E6+Rdo5PoKRW3dXeoJPhNaklSB2gyFlI0O3udALRDE2mWAZu3OKKI4MdPogVpk+VboPPb5HZr
	hXrIEC+/Aj4kGNUjbHBECzvDryHYSDCPtD/OhEg==
X-Google-Smtp-Source: AGHT+IGf3ZtXXEh5OYJF07HdIQPyKNgiGwm/AnMlXGcrV6HD0/oxru+8FNRPGNaNU9NPkpCQBGpav3hf5+9QEkM2STU=
X-Received: by 2002:a17:906:6b1b:b0:a5a:84c8:7710 with SMTP id
 a640c23a62f3a-a6264f00dd2mr877227366b.55.1716892487943; Tue, 28 May 2024
 03:34:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240528090244.6746-1-ecurtin@redhat.com>
In-Reply-To: <20240528090244.6746-1-ecurtin@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 28 May 2024 12:34:36 +0200
Message-ID: <CAJfpegvoao1jd7HhoPEeWCdS8jWEXhKTENbwvLdo=aMiNaLKQQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: change error message to info for empty lowerdir
To: Eric Curtin <ecurtin@redhat.com>
Cc: "open list:OVERLAY FILESYSTEM" <linux-unionfs@vger.kernel.org>, Alexander Larsson <alexl@redhat.com>, 
	Wei Wang <weiwang@redhat.com>, Amir Goldstein <amir73il@gmail.com>, 
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 28 May 2024 at 11:03, Eric Curtin <ecurtin@redhat.com> wrote:
>
> In some deployments, an empty lowerdir is not considered an error.

I don't think this can be triggered in upstream kernel and can be
removed completely.

Or do you have a reproducer?

Thanks,
Miklos
