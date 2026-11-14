Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794652131;
	b=MwD4BXYCrqhbBhCLqZ/Mrb3++BUpZBWWzkcppaagjACHvlJeAQbZnDsvxL9/6wn3sXvY
	 XLmeBgIjBWyQ/5VI/eU8M6PKfS+NxfkX2WInI2fA07tn5ywOYXtHWoJtAuPoeJH6D1poh
	 IQh7ZBjmy5sTSLTbtamAklPE4nk6TUN6ptx4opg4H/AxHnOcxIZJeymEXsLtbJ7BKT+37
	 5nU+jV87n0N+V8Fdw/Ak7DX4QGsfPiaGeIdA/aKxKHedY+FIr6KFJifz4Gfn9m1BK8k8I
	 mLnixRFD8xhORMuaXX7WqSTvl97lDKsdasoxuCRYbhUuvOPcGScK6YqxnJdmTgIa0Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794652131;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=FXrtt5AcPJ3oF0h2d9fXFeKPAxGtake0pU13yHQcboM=;
	b=OgdHPr2milQGnfJaYeWFyPJArFFFvLta39Vf3WMn4il9js73Y0eFOYoBiU+4QvAGnWuO
	 FpyzqHua8QRfoCzAEo1WyTw/1lbqsDBj01xXsQIlQkvBvkcVwilCMMaNYinQEDFUzZJXA
	 IPXDT1icdYY0dSXvu0FwNVlh6YhTJ2ZQEpfU1xFKhPMZo6X1jp+Ykg3tAah+F3R0n55G7
	 GFQCtSdLuN5AnVt7aHdZ0eYtANSzVMjoPw0Qf66r1yCabGbpju2uOrotawo5GLI8nZ54D
	 r6pqdxoG4FLU/GqIEXIV0zLsvKZyea079f+kOHXTuyGpovzYu9H0/GQMIcZjT1cmyJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S3fxnZ4u;
	arc=none smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE31606A88C
	for <linux-unionfs@vger.kernel.org>; Sat, 14 Nov 2026 10:28:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AAE31606A88C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S3fxnZ4u
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c50aaad19fbso107962566b.0
        for <linux-unionfs@vger.kernel.org>; Sat, 14 Nov 2026 02:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794652129; x=1795256929; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FXrtt5AcPJ3oF0h2d9fXFeKPAxGtake0pU13yHQcboM=;
        b=S3fxnZ4urHbGQaknWbzhn575EndlJWklEqh9m0aizdD+yBSSyzmqENhXFHF5GHw2be
         wjAAspR3DOykarz5SOL+xZOAGjW9WqyFhKD3OZvGMrfsp4MCu4fOY4ENVgqq78+te6t1
         D5wKyvuu331UiNBDnwDBPWK1eUcsvluVM4BAhGKpe/uhlh3pSBJDXGw52qiluoP+/J9x
         k9kDclhHKUTYj3Uqfj2MGWNuRfmlXnDZ3I6b1i9T57YbafLtpTP2ehTSRuTNFXthNVdB
         BWg8Fjl8bOo48DYuPkDkjD6h0FXjpL4c9WsxSPAYRwoFVVxOiX0mj99dZCtRrEVT4eSs
         KNZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794652129; x=1795256929;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FXrtt5AcPJ3oF0h2d9fXFeKPAxGtake0pU13yHQcboM=;
        b=GN3fe6dpQc+ECtAMijcqOw9fzHzC4no7QWKP1JUOC5Vb2ZxVToVxqpMAWCw88/Jis5
         WFjZrTCBFghXzksBTHuGggFaHQ5cCiVD7xe6IBgySN2FILLRI25pYi5U7Qqmla8MxYfR
         dgnlnodT08XBZPuDRe9+iePUDOZtbhs6kcYIPpF2IXpmsndyzEOT6CrM6BhuyabfOMZX
         dR0nETbX4rCAoEZ/2uj3QKbs4KCOERlXOQAnpCnCJMycqI8VLLSjSPXB5pPyKI6o6xgW
         TdhZDz4OSXOorV16lEwAFQ0EBsvU47OXDrg+g0Ah4dtsYIDbeRLf7NPB50xKq834AuUD
         tfAA==
X-Forwarded-Encrypted: i=1; AL+hErHNkrHzRhNsKw++YRvnlJfLB+01DbieATAMV32fq5+J4B3j0ozJkBty4TEAr5I+Sq0uv+ArWtL7wP0Ii6pn@vger.kernel.org
X-Gm-Message-State: APuU4Z/HSOqxsGPFyZBkhYgs4SgAAkwxcW7SbVr3FPxBHujIjSG9/xwe
	ET3YxVMvQpmiT4wAkp1MHvB8uYbdxgA/v6NkHFWNYqU4h6159Zikc2+8
