Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BE236AB65
	for <linux-unionfs@vger.kernel.org>; Tue, 17 Feb 2026 13:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771334729; cv=none; b=c4HbVI+0R+mAegmHn8V9kC+sj7cXOmqRDxT7JR84wQocgmdmtdDT1fFemtqNKqRq9+2+79HVEMwyTrHnPGFyQzmsOVFJqyjXNHitA0HW3T94sAyVGDBiRNz8oOWod7iIfJGmOHx8yX5G0dSmR+bReTLxxW8AGcrA1/g/PPfkhec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771334729; c=relaxed/simple;
	bh=y3A+hPugdQy/aMZ17xCeJhJKVKDBVbOjH8vc5PGYIwg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ptljse4pc1RI8jyqJCodr9+jyu9GvMpAsk4CjiHMxtt6oX2o72AsqEEPgk0Avsu/r/HxhY5Moe9EAOj6Xl4oaq0WD6fLsOgQuJaPc07daURBYKgUCbLEjdZHD2zsLQycBam83SETzOhV4Jz2U9sHFOGR5M2wYLqbblJN2VY6HgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iHj9NiLe; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iHj9NiLe"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-480706554beso41190285e9.1
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Feb 2026 05:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771334726; x=1771939526; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+YJwnWVkIxYK1DSRWlkzfvTcjMJVZh4C48PXVKLFwOE=;
        b=iHj9NiLeEcpiqtKj0vpIUVWYDd97vCLmMs0cFgmwQiTae/7coIcYUJZnMQZ7nsF0Hm
         kYhxOdr2h2RO2i5pFlKLrkr73Otyq8Yh3hJgvbraPXrE4hML8kI60CB7l1SOMMQoTmll
         VdHNQI4BUbVequhKOT82PA5gzK3X1npjJNaX6SnhfxUFBMDuyCMmr2qEDssuMauvCPfK
         cdfn2b3XIA2cSpClxDeuP+CvjsxEaUonPTmFt0MSAPGfEhU+o+T5UfhnbiZTmpklSsVx
         MaJEqSxp4xMpDEc2yNqtKTgvK9ShwlFbGyoAFMZPIgOUKg11M6xFCURXhZJ/6L/nzRqZ
         1EiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771334726; x=1771939526;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+YJwnWVkIxYK1DSRWlkzfvTcjMJVZh4C48PXVKLFwOE=;
        b=aen7FvzIRoktc/+21DPNxwpfb05v+MbO5At3Y3dAEEumgbgoS5agG2/NnG0HJhHFU0
         XgEtSEPzhyt5/BQVMdh3k7594tR0wOFGx72dthwqTNPIdpHDmfex8Ez7bSa+EYD2iNHY
         4SPrCNB3m4Uj5oP9x+x4ZnpYlARTw/1bMFzTeM1La1zvZ5FvHpCAJ1ZcJblyU+nfTexe
         skf8X82A/xVzsMk7nnYWJlfmvtisp8W9+qZDuX+fLIoi1MwNyushA47hjKIV9h+15NMy
         eAeiRf69XgZ6u1r8/FTfBSvTg22jW3RptjAEitOP1N/Rs596YWrDB5Ru2ierjjMIAHfC
         +tDw==
X-Forwarded-Encrypted: i=1; AJvYcCXJrGxdQxjjo1Z23Lqy74UuSl5VXvSkKyYF5meIj+BiHmeKdo/oILxHAXvemX/rwRR259GDyEfxHcTB8fgM@vger.kernel.org
X-Gm-Message-State: AOJu0YwyAsNcuE/O0A9wXEC+gFqp0dBNC8jZFqhCIvxlxghvF5ZxvhdP
	W0uXyS6rkW6ST3ZEjrjhsKPG2VW0LIlztaOpTZvJi3vqJG1q9Ta+Gd6u
X-Gm-Gg: AZuq6aIlGMr/VzPqseHV3uK+dDY3YjqyWFLjDV5v9i+DOgjGkmOO5TsY8Bvdpz/HiWz
	Q3IM3PsFeWFvedWjsGPkdNTLNWgbtlI0bK4Mf0PTqbBGl3rUez/UTorxd2Wm2HYPyL9mOTklick
	G1nqsxzXI3fxpWg3+CQ0SE6S5amRRWc1QyrQCFY0iOaOLOkuYm4UHSWsud/JuruGNT4R7xYRKgC
	GezrA74NtylXv7g8JsDxJS5uAX9D9YIbki3zIeQDFXP5A8bgeLD5oS6rZwsU0h/HUXPSSwEftCs
	io8ocRgoIZ24Iy6LM9wvMulZ1h2jVdAGu0O+/t8CeSdoymQBsGfrOsggWGVUYlRuNyp9IANBvjW
	fzP7eVmmkhKbXqkCmBJfwQkM2xOr+C4wj2TLE9JZl3hWbJvVhCDua9f13/SFyIkuvFeX5AvLMEg
	M0qVSKjhosz07AOwuW97QPnc5h1Yheq1SRHYa97WMBT1FW+etPG108FKs=
X-Received: by 2002:a05:600c:83c6:b0:477:639d:bca2 with SMTP id 5b1f17b1804b1-48379b93357mr158975845e9.4.1771334726065;
        Tue, 17 Feb 2026 05:25:26 -0800 (PST)
Received: from localhost (109-186-143-15.bb.netvision.net.il. [109.186.143.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4837b68e5adsm319859315e9.9.2026.02.17.05.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 05:25:25 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: [GIT PULL] overlayfs updates for 7.0
Date: Tue, 17 Feb 2026 15:25:24 +0200
Message-ID: <20260217132524.681374-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linus,

Please pull overlayfs updates for 7.0 with a single functional
change.

This branch has been sitting in linux-next for a while and
it has gone through the usual overlayfs test routines.

The branch merges cleanly with master branch of the moment.

Thanks,
Amir.

----------------------------------------------------------------
The following changes since commit fcb70a56f4d81450114034b2c61f48ce7444a0e2:

  Merge tag 'vfs-6.19-rc8.fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs (2026-01-26 09:30:48 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git ovl-update-7.0

for you to fetch changes up to 869056dbbd636f8f256b695f39c102eb3ce2edd0:

  ovl: relax requirement for uuid=off,index=on (2026-02-06 13:48:23 +0100)

----------------------------------------------------------------
overlayfs updates for 7.0:

  The semantics of uuid=off were relaxed to cater a use case of overlayfs
  lower layers on btrfs clones, whose UUID are ephemeral and an upper layer
  on a different filesystem.

----------------------------------------------------------------
Amir Goldstein (1):
      ovl: relax requirement for uuid=off,index=on

 Documentation/filesystems/overlayfs.rst |  6 +++---
 fs/overlayfs/namei.c                    | 21 +++++++++++++--------
 fs/overlayfs/overlayfs.h                |  2 ++
 fs/overlayfs/super.c                    | 15 ++++++---------
 4 files changed, 24 insertions(+), 20 deletions(-)
