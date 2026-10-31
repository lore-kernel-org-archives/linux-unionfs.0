Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=74.125.231.200
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793439523;
	b=GCZ5rlIpKkwr6I8S0mkTQIU5N9PvbIZXGcXpJ8qqVw+0HyKhtPd8oqk11dYI1z6gLoAx
	 YtZnr9UJ74bMCuXYyT5Il3bAh6ovWRir+rSD3Q3bKx9JYztpMjF8gCABJ/oT8Bc6GKUGl
	 oWdHmLw5UqDVVHq7n1rS7NUT/28nnL6aI7URJHq+5cRKYYo30SuCbCr1aDmfKhuQ2TU4N
	 m2quJufemnBgQGzh+Bpa/XLl9dGEUdNr0aOl/gWHvoxCB5AylhcIpd6vTrtfK6RyMKJPe
	 IAe7WvtHgk1AY4JYIxByVcC/B19yG23iB2QPMJCpOV9OZHCfIxvkKZ+OOljSHKXtjsQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793439523;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=buIMJ5khhlxZO/tz01EgvSDikePfA4MPtrLPE3r2Xoo=;
	b=JD4QuiYZ3TbxudOZapAfpSX3CV3KmnvM/DVYkKPD1Aqw60JHBzXgjasBnx1R+KMZDkcy
	 nlBnE4rK8KWfQ068KMwPWwvzEEFoJcL3f6FPTZrOi8Y9vMZZBb0IHfdFFYSqMdqgYqWBM
	 lPlo3m4KGUDxfWKT3Tv5zqCzjMdH4Gx2h9PAm3bCab77fEYpTg4bF7Gys09Ab+RlXHq6L
	 0GwL7L7TKnB6Xa0d/M2VYsdeJQIFmh7SSz5TBCvLsHbqGHn/iMsX8FMimSD2jOBZRatug
	 U39qXB6kcPihJyDh0HOKL3bEKbRt7j2p73oNR8OReyUWanVJ8s9IXiVFstodu5+7fcA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z+ZroPjE;
	arc=fail smtp.remote-ip=74.125.231.200
