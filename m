Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62363128D4;
	Sat, 27 Jun 2026 04:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782532825; cv=none; b=S54/ydFEChL+8cZsOd55aaXYtAjK7+se497NggGqnKWqzIVBC+QGaVFFoMVKlO7GibNkjZYJs+xnpTcDrQLdB51v1lSW0G+CK5RkuUSyidvZwjLUDWfpBRMTiNoBrQfCiy4gnAs5KK7MJDkBJFfh85hk6R/rIUF2jQPNUJYGbtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782532825; c=relaxed/simple;
	bh=5WioYOdkftj4Trcm7BEyYvsRddN1exgX2MN++Iva60I=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rUre8he2atFwLDTOV2wbU9NXGQhuXwUdCoKbbo0RXEyyAk6pVYC2rb2JbrRZbq9oyTmNq1NMTI7u3yd+35Nw+VF4ZLgyMPH+Lk2VJY53L3Yr1BiEgiRqBRnWTl5oJ8nnEjDlg1kO4rx6NlJ9bPdAVD1aRq72rADAAZE4XYIVt1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=n/1O8hT2; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="n/1O8hT2"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=b1uPAzThSzd6EJ5lYoL6dx42p8gcMb26cxd/40Y4GBs=;
	b=n/1O8hT23GEWtntMSXhkM8MWc7mHqZBzdblQoOJuyq1lkOSIoWIH/JVmnr0PbDAtpthbmBvIW
	VvJteLFcZL8AwsF2wSBAA6hY+UCwrG/1ke8rcmy0XGa7ZAa9aAdc4z4y4zjjTDnPAETVM30xIAq
	8rH5fIr/ciWuIMVFIcHYLG4=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4gnJWB2YrdzcZxv;
	Sat, 27 Jun 2026 11:51:34 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 0118E40576;
	Sat, 27 Jun 2026 12:00:17 +0800 (CST)
Received: from kwepemq200017.china.huawei.com (7.202.195.228) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 27 Jun 2026 12:00:16 +0800
Received: from octopus.huawei.com (10.67.174.191) by
 kwepemq200017.china.huawei.com (7.202.195.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 27 Jun 2026 12:00:15 +0800
From: Cai Xinchen <caixinchen1@huawei.com>
To: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<miklos@szeredi.hu>, <amir73il@gmail.com>, <paul@paul-moore.com>,
	<jmorris@namei.org>, <serge@hallyn.com>, <stephen.smalley.work@gmail.com>,
	<omosnace@redhat.com>, <gregkh@linuxfoundation.org>,
	<bboscaccy@linux.microsoft.com>, <caixinchen1@huawei.com>
CC: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-unionfs@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
	<selinux@vger.kernel.org>, <bpf@vger.kernel.org>, <stable@vger.kernel.org>,
	<lujialin4@huawei.com>
Subject: [PATCH v2 stable/linux-6.12.y 0/2] Backport Fix incorrect overlayfs mmap() and mprotect() LSM access controls
Date: Sat, 27 Jun 2026 12:28:33 +0800
Message-ID: <20260627042835.1492435-1-caixinchen1@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq200017.china.huawei.com (7.202.195.228)

v2: Add static to struct kmem_cache *lsm_backing_file_cache; and define
lbs_backing_file as int for keeping the same type as 6.12.

Backport the patch series
"Fix incorrect overlayfs mmap() and mprotect() LSM access controls" [1]
to 6.12 lts

I test selinux-testsuite[2] overlay test, it pass 135 tests.

[1] https://lore.kernel.org/all/20260403030848.731867-5-paul@paul-moore.com/
[2] https://github.com/SELinuxProject/selinux-testsuite

Paul Moore (2):
  lsm: add backing_file LSM hooks
  selinux: fix overlayfs mmap() and mprotect() access checks

 fs/backing-file.c                 |  18 ++-
 fs/file_table.c                   |  27 +++-
 fs/fuse/passthrough.c             |   2 +-
 fs/internal.h                     |   3 +-
 fs/overlayfs/dir.c                |   2 +-
 fs/overlayfs/file.c               |   3 +-
 include/linux/backing-file.h      |   4 +-
 include/linux/fs.h                |  13 ++
 include/linux/lsm_audit.h         |   2 +-
 include/linux/lsm_hook_defs.h     |   5 +
 include/linux/lsm_hooks.h         |   1 +
 include/linux/security.h          |  22 +++
 security/security.c               | 109 ++++++++++++++
 security/selinux/hooks.c          | 242 ++++++++++++++++++++++--------
 security/selinux/include/objsec.h |  11 ++
 15 files changed, 384 insertions(+), 80 deletions(-)

-- 
2.18.0.huawei.25

