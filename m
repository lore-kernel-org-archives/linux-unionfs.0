Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE095192B93;
	Thu, 17 Oct 2024 06:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729147849; cv=none; b=Rpv3qMwXQsYZSNCap7Za+1hReCNexz3GtSD2aEDugI9RHBLce6wdP7cvUEKScK6DhZTlSQLgUTb0apIMu/mG205x09x5wkl1cIt82XMbgHJGGuqzWosfCOQhlzfX8swtntp/XY+yKisJb6riNmbKH/Rjmf+x+h11cOVsHmBOjig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729147849; c=relaxed/simple;
	bh=tPb/LJsBMXp+sf+XXt7oaqFB0XpG6Sy+3n/6QSFIqYQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XIkMZ5r1Y89FJ/TRhqb1TJ4+lvaCkrKFYGyVymrlw+iqDnCx85PFjwabKKtLv1jbWSKf2MwtNr2y6Exe0Oa3E5tODZAzPZP63OV2O7xA+GgrhYdx+jxy/gwIN8DrMTiL1AVTy2rf67BU60EmlrdIXqAQWlHdcewbgccOGoTMEW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4XTdhw1Z8cz1T8Sw;
	Thu, 17 Oct 2024 14:48:48 +0800 (CST)
Received: from kwepemd500019.china.huawei.com (unknown [7.221.188.86])
	by mail.maildlp.com (Postfix) with ESMTPS id C5F6F18009B;
	Thu, 17 Oct 2024 14:50:41 +0800 (CST)
Received: from huawei.com (10.67.174.116) by kwepemd500019.china.huawei.com
 (7.221.188.86) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 17 Oct
 2024 14:50:41 +0800
From: Zheng Zucheng <zhengzucheng@huawei.com>
To: <miklos@szeredi.hu>, <amir73il@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-unionfs@vger.kernel.org>
Subject: [PATCH -next] fs: Fix build error
Date: Thu, 17 Oct 2024 06:49:23 +0000
Message-ID: <20241017064923.1585214-1-zhengzucheng@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemd500019.china.huawei.com (7.221.188.86)

The following build error report:
fs/overlayfs/file.c: In function ‘ovl_file_end_write’:
fs/overlayfs/file.c:292:51: error: parameter name omitted
  292 | static void ovl_file_end_write(struct file *file, loff_t, ssize_t)
      |                                                   ^~~~~~
fs/overlayfs/file.c:292:59: error: parameter name omitted
  292 | static void ovl_file_end_write(struct file *file, loff_t, ssize_t)
                                                                  ^~~~~~~

Fixes: 291f180e5929 ("fs: pass offset and result to backing_file end_write() callback")
Signed-off-by: Zheng Zucheng <zhengzucheng@huawei.com>
---
 fs/overlayfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 70df61d5e95a..faeac5842694 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -289,7 +289,7 @@ static void ovl_file_modified(struct file *file)
 	ovl_copyattr(file_inode(file));
 }
 
-static void ovl_file_end_write(struct file *file, loff_t, ssize_t)
+static void ovl_file_end_write(struct file *file, loff_t pos, ssize_t ret)
 {
 	ovl_file_modified(file);
 }
-- 
2.34.1

