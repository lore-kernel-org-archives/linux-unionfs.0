Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7FF16C445
	for <linux-unionfs@vger.kernel.org>; Tue, 28 May 2024 10:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716893735; cv=none; b=fv/SxD6dicr114aLJQWEXjBR3OJAyoCqqWU4hprNCVzdM6o0uoL4m5axObEc0y4uhzBycf47tIIahp6mPf0iqx31tGnAg3oyrSuQLqX3v7xYLiPrhwHZRy2rzTWmXywJHJT+AAe8P9wckMYqHKfGWPbp8fePbVa5FdTsvVGSV7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716893735; c=relaxed/simple;
	bh=vHnCPeq7576aPfjGGsYU9wpALy1XPLbQ5pEiCJla2ec=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gm1viUo0JEL1I+3n1zusuii+dDCjZBr2Wow8ZpVuBqpVRxrss1XQpSIw+jc7126Yb78rLinxHI9NmK8IxCenSaItcYOl1yv29OleygKCjJMKQJe5oXScZ2scqqIkzsed/nRsQpJfiEt21JZVCCy3ItFFK1e9ZbyEelZFKqd2QSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hH76nGzE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hH76nGzE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716893732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vHnCPeq7576aPfjGGsYU9wpALy1XPLbQ5pEiCJla2ec=;
	b=hH76nGzENC8rko8B6+6HRrf92CMHwRN3w7X3ITJjaU85Zdl21DBhVKYDdVaLqRjlCV5K7J
	MccQuFukRQPxDYi7AEsYtpcEXMptGNkdJwsqbJmX6Pyn/z7AZjbOVJGf1KQ17zjSCswInP
	7B47T7JTbypHMamUi0HfHWcIPQTgk2w=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-63-7woqZnz5MH2HUl8Zgz4uWw-1; Tue, 28 May 2024 06:55:29 -0400
X-MC-Unique: 7woqZnz5MH2HUl8Zgz4uWw-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2bf7dd49cbaso637515a91.1
        for <linux-unionfs@vger.kernel.org>; Tue, 28 May 2024 03:55:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716893728; x=1717498528;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vHnCPeq7576aPfjGGsYU9wpALy1XPLbQ5pEiCJla2ec=;
        b=Qd+ygbxFg3fimzbLf6oMKK84dw/i1VsuvYZ97wiTHCx+/j2Ojbg8s35M6Y+VtpKKpk
         9RmE09dCeShG4l9A/lIvipYYg1qnT91UDiaDpt62XWUlaIsfLxzk9UJS4GD3c6KKJs9a
         gVH2eGvLWgzyP0iubf21bIBn0tLpyOt7qtsuiN0wfrgxQtvhkxd5RE5R2lDAjDuo+va6
         QR8fysCwIO+7VA9BNruPLKDx2G8+9/M33LOlnuIRQv5h+UbmVYgvNlJkAHEyeEaoouc3
         FjgA/tTlOt3cEfo7ndQ3qFNHEI/jkpQOM8LXz28FJNJnPOUbGkOWPSfdvyhmrOb4MUGd
         B32w==
X-Gm-Message-State: AOJu0YwPSS8gAd6OmaUMIdNMR3Tl5wdm9wx6NCpyAruU4lirZTztfqQR
	Cq6mcqpDV9EEdH9ECwTHqh/rJHU9H1JE+RJNlB+rTCgIdHs//5fo1D+9FYP2O7Y21gSB8p4RwiF
	hqya4qKGJ1kdpF7eZM/zvA0yDRn8678FLJ2IpeZa7sajA/TFqx8oyaCTw/fHFPKKCL7AyLn6w94
	dfcbi7j0ZOoHeT/9SPZReDw0vmN5NDry8fF21jog==
X-Received: by 2002:a17:90a:bd8f:b0:2bd:db8b:ca73 with SMTP id 98e67ed59e1d1-2bf5ee1ed8dmr11699719a91.26.1716893728203;
        Tue, 28 May 2024 03:55:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGYl8Xlq5ut6UpRKjwx+ETwNHlwdmlFWwQr/zO9UXczA7Tbz2gkDKeAu1VWJDBrMtGJis8MV2mdm7z+Ltni4jI=
X-Received: by 2002:a17:90a:bd8f:b0:2bd:db8b:ca73 with SMTP id
 98e67ed59e1d1-2bf5ee1ed8dmr11699703a91.26.1716893727803; Tue, 28 May 2024
 03:55:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240528090244.6746-1-ecurtin@redhat.com> <CAJfpegvoao1jd7HhoPEeWCdS8jWEXhKTENbwvLdo=aMiNaLKQQ@mail.gmail.com>
In-Reply-To: <CAJfpegvoao1jd7HhoPEeWCdS8jWEXhKTENbwvLdo=aMiNaLKQQ@mail.gmail.com>
From: Eric Curtin <ecurtin@redhat.com>
Date: Tue, 28 May 2024 11:54:51 +0100
Message-ID: <CAOgh=FyHFE7qjfYq4BqGc20SYJ5FebhN2iYpJSsYYatO1TkqBw@mail.gmail.com>
Subject: Re: [PATCH] ovl: change error message to info for empty lowerdir
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "open list:OVERLAY FILESYSTEM" <linux-unionfs@vger.kernel.org>, Alexander Larsson <alexl@redhat.com>, 
	Wei Wang <weiwang@redhat.com>, Amir Goldstein <amir73il@gmail.com>, 
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 28 May 2024 at 11:34, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Tue, 28 May 2024 at 11:03, Eric Curtin <ecurtin@redhat.com> wrote:
> >
> > In some deployments, an empty lowerdir is not considered an error.
>
> I don't think this can be triggered in upstream kernel and can be
> removed completely.

True... Just switched to Fedora Rawhide and instead we just see this one:

pr_err("cannot append lower layer");

>
> Or do you have a reproducer?

Run one of these vms:

https://github.com/osbuild/bootc-image-builder

And on boot:

sudo bootc switch quay.io/fedora/fedora-bootc:rawhide && sudo reboot

is the reproducer that is closest to upstream

Is mise le meas/Regards,

Eric Curtin

>
> Thanks,
> Miklos
>

