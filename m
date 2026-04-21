Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B420A227BB9
	for <linux-unionfs@vger.kernel.org>; Tue, 21 Apr 2026 09:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776763490; cv=none; b=W+6aG+XwrhKglN8BY1kMUznUDumswSW9pV3RB4BflFp3gZOwUJP7CopL3ri2/4Wbs/+GYqf34xI3N41TInuZ+jMIqV9POneRX1KA59Ns3gOuX07pOBrJLpZ5YcRE9p9hJB+pvzRPOv5cfQHghW7Tcba0KMbClG8fL0LWWAqx6OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776763490; c=relaxed/simple;
	bh=Veg603++04a4fI/yjvEyxIJqvWDUP5efJnLCMaX/2Ac=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PF41ch+YTuMgAF9zy2CiqOKM+PgAB8No43AD7vXeWPujDLdU71rIE3Po6RDVK1UaJB0M5ah5iXaY0w0FGss03I+eSmTNho9sHRJiF8cJgphYuAnk0QwOWLUCWVHWz89lMwo/5HK9eGJrnwLA+XwwIt95yIMjKddBclmj+90UHBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sDKPqO15; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sDKPqO15"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776763476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HiP8U7iGEUV5KD2PR2peIpyqYDO8dPS6Jb55P5tW2xQ=;
	b=sDKPqO15yxDQDgq29M/FJJcQagAX05sQkWB524huZmWB2TQOYvPwLVQIW2jeaaJarQ6Fh8
	Upf4q3ez6j0yQohn3f0cgiB2yWcbQGuv/QfZbRh5Jczh0zkdB4va5y0U/yiUI+Jeiqjy11
	L3dl2yeB8/OZNZrjqAICty6CU+SVg2I=
From: sunliming@linux.dev
To: miklos@szeredi.hu,
	amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sunliming <sunliming@kylinos.cn>
Subject: [PATCH] ovl: Fix possible NULL pointer dereference in ovl_destroy_inode
Date: Tue, 21 Apr 2026 17:23:49 +0800
Message-Id: <20260421092349.148002-1-sunliming@linux.dev>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: sunliming <sunliming@kylinos.cn>

In the ovl_destroy_inode function, a variable reference oi->lowerdata_redirect
that might be NULL is directly freed. Add a non-null check, and only free
the space when it is not NULL.

Signed-off-by: sunliming <sunliming@kylinos.cn>
---
 fs/overlayfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 60f0b7ceef0a..4b8b5fd4ab59 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -218,7 +218,7 @@ static void ovl_destroy_inode(struct inode *inode)
 	ovl_stack_put(ovl_lowerstack(oi->oe), ovl_numlower(oi->oe));
 	if (S_ISDIR(inode->i_mode))
 		ovl_dir_cache_free(inode);
-	else
+	else if (oi->lowerdata_redirect)
 		kfree(oi->lowerdata_redirect);
 }
 
-- 
2.25.1

