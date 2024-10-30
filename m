Received: from out203-205-221-231.mail.qq.com (out203-205-221-231.mail.qq.com [203.205.221.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E203FB31;
	Wed, 30 Oct 2024 13:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730295045; cv=none; b=Cm0YCT9WHdfbsJH4xwNUI8byf7uitbAd92JDoKhr4XNh/nn9zC/AVnEL3Fsl1NVVwOKVGJoNnCZyNE6Gg5hUUlT0C41nz3kCan0X3gtFOEWqcQidOGcJuI+bbdT1IJCxRcuvzSXP7lISP9CzbnTm3f7v/Gxn4zeOJCoWO0ZTQHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730295045; c=relaxed/simple;
	bh=fXp4EyvDvaEHTs20lqCDCc70TkoaLFwUvrUtZ1hPBtI=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=soVzs0LJ/SNCaxaXQvuYkxe7iE8rO8MOalW4nEKtxPWCvsj0ytuQcOjzMhjIN0O99o/z0iHv1CtxC9jzxVhK1OrDSqJDHhe9R0nditk5a6et9to2Jb7BqaMaiBcWpOQAVLXnbqCIQd84a5BkE2K4v3xi3GbtdAxFyD3KsPUIB1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=UFheIvHn; arc=none smtp.client-ip=203.205.221.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="UFheIvHn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1730295031; bh=rsvQ0cW54UNs+cmr/pqkfTzh7S6i+MSJtskvKobjuH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UFheIvHnLqbbD/5LRTKbIYOCWj3FJB+6+jUJLuBTHBW006ZuCCoMbs4cvwEA9mC9+
	 y8NULTYMnwA/v1qPH4wnLhcb3Dq2jkKQHKfHFbB6SKp9CS0k1FwKiSG29h7Aro2ONg
	 SzDELE+1wMnk/rfWydoxqQR0VQVoqNNuaKfm85i8=
Received: from pek-lxu-l1.wrs.com ([111.198.227.254])
	by newxmesmtplogicsvrszc16-0.qq.com (NewEsmtp) with SMTP
	id 79C9A88A; Wed, 30 Oct 2024 21:30:28 +0800
X-QQ-mid: xmsmtpt1730295028tjvgbdpfv
Message-ID: <tencent_451BB425FBBAC7BB5833E59EA31B4D4B0708@qq.com>
X-QQ-XMAILINFO: NmGHaOBmCahzaJDE79H7nTGDoUh3WOTRfrJ46PalzlT1XYPu0GxVShDApe4zM3
	 nDYnkFd5YJCkCY6vQe7W2TCA+Cff+KPExM1zgu5mb+SO4Z3gEkcmn07Mk/JnKJc81QCyumN9aYOC
	 DnTobGr1lnK+kjoBiacQkCRgDPNRmfzZaU4WG25ojiQDQ9o9UqcVYqhIbanB5aDVkONAzv0TeUGV
	 ZTo/spIufUtzz8J9NoBOKZdTcXpbcw2ju5zxkz+eSwLATOmgysWZXhC8KZHRDn6J6qrbp9r/R4AC
	 zJzDJKArfA1/44SBaiOyLyP8+sSbOw5JilPZiVoKVB+yttWnDf1HtEcXwWgAkV/91UNiveMFjNai
	 vRvDK3nCSBPM0njzSjo9z+t8qSm0zxmfrNmxlBfHZNOTUgoM9StF+xWGEYVf12VaS3R9546fV537
	 BWjd76xRTpA/WAEgvLYp+nEuflFlvLYZtm9jJNdqxlyOuSg3M4L3SRjCInw0h+l1ujLfdEb/0Qa+
	 Nh/if8tZN5xIz+X5T/Nt9yE0jXtPJMrSvB7bbqZiF+3E48zZFtN1vuzxt2CKqgt8BNQfM6wmnWJT
	 FlOIdSCttYJQauqRkLwc4OQjO9LR+I9DvZxHALRPjFkVjGWkznEEoTC3eWcsbcvdN81ydD9ghjMl
	 048kw/FdhPEWYK2pO8U2T62zGOLI9i71T+TCeXtaiMg2212F34FeoJUE90Yun+pz/TuULhS8rnSP
	 w+hK/Jh8v69WDFsj6EWSE4grN+Dm/ttfJHXPTHZTN6O4P1sm1WMnX7bPagFCtysPnpBzNjwe1TZL
	 LKI7/n6aXUGVVJHVKhUUW8a3qvduQ7cmwFPUN67fXlUYKrdNBpTdLPbLOdcS7v4nVZU2bLwkFnL6
	 qanfYiLfU1u6zz5p/k2pxAYZn25z/QDgCnH/y7Z90LK1Yp7ILJKSfLE4Xc/b7Jg9Ayi3YhRZQZuk
	 e3W/AsMLgDlLOkrlXyEzcGCu/51BiuvlZ6mfD1IHg0NIf1cADqb7qIkL1QlbCc
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+ec07f6f5ce62b858579f@syzkaller.appspotmail.com
Cc: amir73il@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	miklos@szeredi.hu,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] overlayfs: retry when getting the dentry fid fails due to lack of memory
Date: Wed, 30 Oct 2024 21:30:29 +0800
X-OQ-MSGID: <20241030133028.3754238-2-eadavis@qq.com>
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

Syzbot report a WARNING in ovl_encode_real_fh.
When the memory is insufficient, the allocation of fh fails, which causes
the failure to obtain the dentry fid, and finally causes the dentry encoding
to fail.
Retry is used to avoid the failure of fh allocation caused by temporary
insufficient memory.

Reported-and-tested-by: syzbot+ec07f6f5ce62b858579f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ec07f6f5ce62b858579f
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 fs/overlayfs/copy_up.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

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
-- 
2.43.0

