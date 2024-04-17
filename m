Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6216E2D60C;
	Wed, 17 Apr 2024 13:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713358870; cv=none; b=GZnh9E4TVlnbsXgk0v9jn+yIBeCrtrHwKxb+Tz3F1eyKKhrlRJ+//LP1TYaztd33oFp4AhFuLx8apO4WNzI/BnFGel8K5KPJ0jj8ANhTHntBud5J4qrJSdwZADAXfBCJIkJ6RQiTqFA9KRrefHlNF6IkiA2z2zrx/lxiKTAmeRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713358870; c=relaxed/simple;
	bh=nbk51VZVe2Jhp85rOdmqo61Cl3JUQKflNYTDouMlSCA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UGl3kMtdDDCgidN6ercAdNGoMVtYJejunyUaauLPB6FxYfJJTGGqFid0AR70M8lRrc2zWz70aGpYAF6sDoff9MuVLkwgFcME6RigXuFWQdDyDZSEiglfh9QBkil1RwHNiF8dZmLUZODEjyNnlFLNTzkDtOEPa5+CWCRCv7C/aDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d5dgl1/b; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d5dgl1/b"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-349e211e562so181372f8f.1;
        Wed, 17 Apr 2024 06:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713358868; x=1713963668; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=luJkq5A749Bj2iJoVYNv8iaip15440ZNmCmzI+PkBF4=;
        b=d5dgl1/bhEHm5IwsK+4DdnS5BBUg8qIVzLtG24KYugfqt9Y1mIK5JfCB/m2tLutYMY
         xJ4DxK8gAR2NY5Fp1VBIZwoMc2zeK90CjY8FOeUOdjvnY8ecffqpkDGwZB7B24jDW6QB
         qjDmk3Jh1aPYtRDsDwX6AJFaezDHkLoTJX4bfryCUsVC68u1r6kb+3u25NfxxShCDPRC
         NS3zUSW2Q3DKMSiOZi5vrlI6OwwSRaBW9u4O8pYKt5WzuYHJ8OtATheVyxQg4STsgIDb
         8lMwqHXRCfcIV3jep7bcDbI1w3T1ux1orkqmFBIJGvg5GMssFma8nqN/zlBlrZqQa4X1
         t+yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713358868; x=1713963668;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=luJkq5A749Bj2iJoVYNv8iaip15440ZNmCmzI+PkBF4=;
        b=gQQ3KowiPqzNBmJxar+2TGUvzFu+3B9BAJSytjEYxBCb7AlAnJMMOGPToWDXbY/NoM
         8s4gsBYzDR1upiZay+GODPJPzRH2+cC8cCs5SLm3CWRV+z5VjIvvbwP3zPx98vVWLgch
         tQInAddJaRFOaimNTBGbHPOUx/ydhJEm8VymEf3etJiViZpcNM0RgrSeRyMqL1EGhMbB
         wQ3cmhgZRg/pNzTheI3BQuptUy3JbV7AJHDqtN4Uwe6BjW65CpkLAkRSxjR/lhihRzps
         bRGP/T2ByhVga5tV+/CHj+6tz5gf2txIqDT3Bt66Un7qlg9WFnQ088tuY6dBKZ3+qNKZ
         cJXg==
X-Forwarded-Encrypted: i=1; AJvYcCXxsiAwlUxHraLpWVirl4dhaqHvloVsRd3S6FEiIYUNEq95kke3e3og7j5yJ/uUaJMLyF+YI52n9RsYUc5P/NZUidcbfCJ2+mg3xUwEpCN5Ul7Cn4nN+SzyolV/qpKYjvUWFHPNwtk=
X-Gm-Message-State: AOJu0YyQKDOhqW/PyuBuGH83g2gwMfdGTaIBJ+5RLNzvLUDJcmoXpt1D
	W77aYlE2xyVqHegVIbJOPHHp4kcSHsf2UeLh1JSbbSsK1EI2w5l2aWt1lA==
X-Google-Smtp-Source: AGHT+IEkmO9TY/as6vIId9oHLuLOTn9tlxDJm1gRblLao2O8/9nHgHJ/j6hDcURuxeze3ARN2Vjz/Q==
X-Received: by 2002:a05:6000:232:b0:346:c746:28a6 with SMTP id l18-20020a056000023200b00346c74628a6mr10351226wrz.55.1713358867508;
        Wed, 17 Apr 2024 06:01:07 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan (85-250-214-4.bb.netvision.net.il. [85.250.214.4])
        by smtp.gmail.com with ESMTPSA id a5-20020adffb85000000b00347e1304639sm7525717wrr.48.2024.04.17.06.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 06:01:07 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] generic/732: don't run it on overlayfs
Date: Wed, 17 Apr 2024 16:01:02 +0300
Message-Id: <20240417130102.679713-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The test tries to mount with same mount options on two different
mount points.

Overlayfs does not support doing that.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/732 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/732 b/tests/generic/732
index 5b5087d5..7a40f49b 100755
--- a/tests/generic/732
+++ b/tests/generic/732
@@ -22,7 +22,7 @@ _cleanup()
 }
 
 # real QA test starts here
-_supported_fs ^nfs
+_supported_fs ^nfs ^overlay
 
 _require_test
 _require_scratch
-- 
2.34.1

