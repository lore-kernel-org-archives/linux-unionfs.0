Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794264771;
	b=F5xEZyHTO/VADBgdB86SpRe6njiLhQeJwbqueQLA+nDLomPB3icscX5rwJb11m2ZF4+d
	 4GV19T5gFJUG82FR0/wqrEbPteL4jCzwMS5HAynibr1h5jQ8rrsB/C6ENjDGJMVyji6/+
	 NLjgkM29yWilhrZTNgSjySQxq0ydWAnJKviKFoN+FAyrWrO4Hf+eCqwH4XoOL5k4X4haU
	 RBXaVuO2rvv+903XaEAoOd+46DETE+JMzfmu1m1uV0xZzePOVTLnSGX+bunuII3CfsPuV
	 vCPolSR6RFqeJbDIlyU95pbkisCRfrsHCQNzJqRdYxbhxmfZIsfBZnLhvhPyUcEJDxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794264771;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:Message-ID:In-Reply-To:References:From:Subject:To:Cc:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Vl/lTXy9bOXBXT8l1noVrvOoB21zUDqGd6o5aJ8O0cE=;
	b=1zY+2Fk1hDpwrTrg600G9yRrFhqStakLaq51V0BJ6RQSQ9EKZjcmzpA0bkNag7FLuNo9
	 PLQNC3W2ACnEZfsa263ZfOINNhr2uRI6vEsgr6Jl3qO2AF2RPNBMAeq31qU8CmBB9lGJ8
	 dqCX1Z3DAaZj2gta06rGtK1TJRE2zcrK/tfwdInBzLZDmB8VngPA2oVPpIuF7uQ8Erjwm
	 /4cR6/Dcur29OJnpwH/fdRN3SC0o4USQ5Cx/BtSK3cadvuaFQa6l/KJOpbHha3CjzH91F
	 jg4QcZaYvwQdzSx7Rln0hzjysgR1RiAsL6FDcpadLTxLwTCaEhQ7p6dJCUolLI7+1CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=n8OxjkDc;
	arc=none smtp.remote-ip=209.85.219.41
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C32606A31C
	for <linux-unionfs@vger.kernel.org>; Mon,  9 Nov 2026 22:52:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92C32606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=n8OxjkDc
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-91ebec7d5dcso11256066d6.3
        for <linux-unionfs@vger.kernel.org>; Mon, 09 Nov 2026 14:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1794264769; x=1794869569; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:cc:to:subject
         :from:references:in-reply-to:message-id:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vl/lTXy9bOXBXT8l1noVrvOoB21zUDqGd6o5aJ8O0cE=;
        b=n8OxjkDcjHht+CFicsbbgNvS18v2I8HFbDqEofGLcRtRuxYqV0xlGApLlf3LsbUo3G
         Ln9ghADPwXr9aRzWg8+Jvtq3OlXW+BB0Lo+YDoORgKVWuqtUyHI0A4GJgDWRfM17tiUo
         W5wO8W/bX3wsmsIHV7WrWH+QWow8RHnvRrkWYZNJg1uQaEl+25vfzlZwTC5DpZeOjbmq
         2DwIoxqCp2rNogvCr6SdPnRhxOuZUq0+5VhMSGxDO1IYdlT9TDC4TP8CFhdLV8ENCylq
         /fbYkWICHb9f+OXciaxb9zfWAc6c2MqZ0wsDtaz5eUiagBPEj0rV3cMG2i4OaC5PX2XB
         m5YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794264769; x=1794869569;
        h=content-transfer-encoding:content-type:mime-version:cc:to:subject
         :from:references:in-reply-to:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vl/lTXy9bOXBXT8l1noVrvOoB21zUDqGd6o5aJ8O0cE=;
        b=hABwqh+jMF5GI0DW6hLPadWYrxK44jINHKK5KYrjGvhRAGQ29+P9qL1uezjUHJMVMT
         f6UQHUyaA5qhgXmkpTXapJ89tbY/kjGx1XN0V7mRlsf5f5nntgTX3+oASOBbqiCylOI3
         raTda6rhPy1Ddaug7E4dZl+0CkrrDIkBedpmrPpBOG52Zs0lGYEZzDpAiUtjJb38BJl4
         C4A5Qxhm7W5yg8kDfguHE99OLD01VaFm5DVPO+0sNPn6yVyZYiXptvrEc14O009Wrl7j
         hqrR/oSXxmlznm2OQ5QJgf3F7zkcWZsgVPQbHONAsw1F0DpMNGTJ7zuqDKPTu1jqxxQJ
         PxgA==
