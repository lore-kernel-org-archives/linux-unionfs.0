Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793438403;
	b=4+Hfn0MmcFUsXB7xWIIqWPhrfiDuzyDVl0Fl8ny27rZAWN0AnfXEPMHRwRnxlBpBo93u
	 aInbUQbPmhbM05MlcL2Rr3LHAnB2CTXwGQxMHz8b2mUcYx4cwAUPy+ZAUX2vszn1/POkR
	 qy1oQwe8ZuH2yggbAtzeo3DZmFR+Yo4U+ejDH0Zv6aEzwrhCQAQoxw2Ya47OAo5A+FSeJ
	 cvK8zzcxuBgMY8Ph88iYNZ7daTH0G97jhxhTWV9PIHxIn/VpQxkkfXFmgdTSTp8eR1gfX
	 I7Q8xa1LHxZUtZ2yOA3XTVZjhzqYeeCWHw5xTf5dlkZFW0OmClXqrMq+CTjojpEwbtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793438403;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KSoziBNNM6XF3aPmL8wbAp4NVFuwfQI3B6uqYIN7o88=;
	b=Y8jRGqzbIXWYxa47Jcz6v4b+nfXBDPcfDCKS4OuEy2woMcfAZW2M8rMKeYwmMRGTGRdv
	 lGkGDyMKCjHGJjkJepOiRL8ip9FQPB3hU8CCtuYKASygnsPRkiIpBtxSaGYs+e3TTsFKD
	 bNIgsmhDnF2LZeaLqNHgXE1Iy0EIYWxOgQizmXrrDY9SEPuR9y2fBXawkGJT95KCLyqnH
	 dZLvsol47VEHRTS3A2IYPJGp9/EPe9sbzCmBRBwz1aC+NB1ynlJMEdFWGMJgsVbbqsqVo
	 Y7K3YRZDB1T4CT5KcxHWVklwd5xnmnQLasG7Ydv0l6vQCeL+rXJAlXgEB6JnNL4dajA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=O+NakXby;
	arc=none smtp.remote-ip=74.125.229.5
Received: from mail-dy2-f5.google.com (mail-dy2-f5.google.com [74.125.229.5])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC47E606A320
	for <linux-unionfs@vger.kernel.org>; Sat, 31 Oct 2026 09:20:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC47E606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=O+NakXby
Received: by mail-dy2-f5.google.com with SMTP id 5a478bee46e88-3535a54c09bso1378913eec.0
        for <linux-unionfs@vger.kernel.org>; Sat, 31 Oct 2026 02:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793438402; x=1794043202; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KSoziBNNM6XF3aPmL8wbAp4NVFuwfQI3B6uqYIN7o88=;
        b=O+NakXbyy8I2zZ37daWqm6F4kA6uC207fionLtLVvRlA64BnBkL3tzkYwsexX+bvam
         CLuZtA5lqCccaDVnwYAjkhvJkvxtu6MTMGEtyQXOl5BI13vZqcIsqqkfiunPyJaAv6nt
         HiPVNGQAemvM745Z33l6YYrJGQmYbpRnDarz8LYk7oda4MoAV3F/JMi9/4S94B8t2fRP
         gSNfOZBfT0qSsr/wan7zKp9GdiKORjJpv2TfeI/iUgJKxxixeYD8Qb6gF+SZ2K9q32mZ
         moNS4b5j3LmRwIygmNUops4sqlI117aENmJbjwhqCRKmCij+9yWfdcfP60kzzT1+Ur9q
         hPDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793438402; x=1794043202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KSoziBNNM6XF3aPmL8wbAp4NVFuwfQI3B6uqYIN7o88=;
        b=whvYg40effF0nkh+bBLAFHMZ/rkiOfGdK3fMpS8joE+IDtLUx0ahcJYWF5qGZ7OieD
         q+qgWpIYuq2VT13JIWTA58348pvPULcsMjG6/2pNPckB5qr0enirV3r1KdKzRcXSrq3a
         jIcNxgm6M2mq5muUpZoN5cFJur9a7MENxgvUoj+Fzh6lHYijAiDo2a/Zqli9b5Z0f6z+
         yHmchT8GlnhnlJy5PGUBqn/NIuhXeqNG6SDIS2u1vmekkGLdAtS5R6I+yjhU5w1R58MO
         +gLgLhvPTM40b0TBjAYnDfpcTioFVTHXd/74ibfG3fxseqvbL+rBe7RMPr+lq9BG7eCD
         7/JA==
X-Forwarded-Encrypted: i=1; AKwUvBxOXLmoPbSHcYykR/+W/PsxiJm4eK5YabFwtFV1hUs/oSI9M8haiigSlyEomuVqV/qAoLJFXadNZtb9T21K@vger.kernel.org
X-Gm-Message-State: AFq9FYKMaDb/pBMi9/WS4Vo9PW+HwTC3JEcIF+4XDo9XTodU5YFjg2/9
	m25xF3OcblATHAiGCtkEgi8pb3HjsDrrPYy4yKuTASwdlGu33CTshWos
