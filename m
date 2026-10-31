Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793440639;
	b=wSRycEk3HboS9uj504GiksT0KzbBOxXGdJDfpnN/WcnemUjhRWdlpkVbIc0KQx0arGw/
	 d7ZvFA7pprXCqjuq8gtHLv3B9rIy5cvI449ksvhWo9CiuuKsYDDGk0AtZCgAikezDLllN
	 l+L5+PA97aLmVY9GNUQbPHYiA5yinLRpOmqz1yCUj/8q0GnHRX/KsOStO8Bk9Nunc3LLV
	 KqfnYk3x/rYzgpTOqkDsMkU4sPFceQpUV/aP5Yd7SAcCAfzK4RIqXeyA5kPgY1zfZu/j/
	 3YFr7AQkZ7JELHet3m0nABc2xDa/ngSAjl9Ijjw+hF6HNk+AJDDvnooySotrM/IzJpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793440639;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=OsyNUXVXYVasBHvigfoIW6Ne0ad3jx5r3liNsbVXCQA=;
	b=Jp+TCc7VZ4oNNlp8c2710+FxxjF9bwj2/yENNN/SyAZdhT8PUWEsroa+c/SiYxsWTZEf
	 Irsrk0VPgtUNHfybheLHymg8mcFJF1sLjSosKaXZ8isFiCKWzjRUazL+QMJAMn6fprP67
	 Qp0n3CrHrOGsYE0TgaUoZhFTh6hFMVTW23VD6rTQASKwqwSubgEMmihPnXN052crLhxaa
	 jUsC/A97OubtPrQg3m71mWs8OYON2yx8hsLGj0v7A7IJBXBoILP4JUkOjhFq6f1+Xf1kc
	 rKZFfsPHI/EAJOh5Zz2bClUe+1XGfBT2c1KAknQXsom0UtIm7r+r1DGsX0YBwdDhfqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XnTL5T+D;
	arc=none smtp.remote-ip=209.85.218.42
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905B7606A31D
	for <linux-unionfs@vger.kernel.org>; Sat, 31 Oct 2026 09:57:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 905B7606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XnTL5T+D
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c40e30c26a4so526151366b.0
        for <linux-unionfs@vger.kernel.org>; Sat, 31 Oct 2026 02:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793440638; x=1794045438; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OsyNUXVXYVasBHvigfoIW6Ne0ad3jx5r3liNsbVXCQA=;
        b=XnTL5T+DL2phlNXmbqkLLhvirOg7giMe+mzsT6jZ3P8q/gtVkvtsUMetvI3WeBSUvk
         llwG/hhPLVMRmIyp8d5tgkbOZoBBQIuLCegr9vGom7SruDl1DB179AUZ/Yhhfxjzf7c7
         CxwW9/z1nouoKL6XVjZYisWJa+bfFOXecphWR9/tI5EnH739xdz7+xgWS5H71GI5KCAd
         nIdiHLJGUT8eLmrYRG9E2+VcvEy9Ru36X6uVFpmK7yOe6qdRHTjuMFHgVpM+Dy6CQgMv
         SyHcR9mvXrE9s3dzRZVY4TJ9SDpnQTzTYsZRKuGZqj4rI1QiINkvSJasKRJ0GPmbEcEb
         sXsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793440638; x=1794045438;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OsyNUXVXYVasBHvigfoIW6Ne0ad3jx5r3liNsbVXCQA=;
        b=uf5/txaW7DSepDQWC6EfKlrFG9zq+4PeT4fe26wia6afSqO9MK7DnLIL/wlv17fPMR
         pVe6ojF7jPw4d5ZVAIPyluXBll6OnIswJwcEvBHrKVQCQfLwCwX0bmTmZcsCSBbksj3f
         4m2NpaFzX1xJLzUbo/vu1vmasS/lTAlenizXrdxHoVSYaNKHyVIOQADqyiOcdtcg8R0C
         dZYRp0Wof0aotdg2ruJA9aywrQ5FWGq5RT6ljHRgbw9n/V1jMqBtldVke2RIodwkBuM/
         9WOaPNF2fxpSJyvFy49wDRWCOKcj9bC1nSY70Z+oTxf8mZzcl1NbyFoRSgUxEgF6ZJhd
         yv1Q==
X-Forwarded-Encrypted: i=1; AKwUvBzkocGpd9J5EpUBCCRUpwmhvdkQgv2TT/dGwfztbRU+ylXx8AuV+NZUHDWvtXxQ7OhGzCQT1jBvZnKIifCp@vger.kernel.org
X-Gm-Message-State: AFq9FYK/AMBrP+lOX+EnS47IugP+XFpUk8wiTxTvH75ScrHNkdIxYT/v
	0tKf5pW9X5HAzN5fnbEXbbXHCunrgZYSehXRj+Gnj20ZJrCHUVhoatCzT4Wtyg2G
