Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A7A33065D;
	Mon, 15 Jun 2026 13:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529616; cv=none; b=lvFWVm1Gb0AyDt5ZKeYSWE6knntW5zx6GtOe2PMPLhuFi9oPH0FisGL+PcHk4bHWWpWavW9P33Z0t827QBKl5sgUFeIQwrbI4UsX+5/YblgpcJxQD0DM/ucNd9GWJWgTHrs5sFs9nATY/Wf2If2KC60M8f1Snuefrb96s4ANq4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529616; c=relaxed/simple;
	bh=Oi1Gz7E8QPCTYMz4AaeQ5V+0Mfe5DN/XqAVr06VG9ss=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=doeFtL/YoAa8s3DJhAjU69TPxA+uEiwWWF794Vr/rRdyA4RLWyF7+AjgU2gdwKbU9hHMFShVBVgmDP5GJ2XqhtipfD1+btq43dYpXvM4o02pgsZjNZuzdmuqWOCqL91tskDgZTGSkv+scAoJq7XgxlWkNFJRLAn3nARNC2vGbM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W03HfXQP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W03HfXQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312CF1F000E9;
	Mon, 15 Jun 2026 13:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781529615;
	bh=DpFsWyewM7BsF2XA7NPwIXo+AiNjCX/CpdO/zk7esVw=;
	h=From:Subject:Date:To:Cc;
	b=W03HfXQP+Qkk3S0UOU/QgWL7VG4ZSoz3ZQHY/AQykgDmNt2eO4l0uGnWyzoS+nQ9+
	 w9kwLWoM2VDpaFIgxVIL1xItM1MR361X1cWEANQDB2p98HxmWy41HvT042cJOUgNLs
	 UP5LdvUEkX8ttBgFw6x82b3u+guIVX6+g1Pni7AHcjj0xFY0OixdDtEAYYQsiebzra
	 90yPFCZAB5vgQPJq8oMtgKSwkf9lJIc9tBvL2qQoavGgQIC4RSwxX0PsGV5UL4m3MS
	 /tT+/tYgn4jyHHh2BAEtS1tZdHXPo2Wy/piPKv18gVFIB/LgmgcWFl0yGM44h5EEzT
	 ke89127deVXag==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 00/10] ovl: support idmapped overlay mounts
Date: Mon, 15 Jun 2026 15:19:49 +0200
Message-Id: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPb7L2oC/yWMyw6CMBBFf4XM2pK2CSX6K8ZFH4NUhTYzWDWEf
 7fo8pzce1ZgpIgMp2YFwhI5prmCOjTgRztfUcRQGbTURhrViVeie3WTzRmDSAXpYT8DC+lkh/3
 RBa0M1HcmHOL7Vz5f/sxPd0O/7Ll94SyjcGRnP+5qsrwgtaVvFWzbF5LvEJKZAAAA
X-Change-ID: 20260615-work-idmapped-overlayfs-0b05e79bd216
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f5839
X-Developer-Signature: v=1; a=openpgp-sha256; l=3723; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Oi1Gz7E8QPCTYMz4AaeQ5V+0Mfe5DN/XqAVr06VG9ss=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTp/+E5veLimpYE1sPu+btX99drWb1LWFNu+vr2DvMK9
 Rkfd/Df7ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIe2ZGhmMdv2zld07PPMml
 YLAv88lGw/t+96cGuf+JC7e1DmhnO8rwP7qHe6qt6Nzwr5c4Gtb5tutEr3u0vn7r7O0XuA8lSFr
 eYwAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

I've been asked about this feature multiple times and had actually
implemented it right when I did the initial idmapped layer support.
So here's a new version of this series.

This series lets the merged overlayfs mount itself be idmapped via
mount_setattr(MOUNT_ATTR_IDMAP), in addition to the already supported
idmapped lower and upper layers.  It allows the same overlay tree to
be exposed under a different ownership view, e.g. a container seeing
the merged tree as 0:0 regardless of the on-disk or per-layer ids.

Overlayfs already normalizes every underlying id through the relevant
layer idmap when it copies attributes into the overlay inode
(ovl_copyattr()), so the overlay inode's i_{u,g}id are "overlay-final"
ids.  The overlay mount idmap O composes on top of that pivot:

    caller view  <--O-->  overlay-final id  <--layer idmap-->  on-disk

O is applied at the overlay-inode boundary only - permission, getattr,
setattr, the ACL owner checks and inode_init_owner() - while the
underlying layers keep being accessed with the mounter's credentials
through their own, possibly idmapped, mounts.  The mount idmap thus
only changes how the caller sees the overlay inode and never widens
the mounter's access to the layers: the second, mounter-credential
check in ovl_permission() against the real inode stays on the layer
idmap.

Most paths need no change because the VFS applies O to the overlay
inode before overlayfs runs (sticky/rename/unlink/create gating) or
after it returns at the syscall boundary (the POSIX ACL get/set
translation).  Overlayfs only acts where it bypasses the generic path:
getattr (it stats the real path), the setattr forward to the upper
(the requested id is rebased from O into overlay-final space before
being handed down), inode_init_owner() on create/tmpfile, and its own
owner checks in ovl_set_acl().

FS_ALLOW_IDMAP is set last, once every operation honors O, so there is
no bisection point where the mount is idmappable but an operation
still ignores the idmapping.

Note that fstests will be broken by this temporarily as they rely on the
ability to create whiteouts for unprivileged device node creation. That
can be adjusted.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (10):
      ovl: handle idmapped mounts in ovl_create_object() and ovl_tmpfile()
      ovl: handle idmapped mounts in ovl_permission()
      ovl: handle idmapped mounts in ovl_setattr()
      ovl: handle idmapped mounts in ovl_getattr()
      ovl: handle idmapped mounts in ovl_set_acl()
      ovl: allow idmapping overlay mounts
      docs: document idmapped overlay mounts
      selftests/filesystems/overlayfs: fix set_layers_via_fds link error
      selftests/filesystems/overlayfs: test idmapped overlay mounts
      ovl: document security.capability idmapping on the xattr forward paths

 Documentation/filesystems/overlayfs.rst            |  16 +
 fs/overlayfs/dir.c                                 |  16 +-
 fs/overlayfs/inode.c                               |  26 +-
 fs/overlayfs/overlayfs.h                           |   1 +
 fs/overlayfs/super.c                               |   2 +-
 fs/overlayfs/xattrs.c                              |   1 +
 .../selftests/filesystems/overlayfs/.gitignore     |   1 +
 .../selftests/filesystems/overlayfs/Makefile       |   2 +
 .../filesystems/overlayfs/idmapped_mounts.c        | 501 +++++++++++++++++++++
 .../filesystems/overlayfs/set_layers_via_fds.c     |  16 +-
 10 files changed, 560 insertions(+), 22 deletions(-)
---
base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
change-id: 20260615-work-idmapped-overlayfs-0b05e79bd216

