Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794822316;
	b=LEf0JlxFc3/0jJ2GtCQH0qeRX+XxGURnxJulEqkQrQZEGFzW9BKigPQSxKp31yukdPr+
	 cMijDnUgPvwSp5yg6HuCLkswYMJvC1p+wHp1L/Llw+wYGdTA8XhPWGzcYotBIAXD9h5o/
	 OCpO1rv2WnLKLLkhBl/z84O3tcjToZTDkohRt8L1zv5sRz1RTy/gq28iKmqQZxWafJJwy
	 yZihHiwsw3uTgj9OtfcuuU23H10ZBH5ndtDT7tx49e351wRRFMmAQKfXpy3hS0ph84pr3
	 5Kc/WCqJGAkUYWmVbmyGssv1rQhshOus08BSiL9Dg3YKQUCyPAtwUvKk8APUuxzSrHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794822316;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=JZBbr+KpgKvtf5CdfCyTEA2njHiE84oBk+6E/JibmWY=;
	b=gLIq6vfbFuhSQjh7vBelUV7FEoCuNsnkcE1QHYHSccZkE9xZzt8O+AYm3+Cb18akHW9W
	 6zTGHWkFZR5cr5YsqzexMXEIZDJhHcYTVqiETU+/0fVDq/zOHvVlkmFDk59kLtXIWXWHM
	 /b3yfxYkYWSY6bKPswxt8Kn89Ooq5miiLml3q+4yHCbYfDFLxlDAlqz5YX17k4Q3YNYsI
	 cSn8PFixO7q9Zexe1Vly8v3am1h69VhlMFS9h4pRVQdZE2Um8PBUrl/GzHoW7bIMNttXc
	 OQ4AOpYsjVxo0in111mroonTUAJ8Sa/1Lz0DulUxiP41Kmz1kJ29IGVAccnQ5HkRA2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B97HKY2P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A271C606A32C;
	Mon, 16 Nov 2026 09:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B97HKY2P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B121F000CE;
	Mon, 16 Nov 2026 09:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822316;
	bh=JZBbr+KpgKvtf5CdfCyTEA2njHiE84oBk+6E/JibmWY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=B97HKY2PGKEGnNZWH+9w9+0VaaDTFjZeYetWFj6uCjbfmrTo7DbHvFCFzkFFczhnR
	 HEATw/pGVvMAd4PbreaA6tlPFV+ioe9bWLZlVkGN3Jnc3bu5KhIG9mB2APdMMyEexJ
	 qxpM2ebSt4BGJesPkEI+dbqVN8D0hh/YnHLDpejcYCUUwCdQtNushOG5qn43SoZCBZ
	 T7YkZnNrFsMd+FsKCzi0JonosAYo6jife3TfunFHCnFnuoehPzuyK6NruLLkOO/ofc
	 Fxaa96qcnNpctrcitMhsV1ZgLI/30L4SF5Cp7PNJbK8wcHujVu3YfUMZIPb1LEgfhy
	 eKAjdrUPsId1g==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:44:09 +0100
Subject: [PATCH v2 12/13] selftests/ftrace: add uprobe tests on overlayfs
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
Message-Id: <20261116-work-ovl-d_real-v2-12-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
In-Reply-To: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4861; i=brauner@kernel.org;
 h=from:subject:message-id; bh=tgbFOzNYWl27oUOBkSLrcjFal3oWf5TeuDFachZqNjU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ulDDvKxedjtHwJmjQZoOpw2Mm44FvtkYPCW/YvU0t
 +O7P/zU6ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIkdcM//0D5/bEbj/Euaou
 YZqiyh79ScKHDTVunEj884yvMcWzYyYjw2Lpzs0njulOu2m2mKF03+NF2rasHl9jlc5KXNv6aJp
 1FTMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Add uprobe tests on overlayfs with a data-only layer:

- a metacopy file whose redirect points at nothing: creating the probe
  fails, the error log has the new message and nothing gets tainted by a
  WARN

- a metacopy file whose data lives in the data-only layer: the data is
  looked up when the probe is created and the probe hits when the file
  is executed

None of the existing tests puts a uprobe on overlayfs.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/ftrace/config              |  3 +
 .../test.d/dynevent/add_remove_uprobe_overlayfs.tc | 96 ++++++++++++++++++++++
 2 files changed, 99 insertions(+)

diff --git a/tools/testing/selftests/ftrace/config b/tools/testing/selftests/ftrace/config
index 29f05f7c6e2ce..05325737e4a5f 100644
--- a/tools/testing/selftests/ftrace/config
+++ b/tools/testing/selftests/ftrace/config
@@ -19,6 +19,7 @@ CONFIG_KPROBE_EVENTS=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
+CONFIG_OVERLAY_FS=y
 CONFIG_PREEMPTIRQ_DELAY_TEST=m
 CONFIG_PREEMPT_TRACER=y
 CONFIG_PROBE_EVENTS_BTF_ARGS=y
