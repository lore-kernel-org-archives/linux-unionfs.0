Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993564CA276
	for <linux-unionfs@vger.kernel.org>; Tue,  9 Jun 2026 18:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781030821; cv=none; b=DFOKIkB0fzEu+lUyYp32Eje2cnlsakvlrYUUFJgQ5cZvUNipHIYPFRTkain9AHmXO6uZ8mQ8Q/osM8t69w3m+4ehjYAuHYzp7UXYa/zOuNMCAgwnf/AGJor1yzb/zxw2OVujDkyta6zfYv3tFan17/AQTc/Ap3wSZhKyvmk/NFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781030821; c=relaxed/simple;
	bh=TYiL5WPfgjxbOXmoUFaTwwaS9nemB175w+61pdTi3Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ofB94W/pc7fnAL2qaT1p/yDbYXn3fVNLkH6hMgzc1jMILZnXyqvzBlSuic1WIkymYgCNTZb5WXBsMqLTeQXtLILRPJ+IV40ur7Edjst9Qhwj78CMjhPA6fOShlLOOzxJoNkmM1g+HobWtuCbraQMeCD9lL5KN3f/PZKAHTmKKYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ShgOrzAk; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ShgOrzAk"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-68d232e119dso9416926a12.0
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Jun 2026 11:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781030818; x=1781635618; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oFFpIr8jRh7kVDI/J+6tASIXDjUQrmX2hOWLyzSNm8M=;
        b=ShgOrzAk47iujYZYpYGI8VmUXZI2cLAloo6kbs2mDRF7TD9fF4DYjWoZvMytZqediG
         hJH5RBIsfYIV/DnXewxaGyZ3GmFcVJJQeaJfWLnvO6rlieSf/rWgeZbNKkJiG9Q8fD8W
         9H3GCDNZePJklNgxbtriO7TJf9Ejbk0tp7RrCkAjeUrtBbMb2FS8AxDwv/ztiHwvafjM
         5nbkuGwyMRF2l++YMnEF5G5N4A+ScFr82BCMZKLZ7IIVrU+DORaDMUYx7tPQ+cHoojGI
         FHkufTWKE5P/Maeoq7iQqcAItQKJBgIjNAdJl8ZZr3uSdzVYf6DoGGB5iOqScp45q0lA
         IklA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781030818; x=1781635618;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oFFpIr8jRh7kVDI/J+6tASIXDjUQrmX2hOWLyzSNm8M=;
        b=R0dvgbrJPm2V8pbpTYu4jQB7/WMPQnaLsUUpLYoruBqLPbLMXdTp4pwMrQwh2yMFy7
         BTTexJIwop5rJKjwHpU9gf5AU3fRC853fk1hQPnHF1PggF8lWUkVjZZG5nlxvPBpZ0t2
         A1mA/W9HdjHBFOOYUdI2Qt4UsATsrYa8cf4vxyHgwyiFHKn6uXBUnZ1HJFMBMBvCMwH5
         Wh08Z4l5Jjh1ABUPSBHagiA3fHqK3f8urO2mnMt4Diyg0emK7X8GBoRyQTF30iKB9lKi
         svDe0ROA0YVlH0KXOtsLSOVLSaa1kBQtBqvvK1EJKvuSB/sir8rbijTiVgaMyH7ehl1y
         5zAQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Huk/oHQqnYH8SjWnPufab4f+4l0oTJLk5WlQk+4hdQVe4j4VeOn4PVK25rkFCFUySIaHIboUFehqLBtBI@vger.kernel.org
X-Gm-Message-State: AOJu0YwCT4AAhT4tpCYI7brSBwQ2TDJ55DGsZfi8DpGxaAQdCDZIRI7o
	RjayTVi0weU8dG+3UJ25HaQQHyqZp5jkV95nVroEPTe3M2d6U9U7dkJeZRaX2bwy
X-Gm-Gg: Acq92OEfAPoBfuU2XFfwGDNq9nBXw3wXoToH0Ibedw4XDNXCEZHmSe2lAgZsjOzmUp/
	n/cqw1CpQtYemb5uYceOZJizbdQhRMfogLR9jZ3cZY/cb9iqeWKqX8JdryMYWtI6oEg3ex7IbFf
	iVjseF1z+nu+cE1UqHeTAHHxuYV/UatywUhOVxdebxXegtEsrovJV0TZFiZb6mMHHnWjaPV3xdq
	4JgEj8K/Em73I7szn9S7YYqum6Lhxni9YhlqB7KbRckF7kZEap/ZFv0MQmrRv3lM6+NGuzriEX3
	YaUZVDV2czxHgHm5ihx3Y+l24+6/iUgsig2L4zfVZs6Yrdj+rE8wYEKb8U8YKzOi7yqV9OBq4Se
	Xc+xdZ/phHK+b7nKAqtGnAlcmvq4I78rUXTwwTcRqQ1wp8x/J2mCkl6+wp05PZHg6BLzhWTB2lQ
	qnrm+OssE9GNQKmOH3BSI7mXSaVRI+wTnQBwNcBjY/PMtcH7maFw0gxhvv38MRIiXE0j0Vq3yMr
	9N3W5xKTW8NlisklFXvYr2GVCF60gtfWz1BcLs=
X-Received: by 2002:a17:906:8e15:b0:be2:208a:a8ae with SMTP id a640c23a62f3a-bf370f6ac02mr1198199166b.22.1781030817896;
        Tue, 09 Jun 2026 11:46:57 -0700 (PDT)
Received: from localhost (2001-1c00-570d-ee00-f0c7-4f01-fa03-4940.cable.dynamic.v6.ziggo.nl. [2001:1c00:570d:ee00:f0c7:4f01:fa03:4940])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf05228a16csm1082063666b.28.2026.06.09.11.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 11:46:57 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: fix comment about locking order
Date: Tue,  9 Jun 2026 20:46:56 +0200
Message-ID: <20260609184656.1916631-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Forgot to update the comment when we changed the locking order.

Fixes: 162d06444070c ("ovl: reorder ovl_want_write() after ovl_inode_lock()")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Christian,

Could this patch get a ride on the vfs-7.2.misc bus
or one of the following vfs.fixes buses?

Otherwise, I shall queue it for some future ovl PR.

Thanks,
Amir.

 fs/overlayfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 00c69707bda98..bc71231cad532 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -783,8 +783,8 @@ static const struct address_space_operations ovl_aops = {
  *
  * This chain is valid:
  * - inode->i_rwsem			(inode_lock[2])
- * - upper_mnt->mnt_sb->s_writers	(ovl_want_write[0])
  * - OVL_I(inode)->lock			(ovl_inode_lock[2])
+ * - upper_mnt->mnt_sb->s_writers	(ovl_want_write[0])
  * - OVL_I(lowerinode)->lock		(ovl_inode_lock[1])
  *
  * And this chain is valid:
@@ -797,8 +797,8 @@ static const struct address_space_operations ovl_aops = {
  * held, because it is in reverse order of the non-nested case using the same
  * upper fs:
  * - inode->i_rwsem			(inode_lock[1])
- * - upper_mnt->mnt_sb->s_writers	(ovl_want_write[0])
  * - OVL_I(inode)->lock			(ovl_inode_lock[1])
+ * - upper_mnt->mnt_sb->s_writers	(ovl_want_write[0])
  */
 #define OVL_MAX_NESTING FILESYSTEM_MAX_STACK_DEPTH
 
-- 
2.54.0

