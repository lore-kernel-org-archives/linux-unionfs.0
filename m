Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD749399D10;
	Mon, 29 Jun 2026 06:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782715137; cv=none; b=ebOxAvY+YloHYlkxaJDjDiexZkga3bT9sIAUQY3G0dZwzVOnQzciwBNFmHrrFd+0JrcAUAf6mGj5DKFPss1VmAku5j5IVbIVhGcIa13bRD739Efx1FapzBSfuKblM5mW0rWW0XKCg7wj5gZwkdF6Zv8ALBv72zAeySYq2yxodOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782715137; c=relaxed/simple;
	bh=wT+1VqkUfVlajCfSh30VOX8IdgOsqcLaACfaLGo+jf8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=J76GcJx+pc1g8FTylwvSxTKbMe/Mk829GPFVNAIAXkb3tayB/OZzqJEIO7ONXOk0qtiGzFVcabqQRJDpvDwhUWRxhwLZ6Crr7RlhEg1MK68hDH4xf1OIuLQgI8yLsZ1W3wOJFVvt5SJkJkhO+NPyfXJ0nWQ3dL6R2ueGc34WEOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=1W6n+TRN; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="1W6n+TRN"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=vNOk6xP1MRsuuLNQDyth3iMzKUHZQtoXBgGpmNwJC+E=;
	b=1W6n+TRNAYw2xqpWpURFlIsKrKbZQDuKfPmknRTGx9CQa06TgzZ9KJYHJWE8cwZ926ClQBCFq
	CbScyOR56017c5h9GKKB7SwiPJ7YvdS91PE57x6UCQjDe2eGIhJriIo1fZLMKHORIjmdxAUEG+B
	S7cuiFR9I2cloDffbOhds+s=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gpbwl5C4fzLm4W;
	Mon, 29 Jun 2026 14:29:43 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 1C5724055B;
	Mon, 29 Jun 2026 14:38:52 +0800 (CST)
Received: from kwepemq200017.china.huawei.com (7.202.195.228) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 29 Jun 2026 14:38:51 +0800
Received: from octopus.huawei.com (10.67.174.191) by
 kwepemq200017.china.huawei.com (7.202.195.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 29 Jun 2026 14:38:50 +0800
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
Subject: [PATCH stable/linux-5.10.y 0/7] Backport Fix incorrect overlayfs mmap() and mprotect() LSM access controls
Date: Mon, 29 Jun 2026 15:06:46 +0800
Message-ID: <20260629070653.580879-1-caixinchen1@huawei.com>
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

ackport the patch series
"Fix incorrect overlayfs mmap() and mprotect() LSM access controls" [1]
to 5.10 lts

I test selinux-testsuite[2] overlay test, it pass 135 tests.

[1] https://lore.kernel.org/all/20260403030848.731867-5-paul@paul-moore.com/
[2] https://github.com/SELinuxProject/selinux-testsuite

Amir Goldstein (4):
  ovl: pass layer mnt to ovl_open_realfile()
  fs: move kmem_cache_zalloc() into alloc_empty_file*() helpers
  fs: use backing_file container for internal files with "fake" f_path
  fs: prepare for adding LSM blob to backing_file

Khadija Kamran (1):
  lsm: constify the 'file' parameter in security_binder_transfer_file()

Paul Moore (2):
  lsm: add backing_file LSM hooks
  selinux: fix overlayfs mmap() and mprotect() access checks

 fs/file_table.c                   | 125 +++++++++++++--
 fs/internal.h                     |   6 +-
 fs/open.c                         |  46 ++++--
 fs/overlayfs/file.c               |  32 ++--
 fs/overlayfs/overlayfs.h          |   1 +
 fs/overlayfs/util.c               |  14 ++
 include/linux/fs.h                |  46 +++++-
 include/linux/lsm_audit.h         |   2 +-
 include/linux/lsm_hook_defs.h     |   7 +-
 include/linux/lsm_hooks.h         |   1 +
 include/linux/security.h          |  26 ++-
 security/security.c               | 112 ++++++++++++-
 security/selinux/hooks.c          | 252 ++++++++++++++++++++++--------
 security/selinux/include/objsec.h |  11 ++
 14 files changed, 560 insertions(+), 121 deletions(-)

-- 
2.18.0.huawei.25