X-Forwarded-Encrypted: i=1; AL+hErEdnv8Smju01miyKC1vXWFAtSbTBw6VuIIWfKXFEH72G0Jkk2Tg7wjSB9JLAHqf7PYBsITiQaAnQFd8GvcU@vger.kernel.org
X-Gm-Message-State: APuU4Z/fKYemSCAZ5dC918Qa2zS0emMbFKmkwVtyYRKhuFeVR/uGci2d
	jwiLX1IpaEuaJZ9dBZcmuzuMh79feQnf3bAxHon9ohtOJ00k9veEVipDAo9FmqDG/VmGSrmrjRE
	oNpuqBzM=
X-Gm-Gg: AYBFou1kwFU4+Q6bec4pWovepFyfiBD2NwH11I4d/8uUvcmBwyX7BiT+OBkstkuLmnp
	iYnefeXT8Ky/0F7DW9p1GB8CLbj8eNdBV8hdZ3XBKDGpC7ftaqbl6nB+0TxBNGTbVkroNfzWX8W
	YfsLL2SHm/AKe1Pw3exANGOgaeVtk/iRgfzTdOzcPeO7XopiiY3gQwRBLcGCxOKh3bFEOxhwJrl
	2en558Pbz02N6uDsOkjgd5atG2tg4v7xKSxSoOpcVOsjfXOPeCqO0wTN7AFXYPDiAvxBTBPb3eB
	6GpDb5QrUazhiiip0LoPl8JO4xTUpzyJF8LxgcSOb5s263fAewDq2VLAliAvN7zgHj2XVoAIqkR
	v9hotViz29PjfZV9INBNU/xb83sl/LwpiUiahr31jJ3Kqc6vjPHzjTErhnZKqWnXCHNMpve3D6e
	YQW/qzA7HTKS8FN5qmda9Q4bSgTdD6VtvAuYJWKyA01R/1+IGnZS3ERKfEodZ1EouG54FBCw2Rq
	ATx4RCd0Puk/jW5cqxAfHub24TuqKgAy/NB3YbyKNwqB6VgTjetjB2PHESGm3YFOt4IXtr/wMLM
	Fu3Tei+0zdJ6sd2e7ajaXX1skfsDGAk/2/Bjc8kHX/odeg==
X-Received: by 2002:a05:6214:634a:20b0:91c:6258:ec97 with SMTP id 6a1803df08f44-91eef88951emr14669486d6.11.1794264769441;
        Mon, 09 Nov 2026 14:52:49 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.251])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef0523506sm6816156d6.33.2026.11.09.14.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 14:52:48 -0800 (PST)
Date: Mon, 09 Nov 2026 22:52:47 +0000
Message-ID: <94833333cf2c5dd487022cb290174393.josef@toxicpanda.com>
In-Reply-To: <946b46fbf1c555a47a8a9304f2ee31af.josef@toxicpanda.com>
References: <773faf2a275e0a51bd38cf68f492856c.josef@toxicpanda.com>
 <946b46fbf1c555a47a8a9304f2ee31af.josef@toxicpanda.com>
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH fstests v3] overlay: test that syncfs and unmount persist all
 changes
To: fstests@vger.kernel.org
Cc: Zorro Lang <zlang@kernel.org>,
    Amir Goldstein <amir73il@gmail.com>,
    Christian Brauner <brauner@kernel.org>,
    linux-unionfs@vger.kernel.org
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

overlayfs is about to stop syncing the whole upper filesystem on syncfs(2)
and unmount.  With fsync=relaxed it only writes the upper inodes that were
modified through the overlay, so it has to know about all of them.

Modify an overlay in many ways: new files and directories, data and
metadata copy up, stores through a shared mapping, sendfile, copy_range,
an O_TMPFILE, a short and a long symlink, hard links, renames, whiteouts.
Do the same to files that were synced before, so that nothing but the
modification itself tells overlayfs about them.  Then drop the caches, sync
or unmount the overlay, shut down the base filesystem without flushing its
log, cycle the mounts and check that nothing has changed.

