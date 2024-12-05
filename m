Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D99149C64
	for <linux-unionfs@vger.kernel.org>; Thu,  5 Dec 2024 14:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733409226; cv=none; b=Wt5yGDIF0lUqNo8tQoHtGo33NajwoeBLhmOtk+dPJczL467jwpY9GAmJcUHyEz06oSbr1vCBQeuYZ0r7dCDU4IWA7bbgQX8afVcgM+2C4A8zzERxF+iHplFhHYD6cqXJDLZRsvmcQ+nEW/JTNC0L3ajtT4S3BLbU1xuh/IlY2Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733409226; c=relaxed/simple;
	bh=6oy5k/LTVs04k/XQNWddAVb9K83NQjSFPF6Sa6+hG8o=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NExg4KcX9DXtGcMrpj/fEZHgOCJXK5EJCpGQ5pjltTMvu4SbtRGh1tUx11axmY5ouG8d8caWYO97m1m4Ovvj/4HIPp3shqGzUvHzRnMDE+lk7p5gaKsEETwwLQxhsYzQm7H7QOrcZ0EthIVH1iQf4biCjO6Fmp2LwjklbtFQxaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Y3xf04ZNhz2FbvX;
	Thu,  5 Dec 2024 22:31:20 +0800 (CST)
Received: from dggpeml500011.china.huawei.com (unknown [7.185.36.84])
	by mail.maildlp.com (Postfix) with ESMTPS id F24701402C7;
	Thu,  5 Dec 2024 22:33:38 +0800 (CST)
Received: from huawei.com (10.175.113.32) by dggpeml500011.china.huawei.com
 (7.185.36.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 5 Dec
 2024 22:33:38 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <miklos@szeredi.hu>, <amir73il@gmail.com>, <akpm@linux-foundation.org>,
	<lorenzo.stoakes@oracle.com>, <vbabka@suse.cz>, <jannh@google.com>
CC: <linux-mm@kvack.org>, <linux-unionfs@vger.kernel.org>,
	<wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>, <yi.zhang@huawei.com>,
	<tujinjiang@huawe.com>
Subject: [PATCH -next] ovl: respect underlying filesystem's get_unmapped_area()
Date: Thu, 5 Dec 2024 22:30:38 +0800
Message-ID: <20241205143038.3260233-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500011.china.huawei.com (7.185.36.84)

During our tests in containers, there is a read-only file (i.e., shared
libraies) in the overlayfs filesystem, and the underlying filesystem is
ext4, which supports large folio. We mmap the file with PROT_READ prot,
and then call madvise(MADV_COLLAPSE) for it. However, the madvise call
fails and returns EINVAL.

The reason is that the mapping address isn't aligned to PMD size. Since
overlayfs doesn't support large folio, __get_unmapped_area() doesn't call
thp_get_unmapped_area() to get a THP aligned address.

To fix it, call get_unmapped_area() with the realfile.

Besides, since overlayfs may be built with CONFIG_OVERLAY_FS=m, we should
export get_unmapped_area().

Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 fs/overlayfs/file.c | 20 ++++++++++++++++++++
 mm/mmap.c           |  1 +
 2 files changed, 21 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 969b458100fe..d0dcf675ebe8 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -653,6 +653,25 @@ static int ovl_flush(struct file *file, fl_owner_t id)
 	return err;
 }
 
+static unsigned long ovl_get_unmapped_area(struct file *file,
+		unsigned long addr, unsigned long len, unsigned long pgoff,
+		unsigned long flags)
+{
+	struct file *realfile;
+	const struct cred *old_cred;
+	unsigned long ret;
+
+	realfile = ovl_real_file(file);
+	if (IS_ERR(realfile))
+		return PTR_ERR(realfile);
+
+	old_cred = ovl_override_creds(file_inode(file)->i_sb);
+	ret = get_unmapped_area(realfile, addr, len, pgoff, flags);
+	ovl_revert_creds(old_cred);
+
+	return ret;
+}
+
 const struct file_operations ovl_file_operations = {
 	.open		= ovl_open,
 	.release	= ovl_release,
@@ -661,6 +680,7 @@ const struct file_operations ovl_file_operations = {
 	.write_iter	= ovl_write_iter,
 	.fsync		= ovl_fsync,
 	.mmap		= ovl_mmap,
+	.get_unmapped_area = ovl_get_unmapped_area,
 	.fallocate	= ovl_fallocate,
 	.fadvise	= ovl_fadvise,
 	.flush		= ovl_flush,
diff --git a/mm/mmap.c b/mm/mmap.c
index 16f8e8be01f8..60eb1ff7c9a8 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -913,6 +913,7 @@ __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 	error = security_mmap_addr(addr);
 	return error ? error : addr;
 }
+EXPORT_SYMBOL(__get_unmapped_area);
 
 unsigned long
 mm_get_unmapped_area(struct mm_struct *mm, struct file *file,
-- 
2.34.1