Received: from mail-oi2-f8.google.com (mail-oi2-f8.google.com [74.125.231.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF90606A31A
	for <linux-unionfs@vger.kernel.org>; Sat, 31 Oct 2026 09:38:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FF90606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z+ZroPjE
Received: by mail-oi2-f8.google.com with SMTP id 5614622812f47-539edfadfa9so686241b6e.0
        for <linux-unionfs@vger.kernel.org>; Sat, 31 Oct 2026 02:38:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793439522; cv=none;
        d=google.com; s=arc-20260327;
        b=bBthK1SXpl/F/LNoiaFT0c3+57KKeHJ5c56kxwvrdQO2yfEqHJ46WpuwfBmMSMfUAz
         UaOWFFk6tETc8Wmy+uLGANFJrr0FRgB4fOKWmEHOm9MP9DzkBX8Ol02rdsIZ77HtT3rB
         ju1qDvegx6Zb8peZxAyziB2ww7ov5o85f5C+YU3iUVAwymOuaJxBLJDj6RLw4ObBeEE8
         CzmQXktJYi/cMPCP6WgSzesJipcPZdq5TdKy1VjF1dQe9E++xPI4pRf+Fco0DwRZCVdC
         lZf3JrHbPyfqLZfKFPM2oLW+OSa7HN+eHjmnBuZastHDDGSr8Aiq6KbULYZ/UxyIZuN+
         UhCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=buIMJ5khhlxZO/tz01EgvSDikePfA4MPtrLPE3r2Xoo=;
        fh=T1IyPSc3N6fKCmw+hYjrrk72+QB4Beu/4NIedtlAg10=;
        b=klqm2Q1CtLsrH5RP9oW4r4Zk9Pc6tlZJvGzzTPRhPeHnQeZ2tPQQBb2sLJScnH5R6Y
         sqGjFZvAhWi4WrL41LtvBq//AtiOFacUJbkck8PFSdBnScbGM5gRtD5aABJUl5eQBHYI
         d4UQlS9liOoVFbqL4Qsng+fhsLNG5U6iE25AJdSxjHzfDq6BMCzrxcJ77TmPxDQFQ7jc
         n5aIAqk46hgKnr+KiyNHo5lf9omppSWqTqlP7fjBDsjXDFw743+yN/NWRCz2O8WmDbSh
         fAA9mfku/2tPqkqaFA4NwEOw+m55gphCMGZ8gQwNfd9I4KJQaOdCE3u4DNlwegpSJpBr
         YuPA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793439522; x=1794044322; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=buIMJ5khhlxZO/tz01EgvSDikePfA4MPtrLPE3r2Xoo=;
        b=z+ZroPjEl0WIHHyNp/2mV+NdrASbrbEojkNmcD0pev+mSvG5dpobdz5jVABf/kXpzh
         qcKagIaWRxcVlV5UnTxhzrwTPZFIX8LB8iLhsZZRMOc7knbJDvin9J8qo1RgqvMwbZaG
         6Kd5H2Htnyoi+XuthFrx6PyNrF/lx53XIen07z20W8zjMtZ8tV0FW2qPxcltgcKvd1OG
         F1vX29rS2ryolmTlna6BlvwtCtWkR5xKNbzYTmHhRlGPwe2sFMLXwkr2LpMCkosxrlyf
         7nQ0m0INErtSIEFJ7zSKGFgyb89XIZxegwPqTkVZB53/iNvwOJweNyG7Rs98uRn54rZa
         Fsmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793439522; x=1794044322;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=buIMJ5khhlxZO/tz01EgvSDikePfA4MPtrLPE3r2Xoo=;
        b=esQAcHf46XvQV91s+TnaeADhVocVOMBYped6p/8gwanHlf32GKz+/p0VL3redvkYOJ
         HvymxLo3GmDFf1LhEr0Uj3McBKoO/j2+HndStJmARjIhgQYJyuxBX0zFh74/21iCqy61
         ma8U2HXP+xNWumd5pGsiOBms/hbKgnqlPDjlSF+wWcSlM+x1gzqsmAUNZfPM7ch/J0B+
         LC7N5Gmuv7HZfb8t1hysn6OrXlRjZjwoXEu6b61QpKvVLwxVgwgT6Xpxu8Zb05/5I7zs
         AisUuR7Q1tIKKj1aZ9d6LQB0NweDa2XSaE+eGX2B4f6I7tq2/Jb5M9A2hamjsROrEydC
         +85Q==
X-Forwarded-Encrypted: i=1; AKwUvBzaZtgB8ZcMoKlELhX5mqxV7KFHIyu9nJ4vbKWF+HjT70QTnVho/i4c3eQMWY0F5kYZ70X1yaw2DyvSIhXm@vger.kernel.org
X-Gm-Message-State: AFq9FYIuYjzL6KL0U7PslaG8Y3TpLX/eLaP/hSWLGHQs6EoFChT4Ge1K
	mz40ssGM3f+5ZFrzOPTZF0TtXdnCI6FPAiCGg54PR5xqt20qL/t/4JrHLL7aHpna3jgzlgWF1x7
	Si6yBCsP8kR+RLXuZ/DlBDP3K/vbo+2PEyiDXoivzEhhA
X-Gm-Gg: AYBFou1a6KYB78OXPRNl7h3NoA2okanTqEwKgg4MQ8zzkwt08gJi3VLeYj3HTjGPy/t
	bXHUy368D9xFARi+a8wW7FFtjxgT54P1LPwmSoNC1Thy2qEYOz3woJcHwNAYvH351mSTv8Oi5A6
	1+t/1Ta/pZVtAnKB3H3raO5NDjvvsGOuXj3Qci0DdBswJ5utUmzbmLeabhH/iRj2pzA/V6ZtgFQ
	oid2uSMXmNLrbNkoxiG/MoupKP9UdsLSTeVFAj5mek9DwCTJmpZz3L5quUbgv04cwdbWWSPW5X7
	Of6Zkj9rNSJEHPpkb54Qu5wg7lNalFz8YiKT5T7LOxhafYC3RpuWjeG9hHH+tU24Sv6XU75baBG
	RTu8Rsdw1YGreLQoXZ/RFeXc7C+b9HfIRh0y8GHnaXl5rfSiZEcvemDe6IuVNNI53RNzzEds=
X-Received: by 2002:a05:6808:2e44:b0:4f7:d324:bc36 with SMTP id
 5614622812f47-5640decbf43mr2997896b6e.43.1793439522296; Sat, 31 Oct 2026
 02:38:42 -0700 (PDT)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261030113201.2921633-1-amir73il@gmail.com> <CAGEkeHekpqv5ncd8tFP2v-OAy-ujTf9_RBbed3dgmTTAQrsPzA@mail.gmail.com>
In-Reply-To: <CAGEkeHekpqv5ncd8tFP2v-OAy-ujTf9_RBbed3dgmTTAQrsPzA@mail.gmail.com>
From: Hungyu Lin <dennylin0707@gmail.com>
Date: Sat, 31 Oct 2026 02:38:31 -0700
X-Gm-Features: AclHuK-X6GKlHTisqtiHyK9eKC4cZ99r0QQanZe3vnYDJQb2Sgwxn-ctseguvNY
Message-ID: <CAGEkeHeBcz2Atc7zz6u-Evd40+AOBtx9Ke+REthvTppxw-vpRQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Overlayfs casefold fixes
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Amir,

I've posted two tests to fstests, with you Cc'd:
https://lore.kernel.org/r/20261031091948.18985-1-dennylin0707@gmail.com

On arm64/QEMU with ext4 and tmpfs, both tests fail on ovl-fixes
(1d27da7de3f7) and pass with the series applied.

For patch 1, changing the empty upper root's casefold flag between
layer setup and FSCONFIG_CMD_CREATE triggers the WARN on the
baseline. With the series, CREATE fails with EINVAL without the
WARN. I tested both directions on ext4 and tmpfs.

I haven't run the full quick group on overlayfs. Feedback on the
test coverage and structure would be appreciated.

Thanks,
Hungyu