X-Gm-Gg: AYBFou2s8zbtxV/mbL/2eYCsxjxvtNJ1/etcWj3RvlEV5BMVjRSdfcJiAlZqoqhYyY0
	Z2hCc3497QH52AOzR9SVRS2wYGiaQY4MTmqMEON9ftpRf7DsfFpeCzZldrIGxpo4lfdlJazCKh5
	D2O8Tf1G74/jq52xv1nwu0XIXiE103RXo6APVzaCbCL4rlXdNBeZhtOcHbW0o8hrvNw7GmJoUbZ
	j5nvVNlbwss0L4StiYeOdk/kTiLRIk8Iyeu2PPgjxRr3gHWonaP6eaa5NFpqQ00zQrRJcBPCFCL
	7qoDwxC7gBz1j9wB0SYLWaXHI+DWLUYyw7jjMLG81UaM5K8gmNAPFoW2UZItuKZAfnMXHIUMOL3
	cAlE5rZ9C3iKBxwFNQIRhqG//qpVXlIu9xm66OAiAutI/CsRbs3XPAyYSTxX9DyynNziFmpRI27
	sQ7kZtuUy+qXdPuWR/lUeevZqLA3tD3M/jwN3YYhlis2M4mvIrvDxIE4LGHwfuxFrUACCdXHytE
	fwI5PuoFIz/aLNSh/NnHC/FfYQWMLYS+dsvNkT655/2wRvn9XOVh1hqhTf4WRWG1lp5lpq2bueG
	P0zfCMZkknXSsuW7PcdLpU+C6AszZWI6oVtyoJRLaXshfpy1Szd95FSU
X-Received: by 2002:a05:693c:835c:20b0:36a:30b:5dc0 with SMTP id 5a478bee46e88-36a423c338dmr6804353eec.24.1793438401775;
        Sat, 31 Oct 2026 02:20:01 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428ecb61sm13067963eec.10.2026.10.31.02.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 02:20:01 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	amir73il@gmail.com,
	linux-unionfs@vger.kernel.org
Subject: [PATCH 2/2] generic: test whiteouts on casefolded overlay layers
Date: Sat, 31 Oct 2026 09:19:48 +0000
Message-ID: <20261031091948.18985-3-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261031091948.18985-1-dennylin0707@gmail.com>
References: <20261031091948.18985-1-dennylin0707@gmail.com>
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

Whiteout creation in casefolded directories can fail when removing
names that exist in a lower layer.

Exercise unlink and rmdir for lower-only names, a copied-up file and a
merged directory, including lookups with different ASCII case. Also
recursively remove a populated lower directory. Check that removed names
stay hidden after recreation and a mount cycle, while the surviving file
and the lower layer remain unchanged.

This covers "ovl: fix whiteout creation in casefolded directories" from
the casefold fixes series linked below.

Regular-file lookup and copy-up also need the separate "ovl: check the
casefold flag of directories only" fix, included in the tested overlayfs
ovl-fixes baseline at 1d27da7de3f7.

Link: https://lore.kernel.org/linux-unionfs/20261030113201.2921633-1-amir73il@gmail.com/
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 tests/generic/999     |  148 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999.out |    2 +
 2 files changed, 150 insertions(+)

