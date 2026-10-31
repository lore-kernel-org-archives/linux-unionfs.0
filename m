Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793438402;
	b=OgukniQgTOeK11BaMLUtp7A8ABPz0GxG0pbka8tVUDXMFAthprlkaP2Oy/PMbuqOwLNI
	 WoNKOSot27Kcf6lJswCA7YgQzGmnZJkysIYj9KlMEMnBA1NRtmAZppB5BuUT2AhEqkTlA
	 DD0JxFVtkPFhGegZVdE4g+INZbjemlffqIK/yxiocu4re3PUXmbRlvDkaCxu+0lfKgVwW
	 FxmyUnYpiztxcqIBxDP6ywbxWi7X6jV6lluRTeyFUSdlPcE9X/Q7+1c46KDE1JkcqUXQK
	 Mfnx5AhQCbkA5cXUmrvHBezNxDiZ70vUduzdybF0exkR+v2dBQ/dcg+JJPr8PW+e3qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793438402;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=NgXyymUrfmD9IrHRZPUTZCn0Xdv6r6cUwaDRTXWRhcQ=;
	b=G3FACRIp1QY117/31nqrlIRdyYFDHxFBu1QKqlgGNgTUVxiq18C547X6bn24r9WctvyF
	 9HxEtWwQ7APpOUIQaiFBuwq5Sru64EfBqhwOuOiP53HI7p/2QHptnKJSkMrTY4JS0wbXX
	 RAuFFpWjkDEQTe6hc4m3slxSlFolCdaVYi3VYhHu+90EblaXWND+K+w8Aa9orzPKv6IEQ
	 Jrhjp3GBSFNKtJ7BdK/SuPYtAwGDixR59s4+RRjSUWu4Tvq9TwXkM03OMlnxwa/py1+Ue
	 INjGO5SGT8J7FazYz6Qt4ByAVgBfpCrdbcK4HduHkj/f506XvfTJkc56OUgQW2tS61w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FfBW7uDl;
	arc=none smtp.remote-ip=74.125.229.7
Received: from mail-dy2-f7.google.com (mail-dy2-f7.google.com [74.125.229.7])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F39606A31D
	for <linux-unionfs@vger.kernel.org>; Sat, 31 Oct 2026 09:20:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42F39606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FfBW7uDl
Received: by mail-dy2-f7.google.com with SMTP id 5a478bee46e88-33e5ae86ff2so736009eec.0
        for <linux-unionfs@vger.kernel.org>; Sat, 31 Oct 2026 02:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793438400; x=1794043200; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NgXyymUrfmD9IrHRZPUTZCn0Xdv6r6cUwaDRTXWRhcQ=;
        b=FfBW7uDldZu/zKJJeoVmxEm7vx005CrAvgQSamGGAlzDh92yiy+UrjpMI/0qM5SNnZ
         YXje3i8PTbOVfrLdoMByf9koNB2B0tpSTPSNYgTadNIH1DVrmvpP/gVVQvV6rAeAQnzP
         YI+3XPi6PKz1w4wp3W3+5KIa0kIo+ZkWFDJmJuFaqqbLjkgDQm3+LRxKEJs0Qtu/rYIW
         sz/Z3PF2kSMVu7tWDVksPUnYp+Kb353xM3JEHhUtgF4qs/2PL/KpPwuaxxqkAYIa4Rv0
         V6r+MqzhH/ROfe1xUtaBO3lanDybc1IgdMAWrzaVebR1lnPvoVVeR/T/fN0BQX0kRmXk
         sX6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793438400; x=1794043200;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NgXyymUrfmD9IrHRZPUTZCn0Xdv6r6cUwaDRTXWRhcQ=;
        b=GPHzT6f2fH4eMSK66hVtZ2FDAU3ncnl7NW3bgsuBBG2F1eZfye0Y9n5fqASM8Vy/Ej
         V/so8Ulg4sVvMyfRPizWh/rvTrUzyi+u6t83umiHA/YQUJ66mI8M8Zt6drNEUbRnhrka
         829sUHXxhRc7kfVbabSOfF/+0eACJw7CYeQ82xOYlIBP3vLLAXSREWKXkQlQtGYqkx9Y
         gK+/cWShJN7K+URm4NSEPaLup0aDifNk9Yqsbf5nh9q6qOInn2S7MTFdzpyLjxjnt9ZG
         pHvPaT8iZSjZCCBM3ee2jrHeqVZgmIntyTAesWsIb02nxbnlsyj3KrYvWroQeX3y+l3d
         5yCw==
