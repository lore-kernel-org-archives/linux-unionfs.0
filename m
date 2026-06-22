Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282633368B6;
	Mon, 22 Jun 2026 02:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782096376; cv=none; b=cdbWFcQn2JFwUFRVaIrSXOM9a2zM8mf2eLmyeTbfurHw5CQmkkeWW758BlruDiTYbIMD+616pgg9cR/9gxPxHecHDXyaMyGtHxXNtJIPrJy3Uv3h/JqMnkvmoaywwfoZooiPhOGIZFTlrb9zJujJAM+td8wSMMJxyHwfJWqAymI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782096376; c=relaxed/simple;
	bh=ecSCH8B2TGpj5VKmxrOF/uPKN53mAl8NkW+VRTZfJdY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oUU41xO+KTRneWf/mZYc8DV1dyYxlqr3oMw2o+4m46aFv0MuhrLkSbrR4C9W5x0um/9aCITRZ4r2cze2rQW8WEiYDGp8lemRUTYLLDBnlkKWUCKdTrAzhGbNf6nbucb1wbm69cLUpIL51OK8I9Uu63xlbW6/bTMz836d+l9j3fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Flrh86l/; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Flrh86l/"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kxQ+pTQUG7fALAdw3vNbYQmc4GHeIWh4uuQ5d0leHiQ=;
	b=Flrh86l/NkbreKHOa4aQG47T/2KOHo3ZQyxUSqTIywCEIy7ICtoZWY1exKep476whC54WtzLa
	ihPz4DoGeqOWj7RO4Ms155OOvk2n6dPdu2GU8S7aXk1JxxtW4qnFajb7NJXlarM+G8dla5O0IJM
	9U31+xmlGeb0rwGsHfIpcnI=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4gkC5P5sYfzRhQs;
	Mon, 22 Jun 2026 10:36:57 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 69C5B40538;
	Mon, 22 Jun 2026 10:46:00 +0800 (CST)
Received: from kwepemq200017.china.huawei.com (7.202.195.228) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Jun 2026 10:46:00 +0800
Received: from octopus.huawei.com (10.67.174.191) by
 kwepemq200017.china.huawei.com (7.202.195.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Jun 2026 10:45:59 +0800
From: Cai Xinchen <caixinchen1@huawei.com>
To: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<miklos@szeredi.hu>, <amir73il@gmail.com>, <paul@paul-moore.com>,
	<jmorris@namei.org>, <serge@hallyn.com>, <stephen.smalley.work@gmail.com>,
	<omosnace@redhat.com>, <gregkh@linuxfoundation.org>,
	<bboscaccy@linux.microsoft.com>
CC: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-unionfs@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
	<selinux@vger.kernel.org>, <bpf@vger.kernel.org>, <lujialin4@huawei.com>
Subject: [stable/linux-6.18.y 0/2] Backport Fix incorrect overlayfs mmap() and mprotect() LSM access controls
Date: Mon, 22 Jun 2026 11:14:14 +0800
Message-ID: <20260622031416.2663747-1-caixinchen1@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq200017.china.huawei.com (7.202.195.228)

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