X-Gm-Gg: AYBFou2RJnMx6c1mM198x5uhAx2Dk8rx6DgKezSkXMyU1AswsyR9RSB9YfKC7YGEqcM
	aolAXN0ShHgnexoPTLeEoEGagx4WSu232h+lXjR6TWhk1dX9KVYAmQSEBqTFgT3Gt2HUt8DdMq3
	AnIRgsxCgByfs/vG+oAllcbIPBE5e7DrH6O/q61BW0EJxJrNN7i+rQigbP88PgLeDN97MVKJHqg
	krWXxpqdAPWdWzht/8DMdnDUeMDxwvjg9koNJwyqzMjrYY2Fuz1T6V2otaqUcMPN43iyqDVshWJ
	TYplSI03h08X8m49QR+A2qXiug7FwoWROtzDPgq+u4GOLKnr0Yktg3ax1dR5ANr3Pejyp3qgQkb
	mpZIU4bvVBCba4hjY8YDYFe1FrCDhNNefEPYSEA3BrQkvwTWa11GTjeOpwc/rvsRlyGp1ZoF4rQ
	pAvH96IKouBaW5+Rb0YjMVP6bNAP2DRsvkCw/Gd6Goc/bFUkKuKmMiJ9QCwy2+pmP6nhQH2Z5ns
	vaTxO2Tf0dd00rMdsBCYruusgT4CfEM4N4yOPTuDoZTlHcLOqyqw4aabyyeC9LWxvArrf7AKH4s
	oOzdgwq+BuvzHPMDlqym2pEUCHdND9H508H2d3U/QS6Jff/u9wSuLKphsOH10lw1WCJAhSdrqJg
	9FK3EvMfp4LrwhpcpolBpm1yUV2PY4+cv0A==
X-Received: by 2002:a17:907:940f:b0:c2e:1b6b:8b19 with SMTP id a640c23a62f3a-c49d142cb22mr731014066b.23.1793440637746;
        Sat, 31 Oct 2026 02:57:17 -0700 (PDT)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4cabe1002asm162304466b.45.2026.10.31.02.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 02:57:17 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: [GIT PULL] overlayfs fixes for 7.3
Date: Sat, 31 Oct 2026 10:57:16 +0100
Message-ID: <20261031095716.3030288-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linus,

Please pull overlayfs fixes for 7.3.

- Was in linux-next overnight

- Gone through the usual overlayfs test routines

- Includes one change in vfs code, factor out helper
  try_take_dentry_name_snapshot() with RVB from Christian

- Merges cleanly with master branch of the moment

Note that commit 8457ca071faba ("selftests/ovl: fix detached layer
mountinfo expectations") was already merged via Christain's vfs.fixes
PR from earlier today is duplicate and also on my branch.

Standard maintainers race and miscommunication. No merge conflict.
Let me know if you want me to drop this patch from my branch.

Thanks,
Amir.

----------------------------------------------------------------
The following changes since commit 214897acc8c2e5d6b63189d23ccaed6fa2af45a9:

  Revert "namei: don't reveal overmounted entries in refwalk" (2026-10-16 10:50:57 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git ovl-fixes-7.3

for you to fetch changes up to 1d27da7de3f74405b1de85ad26c5ea90f826114b:

  ovl: check the casefold flag of directories only (2026-10-29 13:40:31 +0100)

----------------------------------------------------------------
overlayfs fixes for 7.3

- Fixes for bugs found by Chris Mason's AI review, several of them
  reachable by unprivileged users: an info leak, use-after-free and NULL
  deref bugs, an RCU walk stall with remote layers and data loss with
  nfs_export

- Fix copy up of files with an empty security.capability xattr, which
  any user could set to block copy up

- Fix a regression from v6.16 with the override_creds mount option

- Two casefold fixes

----------------------------------------------------------------
Amir Goldstein (6):
      ovl: fortify ovl_copy_xattr() against underlying layer modifications
      ovl: add assertions in dir cache code
      vfs: add try_take_dentry_name_snapshot()
      ovl: skip copy up of empty security.capability
      selftests/ovl: fix detached layer mountinfo expectations
      ovl: fix mount setup failing when override_creds drops CAP_SYS_ADMIN

Chris Mason (13):
      ovl: do not copy up an xattr value that was never read
      ovl: set OVL_WHITEOUTS before publishing the upper dir
      ovl: check that the parents of volatile/dirty are dirs
      ovl: take a snapshot of the name for copy up
      ovl: do not take a name snapshot in RCU walk
      ovl: use the pinned upper dir in ovl_fix_origin()
      ovl: hold a reference on the parent in readdir
      ovl: do not copy up a dentry that was removed
      ovl: fix a torn path in ovl_get_redirect()
      ovl: read the nlink xattr of every indexed non-dir
      ovl: always encode the origin fh when index is enabled
      ovl: set the revalidate flags after d_instantiate()
      ovl: check the casefold flag of directories only

Hungyu Lin (1):
      ovl: reserve space for the casefolded name terminator

 fs/dcache.c                                        |  29 +++++-
 fs/overlayfs/copy_up.c                             | 110 +++++++++++++--------
 fs/overlayfs/dir.c                                 |  22 ++++-
 fs/overlayfs/inode.c                               |  16 ++-
 fs/overlayfs/namei.c                               |  11 ++-
 fs/overlayfs/overlayfs.h                           |   8 +-
 fs/overlayfs/readdir.c                             |  65 +++++++++---
 fs/overlayfs/super.c                               |  39 ++++++--
 include/linux/dcache.h                             |   1 +
 .../filesystems/overlayfs/set_layers_via_fds.c     |  18 ++--
 10 files changed, 233 insertions(+), 86 deletions(-)
