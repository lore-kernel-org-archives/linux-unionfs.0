Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793817921;
	b=BwlKLzPTJSckb2elNEDgy3sbjxxYN/EkhbPzr57IaYt/LBkUr6dxW9xk5dTYtZXXsSz4
	 rfnMv89NJSYetILWYg4BULsA1GR5W3oBsX17uwFC6VXEIhS94VjWj4jriD2Hrim6VrSga
	 4wuEeARgefsjTa1o1cDreyx0GvEKvt/IVWfaXFoAzCa6gzMt0SMZyVUmV7HuYjVnvgu3t
	 7bfZ90vgbefTxdXj9a3EiQp7hW+pmneYj+KtFMM6OY226grJkAMRXx3ZwboB1K7YC3EY6
	 dZDjqNHzpp0mRVcJqkRfdSq1XDJIgOLmlVzOFJvKnOCcxkjMJTlJTi8DIfTxYeyhT7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793817921;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bH4YNBWdLzzdq7NSXPMFm8Ng1HqXQF66xJz3klxPR2U=;
	b=0dCN1NbdWY7/gVGCiT/A+ck8V5Csvt6lMsQ4j5RRJbWr6BNUJYoNPx4nFctC5Ho1py+G
	 AFzdEJ+BAh3wmXP/wMzDCRwzqBu1/ZtYCG1m5x6zk9ZMFCeMzPbrtVj4pTKUNQis6G+RN
	 JWkzSGRZDQ3izjDNPRK8h3Obt7Z2aB644zzZSAZXQXl9mJaDIVLAN3z1OB+O7f7xmlf2S
	 lmpcqsP5fnbcSo+r7wdS+EvG7YfHiLfCyxx+/W5Nk2cmx0s0Qtz4MtC/MFyA9TyCyqHvr
	 GzE3ICPDe5J8NqtGIMxUKY85pM34kjRQyrAtAlKvXasLC1Pmj7g2OoEZ8uprXkL9SYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iqVTGonm;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6AC606A32F
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 18:45:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C6AC606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iqVTGonm
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a35db1f202so8300805e9.3
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 10:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793817920; x=1794422720; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bH4YNBWdLzzdq7NSXPMFm8Ng1HqXQF66xJz3klxPR2U=;
        b=iqVTGonmqyNFhR1Xrwtb5i8rIqkK5GzumTD1bJlGDfbOEiJNTXNkdgDv2F55JOvDUE
         R0ALaNnxKeDV0HPP1YrG4A5wr95NwlcksvEz/ByRU8GrtMcsYeKDDS9+Bsq+FIsYXkan
         IGLQt7l/LwchC1dhYDMgnBD7noYkncgj7uvot2kcGc5MA9QR0dEM2zs3NptTQMpSkIxM
         xTryQdhELSgtnDPB/hw95xEoZXsRmXf9q9MvaozgZWXK39qaktu8bLcXVFI4pn/XGi4k
         BpOG9gnUnLaDld8ikBmoLeb4HQ2Mbu7su9yEUH9Uy9ms86rspXyZwlhbQF98FkRoRP1N
         iaLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793817920; x=1794422720;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bH4YNBWdLzzdq7NSXPMFm8Ng1HqXQF66xJz3klxPR2U=;
        b=CxxUNTn5rsAgXVzBkLNyFkW8xQN9AplWt0x7aIgyW/W2PYacW0FxLwalanHqkRCfEE
         qVmkZRrjiyPgv+BGDbX1F0KEuKvUEk4KAdfGsX51tvVaIN/1ARV3B557l2CgRTDe3hBT
         tsBfpQ5folZydP5pG1149fBTC2m3oEbJjPBUxNLPPhGQsEDndd7hhUBfgorKig040sTT
         SEQNKJwUHh59Bj7cShcEF+UMunuCJlIPbH8+2QmYGVFK9pO27qlYVcKMdJV9ByIVSypF
         cv3phbSR6b28IejItzkZeEwb+o8LoAc6W9niZzxzq8y8P2dDEe+LxioyC2fer5rQDAeA
         VmJQ==
