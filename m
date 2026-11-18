Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021417;
	b=2ZPUM689/e4aI5D4I3Jg7FPfbKpxpA2YVPY0H2nfQNjGoUazcCL4d7Q8Ilv9vQS0tmxP
	 mXUWm8uIxrFrS7mNbZTJ5pM3ftSptXNNu3LBwgaWTUTTHaLfGRNbnkKlCSp68cerIynXf
	 T7iX4JYad+v1V4MnXdPfY0tNqS4t2/hGBc84KFJH9HLJ10i0uwRe0OB2uPFxSCJfTiooE
	 LerSY0g15wSp0MkF+sFuJ7edmkelOLe8H5nzM4loBPwE/29Yvcxb5Hc/DcfLBdd5PE6mi
	 lKzhsi2xkgmSMcdngwo1Ia/jtoLjx5GzFz6ZkZNJ9z20BAzO3x9iqxhk5cUqLGRtxJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021417;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=SSQFHMISIGO/3SWpEk6UNGVZ8ogxvUftpj/vES1hvx8=;
	b=PxBddNWc8YJ5Ma7SO0wXNU/2FM0qoO9I8M05QVVFGJJ3yJfV1AREr4ytql886i/ZRTUt
	 l4RSy/7159fd5Yytb5UuUtlj+b1tQ+Vh7XLzpzXbykMzego07PqeX6QcruP7bLCaa/9E6
	 706+P3KspNq9SWIOVicJIOwsut3maTtXG+8FEUnc2PWqH4D/xaWfy47K6wiU0ftRRwR/J
	 snSS5g1LE133J+Dzty05F1nlBrXrB5aqwrOlm7GVzMq/iTdBr6Z8uo1874eFhFPXk5C8e
	 sZS2ZcXqUdzyK9YqW17MxmZuKVA0p0CVzfxeus7mE+vajmkjXbJ+g1GHuKVtH1ei07g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=rRS++o0T;
	arc=none smtp.remote-ip=209.85.160.182
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EE0606A320
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 17:03:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68EE0606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=rRS++o0T
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-55c304f7031so159301cf.1
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 09:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1795021415; x=1795626215; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=SSQFHMISIGO/3SWpEk6UNGVZ8ogxvUftpj/vES1hvx8=;
        b=rRS++o0TK/lf1FAcyI59pI0yb4ZamvxE8/9rxTr/FCdG41Q3yH7AcnOeFrlzwckeR/
         HhhgbK+VFylycWJYv+/G1dBsTJEzIGaqdhaiemLQvdOsJYZVi6jPF4qXFiftj6X3Llj0
         VeDivKt2uoFE9KJ3AVoBNPHfcdDtHU6FySmZap+9GoqRrVhojQM95rX2MWBoSPcUz38s
         lplxUEJXoUs360Ck5LLQmccs/q5AhEN44PPE6xDmNON7TDlKVwXCzQAirzuWlZR5V1kh
         rzNhIr6EKyqHIAI9NedVPdenRZW4gI3uUENk9zh3pFVjsYUtWt4ONJLMEZtScHRJwoWS
         +y/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795021415; x=1795626215;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SSQFHMISIGO/3SWpEk6UNGVZ8ogxvUftpj/vES1hvx8=;
        b=Ralr7yKLIcZR++z482AEDVIJgbDiB+FdCU2tlL59e5x4ukwnrcG5bEic+iADUSnzsU
         RUz2DNSBPFr/ea+AMDF7KaRRKnOTmN35EtJrRI+iyXKC4n/63Vh2Z4xPsuA5g8XK4Mtt
         V1eUaICjJxkFIwM7iRjBPg3LzG4gzhC+IDzRzgOZG2geuNsvcOtsnOVvs7ZOwh/jGU6Z
         n3hL+87lxy0jyO3BmmeqSCNZlhB7tPKApcZt76SN+IOGu6oQmXSHPLSBHOR6rIhnYaGk
         xDA25jsj2Jadivh1GX0MWdu9za6TqHQJhkiwNUH3o0cBB7DkCyO+U1GlDF2OTEOImKTx
         RIUw==
