Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.231.201
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793292262;
	b=zSpGrF/R+BAGfbSgHmK0bTRF17kaF3V43d+eLkmXddEnE4FBuw/09qt1R29c+jsVZUZ1
	 OWc9ehTOU3NEmy8zjIzBy9onKiU/NfvDiY2tgEGWtRa/oV89SGxTFvwSGy6YKkpw75VIO
	 Iq5NHQEpNUJ9DAzkA30+G2UjS7GI8e6fDiqVnrzsUz7Cqjd+8WgnZmNP94ApaAXtymld1
	 xe+IkiHedYgqY2BMWYTmqkPc6yp5CB0SClgFtAu6TNFw2K5WpEYuwNYZGS/9wtzc87PhK
	 ERUjR163bMUHV7/9Xl6C60IHazZx9MA26bmfr/Q7PQpsDk1o2oAlNcB8GxFo8K41yOg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793292262;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=b3+y3Zx9Shf/DUAvT1EB/38PRALBhEtVxrkr32O/5Hw=;
	b=a2D7N1W3kP4c04Zs0vpSzTuvvTfJ/Qmz6A/VkdPcBsvJF1s3xSLRrglMsEIjfBDquQmC
	 wHUVXwc+c4gXjdfPXTDwiIpy71QnimyWjNfimoB+azI0zEbg2WGzQB7EMOnSAaeLcvW9G
	 icZ/53fKu+SQl3JyMITmmfDoUVRjf89ijy1G2PN93aXLbbWEZSs7+Ax4kP8oWPYQxpZGp
	 LwfkXh2NGsLXJQ/2HmMz51vUZ9i+yILx5vEuvtMNEvSPjPc3AXl9lMZ1Nma1UEcl9xAXl
	 GHnuzVxELO8K9ewMjckD2ugb5Enh9+l5RkbWsiaFTk31+eqxDpDA/PAc8BZRZZgoT1Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AAGCmWWE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.231.201
Received: from mail-oi2-f9.google.com (mail-oi2-f9.google.com [74.125.231.201])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F734606A32F
	for <linux-unionfs@vger.kernel.org>; Thu, 29 Oct 2026 16:44:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F734606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AAGCmWWE
Received: by mail-oi2-f9.google.com with SMTP id 5614622812f47-4f47feb5a15so443054b6e.1
        for <linux-unionfs@vger.kernel.org>; Thu, 29 Oct 2026 09:44:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793292261; cv=none;
        d=google.com; s=arc-20260327;
        b=isrKRKAWnZ/cmoBs4yqp4pB4DnutlY2TYyyEuBgMr0ei/b3PV9Ollv7NkYQ/7VY1nc
         PSeJOYCKVQPTWUiQY+97KE3BX1VePsoSaYjJP4HRES+HflG50tq1fYZqkE3jOznPNva4
         0f9+1s+2uEa+MPhtKkl2QbKOQtmOddjk1unvyKk0TUnnxX6FryvEGwmakk0rxC0qjvhb
         f44hTgbcoFJu69349KY+iaUsimlRccdjXpTfBB3o12earug2uzvIQhuIwKQFbN7ND4AE
         LJsGqpBDIfr3ZDJaZyDffDESnD8FD60/XUvkmX8wrfivUjraaSoG2YvvJgyveN8wpuwG
         JLpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=b3+y3Zx9Shf/DUAvT1EB/38PRALBhEtVxrkr32O/5Hw=;
        fh=5Kne5WeymYoIv8lNT3WNZx7lflaN0GYwjkg1LH7Lqgw=;
        b=Rw8NigA7IMiJMA0VsrkcbjM0iqew/kkyf9TYaBr5jasiFX56ZnZH/eiuAHgR+tWjTe
         swJ9l4y1cLQVbQ3XfJesbC8ALdeGwjMT1xpwOavoOqn7Uy/eCF7KwVTQZefABfMubuCF
         9aj727sfQQ4fNSi75ThrsteedoC19CqoWc+x3ye6J01RND+PCl6yytQZelYpCjB/ppRV
         RYl0/rP/MnUUf2i9wqIlesxdJrCSdBdN402K2Kq33gm05HP0cuYOsU4Dsgc7DD0+sOI0
         zjN/7W880PuDmlPGSm8111GLkMRuUIbsQ4vo7x/VsiNjIr6gFV6FQNvCrgPeLa8fQJKz
         MY2g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793292261; x=1793897061; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b3+y3Zx9Shf/DUAvT1EB/38PRALBhEtVxrkr32O/5Hw=;
        b=AAGCmWWE4tApKkseEkuGhwQaDIuvXKoBEP7SRmhW41ihlMKO+4bZhK+iS27ObPnPFP
         W9mn2giAl0C5EPi2aGu5+JB5AYe8vcltVgsTQRxVM8RhAe6cHkXtS0jQxbsHav63AEho
         ycRIJ2opAcbgBREJIKoYk9C84et5Zb7zTy17+mBcnIvdPOEjJoBnfS2pTf71n+qSRQ/M
         6NC7uCig4PX+yFvfQhqaCPpXxbnuvAOs+34gUd7jDS3Vkt5hORPPehD+8JwXuQ+DYHHM
         2vWWCETwhtajHRNsaYgW6iBX8S52a8p1La0IFhDg4RTyLr4Spf0kOPQ8GmAcpB6h900H
         591g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793292261; x=1793897061;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=b3+y3Zx9Shf/DUAvT1EB/38PRALBhEtVxrkr32O/5Hw=;
        b=qMayD/Su81USoZ2GyjsHUytG2NOh9zrpZbfeQcP7bcERM5cNU2zcfLVQLOlpkRypdT
         Z/DSpGWykZ47TRfqaHeDZEhNDLAE85mFa5KjoiRr1woM27chsluLTL/Cuxu36j57TqZ7
         s/U9EuSL6vn/fh0JjbFnbkZS++yd+VJ9AAslfS6PhKNfNJ5TxxcTprlaN6X4Jxj0eEHI
         j3p6YcSxM0m95fneO9ysHcW/9UKM3/Nr7WzoB6dueRXMY2SwmFP9TTnu0sOh0gEt/Z0A
         2wegkxLtp8W2A5MG4KY55FO5SzFwXJ0eYaWWqxJAjStbBKjXMB58goUWKuAbB7M9BqYN
         4lOw==
