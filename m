Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793438402;
	b=PlaZWfsnnkzp50k0pyJ4jyaGsn4Q0dG2FfkjpTbbWlkoCQltT6h19us2P7NWVa5i81Ob
	 YVa8lIlmJ3NPuZVNA5TFflowyK/CGcBHz06f4epbLc+OncN/BmmnJyQQwcXJGt2TIvjOz
	 /dHhK+6XV4lI9NL6bWIPT5NS5jPkoonk2PZSW3CbmsJ21GdRnzWo2gpLP1AlAIq57vkpE
	 DDZlvSyuJ/JU/BUo/X7eOFjMEUcqeSbmNF/SPWmGn6Gva3tbIL8F1sqinl8WVpNLccggI
	 uuNvQhlmcw6vdy1Kzq57CBeP4kCBSsf3lwN/HUmtWF5jUe70L+KLk9AbyMRxAZiZsQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793438402;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sXa8NcAOO754HFnVnKwwHhECD80G35+p5p2uIIRg800=;
	b=ZxjwGAvbHAanpQkGeK712+apTB7QKLJrOZe7edliPtXURoTl++KstkCCbEyfX8hSQxAa
	 iSc8XXoDu2ZOPyUOtUeB7Y4x/jsk5q0K8PnE33CUbG0CLNfpFUmRtj4vFNVI89lpC7aSg
	 0VDhHkhE5ypzQ2A4MOLnAQueS5Fm/XYgaNTCiKkuq8chAqn7mAt/zmiYl1dHNnjRPaEXA
	 txWV4bkkFpjsZp+g3ACeM28YamDACe5TwH7FLv0c4UOqJnVPTdZQw8vlafGlfJXwXcPOW
	 G4Xt9O/bUKbAKRPRgXhC8PC+sypQ7Z0Q0OVnvDpHc/uB1GRAlZyrYZMKHGMFEtNkjqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Utko9KGN;
	arc=none smtp.remote-ip=74.125.229.5
Received: from mail-dy2-f5.google.com (mail-dy2-f5.google.com [74.125.229.5])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40BC606A321
	for <linux-unionfs@vger.kernel.org>; Sat, 31 Oct 2026 09:20:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E40BC606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Utko9KGN
Received: by mail-dy2-f5.google.com with SMTP id 5a478bee46e88-35dc2af1f2fso641846eec.0
        for <linux-unionfs@vger.kernel.org>; Sat, 31 Oct 2026 02:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793438401; x=1794043201; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sXa8NcAOO754HFnVnKwwHhECD80G35+p5p2uIIRg800=;
        b=Utko9KGNCUfOVKVXVABbtGKIL/gT7ZlXiEZ1TTB5zr7gWEUFYDJcJ7z539jLV6KSKy
         8l87l3MLobAsK+NG26shmrEoZ1/33OKfMBpLnArl746/AXYKszYay1Y2nMp9CtWyZ4Ht
         Bz1RbrAPf7pjoCy7YvjGx57R9riqwnI/VCsY3EAyKP0YL3jG1c9X+YFXgkM6Z3Fk1uca
         SJMCImFM2ge7ujw1v+qNqEZnUmaYn3fvA4yHzrTsBBCLUIjXZbE8sNre2chbWMRK6jWD
         cKWXH8BG5mLMZcvZ4pzntl/UX4ai5zXqAxH0Iw8B8BIxZomo1x24xUAZo3NoA9UN4q3M
         sUwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793438401; x=1794043201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sXa8NcAOO754HFnVnKwwHhECD80G35+p5p2uIIRg800=;
        b=WMah5hpX9UfCDVTq0KebeApdAMXtZ/BPG+VM74RtYYr2GlcD6Wf0N4NpSG/DXxk/jV
         eiOgxxblw/ikYZacdcXs7Em9zgkTFchhrUS/yu1FPqMJPm67ERJYnVpfkF0IgTFgBI/a
         IReQMw0lHvFzx42EIo1pqK6GnBdGvazHjlu7tsnxfvRC5a5zZkyJ6DyGD3ECBk61L6a6
         lVVYsOtHcLZ1JthWwOaw5V2wLzsyPYCx35coiR1PGGcQWXs/ZyqrktqmdmSYm7GLRATw
         mmsJJH7pbNu9uJDe+bzBWLnxl9kJ5MANySL9N7ZlprcPLAOip4gOEYQWOZjjp20JBs9F
         M6cw==
