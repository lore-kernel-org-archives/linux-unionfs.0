Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE24824A1
	for <linux-unionfs@vger.kernel.org>; Mon, 29 Jul 2024 03:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722224611; cv=none; b=KsLjQroTMl3/WxvXI6SAsUxZA7iLcDLr/RCHeuCVceoRGZK/YESvzhVFBXYtAx86Hwx0f/u2NSjPPgctTQpQUAA99urpJ/d/IeKpiahdXIy/Ahe4wRYKDkQKJmtFhC6RgLHjLX3Vx4rBJM/lh/ema4nglB47I5EZCfbbVcaDyZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722224611; c=relaxed/simple;
	bh=pEkbjZbID4Zq2j7DtzyhYW9aOgsLz5p9bS111yh9LLc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=foa3jHjl6FMUC1p++uimkxE/dLy4djzE/kmBGc3zilApzu8t4U8UqQvhL7qakQ9lXfxSNGaWy6984/rOJ/yuU7JtX85DNTlpuls9HJs15ovUvmKCLKz9GchRtGhZ5dGuynjdTvc2WE9tW3XDYt4rM0aj4PsTPdOrFZZ68IYRw40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com; spf=pass smtp.mailfrom=shopee.com; dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b=hTfn86/P; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shopee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b="hTfn86/P"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1fec34f94abso15602385ad.2
        for <linux-unionfs@vger.kernel.org>; Sun, 28 Jul 2024 20:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1722224609; x=1722829409; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=piHZCWX7KlSFhT01GfvCJrIPEKqLIYqxVjk4iuVXV5U=;
        b=hTfn86/PA0QWaTkiRxFUSsaeszf+W2+7W9PeLTA4ygzmdq7QlGSg6ry4zn1Ag9+gJP
         wLCKFFYNzdJ6W9+q/+jaSEnnRQogz3fCaBXssQvmvo2/gDn9KTJOwu+TDfJpieaiGlqP
         BcFyISfUgCtlgnAG9rYRjdd4/GJDMyRZ75zIcZRXrJGxMpqumsjKsVKYZpEHIay+H0Pa
         PxSzDRWLL2FlZ0a18+faHVR0ivaStRYKweju3F5LJWUgRWMVSx8GUgh4mxOpiS90Kzv6
         QFMAUpGy8r0iwEeEqfDRXIA/6jB397SUI7n6Fqb0mATk4grcw14SgMJZVhLOi/kPBq50
         LBOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722224609; x=1722829409;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=piHZCWX7KlSFhT01GfvCJrIPEKqLIYqxVjk4iuVXV5U=;
        b=WRFA/9QPauJb76rRHak3bmdKgFkoztBjDJ1btQVqlrr7A5LaoowwN7r3XGaGnhdH3L
         P66mP+sjrEXgG9EQ9Vg5qS/p8V6ESPHgZeHz+jI9Bqs/MIExjD57Mnqv7xF3lM43yUuB
         JISvOGUQxxtDB1BCI7EA4VsGTonP+nsdai2EeosYlQo+b2Co2e90ihoKSpU/olQefJEE
         3IxUAETN5QJ+GGXhPbmHX9SCTXhnOkFeP5rpRe9wvc+Q86a5ef2reRcML6kAgjn4SJ2j
         bTZ57Uc/I9mI0Ed5F9DlRGaFsJR46Rfe9+0VhrggiHe5apMkxxBuSCWFouQE+WHJJmXT
         l1Aw==
X-Gm-Message-State: AOJu0Yyee3lfi2gkpUsc2vFnfAO0Nki2N/wCsPaQLWC32TjeQBoN31qb
	wuEGs2h2pyq4LeiYuXxwlBjkcpU60KQFC0Dpv1ZQf+qaYMaWyKbKdHR8kpIGZXM=
X-Google-Smtp-Source: AGHT+IF2b1afqpkK6mLINTP2M8mfrCg5KFRVnTaJ9z97pZ/8UZWwnShZFRvCTESYMiewL0mt65dCww==
X-Received: by 2002:a17:902:e5d0:b0:1fd:9590:6550 with SMTP id d9443c01a7336-1ff0494bc45mr44139635ad.64.1722224609418;
        Sun, 28 Jul 2024 20:43:29 -0700 (PDT)
Received: from localhost.localdomain ([143.92.64.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7f1ac12sm71553295ad.186.2024.07.28.20.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jul 2024 20:43:28 -0700 (PDT)
From: Haifeng Xu <haifeng.xu@shopee.com>
To: miklos@szeredi.hu,
	amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haifeng Xu <haifeng.xu@shopee.com>
Subject: [PATCH] ovl: don't set the superblock's errseq_t manually
Date: Mon, 29 Jul 2024 11:43:24 +0800
Message-Id: <20240729034324.366148-1-haifeng.xu@shopee.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 5679897eb104 ("vfs: make sync_filesystem return errors from
->sync_fs"), the return value from sync_fs callback can be seen in
sync_filesystem(). Thus the errseq_set opreation can be removed here.

Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
---
 fs/overlayfs/super.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 06a231970cb5..fe511192f83c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -202,15 +202,9 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
 	int ret;
 
 	ret = ovl_sync_status(ofs);
-	/*
-	 * We have to always set the err, because the return value isn't
-	 * checked in syncfs, and instead indirectly return an error via
-	 * the sb's writeback errseq, which VFS inspects after this call.
-	 */
-	if (ret < 0) {
-		errseq_set(&sb->s_wb_err, -EIO);
+
+	if (ret < 0)
 		return -EIO;
-	}
 
 	if (!ret)
 		return ret;
-- 
2.25.1

