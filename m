Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793977491;
	b=sZVDzWhIuNIIm9+26mLch1TV4wCOj/+qFFfV986khiDpeHHIneL/qkdaGQ8TcWDOwnVn
	 K5e7JTH5dFlLa8j47juTtFnLPpWlWxHHiFGWERGJhhhIxRCm7lKDsMufTIJd6tBFioEgW
	 OiTQT5l2GkJutIJHshqrdQz3ep1Ox5T0MPIMiCVwACzZgmJ1tzxBw8qjHbCYHv9WqqKvb
	 QxWNXI9tB15pZjs/BP6FF8RY3drQJIj8oP21Gm0x3Ao4tSKZeJjAuTmA049O/oNfru5Gq
	 vbrXWOzafO/i311xEGe0WfI5b4Azbl5xG+FoiWYhb2/Ji6KCb97TiuW5xKLdou0WJDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793977491;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:Message-ID:From:Subject:To:Cc:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=osUGiBYO++jmzwgjV1q+vpCIJklcqDLlUevv7q/8lJ8=;
	b=OGEDgCMSW70VlviEjbDzzXWhCUeAZk1Tcw1V/hAnpwXKBxKDeHS7m9v2Vsz9hGCJPCY2
	 PA+GjYx2vktWFP5IYer7CuyNASo+WmEllFY9tZytC2+/O6q1OggRcyskRKNsA9zeV6qC2
	 c/46viURc+Jn4VcAa5uJ7q7BnuxAq2rbxy21X9juJ0fH9hLKtyQoa4eBTajPJGPMOoHJ1
	 mp84CQVrZE7PiubSEg2mTLE9U+8mlZYRW4HOADR/OtW9Yo6bSA+QMa6ngZOfjaQSTIjFc
	 dg7l9CRJBvoWPqc6SnkOLvWXF9cv+5clX4NvHaZZ8fIQmes+oHyS3L/YrkapX8wYRrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=hronv365;
	arc=none smtp.remote-ip=209.85.160.179
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB73606A329
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 15:04:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BB73606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=hronv365
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5365d725440so5965591cf.0
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Nov 2026 07:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793977489; x=1794582289; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:cc:to:subject
         :from:message-id:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=osUGiBYO++jmzwgjV1q+vpCIJklcqDLlUevv7q/8lJ8=;
        b=hronv365PmnuJpTpgwn77mWjRX8H7rQhSPym5savjx6/KsmnzUwbuYxONptwC/P+4a
         v1qK4Lg4hjYSI+K2LMXQe8jQVn0gFLQn9asKETbMvivRMIDOelMVbSfv09ATleY8Jsxg
         WpeS5eVSN5b4bMoLY59ll4kGJ9cZ7/nRVzMwIoTVAx9Xf+jIfkytCNdCoFRj8XZVe5+1
         6DNRW2thk1MON+r8CBaNCEH8cdRadcYK6NBVvxo8Wn3y7ZMW6C4ZWFx06UfHwWTQYTsb
         gxtKoE/sMQaBCZ94565uA1SGfxtMcWLiGEqXfYdlGfUXwUH3nJ1jXUtMa2RGOFMYRCZj
         73gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793977489; x=1794582289;
        h=content-transfer-encoding:content-type:mime-version:cc:to:subject
         :from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=osUGiBYO++jmzwgjV1q+vpCIJklcqDLlUevv7q/8lJ8=;
        b=gHki1Czq/pQSP/UJP5MBCeAzDLNHwzJCEJH/euuy4kbd+xpTP2uLh0UqtwDPMaHhG4
         YeDdtNPbPah26FWq1XHlSF0m12RPo6B320QiTQuR+yw7LPSp482XWHXjgX8fxtV7gXBr
         Qqeed+FdMmbBlMnIX0oLUGp+1ZWvWuO61UvE4XT91P3PE2JsxMOc6R/dH5AssmrzFVnU
         wdn/tu0aMET9Lkqw6DUeKrPoOSRCSKVWpVVNzwBbL+dVM7++9cQKDWfvjngNkFVQ8QZ+
         pRhG6fQmdAD+2j5xQeC8Z/baiqUxrjntrNbkn2u0biHNaHUD9DUYRF0aXeq+sEuDrq/Y
         y5yA==
