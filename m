Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BADE404BE1;
	Mon, 15 Jun 2026 15:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781537616; cv=none; b=WuLo0OUaVcyhd0pktdlA4pbJ/j030QniIzmXlQfWBkWzOPAxg36vwa/r8Pr99nYM9DGXrTxfnUVYJUWXDScnbEWqkB9rA+Sn21HaQWBIS6jS8FRDJNA4booKt1Obb7XO8gKxrzXHuHB/JPycy43pbCnzCdsI7wEb+P9QxHTQC7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781537616; c=relaxed/simple;
	bh=YAVz9xyKeCfQVLFkJDAW/DH8m5ZtB02pAE2V1nOU/ws=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=TRu+4dwfsbtSF54fWQyjk0hnbpD8toGnSojM6/U02C2wbMqaVRftndkcJDUclOo+mms8oTwgsLQrvwgVY8j8i9LoZ15YQRBbNqEY2ypJJHxW+hnBR7OV86LwnrHdGO2PvSBOF46S7MveZmWfq7vE5fZbPcYxB87AhjC7byv288A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QHYPomsn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QHYPomsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4F21F00A3A;
	Mon, 15 Jun 2026 15:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781537615;
	bh=YR8d1sU68vjg6nO93UgPSiFfS13ANOnhT9n1aPx9rjw=;
	h=From:Subject:Date:To:Cc;
	b=QHYPomsnvmrgCoa2DmS6X03Iac2YhKUwVLqUM1U1HRdMdo/vacbta6P3f9qZ9YgE3
	 FiBk0zcga3AYUkJflGcPfVREO8mjHcerH3dG+pzyXPTxw+R861Z02vNFIAAa0HVIzc
	 3QbnR0Ra5pa2gCuLDNbBsFGAsUj4lZVWFCG9S6Gpxnyj74e36ZptB509jJ15z3zMEE
	 0DLB/ifoNUPgxr6SiW+xfi7QaiHxwFRn4+LUa44G49s5KvJ2uQgyoF4BfSI8+iXcKy
	 DdeYZX39/N6hVuU59qSMikL2Eu23FCNfNPJObYxcpAKS23dfaWxUiMcdN4IB677TFJ
	 Kzx+9QyuS/W1A==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/2] Support overlayfs in the idmapped mount tests
Date: Mon, 15 Jun 2026 17:33:28 +0200
Message-Id: <20260615-overlay-idmapped-vfstest-v1-0-c6b3b2228092@kernel.org>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEgbMGoC/yWMQQ7CIBQFr9L8tSQUlRivYlxAeViMQsOnTU3Tu
 wu6nMl7sxEjBzBdu40ylsAhxQr9oaNhNPEBEVxlUlJpqfuzSAvyy3yqfptpghOL5wIuwiqt3FF
 eToChep8yfFh/6dv9zzzbJ4bSem1hDUPYbOIwNuVTFhFroX3/AgQ5AxiXAAAA
X-Change-ID: 20260615-overlay-idmapped-vfstest-b262d3084eea
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Zorro Lang <zlang@kernel.org>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 fstests@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f5839
X-Developer-Signature: v=1; a=openpgp-sha256; l=2655; i=brauner@kernel.org;
 h=from:subject:message-id; bh=YAVz9xyKeCfQVLFkJDAW/DH8m5ZtB02pAE2V1nOU/ws=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZSPua+AoujK/3Xs4stSa35MhE8VC/32eWn95lGr8ju
 c9g84y6jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgImITWb4n8mUf9gh9aNgaNqq
 GCdPlTfB+46Wtv1N0fyz7FtZk1BYDCPDfb7379dz2K1Oqz5oybNoz0OHzbNjG3wUGKbXKk5uapn
 PBAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

This change is required to make the series in [1] which makes idmapped
overlayfs mounts work compatible with the idmapped mount test suite.

The vfstest idmapped mount tests behind generic/633, generic/696 and
generic/697 fail on overlayfs for two reasons that are specific to
overlayfs and unrelated to idmapped mount semantics:

  - They create a whiteout device, mknod(S_IFCHR, makedev(0, 0)), as a
    fixture -- it is the only character device an unprivileged caller may
    create, being exempt from the CAP_MKNOD check. overlayfs reserves a
    0:0 character device as its on-disk whiteout marker, so ovl_mknod()
    returns -EPERM and the fixture cannot be created.

  - openat_tmpfile_supported() probes O_TMPFILE on the idmapped mount as
    the test's fsuid, which that mount does not map. On overlayfs the
    backing tmpfile then ends up owned by an unmapped id, overlayfs opens
    it with O_NOATIME, and may_open() returns -EPERM, so the probe
    wrongly concludes O_TMPFILE is unsupported and the tmpfile sub-tests
    are skipped.

Patch 1 fixes the probe: O_TMPFILE support is a property of the
filesystem, not of the idmapped mount or the caller's mapping, so it
probes info->t_dir1_fd (the base mount, which the caller owns) just like
the non-idmapped setgid tests already do. This is a general correctness
fix and a no-op on every other filesystem.

Patch 2 adds an is_overlayfs() helper and skips the whiteout-device
fixtures (and the checks that depend on them) on overlayfs, which
genuinely cannot create them; the makedev(5, 1) "creation must fail"
probes keep running.

With both patches generic/633, generic/696 and generic/697 pass on an
idmapped overlayfs mount with no change on any other filesystem; tested
on overlayfs and tmpfs.

The underlying overlayfs O_NOATIME behaviour that turns an unmapped-fsuid
O_TMPFILE into -EPERM is being addressed separately on the kernel side;
these test changes are independent of it.

Link:
https://patch.msgid.link/20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org [1]

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (2):
      src/vfs: probe O_TMPFILE support on the base mount in the idmapped tests
      src/vfs: skip whiteout-device fixtures on overlayfs

 src/vfs/idmapped-mounts.c | 166 ++++++++++++++++++++++++----------------------
 src/vfs/utils.c           |   5 ++
 src/vfs/utils.h           |   1 +
 3 files changed, 93 insertions(+), 79 deletions(-)
---
base-commit: ffc8bad17e5b2f56e48dbac43f7c5ae8ac368fe5
change-id: 20260615-overlay-idmapped-vfstest-b262d3084eea

