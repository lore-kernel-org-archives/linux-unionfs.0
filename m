Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794079188;
	b=pq8R/6sQiUvtpT9Ua75lB3c9d47VvOTTwUanMT9DZwU40Dgn+OgrKX0eGPacnq00b5os
	 BhS3O2wiwW7t6aDiLWvAyRNXjmrulYtS3GMqWjiQS1kkKixll++TdZPAo2veQlyWr0BbH
	 QKTt1zTgQx9/UZbDLtExAHJ++AL90UteYmh3B8bVSRap1h2ieKHaRvLiJ8UqGfintzJXX
	 DGbU62LleZwRjetpl4T9Ihz6OG68h/k5HIH1n3x2AcJoDVxbfLgbiiH9HIn9InAid85yD
	 TbsodlptYvRy48Rb4maW/2AyXC9IdGbpaiWptSsjZALixs2aEZhTljYN4GTi6ZWA+Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794079188;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=BODJIFdAxaQfJhmDdlEpZw+uSlRZj/7oX97q9ks1XqA=;
	b=J2AMfFIj9U4br8Wvv4mhrgzY7f8utQLEkCugzRa0e+8SL2to3IKSzsVtRnG24zi8H8nU
	 vP2cR+S2xNpMrHrkLWySjS2xl7MNzm+BXfufAFkmbPO04dloblp/LxwVbWGXZ/jTrQf/2
	 /+g1GDGEmYTQWiNQh8P2KirT2omHIfagfVCCupUKuJfJ9vpXKHobJFA/qY3/dzJ6HN3yO
	 uJ3NoxpVlClJ44TglvngfFZbobq9sUOVlIwKhhokpd3hqETWR/fGviNeKOd1FruBlg2Q5
	 DUxXiV/6/sjWnnwHe9tgDQUWJc7ILUCIH1UDtVoFMHIDqGn+P+1gXew4/yYaDLhNVjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=bYNVk94b;
	arc=none smtp.remote-ip=209.85.222.181
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBBD606A326
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 19:19:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADBBD606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=bYNVk94b
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93a40a9a01aso94967285a.0
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Nov 2026 11:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1794079186; x=1794683986; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=BODJIFdAxaQfJhmDdlEpZw+uSlRZj/7oX97q9ks1XqA=;
        b=bYNVk94bNUWwRM69950P4fYbG0JoHGRR9AwaCQy4nBbSgmZwRgrOfrxQpTI+VeBmct
         ZkcygVYsMFge5yPw/mZcN7fRSxOPfGQhVgnI0/VGgarD8dgGYk/oJIUugu5USMLw3gN2
         4lauFkjDgy1W4l2+Ro5OXgoo7ODGEvz00V0qNWw6cDcRyP7UVbX8CzMuEgRJygv6Vtnd
         ns7SaFslRkp4UjX+LAlmdkhG6oAI9FcBApYBPTYsFvP8BmBrZkZf5TiHATwMasHDto4c
         ysT81/zX/XDAgQLWVNlCR/Oo5SopLVEFzQ1m1/yVgT+OMbZx4oIXA71g4SV1igMaVJCI
         XvCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794079186; x=1794683986;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BODJIFdAxaQfJhmDdlEpZw+uSlRZj/7oX97q9ks1XqA=;
        b=r2I+5PRWRMNmyjtwmxrjGc8aG3cMQ1tUcEix6vNCmqvJziZ29+4EuGdJJxPI6dZCgY
         minoEkb4CSmmG1FUizZl9nhChADi81GJ1kScRVjS8WIr8lnikKTRtT90CHYVVPsqwkp0
         fFP++DbfEw81tbDMaApdSgVQ5pDMsn0ua4AFFspqMNBIkpssdCCx6bwF2chP+rm0E2Ly
         ltS72Cj+pvp484N3k5V3tIRS4+QjkXuiyjtz4o8Ph7Ftwi7oSTefGRpxV5kD+t9kSYS6
         0gYjuJZw8CeDLDB0AfPA94NUCxrY/sY86I0eD9l9C0xwnuUY1R2IlPbHCcQ1CG8WlBR9
         38AQ==