X-Forwarded-Encrypted: i=1; AKwUvBwCA0iqkp8YU/hOzIlGOVCXDfc3d/++AYN1YfvVcvqf4KBPEu0B78BVZrLd0WDDrmopDgNsjVsKhSzIsCWs@vger.kernel.org
X-Gm-Message-State: AFq9FYJivBAnfXf/U8R/vboGqoueuadJiOeS4TSQYbIJAFNcfz5U6X2T
	BXVk5Eug6El+wZjCQEFqNN02voNaO45H5AauQCn9uGX8jZGj541WUOlI
X-Gm-Gg: AYBFou2kfu/kh2wuN2It4wfwyDNGZY4I6uD4W2l9BsUnplm0s7h0A5lVAncikABG+RI
	Bt8MYX2UV1nZlLasNDjA7EGsQ54tPRLmbI4JsDhvSg5K0lCxyQimd0F2cHRes4KORJY5RfF0cel
	DksCy+4tiK98UI4ZVskDJ104n35ZnrgtIwexLUCnFj2JwW7fu8vapcRVeBGMNKlhFuFQv20E7B6
	mHYPNXz6x3O9w29jofQnNJOx3N+/A/hw2tcXCWMZ4UnX+T30W5qGkOZFUd877wSWrphj+cT58QY
	t29D2gvsrNGM9nPzzqxyNGYaOywAXJkVLAI0CykxChS4R8Jp8hDQ9cedLX8Mzdmm0Kcd/IYZEtL
	6eBcWetMD4ztSJ82XB468fs7iuKbTQGvHxRgEMQakK0ZLZ7bMoklQJU0NGS1q511priycLrnREs
	gAelB+pCoXC4MxoTtq6scqS5bCBFDONYdmoQBG99zm2aJIbmdZ9ZOxDStNlJHenh2ZYvd5bTOcR
	ehAObNE6IGm9KhDxGmIITFlN8q+icBN/dKsuNpDomnqOo+CHxcowU+8ouQb2i6Q4+eoxRGM/rKv
	YFsDodElud4fTiClOnhNNX7/hML0vhsWt4kC4lCKBI5DjJ+VknCFW1wy9EmIrwL1b/H/n127QU+
	Ibg==
X-Received: by 2002:a05:693c:880d:10b0:34e:9923:e372 with SMTP id 5a478bee46e88-36a4241a810mr7388621eec.29.1793438400295;
        Sat, 31 Oct 2026 02:20:00 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428ecb61sm13067963eec.10.2026.10.31.02.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 02:19:59 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	amir73il@gmail.com,
	linux-unionfs@vger.kernel.org
Subject: [PATCH 0/2] generic: test overlayfs casefold flags and whiteouts
Date: Sat, 31 Oct 2026 09:19:46 +0000
Message-ID: <20261031091948.18985-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
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

Add coverage for directory casefold flag changes and whiteout creation
on casefolded overlayfs layers, following the setup in generic/783.
The tests run on a casefold-capable backing filesystem and mount their
own overlay.

The tests cover patches 2 and 3 of the following kernel series:
https://lore.kernel.org/linux-unionfs/20261030113201.2921633-1-amir73il@gmail.com/

Tested on arm64 under QEMU with ext4 and tmpfs as the backing filesystems.
The baseline kernel was overlayfs ovl-fixes at 1d27da7de3f7. The fixed
kernel used the same baseline with all three patches from the series.

On both backing filesystems:
- generic/783 passes before and after the fixes.
- generic/998 fails before the fixes because a casefold flag change
  succeeds, and passes with the fixes.
- generic/999 fails before the fixes because removing a lower-only file
  returns EINVAL, and passes with the fixes.

The runtime tests used fstests at 22348afe338c. Both patches also apply
to for-next at d07dca72d245 and pass bash -n there; the runtime tests were
not repeated on that fstests base.

The tests also need "ovl: check the casefold flag of directories only",
which is included in the kernel baseline above. The fix hints use
placeholder IDs pending final kernel commit IDs. The test numbers
998 and 999 are temporary.

Thanks,
Hungyu

Hungyu Lin (2):
  generic: test overlayfs casefold flag changes
  generic: test whiteouts on casefolded overlay layers

 tests/generic/998     | 142 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/998.out |   3 +
 tests/generic/999     | 148 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999.out |   2 +
 4 files changed, 295 insertions(+)