X-Forwarded-Encrypted: i=1; AKwUvBzDX8EVSpzGiaupeX+b+A+/93yxNcNhUOl7jydTPmev6HUud81GgxQ01vni+dcLHiIoiO71XfDF5dT8yvyB@vger.kernel.org
X-Gm-Message-State: AFq9FYJajMwb1P/QM6IT2gq1AXEvve+x1WGGTSdfDRRMfQWjedWakqW0
	FyyaPQr3OglT4h/kaBhk0ZyTGFNHRU0EqtS/lmzWce8A8k3507RX/Dsh+gcRQqFk/RPFZTbc5HJ
	BufN43dhuYubmvyQeL9sMKip2XRRtXIs=
X-Gm-Gg: AYBFou1EHfBlaasPdV9CkcpCT7pACWTL3kYctE+bmyCKIbdRATWYcV2EGBn7OwEvtE/
	BuqR2K/gn4cgSkl7BFp3vdeAzZidPxJdvstg0ZRgnNG3cE9GGXyJpF0/7R75pgdF4L4c04xxm/v
	GA9T7hhv1QqtKZI2DNFYBB2sL9RMj7juANQgFqomzsTPnf76fmiqqDVpDNWW1SmLqpIqtdv+0wU
	RJ8gWa8kiuFGjMyX/HlpCVG6eib7xgIcbAD02OdWUh98h3JuiOXKGlgCkXqEvpo8dllE2tNEBqF
	z2fEhJXJiZjkTbwrN69xSQy6BjIfhW+D/lzgfWvpi5mYsFQe/aoxPZi9rMS4kWbG4Bv16GQhOR0
	AavZNpwEpnj7jn8WlAuuMeRrpr5Fi3mVZZZ+lr04n7Fxv/2dckRCM/GUGSUwnrZ7p21G1gKDM
X-Received: by 2002:a05:6808:3197:b0:4d6:90f3:74ae with SMTP id
 5614622812f47-56384197794mr4379953b6e.46.1793292261209; Thu, 29 Oct 2026
 09:44:21 -0700 (PDT)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028154008.67451-1-dennylin0707@gmail.com> <CAOQ4uxgDmhddqpFawaK874cfWCp4jVDnE67eqXyDA9eumpMEpg@mail.gmail.com>
In-Reply-To: <CAOQ4uxgDmhddqpFawaK874cfWCp4jVDnE67eqXyDA9eumpMEpg@mail.gmail.com>
From: Hungyu Lin <dennylin0707@gmail.com>
Date: Thu, 29 Oct 2026 09:44:09 -0700
X-Gm-Features: AclHuK_1sASlVUtzDN1GpkTnsvtyNbxnOAThii4_r-uX-r_SWsslPNQvF3mBN50
Message-ID: <CAGEkeHdXVTQU7VS=TxPqmsXMtFFeP=LWw-y04NmcRWJrwHa8mg@mail.gmail.com>
Subject: Re: [PATCH] ovl: restrict casefold consistency checks to directories
To: Amir Goldstein <amir73il@gmail.com>
Cc: miklos@szeredi.hu, andrealmeid@igalia.com, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> I am asking because I got some patches for overlayfs casefold which I do not
> prioritize because I do not know how widely the feature is really in use.
>
> If you are interested in reviewing or testing said patches, let me know
> and I will send them to you.

Hi Amir,

Thanks for applying the fix. Please send the casefold patches over;
I'd be happy to help test them.

Thanks,
Hungyu
