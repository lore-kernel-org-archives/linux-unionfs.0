Received: from mta1.migadu.com (out-50.mta1.migadu.com [95.215.58.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176122ECE91
	for <linux-unionfs@vger.kernel.org>; Mon,  7 Sep 2026 04:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788756933; cv=none; b=C9pTvunByiacIyYY6/0dKjLGPXe2Uua6EbHi6sBL3D7ucMlRfKF8BQ2xJmt0PODCtGR2i9JWNzPNa+gL9nBPpcmxWcVOSkuDZbOxH4py3nzC/jdpJ9d9uGXEWPbKsnaoK8OykTtWpklge4JEn0J/QcLLLxwfD0C3IhPVs+R37zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788756933; c=relaxed/simple;
	bh=u9/82jjn7HPYGB+0454M/+i3SLDdyKFmb/gGHFwv9Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FY1jAKF7EOj5nCIZibJFnrkOlu3K3V2tQznYWNGB0TjqHxqqcQmgN2YLM3kqEFJ8Y9I7OvNzsqbpy4mh3Hs85kxYVEm7dOq1j7KwJsO2G94XFFgoulJBYpjCfE0cy8xR0ooXV23j1dRnUa0u5sDhPDZMaoFhkFanEG5BQ/Dwcpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hsiZskD3; arc=none smtp.client-ip=95.215.58.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hsiZskD3"
X-Envelope-To: linux-unionfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=u9/82jjn7HPYGB+0454M/+i3SLDdyKFmb/gGHFwv9Bk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788756928; v=1; x=1789361728;
 b=hsiZskD3WOcXtmYCxfYy+uaO7GW5b4bH6/gx7fE98Yf4nFfoMkbQuncaG6rVFHhn4r8Oi2Ns
 O612/s/8h0ertqoTqCshvTHxKl9BZ2OzfX9uug12ZYNYZ2J/ZaIpBMXhiMvldW2IWYiqKG85Veu
 xdwHygOIMQU7dw41PQlatq/k=
X-Envelope-To: linux-unionfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a71d6b4f24578b51;
	Mon, 07 Sep 2026 04:55:26 +0000
X-Mizu-Trace-ID: a71d6b4f24578b51
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: linux-unionfs@vger.kernel.org,
	miklos@szeredi.hu,
	amir73il@gmail.com
Cc: andrealmeid@igalia.com,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] ovl: clean up dir on casefold mismatch
Date: Mon,  7 Sep 2026 12:55:17 +0800
Message-ID: <20260907045517.1347518-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

In ovl_create_real(), the S_IFDIR case checks after a successful
ovl_do_mkdir() that the new directory inherited the expected casefold
flag.  On mismatch, err is set to -EINVAL but the directory that was
just created in the workdir or in the upper layer is left behind.

The mismatch is reachable: ofs->casefold is fixed at mount time, but
the casefold flag of the index dir can diverge.  With index=on, a
pre-existing "index" directory with +F is accepted at mount, and every
temp mkdir for an index entry inside it fails the check and leaks one
directory.  Measured on an ext4 casefold upper: 100 directory renames
left 100 "#nnnn" entries in the index dir, one per failed mkdir,
growing without bound.

Clean up the created directory with ovl_cleanup_locked() before
returning the error.  All callers of ovl_create_real() arrive with the
parent inode locked (via start_creating()), so the locked variant must
be used; ovl_cleanup() would deadlock on inode_lock().

Fixes: dfc7da402ccc9 ("ovl: Check for casefold consistency when creating new dentries")
Cc: stable@vger.kernel.org
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 fs/overlayfs/dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 7beb0af26498..4e451bbd8f97 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -188,6 +188,7 @@ struct dentry *ovl_create_real(struct ovl_fs *ofs, struct dentry *parent,
 			if (!err && ofs->casefold != ovl_dentry_casefolded(newdentry)) {
 				pr_warn_ratelimited("wrong inherited casefold (%pd2)\n",
 						    newdentry);
+				ovl_cleanup_locked(ofs, dir, newdentry);
 				err = -EINVAL;
 			}
 			break;
-- 
2.43.0