Do that with every fsync mode that syncs, with and without redirect_dir and
metacopy.

The base filesystem has to have a journal, so what gets lost if overlayfs
misses a modification is data in the page cache.  Changes of metadata are
in the log, which overlayfs commits in any case.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
v1: https://lore.kernel.org/r/773faf2a275e0a51bd38cf68f492856c.josef@toxicpanda.com
v2: https://lore.kernel.org/r/946b46fbf1c555a47a8a9304f2ee31af.josef@toxicpanda.com

v2->v3:
- It's overlay/090 now. (Amir)
- Every round passes fsync=, with fsync=auto in place of the default, and
  _exclude_scratch_mount_option is gone. (Amir)
- Added _require_scratch_overlay_features fsync redirect_dir metacopy. That
  needs [2], and the test doesn't run on older kernels any more. (Amir)
- The rounds are in the golden output. (Amir)
- Every fsync mode runs with redirect_dir and metacopy off and on, that's 16
  rounds. It takes 70s here, so it's not in quick any more. (Amir)
- The mmap step with the syncfs in it comes first, it used to write
  everything that came before it. (Sashiko, Amir)
- The caches are dropped after the snapshot, for all files. (Sashiko, Amir)
- The overlay is mounted with noatime. The snapshot reads every file, the
  atime update marks the overlay inode dirty, and that hid any modification
  that overlayfs had missed.
- Added files that are synced before they are modified. Creating a file and
  copying it up mark the overlay inode dirty, and that hid any later
  modification that overlayfs had missed.
- Added fallocate, and a copy_range that isn't aligned so xfs can't reflink
  it.

This is for "ovl: only sync what was written through the overlay" [1].

It passes on ext4 and xfs with the series, and with only the first patch of
it, which adds the mount options and still syncs the whole upper file
system.

I ran it on four kernels that I broke on purpose. All of them fail, only in
the fsync=auto and fsync=relaxed rounds:

- The function that marks the overlay inode dirty does nothing: the file
  data is gone.
- Only ovl_copyattr() doesn't mark the inode: the pwrite, the sendfile and
  the copy_range to the files that were synced before are gone. v2 passes on
  this one.
- A dirty overlay inode isn't kept after the last iput(): the file data is
  gone. v2 only notices in its unmount rounds.
- Nothing is written at unmount: the unmount rounds lose the file data.

[1] https://lore.kernel.org/r/20261107-b4-ovl-containerized-sync-v5-0-d34b4ae57fdf@toxicpanda.com
[2] https://lore.kernel.org/r/20261106155832.3867017-1-amir73il@gmail.com

 tests/overlay/090     | 214 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/090.out |  17 ++++
 2 files changed, 231 insertions(+)
 create mode 100755 tests/overlay/090
 create mode 100644 tests/overlay/090.out

