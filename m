Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4090278F4A
	for <linux-unionfs@vger.kernel.org>; Sat,  3 May 2025 10:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746268106; cv=none; b=TDsyJNZZdY3cku2xwYWNTkUx/NEwwrhEMbJdKu1hi/agpFpIQf1d9pNuqlpr1xganeqUi040Ui9oAOy8SzaagEWqGbd5ZLDzUIWpg3b5LYxwTASSpBxNHoQw8DYOmMdCwrssnQT1vLYlKTkG/p/xBtzyX9pJ8E5NIwn7+WQWpbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746268106; c=relaxed/simple;
	bh=5/jraOC10rbO5B6hPBImhfwsdxsopESLlxLiqUFw3C4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dYdJEQfob2RFdpuk5hGYKiw81O08CVhC94Uvf2DXJKV3UsQI3VmYzDABq1xQnSg7eUZ5425G5WBlEicIHHasUO/62ScrHJZOaHtl/7VYbONgKORZGLQ1MdMky3Imp80Cba9gwtrM4dwKu0doh2AgWH8kGYOH5brrkKqCuyx1g1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=slJMYTBN; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="slJMYTBN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746268091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OGiF/B7ExXs1nt2l7g4/k2yP1yWuaG97E+7+rbhFolc=;
	b=slJMYTBNwj+3r98NHeyBHO4/r649VUGQlLXMyxtQSnCGwtcI8XYgfzgP8NIB4TgRgQAM0Y
	Rnhnymec5E7ChZ6j9Z6MZAmGjKDi6QOQdaPJSFAM7eY32kRX2/hFnjJGSncf2FCVzAo4WO
	WYwkOnncE4Zo/mM/wngQ9LhEFXxs0z0=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ovl: Replace offsetof() with struct_size() in ovl_cache_entry_new()
Date: Sat,  3 May 2025 11:15:36 +0200
Message-ID: <20250503091535.280888-2-thorsten.blum@linux.dev>
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
 fs/overlayfs/readdir.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 881ec5592da5..1ae4a488af92 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -147,9 +147,8 @@ static struct ovl_cache_entry *ovl_cache_entry_new(struct ovl_readdir_data *rdd,
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

