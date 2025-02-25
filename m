Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9238A20CCD3
	for <linux-unionfs@vger.kernel.org>; Tue, 25 Feb 2025 22:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740521675; cv=none; b=a1G3KPSswkkgIwYHsofxfuNvz6V8tb8mS0Eo7ZBDj6+AkrJE0MFCzNhHd2uKAldBamtgPCDCnnNeYPVK3QmIOTiyI/95W02gMsId63ncU3jNnVNsY8GVgjF5iUteX2682f+ERUTkLi6mLkJmIgw56+I4G1p0qXSxd9rbVkecigs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740521675; c=relaxed/simple;
	bh=MDGLRB1elogkq5ZS7O3/EtHbyE61wRXahwAtSkqJ0aw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QswyQZPaTvb7QX6HH3IshlrjTBsM54qlXhKf/L9ljLVVkNKtIjwglyKEMKWNFmGfKtV2UDcdPqTgRIeHH3+cPE4ApuO0hqdJq3vgQiI/uwvY+8BKCIzOH/7sTLoP2tCl37bvRAu8qFkaC6TRGqkNUEZDaQQKBc0Ee7g8WR3WsyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=HKHrvHIP; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="HKHrvHIP"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-6fb95249855so51228497b3.2
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Feb 2025 14:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1740521672; x=1741126472; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MDGLRB1elogkq5ZS7O3/EtHbyE61wRXahwAtSkqJ0aw=;
        b=HKHrvHIPGOs1LAPhaKGNVYAN4p1hSmui5H2x05WfT8rpf/+sxE5cNaJe4j4UPShABd
         QdglBIJRHJlmFTsh0oXtBBF8oK31iko2mj5XAMfkURIXlnHuNViYHY6r4rtcvAFOoCtI
         iKp00SFOYRRF4IrIH5cz9W1tHw+QlEtTRXMqgiMh24y1D7JKw+EngatYg/Lh+9uAIW+r
         B1jSUsbiiMY20xcsisZek9Fjju86noKydwlAvseGVqLwOeC4Pci7nwp+jLZt0Uf28mO8
         we5gSJFCqE0NJTVwC1+55Q/k4JgavG3yBljPZJ2worsbEqjsdGQPxVIwT4TwA5Y2IM+5
         ukpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740521672; x=1741126472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MDGLRB1elogkq5ZS7O3/EtHbyE61wRXahwAtSkqJ0aw=;
        b=hUOMU7fseHvtyl11fQ3tJGYNOvhzYhCJ84tljtRUD5EiJNoFwxN7OMZMMQEhaTh9Ql
         LKNvLgPCKKWJaMdhRsFMXcY5qshuTnQD72MOo4SHeDlN0xVE0NHgBHS/X7DhL1VVjr1T
         Mko5cZja0RnV3fo21w4iQs7eP+aIioITf8x70vZk3xHHT1JEvny/c2UoZIZmRbReISwQ
         eK7tUPe2IBSRWjr1a/hVRx8WEDViqLPGJaAuXa44dHBd1vnGFE4hFiKy9Id7Z2N3JY0E
         8lhmIE4cDFF6yKYfRnlDlIjgS5v78Nhbwq7PfCi6EPZM32WjcCkhYEQ4QmUFG9jJFF57
         Dqvw==
X-Forwarded-Encrypted: i=1; AJvYcCWoReGovOcS1qjdEhVC2nw7jRsaG5r36Ua/M0pOPvDqGTfePOhQbkTQfEz7zbtWoHXfG/NhhiHW1sK+ZcbM@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0LVQ9cPcnmGN5iiqzMB7p0pjzFoWkdG2oM/A+VqNR15hcRe8D
	cuGCR7eolV15z5W1M/azXNMl0c24q/FG6OZx/2/KBd/UG4I58E0cJnAqVub6MHEEfrX+iCRBNhJ
	/q4O+n1RYLnT3q7eLC8yfaL/iEPT22kigt2vl
X-Gm-Gg: ASbGncvcsL/pJDPRrdfs5tliCAibAz3HUrCWFKWCE7u51AXuseqyTUVDYNFOfHUjA04
	wLsw8rlyHgoG0k+yAok/8XC5sPn3/H1nL2d0GlAxmHgznknpn1iGzitb93/a16b/GgpsY5ZzrAY
	0IbWfCASQ=
X-Google-Smtp-Source: AGHT+IEq+q/3SNBzxXflir8s+6QdmuMLr7mPJKzm7/BUu7IXjxCgJ1uEovP+G+hSJ9QqgINvHv7u8FQo9Dm4e0gAv10=
X-Received: by 2002:a05:690c:312:b0:6fb:9fb2:5840 with SMTP id
 00721157ae682-6fd10ad8d15mr47580827b3.28.1740521672571; Tue, 25 Feb 2025
 14:14:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOQ4uxhxQfFfrpmRS6tOv5ANVug6d8dGx6Hsc7MYYe63sUOpcg@mail.gmail.com>
 <20250225192644.1410948-1-paullawrence@google.com>
In-Reply-To: <20250225192644.1410948-1-paullawrence@google.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 25 Feb 2025 17:14:18 -0500
X-Gm-Features: AQ5f1JqI7MeM_scLLuLOFY1u27DXLEkWvnLakhLURvGM4cGQ0eQrhjUWTYnMN4E
Message-ID: <CAHC9VhSu-034tguAKj+rptYB0w8D9mtgmjbDgLwVc-bJQcSrBg@mail.gmail.com>
Subject: Re: [PATCH v19 0/4] overlayfs override_creds=off & nested get xattr fix
To: amir73il@gmail.com
Cc: corbet@lwn.net, dvander@google.com, ebiederm@xmission.com, 
	john.stultz@linaro.org, kernel-team@android.com, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	luca.boccassi@microsoft.com, miklos@szeredi.hu, paulmoore@microsoft.com, 
	rdunlap@infradead.org, salyzyn@android.com, sds@tycho.nsa.gov, 
	selinux@vger.kernel.org, vgoyal@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 25, 2025 at 2:26=E2=80=AFPM Paul Lawrence <paullawrence@google.=
com> wrote:
> Would a patch to set credentials during remount be
> of interest?

Amir mentioned (in a html email so I'm not sure it will go through the
lists, I haven't seen it yet) that Christian recently proposed an
override_creds option using the new mount API, does anyone have a lore
link they could share?

--=20
paul-moore.com
