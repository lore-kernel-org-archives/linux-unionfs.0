Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EFB1C3306;
	Tue,  3 Jun 2025 10:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748945278; cv=none; b=tyLf3Q9vr9IKzhk/D4xReeIiqRa5E5KlF3XBqoOzmzp4vy3WXTei4QUqoE4Fk+xKfhHrvk+FED1ThZ4mcngRYoyq/yPbH4SgnW6HbdBM15LcDgQrD2HWoWQVRuPXIGhDq+DFGYc/RMMrN7k+8tnlhmnP3EitLEAFERupiWORfH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748945278; c=relaxed/simple;
	bh=MkHyS4/huduckHq9LT7jPYggdGlE+E4e0Fd3GxG5QWQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=SRrkHuM1ApZsMus7W1Z1gir+/QS5mSiKtrg0NzwiKumqSXIhOfIRJnRMQEyTl2g8rRR4UwYue4SJT1r8rsFtt918/tNu1btj+uILlWpYzhSefrv3rESivrYzETJngkkTnWANs+ZzmBU7cTuAh+UaZjsOKIxKtHi544Anp8ylECU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=USKaq83o; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="USKaq83o"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4508287895dso37070465e9.1;
        Tue, 03 Jun 2025 03:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748945273; x=1749550073; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W9axPcEIrCWbxXdJ5zSrRtTtu3R1AozoIUFLavtzuOQ=;
        b=USKaq83oexj0aLHVeAzHrqWseqTtdYg8rXwwPGxn3q+9jfwKZ2/zDS7VhwF2irl4kA
         lU+fPM+5EgjdziJ7gW1nfNO3ESKYPHALUCnphkshZLj1RVw3aTYtRgQ+mhMyhXDBQ/ez
         SCCg8NdKmgTF7eEvfhhbzRpa/SGXqW4Y6d0lGInjRHhebz8bZoobHSIMVTxfu21aVMxR
         RUW3cgRAP1rAQJY0JXuxcGEE7ljx7KPDwd/jhk4ecmt4uAPYV6w/hcQbzRGOLlpo2vFS
         2HkAyaZ0JaUFXA4KyWJ/kyfmkZL8WkdJ2HCCjQBWa4a14df1uwH6oMCVHw/Vp4PE982w
         MGqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748945273; x=1749550073;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W9axPcEIrCWbxXdJ5zSrRtTtu3R1AozoIUFLavtzuOQ=;
        b=URC8LXEBMsQCSl8t3bPfM38oZyymCS7+r+2C868PYt2Czzff8tJ4nn9nq4pNIt1es5
         IOVGQXcZTbvPKcrL6sEh07Qe4Pcv7A6/9AasjWgZK7lhayzlBcqNNSBUItUxOQRDSmPZ
         ZmhHPctneocLHFSY9zX7BZ2pPIdoOE3duIKWED0c9mLrlJ8EaSmYVdzGKMlKv3HuoBbf
         R3QUPZqeP4Kexg15Big9RaIfTH2e2r5zY6RFIbezswgRlB6LRzNf2oBNN38imihA7yNv
         fANgc4GRtC9z0QArM5yB2lg96hA6wS1ksIxKf0jzjzLmPAyUaNOPDccyhFuR/JP01cwx
         MYIw==
X-Forwarded-Encrypted: i=1; AJvYcCXGKFye/lsL6OwOgeT8Blmfp4gh9i4vm4MOsVq0LL5FT+jEfzA326nFt7YK8Y3oNzHYW68ZKn8uVR6VqNJfLg==@vger.kernel.org, AJvYcCXOYqN6XvYlETRMmHwboV24RAfjFoNTkbY44YZvT+szz3iiCLb/5sRCChon69i7GwN/crlrwKws@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+FMrwiqdKHIGzvJ4+xgNU8uwDHEN9karnWVEo56b7vxc6CDQn
	rGC8qOSy5kxG3cRdIQaVun1zUPTKzOyFATzHMf2E4/+5JdcdV38uDodC
X-Gm-Gg: ASbGncsEj/N1k3JqZOIGVuPAJPoPV6c05IJX49RslzXRScLGDdAm02YP+IwCywkvHdK
	QmFNLL+fObjbENPOvzcRx985FaXeDgfQPXEp3KKNBaG/Ee0XtVu1hKFgEfX20seMTWml+5fI78F
	P1HeXkuG6mPKytBXPteXzmGgkUG8nmcpcDfgPpNuO+iFHgvWPZ3TfqFQGMTThCfWZfVJxM2rdRp
	HN+AquVGuGlDfC0Rla/kpNrW1Gk1nKHGEjHF+bT+UJ3zzxSpJGjmIdDhHThoNfLxyo17RjB1Zhz
	4DoztmPbDes+MtLmAIplwKSNbJ5ZYtlf/LSXo80nfFY6i0tg7yk17EmttnV5Q2YxVTb+1kBhCiD
	hH4ri3wZTwtMSWFNeGPw6nm8xgxzNq21G02eLUktNTMPtkiMdKl3QpAUwzL0=
X-Google-Smtp-Source: AGHT+IGfYOyxVOZty+c1Qy7lg2BrNf6KJkV+ucmxM9JTIgA1u1ng6WftSrvQLoP72HHalswA+IWbGg==
X-Received: by 2002:a05:6000:3108:b0:3a4:d685:3de7 with SMTP id ffacd0b85a97d-3a51417af94mr1503080f8f.8.1748945272790;
        Tue, 03 Jun 2025 03:07:52 -0700 (PDT)
Received: from amir-ThinkPad-T480.arnhem.chello.nl (92-109-99-123.cable.dynamic.v4.ziggo.nl. [92.109.99.123])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450d7fa24c6sm157191525e9.12.2025.06.03.03.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 03:07:52 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH v2 0/6] fstests overlay fixes for v2025.05.25
Date: Tue,  3 Jun 2025 12:07:39 +0200
Message-Id: <20250603100745.2022891-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Zorro,

My first batch of fixes [1] was addressing overlayfs test failures after
upgrade of test machine to a newer distro (trixie) with libmount v1.41.

After a closer look, I found some tests that regressed into _notrun,
which is harder to notice at first glance.

Tests generic/{633,697,697} were regressed in v2025.03.17.
Test generic/699 always had a problem AFAICT, but I only just tested
it with custom MOUNT_OPTIONS.

Lastly, following the review discussion between Miklos and Karel Zak,
I changed the workaround to the regressions observed after upgrade to
newer libmount.

Thanks,
Amir.

Changes since v1 [1]:
- Change workaround from LIBMOUNT_FORCE_MOUNT2 to --options-mode=ignore
- Add two commits to fix tests that were not running by mistake

[1] https://lore.kernel.org/fstests/20250526143500.1520660-1-amir73il@gmail.com/

Amir Goldstein (6):
  overlay: workaround libmount failure to remount,ro
  overlay: fix regression in _repair_overlay_scratch_fs
  generic/604: do not run with overlayfs
  generic/623: do not run with overlayfs
  generic: remove incorrect _require_idmapped_mounts checks
  generic/699: fix failure with MOUNT_OPTIONS

 common/overlay    |  7 ++++++-
 common/rc         | 10 +++++++++-
 tests/generic/330 |  2 +-
 tests/generic/604 | 11 ++++++-----
 tests/generic/623 |  1 +
 tests/generic/633 |  1 -
 tests/generic/696 |  1 -
 tests/generic/697 |  1 -
 tests/generic/699 | 17 ++++++++++-------
 tests/overlay/035 |  2 +-
 10 files changed, 34 insertions(+), 19 deletions(-)

-- 
2.34.1