X-Forwarded-Encrypted: i=1; AKwUvBzuPZk+Xx+mLSBKvitVr5PbrVsAgCJrt4hcmEyLR6tzEiZBh2Odc3v0UNszZtDqaYM4t6+SAVa6FUdIyAU0@vger.kernel.org
X-Gm-Message-State: AFq9FYKucq6HNgebbHhgIGmSEujm4C3AraCugCLZ9UfQSUFpid5RNQ0H
	0NruJJsG0bQ3d7O5sDlnfL/e2d/IDn8VALJQHeObFaz/TKRrLDVBx2kx6Tr10gcC7fQ=
X-Gm-Gg: AYBFou2AJ+XUwsQn9CWKfu7MmIvCdQzyNvknaVujLwOtPn8U2w6XwA0ZcXiD70O1vnc
	q92wiLnpr24/hrQm0SNiEEErSJy38pz/53HgmwhjthkF/0N4IaHHtJD4eMkKrUkQTOPvdVeUAuO
	mbNcO/r1bsomFOQFHDujhpp9P6xmfTF1GKqZURxZMN5+V9QYiIPilfm7exgVM/AH8hcinuf3FII
	3w8Vwk94MPA9ppQqAS10tFXE9AeZYdlJxLu/F45cWipsVjyK95fsKxWm2Xe8Jp9oGHZsKEjH4E4
	z5IkFxH3vKeGv9KvDPNvFR5htpyr4203TzwloECoEE7tEO/0c1NK+ioOJP3zbG2uktBAfxnEH7m
	H1pZSRJehrzxvJXoHu2qcyNLU+lFIjI2Y8UDwGGTXlxGHAVPGcgw2KAOy8uFuNxbrp87+Ej4Vml
	M3rPY+YglhkO9Y7Dh978fsCJMZNj7GOLAJ+jPI2rPZrzVuTIkIA+ihVVqc3psoBL2KKxaZsK4E4
	cRVgFJfIscrguMZ4H0wJ6ftpXWDBuAGSlDKNNlQp0JJY+j8dcLOrVKHO9dHbPGETXrlc/rem3Vn
	RaLjNYrKYs0UYnhrskpiHEr/iQOeZiGe4JHdQlHYKFa1w1Q31pEBP04L
X-Received: by 2002:a05:693c:4009:b0:33b:c24c:d31c with SMTP id 5a478bee46e88-36a42331666mr6811820eec.7.1793438401002;
        Sat, 31 Oct 2026 02:20:01 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428ecb61sm13067963eec.10.2026.10.31.02.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 02:20:00 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	amir73il@gmail.com,
	linux-unionfs@vger.kernel.org
Subject: [PATCH 1/2] generic: test overlayfs casefold flag changes
Date: Sat, 31 Oct 2026 09:19:47 +0000
Message-ID: <20261031091948.18985-2-dennylin0707@gmail.com>
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

Changing the casefold flag of an overlay directory can leave its upper
and the mount with different casefold states and break lookups.

Check that chattr +F/-F requests which would change that state fail with
EOPNOTSUPP, preserve the casefold flag and leave files accessible. Cover
lower-only directories with and without contents and the overlay root,
with both casefold-enabled and casefold-disabled layers. Keep no-change
requests as successful controls.

This covers "ovl: do not let chattr change the casefold flag" from the
casefold fixes series linked below.

The test also reads regular files on a casefolded overlay. This needs the
separate "ovl: check the casefold flag of directories only" fix, included
in the tested overlayfs ovl-fixes baseline at 1d27da7de3f7.

Link: https://lore.kernel.org/linux-unionfs/20261030113201.2921633-1-amir73il@gmail.com/
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 tests/generic/998     |  142 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/998.out |    3 +
 2 files changed, 145 insertions(+)

