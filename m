Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531A938E8C4;
	Mon, 29 Jun 2026 06:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782714997; cv=none; b=QbWD9Z+U0kwXvnvt8HrCfL13a0RT48nB8+/0I0bursq135K1ZfVAqJUhdxvJLogzC0zmLEhBrUVstbsewIe++Y5GMxjGKFoebeIaVirXpIgMQf5T0wYopNg2avfBgmQ0Vr3C7sYbgzD4BNAwgk7OmgBKulWngV35uZabIlmEmWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782714997; c=relaxed/simple;
	bh=dbn89cqNncvD/YGttjdzMR40/PFeyf0xzyIYbKZorpg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IIhmk2WfqM3s50o2K7D/XvFHvqccfBom4nm/p5xixpAKPUNWKNfqJF2thgaruoNTZHHYdwbAa0CoIfF+U4nEzEPPZr7lrRSUlMUWFEraKhpTrigMfyyyfkN1Pv8vqNYx596+wyj1SWE5I7mVCpeEhEVgvufS05wOiLVtB4XIwo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ZA6ERwOb; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ZA6ERwOb"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=g7I0MmSFE5vIlYE0PpCqKellJZf4i4LqXVJT/+dD1XQ=;
	b=ZA6ERwObo9jmqQWb2W4WvfyoTFm/T6eeF0AZ1pIICCG+qlJ1seSDpwJpaKQgK4WS3SIHaPbVa
	Ek/ohFtF9zXvqJV18wB1bMTVGVNMfynUpanRlkNyD+fASuJr/E+4tpRocRzxT4yvfkTvogx/hqk
	+oxXxWxX+YAsbbO7K+0BduE=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4gpbsD0qVrz1d09x;
	Mon, 29 Jun 2026 14:26:40 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 110C740592;
	Mon, 29 Jun 2026 14:35:47 +0800 (CST)
Received: from kwepemq200017.china.huawei.com (7.202.195.228) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 29 Jun 2026 14:35:46 +0800
Received: from octopus.huawei.com (10.67.174.191) by
 kwepemq200017.china.huawei.com (7.202.195.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 29 Jun 2026 14:35:45 +0800
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
Subject: [PATCH v3 stable/linux-6.12.y 0/3] Backport Fix incorrect overlayfs mmap() and mprotect() LSM access controls
Date: Mon, 29 Jun 2026 15:03:35 +0800
Message-ID: <20260629070338.578858-1-caixinchen1@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq200017.china.huawei.com (7.202.195.228)

v3: Backport 4e301d858af17a ("fs: constify file ptr in backing_file
accessor helpers") to fix const-discard warnings

v2: Add static to struct kmem_cache *lsm_backing_file_cache; and define
lbs_backing_file as int for keeping the same type as 6.12.

Backport the patch series
"Fix incorrect overlayfs mmap() and mprotect() LSM access controls" [1]
to 6.12 lts

I test selinux-testsuite[2] overlay test, it pass 135 tests.

[1] https://lore.kernel.org/all/20260403030848.731867-5-paul@paul-moore.com/
[2] https://github.com/SELinuxProject/selinux-testsuite

Amir Goldstein (1):
  fs: constify file ptr in backing_file accessor helpers

Paul Moore (2):
  lsm: add backing_file LSM hooks
  selinux: fix overlayfs mmap() and mprotect() access checks

 fs/backing-file.c                 |  22 ++-
 fs/file_table.c                   |  40 +++--
 fs/fuse/passthrough.c             |   2 +-
 fs/internal.h                     |   4 +-
 fs/overlayfs/dir.c                |   2 +-
 fs/overlayfs/file.c               |   3 +-
 include/linux/backing-file.h      |   4 +-
 include/linux/fs.h                |  19 ++-
 include/linux/lsm_audit.h         |   2 +-
 include/linux/lsm_hook_defs.h     |   5 +
 include/linux/lsm_hooks.h         |   1 +
 include/linux/security.h          |  22 +++
 security/security.c               | 109 ++++++++++++++
 security/selinux/hooks.c          | 242 ++++++++++++++++++++++--------
 security/selinux/include/objsec.h |  11 ++
 15 files changed, 398 insertions(+), 90 deletions(-)

-- 
2.18.0.huawei.25

