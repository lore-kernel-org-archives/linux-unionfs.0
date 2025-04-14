Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99721B0439
	for <linux-unionfs@vger.kernel.org>; Mon, 14 Apr 2025 20:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744664071; cv=none; b=hYOoW8D8R0YCgWTeeXlazlTErX1LWGr7d7IPwgUGQvD5eV0czrFn2AgzVeoCxMVBITQfcfW37eZ5KV/v+qPlILFGtFn9wKvFBFZXFQn1dJ7pyqzwGxogI9GWGdf+7UOteopJK6EkWw0M3UIvN1BYm6jWof4yKtNNeYt2aIySiyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744664071; c=relaxed/simple;
	bh=IVbscjkg/t7tmXG342QUVsKw+0b4TEyy9/kLcTms0sA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=heHIfTGhbsS7baEY0hZViY87cLRyJwuNhH8es+e+3X4qlAk8IOJt6at+K5K5aiy3AYgzUY36e+NnDJMAc5JX3RhUMCihl0Jqvk7ZxCWedT30iFAR3HNqTQdd2uzOXHNCbjul2Kpo+KbLh8J3uKuyN9Pu2Dtkf+EhcqYqGrswH3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BKd1LOnm; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BKd1LOnm"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744664065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TR7dEj56cb1DCkyT7kzwEfs2jUXxT36dtnwHb+IVk6g=;
	b=BKd1LOnmEWr3oflhSfJvvNzpG75JcMTHlSEIPWwjWDX/mWzFhoWeTnObkVGl8ngRsjaku0
	OXfbYtjrxeXR/+pgSpGuoX4AoHmZTFXcVSTwCx5uzCh7FHz53Gy4g1OupA5DWK64q2x5AS
	RBfZ9X/E5SzEy5PBuQ55Zf8KXhot8So=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] ovl: Use str_on_off() helper in ovl_show_options()
Date: Mon, 14 Apr 2025 22:54:08 +0200
Message-ID: <20250414205408.1504-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove hard-coded strings by using the str_on_off() helper function.

Acked-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/overlayfs/params.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 6759f7d040c8..259ef21f3d08 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -1078,17 +1078,16 @@ int ovl_show_options(struct seq_file *m, struct dentry *dentry)
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
2.49.0

