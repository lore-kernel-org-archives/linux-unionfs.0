Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A52D342CAA;
	Thu, 21 Aug 2025 13:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755783784; cv=none; b=oNldrTNzp4Dn5bCJlKlnNJQDF62XkUK1smDVhOCLik/gcIFUgSNakueqdVhqEjdkADpN9YR+kOwZ9680ueU7YX1AXQRY9He+fJz8gu8ORsb29+XwaoqYHb4yphuPB3AdcDAqES4rmwjAxep4UjWGKyOPfx2pCb3G43aZuDdgj9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755783784; c=relaxed/simple;
	bh=U3lD0if9h0TDpItAoN/yVgGkOYGmElvkZDQn58wqc8g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=THv7sgTcl5ErbMPiu3vQxu6qaWoYvDbZpGeQU4SYaU3JeFZmxg8FrTcNYp3zSc4C6B7uGrYLjHpH+hW+dPOHpT8mPjlh6lIrNLWWSwNb4clIm5KPmf/5k20odyzejZAwCD1Yk648N/Rg1AO953vK39XH1TvYmUg8tfht3VWHXV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OUjrfAO/; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OUjrfAO/"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-619487c8865so3587408a12.1;
        Thu, 21 Aug 2025 06:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755783781; x=1756388581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sPpRVfE3HiLUCQGB9lSpWUOTDrxZVT5obWAyeQ1uE04=;
        b=OUjrfAO/Ha/BUe08VFXbaNksKVEtEuMZc/pGPU03BxMnSPRyAKqGV568PQrqGC1jwa
         6xzGx5NA97MbFs8mw2+bW9FLXrDc8JFswWw+qwv5X09zv2zjjQDkuin1ZP6yrr86QbRK
         /I6l3qa2yCnwzOVcTiolQNwox0wS+qjCC1LKwDgKT/LeCvqueqbbA5xuGDbzPKQfPrpw
         yk+qQr49jmCEjrWqvqO9eXLPgaRUP7+g+s9m/EZpptj7sYewVgn8S9tWJuxBiNy4zJCj
         tIqX6czfDTXcp/o/9JBNe7lHgzJQU8K4cPujFDcrF22JJf05EMY6bu5nkYpR07KrK1V/
         EL8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755783781; x=1756388581;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sPpRVfE3HiLUCQGB9lSpWUOTDrxZVT5obWAyeQ1uE04=;
        b=ONBWZ7FAblf0FN44ZA2C6+E5ADX2F02P+zEICIuMK8D17wIicnSaJ4yqFjnGMRHKZw
         VtGFCN1v9+gNBMoLtVmbkVLwhqYbm0CLbiDzwZ2hipYJY1hn+G9dtu5l/BZp6KU6vq5g
         a5utifZvLD/3zgjcFEyTTlsxIo/6qaHPyijHS9o0cpJ7Ugxoyw53T7dzwrspBj8WhnpZ
         1g5/eDrdZZbPWdcO6dEX9Vql5dxVNdn4+2+GQ4obccZUDvFE3xBFTFkNbeUSx77uHoIz
         CHB6Zs22mXZR6ipSpPTBBbJdeTdAygC0Y8dW1m7nUaChZTMe+VAWpikhKFUtJnt5f2IV
         JRxg==
X-Forwarded-Encrypted: i=1; AJvYcCUXhRuiFJA3UTKIkmafPWPIU0z/ka61g1/2vcSZt//Y8/uY1PN0Q+vuCurMyY722IQ5KD9/IYhw@vger.kernel.org, AJvYcCVwRGO0EBfMLslp+53bhHSVT04VeHrJS/+Nns1SW2JU8o+kykV/TyxEvWqtfTm4oL4XmlcAnyQBic0IjdJC@vger.kernel.org
X-Gm-Message-State: AOJu0YwpNEGn+KKDpDmcKjW8H0zyJCh6MvgV+BEQdpgrXh62iZeTzDUQ
	xgf2d3VtXI13GcocbMNvSsANZuvQWEDOWT/389+EuYU1P4kkbL95VysHKWi7JVE/
