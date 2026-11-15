Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794767296;
	b=tp4EJ1oPMnc8vQNAaTRenN09BCV+ocAwvjYEWwRtYXKCtin04abp4OCIBBYIsw5bNDrV
	 ha5F2Swqo0bT5XD4dac7X7CRau5ymM4s9xgupUPlhH24vm43yDpSFw7zumA6nr4wKU9i+
	 8qYT6MY5MHjfuMNlNRJxq7DAsOvnoIOgwiZ+mIiWZHfhkxV7jtX2O7l7ktHPS2D2c+1m7
	 VmXlr7s1lHM2j2oxYYw+X1pLFGUWF3yzH6+n0k5ok03pIftyKqx/joc4ZeAtj+3K6wouh
	 MLovIcccaj1M521xSY3J3KJXz7S2krfX/RVI00zxb2DpBFBwIR5Rd2rIdMkLEUg9u2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794767296;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Content-Type:Date:Message-Id:To:Cc:Subject:From:In-Reply-To:
	 References:Content-Transfer-Encoding:MIME-Version;
	bh=S2sqyuT4GDnGp9+dHpDjnGTvZCe15TFZq/xtAkotKkE=;
	b=eZJE+47zFbCPO9ZgRfyWE5F9SoNwONUcwTLVF8LMDZ0UPX3YJnK8/YMFPY/y+z5hrbxg
	 mXYWefcvEEoxUrdhsq8n90x9siGexy9tlz2rSsPPisH2nKfIY30FvWDj48qXaKNEUWkx2
	 1gqePHoGVBtpJghF1FtMji2aCV+ODTqWnF1Ct/VYIeAI0XZtO+UDQZIjXNmY9vdemf0Jw
	 +kw+IHkzEg3mf2mIn7cEoSoio3SMMOiNiarWaOKllyPZqEolFYSc0O/WnD2QRV5uAdyXY
	 dEVzJSKxIoK1QvpegmoSxulm0UT8T5nOPskZzoIxK5cjsSnWUC06y5fE0p/n+ce/YPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HBV5nxYv;
	arc=none smtp.remote-ip=209.85.210.179
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5920D606A32C
	for <linux-unionfs@vger.kernel.org>; Sun, 15 Nov 2026 18:28:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5920D606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HBV5nxYv
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8a06e79e152so1223951b3a.0
        for <linux-unionfs@vger.kernel.org>; Sun, 15 Nov 2026 10:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794767296; x=1795372096; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:from
         :subject:cc:to:message-id:date:content-type:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S2sqyuT4GDnGp9+dHpDjnGTvZCe15TFZq/xtAkotKkE=;
        b=HBV5nxYvdpLlRvsxsYLbFKr5P34f8mj9a/XJil7dVolrFQomVVkyecHxP6BgFGwDxs
         /19GzczoyqLC7fuxmwJyN2rwUymD2CerKLMnjfS/2CRMvt+ynLs5gkxwuVBuAu3q9J20
         IzB2wBplZLjMFwEGGW7prCWCSa7Aywa/5h22qXYWy2au5OKH6AKODohFFnhhSeGrFYHI
         n+FqPiDDYHHddi3JAW7aghC+X3tcMJhczYrIX5Hp62B1gpJjhhKWZLANouBkWkfFg5wA
         r6zaGmjBjVlFtwZxS8OaoxZbnmYU5uIROK1UqsDLBtdOM41dsZCnP9Jsrl/zETDD4H/q
         kP7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794767296; x=1795372096;
        h=mime-version:content-transfer-encoding:references:in-reply-to:from
         :subject:cc:to:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S2sqyuT4GDnGp9+dHpDjnGTvZCe15TFZq/xtAkotKkE=;
        b=lwHm2DKvfZsXxAQp2Hvt78FxMNE9ugpFYGbD4geya5XW5Fh1I5tIl4JlW3XEmwT3qj
         /0ypMGv0I/17Rb4Jnkp5JPlOXPhfNI6my+mLBqtU3DPFddJz0w1idQmwEAlXK753Wswg
         FX5zrEjSkO/WXWoI2io6qN6dBeleC6wD2KWnSpFm7mg1Z4BuMZildWHh7COM8TKvgvA2
         QogJG2AUcwT3cChrlc+5BG3sCj0CMuGfPFTtjc0mIB4PIlENMLzfp7s/MFo5DcIhHLUR
         SijkLTxInfcywfW6uC5nWa+HejNwxA3QLOUY4VaPongBvaT1FXqG1d14tO7UwdoAX3J5
         8j7Q==
