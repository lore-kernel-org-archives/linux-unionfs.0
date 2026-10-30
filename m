Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.231.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793394143;
	b=NLme4LWZAbPNgfIj0KJUYwTMByS/SjXBvdNaJDLR+I3ccQoGgImFLgi6N4M0Zc3bi4Ok
	 xbHkUnsHdrh2Zoqbtx6qjXjS9mGbIVMr9DYCePlkAx9w48CeNeW+vhTEfXQhXrFy7td/W
	 v8SR3hFlBfUnAukX/EtsvqNSjfkne7YZD0JgERBTFfzgFsjgAC+m1fyh66TeVZMbUw5PS
	 jxUqvfsSZbXCynHICsUriXffMu6dQkdC9SWnThJK1sg8DdkafNLqtVrg0IQs7AYkWmuhA
	 38O6ri4rUQkS5rSdP/GmmGy+Zdq/rxAd/9pTelEXlkmKKimXD8pWL7iDuXKPIN97Spw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793394143;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=8B4N1ZSUOdoChEztnUklzFSy/6ZgDKWdxgrzNXlkcbs=;
	b=brS/l8F60VePf3brBfMOe5hBtdYNG8SwGJgdbfqMOVVAjHOh4IOruS807Nd+qX/NVFka
	 ubIjI0vq5Ao5BA7Q8dyIYYYTZ83okXXAYtsqLaudaHhCsI7as+PtsIEZ/n2n+ivR3JH2R
	 As0fwE+yFv+sEMWj1P1xxzhYrz3/Am0pirvFFW2VNswL/S3shQXoVHm+92zs+erfa3ejo
	 CwZi36bONov0RRMabbqLLV30RKjG6HA1kORQDaxqkvhn8KtpkxWplM6qZP2oQFHi31+es
	 g7MHc9RpERTppON2HKe5jFGb+wmnVEVgSwAsW5+r5yeASYxphHS0ik6n8wJWjDZxdEg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0TTYO4pr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.231.64
Received: from mail-oa2-f0.google.com (mail-oa2-f0.google.com [74.125.231.64])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9639B606B6C2
	for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2026 21:02:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9639B606B6C2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0TTYO4pr
Received: by mail-oa2-f0.google.com with SMTP id 586e51a60fabf-44cdbcd53b8so391312fac.0
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2026 14:02:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793394141; cv=none;
        d=google.com; s=arc-20260327;
        b=CYrjJSamE7iZZeI/M2YknEmbMQItpYizmx2yX4uklR5pou6MSGnX/8KVSpEe5DDSUN
         zVAzyDaK04IAvtsvfckW3MeVpkvv5/GHrqjV8Pckoobm4TmHgqOqXf4l+B0jCetNnt8F
         9l++Q0spX/F9WaHAj/nACvH0Q51W0v4fGsres9B5oNJmzUTKaUJHvZnUGnCJPNwGiGAt
         JSStYVSV5L06L4IrQnW5RYuBpctaatj0W1+Eb4P8LZFBCKF10sVzVct8zZkobHEE0/Z/
         R94XsFBcfLoQuwbN3YXuJ6y/pwFm+9C/NpzVtiifxPZOjJPfENM9Zy9Y3BOm/2uMGmzH
         byHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=8B4N1ZSUOdoChEztnUklzFSy/6ZgDKWdxgrzNXlkcbs=;
        fh=GNQf6vd7Xbrqobuil6XWOc8sDzFEf8tkWjauhYowXZQ=;
        b=LTTBwvYBqBOHeu612679urFQ+LDp9NkYwrt/uoRlicaGSPEPwCUTh9xPO2hiZGACAj
         gQDFBpUREh7OGLhji2egmejBp5dUvnY/Fc9/HxZLoRDV+QuJZMPdVtvp8MCwR4hFkC5d
         7bS4gvBbxc+2YsK88jd6DhUH5E9scJ3r8cSWzuVyWhUwDhL/LRejUB+XyDh54kqbJdho
         R2epK6Duv4tKELR+zyW0LmWm9S+kTR2VXON97u56aUKm7smFQX7SBuEYvg45dA4n8i2N
         skwFcAeLkRDu/OLzTzx6rUA8k61oGK8GiuLW72mNhd0XnzvsZfjQD1twRgQaa4oOfq/0
         TkHw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793394141; x=1793998941; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8B4N1ZSUOdoChEztnUklzFSy/6ZgDKWdxgrzNXlkcbs=;
        b=0TTYO4pr7tSRMFpmh9cL/3wpnEVZg5Cm3u4NQqizAdplSORi+UixOYKBq+CZM4+7GV
         8RzDdeon2JvI73M41/8Cfe1pX0b4uI1256BnBNNG8IsvyPThYPwUePQEmiS7PKZn9EcT
         WtSqeyAKd1kxL2OFow9YbwTn+EMVzgMC/jgReQjXfRJrYSGSqHDXaqBAVvOr5mEFX+/+
         uNGvFG5m3dapQO5gyJpscZGzNRNthVlMBVC+TXkyVvhdWnQYM/fuKjhwbhjGaWm0Dwfs
         NANgQdPDcGdSgK467pxUgbhSAxbGW1s0v6TxgOXXqxOVAPwrqm9s+QK7n++O4YsZkEbv
         ka3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793394141; x=1793998941;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8B4N1ZSUOdoChEztnUklzFSy/6ZgDKWdxgrzNXlkcbs=;
        b=WzJKIuIAP62nC7rtVdfsrvwSk8I8Hen1cR6hci0wZDHyYKXVn0SQAySJzSIRLF6qGS
         VFUNS1KOO1WfsayjR1WCuV5/DM/SWcJDk6HebZ1nxDzg96pVijjHJyRVw8ru6+U03iLX
         X7HBbwzF8U90L1PZAp0qN0nIyURim3P3I0uR9gcQdFRU/E3K/33xYhIeN69I8UypPTWT
         LDI8kyahPyuC2B2tUrdIYhlBDugaJzEKv1HmUO3bpp8jdYa9qclnb1QX0EcdO7tF6NO3
         M6pnLTf+9jxYaExSgjz/aeXM46L/68ZA3xXZBBKT64hgreL1WIlLP0b+MXEMGCCOwKsz
         ZZmQ==
