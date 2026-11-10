Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794328033;
	b=qdG+p4+AiDVYjob2QJNgiIh53695FnYF9NX4P/tkr+1kBeazfDo3GbQl8EycNWMdC9DA
	 WvakXyJP5f+dE+HJ8rk550ExB2fIbRhvuEcxIfGqi4ae/yOxXIUsybci/fDkzdGanRZne
	 HEMstyj8klih4rf7SNdUHz1fc4Q00nL2yEKSz0Pc1Y90zyXAYho8+syVRDNIjM3HOM0k/
	 EKYWRLahCnK6DnThNcnhfeeGYZ6Sd8Y/4f6ZwOqIz9tiQOVwTJx5OGAX66ZpZMcqETKVZ
	 JhJLRZxOFZ51DlfNIvlEq1s9bSPXmCnIXadovY9xboj0oU+0zmxciPLSe0TDyszAT4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794328033;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:Message-ID:In-Reply-To:References:From:Subject:To:Cc:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=MFglliTUWzsKBuarbhqj7BU6xM83KEbfGac4ICvxiWU=;
	b=yO7g7E+XIJASwFtnKwokxjfdz9DkgRnm1/ScyK5A9X1NvDFJO8f43UwN7J2TZ8uuvRP/
	 HkPulO3Gn3QC2JJEYuRi12J52m8wB9jGEQSLfXAqNIUkhB4RR9ub+rLJbKOnQ1xqh5Qf+
	 HBXaGIznGZBc3eSk9T3O86r+fyxQZFjFxU6zhifRskQnM9CSyldH+mwLZKzrLv1jwQ3or
	 Gdl56TU99SU7D/n/2Mr4Id0rbkr97H3C2WUECEzZQ3vdjPFbYqsWzmLKyz04vthnOD2mA
	 /xMVMiqGuzRGOF8y6hhSuvWLkZrJEwHPk/Eh9ZPolCfk0/1qZyL1BuRXU6cUuLS9ruQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=Z9jR7KRa;
	arc=none smtp.remote-ip=209.85.221.179
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE41606D7D0
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 16:27:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DE41606D7D0
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=Z9jR7KRa
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5eac319a6c2so1573623e0c.0
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 08:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1794328031; x=1794932831; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:cc:to:subject
         :from:references:in-reply-to:message-id:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MFglliTUWzsKBuarbhqj7BU6xM83KEbfGac4ICvxiWU=;
        b=Z9jR7KRah6Og1bzInSt6Z0d2EPqqeBSkC5R+X5Hk4oGf41T/uM8sXdju0zO9BACwgG
         WUs4iAR2+aKTfHLlQvOZmc8fBelObkZfPqQnJfQ037zwAiFMEZi23HsU66f2xTWt3gs0
         rpXEw8uJ55Yp5AagpYiSA53+To+xQUHVorBPTIeAJDE3JxF04FO8VZ/qPdSCfNZfg/Hr
         1rlYEQJLt8Bl9z7yt9+K4K6eBe+srjkhebH/0DItJwIMv97D2wY8WHwhW1vFa8KzIbWI
         sXo+S+ErfFtigQ/8IaBbsKEhytrHLxP4ChqiwfH/miqxfeaS3x8Uzc/kMvuAMn0kG5aQ
         meBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794328031; x=1794932831;
        h=content-transfer-encoding:content-type:mime-version:cc:to:subject
         :from:references:in-reply-to:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MFglliTUWzsKBuarbhqj7BU6xM83KEbfGac4ICvxiWU=;
        b=Q6xpVI+kO80EcgX8MEmCR8UDiRhWW9svShTYTBAzB66h9V7LGrOoqtDLlNLdh7cPPH
         cvAitOuuDc+MPS+HpJvxCg8BtF2bRobaFtnEHUjEyz6Bd/d1ngg5Iw23oCKyngBodSjg
         SKVFI9YHoscF7U3rVa0+qz5vDddYtXD71q8SyntRpPGLKfAwYa9BSaCYzvIV8Wde13wi
         ge2tXT8vTiKhfHynddD0N/p++xL5E7gxsVxWKs2FivyHC3gs8eX26/pJl7pYoqyHB5Fh
         y7lEcISV7n+cjzo/CuP/SbLgVcDa4qZzvkYW7xXYoVulEzOYL6zkuQo10veQQqsAoizh
         QRmw==
