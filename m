Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FC760DCF;
	Mon,  9 Jun 2025 15:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749482363; cv=none; b=He+lPhJ3d8mSUEYmo/jLMSEFjv0IYjOPhdFs5dEynxU6xLO4gjw+YIS/m132GQQP0S2eozvmzrQaQUG9uIJQrOfGx1GAdwCxr0L8Xbn/yFGB1L0PMJY5LyLEQjK/tDJsRsSitQmtPllI6mGXApdD81xoplOXj9hgOjT+jXXxmuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749482363; c=relaxed/simple;
	bh=MT3b7fKB3ZFeGqth5CIAccU3aNFzF7Z9IEjXBFAPFt4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=pwsmPr0kD8kHyOwf3H/TF7edQRJh6bpiyZ7mLynnSYpUoASmmYH+4eH2hgVPJDK58GGZa1NVH3dbB4Q/guW3l4q/HIIbEPP7fx3qyDkZkllSgpvaoLX+kO+UzOv+sP0X0A8EXqfU0cMk1FzwNYvi7mENGoF203lUwEPWYIinHAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dmRU1LkK; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dmRU1LkK"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3a522224582so2718044f8f.3;
        Mon, 09 Jun 2025 08:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749482360; x=1750087160; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BXt9vrNmTuWekNAj6WDRdga0dM4ONjmpXgc3oWT/qDg=;
        b=dmRU1LkK0IxBsw02SSCsltADW6zFnqIe4OprtTyr5MA8PIGXcD2OweY6iU6DXs822J
         J4dELIqaALnZng5u9xe6V3z7rmxaAkiKbWb/KZo6/6Xjarlod3VCeNdJMSDNQnMh4o+w
         azKic+Y8sPlUXpRvD+P6lrhh9BkqBJUL8s3N8FYWk19koXgrTfaFn4rfnVE34hDrdE7/
         FhQYGztUaLcOtIwbm3W8ip6zUWlsocOqgRcFY+odaQSppkfJaBsrZjDmuED6zi0nUAhT
         ADrIq1OQ+bx4Y+7vtIS6Mh8/5Mg5bBTvvB5eV3cS54QJXqJEySf7AtQARrVhIa2QcSPU
         k/VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749482360; x=1750087160;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BXt9vrNmTuWekNAj6WDRdga0dM4ONjmpXgc3oWT/qDg=;
        b=QipgldfeF2PFxy5g4eo97A+0JnyH1CNri/WokFdkhpflr+0O+lhl05d4Kh3UQvHNYV
         xttk4lJnASEJfxEyY+76xc1nFjhyaoCbB6Yj2yJ4mEfwKDdCDtlZx49HPrgmw+Ad/hz2
         1/wNq3/sbxv+fPr0zJzd6fWCezrU1gE0+udg0Nj3oB3hHXfassbgTPIZhCC22TYpQL9Q
         fHzmYbfLRiY6jcn1i8hAswOC1qIIKSR/w+cex0j426zypgTHvv8yb10MQBg485pv8KRW
         +hf4xWZKu1fzLr62jdK4XccFOSOWle3NVHtDjUuSR+o/C4GBVkPHqqL1enO4dCTEZofF
         M/sQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHZ2ohHZnF6XqdjuANdoszEcBw5bH2onJuVUcg0bV0yJryqZR2JSZFbnBfkZwEK/hDuQBTY+VDx0IfyOVqIw==@vger.kernel.org, AJvYcCXzy5l3unZNYvq5JEYJrbcjqYzboM5H/km97OUyeCW4Uyn7w1TJDBPDnXUpReCdqZvLx4s0sEJU@vger.kernel.org
X-Gm-Message-State: AOJu0YxwY5fnpM03m89fqBKtLjMsduvE2Ku/Ooqwho9j7HnYRd/7sr/l
	jnM764tkfbpptKQczL5fJM5IX1BiXgb/UEmeaugIyNCHpVJ5Od+LsJJPQxg/2NUv
X-Gm-Gg: ASbGncvasFN1HcWkWaihgp1QFuM9zllCW/cJ0uk0wez1xHlkhSdIPEA2wr9oLtWpIFB
	RW72AN2zguqJDUS9e3T23Y0rLoOGzp8bdQc/vR+0AWPmJ5/+FRlSuvKAO2nk8GTg3TEGxHkOkC9
	x3MVasw+W1092LdHQ9jqxq0pyW0tE3KangpeoC4Bcf5awR9hmtC6hvWuT8Q4bKGplBASNlxeHAc
	Q/Ef9L/Yd/xvar5iu5F2YrxF9QHhffc9qRjZRwj6lTINlR51yGOIeZux9Phjo35ai3D9O64rW+C
	LUH+Bo1+rJIbA96a1U9nKYi2hn6L2UMWQWTNoWOLaUXyK8EVRdhsoB6jvSmyFdudrrxnhuq4KQY
	jb7IKhQ5MZvmlMOCeq9pDIOBCqHdLfeGa/divsOAuatvwrhthmZwOiwdrxNw=
X-Google-Smtp-Source: AGHT+IGgPeUM9xKxzmI+Nj9JlkWIHKbPXmtPoqnrO49k0xBi8fKyms5gY096KzbbkKihGVVmjZ+tYw==
X-Received: by 2002:a05:6000:230f:b0:3a3:7ba5:9618 with SMTP id ffacd0b85a97d-3a5318a7939mr10627182f8f.29.1749482359975;
        Mon, 09 Jun 2025 08:19:19 -0700 (PDT)
Received: from amir-ThinkPad-T480.arnhem.chello.nl (92-109-99-123.cable.dynamic.v4.ziggo.nl. [92.109.99.123])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a532461211sm9622278f8f.86.2025.06.09.08.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jun 2025 08:19:19 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 0/3] fstests overlay updates for 6.16-rc1
Date: Mon,  9 Jun 2025 17:19:12 +0200
Message-Id: <20250609151915.2638057-1-amir73il@gmail.com>
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

Please find two new tests by Miklos to cover ian overlayfs feature
merged to 6.16-rc1. Those tests do notrun on older kernels.

Adding two new helpers to sort out the shutdown test requiremetns w.r.t
overlayfs following our discussion on generic/623 patch review [1].

Thanks,
Amir.

[1] https://lore.kernel.org/fstests/20250603100745.2022891-5-amir73il@gmail.com/

Amir Goldstein (2):
  fstests: add helper _scratch_shutdown_and_syncfs
  fstests: add helper _require_xfs_io_shutdown

Miklos Szeredi (1):
  overlay/08[89]: add tests for data-only redirect with userxattr

 common/overlay        |  29 +++++
 common/rc             |  48 +++++++
 tests/generic/623     |   2 +-
 tests/overlay/087     |  13 +-
 tests/overlay/088     | 296 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/088.out |  39 ++++++
 tests/overlay/089     | 272 ++++++++++++++++++++++++++++++++++++++
 tests/overlay/089.out |   5 +
 tests/xfs/546         |   5 +-
 9 files changed, 695 insertions(+), 14 deletions(-)
 create mode 100755 tests/overlay/088
 create mode 100644 tests/overlay/088.out
 create mode 100755 tests/overlay/089
 create mode 100644 tests/overlay/089.out

-- 
2.34.1