diff --git a/tests/generic/999 b/tests/generic/999
new file mode 100755
index 0000000..75e13b5
--- /dev/null
+++ b/tests/generic/999
@@ -0,0 +1,148 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Hungyu Lin.  All Rights Reserved.
+#
+# FS QA Test 999
+#
+# Check removal of files and directories from casefolded overlay layers,
+# including copied-up files, merged directories and recursive removal.
+#
+. ./common/preamble
+_begin_fstest auto quick dir casefold
+
+_cleanup()
+{
+	cd /
+	[ -n "$merge" ] && _unmount "$merge" 2>/dev/null
+	rm -f $tmp.*
+}
+
+. ./common/filter
+. ./common/casefold
+
+_exclude_fs overlay
+_require_extra_fs overlay
+_require_scratch
+_require_scratch_casefold
+_fixed_by_kernel_commit xxxxxxxxxxxx "ovl: fix whiteout creation in casefolded directories"
+_fixed_by_kernel_commit xxxxxxxxxxxx \
+	"ovl: check the casefold flag of directories only"
+
+mount_overlay()
+{
+	_mount -t overlay overlay "$merge" \
+		-o lowerdir="$lower",upperdir="$upper",workdir="$work"
+}
+
+check_absent()
+{
+	local name=$1
+	local ret
+
+	stat "$merge/$name" > $tmp.stat 2>&1
+	ret=$?
+	echo "stat $merge/$name: exit $ret" >> $seqres.full
+	cat $tmp.stat >> $seqres.full
+	[ "$ret" -ne 0 ] || _fail "$name: expected ENOENT, stat succeeded"
+	grep -q ': No such file or directory$' $tmp.stat || \
+		_fail "$name: expected ENOENT, got $(cat $tmp.stat)"
+}
+
+check_view()
+{
+	local phase=$1
+	local name
+
+	echo "Checking merged view $phase" >> $seqres.full
+	for name in lowerfile anotherfile copyfile lowerdir mergeddir tree upperonly; do
+		check_absent "$name"
+		check_absent "$(printf '%s' "$name" | tr a-z A-Z)"
+	done
+	cmp $tmp.data "$merge/keep" >> $seqres.full 2>&1 || \
+		_fail "$merge/keep: not readable with expected contents $phase"
+	ls -1 "$merge" > $tmp.names || _fail "cannot list $merge $phase"
+	printf 'keep\n' > $tmp.expected
+	diff -u $tmp.expected $tmp.names >> $seqres.full 2>&1 || \
+		_fail "$merge: expected only keep $phase (directory listing in $seqres.full)"
+}
+
+_scratch_mkfs_casefold >> $seqres.full 2>&1 || \
+	_fail "cannot format the casefold scratch filesystem"
+_scratch_mount_casefold || _fail "cannot mount the casefold scratch filesystem"
+root=$SCRATCH_MNT/ovl
+lower=$root/lower
+upper=$root/upper
+work=$root/work
+merge=$root/merge
+mkdir "$root" || _fail "cannot create $root"
+_casefold_set_attr "$root" >> $seqres.full 2>&1 || \
+	_notrun "cannot enable casefold on the scratch filesystem"
+mkdir "$lower" "$upper" "$work" "$merge" || \
+	_fail "cannot create overlay directories"
+
+printf 'lower data\n' > $tmp.data
+printf 'upper data\n' > $tmp.upper
+for name in lowerfile anotherfile copyfile keep; do
+	cp $tmp.data "$lower/$name" || _fail "cannot create lower $name"
+done
+mkdir "$lower/lowerdir" "$lower/mergeddir" "$lower/tree" "$upper/mergeddir" || \
+	_fail "cannot prepare lower and merged directories"
+for name in one two; do
+	cp $tmp.data "$lower/tree/$name" || _fail "cannot create lower tree/$name"
+done
+cp $tmp.upper "$upper/upperonly" || _fail "cannot create upper-only file"
+mount_overlay >> $seqres.full 2>&1 || \
+	_notrun "overlayfs does not support casefold enabled layers"
+
+# Copy up through the overlay, without changing the backing layers directly.
+cat $tmp.upper > "$merge/copyfile" || _fail "copy-up write failed"
+cmp $tmp.upper "$upper/copyfile" >> $seqres.full 2>&1 || \
+	_fail "copyfile was not copied up with the expected data"
+
+# The first removal is a control that does not need a lower whiteout.
+rm "$merge/upperonly" || \
+	_fail "cannot remove upper-only file"
+rm "$merge/lowerfile" || \
+	_fail "cannot remove lower-only file"
+rm "$merge/ANOTHERFILE" || \
+	_fail "cannot remove another lower-only file using different case"
+rm "$merge/COPYFILE" || \
+	_fail "cannot remove copied-up file using different case"
+rmdir "$merge/LOWERDIR" || \
+	_fail "cannot remove lower-only directory using different case"
+rmdir "$merge/mergeddir" || \
+	_fail "cannot remove merged directory"
+# Removing the children leaves whiteouts in the copied-up directory.
+rm -r "$merge/TREE" || _fail "cannot recursively remove lower directory"
+check_view "after removal"
+
+cat $tmp.upper > "$merge/LOWERFILE" || _fail "cannot recreate removed name"
+cmp $tmp.upper "$merge/lowerfile" >> $seqres.full 2>&1 || \
+	_fail "recreated name is not accessible with different case"
+rm "$merge/lowerfile" || \
+	_fail "cannot remove recreated name"
+check_view "after recreating and removing a name"
+
+_unmount "$merge" || _fail "cannot unmount overlay"
+mount_overlay >> $seqres.full 2>&1 || _fail "cannot remount overlay"
+check_view "after remount"
+_unmount "$merge" || _fail "cannot unmount overlay"
+merge=
+
+for name in lowerfile anotherfile copyfile keep; do
+	cmp $tmp.data "$lower/$name" >> $seqres.full 2>&1 || \
+		_fail "$lower/$name: not readable with expected contents"
+done
+for name in lowerdir mergeddir tree; do
+	[ -d "$lower/$name" ] || {
+		stat "$lower/$name" >> $seqres.full 2>&1
+		_fail "$lower/$name: expected the lower directory to remain"
+	}
+done
+for name in one two; do
+	cmp $tmp.data "$lower/tree/$name" >> $seqres.full 2>&1 || \
+		_fail "$lower/tree/$name: not readable with expected contents"
+done
+
+echo "Silence is golden"
+_exit 0
diff --git a/tests/generic/999.out b/tests/generic/999.out
new file mode 100644
index 0000000..3b276ca
--- /dev/null
+++ b/tests/generic/999.out
@@ -0,0 +1,2 @@
+QA output created by 999
+Silence is golden
