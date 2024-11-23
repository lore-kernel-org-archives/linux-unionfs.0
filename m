Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDD081AC8
	for <linux-unionfs@vger.kernel.org>; Sat, 23 Nov 2024 05:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732339342; cv=none; b=deaacuMt4nj6jvKwJjiLro43isENHDVmsD9O/kvlK10yRXMFqtU8TbDz0YeZFd85lvpZjWBwoEmU6PF87FOE06oQYcqnU+fqaVvm2tmAH0lkohpOkVCSoQmqLcdFYk8MhNgLSBfEEw67A3JY+nZ/8rMa1pjf+B+roMu/Zd9U+q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732339342; c=relaxed/simple;
	bh=7tU5ALD6dT/GscddLn0cfJ213h8MSmkYT/S9vdeLi4o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vomh1Ktz1BDxEKgcHZ5Ttdbujg/yxtY+Db+Ba1TKUsh9PQxqR1YpmVzNVWR8EZQPbaU5Ffne/rh+USkFYtj82FsMwClRSkc/i78zYNQLeJychrFj9UBpca2vWrPTW2Gk3dyP8MYnxhtqUIzCERy9k6fjJglhnCuJY0hjZpdmF2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RMeKsqvY; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RMeKsqvY"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a9ed0ec0e92so316213066b.0
        for <linux-unionfs@vger.kernel.org>; Fri, 22 Nov 2024 21:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1732339337; x=1732944137; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Bz/Cem8L1Zly4fm6PMZZr9K2nmFFTd5Yiu7PpEQWHQQ=;
        b=RMeKsqvY5j45Y4KDL+NYWv+rietyD6nfuY5EIKotiSdTzaadX1XPJuOcMh5f9hcPhN
         xQbeqfmw1ClU1ixNRwMOep2hV6tPhDDpZwQofg372yI4yXZ8Bu5ZXvVWJBwLyYdqU3Bz
         6wLYuQnQrNGYdw9tBWDurRn7vy6SFSiESg0sU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732339337; x=1732944137;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bz/Cem8L1Zly4fm6PMZZr9K2nmFFTd5Yiu7PpEQWHQQ=;
        b=KnLrzB2dU6nu2iBmA5EP06ofWbFGYCM6Ozxdyq6cws/wak2N1AqKQFJ6QsKcW82wuW
         HlcHJVhltGRgD4eWpeO3675gECPIpoFfxeMTlgonLx2cvrb5TWwkI51H5STdIzHl7wjx
         hJb5UAtj5OZegt2NAsFTGJECeYHwoUhVxXKn7BUm0BEVS4IztzB6wU3CG17c+q9X1vaZ
         ykhh5O42lFreer9piFhtloRktEs2YvbayC60C040Wt5/0BCge7d3Fmink7vr/g8VeH1i
         upuRsJg22H7fshjNRPdBI7gBn7FSqjYnpVWopsrWQcMLFrzx2OuwGO8PW/Hej92c0oTp
         S4eA==
X-Forwarded-Encrypted: i=1; AJvYcCVHtmigOMZ5LFzlnEBtiiR8MzJ6Qwe+s0UG6rttxLGJwWXsBjwK/lRlU47MWKTYOxuHT1etlv56EYRbLnDY@vger.kernel.org
X-Gm-Message-State: AOJu0YzuuqvjouDb30FNDkCkEI5TtMvduGvOcwdztbxrBofIUMddT9Ml
	acMWiVwAPi0vQp6cVDynQIbgxY5Erla9rFQ8wekmoY5FFSl9L+YVW9hBeEHvbGTls+doPXOWu4i
	JyXQAsg==
X-Gm-Gg: ASbGncsZg2mbE+S+ULO3OTzxGEGWIHRGhzzT5eSlnwiWJFwiVOyzcjOUclTw+g62BKy
	/53l6RmUQ7z7doxXdIjO7r8ylGGKosG3K7wryHXmdtFI/qbn0TZanqbgceIilSb9U49qet+05d7
	u7mB7X5YZuVxEUEgZzPY4otNDXNFAZ1cZc7zy0nYQl/vvRic4kX1j5WA1OGo+8JmyfJZoXjMZAK
	fayCRwCJV7c57G7McLCzX8mnnR6JxwJEW1rgwHxCQZs2WJ3IV8oSmCAf+fKP7TTRtiqj2XjgePE
	zfrmmS0ENkVdPE17pE+ISRNc