X-Forwarded-Encrypted: i=1; AL+hErEeLdbsx3Vx6lavm8o0v6xcCeU4MQ4qnMzPWSdRj1Ce70+JU8bZld4tQb/2FwvdcHFubsUlRR7K4Mya6PnX@vger.kernel.org
X-Gm-Message-State: APuU4Z+iAvX/NUQbpPSCqlTksoTmXHqXCGrmF82g4XyuezN/qhPy8/j8
	fGXp7WWmv0nEqAViEerhbbVsj3OyTzcWWq1t5C2rnwhcNC8xZreb4jIp
X-Gm-Gg: AYBFou2E6foZKsiGXatfikSWCM70nMazB/pL83QQSc1dOeorSpcCG47VWfpbhbAsOLm
	jJI/kdptUiM3bX/6bskSBxbAa6rXJ2eDvbhk6TMIRe7uKLuSk/hUyZUPvzt7rnm4sT8Z1hCW/lj
	M/axPBy0FKqIT8OsXp6jOGHCT/VfTEHdH1OO9+sGYGlhAL6oR2cu+GePFAJ71ag+UQ1UC/R0e/r
	ixNjMKfsIBeWkUveG7eehtaIteUhFhHBVe1UHlIa2j0jfnt7vq9ll7KcXxpiDmN3cGPOgMK8wQ9
	n+43Z3N81Xm27WJFXZ5SZKjVWteHy+rPuXucLkJxInXIbUQ410WWIJKc/V5o08ZfRapXU+boF8P
	7we7ZGly4Z8WtQutqie+pyZRG1K3Y1hKpUybxbwsZCRLEoTrfsatq5Vk6dWJ4RrJoAttsdkRIoP
	dwd6qcr+mPRf3mTaWD7XYefqFwFJcJdsYRY67rTYniC8YgJ2Ykx2m/mAx4BltpLzVgQz0HES0ei
	5ctJcgmxPODdO9QEGuNQfIs0vXUYqlT17dXdllu5ZIe5QIulGMRiUXsJMLQ0ow8ayRfbwrFrGhB
	g/fbEQnYurGllYrEqUrpkQiYsgByzVKJ1mbX2YFytHcETTrygIvMYiLGfVTGsQuetMmAYNmjGR0
	dxJC7iYirw8vGmjgSowqFb+uuWOedvN/LHg==
X-Received: by 2002:a05:6a00:230c:b0:89f:d620:226 with SMTP id d2e1a72fcca58-8beb619bec4mr7100607b3a.24.1794767295502;
        Sun, 15 Nov 2026 10:28:15 -0800 (PST)
Received: from localhost ([153.61.198.242])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bececcce6bsm2804318b3a.1.2026.11.15.10.28.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Nov 2026 10:28:14 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Sun, 15 Nov 2026 18:28:14 +0000
Message-Id: <DMVZWOMFDBX6.3HVETC9L8RUEU@gmail.com>
To: "Christian Brauner" <brauner@kernel.org>, "Amir Goldstein"
 <amir73il@gmail.com>, <linux-fsdevel@vger.kernel.org>
Cc: "Chris Down" <chris@chrisdown.name>, "Miklos Szeredi"
 <mszeredi@redhat.com>, <linux-unionfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
 <linux-trace-kernel@vger.kernel.org>, <linux-integrity@vger.kernel.org>,
 <linux-security-module@vger.kernel.org>, <linux-mm@kvack.org>,
 <stable@vger.kernel.org>, "Sashiko" <sashiko-bot@kernel.org>
Subject: Re: [PATCH 00/13] fs: let d_real() fail
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Sun, Nov 15, 2026 at 06:01 AM Christian Brauner <brauner@kernel.org> wrote:
> As Amir pointed out the correct fix is to teach the callers to deal with
> an error. So d_real() may now fail for D_REAL_DATA and all callers
> handle it: uprobes fail when they're created, IMA treats it like failing
> to hash the file, IPE denies and the bpf kfunc returns NULL. Then
> d_real_inode() goes away so nobody can ignore the error again. The first
> patch only drops the WARN.

For bpf bits:
Acked-by: Alexei Starovoitov <ast@kernel.org>
