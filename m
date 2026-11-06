Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793972222;
	b=NSq0lr5UZd6sOoKsDGtac31NX5PMBri/8bD8xvPee5eCQnoUPy5EDiKRSlXFRmHz/+UY
	 4HI+0BfHV2Y0IVoLILxbBh3Nm3U4Z5PStgvBWTEgEcrmU/U6JjFoUER/5V1nsyR4hhh7d
	 8WmeKbQcD+yfWEivIidEtG1chMyL883P2Id8O/jv9STPw5DoQ9svzmMIV/pdL5YjNCDFp
	 KuF0c/+hvkzkJqF1YX3DlHywb+gVp0KjC9PdaIoXbZUdi4N6u8ZR0HhEC2kr5Fj5qGnAO
	 QobJGqiQkMha6P8KB0pNXtvcFuEIB65OZpfjTC+wD0/tUh0HmXLcxIUfStFI9FoUhxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793972222;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=wjWsmGcWJuLV3iryWyDkMElw2EY89A+FYMLETttn3HA=;
	b=lBhHGKpAzfMwVmOyZB8g61rFBwtmkEaXN6yc1ETv/4rN5atpquFA9zgRy0xsFHsftiYk
	 vl7vzogVR6yJP4tvPFHqITTK/2jEkOO/aWFwC7a9z0TupQ/wtdIois5IwMmKfoXCC2Xpp
	 sKByTB4zoZ8lIWMUEq4FXZHi68z3etvfSdUxt3Egi56oAgCmD45vCNOu8HRWpz5oj5Quk
	 Q7CmA7xokj50VnFEQbQdS0cHZvByP43TIW160yvb328PnoJiCRoNk0PNZdCKdg+5hJCAW
	 UQYtQb36wfDnUkDG9LZ1HBJT1NNAABIf/WWQ7EpiA7e5AFshwsynpRw4fQccCV9ov+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=JBxdaTT2;
	arc=none smtp.remote-ip=209.85.219.54
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925DE606A32C
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 13:37:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 925DE606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=JBxdaTT2
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-91e7af9a67fso4258176d6.2
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Nov 2026 05:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793972220; x=1794577020; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=wjWsmGcWJuLV3iryWyDkMElw2EY89A+FYMLETttn3HA=;
        b=JBxdaTT27S1ocCL5xMkNZ8HTaDVS30MhBLec1oZm2l2FY+UtiUQBvJt/832ABpdEwg
         92KxIt1rxxwwaQF3gtv6eJuiH/F0uxDTICmsPCNh7athyXFYqb93D54sFGYFTc3rq8yf
         C5BSkwYj+YvpfKC3IJr2R+lSbbuKEZvL1bMKT8KYQn4zOruI/G+D83WchuFhLhxGzUM5
         HCEGIUybkk7f4foryELkR8/CNpQ6S+sDWGtC6/avil6e3+XSexcMvvD3mTFkgRS4VxZS
         zNxDRBNVIefn4NDx+gK/nmPtr/FnqGIkrU6rEdOtHRd+OWHXELimmgIlEhO9pbDLyZH3
         xlWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793972220; x=1794577020;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wjWsmGcWJuLV3iryWyDkMElw2EY89A+FYMLETttn3HA=;
        b=xvO9YKMRfkIFuvcmE2oZ91FiFMGnVf2BK+JzpsRrYlAKEivXy7aEEGgnUSWmHyFxoZ
         OoFxpk2F90DuQ11bPzQb9xwXy3I/TmZ7vMTv9sbu7d8EAivr5sHIVMze9iyOjMW8N6F2
         2rwyfC5UZXrkopBgvH+HbMxOEI2xU1Dny8SeUjbOeMiqZPWGgAABGvItFOmNm9lVr5P8
         xR4ZmR9Gh/N1vJB/sbP02rk/8uIoO8jVaW8wqn0ZqtcOXsd4K5+8/qZ1EOvppGUJ3K8D
         4YT+HxxU4EGzu/Fp2H1h1NS+/vKwHSAerUekUoxuYvq8n/KDTkwtTBdVSQV+4ix4xoPN
         ei3w==
X-Forwarded-Encrypted: i=1; AKwUvBxu9pRrMAvhV8438l8bm0+jzwqfoN7zGGp1SMI7a0HWqT7gQYox5XwDgPnnXrnREMZwpnrem16nkqUkx6xN@vger.kernel.org
X-Gm-Message-State: APuU4Z/xAwCBCrgrN56zucnB4wkH9uEUzjV3uoI/zsKfLCKlvtobQe9K
	XDKMsp7oTg61KYvwZ6ne5vegm4GKg4yg8979Pe7vcbx1zoIj9BxtXfKuQlCPO1ze/eA=
