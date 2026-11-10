Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.25
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794320055;
	b=Ap73UMCTmmNc789y60rVT8MumovXhwSKsauX60t8p8dwUWhYIW1o7Urr1GYVZuK+cJKU
	 RV5gmRWwfEvNVxYeEwMqgQuJcjbVsg+0k4rS4a3aKmaFldAvXBhywnJMd/0+b0VMZhA6x
	 hjMbYJfrnP4kva453ENioL2CYbpRH6Z6Wh3dCeazj3XrkxMo75Ntv3A1r8kwKTDaFoTXv
	 o5n99GBTkunubBxO7GyuqoDrWARs0dRHn4gTO2vxDjwApjY8iJAk1PijU6t5iO8VLqAo6
	 5ZSprmqCGmClW0BL+eiE9G45IMjSqZrDLug8X4kS21/B9wFhDrTL5y/HRwLBrmPvDAQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794320055;
	h=DMARC-Filter:X-RZG-CLASS-ID:DKIM-Signature:DKIM-Signature:X-RZG-AUTH:
	 Received:Message-ID:Date:MIME-Version:User-Agent:To:Content-Language:
	 From:Subject:Content-Type:Content-Transfer-Encoding;
	bh=gjclLISK5NIv3ZhdRcJY6KZPvT59xm2y/B5BrmPqwUc=;
	b=4OzAbBL4rRNaxSjORT8m+hETfCRkJRW7lSguq5jZ8PGDMVE1hpv3v4wuRFAy+XM/2Jmb
	 8OsLrGkidX6SO38LNxXogvHpNYFKt+FR+bvyaH2V0+t8hZKTD2mRLNGwrr5OY4nrZFH0F
	 5XXOGdtDaNdh+Tx6pgLgRZOfpbqcSBJuV+rgbAkeuzZGfkUu2BAjZAv8tz0SkwKetcbQJ
	 QrY0uvaeaKiDKX7xPvfaU+0ccTP4QtOiW2xzDLxS1FoHUbSvJ+V6Gac5fRi3WapstZI/y
	 6T5gdXrCYqeV7m1YemFfzEhcJnLm33PxZDbjnAepF3AzSJ3HzpQ/+gwawiRupM3fpYA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infinite-source.de;
	spf=none smtp.mailfrom=infinite-source.de;
	dkim=pass header.d=infinite-source.de header.i=@infinite-source.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=FB4HLd0F;
	dkim=pass header.d=infinite-source.de header.i=@infinite-source.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=AyPTfATu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.25
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98CE606A321
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 14:14:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C98CE606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=infinite-source.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infinite-source.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infinite-source.de header.i=@infinite-source.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=FB4HLd0F;
	dkim=pass header.d=infinite-source.de header.i=@infinite-source.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=AyPTfATu
