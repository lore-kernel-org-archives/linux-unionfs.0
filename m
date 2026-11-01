Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793553394;
	b=qTLnOsQOeInxy8rXPMBLPoeebbCbLDC2ClDxYCeEwCS3WCmMuHCjDP7FTcw6TfPVMmkl
	 esb0niQ9At9ED6vrqv8a06aTFB3Ltdt+BokAVFAihDUua0ym2uZ3mc0f2fGSIriXmKRR0
	 MwAQDTbwXlJK8xXlWYy74Q11J47w8MD0vtj0+5owtKbNaYLtALqSgvwb7cMEBRmgIjWpw
	 RqM3quFrvuHdzY1p61/cxIK45JlKFpHVsHwY2yQL9CZTWHkKAPE4MZhdz3HWQDiF8E7dQ
	 pmRFjWWsYoIvd4Cs0mv6cMAY7qk1X3fJD/f6eWQ0jGeUS4TJm1AEMpm6f0zuQPQjfOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793553394;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=stfMBCCx0iYEkgEJ5sWasY787cUVg+XUdXtndqYjb9o=;
	b=yR7K8COXLm11fSbxg+4VQRl3ozsMSKbHuCvFwkZcmvGisv01/WTm08VSTIMzghMyub+E
	 uvMTRLA/y59Fjkt0lyR0I4T5zvdW0n55mP2sHkJ3FinAF61Bizm+e220JGGVa/fOzdMBu
	 oRzVeLMjInj/p1SXKi9kTm3f+KCaDk2wZVoHeSJ/SevXCEkyTeQjRc9LN5+uiBbCqroHf
	 rjDFJjaY6VJl5dOamRbULTq2BdsGD9TFv7kvMrvLdft1Ocv+vO1ixtZ25GPrmbExBzYkp
	 A12BxsEZlA733w+6bhTtr2KzaXM/r5zo1oZ0WjA8/J0GItdeQPYWgb81O2HTJXowLcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=gNQ8Tpbv;
	arc=none smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7965A606A324
	for <linux-unionfs@vger.kernel.org>; Sun,  1 Nov 2026 17:16:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7965A606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=gNQ8Tpbv
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c445c95d553so294638666b.1
        for <linux-unionfs@vger.kernel.org>; Sun, 01 Nov 2026 09:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793553392; x=1794158192; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=stfMBCCx0iYEkgEJ5sWasY787cUVg+XUdXtndqYjb9o=;
        b=gNQ8Tpbv5/eK1NBNWCxtTgc16zPTW31++MtIDLWD3Q/1zm4lUx52ChF8Czkb/NMICb
         UX4FF48fhvwXyObWcaMxmZPVQOL3xD6mt1ikX5AMH6MGeVlPBISjpeEWo1vrRNiyJr0+
         GSQPwsqvDokOUf5Tz2oS1y1Ty72N6IRBibvNo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793553392; x=1794158192;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=stfMBCCx0iYEkgEJ5sWasY787cUVg+XUdXtndqYjb9o=;
        b=il1KnFC9e3Hn3+Z0A0l2poj+Domd1PydeDsBNWR4QwIY9d2OtrQvgOAQ6xm7OIK/Gp
         w+mkETG7Wc58iYqbw5ILNuZ3vFUtR9MN0naOA9/iw1Vm9F2CMM16zqkFbMujwkwdfsJc
         p2FwGCU15nltShkQVQw0fFUVFAThbniXdZchwMD/kikX27mDlYVJob/sP3/AWKb5g9B9
         /gBvRYLu2XYSBIhUsxLIIk1XoVrgiPKPwYTDB/tzTJGNHSZx8nm/b97Xxg7Rbpmn8iiK
         27Yax2EbUTWSsifwaGYaxFqSMELx1EFpnDlMKfKv/JRKbOvC4gw8u1PUEoms5JRZ423L
         8nwQ==
X-Forwarded-Encrypted: i=1; AKwUvBz19hz1jPSj1wKH4oKetO9WdMQn5+btsjJ8VgUJh06LVhwGmo0bPS5ERWAbpBd0V8sJ66xtKiCojFw07n/X@vger.kernel.org
X-Gm-Message-State: AFq9FYLMHdDfHEgU1x+Y4i2F8/WUlWYL/5/1mPGRK0ddIHpWOYQNhiqB
	Slz9plcWQe4XZbxuXETLZgGTrmM2daQcJo4R3KnUMLMx5aidXNdcAnS4Yb7zKnJ/mKwVovqgKgJ
	T85F2Bsc=
