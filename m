Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.8
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793484993;
	b=t8i3Ny8EccfpDlkdRMrGRz5BCq3jeWWl1XVY/md+3SMIW2/y2AHftTRaRrsnpB0gB5c8
	 PldVk9zmalT8DBnbxT04z4q1huQ/SoSgnOQIhnLjuwWEvVy+IofcVCMKkaiAKlshHOoy0
	 KpeLYOm/jR5m8Ptwg/GvbiT9P1faxHG+z70Jzj43aUJl5nZp2DCopmC/HfAgByAqhe0jJ
	 QAkKRfapUchscNM7iuy5Ue6tfFVezm5diPmAofIBTq05/x+i5oI3ofgFAp3E56yhx+/6G
	 gQMA+ISVFFaTjVj3wrI+5m3a6emyjJJGOEm3IXnA2A5iHS1Lb4vO52+lwOJO0DxNG3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793484993;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GJoYtmlEWC341A7cBgsZ3mQTJ4svk+sity18hk+Hva4=;
	b=EmLGFhJ3LuCallo4tQHZSnMBZzPybE0+FiDhNb1u7cxt0Bbs9LD7ceVHWHxpFNdeHsTV
	 9p/tbOfuHy1Midy8cDwlmQtXGKYMGt4E/v1PEo+8S1Dg4jv67cToO/gASBdXMvjkhbrmT
	 2AgNl0PGUHRgJRJ8OnXsPb8u3dIwERCVu+q2lFaMuKryfxeJv/zZ3UCB15ocz289Kyjqj
	 tFLoUkvdAu7Fb8yQRPpHMKc70DnGz3RnAX6mGRs1oXrxxtVFfmTIaASBW+epKCfJsBV36
	 xYSGA5zyYv9OmY6zmRAgZIZx7sSi/aXwSoBnHNUIHrBqx3XyBJP1T5rrl30EeZ2lykQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="whiuqm/Y";
	arc=none smtp.remote-ip=74.125.229.8
Received: from mail-dy2-f8.google.com (mail-dy2-f8.google.com [74.125.229.8])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78104606A31D
	for <linux-unionfs@vger.kernel.org>; Sat, 31 Oct 2026 22:16:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78104606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=whiuqm/Y
Received: by mail-dy2-f8.google.com with SMTP id 5a478bee46e88-36a24f47293so1140561eec.0
        for <linux-unionfs@vger.kernel.org>; Sat, 31 Oct 2026 15:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793484992; x=1794089792; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GJoYtmlEWC341A7cBgsZ3mQTJ4svk+sity18hk+Hva4=;
        b=whiuqm/YkHfoW8R6vyQa6KtR7/1csiE5NsVLv4902gK+bI6LIm2slClM/fSgoFdzWs
         phl6MgOt6N74gPSd2/liYnWgjX+EqCr+VAQbXGWpdtBco6rh4aLuR1MdiAjEDnbq2fAf
         Tth0E4FzGJqGSDOfXIu4zs/TYjDKH9a/FvuD7z7YSzaKzSBScLabq9GooBP/CHMuUdIK
         X2dwK/zgRbNNS3NZRFmXkNut5ks033hXxU3FlmfOrLoeXPXGrgAIf0Fio+10NUa49Leg
         men5sW4+ECj438096SL9nnIYGriOgoaJADP7cP6u8/LSY/N7VYkQXxbiqa8Tdlh+zRwC
         VfGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793484992; x=1794089792;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GJoYtmlEWC341A7cBgsZ3mQTJ4svk+sity18hk+Hva4=;
        b=jbvdpjacN+EnJ2C3Go4/oGsGKNdydETa4FG1hlWi96BMmJBE6LLstYHwoRGHLx4jhw
         tiP5QFxswltZzoAn26XU2JjG2QDoUX/ecDlht5WIOvI+mKec6jMfjHM1IEOf46TeyJDb
         uIxlVUSxMh7XkCw3jQii9KP6o2/miAoj/o70zBKbCiT/qokUOSfTDrRnDO9bJiHC8FjI
         TkUA3mFrQKIkVOFyrzfaIprDHPFHML/nreLbbPSt3FahSe3dBQNXlN1FCXOidc+rV26a
         s18QfkRjNMwM2jUtMgCKuIGwq7AWZW8R1/n1GqZJSveeAldEpz9F7wwtO4ARKxuhFTHE
         Ex5Q==
X-Forwarded-Encrypted: i=1; AKwUvBzZ4G77EUr1yJ+iClREGmLmKmdxaWowZqmtpD62DdEQ6NCwXH+NOFpTrzlxK4qBSnCNB8xtlCBxbHiztYLD@vger.kernel.org
X-Gm-Message-State: AFq9FYIAnn2XJXNLMnNRoa1zDK+FYMaiSlUu5epuS9FTMAoQoLSUXvgf
	u76tpEo5u+RdwIzXE62wVQ5o8YxuIIeK7eK6xFR6xYKSNVcf2mxRrt/r
X-Gm-Gg: AYBFou2OxqMSK2ibHXz5CDHtVKfeItXS5r74kza7MLOQvkM60hEsDqsjhVgJaxD3lm/
	cfiM4CigL/2KZTmoXXt9xcj+i6zP/z/fTHtuwlwEwAg2J6brHoHWkcSUGqwx9p8khKSZLk12o9T
	Vp7dgXfixKJxtFNs/cB/J6P4a2gBIHQM2tFEqWbhCU6UNfzPJ26yLRNe5EL4aubZTN1rxhDAL5+
	Lh42ObD+a1rl+FTNNQvxt5sbXQo9yvOZbwueZ//DevbA+fow9cQ7r+pWK8QMtVxyQaFStIGvi4v
	+17nPbETSeBLXAHsZWCTCYJ1wX9ovUBqMr0D7zuIQQsqgMHVwEUe4/WiO08i1AdtFr0J+lJuxVZ
	SHVbXjVITN/Qy2gZRBUQglCGfzAWycaBlIlBMccQcMCMRpl+0yFv9WNmbJBAmDuw2Sh5w5U2SsX
	8rF75KsRvxDVapqzaFCX7+8NjNkgV0FH4hWtCU1IuXOZLwyV6VOqsd9RaJ6/FSe3wI5md1uqdI8
	Ydi5mDb/FJAml+pCXd5El35i1117fyQQiGO/nLBXoLaLZYbrAZet3aRgfhRyidHZ4tPCMTYXqWQ
	/k0uxLo9+QBUOkEX22j93QzreUeB0vYxk8zII5QRVpoGhOcPg2/HldRy6hU/GNJZFNk7KO2aLNG
	aLA==
X-Received: by 2002:a05:693c:88c8:20b0:369:f2d6:4108 with SMTP id 5a478bee46e88-36a42401233mr9001958eec.10.1793484991459;
        Sat, 31 Oct 2026 15:16:31 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42a61a0csm24037242eec.22.2026.10.31.15.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 15:16:30 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	amir73il@gmail.com,
	linux-unionfs@vger.kernel.org,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH v2 2/2] generic: test whiteouts on casefolded overlay layers
Date: Sat, 31 Oct 2026 22:16:18 +0000
Message-ID: <20261031221618.153-3-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261031221618.153-1-dennylin0707@gmail.com>
References: <20261031221618.153-1-dennylin0707@gmail.com>
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
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/999     |  148 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999.out |    2 ++
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