X-Forwarded-Encrypted: i=1; AKwUvBxVHrUOFWbCyP5WPgwTg1yfimmNka0Sl5EeEgiRTweGRxBBbljzYWD8omdW2CGFiNPLvcwoNfh2WqUdVuId@vger.kernel.org
X-Gm-Message-State: APuU4Z+BQFe8gydKVumdEOqFDUk+Wi9bI6rvhiFLTXbDUZOFRwSDnxPI
	Pg+Cep4CDR3QKUD3koykcv5QPj0PML/YmjwQJDTxqgdWDYUBYetUdOd2QUNnswck
X-Gm-Gg: AYBFou3UF/TrvdvlT30IjVHQ+WZdUczMRKjjmWYXyH2GPstxFUmL7MFT+gMEkz4w5vc
	IlL2e0Wzn51b0bZjHMxruK+3BbtNHcX+mxbsKMJXib/N+GN/sCR6sbwbdIjZcndEU5glfSCMi2U
	bmMG0+HOZJFI4Kotw5Omw7t4jPvHDTH7m/4iQmJih9gcxpw8q64LZElB0p0gBgELHe4aFW/PJ9e
	zbWaYj1trIJp2NP+8srkm45R0HG+xv/ym1Knrhlrnch4ieJGVP0opwgOWLy5OzM2xCedXUnJYRH
	KW0hGMrwpE5iBm9Hi6OHPY3nhDKAVHbhw0gG2vXgIyPLtmATkllACiXeR5mrv43lUm3SdZXK4vY
	fCKfLf01E13ZW8iNqClIFzQTyN7d4siMYj00scjdjcyVhd9ZS8pTzEgHdJNUPz8wQqJDUOlbi3m
	57mH2rSncntTJC1D2A07B1O7p43y4CsguaSlygrm5zNG4VYR1pXt5L9NHdG2jO5jqpy8lYms521
	lyoVMGxT5IuhTHzUlK/pEO5dsU/z8cr5JCdyep49zwp420IR9fABz1z7tWH5oh8aJyDA785I1qx
	Fsx3L96S1MdLf2v8fIh9xM1S5Ai0DwRWNE1OXYONfYn9Q/p1gmcKMGypomIP8exOMFtxEf6iX0Y
	6UyARped8slE=
X-Received: by 2002:a05:600c:198e:b0:4a0:2488:71cc with SMTP id 5b1f17b1804b1-4ac1932a23fmr388390675e9.32.1793817919580;
        Wed, 04 Nov 2026 10:45:19 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b4527fed5bsm96022115e9.3.2026.11.04.10.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:45:19 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: [PATCH 6.18 0/3] ovl: backports of fixes that failed to apply
Date: Wed,  4 Nov 2026 19:45:13 +0100
Message-ID: <20261104184517.3630089-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Greg,

These are backports of three overlayfs fixes from ovl-fixes-7.3 that
failed to apply to the stable trees:

  e34d2ef818e4 ("ovl: check that the parents of volatile/dirty are dirs")
  16d319e12328 ("ovl: hold a reference on the parent in readdir")
  f635192ad223 ("ovl: do not copy up a dentry that was removed")

The same backports are expected to apply cleanly to 6.18, 6.12, 6.6 and
6.1, so please apply this series to all four trees.

The patches do not depend on each other and can be applied in any order.

Thanks,
Amir.

Chris Mason (3):
  ovl: check that the parents of volatile/dirty are dirs
  ovl: hold a reference on the parent in readdir
  ovl: do not copy up a dentry that was removed

 fs/overlayfs/copy_up.c |  7 +++++++
 fs/overlayfs/readdir.c | 26 +++++++++++++++++++-------
 fs/overlayfs/super.c   | 16 ++++++++++++----
 3 files changed, 38 insertions(+), 11 deletions(-)

-- 
backport