X-Forwarded-Encrypted: i=1; AKwUvBzn2PguivSsPqDB9FXizjxQBwldoNblxUkncIPqEoGG/PcIv6wawEjRP2pb7MWEnD4THC4UnF8zlZRNi8kI@vger.kernel.org
X-Gm-Message-State: AFq9FYJVQ7LP3AbhFzduRopOG2Megd2z3Y6K1P/ZeqTZIxZpHoGXZ33o
	mWOshlslqFLwMpti64HnXJp3L/ws/spVq1IzLu9iu5GZAKUOKRHvusiEy3QRAGrFbdRGuA8fd7u
	Mz9bLczfA6swQbTmt4txInBVAISAW9Wnkevx6zQfgqFKk
X-Gm-Gg: AYBFou01RhNKUTpR0Gcb0zPNNm+3JsJDyxaHRhslUPgVThBETuNm5ivPimQJvZyHZmm
	nI7ubSBT1O4PhwFrkfikPefoQyyWUNqdSaMxB/CP13vNxpV2Zd1d6oRBIA1TwWo8jLUD+jTZEi2
	kbpzhuqY6+PHrbVhc0DuP5uZAQXKRlefU1McYSc0N3UuJ/CtlB+fK+aj9GCLPYSEJwG6rOKip5O
	4/NNlTOV/rNKlVxhZfo9y2qRMrM6JaOiCpZsmTFcD8eR8SplekVscOIYIOIWNCk+qkSGoPH4kqp
	38pdVM43BdubkIy9NrAkr0Cv2l3FGZQyGm+c+NV3s1y3c0W0EbPHGIs0o6d0GTTw1xWZjaAKYz4
	tr+ZYC+qEfgJ8O6PgPc2hMBjCyOIu82lWWwF+QXFxnAv+oNtgRanMopVl4iLrGPCz6AL0rQ==
X-Received: by 2002:a05:6808:c1d3:b0:552:950f:3ce9 with SMTP id
 5614622812f47-5640de0fcc0mr2520783b6e.44.1793394141572; Fri, 30 Oct 2026
 14:02:21 -0700 (PDT)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261030113201.2921633-1-amir73il@gmail.com>
In-Reply-To: <20261030113201.2921633-1-amir73il@gmail.com>
From: Hungyu Lin <dennylin0707@gmail.com>
Date: Fri, 30 Oct 2026 14:02:10 -0700
X-Gm-Features: AclHuK8s0Wwz9brUstaJ5S65vD0XppIg-j-1wwQ7MLH45BRDf9xJZWXuVCCjOq8
Message-ID: <CAGEkeHekpqv5ncd8tFP2v-OAy-ujTf9_RBbed3dgmTTAQrsPzA@mail.gmail.com>
Subject: Re: [PATCH 0/3] Overlayfs casefold fixes
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> Please see fstest generic/783 and see if a similar test could be
> added to add test coverage.

I'll review and test the series, and work on functional fstests
coverage following generic/783.

Thanks,
Hungyu
