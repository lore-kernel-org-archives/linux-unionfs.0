Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C0425CC54
	for <linux-unionfs@vger.kernel.org>; Tue, 20 May 2025 05:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747718181; cv=none; b=KfUNOx4rgL82ClbgG4KTtfEO7swJG6eMkC+NzWw+rVaVcNOst3dYKTyDOYMV7UNeHs5FBCwqvQhC2pH2//bAWJAfcn4Hb9zDZJl1v5r86leea6SDtCsS2yikfUPn+/s8wB3AIR0rcYLVpBbJDCopnwMNkKFkJpCTppE8exMi+ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747718181; c=relaxed/simple;
	bh=pOeLJYgVVwY6Qw6KFmNhBVQUpZ19g+EsZnha/9udttY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vvf66FmaZvS/zet2UCC73FQcWz32zg6zQPVXnYjWn0QhTXkaw43I0B9gyvCegoTXMQoYbHuQuFML/wX5x0p/nwfR/p1cVWHtyaxBz2nS8hegfW/ywJnrEpwvHQtfOf67N4ZdcW1HW55XFJP9AHpoSwKljplC4nUW2O4mXfw6v18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=l+7XOLPd; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="l+7XOLPd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747718167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7Dgf3nS6gL7uN94ZVb9SokCJOHrb/S37y754RGVpO+Q=;
	b=l+7XOLPdWR54LJe45UA1vxDQgnJwwtduhI5d2JfuQatCJWWxI9ncGrov+OXBckkNgyt6RZ
	lwiuVsPrrOuMVtb7jQOP2JywmqgYpNYOi2ELRVqukio1ezSn9IW6Ckpv+lbtibXwO8wpU7
	/sAFoNU+1G2MOQxh1AzuaYjfgOx4rqY=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-fsdevel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 0/6] overlayfs + casefolding
Date: Tue, 20 May 2025 01:15:52 -0400
Message-ID: <20250520051600.1903319-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This series allows overlayfs and casefolding to safely be used on the
same filesystem by providing exclusion to ensure that overlayfs never
has to deal with casefolded directories.

Currently, overlayfs can't be used _at all_ if a filesystem even
supports casefolding, which is really nasty for users.

Components:

- filesystem has to track, for each directory, "does any _descendent_
  have casefolding enabled"

- new inode flag to pass this to VFS layer

- new dcache methods for providing refs for overlayfs, and filesystem
  methods for safely clearing this flag

- new superblock flag for indicating to overlayfs & dcache "filesystem
  supports casefolding, it's safe to use provided new dcache methods are
  used"

Kent Overstreet (6):
  bcachefs: BCH_INODE_has_case_insensitive
  darray: lift from bcachefs
  fs: SB_CASEFOLD
  fs: dcache locking for exlusion between overlayfs, casefolding
  bcachefs: Hook up d_casefold_enable()
  overlayfs: Support casefolded filesystems

 MAINTAINERS                             |   7 +
 fs/bcachefs/Makefile                    |   1 -
 fs/bcachefs/bcachefs_format.h           |   3 +-
 fs/bcachefs/btree_node_scan_types.h     |   2 +-
 fs/bcachefs/btree_types.h               |   2 +-
 fs/bcachefs/btree_update.c              |   1 +
 fs/bcachefs/btree_write_buffer_types.h  |   2 +-
 fs/bcachefs/disk_accounting_types.h     |   2 +-
 fs/bcachefs/fs.c                        |  45 +++++-
 fs/bcachefs/fsck.c                      |  12 +-
 fs/bcachefs/inode.c                     |   8 +-
 fs/bcachefs/inode.h                     |   2 +-
 fs/bcachefs/inode_format.h              |   7 +-
 fs/bcachefs/journal_io.h                |   2 +-
 fs/bcachefs/journal_sb.c                |   2 +-
 fs/bcachefs/namei.c                     | 166 +++++++++++++++++++++-
 fs/bcachefs/namei.h                     |   5 +
 fs/bcachefs/rcu_pending.c               |   3 +-
 fs/bcachefs/sb-downgrade.c              |   9 +-
 fs/bcachefs/sb-errors_format.h          |   4 +-
 fs/bcachefs/sb-errors_types.h           |   2 +-
 fs/bcachefs/sb-members.h                |   3 +-
 fs/bcachefs/snapshot_types.h            |   3 +-
 fs/bcachefs/subvolume.h                 |   1 -
 fs/bcachefs/thread_with_file_types.h    |   2 +-
 fs/bcachefs/util.h                      |  28 +---
 fs/dcache.c                             | 177 ++++++++++++++++++++++++
 fs/libfs.c                              |   1 +
 fs/overlayfs/params.c                   |  20 ++-
 fs/overlayfs/util.c                     |  19 ++-
 {fs/bcachefs => include/linux}/darray.h |  70 +++++-----
 include/linux/darray_types.h            |  33 +++++
 include/linux/dcache.h                  |  10 ++
 include/linux/fs.h                      |   4 +
 lib/Makefile                            |   2 +-
 {fs/bcachefs => lib}/darray.c           |   9 +-
 36 files changed, 571 insertions(+), 98 deletions(-)
 rename {fs/bcachefs => include/linux}/darray.h (64%)
 create mode 100644 include/linux/darray_types.h
 rename {fs/bcachefs => lib}/darray.c (75%)

-- 
2.49.0