X-Forwarded-Encrypted: i=1; AL+hErF1SN/llIX6sqDqOJgISRdd3WLCJqLO2y53EXUpJO76O/JcipoJF2cgpZLP8mhY9DKwJZSXdpKvfw5MyE9q@vger.kernel.org
X-Gm-Message-State: APuU4Z85f9iHo+++RGV3DCGJ0qekA65alY7AykICFPQuKAwvBGseumlQ
	DY+m7IVGGt5BQwQT+wx3h/1OSiOoh3ss1ds8AHlN6uje1V8Vfrb+nETbA5mF+BkG+o8=
X-Gm-Gg: AYBFou3C+f9YuJn+xXwmWkc2GNYoFVMNfnAUbjf1eQ08qFOJUiapbjk46DO+BxuNHrO
	LPCX+/HLCdQ3I58eE1OJpr+H1Blv8X2YK2/bvRhqlqm1Kbi3PrD8akuq8zZCWHWJ11ASQi3Pt2M
	vjOw3pDkilGg0PTZ0upEReTrIzD7Rm+zLivw1W/BKXKgqYyzYJbGSS1HKr3oyxsabhN1Z+5YHZw
	FY46EEAyarj9vXu7jylfHitHtvKJhc/qjRM/KKYt6+IoTE7cenBYB4SHm96KfsHYE0rNwKobc7q
	Xsfot4cw+klVw8MitMECVk9YWvEQA8hZp9cuZA4V9hf5sohGBjRPTwQfID82CnmYjOl0rwEcBmU
	zDDkA7eqMJKmjsF5FEd6niSp60Rtz0p8SbUvUCzLoNFgSTMOx26LlVheup3IGVIPF9LyHYC4eUS
	pcpCQi+C50HcPyz7teIAQSl0ITl4YImoGU8wlAd5OcO1YA+zuvy1UisHM9Vxn60nVHsO0ISwWA+
	+x2QWsBpNlboWAhgu8zdwnhf0TQJ8NSMBkzdJMBCor5NY9ZlntqcWL/xR2L2jdYeouhVdp0gdKJ
	vM+ZS2gVqs4UWwbFBbX1+br7Lbr97l7Ko1RS7FJPSaC/W3H76YzhFJ2IAZ+uOFGuEsA=
X-Received: by 2002:a05:622a:53c4:b0:537:548b:77ed with SMTP id d75a77b69052e-55d686288damr1091231cf.30.1795021414987;
        Wed, 18 Nov 2026 09:03:34 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.240])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d66c4fcd1sm3886851cf.28.2026.11.18.09.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 09:03:34 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH v7 0/7] ovl: only sync what was written through the overlay
Date: Wed, 18 Nov 2026 17:03:23 +0000
Message-Id: <20261118-b4-ovl-containerized-sync-v7-0-54f45743fe55@toxicpanda.com>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFza/WoC/33RzU7DMAwH8FeZciaQr6YrJ94DcXBilwZBMjWl2
 pj67iRDiEpUPeTgyP7pL/vKMo2BMns8XNlIc8ghxVK0dwfmB4ivxAOWmimhrCyPO8PT/M59ihO
 EWIa/CHm+RM+l6RyhhJ46YGX+NFIfzjf7+eWnzp/ujfxUwdrhIBN3I0Q/1K9aPmzjtXsIeUrj5
 RZ1llX9TdXupJolF/woFDVS6bYD+zSlc/AniAj3Pn2wGm1Wa67b41ThDHW9OJIB0ahNTv9xUpg
 9Ttd0CKCENKZv9CZn1tzeCWZTOIuIJFyLeIRNrllzu7trCofaOAPUtD32m5xdcVLscbbuTqN0J
 C0Y/H+KZVm+AbmkHk6SAgAA
