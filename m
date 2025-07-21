Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2640623C50D
	for <linux-unionfs@vger.kernel.org>; Mon, 21 Jul 2025 20:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753130322; cv=none; b=XPeQYZOYQ9x1QC2Xh0QMk/VjeEk/abAYJ9oLvuC3+qunMH6d4gl3D/FLlqHUFpJfFNrsc1P7HMBS6NMB0IBTNvLnYidFHRfaU/xO/gSWnVuoKDZI+31Zim9NBAj8yG07mX1dR17Vo5HrjnwjDJT6c0N0mCSmsqLhdz8bIDu/Jn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753130322; c=relaxed/simple;
	bh=cF0cDblRxaBqv+zuy1VnJ8EjpAZtAl/rxcErRzGHO1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pr9iv+SC5Nu959MxWGt/3s/Crqr8kJCwFJjnQZXv1UnGJSuEYyvm3fb1mExzrzZOqK5vgWnYKLLQtChA+dRqBbmpmBm88E2QZlbx7508ui2fBAKv8ttLvJKA9nwys4L608CcYZID905/hKnVKZk8JUxAjNEd4/8tTvU7hKGP1+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com; spf=pass smtp.mailfrom=mandelbit.com; dkim=pass (2048-bit key) header.d=mandelbit.com header.i=@mandelbit.com header.b=ETGwTXqI; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandelbit.com header.i=@mandelbit.com header.b="ETGwTXqI"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4560cdf235cso23659775e9.1
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Jul 2025 13:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mandelbit.com; s=google; t=1753130318; x=1753735118; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZwS9SNcnm3V7/gtRA8ZdfIBKvMjo4/gCeN6JSpiTM+Q=;
        b=ETGwTXqIwSiaPnp29AN16G0HQrGYjuiQC5XtwKOOtZdVFvBMwqKcn//DhssNNZvV3+
         VMD41cLCdUPnDPfbWboaNLYfouHHwzcDcs5edh5MZ1sE509TK+cmZCo7snGlgBh7BWa8
         y//LVQtDHevsk13jcvsscG1nAW1BBENWZ8EQtnFRYjAfP/uMd3pybuDabY/KBq1LcyNw
         MDujUGTb2nEXFrrWJUt58NCpGS1Pcw4OeBawQfiQsQTw7mLKXNLNYbyzVmlWrBYRFV+w
         S9c8LlpMZNh1uTR9dy2/7q8jiPRHLI5L2teEhW/Bj7dmH1kPrJvM0WYhCUWgxQoz6WWZ
         SZww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753130318; x=1753735118;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZwS9SNcnm3V7/gtRA8ZdfIBKvMjo4/gCeN6JSpiTM+Q=;
        b=lMP0R59g7qDi6cf2vAdE2vlHQC9/HV46sJI1ft3Ud0XpCWmee+axUlk+nLEyAs3Ixl
         7z9Hoy89VFJ+VDkiLujffT3ad8t+lH0bQsuQdkxaOh+p2gmjMrDjkzooZnW5OltEOCc2
         cIET2TaPE+yXABVWYPyDhYEOD7j8MEFI7GHY8Df8PTolVAbVnyaqhh5gDpdEo7EaBTJ4
         S1fucP3DkLLbtn1EXiZE88qZE3w9OJ4M+eAr+IZ/AQM7FNas9w1CTXoh1BHgKGjTVGzv
         qIyw3EFYhDQzX0sEvdqJgnfeITABYqlflFAlorVJxazSMBcXsOe/n1n2acyBiI4RZjRb
         0UnA==
X-Gm-Message-State: AOJu0YwkhanF3AJrsvmhvyy67MY6H0DDAS6Rxg7VUES9tEX9XfwQiphT
	jcf5h+br370se2ge8D3B5SnE0ns6VCwBuMMtbv4BTHSLPg/cHCG89+DhShHIwPyj0wuIQxoqcHK
	zLACEpd7/EQ==
X-Gm-Gg: ASbGncsZXca2Zw8mwvyk0+tJiP/SA0jQbsc2m+A4USDg9RHST6pCMPYjxgQb3kX9/NG
	BUoySCJeZC08CZKKouxEehTyO2r2lF3nZf6ta5ilUdCjAqFUisBOIV1rloNGne1QovX0I8qSkIb
	d6ALil2v/d1DTzAK3GR66+6GqxLfOn4H9FS4nQKA9U32peRXKQqO7EYpP/hg2L8AAzsHmoNzFFS
	dmceaGOe1tExTpl2j45KIJ5nXJRWJ/nZteLRpeijEleh8N+HW/alnvUqQMI38cmE6Qas/PiyxDY
	G15E3Roh31a4++UxKR3kqQytmms5i6dIatemKPNBFyTgBoYhcA9M7WSz+TPUxl04FPgqovo+MJw
	FVdad2V8l4TwuuCtCb0O1pFC//Je+DHTnB6Z2DB00IAk67OLy
X-Google-Smtp-Source: AGHT+IF/iZmqKymYg+U3PZCXI47bCs/Ql/JnJsK6vTJXVmDfZEfm5WcgXvuETrr+JfJyIxtQ9lNg/w==
X-Received: by 2002:a05:6000:64a:b0:3b6:1a2c:2543 with SMTP id ffacd0b85a97d-3b61a2c2743mr9765082f8f.6.1753130318177;
        Mon, 21 Jul 2025 13:38:38 -0700 (PDT)
Received: from inifinity.homelan.mandelbit.com ([2001:67c:2fbc:1:834d:bc8d:cdb5:bc29])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4563b75e9e9sm111090215e9.34.2025.07.21.13.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 13:38:37 -0700 (PDT)
From: Antonio Quartulli <antonio@mandelbit.com>
To: linux-unionfs@vger.kernel.org
Cc: Antonio Quartulli <antonio@mandelbit.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	NeilBrown <neil@brown.name>
Subject: [PATCH] ovl: properly print correct variable
Date: Mon, 21 Jul 2025 22:38:21 +0200
Message-ID: <20250721203821.7812-1-antonio@mandelbit.com>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case of ovl_lookup_temp() failure, we currently print `err`
which is actually not initialized at all.

Instead, properly print PTR_ERR(whiteout) which is where the
actual error really is.

Address-Coverity-ID: 1647983 ("Uninitialized variables  (UNINIT)")
Fixes: 8afa0a7367138 ("ovl: narrow locking in ovl_whiteout()")
Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
---
 fs/overlayfs/dir.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 30619777f0f6..70b8687dc45e 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -117,8 +117,9 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
 		if (!IS_ERR(whiteout))
 			return whiteout;
 		if (PTR_ERR(whiteout) != -EMLINK) {
-			pr_warn("Failed to link whiteout - disabling whiteout inode sharing(nlink=%u, err=%i)\n",
-				ofs->whiteout->d_inode->i_nlink, err);
+			pr_warn("Failed to link whiteout - disabling whiteout inode sharing(nlink=%u, err=%lu)\n",
+				ofs->whiteout->d_inode->i_nlink,
+				PTR_ERR(whiteout));
 			ofs->no_shared_whiteout = true;
 		}
 	}
-- 
2.49.1

