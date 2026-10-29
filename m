Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793236172;
	b=UlR4uzp0ZI9rnH9G4D+Jg0j8kABB+AHM5Eh0xSMKtCk99143CfKBY8R1Vcrg2FSmlqy5
	 n/jRbAYQUaf1V4KMuvE+XLweiLKGAYo4NQwywm+/qdiKeC1y021GyN+FmpacP1QmdfPZ9
	 Fb+88KYuu9IWcJa7ul5D0CfmfDjjqQNWSOL2OY5P+KORBDLBuEEARgjJDMvEQ0CRGGNsv
	 B0poEFf7uGjdx6eLcnT+F6zygNMUwM/cjRxtnSRGVp7TX4iSJN38OKlpvDQijQQpNCSw5
	 8wmYQ+TyjYK9cZEy+X9xHDZxpQUgAeJCJ6+zANdZgZPqYpfXBMrE6lsNWNtqms7AheQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793236172;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=AvgapgFfF15CCbkLfkT4iFV2nlX6ytkjGcBxxRU+c+g=;
	b=LrkEEw3FWQutkelTJcI9eQhM34nxFu73rXXTml1dGcg1zsJ8xCmapF4vAuI7JrtrgZr6
	 jEOai1RVwg3dlXudVlD1l5YzKEfVGwcnCbBNGibCzv5hHatgzVK7Y4+XjaRLbQ82kJuus
	 /BxTIujvvbu1e52wm/04G3LXTuT7XQEgEqHV+rLnztJSWLfTuTUTsRWAr7aPWrc1YHKfz
	 dECDru6Ed29VRZzJAWBNNxTD2woGcZ+Ownb0fJgbhZspzO77wl6p4wguPfh7sGBn+3avh
	 AeJ52I/hZUAnxawBTRpU+Ws/idZkvtiAjh5IYno31oBV0vbWGyf+QUTyosSLAgWYzFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=pI3TBJE4;
	arc=none smtp.remote-ip=209.85.160.173
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C963C606A31A
	for <linux-unionfs@vger.kernel.org>; Thu, 29 Oct 2026 01:09:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C963C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=pI3TBJE4
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5365f9a04c5so23830361cf.1
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Oct 2026 18:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793236170; x=1793840970; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=AvgapgFfF15CCbkLfkT4iFV2nlX6ytkjGcBxxRU+c+g=;
        b=pI3TBJE44dpK06EGqubuZKxWiVeA+U4KvUsuhzjiZFmtB3qDeCnF/k+MYzN3op+fkl
         HLrdUZVJSqcv/ByJb/JYEldtdRNn4hr5/8TUuRXAcXZg4xWf8kpt3Pml7by96dC0AUq+
         WgFu1+gkcxBykaVvhjt7gqxFio5ec5qwDZ/3lbMEcOrf18KioRIga2AtiZahD7s9WM31
         HvboMdPcEe7K0CB613aCWp9Zhti4Oez3ywusLQEMb7ML8XPSaapKFX4UUxIwexPNYt5i
         236h1JWoKir8xQGFz1F1symjt4ldInhIn8KD5NdMMVg7YBpceFIWo1MQT1MJYhOkvT9W
         LWUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793236170; x=1793840970;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=AvgapgFfF15CCbkLfkT4iFV2nlX6ytkjGcBxxRU+c+g=;
        b=fTOU75CSpdtfjlv1SB9Qk4ylWeh6GuI5/O8VEwvQSufuHIPTHlDOa9aWehgsf8TIPG
         qMduZLZYtFujkPmS3UmwaXedLi3S+P8NFGMBOIgbBzs6lDsDXMy1MRclJdb2N07xXFc9
         iVYfH9RXMnN1wPgvo4u0RGSDcsxGvrl0LzOYyw5NGmsG2UUwDTFVdHYH/o07azlba7tJ
         urBenN4ieSSQUZxvuEorwq6RazGZLpC4L1ixaS5qqDkYZQtgtGOJrRgI81NIlo2xr5S6
         PNjPZ8JAb3dHmLU4MpRoWnUbBfeayoBaYZ59TqlRlBYFEPHlvdgMHRpaZNIzl/lLrmoa
         L7ag==
X-Forwarded-Encrypted: i=1; AKwUvByQY8QqpC2a1Py9waiRHzAoGSHa+yzrVjEZHl4HInfLzVdEMnONm848Ozsboq5K9wVUEm4URQU8ft6QNLX2@vger.kernel.org
X-Gm-Message-State: AFq9FYKDMhXibpDuaO97YAeAVusYAvpau9D2blgZCdCUrHzd5gGkOkLJ
	dgcDxwSUwgFR46h+vZfh3LJj/TtWGI8fFt/ESYGkN4pWo/IRr0BevvHjAFjvE3o+LUg=
X-Gm-Gg: AYBFou2WSYxQks/Y68WpJ11uDCWFuCBYrevNT6qlE0EbjxCC0MCHuX0YInk+wCKnYHN
	J4wsBvwl+eM95CxChb9Dz6MmuvlC6vdjL2TpiniDPBzC6pn+PKZ34ZUjYAcQITboRir7uX8KvDd
	/zWQdi6O2BhcqbIHMIv3wRrgdAwAxdJAowJgQ176sIEKSHNc3I9rpYWMG+itAhVPE6w+tWnKVhy
	kzoQEn5b6nOvqEAuk93dH7tGpeAxvEVrP1vukxEyzmli2EjamOSNMxfClD7y4scIR6G8RvcTIRo
	UP/L+qWmNANagzhc7OG6fJrmI2mvINbiUeffB/YIT0JaGSlPiBLIwe1tUckyJ2Ll0x07jOgNq02
	C+YRttPaAsIPdAd1vD2Vp2bVmJawSsb3PwISgFll53HhK3NV21Y8VLAamKrwxtmnRnCdHgFjox6
	CqHTHLD+ST2c4AF00zyF6bZCPZLm+OckMIPytPlo8WupCt+N3p68FIaybTDLbUJCpc1ucRXbFMl
	G/IurqPQvdof8YlZR2oarfcjCRSa5N3ud11OFK63kvTySCmKXL6X1crt4EpjUL2mxub8We/uHg5
	DVK+y7Ci5BR+8N29+7QcMtrsSKPowzcmwrq9I5GTeyg23g==
