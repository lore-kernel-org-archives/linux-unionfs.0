Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794011504;
	b=brkxHIiTim1VkbsFLS82OEA5YAmQaw5ZkqnF2hHhnf0EwCCNRX027MydC5AeoNYyt95I
	 cnlnrk8aQlybNVW927x94/mQNUGRBtobqUYunTTEHtOk8DgDTVbuOkA8+T/lg40YQGOFt
	 BUvCMSgHe/IEMek+EAUozoZE2GhGBySyBZqYJ4wvIByd3j0yiMiTHkebXreWi4ei7fyqv
	 /sGHGu5DHuMOKVi78Nn3oMDEa/xsYIx5j3YdDDQTczcZx5mzw400LyDmSczSzesh6lVSw
	 AcUhAU2AxIkpB464SKNJPinqGTejWmPZnwB2r38il7QgFJ68ZAap36yx8kipteL+8+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794011504;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:Message-ID:In-Reply-To:References:From:Subject:To:Cc:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=LDguwGrSBxdmZQBN3HIv1p+8YUY4bhTPUTj+F2Sw6mA=;
	b=Lv8utkvyNgGseG9Nol6SJWQAbS9wdLlO+OzD2P7lakrKMyqnB0cGK3nyf5kVCNBOin5f
	 R7pdOzaeSgzM6JJK2L9c2HXVI4RbSYeI7jqWZXWjE/cI0Yn40tWvlo9KHhTgkLPwF0FaB
	 yfR2zIVbJz49nhttOPgGnJYUEslJqhJULt+Lg/rqLwD85ijtqAOqC09kuX/oHZAQJ4AbK
	 Kq/TcS2Z5HkrflAqUVa0h0UP5DgrPO/0jpwAPSbKgadH2wz4EVwV05gu+4fV7TyU2ejt8
	 Wpn7t4sO/C6idRY209J0lewRzsqYstrPJlHa/eaR0aWUxrRnrUxkbBRgUGWQEBnKA4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=roP2jb5z;
	arc=none smtp.remote-ip=209.85.219.43
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BADF606A32C
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 00:31:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BADF606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=roP2jb5z
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-91ccfb88e4dso13834096d6.0
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Nov 2026 16:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1794011503; x=1794616303; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:cc:to:subject
         :from:references:in-reply-to:message-id:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LDguwGrSBxdmZQBN3HIv1p+8YUY4bhTPUTj+F2Sw6mA=;
        b=roP2jb5zXZx4Z/cevpFgeuWFOm0sxH7qfgbxJeR6FAur2B8cbtwDwXTuiCzm4QwqPA
         ZEu8cP0oeV8areKQCinpcBpB/CAWVcnbpS34JpBvYPLmO9Oacrk32wYxbqh5VmCK7mQi
         wOr2LlLETeqqQleSzSf101J0F+wTCMwYR6KSyDN10ACm4bFVQMaNPjP5zI/IkMmB+SA4
         Keyt9706FafjyAtQmSo+RecWasLWtLKm9RnvX8RdfE4unizK/H2ixvZtW5JZDXZef8cR
         TAYL711FeVGsz0FZEbAD7ib01AhWp9pLLgkOWwoWxJBZjbk4mAvn44q74CSJWOFZN8DN
         qSng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794011503; x=1794616303;
        h=content-transfer-encoding:content-type:mime-version:cc:to:subject
         :from:references:in-reply-to:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LDguwGrSBxdmZQBN3HIv1p+8YUY4bhTPUTj+F2Sw6mA=;
        b=2tGuiGqgdOcgSr5+f4c2rZAwuyuHLQS0kmGPQ1rCf533gpcHjoaVWpEUgnkT3aa6y6
         Op+Vd+8Pc5ZY5AQq1JUoZ35369xNV4gVm6y83x/I9xtCkrYFr6Ebk+RLWCcq/0GvnAvx
         R5+n5ik8Ga+tNvhOgLOUT5WIFXmnMmGl/EByaorfKmjgmrjZqQ+lLosADChuzXlZp1Po
         U9xo8qBMaOi6OIFfdTWyHlmw1DA6BE5YD4vbw6IBOTE8O53uCLkhk3zqg8Dq5LJXPZS0
         WwEwF24he+EcgpitIkhwwPQxc1GTQVQtl0p+DL8vm/2kbL0PL/tIPJdJ51Xe3JxsSE92
         UYaw==
X-Forwarded-Encrypted: i=1; AKwUvBwvubBCrOcgM2ZIK0BYvtsaUtP/pYJDp4c1hKbarKVU1+i2Y5nyd/QZlGUdA0Y2h8crSwQL4FugXdXQXqb3@vger.kernel.org
X-Gm-Message-State: APuU4Z/RmnHD+8OOsLjpNI2EefoKlpHrYvH8U4jReZZueG8I3pvh98KC
	SMbjWNfHMk7s+/zA5NlXaGhL5M/KYCzxAZP2VLYQUN121Mn2B3zIGLU4kF5WN1KhIL8=
