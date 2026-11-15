Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794751369;
	b=DeD5C2HmR6BAHej7eHsLPBv4onNLI75x3yggTuIxARFheh8LypO3rOQVT/bbv8M0nRKd
	 GjXUJnao2/mOcQMSbBSmJAQG6Axvwjt/XaZjOzUKk4IT3Oi9J4nyrhIXgssJnkHGs4rZ+
	 3Adz4u4K2r6BxzD6j/v7u5+3OVBjJJ10sduaxf2VCnr/zEBlAQWUd78DyZERjd9knMzc6
	 n7J8xxZ6gpb3gONNmMHO1++0jO28d/066gfFueh6oAcQnLnDH2QE4B3rUYy4cSdghw5Sh
	 twLjmvtMMBz+7NHHIs+2wTB/TKg25mWp8u5NjcWd6aAl3WpnyTzph74H6Lfo//FDcuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794751369;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=oP5zIZCQTcMU9+CPrnID7f1P0LDTPtLFFjYPE0HeKnY=;
	b=UuQ+wW4mpbCRvDjo6aqdiY45qYJ02QN7Lb6F58Gof6pec6jk3NXOzQkSRnBG1sn0hodj
	 u/fuahl+pCfrMICcfyJWV1qAaR9OJXozM/hLG+YjMyPU9SF9F2+Mfrqmyr2UxsjQFa8QP
	 vS3bVqZT1vCInvB43dDzYnS4kn0Kzfgvg9TJlv2nmO/3K7Etn6gh428K7RmSs9laSdi6e
	 x455X0h4uz19I/AvxbJ9ZUWmHVpXK/gdyWCZY2abHhbyvqiKKLBRqonWmjFm52OgZ4s8s
	 8/x/QZySeYb5j2iTwEDsZ7Phj8w2KW8ljaVJBP9VdKUnlwZrGjpcdN25eN+3ugaoe/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K5ptMEvX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D990606A8B0;
	Sun, 15 Nov 2026 14:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K5ptMEvX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3F51F000C4;
	Sun, 15 Nov 2026 14:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751369;
	bh=oP5zIZCQTcMU9+CPrnID7f1P0LDTPtLFFjYPE0HeKnY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=K5ptMEvXOFu9qpLLiVWzupBP0giX+aKB+gY5mvwLuKtilk1+JXMObMjAgnCUsISCU
	 2497YIWWQwd+8BSlRCera9VbFkT+iLV7OrAxD9xvA32qYgrG4GyHi9e0wpRENhkD8R
	 nPUxAuijTqPnVrbls6vpZ06JMNKW8CP0vOWqohnrnB1ow0wpTwR7hTFmZD7NpldVhi
	 3T7hENFpK/e3YaFEtIf4MfiZqPBE0pk16ewIH+JZi7c6nSNNWuxwKgNrNGWWQdbZNm
	 RFcJk0PGwXpT6ZV9Gg7UH4l6eS/vOydX1+K8aCZYSS3Oi4ZEhIfYmhFTdv+/eo8ABP
	 +EVy0uNQY+XuA==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 15 Nov 2026 15:01:42 +0100
Subject: [PATCH 12/13] selftests/ftrace: add uprobe tests on overlayfs
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
Message-Id: <20261115-work-ovl-d_real-v1-12-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4013; i=brauner@kernel.org;
 h=from:subject:message-id; bh=xU8r7+QeQbm0YiMN28AhupsgwvIfGboboN38EplDOpw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93B1rLux4aLX3tOn77I7tfTqN3eKmzWFbD1dmk1zHG
 YoZjyYJd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzk1H9GhkkW83jiHk2dIez5
 x7dQd6vso67TTLpvnMzepxjJvlZ4dJ6RYYpxgVsM+315zvbbl9cw/TxuJZby4xvr37cujL+eHnN
 R5QMA
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
 .../test.d/dynevent/add_remove_uprobe_overlayfs.tc | 92 ++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe_overlayfs.tc b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe_overlayfs.tc
new file mode 100644
index 0000000000000..a4351e6a3b181
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe_overlayfs.tc
@@ -0,0 +1,92 @@
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
+setfattr -n trusted.overlay.metacopy $OVL/lower/sh
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

