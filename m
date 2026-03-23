Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA4C291C10
	for <linux-unionfs@vger.kernel.org>; Mon, 23 Mar 2026 04:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774239924; cv=none; b=jb5OYFQfzm1nYvYL8bcEsPaoiBK5zxoepJE8es+0J3A2wt675tIjlTRq2pKsREWHjNCig2g2Umtl3AyWaVN6XYKMXgxBMQUm/8rOqrPdzphMIFjskR3v+Hda6T90s2OIKT1UCwjriqCAJZrB1NK7aXPJwqDemzzyllNamD8e3Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774239924; c=relaxed/simple;
	bh=9CQVC13UfnGA+k7t8MLBC3z2a9+S87m7Va2FqPx1Gpg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IHRrefGgi8NSf4Kh2DEYw+2BBEAeJAjUruxWrcP3k+S6mV3rzfWnNTUL6rfr3wIx65uJy6a0ukI5lwUYFcS9RjM2lS5fvE3+sdSQf9iC6JkMT8WDxVpM9qu/xQiJXl083XOLFf7zwfvq2SouuvfNPZenDKwDHf3iWll4uS2eDVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=L7SKQgsw; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="L7SKQgsw"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8cfc5941028so362430285a.1
        for <linux-unionfs@vger.kernel.org>; Sun, 22 Mar 2026 21:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1774239922; x=1774844722; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dHNU+T5mQ52dsDV+e3ezWpkvnj+dhj3Dc5R6m19Ae3g=;
        b=L7SKQgswiIi65AfM5bbqq8OwWMKTtk5IxpH57PRJEwNgk5XIG9sd2XkEr2ase3CRU5
         8CTiFME0Iaj8RCJ12hHPnbbZfgliDDnVtOKT5tfgr+e3I0bcUR8olKXpMhPXyH69ue1z
         lHEcJ86UIYZKbhQ/ZB7veE16p/01zOzlXeGTWseFkZr9X/+/Fio+2U4SaMuP0Z8btpJs
         lTVgV+2hlad3dtZdDMVmqmraKMNWdqLiSXECCfI0ZC66T1TO0uDqCXPVmtmcN0IlST9Q
         tFBKSn8TFbDBvOxc4ufU+YbJfHmalXKa+ro0cDcq71dMK5JL/BeE9SBKCo4ibyA52zwo
         lrJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774239922; x=1774844722;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dHNU+T5mQ52dsDV+e3ezWpkvnj+dhj3Dc5R6m19Ae3g=;
        b=dEYzxJz24/sUjgSqQtiGVU0xhHz+axSaPHErCQlC479fYAO1eQ5BV4FHzL1WnPd+rL
         MrfGDkuHBZalRr2c8b3KAxIAa4gdoUlYoEneW4yWQLyGX1XF7eq1OF9CbkpUTrBs5eSy
         fJlVoS19rYaTRYctDDICmULyHCxbeIfE7MOBR82MEeoH6ZMMlktE892z5t11S/NBGSIv
         WkcIr45/lLlxcv/AsupZhbdsYqnHc8tj6u6T7EUOthR+DWV4a/KUO5eVqfVJfKTjVXJ4
         zxFCTkMJJPMmjSx6dKUncITu6tJ0gi3602sKUarr8zsb+nPEny3F43XqnR9QTML2Z2nN
         JsBA==
X-Forwarded-Encrypted: i=1; AJvYcCUYdxwBxzUVhRB3HOQBVWqHgPZavryIPnn7EXjEDO1Uj/inPXpbU+jFyRq5+/FxyY0XCI/X5RL1zMk1xa+V@vger.kernel.org
X-Gm-Message-State: AOJu0YyC9kJIB8+9ickk4bBm3a7SKf2qXqI8K2PPm800Ww1zaMKYy67x
	QFG1IbVUuOIYMhZVmxCNspd6avuA6stSpWjK9Hum07beYw4xV56DFLD3y50HyRWyVg==
