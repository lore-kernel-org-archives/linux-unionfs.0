Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723559;
	b=tq24bPTY2wEc/yz1qC/J2756EHBYHqyU9K0/Q21bImPUZeTUMnOhtLGstCp+FPlTYtKE
	 clggXUnLCG8Ln6PCIcJq18PgnOrPaM8bXPmBr58YD++vxov3+wTismrW1XAS88uv6pKny
	 SgLxwVqhy0+LZos8O82q3+reY2R+CiTZejXZT/T1daIQaMwGsr85SOovw3wA+4jEwWnkg
	 bK3jREFOxQppIMr3q/cM6Ji4bibHuvfa6idc/ku3pY2Y/QpSjaiUK36yIOrnadxyXmCfn
	 TICqo/X1Ecq8Hr2VeKe6QWu1zcWxTqE4jTE+eVQP1s1nyiGz/6XYPX98DQP2nSdHv7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723559;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=NR97qxa1tJCk8/3NXh8u8lLXKz57p0plaZ3QiqfzgAM=;
	b=U39S/odVNFTF3HragFD5mGg/tmKa3mfdMTJW6MEMDAzJpBv4cu7mEOq18f0+DKgeekrt
	 AotIaqusZcKqmag+viCtgY1ALBY3DFSOunF+Nn4cn7nabPJ+louJ/agvXdGtdjZ/IDkJP
	 MY9rJfwPpipm9l6hvsD15HP7jLKT9LWXtOk2f5TJBDSoVgYTRqhr9Zc012CACUQHvzMXq
	 lJSK5tlW2PxtO4c3NE5yu48WfVbL43eeKTKdtr5RPp+OomOupQYY0oNP4gZdGHrmDdqS0
	 IhMkZ8ydEmRSYBgUgqJUa4n75/8Esogmwgqx/OPuf4eFQWa6NH1N6LuKQnWA6O/Xd1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=AQWONENo;
	arc=none smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF438606A329
	for <linux-unionfs@vger.kernel.org>; Tue,  3 Nov 2026 16:32:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF438606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=AQWONENo
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c4550d8ab15so536382666b.2
        for <linux-unionfs@vger.kernel.org>; Tue, 03 Nov 2026 08:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793723557; x=1794328357; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NR97qxa1tJCk8/3NXh8u8lLXKz57p0plaZ3QiqfzgAM=;
        b=AQWONENo1KDQTu7a8xGQRLwvMfpaOjiWcZFCmkOsz4QRpZ/6BHmgZRp6awAxvXsQhv
         yURn4gyyXT2oyTEdsulP6jXT6i6cbHX/9lpa/WL1C980EugdZUdi7sk5LpMRs8JzKPNs
         m/HR7+8UzQoGg3AJ8gjrffp9SsssAG2L+GOXg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793723557; x=1794328357;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NR97qxa1tJCk8/3NXh8u8lLXKz57p0plaZ3QiqfzgAM=;
        b=yYhnyGMFea+tyk1/XgHWLlC+KcrPW+sRC03wGCSpOH1RY5ceymjYA0twDRiHOGvw4f
         wkWJLzs4niVeR/R+AETORdASqSrKQtCP1NDJ2q4Sy+F7gUa/2xVYoynBseueFRp4A0O8
         KlmKotEbTkiop+cPQQt2DScBDUZPuh0PqoZeB4DBXTia+iUuXrCiBMGxLyr8rvwWzwaV
         u0yOKzQ62EO40caWrTcXSuFX6BZKyMwWdSMMbwjmYLEMKVoxsLwRvK3kPDHecTIgRFwO
         KB+s60VoprxSPtmq43ZR1Ozk6nrcOoxVKzAVSAHkZgFgLMDoAx9O23RBZz/3gvZ5eO3d
         gbkg==
X-Forwarded-Encrypted: i=1; AKwUvBxj4rOSIUQvOQRYViwiP4C04ozCtx0G8KjgjcK1tfD7HxwLxZog5HWYzqMsRnQJ7TbcXcnLo4xO/tqQR9qv@vger.kernel.org
X-Gm-Message-State: APuU4Z/MrnNPa44VnvvF2rlA3XWLKW/0wIcelUZW8sToaFonKQN19MuU
	f7zaCfhjHd3vWF2erYbVrCwWEVYLKK7l7UUXdWZC9a7tQNKZT09sOodaRCKdFl435Vij3TvYhCK
	AMuzGlzCrug==
