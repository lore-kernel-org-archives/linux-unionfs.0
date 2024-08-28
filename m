Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6851314A4D6
	for <linux-unionfs@vger.kernel.org>; Wed, 28 Aug 2024 11:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724846237; cv=none; b=o+ht42uQRNzZz2ptinuqGZCyxSMgIa0UolkCjXvJUxW61BvnodOlNmM19cU2ElgDJ3WiY8xdLR2hgVR8/74xJ7KzjkkeRvUW1a63Ld6UAjaZYeF0iN7FhlcjHjW+mpKh56gHH+JNyOtax/W0DA8JB6umzalTmGxVHwf3A0rs18c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724846237; c=relaxed/simple;
	bh=Qg01jAw6fWd4qinZ7f1NNenmXMwuExwxQxPvodIHOp0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BN34EoztNypSzs/24/QogwFIRQCPBIalDxYkIXjlhNABqMmATgB21TK9Y61cbdDm8bumostbGOBJjpxtT/4OGVhkRU8d54kva0CzJX2SeHsb45FlaaNpxZvE5Ks15aVSwUw4fWThDc1MQ5MMr02tExKE9gs4R3iW5QW21GOHWrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Wv2sb23FJz1xwPj
	for <linux-unionfs@vger.kernel.org>; Wed, 28 Aug 2024 19:55:15 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id EF8151401F2
	for <linux-unionfs@vger.kernel.org>; Wed, 28 Aug 2024 19:57:12 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 28 Aug
 2024 19:57:12 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <miklos@szeredi.hu>, <amir73il@gmail.com>
CC: <linux-unionfs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH -next] ovl: obtain fs magic from superblock
Date: Wed, 28 Aug 2024 20:05:14 +0800
Message-ID: <20240828120514.3695742-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)

The sb->s_magic holds the file system magic, we can use
this to avoid use file system magic macro directly.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/overlayfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 06a231970cb5..c809e845765f 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -256,7 +256,7 @@ static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
 	err = vfs_statfs(&path, buf);
 	if (!err) {
 		buf->f_namelen = ofs->namelen;
-		buf->f_type = OVERLAYFS_SUPER_MAGIC;
+		buf->f_type = sb->s_magic;
 		if (ovl_has_fsid(ofs))
 			buf->f_fsid = uuid_to_fsid(sb->s_uuid.b);
 	}
-- 
2.34.1