X-Received: by 2002:a05:622a:5a07:b0:535:a5f8:a5c7 with SMTP id d75a77b69052e-53fcc9c139emr67167931cf.71.1793236169584;
        Wed, 28 Oct 2026 18:09:29 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.244])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54111e32d7asm11391021cf.2.2026.10.28.18.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 18:09:28 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH v2 00/10] ovl: only sync what was written through the
 overlay
Date: Thu, 29 Oct 2026 01:09:14 +0000
Message-Id: <20261029-b4-ovl-containerized-sync-v2-0-4e9f08e4a052@toxicpanda.com>
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
X-B4-Tracking: v=1; b=H4sIALyc4moC/32OQQ6CMBBFr0K6dpRWBHHlPQyLaRmkRlvSIgEJd
 7fFuDMuZvEm/7/8mXlymjw7JTNzNGivrQkgNglTLZorga4DM5GKnIcDmYEd7qCs6VGbUH5RDX4
 yCnhWSqo5NlQiC/3OUaPH1X2pPuyf8kaqj8KYkOgJpEOj2viKuPstj+lW+966aZ068Gj9rir+r
 Bo4pHBMBR242Bcl5ufejlp1aGrcKvtg1bIsb+81QJ8HAQAA
X-Change-ID: 20261026-b4-ovl-containerized-sync-149bed1afe9a
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Chengguang Xu <charliecgxu@tencent.com>, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793236165; l=9017;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=Qz4fgceENgwobXqyICwP39qYZkuEeufCYCeIB/WJElQ=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QGwiL91nP/XCuWAq8pnzmFtmIgXm54uK5ql4QO3h+a9a40zhTXaDvUDTVmleaqqkuRcEXcpO2jz
 XZqRnE+OzbAk=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

v1: https://lore.kernel.org/all/20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com/

Jan, Amir suggested I ask you to look at the writeback and lazytime
parts again, that's patches 4 to 6 and 9.

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
of other people's data. So overlayfs writes the upper inodes that were
modified through this overlay and does the other two steps as they are.
No file system has to promise anything for that.

Upper inodes with an overlay inode are tracked as in v1. The rest,
whiteouts, index entries, the work directories, are caught in the
ovl_do_*() helpers, which know what upper inodes they touch. If the VFS
considers such an inode dirty it gets a fake overlay inode, hashed by
the upper inode like a trap inode, and from there it's an ordinary dirty
overlay inode.

Things I know about:

 - An upper inode can have an overlay inode and a fake one. After
   creating 2000 files and a chown -R of another 2000 there are twice as
   many overlay inodes cached on ext4 and ext2, and 1.5 times as many on
   xfs and btrfs. The fake ones can be reclaimed once they're written.
 - With nobody else's data to skip syncfs() gets a bit slower, after the
   above it went from 49ms to 62ms on ext4 and from 96ms to 154ms on
   xfs.
 - ext2 and jfs can dirty the inode of the quota file from ->sync_fs(),
   that now waits for the flusher of the upper file system.
 - On a file system without a journal the neighbours' unwritten inodes
   show up as bitmap and count differences in fsck after a crash.

The testing is the same as for v1, now also on ext4 without a journal
and on ext2 with [2] applied. syncfs() goes from 226-268ms to 45-50ms
and unmount from 114-238ms to 37-43ms, on all five. fstests with
-overlay gives the same results with and without the series on ext4 and
on xfs.

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
Changes in v2:
- Link to v1: https://patch.msgid.link/20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com

---
Chengguang Xu (4):
      ovl: setup overlayfs' private bdi
      ovl: implement overlayfs' own ->write_inode operation
      ovl: cache dirty overlayfs' inode
      ovl: implement containerized syncfs for overlayfs

Josef Bacik (6):
      ovl: make the root inode appear hashed
      ovl: mark the overlay inode dirty on modification
      ovl: handle lazytime on the upper filesystem
      ovl: look up overlay inodes with a key structure
      ovl: pass the ovl_fs to ovl_do_rename_rd()
      ovl: put modified upper inodes on the dirty list

 fs/overlayfs/copy_up.c   |   9 ++-
 fs/overlayfs/dir.c       |  11 +--
 fs/overlayfs/file.c      |   7 +-
 fs/overlayfs/inode.c     | 185 ++++++++++++++++++++++++++++++++++++++++++++---
 fs/overlayfs/overlayfs.h | 147 ++++++++++++++++++++++++++++++++-----
 fs/overlayfs/ovl_entry.h |   2 +
 fs/overlayfs/params.c    |  14 +---
 fs/overlayfs/super.c     | 175 +++++++++++++++++++++++++++++++++++++++++---
 fs/overlayfs/util.c      | 108 ++++++++++++++++++++++++++-
 9 files changed, 598 insertions(+), 60 deletions(-)
---
base-commit: 2c8a968b488c134d05ccefff890270ac8ab899a8
change-id: 20261026-b4-ovl-containerized-sync-149bed1afe9a