X-Forwarded-Encrypted: i=1; AKwUvBzwUFlLysSKaMhe8TEzg7H2Ao8eoGm0Jqq/qArkkm6UDq1QHFGVrV0BVxrUQijgxAPSKC6hVp/ceExIikbS@vger.kernel.org
X-Gm-Message-State: APuU4Z8CayTVRpGCWIMY1w+uDFek9KxeJiocUjW7iJFX3x3AAwLB4+Nb
	C1WkId28REIj8sumRpwLVp2tJ/CpX6F/YqvOJNg+2x6ORptOtpH1S92Ip9qP0fyzFgU=
X-Gm-Gg: AYBFou0325n2hFHZqyJu4h9hTioAiqk/uEnK3Hsyp0BLUpIZLqIpvjtUsBEvUiH6eTC
	7WmZQAhpr+h1vTIAzOVjxJfsp8VGI4HMpXsuluAdcoMe3INMilVkaut3KpW3dSEze4shCKw3DvD
	AZEM6zHU3bASZpRs2rLF+JTHkoG45jXzCOxFTuWS3d7YEPJ3wW35tb+tStDvObhleOt411/GMqh
	LWOWUtjuo3yStmcK1kvQ7oumCgZN9UGggaskK1UGh3xTivhOz+0GHnjkkDf6rcIri705GLUS5fA
	5Jcq6RUsPBqaUtk/uFnqu3DwntLl+ViNsBxO2fJ97G30fiMFYhMFmMhdOaLc9fvpl37CFVxyr51
	cogDESWxQQK1BD5mJXEQt+dILVf716JGBOV5KO7syISNYUi10aSzdGdnwww07/s4Bcg05U2JMOw
	MRP7ZrrFp9cK9+hBU9HYoUxfFETAkExeT0Ct6xuSvGAmlZt1Sfe5OJaph2gAw+IX+m0U+TIkOyK
	+AAgtVCmBQG6ezNTeiJiK8xqIpJWscFD5C320FrcP9d0l1QuB+r3chs/Al7lQc6BlUS2lVR6xAW
	6sqU1qD79Xy9mSlnCdkLSi96upySF5+OHuPLpWWYQJTNvQ==
X-Received: by 2002:a05:620a:1a0f:b0:93f:eed:ea4f with SMTP id af79cd13be357-94604da3ca6mr412770985a.41.1794079185485;
        Sat, 07 Nov 2026 11:19:45 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.250])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94782d93650sm3003385a.23.2026.11.07.11.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 11:19:43 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH v5 0/8] ovl: only sync what was written through the overlay
Date: Sat, 07 Nov 2026 19:19:29 +0000
Message-Id: <20261107-b4-ovl-containerized-sync-v5-0-d34b4ae57fdf@toxicpanda.com>
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
X-B4-Tracking: v=1; b=H4sIAMJ572oC/33Rz07EIBAG8FfZcBYFSv/gyfcwHgZmajEKm1LJr
 pu+u7DGuIlNDxw+MvPLl8yFJZo9JfZ4uLCZsk8+hhLauwNzE4RX4h5LZkqoTpbHreYxv3MXwwI
 +lOUvQp7OwXGpjSWUMJIBVvaPM43+dLWfX35y+rRv5JYK1gkLibidIbipftX4sI3X6cmnJc7na
 9Usq/rbqt9plSUXfBCKWqma3kD3tMSTd0cICPcufrBaLatbzuxxqnCazCgG0iBatck1f5wUeo9
 rajsEUEJqPbbNJqdvub0TZF24DhFJ2B5xgH/cuq7fEVX0KPQBAAA=
X-Change-ID: 20261026-b4-ovl-containerized-sync-149bed1afe9a
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>, Chengguang Xu <charliecgxu@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1794079181; l=12605;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=eObx81F36C8LT35tT30vmSNszUpeaRAVHZ+UHj1Wxdw=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QC6CPUj6RSRBTKDvQcB+HWF7oqj3lJ7I8xExs2Jpy0rEFO01yulWDZdbYCVoA2fyl5lnlyJtHFI
 oZHGGkD7HOgk=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

