Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531421EF0B2
	for <linux-unionfs@vger.kernel.org>; Wed, 12 Feb 2025 09:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739353519; cv=none; b=YlRq3hPrnSspDsO65bCuBmFAB9DYaS51Y4QYm/5gOxfKtpSuQWpruQ6AvKp6CuFRtNYiTknEkRuo3Ex1UKV3pDADNhzXS4w+16ktxWTGhR4AfPTXfDjdArE9zv7HdEshYKzGoYoy+HhwfGCuCugHzFb+WtnommC3QmcFU678P4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739353519; c=relaxed/simple;
	bh=8jjzuKgD/1AtBRUA78ZBjpWLJBnkbYSffdRg2OGfQEQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=nBR6KD3baupgAO+MH+Y+0vyDYxhxOjSCBnOqLPACkt1OAlEJgQgCW4N0DXEk9gMey4xyENg2IB0SU3lSK+vWtJVnMStWO2vQB/bWKICMVOAO//cQk1DTqhMlwNDRfKyE7T8yR8BQjlwYDwE+fW0nwSO6ddqOHdXJc2mPK32uJoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fMZV88wG; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fMZV88wG"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5de5e3729ecso8214468a12.0
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Feb 2025 01:45:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739353515; x=1739958315; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lzHhp61LLCBELCIWGbfRoZUDoPPNJL4l7UHp6zW7DJk=;
        b=fMZV88wGU7yPjhRVVSsQVT4yJN41OAzlHX0GMfKN8IPT8G8O4Pcha30TTwrLs0/0ts
         /ZbPQnHzuRKbM4lvJPM03qyHAXX6bgllVo4QbejOz7YAh9bVWl51ASnrJzbVqDYDojJl
         iZaOfgtDjxBH+28ehy09lnvgU2n2shfNN0Ufwx7+fxwpGy2PAuDFpvepriZ4M2szZ3/i
         6n/grMc2GTmJFTCVoblo3PEAhBdNwq+y0BLS9pyGTyTXL85hs6MailFto0v5jaQ99Zae
         Jl4APKvOchmXyglq7VaNyULdxsFsmzhnO+Vmnv6jBec8SjalZ8Eimx6h3xN/K5iYS1c7
         wAPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739353515; x=1739958315;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lzHhp61LLCBELCIWGbfRoZUDoPPNJL4l7UHp6zW7DJk=;
        b=vSDM/KXXnPvuME263nOEBgjjq138Bsxh5eK/ywZTZZLMGod+S2MXJ4S+cNw8gm6GOl
         CIXkNgSvjOiwwk+HK+IW7eaIS56M+C0Scy2UudVowx4j4Gc2s8ZHFSAykzl3b1KDfX3X
         6clUTYQNy94jz+vp86CPi9fqpjtRwRMfoERxKCSReD9VbFgpQz3dxdIxzJTrfoB6dapz
         NjE9GGL8zM4WdAMGEDNiNIJRema0MNOBkSZlPVzGBoNcLRfKX/IbNt6S/bI3wdaYMGc3
         Bdyi93U2oiEHOHRFqLYkvGSV35rXNATS38wQdowXUdZrWAkNZe6Co+FUFlmt3KSW1oC8
         77kA==
X-Gm-Message-State: AOJu0YxM0U28YDvyqO/Rcqh+TVT1HbVqgua9osTSc17laVE/rNiLupe0
	jz+yUAsfV29DkmhBXxyjvJr778smTbrv5ONBzmz8/mBYd6MOX9B8J0xNCTK6eOAAecG7FH/mGEk
	78bVzIAkJRLsL3nprjSxCQxVs8WNVws7d
X-Gm-Gg: ASbGncv4pSkIowrXkO8/uGgBff9qBDlIFzk9O0XG+GJHGaxTh9u+lVF3PPVDys2qY6d
	tj0aZqTfQvLW8uPzNXxwSmMc9kDSZHqW7e9FAPAcMKdqbbc4P5b3UGtN2NQS5NRMWDod+W60=
X-Google-Smtp-Source: AGHT+IEqnDSKG459snhDx07tMw5XindsKgjcoUIUxr7zD7tVZnFGbXeDNbmWVlZppEP7aHGWjVzJUaYhfBgG53PDqEk=
X-Received: by 2002:a05:6402:274d:b0:5de:5263:ae79 with SMTP id
 4fb4d7f45d1cf-5deb08813d5mr1516852a12.12.1739353514734; Wed, 12 Feb 2025
 01:45:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jordi Pujol <jordipujolp@gmail.com>
Date: Wed, 12 Feb 2025 10:45:03 +0100
X-Gm-Features: AWEUYZm0pOemy5fqeFkVx8yNwtNEd459eG3iR-NYWEBTTNLwUX1j313x6K6EcEI
Message-ID: <CACTE=go+F-ZcynMgGmZTkmEMKw-eoQdD1x8iHacD2c+hebskvQ@mail.gmail.com>
Subject: overlayfs doesn't sync from version 6.12
To: overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hello,

I allways work on a Live system that uses overlayfs, and also remaster
the pristine filesystem using overlayfs.
After upgrading kernel to version 6.12 have experienced several
filesystem problems, thus have compared the overlayfs code of previous
versions.
By intuition, have found that these lines have been removed from
version 6.11. This difference is key:

overlayfs-sync-upper.patch
--- linux-6.13.2/fs/overlayfs/super.c
+++ linux-6.11.11/fs/overlayfs/super.c
@@ -202,9 +202,15 @@
  int ret;

  ret = ovl_sync_status(ofs);
-
- if (ret < 0)
+ /*
+ * We have to always set the err, because the return value isn't
+ * checked in syncfs, and instead indirectly return an error via
+ * the sb's writeback errseq, which VFS inspects after this call.
+ */
+ if (ret < 0) {
+ errseq_set(&sb->s_wb_err, -EIO);
  return -EIO;
+ }

  if (!ret)
  return ret;

In latest versions the filesystems work like a charm when applying
previous patch

Regards,

Jordi Pujol
