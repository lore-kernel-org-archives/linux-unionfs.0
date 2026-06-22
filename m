Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E08190473;
	Mon, 22 Jun 2026 02:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782096459; cv=none; b=qQNnqy3VDWtAXmO6SrsD41Vj3+huYwcosWzAcm4rYYNu0QX6qAKfwcxTaMdCXGchvAEXfSzkLXEGtuUvD02g4GSyWckbVNS0dLHZM6s1NlQIYjs63Ox7THAFsZsdAh3agWB64qZIuNwlO56ZMivR/3Xl9X7/8ZTOz28zc1hYXmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782096459; c=relaxed/simple;
	bh=ZbONalUUQb2VubsHh9B9Mx/myq6aO6QInbNsOjvtXBQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bw+KS87Pg7AYv/4LLXTlY1XiAATrOuXdWLMaRl1p3tEP1B43RRUjQ7ECvZNObhxlZRLFCPRD0wt2oh4gJVvxTrxhG+pCLlJxeCi5X8fRIyYxQ4rFIotv7mfHIhnlzHD1yHbpwUMu8lczJTUPRp7a3cEVO9Y5YFAmTAJvidWhtpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=xgceu58z; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="xgceu58z"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=/qccRdh7jdYXE8ZHlYbMqrPoXHhpFP/+x0Q5C5FqIp8=;
	b=xgceu58zZmV5XpG4v9F0NpkkzlNb3uBZkZ1AOSfO94a0lExFzgiRQ99Qn+TptD/aebLgGRZ/y
	/xXmO4c/bfK5rhkFXka0CREVWhHFvu9TnMNAL4rOLog9OKMrVq965qFCPJmqGqkTAojEk19KqV2
	p9x9/1iU876D+jG73yhXg3o=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4gkC7D0LzmzmV98;
	Mon, 22 Jun 2026 10:38:32 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 2BC2F4056C;
	Mon, 22 Jun 2026 10:47:36 +0800 (CST)
Received: from kwepemq200017.china.huawei.com (7.202.195.228) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Jun 2026 10:47:35 +0800
Received: from octopus.huawei.com (10.67.174.191) by
 kwepemq200017.china.huawei.com (7.202.195.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Jun 2026 10:47:35 +0800
From: Cai Xinchen <caixinchen1@huawei.com>
To: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<miklos@szeredi.hu>, <amir73il@gmail.com>, <paul@paul-moore.com>,
	<jmorris@namei.org>, <serge@hallyn.com>, <stephen.smalley.work@gmail.com>,
	<omosnace@redhat.com>, <gregkh@linuxfoundation.org>,
	<bboscaccy@linux.microsoft.com>
CC: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-unionfs@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
	<selinux@vger.kernel.org>, <bpf@vger.kernel.org>, <lujialin4@huawei.com>
Subject: [stable/linux-6.6.y 0/3] Backport Fix incorrect overlayfs mmap() and mprotect() LSM access controls
Date: Mon, 22 Jun 2026 11:15:53 +0800
Message-ID: <20260622031556.2664089-1-caixinchen1@huawei.com>
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
to 6.6 lts

I test selinux-testsuite[2] overlay test, it pass 135 tests.

[1] https://lore.kernel.org/all/20260403030848.731867-5-paul@paul-moore.com/
[2] https://github.com/SELinuxProject/selinux-testsuite

Amir Goldstein (1):
  fs: prepare for adding LSM blob to backing_file

Paul Moore (2):
  lsm: add backing_file LSM hooks
  selinux: fix overlayfs mmap() and mprotect() access checks

 fs/file_table.c                   |  41 ++++-
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
 12 files changed, 394 insertions(+), 73 deletions(-)

-- 
2.18.0.huawei.25