X-Change-ID: 20261026-b4-ovl-containerized-sync-149bed1afe9a
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>, Chengguang Xu <charliecgxu@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1795021413; l=20663;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=pJA8slna7Bjj6rvsFLGg+gtFthk85ovDv8DftGkLVoM=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QDQHetDxRPK4fLOG2hXeQNiUrRO/Rg6UjO9zUf1L/ONROYjBOm3ltNgaossmvV+fAdosm1t9oUQ
 0hHnLyAxsLgs=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

v1: https://lore.kernel.org/all/20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com/
v2: https://lore.kernel.org/all/20261029-b4-ovl-containerized-sync-v2-0-4e9f08e4a052@toxicpanda.com/
v3: https://lore.kernel.org/all/20261104-b4-ovl-containerized-sync-v3-0-8daa20144f53@toxicpanda.com/
v4: https://lore.kernel.org/all/20261106-b4-ovl-containerized-sync-v4-0-6ddde0b7dd8a@toxicpanda.com/
v5: https://lore.kernel.org/all/20261107-b4-ovl-containerized-sync-v5-0-d34b4ae57fdf@toxicpanda.com/
v6: https://lore.kernel.org/all/20261110-b4-ovl-containerized-sync-v6-0-43d1be16a4d6@toxicpanda.com/

I've completely redesigned this, because there were so many problems
that I kept tripping over trying to maintain state between the upper and
the lower inode. I'm not in love with this design either, but it's the
simplest. I'm hoping somebody spots something obvious and we can do it a
different way.

v6->v7:
- Redone without a flusher. An overlay inode has nothing of its own.
  What is dirty, under writeback or deferred by lazytime is the state of
  the upper inode, and nothing tells overlayfs when that changes. Up to
  v6 the dirty bit of the overlay inode mirrored that state on a bdi of
  the overlay, and most of what the reviews found was the mirror being
  off, or the flusher acting on it. The worst one: with 3000 files open
  for writing and the system over the background threshold the flusher
  of the overlay took 79% of a CPU going over its list. (Sashiko)
- Now the overlay only keeps a set of the inodes that were modified, an
  xarray, patch 5. Only syncfs(), unmount and a read-only remount walk
  it, and they ask the upper inode of each. Periodic and background
  writeback is all up to the upper file system, like without the series.
- The xarray has the marks of the page cache and a sync uses them the
  same way. ->sync_fs() without wait tags what is dirty with towrite,
  starts writeback of those and marks them writeback, with wait it waits
  for what is marked writeback. The one difference is that there is no
  completion to clear the writeback mark. Whoever has waited does, and
  only if the upper inode is clean, another sync may have started it
  again.
- The set holds a reference. An inode leaves it when it's unlinked, or
  when a sync or the shrinker sees the upper inode clean. The shrinker
  part hangs off the ->nr_cached_objects() and ->free_cached_objects()
  hooks. Nobody who walks the set needs a lock against anybody else.
- Gone: the bdi, ->write_inode(), ->drop_inode(), the lazytime patch,
  "ovl: report failed upper writeback in syncfs()", and the special
  cases for the root and for unhashed inodes. 7 patches, v6 had 8.
- syncfs() waits for the writeback of its own inodes, whoever started
  it, and for nobody else's.
- New patch 4: write_inode_for_sync() in fs/fs-writeback.c writes one
  inode the way the flusher does for sync_inodes_sb(), WB_SYNC_ALL with
  for_sync. Up to v6 I pieced that together from sync_inode_metadata()
  without and with wait, so that ext4 wouldn't commit for every inode.
  (Sashiko)
- Deferred timestamps are handed to the upper file system in a sync, or
  when memory is needed, so lazytime keeps working in between.
- syncfs() also reports writeback that the upper file system did earlier
  and that failed. The overlay inode remembers where wb_err of the upper
  mapping was when it entered the set, and a sync compares. An fsync()
  in between doesn't take that away.
- A freeze and a read-only remount of the upper file system are held off
  while an inode is handed over. If one has already begun syncfs() syncs
  the whole upper file system like before. That closes what v6 only
  described in the changelog of patch 7. (Sashiko)
