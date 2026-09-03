Received: from mta1.migadu.com (out-211.mta1.migadu.com [95.215.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0662370AEC
	for <linux-unionfs@vger.kernel.org>; Thu,  3 Sep 2026 03:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788406456; cv=none; b=e5imrpXwdoVdB0soozGQEGzWJ+22Yervj1C04cxuv6Xn9vSoKsKMwCIVk/NpDHN7p2URWSMvABj3vVUbiU0WPdwYmNtOBCtrks7ie4jxUb60sQlZW2SlUTG5VKU3thS/oiE3J2JkszQnx/8CmFV6cYRdeq+FADhJ2fQeJL3hJ0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788406456; c=relaxed/simple;
	bh=1KMp/FOl0LyWPvCuKijZ4ceqVvuUTUzcJmSfy/YwVyk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L8IKRtVyEMVAsrsL+qfJpW7mnDWvDQ9FbMsnlr2jr2M/+fTRzcQlqt/Vl0JgCU1TVUTYOIFjtk1ftb/EFoCi3WDRiYn/A6/to3AhnD+a8jKYUjX9nohnDYL7tTn1Qn2Z6QWZXnvfkB0NqqxqV3OvIGFzRMhIHDwPBKoRGbK10WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UAB79+zm; arc=none smtp.client-ip=95.215.58.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UAB79+zm"
X-Envelope-To: linux-unionfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=1KMp/FOl0LyWPvCuKijZ4ceqVvuUTUzcJmSfy/YwVyk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788406451; v=1; x=1789011251;
 b=UAB79+zmoW119l1raAHb1WADzD+ghefSqyWc7R+eVB1ssXPC9j5WehaUN0awtBZfy+RCxT0w
 cn9zaTvTod3ctSOvikhiC3wzzhIyfnJe3KlllsiLb7f3pZ3g16FQGrM34kDrfH74mA4anNDYybR
 1uAC1JPfX3oYvFQJaNbAun30=
X-Envelope-To: linux-unionfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e20257ac234d1e26;
	Thu, 03 Sep 2026 03:34:11 +0000
X-Mizu-Trace-ID: e20257ac234d1e26
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: linux-unionfs@vger.kernel.org,
	miklos@szeredi.hu,
	amir73il@gmail.com
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	brauner@kernel.org,
	jlayton@kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH] overlayfs.rst: document cross-layer file lock and lease semantics
Date: Thu,  3 Sep 2026 11:33:59 +0800
Message-ID: <20260903033359.1042529-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

Locks and leases taken through an overlay attach to the overlay inode,
while opens of the same on-disk file through its real upper/lower path
operate on the underlying inode.  The two do not conflict, so an
"exclusive" flock/POSIX/OFD lock or a write lease held via the overlay
is silently bypassed by anyone reaching the file through the layers
directly, e.g. backup tools walking a container's upperdir or another
overlay mount over the same layers.

Locking through the overlay succeeds and appears to work, so the lack
of mutual exclusion only shows up as data corruption when the two
sides write concurrently.  Document the semantics, the affected
scenarios and the recommended practice.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 Documentation/filesystems/overlayfs.rst | 27 +++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 16c35b491dad..546b77e66016 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -884,6 +884,33 @@ The "-o userxattr" mount option forces overlayfs to use the
 useful for unprivileged mounting of overlayfs.
 
 
+File locks and leases
+---------------------
+
+File locks (flock, POSIX record locks and OFD locks) and file leases
+taken on a file through the overlay attach to the overlay inode.  The
+same on-disk file opened through its real upper or lower path is a
+different inode object, so locks and leases acquired through one path
+do not conflict with locks and leases acquired through the other.
+
+An "exclusive" lock or a write lease held by a task that opened the
+file through the overlay does not prevent another task from acquiring
+the same lock or opening the file if the latter reaches the file
+through the underlying layer directly, e.g.:
+
+- a tool running outside the container accesses the container's
+  upperdir/workdir or the image layers below it directly,
+- a second overlay mount is stacked over the same upperdir,
+- the same layers are shared between different overlay mounts.
+
+Locks and leases do provide mutual exclusion between tasks that all
+reach the file through the same overlay mount, and a lease taken
+through the overlay is broken by opens through that overlay.
+
+Do not rely on file locking for mutual exclusion between overlay
+users and anything that may touch the underlying layers directly.
+
+
 Testsuite
 ---------
 
-- 
2.43.0

