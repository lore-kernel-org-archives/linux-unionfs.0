Received: from sender2-of-o52.zoho.com.cn (sender2-of-o52.zoho.com.cn [163.53.93.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278FE34BA49
	for <linux-unionfs@vger.kernel.org>; Thu,  9 Oct 2025 05:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=163.53.93.247
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759988562; cv=pass; b=uaSUnJ/mFp6B7sNcFqUDpeJ2MExLe+2FSBm+FtYUqPA4FL7/a5uT02ssjgjHFBWcvaMDtFMy+UWYnqQxU4QWKq75zMoAUEWDonQiObq0hGLF/wuB+QWcMOpgWfdHPKvc3qs3/ILUvzET4lvQ3sX/BIJsTJTC09M7a+TcpLSc53g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759988562; c=relaxed/simple;
	bh=qP2t64WWwFVFySYaXw7T5YaxzaU3sZhN+CaytL5Odg0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bjlqud/hsxmT5qy6JLKpZGP1Q4gB2LKeKFDY4JQuC7tRO/wFeGWmfpj2zakWsEucaYYXtJVqbsSmFWtkZzl9pCSeQtejsqVA6g2WHNve94UAH81GaaHygUv6uy6+HFweXALCPF7J7cbSy/qq/ZZMfnzZ8BZnLNnUkyk5wHiCYxw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mykernel.net; spf=pass smtp.mailfrom=mykernel.net; dkim=pass (1024-bit key) header.d=mykernel.net header.i=heo@mykernel.net header.b=aCw1koCP; arc=pass smtp.client-ip=163.53.93.247
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mykernel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mykernel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=heo@mykernel.net header.b="aCw1koCP"
ARC-Seal: i=1; a=rsa-sha256; t=1759988530; cv=none; 
	d=zoho.com.cn; s=zohoarc; 
	b=hsk6VGTz3GYDgkNKFPjrGVhFfm99xLw9OZMI0wxcBiCZJxnAOeuwETDxFeUFamdIFJrQfwQ+dhDMLa2xzjn60D7LKgALj4EkqclqsH/0inDidSDXVS+j/YvKfZK7F/V0xN4P1R+v5+Z4+dD8iahvZC1FduvFoEP2mWi3Jj+Pxxk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
	t=1759988530; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=4zqvoK+QnV5pC8Xmv8XLR9Yan6oChzGFJRjJjMVn+eI=; 
	b=qIaWR+5WPGws4EzaRAi4hnDAz9BSaz4Qw69ztAny7s+Ohf1fheqT+K1x055Pi/LS38bVK6A6b2mXLv/KhUrNyIiiMlDmJEshAkCDaCBrUiRjPcGShrv22sqtnJwe9M65nNn579aEivDTRgJ00uqCZU8NSsnz2L9sKSidmSv2DuE=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
	dkim=pass  header.i=mykernel.net;
	spf=pass  smtp.mailfrom=heo@mykernel.net;
	dmarc=pass header.from=<heo@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1759988530;
	s=zohomail; d=mykernel.net; i=heo@mykernel.net;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=4zqvoK+QnV5pC8Xmv8XLR9Yan6oChzGFJRjJjMVn+eI=;
	b=aCw1koCPrQHWwIrNJd3EKH/iwH5ofbm7ooN+Ff46Xhz+2fjv7pcdbxp/alm80Y0u
	efPDUwvHKpdUw6R7lyRCqJfGPbXDkWKvINVfksLKBGIVR/0HXRZHAN4EmccwA+xyCmh
	EgSnrE5eszyz+FVqC6nbJhWCwAHVgC8F4NH0CXmI=
Received: by mx.zoho.com.cn with SMTPS id 1759988526490649.5659639018318;
	Thu, 9 Oct 2025 13:42:06 +0800 (CST)
From: Seong-Gwang Heo <heo@mykernel.net>
To: miklos@szeredi.hu,
	amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org,
	Seong-Gwang Heo <heo@mykernel.net>
Subject: [PATCH] ovl: remove redundant IOCB_DIO_CALLER_COMP clearing
Date: Thu,  9 Oct 2025 13:41:48 +0800
Message-ID: <20251009054148.21842-1-heo@mykernel.net>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoCNMailClient: External

The backing_file_write_iter() function, which is called
immediately after this code, already contains identical
logic to clear the IOCB_DIO_CALLER_COMP flag along with
the same explanatory comment. There is no need to duplicate
this operation in the overlayfs code.

Signed-off-by: Seong-Gwang Heo <heo@mykernel.net>
---
 fs/overlayfs/file.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index f5b8877d5fe2..31a98f10fc4b 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -369,11 +369,6 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	if (!ovl_should_sync(OVL_FS(inode->i_sb)))
 		ifl &= ~(IOCB_DSYNC | IOCB_SYNC);
 
-	/*
-	 * Overlayfs doesn't support deferred completions, don't copy
-	 * this property in case it is set by the issuer.
-	 */
-	ifl &= ~IOCB_DIO_CALLER_COMP;
 	ret = backing_file_write_iter(realfile, iter, iocb, ifl, &ctx);
 
 out_unlock:
-- 
2.49.0

