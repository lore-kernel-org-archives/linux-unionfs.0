Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793947622;
	b=qRJIIKExtOieYw2Egm08KhxB0ugzI4H5N0rKt0H3S+Fx87DOzbKe3XlxiT8Qi+HXSQuZ
	 z8Tmxrx5KyGdTNYmRxWdYfUbD9m1517dQrASBCf7vDySe9u9blvrwvURUI943AcALXN0K
	 CA1lRU+fpdNDMixh4zoHhWAAXJ0Zrq54VuLPC2fxDDXs76djWOpJHrIiIQkyII+QIXD0w
	 RtprO3s1Iqh9b+3/oM9kvFvX9J08G48j7ywwvQHL3LYcGHDhoXAuk/2n26f7fpxqgKVnl
	 zq1HDargbwNwip5IUkroYDc/T1Iz/OB1+rRGz4UpLUIUlvatUKe9lfh5mG//cu269UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793947622;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hIiJTHVvnRcW94BgAfPLzMPiYxMM33qks5DkmeQr+Ak=;
	b=vPJTwtZVFIM2ENbm8PQdiBWoof3r+MQsrlsvsX31u89bQCCsKoRrkzyAOurl7M4jtciP
	 zcMUzXFJiC3EhIPA0qU+ZNy1pA2ynLtMJjAjtFC+JglW7wnw629eEcwVhHqLzF3vzddjb
	 vdg+1C0BKT865aSKAM+xk6WlYjffhIAcmLWDvs6rug79lVmeGjARYJIt0+OWUN393j3rw
	 xhp8XPO6yRHIQgNwAt6CUfSWwbRsSBAyoE7C2MOKriak/moc2XSuqTveoh3meUQeQPA28
	 yd0pB94tq/Q4gcJWOiUmF7WcQN8lLcSZA5Yoibvsoj24CYNlCHDdjTRoUeZwxRb7xpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="g6DnxrD/";
	arc=none smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034CC606A328
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 06:47:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 034CC606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=g6DnxrD/
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c4cb6834eaaso37826766b.2
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Nov 2026 22:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793947620; x=1794552420; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hIiJTHVvnRcW94BgAfPLzMPiYxMM33qks5DkmeQr+Ak=;
        b=g6DnxrD/K96AYO1B7tiDT6BfiOA4apqHQiYNM04gubZiCRYnStB+SjpfQuoxjfi4fJ
         a0WpnVMLWTWH281kH6Uv80/8Xbbd2/utITQ7T5H/2hmayMLGKJUwPZza7WKopmyX2yqM
         mmQaiHm0yAa1UqVBf/WI+YZYGianrILUH2+IA/EegHVDEgY9ujbbkrf4LmEy4Jw67Br8
         54g/wGGUtM2o7f2dzLXbGoZI4B9h0Cld1c3VdqnCIsDbuZWVEwQa9ybgUh6LE01l2fhh
         83B6WuqKrPbh+PP7AacD3BsZmRFGvbEmz+8AXqna49n7my/LggaBbQ2RMJW7/gjEBjQG
         t3sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793947620; x=1794552420;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hIiJTHVvnRcW94BgAfPLzMPiYxMM33qks5DkmeQr+Ak=;
        b=LxxS04mRdErTzzcu9Tp4uO8gFuOTOpy66isKxny9gUMmPJueT9uWrGNj+7vUs0kbCj
         j5b5jO+NzpgG9lZjAyNdijCySG5rSxW34v3HGozXq5Tu4Yb4NiLb2Mn6gibrFSM4b3kl
         XBtC12a1D97FHCulhGGhIBYZPPKLeIoUvKpccx7YOSMkKEXFnX1mZBcc3DiepAZMu8LL
         mcexeybrqV/IZfLGhfH/WMH5BBzhFZIWFzEukza51jzPBobbXu1objvniSuXNu0EuAog
         4ZbraZF7pjtpJdmKJ8N7nAJiKbu9Fhmdjq3GWtyxXJRFD4AKtg/JL2uRXho7OQ33ZVG8
         VpFQ==
X-Forwarded-Encrypted: i=1; AKwUvBwm7G6Zg8p/CdfLPy+rPF76GvOx/9fB3Qo8NB1RfqUcP4RvC9YUoC0sXEmpjvgh58AxiqCRpMvZoe3Apq+t@vger.kernel.org
X-Gm-Message-State: APuU4Z+GcXXvM9o3kID3+fYkLm04vR2cYfqxZwkFTe+wC48eTFqrj+M9
	WMGy+hhKFrRpFaLJRBnFKlte3QQIj75WxhF5dSBJ3PMjlrfeW5g4PybH