X-Forwarded-Encrypted: i=1; AKwUvBwF/XxAoYoGK9y+lu7xZofOVmFR69JBi56o4WB5mUFRk57n5iU1oUmQMk2edziYs+W8lt0F+c8UE1oO31z/@vger.kernel.org
X-Gm-Message-State: APuU4Z/L5EGNZagmw83jWQcLwHYvefFRxmxgEeFBbyK8rnfEyn0+3QcG
	hsz8RX0uc9aS9XvblM8ffvAr1clvwPskuA89feivriphQnjV7J4ciKKcBGOZnu98ujE=
X-Gm-Gg: AYBFou1cSO6bwx4HiBdJeLfBhp3xRhLBV4SA7qAnPlNC+53OtGtffcpi7QLK2IxivF6
	rUhsetMofUU8sxvh6Ihu4GyutdNgd6CO1Ez41cU2yGN2zzSEr/F2jNH1cM73YbXbjp7s3yX7e5E
	Mr3mgn8/ErTLKwPdLu+yj6LJ0H+J0O691eWvlD2Q+SdoZLvDWl4UzpR0SlbK73Lq2KUrfX1V3qW
	BL3miFkMHvWn9mWOjgjXCEJDAmS5K82tZYxmBrwEOjRKv8f5niyvsYJJbEYE0QdWePl6A+1LYGH
	a2DkJGM0IcEH4up4474OE5OCwm3Vo1T51OExEDmxoDfh+0U0qwCLrKUBqkmiJyEWSUGIEJv2i6t
	LEsUp7qgDUyrIa0iRsG2x0CVaqkRERskHoJ1y112YQGeHSIUhusuOAh/76D5rEMSeecEP7RjYs6
	a5sY7fMtBnks0a3UXsqmTJbqgTYlxiE8FidWrmxNM9qPbEaVmJcN09ER6vfSibsWEaHwo6Wujqh
	x6kxmaPUlsNJBpHFlK4Ebp+IYUqX7+trAg6ySNVhNecy6qMq+S3NanxYPRXSmr7n60/DP+7kiRc
	JZv7P8jTin9spi4dXeeY96X0tmkJjfPSLh48ZP++r3VIjA==
X-Received: by 2002:a05:622a:2592:b0:533:3a14:6a2e with SMTP id d75a77b69052e-54e130945c1mr42726921cf.17.1793977489385;
        Fri, 06 Nov 2026 07:04:49 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.249])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54edd55b971sm9255121cf.10.2026.11.06.07.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 07:04:48 -0800 (PST)
Date: Fri, 06 Nov 2026 15:04:47 +0000
Message-ID: <773faf2a275e0a51bd38cf68f492856c.josef@toxicpanda.com>
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH fstests] overlay: test that syncfs and unmount persist all
 changes
To: fstests@vger.kernel.org
Cc: Zorro Lang <zlang@kernel.org>,
    Amir Goldstein <amir73il@gmail.com>,
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
an O_TMPFILE, links, renames, whiteouts, a file written before the inode
caches are dropped.  Then sync or unmount the overlay, shut down the base
filesystem without flushing its log, cycle the mounts and check that
nothing has changed.

Do that with the default mount options, with every fsync mode that syncs
and with redirect_dir=on,metacopy=on.  Options that the kernel does not
know are skipped.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
This is for "ovl: only sync what was written through the overlay" [1], Amir
suggested a test like this in his review.

It passes without the series on ext4 and xfs, there it skips fsync=relaxed
and fsync=on, and it passes with the series. With the series and the
function that marks the overlay inode dirty turned into a no-op it fails in
the default, fsync=relaxed and metacopy rounds, the file data is gone.

[1] https://lore.kernel.org/r/20261106-b4-ovl-containerized-sync-v4-0-6ddde0b7dd8a@toxicpanda.com

 tests/overlay/118     | 180 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/118.out |   2 +
 2 files changed, 182 insertions(+)
 create mode 100755 tests/overlay/118
 create mode 100644 tests/overlay/118.out

diff --git a/tests/overlay/118 b/tests/overlay/118
new file mode 100755
index 00000000..796f6d7b
--- /dev/null
+++ b/tests/overlay/118
@@ -0,0 +1,180 @@
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