X-Gm-Gg: AYBFou1Y6oUjiSUYl8p9CK8Pg/zTmLvHfKn51kPt6C5N3cekG/sG75XEeFhMmExjApd
	6mFKbBzjWnSVIopJWUTgrtmdHt2dLP8UAdPimrq8tSlxtKWPU8O3O8UW1I2AHPIGE4zbfT4kYZu
	t82X8W7ZVDHGlCCQFyAwln+mI10ytO+gmYVOVWmja2RydyZIMKoOPMYQ7up6IYOHlxKgC8m+Yoc
	ac3s160FXexVZIS25gCLQS6eSLTWv1wVybK/lA4j5WWMIW4fVOKGmHZeBK+6NZGztVTtlnMmF0G
	1lr1sU2VvX5f23Zq/oC0W+JL2TqC2yBw7bMzEL+UQXuAUbY5GDmOTi3sl75NSGDK55R8NnelyLa
	eLt4vXwVKag/WwcM7S1Q4lLMppw/NsQ3Gmfyd4MTgW1iWLhMRIHg8Ig4Ys47XY5heLYBa1wrqMV
	Q45HCTUmnGq2xeLmw06eG6sKIR37zTpYVfNhODolH4pbYMFLDBJt+gVHEQ6Orl9NP8yTdgmX8iP
	pk6PFAIZRkHTHdVUBRsCMCp6B5A17+ox5Aj9Dap1wdaMZgucrJq7tzIueMI46kQ82OxMtkXJvQz
	kpAH/V2ZI1TNG61relrE1gpmTXgff9Cxeh5mFBd8lTD2+A==
X-Received: by 2002:a05:622a:2485:b0:53f:a444:dc7c with SMTP id d75a77b69052e-54e156631cemr63284951cf.56.1794011502798;
        Fri, 06 Nov 2026 16:31:42 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.247])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54e26835bf8sm32811911cf.19.2026.11.06.16.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 16:31:42 -0800 (PST)
Date: Sat, 07 Nov 2026 00:31:41 +0000
Message-ID: <946b46fbf1c555a47a8a9304f2ee31af.josef@toxicpanda.com>
In-Reply-To: <773faf2a275e0a51bd38cf68f492856c.josef@toxicpanda.com>
References: <773faf2a275e0a51bd38cf68f492856c.josef@toxicpanda.com>
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH fstests v2] overlay: test that syncfs and unmount persist all
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
an O_TMPFILE, a short and a long symlink, hard links, renames, whiteouts,
a file written before the inode caches are dropped.  Then sync or unmount
the overlay, shut down the base filesystem without flushing its log, cycle
the mounts and check that nothing has changed.

Do that with the default mount options, with every fsync mode that syncs
and with redirect_dir=on,metacopy=on.  Options that the kernel does not
know are skipped.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
v1: https://lore.kernel.org/r/773faf2a275e0a51bd38cf68f492856c.josef@toxicpanda.com

v1->v2:
- Added a symlink that's too long to be stored in the inode. (Christian)

This is for "ovl: only sync what was written through the overlay" [1], Amir
suggested a test like this in his review.

It passes without the series on ext4 and xfs, there it skips fsync=relaxed
and fsync=on, and it passes with the series. With the series and the
function that marks the overlay inode dirty turned into a no-op it fails in
the default, fsync=relaxed and metacopy rounds, the file data is gone.

[1] https://lore.kernel.org/r/20261106-b4-ovl-containerized-sync-v4-0-6ddde0b7dd8a@toxicpanda.com

 tests/overlay/118     | 182 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/118.out |   2 +
 2 files changed, 184 insertions(+)
 create mode 100755 tests/overlay/118
 create mode 100644 tests/overlay/118.out

diff --git a/tests/overlay/118 b/tests/overlay/118
new file mode 100755
index 00000000..f9c98eff
--- /dev/null
+++ b/tests/overlay/118
@@ -0,0 +1,182 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Josef Bacik.  All Rights Reserved.
+#
+# FS QA Test 118
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
+_require_xfs_io_command "syncfs"
+_require_xfs_io_command "sendfile"
+_require_xfs_io_command "copy_range"
+_require_xfs_io_command "-T"
+_require_xfs_io_command "flink"
+_require_attrs
+_require_chown
+_require_mknod
+# These never sync
+_exclude_scratch_mount_option "volatile" "fsync=off"
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
+modify()
+{
+	local m=$SCRATCH_MNT
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
+	# Stores through a shared mapping, also after a syncfs, no msync
+	$XFS_IO_PROG -c "mmap -rw 0 256k" -c "mwrite -S 0x66 0 64k" \
+		-c "syncfs" -c "mwrite -S 0x67 64k 64k" $m/mmap >> $seqres.full
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
+
+	# An overlay inode that nobody holds on to
+	$XFS_IO_PROG -f -c "pwrite -S 0x68 0 1m" $m/evicted >> $seqres.full
+	echo 2 > /proc/sys/vm/drop_caches
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
+	_getfattr --absolute-names -n user.test xattr 2>&1
+	cd - > /dev/null
+}
+
+# <syncfs|umount> [mount options]
+do_test()
+{
+	local how=$1
+	shift
+	local label="$how${*:+ $*}"
+
+	echo "=== $label" >> $seqres.full
+
+	create_lower
+	if [ $# -eq 0 ]; then
+		_scratch_mount
+	elif ! _try_scratch_mount $* >> $seqres.full 2>&1; then
+		# Not every kernel knows every option
+		echo "cannot mount" >> $seqres.full
+		_unmount $OVL_BASE_SCRATCH_MNT
+		return
+	fi
+
+	modify
+	snapshot > $tmp.before
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
+	_scratch_mount $*
+	snapshot > $tmp.after
+	cat $tmp.after >> $seqres.full
+	diff -u $tmp.before $tmp.after | sed -e "s/^/$label: /"
+	_scratch_unmount
+}
+
+for how in syncfs umount; do
+	do_test $how
+	for mode in relaxed on strict; do
+		do_test $how -o fsync=$mode
+	done
+	do_test $how -o redirect_dir=on,metacopy=on
+done
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/118.out b/tests/overlay/118.out
new file mode 100644
index 00000000..3daed864
--- /dev/null
+++ b/tests/overlay/118.out
@@ -0,0 +1,2 @@
+QA output created by 118
+Silence is golden
-- 
2.55.0