X-Gm-Gg: AYBFou3PnZPiAhmfZRPglDX+65r5Z/sBTFxshOKOi94HwxyPii40wbmnidt8rIkwNcn
	G1PE5WbPwRi36Vi0VNw5whm1HcF9Ts1BWnuioe8MZ5GXYNrLk5QImnNiovZRbG4OOwW/lMZ77Hb
	Q/jWFFJzfEMonGaJhJPRecVaC7ZMO8iRHNCFSYbwbUK8TBtxaINhvzusqFZxClFJmm+fZHKgZcP
	BAcgMMwW/Hk7DRVMlNI2zeh6lcd5/amyl9nelGxWtJOwKrizIGrQ/YcSrOjZs80OgMBpiCrew/C
	AMewh3iw0nfcCKrQsdLkkTM9AVfSlhLTBV1TvR9e7nLhChDxtySEy5/Qk7qb6lgGEHGPefID7yW
	Q2kIWuA4KuA/clfiQ3Rl2oi7X8yb+mCFfKgaeFmrMwRUQEyl/7tz8nKvsSq2/PcK9tHINIyg9ZE
	ceuXVeFVawoUALMaQtllbWOoTpQEZltpzsZt5OEXsq8qm3++xSLXp6GcSxc1luvc+swtltAJCyl
	MDf4/sCKcGnI+kDl+VNezIry9ChS9iiQEcx2OIugIVJEHKnmZoPdqs/ZKswTo9chrfmT+IVuzX7
	yXDlhm2jLFLPkv9y8NZppp4fsYnihtCL2JS95ZdUtFhH4g==
X-Received: by 2002:a05:6214:2d45:b0:91c:dfc:ce5e with SMTP id 6a1803df08f44-91ea993c08dmr33513576d6.47.1793972220229;
        Fri, 06 Nov 2026 05:37:00 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.255])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ea6a2c11bsm20498496d6.8.2026.11.06.05.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 05:36:59 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH v4 0/8] ovl: only sync what was written through the overlay
Date: Fri, 06 Nov 2026 13:36:42 +0000
Message-Id: <20261106-b4-ovl-containerized-sync-v4-0-6ddde0b7dd8a@toxicpanda.com>
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
X-B4-Tracking: v=1; b=H4sIAOzX7WoC/33OwW4CIRAG4FcxnDstsKyKJ9+j6WGA2S5NBQNbo
 jX77gWNaZOaPczhn8x8+S8sU/KU2W51YYmKzz6GGtTTitkRwzuBdzUzyeVa1AGjIJZPsDFM6EN
 9/iYH+RwsCKUNOYEDaWT1/5ho8Ker/fp2y/nLfJCdGtguDGYCkzDYsa1afHmMt+vR5ymm87VqE
 U29t9ostCoCOGy5pF7IbqNxvZ/iydsjBofPNh5Yq1bkX04vcbJyivTAt6SQ9/Ih1/1ygqslrmv
 tHKLkQqmh7/5x8zz/AJZfUB2lAQAA
X-Change-ID: 20261026-b4-ovl-containerized-sync-149bed1afe9a
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>, Chengguang Xu <charliecgxu@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793972217; l=10098;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=cdS15OHmeogGAZFdcMW5zZNlkd4djIhqMdzECel8nck=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QBCIPhTeeLzd7HSFb35+dmcYQstL8nY7Sh6629I3fYa2IpOeOa4KVI48YoBOKTBGeDkJjnvepL+
 isEn0U1czbg8=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

v1: https://lore.kernel.org/all/20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com/
v2: https://lore.kernel.org/all/20261029-b4-ovl-containerized-sync-v2-0-4e9f08e4a052@toxicpanda.com/
v3: https://lore.kernel.org/all/20261104-b4-ovl-containerized-sync-v3-0-8daa20144f53@toxicpanda.com/

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
 - f2fs, ubifs and fuse get relaxed as well and I didn't test them.
   ubifs_sync_fs() doesn't write dirty inodes, so a chmod of the work
   directory at mount time waits for the flusher there.
 - A default mount that gets relaxed shows that in /proc/mounts.
 - v3 said chown -R and rm -rf get slower. That didn't hold up in more
   runs. What did is syncfs() with nobody else's data to skip, after
   creating 2000 files and a chown -R of another 2000 it takes 4-10ms
   longer on ext4 and 9-23ms longer on btrfs.

The testing is the same as for v1, now also on ext4 without a journal.
syncfs() goes from 223-261ms to 44-47ms and unmount from 112-242ms to
37-43ms on those four. ext2 with [2], which is in Jan's tree now,
doesn't get relaxed and does exactly what it did before. fstests with
-overlay gives the same results with and without the series on ext4 and
on xfs, apart from overlay/019 on ext4 and generic/670, 733 and 751 on
xfs, which are flaky either way.

[2] https://lore.kernel.org/r/20261027-b4-ext2-dirsync-v1-1-3dcd012d518d@toxicpanda.com

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
      ovl: make the root inode appear hashed
      ovl: mark the overlay inode dirty on modification
      ovl: handle lazytime on the upper filesystem

 Documentation/filesystems/overlayfs.rst |  36 +++++-
 fs/overlayfs/Kconfig                    |  21 ++++
 fs/overlayfs/copy_up.c                  |   5 +
 fs/overlayfs/dir.c                      |   1 +
 fs/overlayfs/file.c                     |   7 +-
 fs/overlayfs/inode.c                    |  23 +++-
 fs/overlayfs/overlayfs.h                |  58 +++++++++-
 fs/overlayfs/params.c                   |  32 +++---
 fs/overlayfs/params.h                   |   2 +
 fs/overlayfs/super.c                    | 198 ++++++++++++++++++++++++++++++--
 fs/overlayfs/util.c                     |  70 ++++++++++-
 11 files changed, 416 insertions(+), 37 deletions(-)
---
base-commit: 2c8a968b488c134d05ccefff890270ac8ab899a8
change-id: 20261026-b4-ovl-containerized-sync-149bed1afe9a

