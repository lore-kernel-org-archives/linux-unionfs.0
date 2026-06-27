Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D902EEE9B;
	Sat, 27 Jun 2026 06:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782541751; cv=none; b=CF+I6BHclDx1xL6zV719mfJxvHbIjvFGyOcDK52XPYrlLv/FImCAzV0Q1Zk2NoRNHwp8t9ghRb4J/CScr2xr8szNtxAqqNgRNmbWlSLPdcvehcbhLIMKK1aKgfH/6JvBZFtZHNaU4hOXPyfqhndvqjaUaTmXz51bPZzKmDEePBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782541751; c=relaxed/simple;
	bh=rNJOUaCkDPacOFqNkrUkc0E59ah+yyGct/mPpROxGdo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VKX4JEvPGWUFvCorb5/Cachec5k3ni5F48ND28ImrW8fl19kj4ZWeOReHGrg76kdyY/nvMi8pbUdJuMFBI7wFaVMfBeR83M060t3l+kNI4aiT7LGqA1xQ8x3FTnZRy7WyKEiw2XWnnZIJaXLHLXO4StwuAONll9fqnOmwXZo+5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=foQN5aGC; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="foQN5aGC"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ljDY3nyizF2W/GnFcYTLCUCIDdg/cS8Qmi/xhTH76YA=;
	b=foQN5aGC/VZ1V6Ge30Kh4AHMUq+z1fmWM0dSgkv62fq5XuBAxa6hrMjEpQ27ofdjVFZwxiLKb
	Xv8boOBQaw3EQIbwE6iFBROkms+gBVa0FSTww8zU3S0v1k6ijvp06fRlkjiLjOPlNBTRAMj2ZdG
	7+L5pt/2gIIb7ENB35v0qyM=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4gnMpn3Gd4z1T4Fw;
	Sat, 27 Jun 2026 14:20:17 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 5F657203B7;
	Sat, 27 Jun 2026 14:29:02 +0800 (CST)
Received: from kwepemq200017.china.huawei.com (7.202.195.228) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 27 Jun 2026 14:29:02 +0800
Received: from octopus.huawei.com (10.67.174.191) by
 kwepemq200017.china.huawei.com (7.202.195.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 27 Jun 2026 14:29:01 +0800
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
Subject: [PATCH v2 stable/linux-6.6.y 0/3] Backport Fix incorrect overlayfs mmap() and mprotect() LSM access controls
Date: Sat, 27 Jun 2026 14:57:17 +0800
Message-ID: <20260627065720.1945589-1-caixinchen1@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq200017.china.huawei.com (7.202.195.228)

v2: Add static to struct kmem_cache *lsm_backing_file_cache; and define
lbs_backing_file as int for keeping the same type as 6.6 lts. Use macro
backing_file to replace inline function to eliminate the const warning.

Backport the patch series
"Fix incorrect overlayfs mmap() and mprotect() LSM access controls" [1]
to 6.6 lts

I test selinux-testsuite[2] overlay test, it pass 135 tests.

[1] https://lore.kernel.org/all/20260403030848.731867-5-paul@paul-moore.com/
[2] https://github.com/SELinuxProject/selinux-testsuite

Amir Goldstein (1):
  fs: prepare for adding LSM blob to backing_file

Paul Moore (2):
  lsm: add backing_file LSM hooks
  selinux: fix overlayfs mmap() and mprotect() access checks

 fs/file_table.c                   |  46 +++++-
 fs/internal.h                     |   3 +-
 fs/open.c                         |   7 +-
 fs/overlayfs/file.c               |   8 +-
 include/linux/fs.h                |  15 +-
 include/linux/lsm_audit.h         |   2 +-
 include/linux/lsm_hook_defs.h     |   5 +
 include/linux/lsm_hooks.h         |   1 +
 include/linux/security.h          |  22 +++
 security/security.c               | 110 ++++++++++++++
 security/selinux/hooks.c          | 242 ++++++++++++++++++++++--------
 security/selinux/include/objsec.h |  11 ++
 12 files changed, 395 insertions(+), 77 deletions(-)

-- 
2.18.0.huawei.25