X-Google-Smtp-Source: AGHT+IGQkfvBTJbqAhvXOmbismPddKNS1JTKVaSKHZm3s/I6LD+ZWuzlmX6eeDHpTQ33vNoq5OV8ow==
X-Received: by 2002:a17:906:2921:b0:aa5:1e67:2f4e with SMTP id a640c23a62f3a-aa51e672fabmr317278466b.19.1732339336705;
        Fri, 22 Nov 2024 21:22:16 -0800 (PST)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa51a8f417dsm139720466b.165.2024.11.22.21.22.14
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2024 21:22:15 -0800 (PST)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-aa1e51ce601so449625566b.3
        for <linux-unionfs@vger.kernel.org>; Fri, 22 Nov 2024 21:22:14 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW2FiMWJ08hO41OUlt0Hp/wCdkLukewlS2KLNIrl6WS2lvMsPO2sFwAwBj5ASdTYjRUQg13Q2abbU+aK89c@vger.kernel.org
X-Received: by 2002:a17:906:18b2:b0:aa5:14a8:f6d9 with SMTP id
 a640c23a62f3a-aa514a8fdacmr332444066b.14.1732339334425; Fri, 22 Nov 2024
 21:22:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241122095746.198762-1-amir73il@gmail.com>
In-Reply-To: <20241122095746.198762-1-amir73il@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 22 Nov 2024 21:21:58 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg_Hbtk1oeghodpDMc5Pq24x=aaihBHedfubyCXbntEMw@mail.gmail.com>
Message-ID: <CAHk-=wg_Hbtk1oeghodpDMc5Pq24x=aaihBHedfubyCXbntEMw@mail.gmail.com>
Subject: Re: [GIT PULL] overlayfs updates for 6.13
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 22 Nov 2024 at 01:57, Amir Goldstein <amir73il@gmail.com> wrote:
>
> - Introduction and use of revert/override_creds_light() helpers, that were
>   suggested by Christian as a mitigation to cache line bouncing and false
>   sharing of fields in overlayfs creator_cred long lived struct cred copy.

So I don't actively hate this, but I do wonder if this shouldn't have
been done differently.

In particular, I suspect *most* users of override_creds() actually
wants this "light" version, because they all already hold a ref to the
cred that they want to use as the override.

We did it that safe way with the extra refcount not because most
people would need it, but it was expected to not be a big deal.

Now you found that it *is* a big deal, and instead of just fixing the
old interface, you create a whole new interface and the mental burden
of having to know the difference between the two.

So may I ask that you look at perhaps just converting the (not very
many) users of the non-light cred override to the "light" version?

Because I suspect you will find that they basically *all* convert. I
wouldn't be surprised if some of them could convert automatically with
a coccinelle script.

Because we actually have several users that have a pattern line

        old_cred = override_creds(override_cred);

        /* override_cred() gets its own ref */
        put_cred(override_cred);

because it *didn't* want the new cred, because it's literally a
temporary cred that already had the single ref it needed, and the code
actually it wants it to go away when it does

        revert_creds(old_cred);

End result: I suspect what it *really* would have wanted is basically
to have 'override_creds()' not do the refcount at all, and at revert
time, it would want "revert_creds()" to return the creds that got
reverted, and then it would just do

        old_cred = override_creds(override_cred);
        ...
        put_cred(revert_creds(old_cred));

instead - which would not change the refcount on 'old_cred' at all at
any time (and does it for the override case only at the end when it
actually wants it free'd).

And the above is very annoyingly *almost* exactly what your "light"
interface does, except your interface is bad too: it doesn't return
the reverted creds.

So then users have to remember the override_creds *and* the old creds,
just to do their own cred refcounting outside of this all.

In other words, what I really dislike about this all is that

 (a) we had a flawed interface

 (b) you added *another* flawed interface for one special case you cared about

 (c) now we have *two* flawed interfaces instead of one better one

Hmm?

                  Linus
