Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768723F4DD9;
	Mon, 15 Jun 2026 13:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529623; cv=none; b=di2iL3DFja/jFB1VUBsqNL/qbTO9HGHGGf08/oxc6vWuNaJFgiT/iyxao0bQyptrRrZGylnRyr7mJ/NIZTBKosZMKs9hqaDog+uh5f3Hu8kUMmQ625zJ4fBbqJdN0TWyFSo1Hs1+2X+ybrPnf0qw2F+5yF+npGkkBN8LJ7rqo1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529623; c=relaxed/simple;
	bh=9szy1eaK5iPBxvn6tPMMLcupjSedmktPYu4v5bgxWq0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NunhIpjyWhxJFagwQ4R1UUfalbdSZtujG1Fpl5+W6XuDM4p/O7smIjyB5b0hntsHOnxjlDDrUedFvzn4TYopyFUL4Qso2TABgror4iehfQHWMOXv+/9h7x3WaRQORbcbYkxG4s7GcBtr4QJ9yjuwA7f4GYNeMWEgMbVLjqVPV0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BlklUi2w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BlklUi2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26041F00A3A;
	Mon, 15 Jun 2026 13:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781529621;
	bh=9PejAffvMKcY8u+ZLJEHSqivW57WkTiUWxBCvDkXhDU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BlklUi2wWehu4WOereX5Egfo0004WyDxdjUh5U5o5OEmXuIxejpFAj+Uk0K8g28U7
	 v5Ltqd650JF7sv/7ygUW9aLCJBfLl6cfUBrLIfoJoWsC97WRKcaYQUmpnCZoElz95E
	 X5lAA1NPvd3wc+9TJfF5VwX4eylNNGaQ9fuSnnw4mt2Eh4gzsZTW+h95vMm9KID56V
	 LcisXSE+HdG8WUq6Quy9AZI+UpawY5iWB9CadX/f3RPRFFlJ8FH/Ey7xpvHLWod3gQ
	 z8Zki+Bl974e4kHlJaio/54QhYEd/CoYqTfjB/n8dw0JP34R9PLftGHi5gczLeAKC+
	 Iz4L3dMqDx9Uw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 15 Jun 2026 15:19:52 +0200
Subject: [PATCH 03/10] ovl: handle idmapped mounts in ovl_setattr()
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-work-idmapped-overlayfs-v1-3-7381632aa402@kernel.org>
References: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org>
In-Reply-To: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f5839
X-Developer-Signature: v=1; a=openpgp-sha256; l=2246; i=brauner@kernel.org;
 h=from:subject:message-id; bh=9szy1eaK5iPBxvn6tPMMLcupjSedmktPYu4v5bgxWq0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTp/+FZ/XrCB47PPlqfVH4dUD7xan3KwgP60SuElNy+m
 B/8eVSopaOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiRuGMDB+0+yuN6sTmcCoH
 zFdZ67a6sTB3zQuO432W7m6uTAdzmxh+MZ97UfRrjuI+l03JMypfqE2W4FrianPzdvnuxeVHTr5
 5xQEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Pass the mount's struct mnt_idmap to setattr_prepare() so that the
permission checks for a chown/chmod performed through an idmapped
overlay mount are evaluated in the mount's id space.

The ownership requested in @attr is expressed relative to the overlay
mount idmap.  Before forwarding the change to the upper layer via
ovl_do_notify_change() - whose notify_change() applies the upper layer
idmap in turn - rebase ia_vfsuid/ia_vfsgid into the overlay's own id
space, i.e. the same space as the overlay inode's i_{u,g}id established
by ovl_copyattr().  Without this rebase the upper layer would interpret
the caller's mount-relative id as an upper-relative one and store the
wrong owner on disk, or reject it with -EOVERFLOW.

from_vfsuid() returns INVALID_UID for an id that the overlay mount
idmap does not map; that invalid id is carried faithfully into the
forwarded iattr and rejected by the upper notify_change() via
vfsuid_has_fsmapping(), so no bogus owner can be written.

No functional change until FS_ALLOW_IDMAP is set on ovl_fs_type; until
then the overlay mount idmap is &nop_mnt_idmap and from_vfsuid() is the
identity.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/overlayfs/inode.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index f59db57dfd55..33734ca971e1 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -26,10 +26,18 @@ int ovl_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	bool full_copy_up = false;
 	struct dentry *upperdentry;
 
-	err = setattr_prepare(&nop_mnt_idmap, dentry, attr);
+	err = setattr_prepare(idmap, dentry, attr);
 	if (err)
 		return err;
 
+	/* Rebase ownership from the mount idmap into overlay id space. */
+	if (attr->ia_valid & ATTR_UID)
+		attr->ia_vfsuid = VFSUIDT_INIT(from_vfsuid(idmap,
+				i_user_ns(d_inode(dentry)), attr->ia_vfsuid));
+	if (attr->ia_valid & ATTR_GID)
+		attr->ia_vfsgid = VFSGIDT_INIT(from_vfsgid(idmap,
+				i_user_ns(d_inode(dentry)), attr->ia_vfsgid));
+
 	if (attr->ia_valid & ATTR_SIZE) {
 		/* Truncate should trigger data copy up as well */
 		full_copy_up = true;

-- 
2.47.3

