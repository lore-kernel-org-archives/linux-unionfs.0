Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com [209.85.210.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17702EAD09
	for <linux-unionfs@vger.kernel.org>; Tue, 27 Jan 2026 10:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769511178; cv=none; b=SH67fiTRrWICO20E9o9DVtPJSj+YO7DEhAY7XMSZ81aVvHTlHEVgyUhCKwUj6pqO6BKNQcRBC+dvK3dCSJpAVfQYW9LA84tQ0z48CjjwRWvGfV7lTKdmdWiJA5uDs/he9baGWGkpq31yACbRD7GwplKgDj3pma8FG6aZjS/WBp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769511178; c=relaxed/simple;
	bh=En/Se5eT1cyDDsJaO5Kf125cNLXL7U45chKBQHwXqW8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SZRx7D5xbTohqZdxuDRdmsNSS2meA/zP/EQz21ysAVOQZZeeHbL1+IRG2vnxgq4ZmHYXAxmpbunFSIHfVk7PDBJW2bWDPLZsOIQLYHUIs3EXKm+Tbh5t2/S1FT65I+vVRtzbPmQ2t4daLQpdB82ADQ9RCDSZJiQ6+/DCq8Ii9vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eVd7bawT; arc=none smtp.client-ip=209.85.210.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eVd7bawT"
Received: by mail-pf1-f194.google.com with SMTP id d2e1a72fcca58-81f4c0e2b42so2834186b3a.1
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Jan 2026 02:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769511176; x=1770115976; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7XC+PE/hccOFyup38uEVWA8pli557/iQjh+X1bKT/84=;
        b=eVd7bawTiPmcyzZhPn9t2Dlfi842rBJ0Z6+dEMB1b89oA0C3vaRXHexrmPzaroXaFo
         ji9/fu+I+ZbkZH/ZYlD9s4Ef5+qa9VyPf99MRiW4Z8YGvnONymmocZ9DOu7lahoKeGaH
         5B4uipmx8H4R5BSXJ/v+gRSI0BUl+8aQQ0LilU+UQxfvUjLGUIXxhQCEwxXnvdgY9Hc8
         Lggzu6EXfwpbhWJhe9qQXiQ6U7TWjFoPejX8abzeFG6kWtf71BMfWdIlc8HZvPd6U8h8
         1b+a4QE/xKCDbjuq1tT7f+jNiPh2088fRDrLi4bL514nd56oXNayiSa1hvhFRFfKe4fx
         Wu9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769511176; x=1770115976;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7XC+PE/hccOFyup38uEVWA8pli557/iQjh+X1bKT/84=;
        b=URKVmn4na6yWTBKsjS3hf8N+F7CYYHIIaFiL5xSVkiffmkKIAjp0bQhrYWJA3oNNtQ
         hZG21uBIHpQrOWi025f8xrsGlTrJcZlQVb+Lq2PGM/j+rN4hAUWr93CtrxOYoanEzOpd
         l7ty3liwocFiFO3VFKIo2xAyWG1ylnpx8W/2ByaZ3yQ36MNYEm9BO2z91KEF0XRuZtXX
         9rmdaJDbKzBdGOiYaAF2g0VVJgstPnyln5O8/jYWz+xq1d+Gq4zgvkVwcddrGh25ZBgW
         C5DVN8mw2qmWmoS2qrbmvvXp1CZ4eZqp5JZ1GBQo7IgF5WiuOCxwDzKhDKo7pYgwzF4S
         qmRw==
X-Forwarded-Encrypted: i=1; AJvYcCVir3ID/H2S+z1GUn2I0KGuBLu4Pa1k6rCk7WajRcmdaNfDeXf+rAae9loQATVEkTD0GAvhpmlziJo8zBQ/@vger.kernel.org
X-Gm-Message-State: AOJu0YycsgZXXrlv+IHseEcYmfFXjRQtUOyZta6IRkP0aaeFxqkmGYkV
	NPfeIEmTR1Vuerr84riPpmUTfcRsG/5C4S8urxQ1DGGmZWviBJlhw6Zn
X-Gm-Gg: AZuq6aLJy3DBXO7Ws7Gp/GJBHNaM1F9fUi3BIDsd0HkQ5R4jX6jppfrPEbzKkomkLZg
	gwv/ye70zd1zFPRw+4UFlCL03q8IWkoiXkNSKIyFC6bSG/zzGY7ckfcpJPGytAgXGLJGRsh438s
	nXcFucgfmB6hl+zAAQ9xkMo3i9u77YLfLORvHwP8VUZMwmtTy6JgAX81gCxm+j3+oZN+oBY/3tQ
	bH4ZJ47sqnd8qVmQ1M5cJbQyfzyiLJ186WIDwg9jzI8peeW3Yz5PWxLwb8cHgH+v2y63gPo9m+e
	KlmG/MnpYALUKnWXOu8ifEmXoKQ6GBsSx9gwI+HV8VZAXeAWQdqj98cfZBgxEqBupr2j3wFGJQE
	XlR65L+wCXrvn8dubf50KdofrT8yIvatxV7QJxvW07zw5Y3WJG9kHBbB0mUWZXtq4yjmkwrrs2U
	Ae4Tc7s3mOlrW3oXmzbYJjBMGXZlXOWsdXB5gqxg==
X-Received: by 2002:a05:6a20:a106:b0:38d:ea8a:3dbd with SMTP id adf61e73a8af0-38ec6582a0cmr1203045637.73.1769511175901;
        Tue, 27 Jan 2026 02:52:55 -0800 (PST)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.220])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c635a43fc46sm11078613a12.36.2026.01.27.02.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 02:52:55 -0800 (PST)
From: Qing Wang <wangqing7171@gmail.com>
To: miklos@szeredi.hu
Cc: amir73il@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com,
	wangqing7171@gmail.com
Subject: [PATCH v2] ovl: Fix uninit-value in ovl_fill_real
Date: Tue, 27 Jan 2026 18:52:48 +0800
Message-Id: <20260127105248.1485922-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAJfpegt_n85jDSe9k9GcC_9KB=+R_oUeJTPt+3XSPkhjBPm3NQ@mail.gmail.com>
References: <CAJfpegt_n85jDSe9k9GcC_9KB=+R_oUeJTPt+3XSPkhjBPm3NQ@mail.gmail.com>
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
index 160960bb0ad0..9ea3cd11dd93 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -755,7 +755,7 @@ static bool ovl_fill_real(struct dir_context *ctx, const char *name,
 	struct dir_context *orig_ctx = rdt->orig_ctx;
 	bool res;
 
-	if (rdt->parent_ino && strcmp(name, "..") == 0) {
+	if (rdt->parent_ino && namelen == 2 && !strncmp(name, "..", namelen)) {
 		ino = rdt->parent_ino;
 	} else if (rdt->cache) {
 		struct ovl_cache_entry *p;
-- 
2.34.1

