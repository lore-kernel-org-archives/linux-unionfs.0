Received: from forward103d.mail.yandex.net (forward103d.mail.yandex.net [178.154.239.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFE8307ADE
	for <linux-unionfs@vger.kernel.org>; Mon, 27 Oct 2025 14:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.214
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761574409; cv=none; b=fRVCzl1FtdtoCeE2RhifDM43+dGVWIIkeESJVTq7AeQrS1fA2VkMrYqnj7/GZemhYefANDi44v+PVb76OVT6ci1+4fKHFBE6Pyu3nm5dPXdMm4pXxuXPRnODfjf3daq4LrH3NX1Rnoikd8/9zpHfnQs/3dCK4GAgTgQOTHqLYwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761574409; c=relaxed/simple;
	bh=kPNzQJv3lnN5vjpALOGsj/HLDV6WrLpSqWEi3V+C9ps=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r0rOVJH4u7iymLX+0d31Zn7wu2WpnVjXx1YymuiADcha2n67RitMmOosiEDKaAKTiIIem6/bNnjNw5hBpEL82cfAeN8pRBCs5ufs/mfq6necm9zOiwhC+vj6CCPovakJIHmhuAL/BqfnufENL8rmE8zcrbBPrR7PPV3wKmopBQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=m3oAmPfY; arc=none smtp.client-ip=178.154.239.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="m3oAmPfY"
Received: from mail-nwsmtp-smtp-production-main-92.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-92.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:a498:0:640:c8b9:0])
	by forward103d.mail.yandex.net (Yandex) with ESMTPS id DED8AC0078;
	Mon, 27 Oct 2025 17:13:17 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-92.iva.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id GDd6H7tLNKo0-vcEnPhVh;
	Mon, 27 Oct 2025 17:13:17 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1761574397; bh=j51lPqtmvQCREZ7Zbqr/fhfMJNADCAgzpj1jWsm4njI=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=m3oAmPfYNxNoIgZZpI2rFlRQj2AMAE8xHGpDB6QfM2eZRmA7nB0TMiLXCA9DWjqvI
	 NW5R2EJoIeq1h4qvESmgOLsbpI6HtJVyW5fwZePiKGXvV3huewE/iQ3XllOAkUPx4y
	 6G7NkRRcs6uz+q/dZ2weBSkhQRC0SquAbps6SC6s=
Authentication-Results: mail-nwsmtp-smtp-production-main-92.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] overlayfs: avoid redundant call to strlen() in ovl_lookup_temp()
Date: Mon, 27 Oct 2025 17:12:30 +0300
Message-ID: <20251027141230.657732-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since 'snprintf()' returns the number of characters emitted
and an overflow is impossible, an extra call to 'strlen()'
in 'ovl_lookup_temp()' may be dropped. Compile tested only.

To whom it still concerns, this also reduces .text a bit.

Before:
   text	   data	    bss	    dec	    hex	filename
 162522	  10954	     22	 173498	  2a5ba	fs/overlayfs/overlay.ko

After:
   text	   data	    bss	    dec	    hex	filename
 162430	  10954	     22	 173406	  2a55e	fs/overlayfs/overlay.ko

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/overlayfs/dir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index a5e9ddf3023b..c5b2553ef6f1 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -66,9 +66,9 @@ struct dentry *ovl_lookup_temp(struct ovl_fs *ofs, struct dentry *workdir)
 	static atomic_t temp_id = ATOMIC_INIT(0);
 
 	/* counter is allowed to wrap, since temp dentries are ephemeral */
-	snprintf(name, sizeof(name), "#%x", atomic_inc_return(&temp_id));
+	int len = snprintf(name, sizeof(name), "#%x", atomic_inc_return(&temp_id));
 
-	temp = ovl_lookup_upper(ofs, name, workdir, strlen(name));
+	temp = ovl_lookup_upper(ofs, name, workdir, len);
 	if (!IS_ERR(temp) && temp->d_inode) {
 		pr_err("workdir/%s already exists\n", name);
 		dput(temp);
-- 
2.51.0

