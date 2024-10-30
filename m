Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F381E260C;
	Wed, 30 Oct 2024 10:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730284630; cv=none; b=QXLWSuiKCMNrEBDP7+JlBJB/2/dyHVmzIpMkTVCbRLG+6KUo0jhuBU24Jdmrv0TYeebKFHYW3isiookAkJvgokT2aa1Kkm8GFKDLPVxaje/KnsIXz7NCz9p9IGR2HC1oQPHCkSyo/XGbr8Ng+VeDzzet8lykztcz+dU6BomOogg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730284630; c=relaxed/simple;
	bh=BuV9WLUxozweYH9SaJOjipfLeWosJXwHUEdtG17zscM=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=aEIxzaoPPBMOqLLnFPIu+pT66j5SZzyx1TiNIf8iPrvGffypqzz+KMrrAvdyL4WeQ7/t18G96CfXTVIzN4FEY4Fw5ZfQYf2kSZhqMJYLxni7zeGjFKRYM2FKOpHjwLE+Wu6xwErddr57Ap1jQDqGP23pvjCqEqOrxnoHG45bUHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=ThUP76GG; arc=none smtp.client-ip=162.62.58.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="ThUP76GG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1730284314; bh=zHfoqvcdyaOKQo7OsU+H7Hbt4PIQsWhPaOgva2OQV8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ThUP76GGMwrFF0yxKuN72fizkLkgJyiSLnQBxphJgZccVa1qfoV4BqU7VvNla1c5h
	 BxoEyzWyWVe7aBjxdi1cmdD/SmQRN23V7CA7GY4P3CJ3ryrDdGiayPcOD5sJSiwnXB
	 NUcqmBggGrXytQG56XrndkI2tegS0ofjhB60L7Vo=
Received: from pek-lxu-l1.wrs.com ([111.198.227.254])
	by newxmesmtplogicsvrszb16-1.qq.com (NewEsmtp) with SMTP
	id 7F42E2E3; Wed, 30 Oct 2024 18:31:52 +0800
X-QQ-mid: xmsmtpt1730284312tmx4hylhw
Message-ID: <tencent_93E0C66D49BEAEDE6ECA0C9FA7C786D2D206@qq.com>
X-QQ-XMAILINFO: NhUkPfKlCtQwUUMh2foJjMGPnHrdYy6dHZWFs/7ZegpoND4YXmNKSDrDzjkKwS
	 O/PkpHZrWXXm90j8YT0Eow0x0TSjMZmh3ig4jhjlb6uiBZFR/KoZO9d/dJKt4agqEV9wOl5bhss/
	 V8Oiuk3cahMkrlnpeUmHUHv3SkZ3WUp1DLNq2w+dVKS3btiMGBMGwnJ1W8LjUFBwzTesVe4R26am
	 zD52gptuOkzh45L1Q/tWPtkz8/ARWfulB0fDWVopV1RM13OW2qExmXUrk7FQDOlkC6cn+89jhfOR
	 bW+ePBR+Vb73zOWUKmjP6IYL5PBHUQRkkMApEOpgx6T4Ti2VaBPxTfWuBZHY0QpV+yLquctf8Skt
	 98XtmqtdmOqpYaLS3qpYnDZja3EG+ywgnimKKZ0RdO/WQTIrovFxAwFNeQT0835nxb18rWNcFADA
	 5T88uzf6Yst2WA4EeXFYGqHchRVlf/WQ9OBtaAsZFsN0e9TDSOJI3NUIFagbjXNvtw7db3uQQnvV
	 jHXFLgPOLLOuKj4zbvOcqQJ5WxTt4NLKzoxz4TXFu1U9n5/sE4fwxeszH31bcN+nWRN863AEGZjJ
	 h+9ZlKA56BNglSDLl2VGU3vhss4accbSs90GaXm7DbmuVAYBO9M/x8WI+ZbvJ1oo/uP3KGuynFdO
	 dtjlXf3brDlWq6awb2rGiauq6XyfCSYycFridw88FoM2baw5bYtSEC1+2t++8cvVBZQ9RB5aLIsA
	 oX6AVPj8k89el+dSp6oHBJVssjOYnnTH8ZGRjyvZ86BePbbT/6xlvgJ3L6z0uTosQTCG+QFCShgN
	 FVRi/H23ytxRUuoTJE66TqBEPlZn3AUCro6xM9KzVp6Zd1OTeYvqtGqV+xclNT59r7ASDdd4cBry
	 EsZTKIvBUde1L/RNBRUAfIr1uc+Aatn7ifkOzIplHlVINeoLmM+Zmm42xd/yZFYyw6j1GquTUS
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+ec07f6f5ce62b858579f@syzkaller.appspotmail.com
Cc: amir73il@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	miklos@szeredi.hu,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [overlayfs?] WARNING in ovl_encode_real_fh
Date: Wed, 30 Oct 2024 18:31:52 +0800
X-OQ-MSGID: <20241030103151.3582905-2-eadavis@qq.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <671fd40c.050a0220.4735a.024f.GAE@google.com>
References: <671fd40c.050a0220.4735a.024f.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the memory is insufficient, the allocation of fh fails, which causes
the failure to obtain the dentry fid, and finally causes the dentry encoding
to fail.
Retry is used to avoid the failure of fh allocation caused by temporary
insufficient memory.

#syz test

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 2ed6ad641a20..1e027a3cf084 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -423,15 +423,22 @@ struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
 	int fh_type, dwords;
 	int buflen = MAX_HANDLE_SZ;
 	uuid_t *uuid = &real->d_sb->s_uuid;
-	int err;
+	int err, rtt = 0;
 
 	/* Make sure the real fid stays 32bit aligned */
 	BUILD_BUG_ON(OVL_FH_FID_OFFSET % 4);
 	BUILD_BUG_ON(MAX_HANDLE_SZ + OVL_FH_FID_OFFSET > 255);
 
+retry:
 	fh = kzalloc(buflen + OVL_FH_FID_OFFSET, GFP_KERNEL);
-	if (!fh)
+	if (!fh) {
+		if (!rtt) {
+			cond_resched();
+			rtt++;
+			goto retry;
+		}
 		return ERR_PTR(-ENOMEM);
+	}
 
 	/*
 	 * We encode a non-connectable file handle for non-dir, because we

