Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92364352C3A
	for <linux-unionfs@vger.kernel.org>; Wed, 28 Jan 2026 13:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769606652; cv=none; b=pvPwvBepIPO5jVMcJcxo3M3ebIEmLcITN4TsPW/ahgTTQx8fmQYIB+linpcaf+NyMFk1CROg6eiwU4Lr/+DTVO89G2nlNuTyoLCZOgcTIJg+YtVLrGn3hVQNoi/busPI8thCvgWi3NVsDVw2/nlbVcsBiOVSAueRHY9nhfuakGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769606652; c=relaxed/simple;
	bh=by5c7OBWmvzWhVys6tF6T+VYllXJ1/+r8xSpNq3nuBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtdrvhDHjX1FuDb1TXSif5XewDwUxIhJz4W/lQlySG36naqg6w1yORajhlsEY7tTuwGSkyqtXjvk10aHQa2lomr3p6vbdI3/VNLHi6ZtM2AaMnAbmU07pBMj8KB0TNGqZJK5O/OZLwy7VH+5JlxmNbW6qIuYWY8bKSdh51OF1so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W7nt6ktY; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W7nt6ktY"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-65378ba2ff7so10302395a12.2
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Jan 2026 05:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769606649; x=1770211449; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kxRM277namVFNLdkVHTNF4KV4lqJB7EgGMx8/qf8f94=;
        b=W7nt6ktYD1RiYz7pLN3PILLQbdb08/u009q6bRnAlNJiVOEJHRL0t1SR22otnk1NOC
         R2+KUUGfOWhX931UJKyosaYw2rNAzzXfb+Wfo+bxZWeW2FQRLcIlBfSOyaIPZqrGLKtY
         Y9CEKp+y3CrTHht6gaBKb/4cprKUfaF4iFMbIi1kXePlPeTgFgZbPZvTKwwSuVH14EyW
         hzNK5NDI5N/QoOoVjPlcgLd06+aFpLLNX1nmV2mcfqynHEKWf53Hpg+ilU8gPxVP7LBZ
         J747uuQqwoxIUG9shomO9o5KIt1eP1a4GFNZaJ59P+5blXfNNIc+V8ZEGoKVbdsD3Ifw
         eBnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769606649; x=1770211449;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kxRM277namVFNLdkVHTNF4KV4lqJB7EgGMx8/qf8f94=;
        b=JsX9LvaBpR1kTOgxF32AUjdQXZW3Y8HKuwVdN8l3c52YwRyYm7DzGt1rcM2K0VQnmL
         jS9BHPZoJeLcfuw9utSyuDew6eU10q4QEZZjruBnzoXVElouFXTzvREdRFbnh462O+wb
         uB+kVtGzWUrOg6hTIUesUSF5Y1QRg5Bqiq/1vFJWieBGogwY3Xt1TAUSZJ08+l+lDZ95
         INA2omsois7J4N8VIEDAZulquSaCRy1V2bkJScf27oa/oMiAPoOxas1wq1Sn63O0P4tf
         r8rtdg6OmVzMW1Jb0p3ScB8PJztbiMpL1Bpq7lTIZY3djgNA3Fd+KXr2m5y44xaKhbdB
         scbw==
X-Forwarded-Encrypted: i=1; AJvYcCVJ236Y8t2IYpwE49n0OGhoW/6J1EGTCQJ0bBqVk+/KSXqSr5HLmNUyP7uQPvJ85k1ba4IO99AjgQWHZ9sF@vger.kernel.org
X-Gm-Message-State: AOJu0YwcqsXovxntMZqRzumqFLutX8wYai9w0LtHxP+RNPvaaVabmLtD
	dxeDnlCBoLudTNYcKOMVrd4dsVw0QcvsOnkInwE6etwTeoRAqBweVX5k
X-Gm-Gg: AZuq6aIv/HpgWrCMl9E0ja2wBYwSkiWtXrG0N5yuD/1IRuG+HYgvlQliVmyvIq1lPC7
	SUuoWmP3GSojTxhNbRF/fqO4nqjSsgruMI2kqB24G8cjyzg9Kd4MbtVnmsU2irHtfZltrzurFce
	JGwUzJFmx4VDdVQQeho9CTsZd55yFz6gYde5c3Ttm5sJOv2XjLMMIA9sHA6Wd5A7TQ5v1VlKN95
	KMqs5olRSodsVrx6vR+/pi40iJ1iIgFHnXUTQZoytuGj4nLSGb3bllA36/ddsZB5iOto4ywyy02
	tjOCerz0QKMZs9wlMSO6t4iRVqoyMNBTTWw7dZ6y/mdcKBu4sRE88o7EPBgxVE3HiCHmHl/DnyK
	5jQZk2P9mC1sQ/qUajzzIFDGK/TTPBWWd4ZwOxwerGQRxYnrAlC8wypZyOlo60fG9ijNa+CKe4p
	b3Gl7L2fjCAOz+p5WIcPTBk37/UhzU5TIXgc2bVLkRdpPEhXTZWYsGg549l87zYzvt3D3T/ICTc
	KGXlQ9eaQYYLNPlJl/wqOKZvYU=
X-Received: by 2002:a17:907:6d0a:b0:b87:1c74:a8c6 with SMTP id a640c23a62f3a-b8dab3f022dmr389917666b.57.1769606648807;
        Wed, 28 Jan 2026 05:24:08 -0800 (PST)
Received: from localhost (2001-1c00-570d-ee00-c84e-f30e-bdab-df5a.cable.dynamic.v6.ziggo.nl. [2001:1c00:570d:ee00:c84e:f30e:bdab:df5a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8dbf184343sm122306466b.33.2026.01.28.05.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 05:24:08 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>
Cc: Qing Wang <wangqing7171@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com
Subject: [PATCH 1/3] ovl: Fix uninit-value in ovl_fill_real
Date: Wed, 28 Jan 2026 14:24:04 +0100
Message-ID: <20260128132406.23768-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128132406.23768-1-amir73il@gmail.com>
References: <20260128132406.23768-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qing Wang <wangqing7171@gmail.com>

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
write it without null-terminate. However, ovl_fill_real() uses strcmp() to
compare the name against "..", which assumes a null-terminated string and
may trigger a KMSAN uninit-value warning when the buffer tail contains
uninit data.

Reported-by: syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d130f98b2c265fae5297
Fixes: 4edb83bb1041 ("ovl: constant d_ino for non-merge dirs")
Signed-off-by: Qing Wang <wangqing7171@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/readdir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 160960bb0ad0b..724ec9d93fc82 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -755,7 +755,7 @@ static bool ovl_fill_real(struct dir_context *ctx, const char *name,
 	struct dir_context *orig_ctx = rdt->orig_ctx;
 	bool res;
 
-	if (rdt->parent_ino && strcmp(name, "..") == 0) {
+	if (rdt->parent_ino && namelen == 2 && !strncmp(name, "..", 2)) {
 		ino = rdt->parent_ino;
 	} else if (rdt->cache) {
 		struct ovl_cache_entry *p;
-- 
2.52.0

