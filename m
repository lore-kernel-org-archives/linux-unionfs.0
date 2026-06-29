Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4865D39BFE1;
	Mon, 29 Jun 2026 06:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782715147; cv=none; b=HhE8O7vH+vgkOPrI06vzTIvWlsVZLjkHCuFGKs79pHKvZJPzDJrqX/0H45Nbgg0Iz1lwqHl1jX+AodVa+GbJ6rl10NQyUCWs2Lcx9uYboY/BTwPfHfMl71xqR2WBnsZlWyzOYu/JwPXuZ2fj45bVPsKAXAhxR+3yAAdDIsYmTog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782715147; c=relaxed/simple;
	bh=tFdp4da63pGuNCmxVMDUVGU6t4TExBFHZ3mC2CuCdF4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ExVGolbnedYzoMSQYYrOMIGkFFi1hvf9UYL9/gyD3xZVTfZrHu8Ub2xOy2zO3X0Qwd2mvdTD/ihYEF+d1U5hlgonbxrIe4y5PIMGKLf6KxUuihY0D5bDRkkZWwPsgoQVSJoru1eNjjnSo33yNa+6d2sORc9+OHYUUnRqDZuYtAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=P0u1X59v; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="P0u1X59v"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=DdaYRsUDWP/7R2Q7Eo9LSwCkqI/DKeoHbxKU7wdgLe0=;
	b=P0u1X59vlA2ZodYomLCtg+VoRI0S7Yd0dXNU/enno2JHJPSxlRMfXY/2uPn9Pu4tgvIf6RwDk
	ZR96vPANQhE0XBYdwJxzI/9kT/ooGPWWNT8yKCnIP6I/dY+PimOciJQbhpt3ubExftFxAw1dQM8
	C/BaFWDqzrTvJP37oOdWI0c=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4gpbwn5VDRz1prLK;
	Mon, 29 Jun 2026 14:29:45 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 27DD840591;
	Mon, 29 Jun 2026 14:38:56 +0800 (CST)
Received: from kwepemq200017.china.huawei.com (7.202.195.228) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 29 Jun 2026 14:38:55 +0800
Received: from octopus.huawei.com (10.67.174.191) by
 kwepemq200017.china.huawei.com (7.202.195.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 29 Jun 2026 14:38:54 +0800
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
Subject: [PATCH stable/linux-5.10.y 5/7] fs: prepare for adding LSM blob to backing_file
Date: Mon, 29 Jun 2026 15:06:51 +0800
Message-ID: <20260629070653.580879-6-caixinchen1@huawei.com>
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

[ Upstream commit 880bd496ec72a6dcb00cb70c430ef752ba242ae7 ]

In preparation to adding LSM blob to backing_file struct, factor out
helpers init_backing_file() and backing_file_free().

Cc: stable@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org
Cc: linux-erofs@lists.ozlabs.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Serge Hallyn <serge@hallyn.com>
[PM: use the term "LSM blob", fix comment style to match file]
Signed-off-by: Paul Moore <paul@paul-moore.com>
[1. The commit def3ae83da02
("fs: store real path instead of fake path in backing file f_path")
is not merged, The 5.10 LTS version accordingly operates on
&ff->real_path instead of &ff->user_path.

2. Mainline's file_free() does both the backing_file cleanup and the
kmem_cache_free() synchronously.  Linux 5.10.y defers the actual kfree()
to file_free_rcu() via call_rcu(), so only path_put() is done
synchronously in file_free().]
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 fs/file_table.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 6daef2e2b2ad..6792d0bce246 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -70,11 +70,16 @@ static void file_free_rcu(struct rcu_head *head)
 		kmem_cache_free(filp_cachep, f);
 }
 
+static inline void backing_file_free(struct backing_file *ff)
+{
+	path_put(&ff->real_path);
+}
+
 static inline void file_free(struct file *f)
 {
 	security_file_free(f);
 	if (unlikely(f->f_mode & FMODE_BACKING))
-		path_put(backing_file_real_path(f));
+		backing_file_free(backing_file(f));
 	if (likely(!(f->f_mode & FMODE_NOACCOUNT)))
 		percpu_counter_dec(&nr_files);
 	call_rcu(&f->f_u.fu_rcuhead, file_free_rcu);
@@ -211,6 +216,12 @@ struct file *alloc_empty_file_noaccount(int flags, const struct cred *cred)
 	return f;
 }
 
+static int init_backing_file(struct backing_file *ff)
+{
+	memset(&ff->real_path, 0, sizeof(ff->real_path));
+	return 0;
+}
+
 /*
  * Variant of alloc_empty_file() that allocates a backing_file container
  * and doesn't check and modify nr_files.
@@ -231,7 +242,14 @@ struct file *alloc_empty_backing_file(int flags, const struct cred *cred)
 	if (unlikely(error))
 		return ERR_PTR(error);
 
+	/* The f_mode flags must be set before fput(). */
 	ff->file.f_mode |= FMODE_BACKING | FMODE_NOACCOUNT;
+	error = init_backing_file(ff);
+	if (unlikely(error)) {
+		fput(&ff->file);
+		return ERR_PTR(error);
+	}
+
 	return &ff->file;
 }
 
-- 
2.18.0.huawei.25