X-Gm-Gg: AYBFou06uGn4BJ6MFvps2GeyyVoIibwV3dMd2e5b4VVhXqDqMKQg36L0Uax9eKN9UyT
	iYrQZjUIJDZfoXrwzW6VA5/XJ2jU1dO40/7EkiWqd8ay1LGKi794xR8k9OiR9C28wHx8LkI8qZt
	O77BoRgd7IZc6c6mCqYMFPr22BRzY2rGjkEuHfH7zVLoOwbLekzBoE0UINuzQt4le4u/RLmc4Bw
	WmiPcvkxcNcBHQzyxKi7Mc5WZoHJvU6w1W8E6sD4+rjC0KMvqZhuO7Drs4M+6BClP/z8DB6pjaX
	X3Of/1mw6ugTLt2rQNaMdM7Uw1/OVhomQo23+Yxj4zH5X10dsST3q12P+pLo2MaOEcSvJrC9rWT
	YTgNY0MRRMKvjXE+Qtg1+VD/htcPj3hNz6VI7qf9QGbKCycJhZnaSomSkRvQKP8JOc43w/0ks3Z
	CzeuYnoHlVbhYhpHzeogysS0VIDikYQVpGRPHDorJr2oojSM27dSQSQ1jBOGPyVEpE3VOkzMB4N
	KJ6Bw2lWbYow0Ru2FFCHIvOjJ3QXBx27or7jmPN4hIPj/SI/mCA4JESo5gNsB4Bn3ePOLsW7Y5o
	C+hqqsQhulAqhYccbshrB6GKzggGAA5HnkFMbKj5BPuiJIXGpzRNmoCEaqfQAhYyy9ID1s6tUz/
	AF9E2nQpV54AO
X-Received: by 2002:a17:907:9496:b0:c46:8909:963b with SMTP id a640c23a62f3a-c4d35485cf9mr140787466b.9.1793947620154;
        Thu, 05 Nov 2026 22:47:00 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d356c6025sm51097866b.73.2026.11.05.22.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 22:46:59 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: [GIT PULL] overlayfs fixes for 7.4-rc2
Date: Fri,  6 Nov 2026 07:46:59 +0100
Message-ID: <20261106064659.3809691-1-amir73il@gmail.com>
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

Hi Linus,

Please pull overlayfs fixes for 7.4-rc2.

- Was in linux-next overnight

- Gone through the usual overlayfs test routines

- Merges cleanly with master branch of the moment

VFS NOTE: added export of symbol dentry_open_nonotify() that was added
by commit ebe559609d78 ("fs: get rid of __FMODE_NONOTIFY kludge").
Note that before removing the __FMODE_NONOTIFY kludge, overlayfs and other
modules could open a FMODE_NONOTIFY file with dentry_open().

Thanks,
Amir.

----------------------------------------------------------------
The following changes since commit 51628610f9187c1c1cfe499d92e066bc22ad9693:

  vfs: fix take_dentry_name_snapshot() semantics (2026-11-03 08:28:20 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git ovl-fixes-7.4-rc2

for you to fetch changes up to db1c5da238dc80a61ab429a7b71b0e2835766c45:

  selftests/fscontext_ns: expect EINVAL for overlay descendant userns create (2026-11-04 21:47:48 +0100)

----------------------------------------------------------------
overlayfs fixes for 7.4-rc2

- Fix a self deadlock of a fanotify permission event listener that also
  watches the layers, when it reads an overlay directory

- Three casefold fixes, found by Chris Mason's AI review

- Fix a decode of a modified file handle with nfs_export=on, which could
  read the stale lower data of a copied up file, also found by Chris
  Mason's AI review

- Fix an overlay selftest after an errno change

----------------------------------------------------------------
Amir Goldstein (3):
      ovl: inherit FMODE_NONOTIFY when opening directory realfiles
      ovl: inherit FMODE_NONOTIFY when reading directory layers
      selftests/fscontext_ns: expect EINVAL for overlay descendant userns create

Chris Mason (4):
      ovl: fail the mount if the casefold flag has changed
      ovl: do not let chattr change the casefold flag
      ovl: fix whiteout creation in casefolded directories
      ovl: look up the index by the decoded origin

 Documentation/filesystems/overlayfs.rst            |  3 +-
 fs/open.c                                          |  1 +
 fs/overlayfs/dir.c                                 | 46 ++++++++++++----------
 fs/overlayfs/export.c                              |  4 +-
 fs/overlayfs/inode.c                               |  8 ++++
 fs/overlayfs/namei.c                               | 13 ++++--
 fs/overlayfs/overlayfs.h                           | 21 +++++-----
 fs/overlayfs/readdir.c                             | 35 +++++++++-------
 fs/overlayfs/super.c                               | 12 +++++-
 fs/overlayfs/util.c                                | 13 +++++-
 .../filesystems/fscontext_ns/fscontext_ns_test.c   |  2 +-
 11 files changed, 102 insertions(+), 56 deletions(-)
