Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E201CAA78;
	Fri, 26 Jun 2026 02:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782439970; cv=none; b=JnGyOxWkkV/j1PEadVNLu7j0t86Y7nR+XKV7DYz26Cid1eqWYolRltUdxMXP85rVMaPvxee62wEPHxBfmZ/UO7x2QQHS0ZYyKPElR1ZuGHDhw4tFKUG6RrqC8kgkX5kNiGp2niUYBHMft1ws8s3qdUQ/jhztwrnta864V9Jii60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782439970; c=relaxed/simple;
	bh=3bUDTGUuBPkouAcaf6j/ke2Rt4TVx2uL1+k4d7AqZtY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=G/5I+1ERTL7lql36BdldhfCTdkfQagrYAYKwTTqJBJPkkaNJd5ZqSIZp3ALQSi62mhoSXNF3lPE11GpmKcY9P3unkQPD9mQ4W8Uvnr4p9f6P2wZq30A5oXExU9chHjPMvlDEcbnQnlmyJCNvU6XXo7PU1pM/F6U5UYchfu9p1kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Tv7pTf4E; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Tv7pTf4E"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=izqAsj70qZfNF1O/YzvFj7uUN5J/lCj7ZHpgxS9ZCVA=;
	b=Tv7pTf4Ets2kpKcaYLiW3eenpr4XZrE3LHw7uKECF9M+l+KdDPHIVNtzi08S1wJviPUf6N24e
	TcHh1WU1gvpiZ5/lX8ZXf7HpyR3W5DjgrCGnZGSvhxDDWu4hDnXjeJQ2iHWzKmuwP0k9fFLFHRO
	NjHaR5J2ir1Xn9Bub70lCZs=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4gmf9b3JgwzcZyj;
	Fri, 26 Jun 2026 10:04:03 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 2352640537;
	Fri, 26 Jun 2026 10:12:44 +0800 (CST)
Received: from kwepemq200017.china.huawei.com (7.202.195.228) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 26 Jun 2026 10:12:43 +0800
Received: from octopus.huawei.com (10.67.174.191) by
 kwepemq200017.china.huawei.com (7.202.195.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 26 Jun 2026 10:12:43 +0800
From: Cai Xinchen <caixinchen1@huawei.com>
To: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<miklos@szeredi.hu>, <amir73il@gmail.com>, <paul@paul-moore.com>,
	<jmorris@namei.org>, <serge@hallyn.com>, <stephen.smalley.work@gmail.com>,
	<omosnace@redhat.com>, <gregkh@linuxfoundation.org>,
	<bboscaccy@linux.microsoft.com>, <caixinchen1@huawei.com>
CC: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-unionfs@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
	<selinux@vger.kernel.org>, <bpf@vger.kernel.org>, <lujialin4@huawei.com>
Subject: [PATCH v2 stable/linux-6.18.y 0/2] Backport Fix incorrect overlayfs mmap() and mprotect() LSM access controls
Date: Fri, 26 Jun 2026 10:40:56 +0800
Message-ID: <20260626024058.3149217-1-caixinchen1@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq200017.china.huawei.com (7.202.195.228)

v2: Add static to struct kmem_cache *lsm_backing_file_cache; and define
lbs_backing_file as int for keeping the same type as 6.18.

Backport the patch series
"Fix incorrect overlayfs mmap() and mprotect() LSM access controls" [1]
to 6.18 lts

I test selinux-testsuite[2] overlay test, it pass 135 tests.

[1] https://lore.kernel.org/all/20260403030848.731867-5-paul@paul-moore.com/
[2] https://github.com/SELinuxProject/selinux-testsuite

Paul Moore (2):
  lsm: add backing_file LSM hooks
  selinux: fix overlayfs mmap() and mprotect() access checks

 fs/backing-file.c                 |  17 ++-
 fs/file_table.c                   |  27 +++-
 fs/fuse/passthrough.c             |   2 +-
 fs/internal.h                     |   3 +-
 fs/overlayfs/dir.c                |   2 +-
 fs/overlayfs/file.c               |   2 +-
 include/linux/backing-file.h      |   4 +-
 include/linux/fs.h                |  13 ++
 include/linux/lsm_audit.h         |   2 +-
 include/linux/lsm_hook_defs.h     |   5 +
 include/linux/lsm_hooks.h         |   1 +
 include/linux/security.h          |  22 +++
 security/security.c               | 109 ++++++++++++++
 security/selinux/hooks.c          | 242 ++++++++++++++++++++++--------
 security/selinux/include/objsec.h |  11 ++
 15 files changed, 383 insertions(+), 79 deletions(-)

-- 
2.18.0.huawei.25