diff --git a/tests/generic/998 b/tests/generic/998
new file mode 100755
index 0000000..f9ff789
--- /dev/null
+++ b/tests/generic/998
@@ -0,0 +1,142 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Hungyu Lin.  All Rights Reserved.
+#
+# FS QA Test 998
+#
+# Check that rejected casefold changes leave overlay directory casefold
+# flags unchanged and existing files accessible.
+#
+. ./common/preamble
+_begin_fstest auto quick ioctl casefold
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
+_fixed_by_kernel_commit xxxxxxxxxxxx "ovl: do not let chattr change the casefold flag"
+_fixed_by_kernel_commit xxxxxxxxxxxx \
+	"ovl: check the casefold flag of directories only"
+
+check_casefold()
+{
+	local path=$1
+	local expected=$2
+	local expected_state=disabled
+	local flags
+	local actual=0
+
+	[ "$expected" -eq 1 ] && expected_state=enabled
+	flags=$($LSATTR_PROG -d "$path" 2> $tmp.err) || {
+		cat $tmp.err >> $seqres.full
+		_fail "cannot read flags on $path"
+	}
+	flags=${flags%% *}
+	echo "lsattr $path: $flags" >> $seqres.full
+	[[ "$flags" == *F* ]] && actual=1
+	[ "$actual" -eq "$expected" ] || \
+		_fail "$path: expected casefold $expected_state, got flags $flags"
+}
+
+reject_casefold_change()
+{
+	local change=$1
+	local path=$2
+	local ret
+
+	$CHATTR_PROG "$change" "$path" > $tmp.err 2>&1
+	ret=$?
+	echo "chattr $change $path: exit $ret" >> $seqres.full
+	cat $tmp.err >> $seqres.full
+	[ "$ret" -ne 0 ] || \
+		_fail "chattr $change $path succeeded, expected EOPNOTSUPP"
+	# Check the SETFLAGS error, rather than accepting any chattr failure.
+	grep -Fq \
+		-e "Operation not supported while setting flags on $path" \
+		-e "Not supported while setting flags on $path" \
+		$tmp.err || \
+		_fail "chattr $change $path: expected EOPNOTSUPP, got exit $ret: $(cat $tmp.err)"
+}
+
+_scratch_mkfs_casefold >> $seqres.full 2>&1 || \
+	_fail "cannot format the casefold scratch filesystem"
+_scratch_mount_casefold || _fail "cannot mount the casefold scratch filesystem"
+printf 'sentinel\n' > $tmp.data
+
+# Try the enabled mount first so kernels without overlay casefold support
+# skip before reaching the actual attribute-change checks.
+for folded in 1 0; do
+	root=$SCRATCH_MNT/ovl-$folded
+	lower=$root/lower
+	upper=$root/upper
+	work=$root/work
+	merge=$root/merge
+	mkdir "$root" || _fail "cannot create $root"
+	if [ "$folded" -eq 1 ]; then
+		_casefold_set_attr "$root" >> $seqres.full 2>&1 || \
+			_notrun "cannot enable casefold on the scratch filesystem"
+		change=-F
+		same=+F
+		casefold_state=enabled
+	else
+		change=+F
+		same=-F
+		casefold_state=disabled
+	fi
+	mkdir "$lower" "$upper" "$work" "$merge" || \
+		_fail "cannot create overlay directories"
+	mkdir "$lower/empty" "$lower/dir" || \
+		_fail "cannot create lower directories"
+	cp $tmp.data "$lower/dir/file" || _fail "cannot create lower file"
+	cp $tmp.data "$lower/file" || _fail "cannot create lower file"
+
+	if [ "$folded" -eq 1 ]; then
+		_mount -t overlay overlay "$merge" \
+			-o lowerdir="$lower",upperdir="$upper",workdir="$work" \
+			>> $seqres.full 2>&1 || \
+			_notrun "overlayfs does not support casefold enabled layers"
+	else
+		_mount -t overlay overlay "$merge" \
+			-o lowerdir="$lower",upperdir="$upper",workdir="$work" \
+			>> $seqres.full 2>&1 || _fail "cannot mount overlay"
+	fi
+
+	echo "Casefold $casefold_state" | tee -a $seqres.full
+	# A lower-only directory would be copied up as an empty upper directory,
+	# even when its merged view contains files. The upper root is also empty.
+	for path in "$merge/empty" "$merge/dir" "$merge"; do
+		check_casefold "$path" "$folded"
+		reject_casefold_change "$change" "$path"
+		check_casefold "$path" "$folded"
+		cmp $tmp.data "$merge/file" >> $seqres.full 2>&1 || \
+			_fail "$merge/file: not readable with expected contents after chattr $change $path"
+		cmp $tmp.data "$merge/dir/file" >> $seqres.full 2>&1 || \
+			_fail "$merge/dir/file: not readable with expected contents after chattr $change $path"
+	done
+
+	# chattr still issues SETFLAGS for a no-change request.
+	for path in "$merge/empty" "$merge/dir" "$merge"; do
+		echo "chattr $same $path" >> $seqres.full
+		$CHATTR_PROG "$same" "$path" >> $seqres.full 2>&1 || \
+			_fail "chattr $same $path: expected success for unchanged casefold state, got exit $?"
+		check_casefold "$path" "$folded"
+	done
+	_unmount "$merge" || _fail "cannot unmount overlay"
+	merge=
+	cmp $tmp.data "$lower/file" >> $seqres.full 2>&1 || \
+		_fail "$lower/file: not readable with expected contents"
+	cmp $tmp.data "$lower/dir/file" >> $seqres.full 2>&1 || \
+		_fail "$lower/dir/file: not readable with expected contents"
+done
+
+_exit 0
diff --git a/tests/generic/998.out b/tests/generic/998.out
new file mode 100644
index 0000000..9f5c8b0
--- /dev/null
+++ b/tests/generic/998.out
@@ -0,0 +1,3 @@
+QA output created by 998
+Casefold enabled
+Casefold disabled