diff --git a/tests/overlay/090 b/tests/overlay/090
new file mode 100755
index 00000000..7f6e58f4
--- /dev/null
+++ b/tests/overlay/090
@@ -0,0 +1,214 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Josef Bacik.  All Rights Reserved.
+#
+# FS QA Test 090
+#
+# Test that syncfs(2) on an overlay, and unmounting one, persist everything
+# that was modified through it.
+#
+# overlayfs used to sync the whole upper filesystem for that.  With
+# fsync=relaxed it only writes the upper inodes that were modified through this
+# overlay, so it has to know about all of them.
+#
+# Modify the overlay in every way we can think of, sync it, shut down the base
+# filesystem without flushing its log, cycle the mounts and check that nothing
+# has changed.
+#
+. ./common/preamble
+_begin_fstest auto shutdown copyup whiteout mmap redirect metacopy
+
+. ./common/attr
+
+_require_scratch
+_require_scratch_shutdown
+_require_metadata_journaling $SCRATCH_DEV
+_require_scratch_overlay_features fsync redirect_dir metacopy
+_require_xfs_io_command "syncfs"
+_require_xfs_io_command "sendfile"
+_require_xfs_io_command "copy_range"
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "-T"
+_require_xfs_io_command "flink"
+_require_attrs
+_require_chown
+_require_mknod
+
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+
+create_lower()
+{
+	local f
+
+	# This leaves the base filesystem mounted
+	_scratch_mkfs >> $seqres.full 2>&1
+
+	mkdir -p $lowerdir/dir $lowerdir/rmdir $lowerdir/mvdir
+	for f in append truncate mmap chmod chown chown_append xattr link \
+		 rename remove dir/append rmdir/file mvdir/file; do
+		$XFS_IO_PROG -f -c "pwrite -S 0x6c 0 256k" $lowerdir/$f \
+			>> $seqres.full
+	done
+
+	# These were not written through the overlay, so it does not have to
+	# sync them.
+	$XFS_IO_PROG -c "syncfs" $OVL_BASE_SCRATCH_MNT
+}
+
+# Creating a file and copying it up are modifications.  overlayfs remembers them
+# until the file is synced, and a later modification that it misses does not
+# show.  So make files that are in the upper layer and have been synced.
+prepare()
+{
+	local m=$SCRATCH_MNT
+	local f
+
+	mkdir $m/clean
+	for f in pwrite truncate fallocate mmap sendfile copy_range chmod \
+		 chown xattr link rename remove; do
+		$XFS_IO_PROG -f -c "pwrite -S 0x70 0 256k" $m/clean/$f \
+			>> $seqres.full
+	done
+	$XFS_IO_PROG -c "syncfs" $m
+}
+
+modify()
+{
+	local m=$SCRATCH_MNT
+
+	# Stores through a shared mapping, also after a syncfs, no msync.  This
+	# has to be the first one, the syncfs must not write anything else.
+	$XFS_IO_PROG -c "mmap -rw 0 256k" -c "mwrite -S 0x66 0 64k" \
+		-c "syncfs" -c "mwrite -S 0x67 64k 64k" $m/mmap >> $seqres.full
+
+	# The files that overlayfs has nothing to remember about
+	$XFS_IO_PROG -c "pwrite -S 0x71 64k 64k" $m/clean/pwrite >> $seqres.full
+	$XFS_IO_PROG -c "truncate 4k" $m/clean/truncate
+	$XFS_IO_PROG -c "falloc 256k 64k" $m/clean/fallocate
+	$XFS_IO_PROG -c "mmap -rw 0 256k" -c "mwrite -S 0x72 64k 64k" \
+		$m/clean/mmap >> $seqres.full
+	$XFS_IO_PROG -c "sendfile -i $m/link 0 64k" $m/clean/sendfile \
+		>> $seqres.full
+	# Not aligned, so that the data is copied and not shared
+	$XFS_IO_PROG -c "copy_range -s 1 -d 1 -l 64k $m/link" \
+		$m/clean/copy_range
+	chmod 640 $m/clean/chmod
+	chown 1234:1234 $m/clean/chown
+	$SETFATTR_PROG -n user.test -v value $m/clean/xattr
+	ln $m/clean/link $m/clean/link2
+	mv $m/clean/rename $m/clean/renamed
+	rm $m/clean/remove
+
+	# New files and directories
+	$XFS_IO_PROG -f -c "pwrite -S 0x61 0 1m" $m/new >> $seqres.full
+	mkdir $m/newdir
+	$XFS_IO_PROG -f -c "pwrite -S 0x62 0 64k" $m/newdir/new >> $seqres.full
+	$XFS_IO_PROG -f -c "pwrite -S 0x63 0 64k" $m/dir/new >> $seqres.full
+	ln -s new $m/symlink
+	# Too long to be stored in the inode
+	ln -s $(printf 'a%.0s' $(seq 1000)) $m/longsymlink
+	mkfifo $m/fifo
+
+	# Copy up, then change the data
+	$XFS_IO_PROG -c "pwrite -S 0x64 256k 64k" $m/append >> $seqres.full
+	$XFS_IO_PROG -c "pwrite -S 0x65 256k 64k" $m/dir/append >> $seqres.full
+	$XFS_IO_PROG -c "truncate 4k" $m/truncate
+
+	# The other ways to write data
+	$XFS_IO_PROG -f -c "sendfile -i $m/link 0 256k" $m/sendfile \
+		>> $seqres.full
+	$XFS_IO_PROG -f -c "copy_range -l 256k $m/link" $m/copy_range
+	$XFS_IO_PROG -T -c "pwrite -S 0x69 0 64k" -c "flink $m/tmpfile" $m \
+		>> $seqres.full
+
+	# Copy up, then change the metadata
+	chmod 640 $m/chmod
+	chown 1234:1234 $m/chown
+	$SETFATTR_PROG -n user.test -v value $m/xattr
+
+	# With metacopy=on the first one only copies up the metadata
+	chown 1234:1234 $m/chown_append
+	$XFS_IO_PROG -c "pwrite -S 0x6a 256k 64k" $m/chown_append \
+		>> $seqres.full
+
+	# Names
+	ln $m/link $m/link2
+	mv $m/rename $m/renamed
+	# Without redirect_dir=on mv gets EXDEV and copies the directory
+	mv $m/mvdir $m/mvdir2
+	rm $m/remove
+	rm -r $m/rmdir
+}
+
+# No inode numbers, no timestamps, and no sizes and link counts of directories
+snapshot()
+{
+	local f
+
+	cd $SCRATCH_MNT
+	find . | LC_ALL=C sort | while read -r f; do
+		if [ -L "$f" ]; then
+			echo "$f $(stat -c '%F %u:%g' "$f") $(readlink "$f")"
+		elif [ -f "$f" ]; then
+			echo "$f $(stat -c '%F %a %u:%g %h %s' "$f")" \
+			     "$(md5sum < "$f")"
+		else
+			echo "$f $(stat -c '%F %a %u:%g' "$f")"
+		fi
+	done
+	_getfattr --absolute-names -n user.test xattr clean/xattr 2>&1
+	cd - > /dev/null
+}
+
+# <syncfs|umount> <mount options>
+do_test()
+{
+	local how=$1
+	local opts=$2
+
+	echo "=== $how $opts" | tee -a $seqres.full
+
+	create_lower
+
+	# An atime update is a modification too.  With atime the snapshot would
+	# make overlayfs write every file that it reads, also one that
+	# overlayfs has lost track of.
+	_scratch_mount -o noatime,$opts
+
+	prepare
+	modify
+	snapshot > $tmp.before
+
+	# Nobody holds on to the overlay inodes when they are synced
+	echo 2 > /proc/sys/vm/drop_caches
+
+	if [ $how = syncfs ]; then
+		$XFS_IO_PROG -c "syncfs" $SCRATCH_MNT
+		_scratch_shutdown | tee -a $seqres.full
+		_scratch_unmount
+	else
+		# Only the overlay, the base filesystem stays mounted
+		_unmount $SCRATCH_MNT
+		_scratch_shutdown | tee -a $seqres.full
+		_unmount $OVL_BASE_SCRATCH_MNT
+	fi
+
+	_scratch_mount -o noatime,$opts
+	snapshot > $tmp.after
+	cat $tmp.after >> $seqres.full
+	diff -u $tmp.before $tmp.after
+	_scratch_unmount
+}
+
+for how in syncfs umount; do
+	for mode in auto relaxed on strict; do
+		for meta in off on; do
+			do_test $how \
+				fsync=$mode,redirect_dir=$meta,metacopy=$meta
+		done
+	done
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/090.out b/tests/overlay/090.out
new file mode 100644
index 00000000..d6b46515
--- /dev/null
+++ b/tests/overlay/090.out
@@ -0,0 +1,17 @@
+QA output created by 090
+=== syncfs fsync=auto,redirect_dir=off,metacopy=off
+=== syncfs fsync=auto,redirect_dir=on,metacopy=on
+=== syncfs fsync=relaxed,redirect_dir=off,metacopy=off
+=== syncfs fsync=relaxed,redirect_dir=on,metacopy=on
+=== syncfs fsync=on,redirect_dir=off,metacopy=off
+=== syncfs fsync=on,redirect_dir=on,metacopy=on
+=== syncfs fsync=strict,redirect_dir=off,metacopy=off
+=== syncfs fsync=strict,redirect_dir=on,metacopy=on
+=== umount fsync=auto,redirect_dir=off,metacopy=off
+=== umount fsync=auto,redirect_dir=on,metacopy=on
+=== umount fsync=relaxed,redirect_dir=off,metacopy=off
+=== umount fsync=relaxed,redirect_dir=on,metacopy=on
+=== umount fsync=on,redirect_dir=off,metacopy=off
+=== umount fsync=on,redirect_dir=on,metacopy=on
+=== umount fsync=strict,redirect_dir=off,metacopy=off
+=== umount fsync=strict,redirect_dir=on,metacopy=on
-- 
2.55.0