X-Gm-Gg: AYBFou1rFlUjohi9lgG+N6lI9BMVMUjr0NSyoF0Mphhi7exWoT072G+TYbGTmAgV4+R
	Rt36C3g7cAlz61WEThkVZTQMgbJHi1T9H/siGQjhmqb/AbskRt28t3Y0wZEjY1XgPj8OndaW4yz
	OnZpYa94ygSGECWzjg9GrLdi96kZYefP48iOWtIAr6ni25Pt9Z9LkAN01ueI2cXR0WWr1GcOlVb
	1kEZTi2jgLObwVQchuPnECameVTpPqz6r4irk1eYxu4gCsohRV/TjKt+W1TkWG2YdG70duJzdMM
	n816CW90TJ3kXEwfQIs2/8q+23ZWBRdJBELk8qNlUk4LhzyE02Je1/abMXXnJVq9XYfOmjjhHxJ
	n5FEmX8Li0X8KeQkoiSN1tl7gvrXZbWXBsP1D5Qpo0Fw5HHzeRbVeh1HyTavkjXcpjARoGOV/OU
	WmwI31mgfgJLZhNh2CiFE7ImbRwCcFgfI8tYUYuV7r8WmJFaHgj/4byGjMLJhpAhYromk8ZM6PS
	Y84muqoAruTjyhRxJ/HgwElHUp5+xbTvsdr5S6Pq9hM9bqK38DYTFpEPxkjh97lk0yRa4+qfahV
	JlmamEZHho/p+8fbmjvWceH6DTBUCuRpkPClhBHegXYtrsHOtoBJR+sfFPS01bBqW5Uig6jveLm
	ohgYEXCtXa+xnsE5WicvQYKE=
X-Received: by 2002:a17:906:7952:b0:c2e:40a0:7978 with SMTP id a640c23a62f3a-c4ca7a54f88mr1145548866b.9.1793723556896;
        Tue, 03 Nov 2026 08:32:36 -0800 (PST)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4cebf492b6sm104041766b.58.2026.11.03.08.32.34
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 08:32:35 -0800 (PST)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c4550d8ab15so536371766b.2
        for <linux-unionfs@vger.kernel.org>; Tue, 03 Nov 2026 08:32:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzAWM5ll8pKq6Tk8NK+TEmAFYRNgxHeVUCx3kBt3GxivPngAo6pPxjLvRfkOq7QO7S3G8silZo0Sy9lkh0+@vger.kernel.org
X-Received: by 2002:a17:907:6e93:b0:c41:1e13:4ba9 with SMTP id
 a640c23a62f3a-c4ca795e46amr1177918466b.6.1793723553776; Tue, 03 Nov 2026
 08:32:33 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261031095716.3030288-1-amir73il@gmail.com> <CAHk-=wiPhTLn1p0ZHx-7SMdk4_zazqDK1k7MMEn9scRfqeDgtw@mail.gmail.com>
 <CAOQ4uxjNrdxZdZZipsqnUNq+TswCKqp+30iKRKCqh2WOQ-zKGA@mail.gmail.com> <CAHk-=wiimdwWu0EVQdxGVjbVWdzNKGg0f6vZ1aR-GXxDvQa-Eg@mail.gmail.com>
In-Reply-To: <CAHk-=wiimdwWu0EVQdxGVjbVWdzNKGg0f6vZ1aR-GXxDvQa-Eg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Nov 2026 08:32:17 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjz+Tg3iq_6uBqxm+egP_aRhodcz2Qu3pQaR8SQcvPt0A@mail.gmail.com>
X-Gm-Features: AclHuK9w4S2wxf4udVRHX01W-WMPzHWb6oB-n8uxW69QasJSfANeHRc58bQ4vhU
Message-ID: <CAHk-=wjz+Tg3iq_6uBqxm+egP_aRhodcz2Qu3pQaR8SQcvPt0A@mail.gmail.com>
Subject: Re: Return failure from take_dentry_name_snapshot() (Was: [GIT PULL]
 overlayfs fixes for 7.3)
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"

On Sun, 1 Nov 2026 at 09:16, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'd like to see an ack from Al / Christian, but
> I think I'll also rewrite that function to use guards.

I didn't get any acks, but I obviously did do the guard rewrite (and
then some: I got a bit OCD about it).

I've committed the end result.

          Linus