@@ -30,6 +31,8 @@ CONFIG_SAMPLE_TRACE_PRINTK=m
 CONFIG_SCHED_TRACER=y
 CONFIG_STACK_TRACER=y
 CONFIG_SYNTH_EVENTS=y
+CONFIG_TMPFS=y
+CONFIG_TMPFS_XATTR=y
 CONFIG_TRACER_SNAPSHOT=y
 CONFIG_UPROBES=y
 CONFIG_UPROBE_EVENTS=y
diff --git a/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe_overlayfs.tc b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe_overlayfs.tc
new file mode 100644
index 0000000000000..a29065dd76900
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe_overlayfs.tc
@@ -0,0 +1,96 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Generic dynamic event - add/remove uprobe events on overlayfs
+# requires: uprobe_events error_log setfattr:program readelf:program
+
+grep -qw overlay /proc/filesystems || modprobe overlay 2> /dev/null || :
+if ! grep -qw overlay /proc/filesystems; then
+  echo "No overlayfs support. skipped."
+  exit_unsupported
+fi
+
+echo 0 > events/enable
+echo > dynamic_events
+
+OVL=$TMPDIR/ovl
+mkdir $OVL
+mount -t tmpfs tmpfs $OVL
+
+cleanup() {
+  echo 0 > events/enable
+  echo > uprobe_events
+  umount $OVL/merged 2> /dev/null || :
+  umount $OVL 2> /dev/null || :
+}
+trap cleanup EXIT
+
+mkdir $OVL/lower $OVL/data $OVL/merged
+
+# A metacopy file whose data lives in the data-only layer.
+REALBIN=`readlink -f /bin/sh`
+cp $REALBIN $OVL/data/sh
+truncate -s `stat -c %s $REALBIN` $OVL/lower/sh
+chmod 755 $OVL/lower/sh
+if ! setfattr -n trusted.overlay.metacopy $OVL/lower/sh; then
+  echo "No tmpfs xattr support. skipped."
+  exit_unsupported
+fi
+setfattr -n trusted.overlay.redirect -v /sh $OVL/lower/sh
+
+# A metacopy file whose data doesn't exist.
+touch $OVL/lower/broken
+setfattr -n trusted.overlay.metacopy $OVL/lower/broken
+setfattr -n trusted.overlay.redirect -v /missing $OVL/lower/broken
+
+mount -t overlay overlay -o lowerdir=$OVL/lower::$OVL/data $OVL/merged
+
+TAINT_WARN=512
+TAINTED=`cat /proc/sys/kernel/tainted`
+
+# The data of the broken file can't be resolved so the probe must fail
+# right away and not only when it is enabled.
+echo > error_log
+if echo "p:broken $OVL/merged/broken:0x0" >> uprobe_events; then
+  echo "uprobe on a file without data was created"
+  exit_fail
+fi
+grep -q "trace_uprobe: error: Failed to resolve the data of the given file" error_log
+! grep -q broken uprobe_events
+test ! -d events/uprobes/broken
+
+# Get the entry point virtual address from ELF header and convert it to
+# a file offset. See add_remove_uprobe.tc.
+ENTRY=`readelf -hW ${REALBIN} | grep "Entry point" | awk '{print $NF}'`
+ENTRY_DEC=$(printf '%d' "$ENTRY")
+OFFSET=$ENTRY
+while IFS= read -r line; do
+    set -- $line
+    [ "$1" = "LOAD" ] || continue
+    VA_DEC=$(printf '%d' "$3")
+    OFF_DEC=$(printf '%d' "$2")
+    FSZ_DEC=$(printf '%d' "$5")
+    if [ "$ENTRY_DEC" -ge "$VA_DEC" ] && [ "$ENTRY_DEC" -lt "$((VA_DEC + FSZ_DEC))" ]; then
+        OFFSET=$(printf '0x%x' "$((ENTRY_DEC - VA_DEC + OFF_DEC))")
+        break
+    fi
+done << EOF
+$(readelf -lW ${REALBIN} | grep LOAD)
+EOF
+
+# The data of the metacopy file is looked up when the probe is created.
+echo "p:myevent $OVL/merged/sh:${OFFSET}" >> uprobe_events
+grep -q myevent uprobe_events
+test -d events/uprobes/myevent
+
+echo 1 > events/uprobes/myevent/enable
+echo 'ls' | $OVL/merged/sh > /dev/null
+echo 0 > events/uprobes/myevent/enable
+grep -q myevent trace
+
+echo "-:myevent" >> uprobe_events
+! grep -q myevent uprobe_events
+
+# Nothing above may have warned.
+test $((`cat /proc/sys/kernel/tainted` & TAINT_WARN)) -eq $((TAINTED & TAINT_WARN))
+
+clear_trace

-- 
2.53.0