X-Gm-Gg: ATEYQzzBqDEGQJE0Qm0rMu6e7L/4r1eG5LIKSTXyPZMiAozHPVSOp/xOiat/+oagk+V
	r1lllbPckrlR7reGsvz/IiwIsMUYfYBN6RANqFvPLN4vY1zb5YPQ9fBxnFGls94sxJDoL+LrDEz
	PtmPYnov+g2ctM5UTOgggjCTlKJcGuw3WKaRVlCDawSr9sn6rE2IS5EpVH4VLvfHW3ohr4H9rm+
	JYUzrYTRINzJyDyjp+kq3J3t8TNqi05bTq96uml/9kGfbUJCIDFXv/6UKT2pqm0Xqh/UaImQWOI
	mHFUocFjn893wH8DtgsYisd3wo2yMOZXIO6QWCE7+D5B15+p76DWpcq/36bKOEWmCjfdozhQ/Ni
	KBTeIY6YZsTiyeNOLclW0Vu1si2xT/M7CLiwvWJ98PbfXgBMCeC2WxuMGmW+XPivz4Z8e6n1m+B
	JaRxN9uW1SIP3KpaXKN6P864qh6oMGwhx2yyefC2VgPS+QQJ6CyB3xmEte0e8LeDvUZMD9
X-Received: by 2002:a05:620a:3193:b0:8cd:94a5:2f22 with SMTP id af79cd13be357-8cfc7e6d7eamr1552756685a.20.1774239922032;
        Sun, 22 Mar 2026 21:25:22 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc8f5fa29sm677110285a.10.2026.03.22.21.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2026 21:25:21 -0700 (PDT)
From: Paul Moore <paul@paul-moore.com>
To: linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	Gao Xiang <xiang@kernel.org>
Subject: [RFC PATCH v2 0/2] Fix incorrect overlayfs mmap() and mprotect() LSM access controls
Date: Mon, 23 Mar 2026 00:24:17 -0400
Message-ID: <20260323042510.3331778-4-paul@paul-moore.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a follow-up revision to the patchset[1] posted a week ago.  This
second version has changed significantly in terms of approach and
implementation, as it has become clear that the overlayfs/VFS devs are
unable to make the user O_PATH file approach work.  Unfortunately, this
pushes a lot of the complexity down into the LSM, as opposed to the
backing file code, and will likely result in code and state duplication
across the different LSMs, but at this point in time it doesn't appear
we have any other options.

I'm marking this patchset as a RFC since I've only done basic testing
on this patchset, and I still haven't satisfied myself that the code
covers all of the different cases.  Additional inspection and testing
is required, however, please feel free to take a look and comment on
anything that looks odd.  As always, additional testing is welcome and
encouraged.

[1] https://lore.kernel.org/linux-security-module/20260316213606.374109-5-paul@paul-moore.com/

--
CHANGELOG:
v2:
- remove the user O_PATH file patch from Amir
- add the backing_file LSM blob and lifecycle hooks
- update the SELinux code to reflect the other changes
v1:
- initial version

--
Paul Moore (2):
      lsm: add backing_file LSM hooks
      selinux: fix overlayfs mmap() and mprotect() access checks

 fs/backing-file.c                 |   18 +-
 fs/erofs/ishare.c                 |   10 +
 fs/file_table.c                   |   21 ++
 fs/fuse/passthrough.c             |    2 
 fs/internal.h                     |    3 
 fs/overlayfs/dir.c                |    2 
 fs/overlayfs/file.c               |    2 
 include/linux/backing-file.h      |    4 
 include/linux/fs.h                |    1 
 include/linux/lsm_audit.h         |    2 
 include/linux/lsm_hook_defs.h     |    5 
 include/linux/lsm_hooks.h         |    1 
 include/linux/security.h          |   22 ++
 security/lsm.h                    |    1 
 security/lsm_init.c               |    9 +
 security/security.c               |  100 +++++++++++
 security/selinux/hooks.c          |  252 +++++++++++++++++++++---------
 security/selinux/include/objsec.h |   17 ++
 18 files changed, 387 insertions(+), 85 deletions(-)

