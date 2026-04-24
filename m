Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E27C19C553
	for <linux-unionfs@vger.kernel.org>; Fri, 24 Apr 2026 04:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777006797; cv=none; b=Fn+8UVV9LDq+i42WovYxsW7cyK8VCs7cZa8PpvPiSRwXkZBcobJqT/IUfRECXBwmIV98qqIgFuXEUWw+PZTbYbQLq/yRi/hKdp0LhssNjAUapJKmfoa7bNMDtxzM0tTpYbrXIJotrXvEtRlEgDu3d8df53TprCq+EQWnSCmK3iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777006797; c=relaxed/simple;
	bh=H76pr8QL8DeaJlUDeQNSFXNmjPwwq2Dacl8m2cQjA5c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Pv8h6BDeilX6SvV5RPe1otqOs4IVJCzxb2vkx6i5N/Goh1wUPxJ9nIj5VozCIg61lf3KKUJtzG9aP9A8km/M0GOXC+NpAbyI2dU7B7JT2qMR9+Y1rC7QoCHULTBH+I+/i1UZOYsAPwcUT5rJzbQFhbpNiwHZXtql/0FHEVnNEEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=deK/0Ae0; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="deK/0Ae0"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-12c8cc7a77eso3478231c88.1
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Apr 2026 21:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777006795; x=1777611595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=978EVbvW3ZLh1wlVJiw2Zg9e6G5YwocerOhloqcIejc=;
        b=deK/0Ae02DIYKFvLq+bHjcfhwrG9NcDWzEpe/JZxNB7kLMtWKPwVzdErzcQB9gj4UE
         PUsb8yPMEYm8Juq71j82FSUJuouPe7ntaR6xa5R76Pw6jlGRiP0/GhQrjmik/sTPwqvX
         1/u4txsYVIrZNyNIAlUt5+1NNF555koARSQ8gOAUCaZ6ZFy6QUrzCBmH2ku/xhTIL2JQ
         aCqzAQMOuFLdTIvyYQB3L2BKc5vylWbucme0jORmsidBWOxCBlqNXyf4//8zPupemOg9
         W+QrsrkBicc+H5jl3SJ8rk54aD915iqJOwr7unztaGX+GCVHVx2zfzzZIk9EjDuAO5mr
         gJww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777006795; x=1777611595;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=978EVbvW3ZLh1wlVJiw2Zg9e6G5YwocerOhloqcIejc=;
        b=WhiVZfCYx6L484Pxfe0I4HyB2j6PFXU028sS6PXCMqAtDJuPcQeLYmhn/VQbOf90+Z
         L7pFYF5zPSqc+tRsj9XphdaDTQIqeNsw/9r7oLWjiYDePioGSYrUkpi54ugz9g+nWKA0
         P6mm3lTHIsxNPL7pNIQmT7y1KzYLLZZ45x/bMBDy0+7MnAv5l/KghHnNV2Orb2g84Qbb
         kzPPqOxalSE3r42oOIgK9kjnQVWltuZWKJKk1HT5oJKkzsnoQWonKSynjk25jotzYHSZ
         pKVkoGkz+KxCerPNheBQLm/ianH//u7fSRkJJO5whyBavsdVhbBpNsiADMLPJFiigUG/
         r3lg==
X-Gm-Message-State: AOJu0YxwitU9mRsa2FKVY4Mu6YIHecSDcfkszZGZdV5bVnDO0TvZF5Xt
	JjAL3V2bLeV8l7qvQNvJe//ecfHuuTg6SFtkHJQ8fiV2lERE8ZrYIHli
X-Gm-Gg: AeBDieuq1sOP5l0Uix3usn8FM0te4dRDwrQPSlNeST1jbpUntJjN/YErJzG4rjAid/t
	K/K0qJV1lPb2OclXTIOaexnVaNJlJ5YPaDe4csMuU1yW9hYx9WA4g7pSR8FwEB1MkP+ZW0whh3d
	O/z9L6tyuHdJtVM8LGxca+E0pQLkqE/pKKEd6QBHwYNx49+DuvKhmLXQpsFsnb59fbGYNVylcHm
	7j2zcXe8EJfjQRfrGYYTYXEP1qadPHdAhl/ztWGgiZPIOuF/OxWVm0BojW29An9NLiJd3iEH8ZA
	pZ7rEXXIKwUI5qPai8JY4u5SrWughqLvH5dvOvMZ6A4ltfOJnAaLz9q8b5KJ9/lGmRKesnjwl0O
	R3WyPrusxnmGqRm3i416/R4rmwT7DW+spOnTKIfR79CptwrRi2l48o1p4rIj27Pwv+6iYBqzLOJ
	v62AFAB+8V4bRB2CEvICH4HHE43FYVMg91SHQBDK6XJgN4Z2Gev/5CS3x+Dv2w5zqamKJMZfGhO
	jhkxzf27oBnPgf9m+RLKxNZlrj8Equ4jrmVank=
X-Received: by 2002:a05:7022:b8d:b0:119:e569:f86d with SMTP id a92af1059eb24-12c73b26cc5mr13053682c88.10.1777006795446;
        Thu, 23 Apr 2026 21:59:55 -0700 (PDT)
Received: from localhost.localdomain ([2600:8802:c01:ca00:45b2:2071:1eb4:e2ce])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c919266f6sm24955876c88.1.2026.04.23.21.59.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Apr 2026 21:59:55 -0700 (PDT)
From: Tamil Mathi <9tamilmathi@gmail.com>
To: paullawrence@google.com
Cc: linux-unionfs@vger.kernel.org,
	kernel-team@android.com,
	syzbot+75ff1aecfbeeefb78736@syzkaller.appspotmail.com,
	Tamil Mathi <9tamilmathi@gmail.com>
Subject: [PATCH] incfs: validate rlog_pages mount option against MAX_ORDER_NR_PAGES
Date: Thu, 23 Apr 2026 21:59:54 -0700
Message-Id: <20260424045954.3187-1-9tamilmathi@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The rlog_pages mount option is parsed from user-supplied mount data and
used directly to compute the read log ring buffer size:

  new_buffer_size = PAGE_SIZE * options->read_log_pages;
  new_buffer = kzalloc(new_buffer_size, GFP_NOFS);

kzalloc() for a contiguous allocation larger than MAX_ORDER_NR_PAGES
pages triggers WARN_ON(order > MAX_ORDER) in __alloc_pages_noprof().
A user can pass rlog_pages=22472 (~88 MB) to reliably trigger this
WARNING during mount.

Fix this by rejecting rlog_pages values that exceed MAX_ORDER_NR_PAGES
at parse time, returning -EINVAL for out-of-range values.

Reported-by: syzbot+75ff1aecfbeeefb78736@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=75ff1aecfbeeefb78736
Signed-off-by: Tamil Mathi <9tamilmathi@gmail.com>
---
 fs/incfs/vfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/incfs/vfs.c b/fs/incfs/vfs.c
index b45533b..4eaf890 100644
--- a/fs/incfs/vfs.c
+++ b/fs/incfs/vfs.c
@@ -270,6 +270,8 @@ static int parse_options(struct mount_options *opts, char *str)
 		case Opt_rlog_pages:
 			if (match_int(&args[0], &value))
 				return -EINVAL;
+			if (value < 0 || value > MAX_ORDER_NR_PAGES)
+				return -EINVAL;
 			opts->read_log_pages = value;
 			break;
 		case Opt_rlog_wakeup_cnt:
-- 
2.39.5 (Apple Git-154)

