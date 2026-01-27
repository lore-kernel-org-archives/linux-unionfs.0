Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84B02857C7
	for <linux-unionfs@vger.kernel.org>; Tue, 27 Jan 2026 07:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769500465; cv=none; b=QnjAnUwfM64/PwBMeDt8gtYHL/OceOkqOurO6H/GVj2NfIxV66u+HKtlwcqEjgmQ7ocAxmHdKbPgMEBADjxIb2gRlsLL6FqEIhBMG54DuExzvD3gL07Cj57j9nBgNIKPE2Jb6isoiY8fQJhGDsn5p0/39xeOXhzcUlhqTjde5j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769500465; c=relaxed/simple;
	bh=sva4oJ/jLabX24xc2S6XLTPNwMIB2gnGJhMFmbQdvy8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YrvxJTvA1iqgohWDOT4zFkKNxEl8aRoFcOXHXGo+wVkBfWJXQBy8O5FBECjffbo4VqXXO3o0jHWtEXuPAPHZud+GyRt+3Z/vmFKn2pFGinOONhjDfzLM2pWqf3EbBjOza7MxJyGq8vgE/RqQtZ7iOe23dzCmYNGlrggPkroqxW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NPJJVw82; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NPJJVw82"
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-2a2ea96930cso33462895ad.2
        for <linux-unionfs@vger.kernel.org>; Mon, 26 Jan 2026 23:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769500463; x=1770105263; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DxtHOOpBiQrOJRLwsbdkcCVvw91TG/jEwLuMVFsF7UQ=;
        b=NPJJVw82MB3lWOzmFGv9xleLIfb1TwH9nAmcQWVzXDhu0a5evXtALhLGnW+gL0DNqQ
         lW+umzdQ5shTQfttcxmJWaxYvNhAdCX5lNAIFwgksGQnH77e+fkiri4MQovRuPlUQdGP
         BYAhjNiJu9IYM0AQTCTC8GvPQEzIHO5u0Sn2hi4VMFsQLhQTkPcSqcMIX83QAeb5rD8t
         WG8twGpfGVm+eDbeut34QUn9hVrISgZqB1jDrO3heqM/e27bwtI8iCvXWCo79NgOdZcJ
         gAydfreJORy22XCQBYf68/gnhcJgrZmT57yk1DnGNsTUsinkQ39DnFsjfWxIUZ9OaloB
         l5Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769500463; x=1770105263;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DxtHOOpBiQrOJRLwsbdkcCVvw91TG/jEwLuMVFsF7UQ=;
        b=WuCt9wknuETb0c5Q+EUcmD6zlZOtEAhwBbRbVeFMOP57rY4OM/JopleNlw2OnXgUOZ
         ZPRczJkaD/tO+kqjMU8vJKXtiwNhhdLRqqUyGmMgqt7XJLttTEJQn7Pu1XWbkQ1SBKVU
         ApujAX8eA7SRzTO7rqtYIvHD+6TEROiskJcZIEKNBoFl0b5WmRl6quaj/6v59YBWy4Fi
         xaobHNhp0msQku6y5Z+Zhz2idhm0WEe4WWPoSWUX93Z6//BuHA5DIDI0At8IgQ4Xt8gc
         mx2N4dLRC4/uV+MPE289RUVNpY8N8EJ6RhHj5bBToRYtelSnhw8nyg+6apP71NqRCBkz
         JMEQ==
X-Gm-Message-State: AOJu0YyiCivDVFTbcucLkdBSuKFn8f4mpZyiiXx5QzrEtOo+6MmPiVq8
	HvLHOOhz3unl+jueWnJYW/aveMLwLauf5y8TJMlGqijvNgY3a6huT1Qy
X-Gm-Gg: AZuq6aLp6yuYAe45FWbpE4U2ZeIfIhMHiXYUsc2NcX8OlTeTIuRpCpKBTCvrwUzAQaW
	s5jHSdEpkbuGh1IzI3+lIW5MUtoOfk73R9unCC6voUsvdC4lQFKqI+OmxV78lNHE8EamQ7CLRnX
	lNdlUMmNO+8vrytsmVCe+Buks/7rUcPVmHin+T8DP4/3rMEy5Gx+2mMYA04oxtMUec1cQQ71HMj
	LSGBDsoSxUlLZOd+5aFxrcbecoHxFzkfdP16pTBPNwR+Zlj6mnWL6tSqo/DawOmjOx/g54EDsFK
	e5BXNWKTIHrBhfBoa9bNN7FtJp8gskClnfzszJOfFWsDXsM0IVMtj6k8DOuNhTLEVwDUuxZry53
	MhnlgZX/QfKGWMOQfwXOeD5C5EvxhgNxguAbdjuTfhSHDeK59NhqaEL84xZMHfwj3C2HIhbqS/F
	Fzum5eN6aOpupFoCSKuT+JP+VhJWIFCFJlaHTZVw==
X-Received: by 2002:a17:90a:d404:b0:343:b610:901c with SMTP id 98e67ed59e1d1-353fed87a55mr1008063a91.26.1769500462899;
        Mon, 26 Jan 2026 23:54:22 -0800 (PST)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.220])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3536aeeec03sm4575762a91.0.2026.01.26.23.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 23:54:22 -0800 (PST)
From: Qing Wang <wangqing7171@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qing Wang <wangqing7171@gmail.com>,
	syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com
Subject: [PATCH] ovl: Fix uninit-value in ovl_fill_real
Date: Tue, 27 Jan 2026 15:54:04 +0800
Message-Id: <20260127075404.1110552-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot reported a KMSAN uninit-value issue in ovl_fill_real.

This iusse's call chain is:
__do_sys_getdents64()
    -> iterate_dir()
        ...
            -> ext4_readdir()
                -> fscrypt_fname_alloc_buffer() // alloc
                -> fscrypt_fname_disk_to_usr // write without tail '\0'
                -> dir_emit()
                    -> ovl_fill_real() // read by strcmp()

The string is used to store the decrypted directory entry name for an
encrypted inode. As shown in the call chain, fscrypt_fname_disk_to_usr()
write it wthout null-terminate. However, ovl_fill_real() uses strcmp() to
compare the name against "..", which assumes a null-terminated string and
may trigger a KMSAN uninit-value warning when the buffer tail contains
uninit data.

Reported-by: syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d130f98b2c265fae5297
Fixes: 4edb83bb1041 ("ovl: constant d_ino for non-merge dirs")
Signed-off-by: Qing Wang <wangqing7171@gmail.com>
---
 fs/overlayfs/readdir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 160960bb0ad0..2581cb33fb87 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -755,7 +755,7 @@ static bool ovl_fill_real(struct dir_context *ctx, const char *name,
 	struct dir_context *orig_ctx = rdt->orig_ctx;
 	bool res;
 
-	if (rdt->parent_ino && strcmp(name, "..") == 0) {
+	if (rdt->parent_ino && strncmp(name, "..", 2) == 0) {
 		ino = rdt->parent_ino;
 	} else if (rdt->cache) {
 		struct ovl_cache_entry *p;
-- 
2.34.1