X-Forwarded-Encrypted: i=1; AL+hErE97izWWPA5lEJl9T28/ET7Fn0wX3IY53Tkba7muSAFRtkgE18HGsTiyIrzJym6b0aWBFpDBg4E7DUpy+n9@vger.kernel.org
X-Gm-Message-State: APuU4Z+40z6c3mXBQ7bqg49RBIhQAQkyTYMMj0waWpmFQP9pWZvEVpXV
	mj35KX8+sXePHXCI2eq/qtfkroyekBq+YSjOZIrluYjUomG4IwTcMI7IcPNsPFj/NNc=
X-Gm-Gg: AYBFou1wfmwEdSV49smvG0xgF0wfBGeEwPYVugrDYSzBlTsJtQObuRRt23FeYBroUF1
	Fes/+ZK9liaYxeb0Bf66XLHbJY7sYRDS721oPwGfjH3HqmuBU5Az0qdDZ7pfqGsFajSQk8Rca9t
	WFm5Q1vjWlh22TYrVQVMEU+9gFmRpgHEa1LhCYRD+vIfFyDW6sQT8Ovjc+TmSFVVkQdTYbkkzNS
	29WWzPQ30J3xolve2EIQ8jLJhcC/1AiVCqyO862nRVwXykoOquUR0q9BeJB/FEhM/uxwIdkKptv
	yRFvaOrnjTx6h/ZcoGNtDrgtbr7d5yVX3k6Kjn7JXf4nJNgi4gZlOCpqx/wvCD1N05TxvNl0PSb
	LBZdJwVXc4TXK/urdse8yFPLyJ5qGigX3E/nful0dEVSecYuwNFL7mSMKb6HUw8xPUByOknlXjO
	01pkxnyHwTbmRARs+XtWPRYem6AehT2afne9A348oDaoRXLFDSJQsmg/Vro5u0bk2W3qWPZqG6j
	nIiTRO3659OAqt2hvawiD5+WnhbUq9vVetBzjCnld1DwjIVE0DJ0H6VX390l1VXXHRSboGUvg0L
	msjKEMoRou8xFRE+5AA30jX6HZX4YzRKRrrrP/q36QvdGQ==
X-Received: by 2002:a05:6122:a5c5:10b0:5ea:a0f0:1945 with SMTP id 71dfb90a1353d-5ee0d0c7167mr941852e0c.6.1794328031072;
        Tue, 10 Nov 2026 08:27:11 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.253])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ee0c58ed55sm2053453e0c.5.2026.11.10.08.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 08:27:10 -0800 (PST)
Date: Tue, 10 Nov 2026 16:27:09 +0000
Message-ID: <99629e3277656888cbe84bf7490c5e54.josef@toxicpanda.com>
In-Reply-To: <94833333cf2c5dd487022cb290174393.josef@toxicpanda.com>
References: <773faf2a275e0a51bd38cf68f492856c.josef@toxicpanda.com>
 <946b46fbf1c555a47a8a9304f2ee31af.josef@toxicpanda.com>
 <94833333cf2c5dd487022cb290174393.josef@toxicpanda.com>
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH fstests v4] overlay: test that syncfs and unmount persist all
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

Do that with fsync=relaxed and with fsync=on, which still syncs the whole
upper filesystem, with and without redirect_dir and metacopy.

The base filesystem has to have a journal, so what gets lost if overlayfs
misses a modification is data in the page cache.  Changes of metadata are
in the log, which overlayfs commits in any case.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
v1: https://lore.kernel.org/r/773faf2a275e0a51bd38cf68f492856c.josef@toxicpanda.com
v2: https://lore.kernel.org/r/946b46fbf1c555a47a8a9304f2ee31af.josef@toxicpanda.com
v3: https://lore.kernel.org/r/94833333cf2c5dd487022cb290174393.josef@toxicpanda.com

