Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0506E3218B
	for <linux-unionfs@vger.kernel.org>; Fri, 27 Sep 2024 20:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727468459; cv=none; b=Byv3Wq7f1/dgLucrjAB05tRSlOSzwwEkQGybs+NFnFkPFkRPcm/3A6nh5QUklGIOg2xVGpuANYWzOCXwytx1C3ZBTweFJ/V6YIOkvCGd+3/em/KyyE/9n5UDfJ9DuD55LyMhxMspkCq+30xEagN3nNIP2j7ieIS9ekLXbAkaSDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727468459; c=relaxed/simple;
	bh=WyXyJQKs+LjNjZ1/xEp2xiqyDBoSLBN/sYzZZZJzDC0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pL/rMOgN1wvyXRMB3EhB+dEa4Rt7tVIJHAtl8lLiNvAHQQVOQOl4Vu7TwUAr06FS/SX7Z4P7MEI52wJrcEYFQBMcD8GkP6jtkePVqHOIbnHEhXAFDBqHG9tI94QPttcbF4KATLHkjPSdo4BEFStYb0S9q8epIS+A1Cvvwev6uR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K3esvp+G; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K3esvp+G"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a8d56155f51so296382566b.2
        for <linux-unionfs@vger.kernel.org>; Fri, 27 Sep 2024 13:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1727468456; x=1728073256; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FhWlefZWZpkZ1hQiUXN4BLRYQqUrk3MN5sPdZxTFvf8=;
        b=K3esvp+GuHoICvgvuCmuTJ3U/vIU77mNSrtVNdhzDnjSDoglLJq4WgG4gTgzDtmPXJ
         17HNCsd76TdHtPwTmPHnJNEIsWlov4MnxTP2clQa23WKN7CCK2auXRqGu0wzJbqwbY1R
         cEAHPCb4SLBFRR+Rd/Du9kI8OJQQBTcb2MrD4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727468456; x=1728073256;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FhWlefZWZpkZ1hQiUXN4BLRYQqUrk3MN5sPdZxTFvf8=;
        b=hM7myHjatY27UrfgzliSyaTvwGXolGcjqVq3JkQzNK01b8sYVElYJv7y5Auv6/tR6N
         2ZDEMgKKWiB2Ah41ovndShd8Or0Zv5mt9U3JysljzH24rouRx0rMIGq4/ZewN7lxMrll
         O+XsGuBkVHtbjQbTagSsHwxXAtYMMXT35XHLknxKo/uirOEfRmyGtv6UFmhlJbETQ2qM
         k6nJOHbepwXDJBtfdp+lz5EKJ8PHmR5dstd05jqPHkU3OEIgnhUxavmFdZekTSCbJ2EJ
         rTivZ+zQRDr76vWVz+pt/fFb3/qTKU9aZ8eXqVI3nxhZp3W9N+VGR00anV0ZmCumRsqL
         kE+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUj8UfW7teRzg8Lu4nnUvxCB23ctXeQfozsrTJ/d3nFOsXONj15PD+aZcMP/FTedAG68GmpAn3rqhiPUsea@vger.kernel.org
X-Gm-Message-State: AOJu0YyHoJMTRZTK2+kSF5GcGygBUZIdhbFWsWd3nVPabBVpLrHDY+/J
	lvVcxpwq2GJo/XQ7UlkxE2QqGSsoQdjGAvf3d464zMmdxhgO8jPjAS1/vgShvYXmwjYTNCuq1yp
	1IY4YaA==
X-Google-Smtp-Source: AGHT+IF4Ix2KI27LwJGuziVHTnmeqGvGMtNw0uafB9IUa1abK7x4GyFXiS2RZZYzl1IypdJDHAIhwQ==
X-Received: by 2002:a17:907:74a:b0:a86:8832:2fb7 with SMTP id a640c23a62f3a-a93c491f410mr411334666b.20.1727468456095;
        Fri, 27 Sep 2024 13:20:56 -0700 (PDT)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93c27776a1sm170423266b.8.2024.09.27.13.20.55
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2024 13:20:55 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a8d56155f51so296377266b.2
        for <linux-unionfs@vger.kernel.org>; Fri, 27 Sep 2024 13:20:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW+5Q4J2O6b3fq+UWrFY2+q2KBCOP6bbY+AftjeRjmbAzlHmwSmUB8ZVu54RQ0OuTPCizhHq1VJMR98BExP@vger.kernel.org
X-Received: by 2002:a17:907:9604:b0:a8d:250a:52b2 with SMTP id
 a640c23a62f3a-a93c48f95c8mr413441866b.6.1727468454777; Fri, 27 Sep 2024
 13:20:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <k53rd76iiguxb6prfmkqfnlfmkjjdzjvzc6uo7eppjc2t4ssdf@2q7pmj7sstml>
 <CAOQ4uxhXbTZS3wmLibit-vP_3yQSC=p+qmBLxKkBHL1OgO5NBQ@mail.gmail.com>
 <CAOQ4uxiTOJNk-Sy6RFezv=_kpsM9AqMSej=9DxfKtO53-vqXqA@mail.gmail.com>
 <CAHk-=wikugk2soi_2OFz1k27qjjYMQ140ZXWeOh8_9iSxpr=PQ@mail.gmail.com> <20240927201522.GW3550746@ZenIV>
In-Reply-To: <20240927201522.GW3550746@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Sep 2024 13:20:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjBApKY+1s7F7AB0ZnKs=SSG8jv2LMtay_MY-ym+oEKUg@mail.gmail.com>
Message-ID: <CAHk-=wjBApKY+1s7F7AB0ZnKs=SSG8jv2LMtay_MY-ym+oEKUg@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] general protection fault in ovl_llseek
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>, Leo Stone <leocstone@gmail.com>, 
	syzbot+d9efec94dcbfa0de1c07@syzkaller.appspotmail.com, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com, skhan@linuxfoundation.org, 
	anupnewsmail@gmail.com, Christian Brauner <brauner@kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 27 Sept 2024 at 13:15, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> BTW, what do you prefer for "please run this script with this explanation
> just before -rc1" kind of stuff?

Well, I didn't miss that one either (see commit cb787f4ac0c2:
"[tree-wide] finally take no_llseek out") but yes, it's probably
better to mark those kinds of things very obviously too (and a
'[PATCH-for-linus]' like subject line is probably good there too).

And hey, people will forget, and I'll - mostly - figure it out anyway,
so it's not like this is a big worry. Maybe if you notice that I
missed something, you can make sure that the re-send has a big neon
sign for me.

               Linus