X-Gm-Gg: ASbGnctRsSb9zm7i3M6OcKyBHd4brRGpMRvbk2Zov+IXpdvWMiBbJ8YMnpiZiwSjX4I
	cEy947J88FWhqmaZfHIDjig2qv6PSnepP+hGY42Xf2pcm1ZKHhBfrx5puaopI2rv/8bVqIr4VYN
	Vx4cG35C7eMBPLFkYa9PX5i2PH5/rN9CveWgX5fCfHZ78ygMzIPTYtjz9AqsJjasjIEmiCZBe1t
	YXavTgSFM5Ykl6cOqrfghTEjqvX885AbNqY0vVcAd4IwADApH9kTvvf5mGIhdSUiD+oQN/Ifxlp
	q77yDxKg6+dr9KL730od6c2JQIdYUOXDqh2jsqkosS+OgUGSU+el1LQ6kocUYfv84AoLr9rez2i
	ecD/JiT3z5mXmnAi3qAoVSBRc/uDZzcGRwRrxvjL72F3UrFYsMvWusuPtwc7a8Kuk75GdXc/eqo
	EAF4LDcuHyWOBVDqb3RR5lmug=
X-Google-Smtp-Source: AGHT+IFB4KzrTSBfENNo1r7jRNPAT4PoioswUll+IRP6Eay4vEUXeuVwmHv0Ywop9yUKqEYE71QN3w==
X-Received: by 2002:a17:907:c13:b0:acb:37ae:619c with SMTP id a640c23a62f3a-afe0ba5e269mr235879166b.15.1755783781088;
        Thu, 21 Aug 2025 06:43:01 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (92-109-99-123.cable.dynamic.v4.ziggo.nl. [92.109.99.123])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afdf24bc40dsm341995766b.109.2025.08.21.06.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 06:43:00 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com
Subject: [PATCH] ovl: use I_MUTEX_PARENT when locking parent in ovl_create_temp()
Date: Thu, 21 Aug 2025 15:42:44 +0200
Message-ID: <20250821134244.846376-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: NeilBrown <neil@brown.name>

commit 5f1c8965e748c150d580a2ea8fbee1bd80d07a24 upstream.

ovl_create_temp() treats "workdir" as a parent in which it creates an
object so it should use I_MUTEX_PARENT.

Prior to the commit identified below the lock was taken by the caller
which sometimes used I_MUTEX_PARENT and sometimes used I_MUTEX_NORMAL.
The use of I_MUTEX_NORMAL was incorrect but unfortunately copied into
ovl_create_temp().

Note to backporters: This patch only applies after the last Fixes given
below (post v6.16).  To fix the bug in v6.7 and later the
inode_lock() call in ovl_copy_up_workdir() needs to nest using
I_MUTEX_PARENT.

[Amir: backport to v6.16 when lock was taken by the callers]

Link: https://lore.kernel.org/all/67a72070.050a0220.3d72c.0022.GAE@google.com/
Cc: stable@vger.kernel.org
Reported-by: syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com
Tested-by: syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com
Fixes: c63e56a4a652 ("ovl: do not open/llseek lower file with upper sb_writers held")
Fixes: d2c995581c7c ("ovl: Call ovl_create_temp() without lock held.")
Signed-off-by: NeilBrown <neil@brown.name>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index d7310fcf38881..c2263148ff20a 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -779,7 +779,7 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 		return err;
 
 	ovl_start_write(c->dentry);
-	inode_lock(wdir);
+	inode_lock_nested(wdir, I_MUTEX_PARENT);
 	temp = ovl_create_temp(ofs, c->workdir, &cattr);
 	inode_unlock(wdir);
 	ovl_end_write(c->dentry);
-- 
2.50.1