ARC-Seal: i=1; a=rsa-sha256; t=1794320046; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=DT4BLM6aHODmFTWUBSWi4Sn1Q6+RAZQXtfQV1HysSrZ8p14VJlc8w/WtKuqrMHjEi5
    Y/XuZqlbPCHi9SCMyrl0g1D1kQq5yAxEnTc2O4lbYhJdsfm0e+ExUBUljpqXxt4jrAVZ
    oe6787NQe724Sbo+CLO5oiq8MyilnpV2k/nPR17JrJ1GZlzM2owaGak389uU2d/EtY5z
    TOIH5UlKOAJMRSUXmxOn7v/ev4S/upbS8RzyKGjbuTLZJ5kulFICK64BHBCMLjJE3Qpu
    HDta+Az3uDN2aqT9KEUHzYK3dtsejFufF2MnD2HMfyvQN2SNwr96MZ3l9n5A8agOcVmV
    NNdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1794320046;
    s=strato-dkim-0002; d=strato.com;
    h=Subject:From:To:Date:Message-ID:Cc:Date:From:Subject:Sender;
    bh=gjclLISK5NIv3ZhdRcJY6KZPvT59xm2y/B5BrmPqwUc=;
    b=iJjULznzcLA3w+AHNCQsFeOMgaIw5j6SUiwJgzLXER6JDBi4FDaXV2ZCmaxS5my/Mq
    mKoPbEb2fOWzndKCkZWxX6DsWV+iZlchirmTrp5SWlQOJ8tJz1BgcrDT/yFPBkhD3Vgi
    ow1eOchF/4/eY6A/jUfzp8Y6UrXnNYUYo/56UHCP1C7fBY9T8UJDmf7Kn9s3frxYFSe9
    ymEJkFB3i3mx3+6CNJfAFgq7jFa+jeWsfmFzyD0IY/85z+VPbL/jclYJyMyYs4W+lcPR
    I8jSn9k/AB5L6yoY5B6fR1gY14qADD2jwS3XUpSLeemkwCVA8kMEe00K8mEnpkcrydiV
    zTMQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1794320046;
    s=strato-dkim-0002; d=infinite-source.de;
    h=Subject:From:To:Date:Message-ID:Cc:Date:From:Subject:Sender;
    bh=gjclLISK5NIv3ZhdRcJY6KZPvT59xm2y/B5BrmPqwUc=;
    b=FB4HLd0FeGMdAAFPZxbxiFy3GpIm+exyf01TmZlEGL79DWvo8/RIa2kcVHBANTvQpG
    kqp7FVjuMqmBFOWlwgNy3vTfC1TvJPbFsDpnHHJBkmA2QssVgI4i6Aqw1Z6lsNMcVpa1
    eWycSl+ji/m+uUMxWjz9PBuuFB2aIpgB5pji1Jxp/M56xsatm03FUt0KDqRJdzV3f8DN
    57ZOUtju0k5yeMCsFcE7AmBUVeX2kEBxUrnDShrk0OLHacZUN3bAzb+pWcG3w0kEvClu
    WA3ifoCjBxfMW4COEVk0obRa1qljX/JPWWPhCDcCEPV62GIaG7W/y4TftXSrqPJj+i7O
    s8sg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1794320046;
    s=strato-dkim-0003; d=infinite-source.de;
    h=Subject:From:To:Date:Message-ID:Cc:Date:From:Subject:Sender;
    bh=gjclLISK5NIv3ZhdRcJY6KZPvT59xm2y/B5BrmPqwUc=;
    b=AyPTfATuquxOVKjgjfPYMPkcGX2Z331t0W0SOPKTq0BjAj84hHqyjcwg7rXRL0LPaQ
    EUqjEEDkxLhA2XyKuYCg==
X-RZG-AUTH: ":LW0Wek7mfO1Vkr5kPgWDvaJNkQpNEn8ylntakOISso1hE0McXX1lsX682SOpskKNgu1vdp7pXN2ayNAkRDsxQSTmpkQWHBbl7px9idLshhUPX/aty2rBIg=="
Received: from [IPV6:2003:de:f71c:9000:bfd3:365a:67a4:83aa]
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id 2fd1142AAEE6VqT
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate)
    for <linux-unionfs@vger.kernel.org>;
    Tue, 10 Nov 2026 15:14:06 +0100 (CET)
Message-ID: <412ffb1b-f3fc-429b-8d78-8b1a9e8d86bb@infinite-source.de>
Date: Tue, 10 Nov 2026 15:14:01 +0100
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-unionfs@vger.kernel.org
Content-Language: en-US
From: The 8472 <kernel@infinite-source.de>
Subject: Bug: overlayfs does not honor pwritev2(..., RWF_NOAPPEND)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I have observed failures where a positioned writes using pwritev2+RWF_NOAPPEND
on an O_APPEND file still appends the written bytes instead of writing at the
specified offset, contrary to the behavior promised by the manpage.
Github support confirmed[0] seeing this behavior, specifically on overlayfs,
other tested filesystems were fine.

Context: I'm trying to use RWF_NOAPPEND to get portable behavior for the
Rust standard library's File::write_at()[1] and linux is the one that's
not consistent with other unix systems.


[0] https://github.com/actions/runner-images/issues/15277#issuecomment-6768886675
[1] https://doc.rust-lang.org/nightly/std/os/unix/fs/trait.FileExt.html#tymethod.write_at
