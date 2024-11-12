Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9662C2170DD
	for <linux-unionfs@vger.kernel.org>; Tue, 12 Nov 2024 21:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731446970; cv=none; b=MeTQBZAY1Ov5STokV2h7YmFq86I7AJC4M1zjWYP9jIXJbwr+EfwzIeH3kYP5xKvlhnxkHIoInn4fBhbdDO0TJf3c6fKxQqfsFQCfkjgYbF4EzvzMsf7iuUX6edQEDehY5RIkbP68mnKXhWlShrv5D4oPKFf+1a2PdZQ4/Hk3kZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731446970; c=relaxed/simple;
	bh=JWVjvOuUu6cR6pPjE3K7atmNp6S5Wl0cAN2jxQvRU8k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HF2BwzTpJDiKYZtUU6pYXGyPuApqvB3LRv/AponTZ5crTubdA15gMzTYJtVQdmge9/Kn/poXNtZdLjq+0BsatTLDx+CCW0U//zs9a9GXBMb7odWrxEAAA6rv8CogBozX/V08GSuBffBoo8I7SKloUm+UJoYvMgi3H2db5p/UYts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NrVYDOHS; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NrVYDOHS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731446965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ciDG6XzStM4rMTl5F/ayytQQTAJYpG9+U+DoCstH5lQ=;
	b=NrVYDOHS9kWwxOEc1hua7/rLZqlSjgbxMu3ZSLh4K34jqt0MkZIo7JxIIR85+b7AWCL1AP
	ZjzqUCyrP+LoqPFcYadib2idTOkyr+GqZEmKENHWPnLdG28xd3MNJJc+8FStzPD2pZO3pZ
	m2afJVVrEQjI1qKWtqatecCLL9CWGXM=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ovl: Use str_on_off() helper in ovl_show_options()
Date: Tue, 12 Nov 2024 22:28:15 +0100
Message-ID: <20241112212814.237680-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove hard-coded strings by using the str_on_off() helper function.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/overlayfs/params.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index e42546c6c5df..1127721a5f7f 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -987,17 +987,16 @@ int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 		seq_printf(m, ",redirect_dir=%s",
 			   ovl_redirect_mode(&ofs->config));
 	if (ofs->config.index != ovl_index_def)
-		seq_printf(m, ",index=%s", ofs->config.index ? "on" : "off");
+		seq_printf(m, ",index=%s", str_on_off(ofs->config.index));
 	if (ofs->config.uuid != ovl_uuid_def())
 		seq_printf(m, ",uuid=%s", ovl_uuid_mode(&ofs->config));
 	if (ofs->config.nfs_export != ovl_nfs_export_def)
-		seq_printf(m, ",nfs_export=%s", ofs->config.nfs_export ?
-						"on" : "off");
+		seq_printf(m, ",nfs_export=%s",
+			   str_on_off(ofs->config.nfs_export));
 	if (ofs->config.xino != ovl_xino_def() && !ovl_same_fs(ofs))
 		seq_printf(m, ",xino=%s", ovl_xino_mode(&ofs->config));
 	if (ofs->config.metacopy != ovl_metacopy_def)
-		seq_printf(m, ",metacopy=%s",
-			   ofs->config.metacopy ? "on" : "off");
+		seq_printf(m, ",metacopy=%s", str_on_off(ofs->config.metacopy));
 	if (ofs->config.ovl_volatile)
 		seq_puts(m, ",volatile");
 	if (ofs->config.userxattr)
-- 
2.47.0