X-Gm-Gg: AYBFou2wo1QXHzQV4H3WJbfnLkSc5e4k7kBYfRXM1Gns3tqX835zKxKUdCQRweiNtza
	iHwCR814q7hhcZ5uAzuokxulEBvSmsARj6vOtbbnAeFRjoAna5XbawGiJj8J7l0o6ZolqSMcZfc
	sL58++PTOr5Ae03k5Y4S5OSUzAqsZiCGvWCIuH3Waw3paWhRW9aPC+6GxeLLscDXqkl9BoU4F0Q
	5WD0noi2hqYnOiFJzabagdwvQio2TVpkwTEWCwptwx/Uu9eNbpo3E3rCRDEXKlhDLe1e9Lqs/fw
	WKO+rwdcyadbbtycXw6JYzm2I/9/zpVuo0ljcH3Q3vV5Vs4Sr20nWrfZ+K7cv5Wcxmxw2tn/5QD
	G0kuM75wCzFIcwSn+HN1Q7tAni0CKsgnhTr0jh7M6cK8MXP0yYaqg6db8DkV2MPsv87iSrXxXz4
	lAcvlKo5qPD7S+PJbu+Y0qh92xibTVbhjCfBeE8fPaXjRwWcxoLbX0PsKn4HEvwFBIuXsa42l3n
	OspXuinjXi/jFYMjHBIOSPQ6a/cLJYnYord9kFKwCEGxzG7aOe5mE3SVOTJXsktCA1JCqhtRKop
	0cPw8vuAgqGJmPNML31hPg7uLO87CC1HoMVJrnnGgIBZPcVmd7EA1feiCXb70AwhA28LlG1CJ3P
	eKQ==
X-Received: by 2002:a17:907:9283:b0:c41:a5da:1511 with SMTP id a640c23a62f3a-c4ca7a88ad4mr600823466b.25.1793553391818;
        Sun, 01 Nov 2026 09:16:31 -0800 (PST)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4cabe10055sm294322566b.43.2026.11.01.09.16.30
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2026 09:16:31 -0800 (PST)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c445c95d553so294637366b.1
        for <linux-unionfs@vger.kernel.org>; Sun, 01 Nov 2026 09:16:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxmpvJ4x/rmh/bIY2eNt18Ly02KQsaHPuDV2ag7xRRNxEgLrlq+HUKtM7sniPIHMPDCIRgKdePtqHvjUp0T@vger.kernel.org
X-Received: by 2002:a17:907:9615:b0:c41:e75e:5889 with SMTP id
 a640c23a62f3a-c4ca7ab6062mr670144466b.33.1793553390629; Sun, 01 Nov 2026
 09:16:30 -0800 (PST)
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
 <CAOQ4uxjNrdxZdZZipsqnUNq+TswCKqp+30iKRKCqh2WOQ-zKGA@mail.gmail.com>
In-Reply-To: <CAOQ4uxjNrdxZdZZipsqnUNq+TswCKqp+30iKRKCqh2WOQ-zKGA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 1 Nov 2026 09:16:13 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiimdwWu0EVQdxGVjbVWdzNKGg0f6vZ1aR-GXxDvQa-Eg@mail.gmail.com>
X-Gm-Features: AclHuK_uccpP1X2e8Vqp60tdiLbtX2zzsC2PsbIq8_vF14_xkvBHQNU7aw3Vaz8
Message-ID: <CAHk-=wiimdwWu0EVQdxGVjbVWdzNKGg0f6vZ1aR-GXxDvQa-Eg@mail.gmail.com>
Subject: Re: Return failure from take_dentry_name_snapshot() (Was: [GIT PULL]
 overlayfs fixes for 7.3)
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"

On Sun, 1 Nov 2026 at 03:50, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Feel free to apply and/or wait for ACK from Al/Christian,

I'd like to see an ack from Al / Christian, but

> or I can include it in my next ovl-fixes PR.

I think I'll also rewrite that function to use guards. I didn't do it
originally because I just wanted to do minimal surgery, but when I
look at that patch I go "it could be done more prettily with our
modern infrastructure".

Let me look at it in my copious spare time.

             Linus