- New patch 2: an upper file system with SB_I_NO_DATA_INTEGRITY, which
  is fuse, doesn't get relaxed. A sync doesn't wait for the fuse server,
  writing the upper inodes one by one does. (Sashiko)
- The helpers that set the impure, redirect, opaque and nlink xattrs
  track the inode themselves, and so does ovl_clear_empty(). A link or a
  rename that failed after them left the inode untracked. A setattr that
  fails tracks it too. (Sashiko)
- Rebased onto 7.4-rc1. v6 was still on the base of the earlier
  versions, and patch 4 conflicted with 4f61ff2ebfb3 ("ovl: use the
  pinned upper dir in ovl_fix_origin()").

v5->v6:
- Lookup marks a merge directory and its parent when it sets the origin
  and impure xattrs on them. (Sashiko)
- New patch 8: if somebody else writes the pages of an upper inode and
  that fails, syncfs() on the overlay reports it. It's best effort, the
  limits are in the changelog, and it's on its own so it can be dropped.
  (Sashiko)
- Left alone: if the deferred timestamps can't be handed over because
  the upper file system is being frozen, the sync of the freeze can miss
  them. They are written after the thaw, it's in the changelog of patch
  7. (Sashiko)

v4->v5:
- Added sync_fs_and_bdev() to fs/sync.c for the ->sync_fs() and block
  device part of sync_filesystem(), so ovl_sync_fs() doesn't open code
  it, patch 2. (Christian)
- ovl_instantiate() marks a new inode and a new hard link dirty.
  (Christian, Sashiko)
- Copy up marks the parent as well, and the inode also when it only adds
  a link to an indexed upper inode. (Sashiko)
- Dropped "ovl: make the root inode appear hashed". A fake hash stays in
  the slab object when the inode is freed, and the next overlay inode in
  it looks hashed. The root isn't tracked at all now, ovl_sync_fs()
  writes its upper inode every time. (Sashiko)
- lazytime got a lot simpler. The overlay inode doesn't get I_DIRTY_TIME
  any more, deferred timestamps are handed to the upper file system when
  ->write_inode() finds them. That takes care of the I/O from dentry
  reclaim, so this doesn't need anything from Jan's deferred inode
  reclaim series. (Sashiko, Christian)
- ovl_sync_upper_inode() could lose an error.
- Left alone: fsync=auto still goes by RENAME_WHITEOUT, no flag. What
  that leaves uncovered is under "Things I know about". (Christian)
- Left alone: if somebody else starts the writeback of an upper inode
  and it fails, syncfs() on the overlay doesn't report it. It never has.
  (Sashiko)

v3->v4:
- Patch 1 is v2 of Amir's patch. It has ovl_tracks_dirty() and picks the
  mode for tmpfs at mount time, so I dropped my version from patch 2.
  fsync=auto stays auto if it doesn't become relaxed. (Amir)

v2->v3:
- Patch 1 is Amir's, it adds fsync=relaxed. Only an overlay with that
  syncs just what was written through it, everybody else syncs the whole
  upper file system as before. fsync=auto, the default, picks relaxed if
  the upper file system supports RENAME_WHITEOUT. (Amir)
- Dropped the fake inodes and the calls in the ovl_do_*() helpers,
  patches 7 to 9 of v2. Upper inodes without an overlay inode are left
  to ->sync_fs() and the block device, like in v1. (Amir)

v1->v2:
- Dropped the superblock flag and the ext4, xfs and btrfs patches. This
  is all in overlayfs now and works the same on any upper file system.
  (Christoph, Amir)
- Upper inodes without an overlay inode get a fake one that goes on the
  dirty list, patches 7 to 9.
- The periodic flusher pass doesn't write the upper inode any more, and
  syncfs() doesn't make ext4 commit per inode.
- Record write errors in s_wb_err of the overlay.
- Make the root inode appear hashed so it can be on the dirty list,
  don't mark unhashed inodes dirty, read i_writecount with acquire.
  (Sashiko)
- Left alone: dirtied_time_when isn't set for an overlay inode that gets
  I_DIRTY_TIME from ->write_inode(). It only matters for the 12 hour
  expiry, where the upper file system writes the timestamps on its own.
  (Sashiko)
- Rewrote my commit messages. (Christoph)

What it does now:

sync_filesystem() writes every inode on a dirty list, calls ->sync_fs()
and writes the block device. Only the first step is expensive, because
of other people's data. With fsync=relaxed overlayfs does that step only
for the upper inodes of the overlay inodes in its set, ->sync_fs()
without wait starts them and with wait waits for them, and does the
other two steps as they are.

Whiteouts and the work directories have no overlay inode, so nobody
writes those inodes. That's fine if ->sync_fs() or the block device gets
all metadata to disk, which is what relaxed asks of the upper file
system.

Things I know about:

 - ext4 without a journal supports RENAME_WHITEOUT, so it gets relaxed.
   It's fine there, its metadata is in the buffers of the block device,
   which we write. I tested it like the others.
 - f2fs and ubifs get relaxed as well and I didn't test them. f2fs
   writes its dirty inodes in the checkpoint. ubifs_sync_fs() doesn't,
   but the only thing overlayfs leaves dirty there on an inode it
   doesn't track is the chmod of the work directory to 0 at mount time,
   right after creating it with mode 0. fsync=on is there for anybody
   who needs more.
 - A default mount that gets relaxed shows that in /proc/mounts.
 - A tracked overlay inode, its upper inode and the dentry of that can't
   be reclaimed while the upper inode is dirty, like a dirty inode of
   any file system. After that they stay until a sync or the shrinker
   looks. The shrinker only queues a work item that does the looking.
   The reference it drops can be the last one to an unlinked upper
   inode, and file systems allocate memory under locks that deleting a
   file needs. Deferred timestamps count as dirty, the work item hands
   them to the upper file system.
 - When a sync reports an error it marks it as seen in wb_err of the
   upper mapping, like an fsync() does. A file that is opened on the
   upper inode after that doesn't get it any more.
 - syncfs() looks at every inode in the set, also at those that the
   upper file system has written by now.
 - A file that is open for writing stays in the set, it may be mapped.
   That doesn't cover pages pinned through a mapping. A direct read into
   one that completes after the last munmap() and close() dirties them
   when the inode may have left the set.
 - An atime update puts the inode into the set as well.
 - A read-only remount of the overlay syncs it, so it now fails once
   with the error of writeback that has failed earlier.
 - The error reporting has gaps, in all of them syncfs() returns 0 like
   it does today. With the upper file system frozen or read-only we
   fall back to syncing all of it and don't look at the inodes, so an
   error is reported by the next syncfs() that can. btrfs records an
   error after it has ended writeback, which can be after we looked.
 - Data that an earlier mount of the same upper directory left dirty,
   with fsync=off for example, isn't written by a syncfs() of a later
   mount. Today it is, along with everything else.
 - Every inode of a relaxed overlay gets a slot in the xarray when it's
   allocated, also those that are never modified, so that tracking one
   can't fail. The index is the address of the inode. i_ino isn't unique
   in an overlay and xa_alloc() needs one of the three marks. All
   overlays allocate from one slab cache, so where their inodes are
   mixed a slot can cost a node of the xarray or more. With 64 overlays
   of 2000 files, same debug kernel as below, it's 21 bytes an inode if
   they're walked one after the other, 89 if all at once, 489 if they
   take turns entry by entry. Plus about 6K for every overlay.
 - If the origin of a copied up file can't be decoded, like in a user
   namespace, a later lookup makes a second overlay inode for the same
   upper inode. If the first one is tracked it pins the upper inode
   after that was unlinked, until a sync or the shrinker looks.

Tested like before, see the v1 mail below, now also with ext2 and ext4
without a journal as the upper file system. New tests for memory
pressure, a frozen and a read-only upper file system, O_TMPFILE, write
errors, and syncfs() next to tasks that create files and next to other
syncfs() calls. Everything that was changed through the overlay is in
the copy of the block device and the 192M of the neighbours aren't,
except with ext2, which doesn't get the new mode by default.

To see that the tests can fail I broke the series in 12 places, a line
or two each, and all of them are caught.

With KASAN and lockdep on, ext4, xfs, btrfs and ext4 without a journal,
one sample each, without and with the series:

  syncfs(), the neighbours' 192M dirty         258-305ms    44-50ms
  unmount, the same                            147-273ms    37-43ms
  syncfs(), the 192M under writeback [4]         42-58ms  138-171ms
  syncfs(), 4000 inodes in the set, dirty       52-153ms   71-207ms
  syncfs(), 10000 inodes in the set, clean       55-57ms  144-146ms

So it isn't free. Walking a tree takes 0 to 3% more system time, which
is what it varies by without the series.

fstests with -overlay, the auto groups of generic and overlay, on ext4
and on xfs: nothing that passes without the series fails with it, and
the run time is within 0.3%.

[2] https://lore.kernel.org/r/20261027-b4-ext2-dirsync-v1-1-3dcd012d518d@toxicpanda.com
[3] https://lore.kernel.org/r/99629e3277656888cbe84bf7490c5e54.josef@toxicpanda.com
[4] Not btrfs, nothing was in flight there without the series.

--- Original email (v1) ---

Hello,

This picks up Chengguang Xu's "implement containerized syncfs for
overlayfs", last posted as RFC V6 in November 2021 [1].

syncfs() on an overlay and unmounting one call sync_filesystem() on the
upper file system, so they write every dirty inode on it no matter who
dirtied it. We run a lot of containers on one upper file system, and
stopping one of them writes out the dirty data of all the others. That
can take a very long time, and s_umount of the upper file system is held
the whole time, so anything that wants it exclusively queues up and then
everybody else queues up behind that.

With this an overlay only writes the upper inodes that were changed
through it, and then has the upper file system commit its metadata.

The V6 discussion ended with a direction but no V7, so that's what I
tried to follow:

 - V6 kept every overlay inode with an upper inode dirty for good. Jan
   and Amir didn't like the cost of walking them. Now an overlay inode
   is marked dirty when the upper inode is changed, mostly from
   ovl_copyattr() as Amir and Miklos suggested.
 - It never looks at the dirty flags of the upper inode, Miklos pointed
   out that they're cleared when writeback starts.
 - ->write_inode() goes through write_inode_now() on the upper inode,
   and keeps the overlay inode dirty while the upper inode is open for
   writing, which covers shared mappings.
 - V6 marked the inodes DONTCACHE, which Jan was worried about. This
   goes back to the v5 patch that keeps dirty overlay inodes cached.

One thing is new. V6 called wait_sb_inodes() on the upper file system to
catch writeback that was started but not finished, which waits for
everybody's writeback. Instead ->write_inode() keeps the overlay inode
dirty while the upper inode has pages tagged dirty or under writeback.
The tags don't have the problem the inode flags have, the writeback tag
is set before the dirty tag is cleared. So a clean overlay inode means
its data is on disk, and syncfs() only waits for its own inodes.

That takes care of the data. Metadata is harder, a lot of what is
changed on the upper file system has no overlay inode that could be on
the dirty list: the root of the overlay isn't hashed, and whiteouts,
index entries, the work directories and their parent have none. File
systems that log their metadata don't care, ->sync_fs() commits it. ext2
does, there a whiteout was gone after a crash. I first had overlayfs
write all of those itself and kept finding more of them, the last one
was the link count of the shared whiteout when a whiteout is removed.

So patch 1 adds a superblock flag, SB_I_OVL_USE_SYNC_FS, by which a file
system says that ->sync_fs() commits all of its metadata, and patches 2
to 4 set it for ext4 with a journal, xfs and btrfs. Without the flag on
the upper file system nothing changes, no inode is marked dirty and
syncfs() and unmount call sync_filesystem() like they always did.

Patches 5, 7, 8 and 10 are Chengguang's with changes noted in them,
patches 6 and 9 are new. I dropped Jan's Reviewed-by tags from V6 since
the patches changed.

lazytime on the upper file system needs its own handling. The flusher
leaves the timestamps in memory for up to 12 hours, so the overlay inode
can't be clean, but it can't stay dirty and pinned for that long either.
Patch 9 gives it I_DIRTY_TIME like the upper inode has, and forwards
->sync_lazytime() to the upper inode.

Things I know about:

 - An overlay inode that loses its last reference while it is dirty is
   kept until it has been written and then sits on the LRU, like with
   any other file system. Clean and unlinked ones are still freed right
   away.
 - Every overlay on such an upper file system gets a bdi.
 - I haven't measured syncfs() with a very large number of dirty inodes.

For testing I put several overlays on one upper file system and dirty
192M next to the overlay under test, through another overlay and
directly. Then syncfs() or unmount the one overlay, copy the block
device as it is at that moment, mount the copy, and check that
everything that was changed through the overlay is in it and that the
192M aren't. That passes with ext4, xfs and btrfs as the upper file
system. With KASAN and lockdep on, syncfs() goes from 239-284ms to
45-48ms and unmount from 126-234ms to 39-44ms. With ext2 and ext4
without a journal the 192M are written as before.

fstests with -overlay, the auto groups of generic and overlay, gives the
same results with and without the series on ext4 and on xfs.

[1] https://lore.kernel.org/r/20211122030038.1938875-1-cgxu519@mykernel.net

Thanks,

Josef

---
Changes in v7:
- Link to v6: https://patch.msgid.link/20261110-b4-ovl-containerized-sync-v6-0-43d1be16a4d6@toxicpanda.com

Changes in v6:
- Link to v5: https://patch.msgid.link/20261107-b4-ovl-containerized-sync-v5-0-d34b4ae57fdf@toxicpanda.com

Changes in v5:
- Link to v4: https://patch.msgid.link/20261106-b4-ovl-containerized-sync-v4-0-6ddde0b7dd8a@toxicpanda.com

Changes in v4:
- Link to v3: https://patch.msgid.link/20261104-b4-ovl-containerized-sync-v3-0-8daa20144f53@toxicpanda.com

Changes in v3:
- Link to v2: https://patch.msgid.link/20261029-b4-ovl-containerized-sync-v2-0-4e9f08e4a052@toxicpanda.com

Changes in v2:
- Link to v1: https://patch.msgid.link/20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com

---
Amir Goldstein (1):
      ovl: expand fsync mount options

Chengguang Xu (1):
      ovl: implement containerized syncfs for overlayfs

Josef Bacik (5):
      ovl: no fsync=relaxed without data integrity
      fs: add sync_fs_and_bdev()
      fs: add write_inode_for_sync()
      ovl: add a set of the inodes that a sync has to write
      ovl: track an inode when it is modified

 Documentation/filesystems/overlayfs.rst |  45 ++-
 fs/fs-writeback.c                       |  36 ++
 fs/overlayfs/Kconfig                    |  21 ++
 fs/overlayfs/Makefile                   |   2 +-
 fs/overlayfs/copy_up.c                  |   9 +
 fs/overlayfs/dir.c                      |  11 +
 fs/overlayfs/file.c                     |   7 +-
 fs/overlayfs/inode.c                    |  27 +-
 fs/overlayfs/namei.c                    |   9 +-
 fs/overlayfs/overlayfs.h                |  39 ++-
 fs/overlayfs/ovl_entry.h                |   9 +
 fs/overlayfs/params.c                   |  34 +-
 fs/overlayfs/params.h                   |   2 +
 fs/overlayfs/readdir.c                  |   1 +
 fs/overlayfs/super.c                    |  58 +++-
 fs/overlayfs/sync.c                     | 591 ++++++++++++++++++++++++++++++++
 fs/overlayfs/util.c                     |  16 +-
 fs/sync.c                               |  52 ++-
 include/linux/fs.h                      |   1 +
 include/linux/pagemap.h                 |   1 +
 20 files changed, 920 insertions(+), 51 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261026-b4-ovl-containerized-sync-149bed1afe9a

