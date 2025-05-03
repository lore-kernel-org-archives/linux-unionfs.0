Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF551552FD
	for <linux-unionfs@vger.kernel.org>; Sat,  3 May 2025 10:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746268494; cv=none; b=NCQPKHHaWRz6XhfWLh3SMGxSALIKpXvIU4ZmmIrA5nV+SFTQQtWjvEDV6g6pSGeUzSJ8UOvgcSF/5+5ObD4bZ+P2DelH1zwe3bpmjnu92IGZB+NlHQlFhZ4Fipym69nXO7K3WwKBZaWmB2jldJkq4zrP33yypYhfdIDBJ6OmP2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746268494; c=relaxed/simple;
	bh=pGORQP99i+9J5l8UfBNVWEWdosSqp5aiEJue5Nc4nL8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LjkZOyTEMEeFjRIpY+/QRp8Zg2qm67gbZk7pRjO3zrprln/wWqB5oeQWUWJLHbBWPGXJs6EfIlTw54Ipbx2QJSYthqthwtpPM9o2FGyVmmAN4SFsNl0j0AjqJiQt3rJsqYNdrRtKK3+Penp/qXYwP1cPWz1QEtE+AhI6NIT9/+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rVEiaA96; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rVEiaA96"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746268489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HaEkVw3CpeevXqujMU8zoiIYMYq8s7lghpVO2Lk9Sl4=;
	b=rVEiaA96eEy3tZ5jKKt3ChRFfaDMn+qreOK4TaLSmhqWZD7S44vwacbyUACjK/UBLO7bLw
	dcZMOnZKur9z0dT3FQkObeEEbjt5l6IVIocAott9MdUOdQ2GMVY2sVK+Z/5Si0JysoQySN
	OiSijeTPqOVxmM9WsQ0qEpw9EHywvN4=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ovl: Replace offsetof() with struct_size() in ovl_stack_free()
Date: Sat,  3 May 2025 12:34:16 +0200
Message-ID: <20250503103415.281123-2-thorsten.blum@linux.dev>
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
 fs/overlayfs/util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 0819c739cc2f..dea0df3272e3 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -145,9 +145,9 @@ void ovl_stack_free(struct ovl_path *stack, unsigned int n)
 
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

