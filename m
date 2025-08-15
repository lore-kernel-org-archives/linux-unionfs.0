Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB71618DB37;
	Fri, 15 Aug 2025 14:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755269160; cv=none; b=LbLcmyoli+ojlLLpvvDcpgb8eVkHZOA3nGtKTAOKOz5mM18g7V+zvi7fnekHrFG+D3JyesoAnYWO1FFK3B0WMMaL0AlgvQFYM6BF8hWPxs7PBHf4j9fqp8dw/UTemYGP9eqiKcmKh9+xiRxJdxo1jpL5kAn81reSxu1MVgdsFgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755269160; c=relaxed/simple;
	bh=9Gmb5FEWcaxJfEAwNfy8ACLmVg/o4yZ+y9AxZol5BE8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ToqUpL5n6KX9UGnn+pvRutpDYvA6fKvGQzYlsYQpWXlXFG8+fa0fkS17ZI2IrQfwNTCvwwpAh6Gem9s/H9cNSAFgmUPSr+Hq2ck/TGb4ozOP8t6cJ1LglAKHph1hIwol3g18Q0f+3fmUQBgC411ctyuRHnYdlxoU5AneyDjS9u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N7w+BMzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N7w+BMzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1EBC4CEEB;
	Fri, 15 Aug 2025 14:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755269160;
	bh=9Gmb5FEWcaxJfEAwNfy8ACLmVg/o4yZ+y9AxZol5BE8=;
	h=From:To:Cc:Subject:Date:From;
	b=N7w+BMzTMPvZWh7FcvHAAOc+jnmxNQUVwHYGzb2iXu3EMCmFGWo19w+6s6GBYUi+o
	 MELNUzH/QM/JcZyVq+ZgVn6b/5l66msy7Lg9ycrSMMmDSxkDo+5QOiJ8MyCq1sDZEd
	 hh4KeXNMwcFDFcgoqPhnWHkXcbKXhXO7Mwa9Oz/Ha/jZNCPSlMAKvN7YUhOh8SslGW
	 TM+l5IGouvQGDPq83bvwglzQ+DlglNUy4NozvDuQd7AOvFaW3LxsayVzpxb00Tj97Q
	 rtSgu4au5qYxjVT7oo+oQY+/d39dzJG0gPJfFrX4LkBBd5/IwxYz/dbz5rg2OQycLM
	 1bjuNsqzhVdiQ==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org,
	pdaly@redhat.com
Subject: [PATCH] overlay/005: only run for xfs underlying fs
Date: Fri, 15 Aug 2025 22:45:55 +0800
Message-ID: <20250815144555.110780-1-zlang@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When we runs overlay/005 on a system without xfs module, it always
fails as "unknown filesystem type xfs", due to this case require xfs
to be the underlying fs explicitly:

  $MKFS_XFS_PROG -f -n ftype=1 $upper_loop_dev >>$seqres.full 2>&1

So notrun this case if the underlying fs isn't 'xfs'.

Reported-by: Philip Daly <pdaly@redhat.com>
Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 tests/overlay/005 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/overlay/005 b/tests/overlay/005
index 4c11d5e1b..d396b5cb2 100755
--- a/tests/overlay/005
+++ b/tests/overlay/005
@@ -31,6 +31,7 @@ _cleanup()
 # them explicity after test.
 _require_scratch_nocheck
 _require_loop
+[ "$OVL_BASE_FSTYP" = "xfs" ] || _notrun "The underlying fs should be xfs"
 
 # Remove all files from previous tests
 _scratch_mkfs
-- 
2.49.0

