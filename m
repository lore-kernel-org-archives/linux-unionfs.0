Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com [209.85.210.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8863286405
	for <linux-unionfs@vger.kernel.org>; Wed, 28 Jan 2026 02:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769568141; cv=none; b=PbRj+DorGWIRdYcDHKzYbdBTn5i8Vt+iVJ8V3nWxj4cggm1Q+BDEGTEPMOGgegPSkRTqhfZKDpNZ4S5tWuNC6x7/MzaSuRqLgtdqDBbl2bMB0vnvxi3D+X6NuXV46acTuC8eNaxU/XIS3scGGJmxg/vRvHHLA0XmJuT77kyvtDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769568141; c=relaxed/simple;
	bh=ySUVuUZdbvYFfY4FgYdpkObwkXmUBZX+j+38Y6EqrJU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F6dyiniY850DbBAn1E8P0XAB2aCxCMmgDQNDpOh5UhCtZioKFL/+LDw1HyYLdpYVneZU+4wbMmzyakLFMfaJ5sXw68orDvVpk03oyqaU3sb3vNoXnp0CbCNYboxQc7mQWTjO98NM05k/Uw0Z+BammEVgWjLr2oQsdiwqneRgRXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fBgftnZ7; arc=none smtp.client-ip=209.85.210.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fBgftnZ7"
Received: by mail-pf1-f194.google.com with SMTP id d2e1a72fcca58-82318b640beso2684452b3a.0
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Jan 2026 18:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769568139; x=1770172939; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QEZMQLfdyPYKzhiqnkvYGZfQ0QlObO2jzAVYfO/9mvE=;
        b=fBgftnZ7ntOEThv5RpetTH/31HW1G3h7GfBLJXacJuaf5FS2C/x2kNdLbudVge+cQp
         egM/YLXzTZJLqdKRs9KqqdVcaXdg8/Jw/soWKSlLNcs8uyNM0D7q47ccjdm5MAsUufuE
         I2aI5s62Uf9U4RyMGJ4VOII1REkw+/946M8gzccRKsZyr0ckoegQL/9jJIBhMLA1/JIp
         xN/fDjC/fzYk/iT43+vOEcgtj8UzGHNTiQLCpurToDwPJ9ElvLyANROr9boKB03h/ouS
         8XXHx2yvhoMjefUQLlYnhxXtu6hmV7il2eNeA7/DJQxtUJmVjjh4DH0TxjA4jDWoNDQ2
         lCtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769568139; x=1770172939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QEZMQLfdyPYKzhiqnkvYGZfQ0QlObO2jzAVYfO/9mvE=;
        b=VZAI8+Pcs8OpWRPUgZJy/aie16sE/m++CYUiP+3l+e+oNCSiv9+rgSYkBkD6mA1g+f
         EEiW/0lnt4rXmVMHJHRoBEEjQuSpxMatNwmtGW9N1N5nCp+N7bXbE3U4q/mDewrs7NI5
         YTUjHOvjY8WTzrTdPWFqgfbU6tzhpUtHlK3qZ/0p8SFXTAbUMGmTrf5EVYOw80PLwRJg
         bsoo//Lc4vJmSFmqh9CvWQdheUhHTIGTcBS0F18EtD7y2Mto/x+fdfgEe1K6zESFXxpa
         beU0+h8i8yzBff/3SR7nPv5Ckixjvhild0xyurVvSCbHLETyG//oae9BIfWNoZYmTOpd
         EZHg==
X-Forwarded-Encrypted: i=1; AJvYcCW5eej2vAnGmz5x7fVSHp8vx1cctVOwT4e4/GwCVpCvU4EfIHUaBmss0oS6nCbZCloioTDM8Ev3WylNZDX4@vger.kernel.org
X-Gm-Message-State: AOJu0YxLyXp6YCQ4VC66XInImTlN04N2eQqvQbIjh9O02pvyMEY41Ml7
	7C5YtouCezwgK0ZkbCvptAlSSWwyh3NmFWPTK6+bOuwAWKmD9PIl6EA03QD7+zXz
X-Gm-Gg: AZuq6aKhZniD5gejpBRBMDpxAgzvZdsYZNefv/4qfiHdGOz+WE3MXTBEpFcQgY3m01l
	t8jj4x9+j/5QcKXVRmTCKFxdq94CL1Jb7JTfq7XZ+AEtCJvr1K62AEGrnBdZOOZ7ooxHlMKzADC
	p2w3Opujtc62YiYTc07wAyo6VoK4I3u6t26IiqcYBkAC5abIPsbjLV9jfaGXlcZBdjtS6+3l5mV
	V0XyYEpsfbH9ArS/0fzIXMTJNuggoD+nb1gGfycMZjLiF/flqJNapDiNpaGDaJvSI0sAtdBhxLR
	Eaj75jMDvtJxJnt9tqAdxZ+PZVUMYAArEWCSSe6DFwD3MuOTUb0BbgBZHTIdWznKLdz6Tc1OS91
	KDUy1+oOFZqD/l+PVJ1m+NO1SJQz8PQF09yqa9Jh4KQ8gxH17FhYegMdDC/IgWrVfDvua1kPpf5
	BEl4CJokyHY6qmRufNsNyAt9GAxDloqIpsG4iM1g==
X-Received: by 2002:a05:6a00:4b01:b0:823:edf:9811 with SMTP id d2e1a72fcca58-823691738a2mr3517068b3a.18.1769568139083;
        Tue, 27 Jan 2026 18:42:19 -0800 (PST)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.220])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379bfd8desm869487b3a.33.2026.01.27.18.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 18:42:18 -0800 (PST)
From: Qing Wang <wangqing7171@gmail.com>
To: miklos@szeredi.hu
Cc: amir73il@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com,
	wangqing7171@gmail.com
Subject: Re: [PATCH v2] ovl: Fix uninit-value in ovl_fill_real
Date: Wed, 28 Jan 2026 10:42:12 +0800
Message-Id: <20260128024212.1818250-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAJfpegt9yLioW1dEmGYOfib=TcuWVom=Z+a+bN+jS_8wFie90Q@mail.gmail.com>
References: <CAJfpegt9yLioW1dEmGYOfib=TcuWVom=Z+a+bN+jS_8wFie90Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 27 Jan 2026 at 19:19, Miklos Szeredi <miklos@szeredi.hu> wrote:
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 160960bb0ad0..9ea3cd11dd93 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -755,7 +755,7 @@ static bool ovl_fill_real(struct dir_context *ctx, const char *name,
>         struct dir_context *orig_ctx = rdt->orig_ctx;
>         bool res;
>
> -       if (rdt->parent_ino && strcmp(name, "..") == 0) {
> +       if (rdt->parent_ino && namelen == 2 && !strncmp(name, "..", namelen)) {
> 
> Yeah, and also the str... functions only make sense on null terminated
> strings, so that needs to be memcmp.

Thanks for your idea, but I think strncmp is same as memncmp in this case.
strncmp dons't use null terminated.

```
int strncmp(const char *cs, const char *ct, size_t count)
{
	unsigned char c1, c2;

	while (count) {
		c1 = *cs++;
		c2 = *ct++;
		if (c1 != c2)
			return c1 < c2 ? -1 : 1;
		if (!c1)
			break;
		count--;
	}
	return 0;
}
```

What do you think?

--
Best Regards,
Qing