v1: https://lore.kernel.org/all/20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com/
v2: https://lore.kernel.org/all/20261029-b4-ovl-containerized-sync-v2-0-4e9f08e4a052@toxicpanda.com/
v3: https://lore.kernel.org/all/20261104-b4-ovl-containerized-sync-v3-0-8daa20144f53@toxicpanda.com/
v4: https://lore.kernel.org/all/20261106-b4-ovl-containerized-sync-v4-0-6ddde0b7dd8a@toxicpanda.com/

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
of other people's data. With fsync=relaxed overlayfs writes the upper
inodes whose overlay inode was marked dirty and does the other two steps
as they are.

Whiteouts and the work directories have no overlay inode, so nobody
writes those inodes. That's fine if ->sync_fs() or the block device gets
all metadata to disk, which is what relaxed asks of the upper file
system.

Things I know about:

 - ext4 without a journal supports RENAME_WHITEOUT, so it gets relaxed.
   It's fine there, its metadata is in the buffers of the block device,
   which we write. I tested it like the others.
 - f2fs, ubifs and fuse get relaxed as well and I didn't test them. f2fs
   writes its dirty inodes in the checkpoint. ubifs_sync_fs() doesn't,
   but the only thing overlayfs leaves dirty there on an inode it
   doesn't track is the chmod of the work directory to 0 at mount time,
   right after creating it with mode 0. fsync=on is there for anybody
   who needs more.
 - A default mount that gets relaxed shows that in /proc/mounts.
 - lazytime on the upper file system doesn't do anything for inodes that
   are modified or read through a relaxed overlay, their timestamps are
   written with the next pass of the flusher.
 - While a file is open for writing the flusher of the overlay looks at
   its inode up to every 5 seconds. That doesn't do any I/O.
 - With nobody else's data to skip syncfs() gets a bit slower. Over 30
   boots per kernel, after creating 2000 files and a chown -R of another
   2000 it goes from 51ms to 57ms on ext4 and takes 11ms longer on
   btrfs. After 2000 mkdirs it goes from 45ms to 48ms on xfs and from
   49ms to 54ms on btrfs, on ext4 I can't tell 235ms and 238ms apart.
   Nothing else I timed moves.

The testing is the same as for v1, now also on ext4 without a journal.
syncfs() goes from 222-268ms to 41-50ms and unmount from 122-236ms to
36-45ms on those four. ext2 with [2], which is in Jan's tree now,
doesn't get relaxed and does exactly what it did before. fstests with
-overlay gives the same results with and without the series on ext4 and
on xfs, apart from overlay/019 on ext4 and generic/670, 733 and 751 on
xfs, which are flaky either way. There's a new fstest for this [3], it
fails if I break the tracking.

[2] https://lore.kernel.org/r/20261027-b4-ext2-dirsync-v1-1-3dcd012d518d@toxicpanda.com
[3] https://lore.kernel.org/r/773faf2a275e0a51bd38cf68f492856c.josef@toxicpanda.com

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

Chengguang Xu (4):
      ovl: setup overlayfs' private bdi
      ovl: implement overlayfs' own ->write_inode operation
      ovl: cache dirty overlayfs' inode
      ovl: implement containerized syncfs for overlayfs

Josef Bacik (3):
      fs: add sync_fs_and_bdev()
      ovl: mark the overlay inode dirty on modification
      ovl: write the timestamps that lazytime defers

 Documentation/filesystems/overlayfs.rst |  36 ++++++-
 fs/overlayfs/Kconfig                    |  21 ++++
 fs/overlayfs/copy_up.c                  |   9 ++
 fs/overlayfs/dir.c                      |   3 +
 fs/overlayfs/file.c                     |   7 +-
 fs/overlayfs/inode.c                    |   4 +-
 fs/overlayfs/overlayfs.h                |  58 ++++++++++-
 fs/overlayfs/params.c                   |  32 ++++---
 fs/overlayfs/params.h                   |   2 +
 fs/overlayfs/readdir.c                  |   1 +
 fs/overlayfs/super.c                    | 165 +++++++++++++++++++++++++++++---
 fs/overlayfs/util.c                     |  93 +++++++++++++++++-
 fs/sync.c                               |  52 +++++++---
 include/linux/fs.h                      |   1 +
 14 files changed, 434 insertions(+), 50 deletions(-)
---
base-commit: 2c8a968b488c134d05ccefff890270ac8ab899a8
change-id: 20261026-b4-ovl-containerized-sync-149bed1afe9a

