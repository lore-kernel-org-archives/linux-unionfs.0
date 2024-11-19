Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF5A78C76;
	Tue, 19 Nov 2024 15:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732031905; cv=none; b=PvqBiHaXvPCiOz6JUP7cuDwooDq3I/Na4fA6pbWzVCQO6Q4VyVssy5LOTI+N/8izDbs8J45P7luNC81HUhuPO92S+HWIA3pzQT+jyVZYMBW2Lj2R1RpzVkwui64xLcXVhFwSSK3F1ZKjwnDlMiPJ+OV5iW4PiMZ+PNVDzztPRBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732031905; c=relaxed/simple;
	bh=WVf+qH52iRBN8c9BUy9kRMC+HED/QfEoFsbsiJtJ7Sk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tl/7syt29qqGBZDRg/XTKQXy6+POEf9q9A2pwpnK+eF40Il4+jdxEnA3MM+6sKWnx5zDWy7vvswzCVbM2GiJASBOSBnEytskS+JLadb1C8A0C4Dk055j+e7PMNJFhNN9Hy3D6C5C586flu7NFCep3llO5Oyve2C04ShugKq2v68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from altlinux.ipa.basealt.ru (unknown [178.76.204.78])
	by air.basealt.ru (Postfix) with ESMTPSA id 97F182333B;
	Tue, 19 Nov 2024 18:58:18 +0300 (MSK)
From: Vasiliy Kovalev <kovalev@altlinux.org>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: kovalev@altlinux.org
Subject: [PATCH v2] ovl: Filter invalid inodes with missing lookup function
Date: Tue, 19 Nov 2024 18:58:17 +0300
Message-Id: <20241119155817.83651-1-kovalev@altlinux.org>
X-Mailer: git-send-email 2.33.8
In-Reply-To: <CAOQ4uxhc9-MMF1nEpoxC5X41FRqSygGdVcTuvdJKurMxWU1U0Q@mail.gmail.com>
References: <CAOQ4uxhc9-MMF1nEpoxC5X41FRqSygGdVcTuvdJKurMxWU1U0Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a check to the ovl_dentry_weird() function to prevent the
processing of directory inodes that lack the lookup function.
This is important because such inodes can cause errors in overlayfs
when passed to the lowerstack.

Reported-by: syzbot+a8c9d476508bd14a90e5@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=a8c9d476508bd14a90e5
Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Cc: <stable@vger.kernel.org>
---
 fs/overlayfs/util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 3bb107471fb42..9aa7493b1e103 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -202,6 +202,9 @@ void ovl_dentry_init_flags(struct dentry *dentry, struct dentry *upperdentry,
 
 bool ovl_dentry_weird(struct dentry *dentry)
 {
+	if (!d_can_lookup(dentry) && !d_is_file(dentry) && !d_is_symlink(dentry))
+		return true;
+
 	return dentry->d_flags & (DCACHE_NEED_AUTOMOUNT |
 				  DCACHE_MANAGE_TRANSIT |
 				  DCACHE_OP_HASH |
-- 
2.33.8

