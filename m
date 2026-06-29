Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AA63A8721;
	Mon, 29 Jun 2026 06:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782715149; cv=none; b=e85FSwiUFfyyv8uPWSEAoXypTTvENLBRVmfYZ1H/TgutDWY83JvFFS6W+3CaZhEAQHBHXqePxUMIAWHK1KPfcmZ9CkLCe6cCDledCFqPE69iHzvt31OFWEmd18e2hCIcRHA4Lnl7A0iz6gQdczWOp5+Eq1sV1RaDXNf5b4YgMLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782715149; c=relaxed/simple;
	bh=vXaNou+myxsEcCdRnyzIyCUjMVn3vVEbuYtO9RjDMc4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b8x0auPwdQiKdZ1a7B5oO9e+KIQ5Br5oMtlzW9qQU2/oNbTcZuAFIsfQdegQ5DLtRFitErm8oOSTZ5NL6HLqflgIZKpg7OPcXZBnxUdXT20JvMOMpH5gt2A0Hahlxo7hH/Z/d0z7ze4bYkmnStjiX8Hqa5gg7fzQ5AZZqHRcOG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=i3hXHUOZ; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="i3hXHUOZ"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=AayvzdFg4l258oTrjVnVsw8AxcQunWaMu7SMsAOEl94=;
	b=i3hXHUOZoMUwiorKecwC59iLZlO3vejUKqAEGKhkuWOcaVx9Hf9HZlYHwlQZo1MeGT0O9ERwF
	F/WNcOvMUlWqB/2fJNBicpWsJLHG/WHYNuaVsLWNB2YEEdP4dLqUd2vnfeRaIy2CPgEmENaolVv
	W4eSlqBSz1gLK8vbvJybejw=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gpbxF389Mz12LF0;
	Mon, 29 Jun 2026 14:30:09 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id C137740561;
	Mon, 29 Jun 2026 14:38:53 +0800 (CST)
Received: from kwepemq200017.china.huawei.com (7.202.195.228) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 29 Jun 2026 14:38:53 +0800
Received: from octopus.huawei.com (10.67.174.191) by
 kwepemq200017.china.huawei.com (7.202.195.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 29 Jun 2026 14:38:52 +0800
From: Cai Xinchen <caixinchen1@huawei.com>
To: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<miklos@szeredi.hu>, <amir73il@gmail.com>, <paul@paul-moore.com>,
	<jmorris@namei.org>, <serge@hallyn.com>, <stephen.smalley.work@gmail.com>,
	<omosnace@redhat.com>, <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
	<bboscaccy@linux.microsoft.com>, <caixinchen1@huawei.com>
CC: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-unionfs@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
	<selinux@vger.kernel.org>, <bpf@vger.kernel.org>, <stable@vger.kernel.org>,
	<lujialin4@huawei.com>
Subject: [PATCH stable/linux-5.10.y 2/7] fs: move kmem_cache_zalloc() into alloc_empty_file*() helpers
Date: Mon, 29 Jun 2026 15:06:48 +0800
Message-ID: <20260629070653.580879-3-caixinchen1@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
In-Reply-To: <20260629070653.580879-1-caixinchen1@huawei.com>
References: <20260629070653.580879-1-caixinchen1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq200017.china.huawei.com (7.202.195.228)

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 8a05a8c31d06c5d0d67b273a4a00f87269adde82 ]

Use a common helper init_file() instead of __alloc_file() for
alloc_empty_file*() helpers and improrve the documentation.

This is needed for a follow up patch that allocates a backing_file
container.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Message-Id: <20230615112229.2143178-4-amir73il@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 fs/file_table.c | 41 ++++++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 15 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 7a3b4a7f6808..be24d724b407 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -93,20 +93,15 @@ int proc_nr_files(struct ctl_table *table, int write,
 }
 #endif
 
-static struct file *__alloc_file(int flags, const struct cred *cred)
+static int init_file(struct file *f, int flags, const struct cred *cred)
 {
-	struct file *f;
 	int error;
 
-	f = kmem_cache_zalloc(filp_cachep, GFP_KERNEL);
-	if (unlikely(!f))
-		return ERR_PTR(-ENOMEM);
-
 	f->f_cred = get_cred(cred);
 	error = security_file_alloc(f);
 	if (unlikely(error)) {
 		file_free_rcu(&f->f_u.fu_rcuhead);
-		return ERR_PTR(error);
+		return error;
 	}
 
 	atomic_long_set(&f->f_count, 1);
@@ -118,7 +113,7 @@ static struct file *__alloc_file(int flags, const struct cred *cred)
 	f->f_mode = OPEN_FMODE(flags);
 	/* f->f_version: 0 */
 
-	return f;
+	return 0;
 }
 
 /* Find an unused file structure and return a pointer to it.
@@ -135,6 +130,7 @@ struct file *alloc_empty_file(int flags, const struct cred *cred)
 {
 	static long old_max;
 	struct file *f;
+	int error;
 
 	/*
 	 * Privileged users can go above max_files
@@ -148,9 +144,15 @@ struct file *alloc_empty_file(int flags, const struct cred *cred)
 			goto over;
 	}
 
-	f = __alloc_file(flags, cred);
-	if (!IS_ERR(f))
-		percpu_counter_inc(&nr_files);
+	f = kmem_cache_zalloc(filp_cachep, GFP_KERNEL);
+	if (unlikely(!f))
+		return ERR_PTR(-ENOMEM);
+
+	error = init_file(f, flags, cred);
+	if (unlikely(error))
+		return ERR_PTR(error);
+
+	percpu_counter_inc(&nr_files);
 
 	return f;
 
@@ -166,14 +168,23 @@ struct file *alloc_empty_file(int flags, const struct cred *cred)
 /*
  * Variant of alloc_empty_file() that doesn't check and modify nr_files.
  *
- * Should not be used unless there's a very good reason to do so.
+ * This is only for kernel internal use, and the allocate file must not be
+ * installed into file tables or such.
  */
 struct file *alloc_empty_file_noaccount(int flags, const struct cred *cred)
 {
-	struct file *f = __alloc_file(flags, cred);
+	struct file *f;
+	int error;
+
+	f = kmem_cache_zalloc(filp_cachep, GFP_KERNEL);
+	if (unlikely(!f))
+		return ERR_PTR(-ENOMEM);
+
+	error = init_file(f, flags, cred);
+	if (unlikely(error))
+		return ERR_PTR(error);
 
-	if (!IS_ERR(f))
-		f->f_mode |= FMODE_NOACCOUNT;
+	f->f_mode |= FMODE_NOACCOUNT;
 
 	return f;
 }
-- 
2.18.0.huawei.25