v3->v4:
- It's overlay/091 now. (Amir)
- It takes 17-18s instead of 64-67s and is back in quick. (Amir)
  - Only fsync=relaxed and fsync=on, that's 8 rounds instead of 16.
  - The snapshot is one find -printf and one md5sum instead of a stat and an
    md5sum per file.
  - One xfs_io writes all the files of the lower layer, and another one all
    the files that are synced before they are modified.

Those times are from ./check in a KVM guest with 4 CPUs, on a kernel with
KASAN, lockdep, UBSAN and DEBUG_OBJECTS. A round takes 1.8s there, a third
of that is the 40 or so commands that modify the overlay.

With the fsync=auto rounds gone nothing goes through the code that turns auto
into relaxed. In v3 those rounds never showed anything that the relaxed
rounds didn't.

This is for "ovl: only sync what was written through the overlay" [1]. It
needs [2].

It passes on ext4 and xfs with the series, and with only the first patch of
it, which adds the mount options and still syncs the whole upper file
system. On the four kernels that I broke on purpose for v3 it loses exactly
the same files as v3 in the fsync=relaxed rounds, and nothing in the
fsync=on rounds.

[1] https://lore.kernel.org/r/20261110-b4-ovl-containerized-sync-v6-0-43d1be16a4d6@toxicpanda.com
[2] https://lore.kernel.org/r/20261106155832.3867017-1-amir73il@gmail.com

 tests/overlay/091     | 204 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/091.out |   9 ++
 2 files changed, 213 insertions(+)
 create mode 100755 tests/overlay/091
 create mode 100644 tests/overlay/091.out

diff --git a/tests/overlay/091 b/tests/overlay/091
new file mode 100755
index 00000000..260978e3
--- /dev/null
+++ b/tests/overlay/091
@@ -0,0 +1,204 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Josef Bacik.  All Rights Reserved.
+#
+# FS QA Test 091
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
+_begin_fstest auto quick shutdown copyup whiteout mmap redirect metacopy
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
+	# This leaves the base filesystem mounted
+	_scratch_mkfs >> $seqres.full 2>&1
+
+	mkdir -p $lowerdir/dir $lowerdir/rmdir $lowerdir/mvdir
+	cd $lowerdir
+	# xfs_io runs the command on every file
+	$XFS_IO_PROG -f -c "pwrite -S 0x6c 0 256k" \
+		append truncate mmap chmod chown chown_append xattr link \
+		rename remove dir/append rmdir/file mvdir/file >> $seqres.full
+	cd - > /dev/null
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
+
+	mkdir $m/clean
+	cd $m/clean
+	# xfs_io runs the command on every file
+	$XFS_IO_PROG -f -c "pwrite -S 0x70 0 256k" \
+		pwrite truncate fallocate mmap sendfile copy_range chmod \
+		chown xattr link rename remove >> $seqres.full
+	cd - > /dev/null
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
+	cd $SCRATCH_MNT
+	find . -type d -printf '%p %y %m %U:%G\n' -o \
+		-printf '%p %y %m %U:%G %n %s %l\n' | LC_ALL=C sort
+	find . -type f -print0 | LC_ALL=C sort -z | xargs -0 md5sum
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
+	for mode in relaxed on; do
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
diff --git a/tests/overlay/091.out b/tests/overlay/091.out
new file mode 100644
index 00000000..a8536983
--- /dev/null
+++ b/tests/overlay/091.out
@@ -0,0 +1,9 @@
+QA output created by 091
+=== syncfs fsync=relaxed,redirect_dir=off,metacopy=off
+=== syncfs fsync=relaxed,redirect_dir=on,metacopy=on
+=== syncfs fsync=on,redirect_dir=off,metacopy=off
+=== syncfs fsync=on,redirect_dir=on,metacopy=on
+=== umount fsync=relaxed,redirect_dir=off,metacopy=off
+=== umount fsync=relaxed,redirect_dir=on,metacopy=on
+=== umount fsync=on,redirect_dir=off,metacopy=off
+=== umount fsync=on,redirect_dir=on,metacopy=on
-- 
2.55.0

