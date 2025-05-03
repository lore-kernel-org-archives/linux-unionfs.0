Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A901F3FD1
	for <linux-unionfs@vger.kernel.org>; Sat,  3 May 2025 11:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746273190; cv=none; b=gIy1fiGEwJVper4p14QAivTILiKsdl66iU0zUquPSDhg0RUfGiFvWVLzwMM+OPhxymhe3Wc4b8S1VyPv4VMmZNau6bJPeqW+WgTJsUWA2FX2BFytgtvt660MYNO7eoq1jMrgVVAs1FztJNb9dARAngPx0bU0RG3wKOQ88tRpwiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746273190; c=relaxed/simple;
	bh=w+fssZgFamC4QJtIuBh39lOyDQ/gn2TYeWA4uBF1fa0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=puwMPK3A32lIvHZ1OtFvUMyUoMgKC6tr/UmyWZEd6Se83GpfzNf/3w6h65LkZbZM85r4KcBcMhYGYdnx6EjIrJjuqVF5M6wYLsqSoE41oP5BUSKcEMeZqxq/p589JlnO4qq7VkWqwvtcOkulYgYobfDIJqkFAl3Xho397hvtS7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iUviIQsy; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iUviIQsy"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746273184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3XlyEXv1TeOhpT7TJTq/JP6q/LbG0XV7hKmXjm2rX/w=;
	b=iUviIQsyEi+aJQuzwXsXhOH9JARC3iWcFaoZPat01A10Y0FBtU2RGwP64q3xpedEbFuDMo
	kzedVoHCcxQ5nChOt93LVQ8+EJRZdOxmSH59u7TBER/xe1YGILcKhdIdPTMfE+2pzBaeyR
	KjhEEqeoDRJ/V5kfCGeojOusgQi0/x0=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] ovl: Replace offsetof() with struct_size() in ovl_stack_free()
Date: Sat,  3 May 2025 13:52:44 +0200
Message-ID: <20250503115244.342674-2-thorsten.blum@linux.dev>
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
- Link to v1: https://lore.kernel.org/lkml/20250503103415.281123-2-thorsten.blum@linux.dev/
---
 fs/overlayfs/util.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 0819c739cc2f..e33d2257c642 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -15,6 +15,7 @@
 #include <linux/uuid.h>
 #include <linux/namei.h>
 #include <linux/ratelimit.h>
+#include <linux/overflow.h>
 #include "overlayfs.h"
 
 /* Get write access to upper mnt - may fail if upper sb was remounted ro */
@@ -145,9 +146,9 @@ void ovl_stack_free(struct ovl_path *stack, unsigned int n)
 
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower)
 {
-	size_t size = offsetof(struct ovl_entry, __lowerstack[numlower]);
-	struct ovl_entry *oe = kzalloc(size, GFP_KERNEL);
+	struct ovl_entry *oe;
 
+	oe = kzalloc(struct_size(oe, __lowerstack, numlower), GFP_KERNEL);
 	if (oe)
 		oe->__numlower = numlower;
 
-- 
2.49.0

