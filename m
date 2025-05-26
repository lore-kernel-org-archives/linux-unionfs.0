Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E87A28EB;
	Mon, 26 May 2025 14:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748270108; cv=none; b=PxFlQiUcG6k9x/fDzuBvqgg0/zbLR+tBiPjrN1PeUtEXv3aRL8h/UHTgTKmmcj62HVMt1wvssLgUjdQKb3FHI2C47FvywGBOMG94QOyUzc6Fo5AXZhe1/ik16zXvjTM9WKxMBYxFpKBhGkjY2uOdhf6qKLY6Ng01b5BmeOGQpJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748270108; c=relaxed/simple;
	bh=slUUX+Xfj1OSuhBELMtPg+bYXDlhloFKYqMrulkUoQ0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=V3KWbquhXNsTjWBjPPeBOh33Ddg0IhwDje/Z563OQzzu1vyJMDqdTBGG/gFNtFm5l+kBPqMYJnV8Xx9UVl3IylE2NC5Op4vel/Ajk39Baxsq8ecdUnK6dvwFISSoxyKbnKfW5ygXEl/Aj9494SoBU5BUxmyhOAZTdTKIadthhEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i/PrbPlB; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i/PrbPlB"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-442fda876a6so22266675e9.0;
        Mon, 26 May 2025 07:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748270104; x=1748874904; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FWLIefqv85YoaftSGJXTEq/4LX7sS5rmlanKHNxwp7A=;
        b=i/PrbPlBe5+vCljCuTQbxPhhZuy1RjnkfwdonDRSN3535OhKNlDCHefOKOCgj7uOfq
         lhaiETgrPjrx3RzSGONxI/UX0NrPd6sZ9/wyYi3kn0cPWwfNuQBrIknxWdqLcLNZ/r/8
         a9MLAhl15GlNshw5RnkBXaLQmJZOedftLKVdk0gW0oonVarlorSb3UkRC4yWGU6Tww2M
         Nl+K4pIdo1zIeve+VqqSG2e3vOuvGBf1jyYe3lQJcFrh59+tDL/0UiXQOvS0yK6AvIEz
         INloR7fxD3f3cCV51+t8blUnJhYam+zx02QNXCfxoUm5+vxEEkGyDSUzAid330A6k+1F
         3jMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748270104; x=1748874904;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FWLIefqv85YoaftSGJXTEq/4LX7sS5rmlanKHNxwp7A=;
        b=sCAPEDXa9LhBu/b7Ir0n/EA6f47Ivmg+DzBQpa4i612+/d9GQ56+BauAuwoNJXVxwl
         jPAmA8/kAGBmsexiNOXHfgeqMm4dolzWAstSBWPUphRkIn6wGrL0Lp4b2ejjLGAl1Yoh
         EawLDewpeftUkjoLTfs82tY8NidMmwsYqL5U1ZG614/0VG0/xWmOmvXrDBaXnZAwwoWG
         53CCX8qYmd/Xa9RUYKYwKDvxYIKGdP3DQuxnbhPGqmqjyvWINtd9VPp1rqdDVSoj2xZA
         3aMSYlu/NCO5Xr6XuVz+4VL6xCTU2oCjqwDRuFrQ5mrvO2M8uwynUtkvfYFUJM3+LSeS
         x5pw==
X-Forwarded-Encrypted: i=1; AJvYcCUTkY5EvdQ3fQIZ09FZL2xXW66nkmcRfupqAhGrsn32ctaUbj4ccqLO7ac+r59TXjQhSQNDaMeFRWRW5/7c0A==@vger.kernel.org, AJvYcCVVewWM6xJhnrAmhqz07hfMvLCLzrGXK0lKlaXWIXrPbdL6SNtp6Ix8aOMNKuECj5cQsmItv/zg@vger.kernel.org
X-Gm-Message-State: AOJu0YwdMTzMX5Tfw5iMz8Ly5N9Vyty4W2EW2c8OaSVmmkLc5TuqyAlT
	kZ8CvY70W5srQodwXODZrjcM/xTTuynCsjKeqklwUOxifM3PLfde0W6T
X-Gm-Gg: ASbGncsyqdHIzlfuOanSBUtDxk8k5cP67K3VVgWVFMlqb1HJktk5jm2yHF58uXboHl+
	U7IX2olcHRHdxvK0n7RELNDiG0WF5jHZJclQqaez8cOCDtf/MsD8/KCxcpt+fzhMb9up9mt0lcP
	FPNVB5bsAXTLXnjxW9WR5D6cpnL2qADr1E6kJ3O7ntthAmp+zCaE+HZL52aabFvLDqQzP21quxB
	n5+KeHVIkkS22Ryy+044emMHFUUhS9fuolu/Y5W/ektv1OYANU45T+tOamJ87bdU1uUKePQwu0/
	aTJ5HA94Str8/WaLWfmMXRYZd4RZbNb8y9+o1vZQe9IAHr8TLViW5xUPDhz125I8BBNO+6n4nht
	na5zdc1KfKf5++5jKVsd/9n1LrjG1n74p6gwWPCuTfC8aRe0k
X-Google-Smtp-Source: AGHT+IFBtLVic4k2k4SRpZWKOQq3ppAr5hunjB5pcf5wFvmLihjr9sdvVCADDe506ugXg3aQNCdY4g==
X-Received: by 2002:a05:600c:1c27:b0:43c:eeee:b713 with SMTP id 5b1f17b1804b1-44c92f21e2amr63430855e9.20.1748270104163;
        Mon, 26 May 2025 07:35:04 -0700 (PDT)
Received: from amir-ThinkPad-T480.arnhem.chello.nl (92-109-99-123.cable.dynamic.v4.ziggo.nl. [92.109.99.123])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f1ef032esm245264865e9.9.2025.05.26.07.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 May 2025 07:35:03 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 0/4] fstests overlay fixes for v2025.05.25
Date: Mon, 26 May 2025 16:34:55 +0200
Message-Id: <20250526143500.1520660-1-amir73il@gmail.com>
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

It's been a while since I upgraded my test machine.
A recent quick run with overlay had some failed tests.

This fixes some of them and opts-out of some.
The first patch is a re-post related to upgrade of my distro
to a newer distro (trixie) using libmount v1.41.

Thanks,
Amir.

Amir Goldstein (4):
  overlay: workaround libmount failure to remount,ro
  overlay: fix regression in _repair_overlay_scratch_fs
  generic/604: do not run with overlayfs
  generic/623: do not run with overlayfs

 common/overlay    |  6 +++++-
 common/rc         |  8 ++++++++
 tests/generic/330 |  2 +-
 tests/generic/604 | 11 ++++++-----
 tests/generic/623 |  1 +
 tests/overlay/035 |  2 +-
 6 files changed, 22 insertions(+), 8 deletions(-)

-- 
2.34.1

