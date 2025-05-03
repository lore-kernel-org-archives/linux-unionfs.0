Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969D81DDA00
	for <linux-unionfs@vger.kernel.org>; Sat,  3 May 2025 11:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746273170; cv=none; b=V0zheJ6eIzvvDBUoEKDvKvpRGdzJrAlGQkUw3EduuDtyuAxV0pLdzfzxTq/+JcOTEWY1pxcWGwdovEok4bGaHwqfIgGZbZGiVlpb6MPTpc+Kn3+0uH8ENs4hXBKxtWcB71YYXKieyOCBW0q0PayhrPPbX97csLJ580meSQkmhsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746273170; c=relaxed/simple;
	bh=+VOkYvZgU76psOdFtOF3W43doZlN1sDEPP5n0VsCTSY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JXn7J85sh+2dZdXvA9sJf6edusWv2G90/O28p7ztTaMRN4YZmi7g08bzzwYAmpDp4D13dKkY3iQt2PcaD6fsmpSMMCbTx1X12fbGKYqoVZ8LuftteQRKbkz0c/9sed+c4i4K73dUVhg5ju4+Uk3zMIgZXPREyHZ9gBbvPuvztDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kWBSGrxk; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kWBSGrxk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746273155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NCH7FxqQS+cz0AmUB/MfZEOwpq2pP89BZV8jkLcroFM=;
	b=kWBSGrxklgzmkr9WbO3wU1YeYvf83k6LJ/R/RprDHI+x/Tlr/Wtg6LDc9HgQ8P/50jLDbu
	3vR1nwNY+v/V86AY/HshAbOqNDUPefvk7FAMFrZD/ygaI3Z0fzu5OnPfMjThc5hYKk7CwC
	Wpu8S/psWMbHquuogpyTUg6siN7At0A=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] ovl: Replace offsetof() with struct_size() in ovl_cache_entry_new()
Date: Sat,  3 May 2025 13:52:03 +0200
Message-ID: <20250503115202.342582-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Compared to offsetof(), struct_size() provides additional compile-time
checks for structs with flexible arrays (e.g., __must_be_array()).

No functional changes intended.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Changes in v2:
- Add missing include
- Link to v1: https://lore.kernel.org/lkml/20250503091535.280888-2-thorsten.blum@linux.dev/
---
 fs/overlayfs/readdir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 881ec5592da5..efe4700c797e 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -13,6 +13,7 @@
 #include <linux/security.h>
 #include <linux/cred.h>
 #include <linux/ratelimit.h>
+#include <linux/overflow.h>
 #include "overlayfs.h"
 
 struct ovl_cache_entry {
@@ -147,9 +148,8 @@ static struct ovl_cache_entry *ovl_cache_entry_new(struct ovl_readdir_data *rdd,
 						   u64 ino, unsigned int d_type)
 {
 	struct ovl_cache_entry *p;
-	size_t size = offsetof(struct ovl_cache_entry, name[len + 1]);
 
-	p = kmalloc(size, GFP_KERNEL);
+	p = kmalloc(struct_size(p, name, len + 1), GFP_KERNEL);
 	if (!p)
 		return NULL;
 
-- 
2.49.0