X-Gm-Gg: AYBFou0xLKHkINWVmHpHfL2kOUMZc5p5vxY45a83j0v6ogOglBzP8DeVNBJkQFCVHt+
	HDtWYi6Qclc5M2FaI0XXMGtf5lgydCVumGXY6IWbZh0T+DxGsGtMF7H/ECMMjk/7hrGJhTePyYW
	Uww8KgaxayKASsqYAeTZrFXwqXfK/FsjDhj5MDAjjJnGFwVXCYKp9QjIpVOCNM/saaoBA7YnLue
	zKoDExqNgvRded4/vbAGiEDwMM7GHQ5f7DehGa6HAhY0YOUHYVSGdnHq0+wolY/7Y5ssNdF360D
	dC+uL3WPN+Qfr1ghRkifR3dyrl6q4tHFAXAUquaD8PQae4nClVMFOWYqYbEgSXUGbHk3ZMuoui5
	9E+2ZQEVypOVkOIp1ItgEvfx6dL/Vcmmq0RROxgmEN4507lUon+Lk/TOGfUI/hAy5qSX5+6cTMw
	7UyD6CdP1S4cD2G7I0MqS6gr1WzZNCIQrU4oYR6I2ZJ4WSNPgN5VUfPbAXAIOg0bAXvI9jJdW1c
	N9osZUFO6w0bY/cIwfQqhNqMCo7qPI9jZXehEXKSQzYw4xRjZ6S/fr1fUWO+OAAZOERYVp6Kkfh
	mRm+v+UFM5R8pGrMK/1HmzQSQWIVD6qH/OtlbKxH434pGncUVWNHzN68oVajccO45FU1WLykoBU
	l10Fa/MRb0orL
X-Received: by 2002:a17:906:99c9:b0:c50:95bd:e491 with SMTP id a640c23a62f3a-c50964377d8mr492804366b.28.1794652127818;
        Sat, 14 Nov 2026 02:28:47 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b79146sm198656966b.68.2026.11.14.02.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 02:28:47 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Christian Brauner <brauner@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: [GIT PULL] overlayfs fixes for 7.4-rc3
Date: Sat, 14 Nov 2026 11:28:46 +0100
Message-ID: <20261114102846.574470-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit

Hi Linus,

Please pull overlayfs fixes for 7.4-rc3.

- Was in linux-next overnight

- Gone through the usual overlayfs test routines

- Merges cleanly with master branch of the moment

Thanks,
Amir.

----------------------------------------------------------------
The following changes since commit 7475ea8b58616b33c04afb976cf0fbaad9dd63fb:

  Linux 7.4-rc2 (2026-11-08 16:22:20 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git ovl-fixes-7.4-rc3

for you to fetch changes up to 748739f3171ed1c44a30a98b0e0341b1a8d62d31:

  selftests: overlayfs: reject different lower idmaps on same fs (2026-11-12 13:38:59 +0100)

----------------------------------------------------------------
overlayfs fixes for 7.4-rc3

- Fixes for data-only layers (composefs), some for regressions from
  v6.16, which relaxed the requirements for redirects to data-only layers

- Fix a use-after-free in lookup of a hardlink with a FUSE upper,
  reported by Sashiko

- Fix a mount failure right after unmount of an overlay with the same
  upperdir

- Reject lower layers on the same fs with different idmaps, which could
  decode file handles through the wrong layer

- Minor fixes for a memory leak, an error message and readdir d_ino

----------------------------------------------------------------
Amir Goldstein (5):
      ovl: do not read the flags of a put upper dentry in lookup
      ovl: fix leak of lowerdata redirect on ovl_get_inode() failure
      ovl: do not check the deferred lowerdata redirect on index lookup
      ovl: do not allow nfs_export with data-only layers
      ovl: report the requested redirect_dir mode in conflicting options

Daejun Park (1):
      ovl: bump the impure dir version when linking a file with origin

Denis V. Lunev (1):
      ovl: release the upperdir/workdir in-use locks before the umount sync

Giuseppe Scrivano (3):
      ovl: do not always clear absolute_redirect
      ovl: follow lower to lowerdata redirects from any lower layer
      ovl: return EIO if the lowerdata is missing

Jérémy Jean (2):
      ovl: reject different lower idmaps on the same fs
      selftests: overlayfs: reject different lower idmaps on same fs

 Documentation/filesystems/overlayfs.rst            | 24 +++---
 fs/overlayfs/dir.c                                 | 20 ++---
 fs/overlayfs/namei.c                               | 61 ++++++++++++---
 fs/overlayfs/overlayfs.h                           | 22 +++++-
 fs/overlayfs/ovl_entry.h                           |  2 +
 fs/overlayfs/params.c                              | 91 +++++++++++++++++-----
 fs/overlayfs/params.h                              |  2 +
 fs/overlayfs/super.c                               | 52 +++++++++++--
 fs/overlayfs/util.c                                | 12 +++
 .../filesystems/overlayfs/idmapped_mounts.c        | 45 +++++++++++
 10 files changed, 270 insertions(+), 61 deletions(-)
