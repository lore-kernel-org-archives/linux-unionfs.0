Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045EC3F4DC6;
	Mon, 15 Jun 2026 13:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529626; cv=none; b=fdYPdAWaBNfHxTsJjfR3NrSf5meMNoxOeTGJcKFjRNuUXQE3gzM7pcDCZ+XVRuAexl1ZdiANknxY0dVOX6C65XODKCt7l8RUa4Bcs2DjWYQx+FjehqBGmxvhP6HOuLvQWbbDGvSI5W2xWnsaQQghAo1AgeHz4pu8C8TXzS7CHK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529626; c=relaxed/simple;
	bh=WB6fTDPiwZHn0aTIVrwJvZh1YyKUm/7nDB8UG8Dv/sU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gJJ95PdKdwBC8OpgXRFWVvnPKULW2YcUwx4ksA7goTnav5bbqB5pmxN5+bdVfJsxrXyl+6j272lsIIuKIbRoo6/b7fKLL8zW3h3RWPMSjlLTWJLe05TPK5IH8+C/eIzP2n52jyGv4DB52S4AtX7UlOJPrjmKOir153GtOCRldok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RS15fjHl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RS15fjHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428341F000E9;
	Mon, 15 Jun 2026 13:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781529624;
	bh=EIIiZdcY84KsFDjbnmPDyHrvPzmrosIDEPmbdGcndM8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RS15fjHlqVp1pX61GHPZuOp+qgS2coVTISBPwwANDErHNlkHoHn2DAJm5Nn+Q9fQL
	 2Iyb0y8hDwz5MnA8ruPIcRkA2ZGKsaZBb7q9zAIDo6p/a7o1R8ZhBxq+H9UoZ0MP/4
	 I+yoIv31we/OVtH4ws++LpdTwuuazZhRRF0a62xCpdbBx4vsjJLbR0CLhANa5+CmUA
	 XdSm/e425Pbi7pdKo1WNKw+lYvmrDoiJe5F9EjuAv3sNrePlC+bBhT2G8nmlOCfQf0
	 BMeJ6DcyUPfJ2VyvE6DXH4LzIGjgGjBgVlhn4kTzGkxJnUH+nLpskZHkD3bOMjceoq
	 vNVlZaGZ3Evbg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 15 Jun 2026 15:19:54 +0200
Subject: [PATCH 05/10] ovl: handle idmapped mounts in ovl_set_acl()
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-work-idmapped-overlayfs-v1-5-7381632aa402@kernel.org>
References: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org>
In-Reply-To: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f5839
X-Developer-Signature: v=1; a=openpgp-sha256; l=2226; i=brauner@kernel.org;
 h=from:subject:message-id; bh=WB6fTDPiwZHn0aTIVrwJvZh1YyKUm/7nDB8UG8Dv/sU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTp/+G1fX5J5sitkMS8n+LaV8peNwRNi1lqrlO6TmWaD
 7uq0r1VHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABMpjGFk6MkXfGjQbC5xfr4k
 698fS88xJ0nrrVDkuSpuZViz6U+6OCPD6eedNcpLvurO/dCtGd81mc/2qMAmYYWOlYpq1idkVs7
 lBQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

The two checks ovl_set_acl() performs on the overlay inode itself -
inode_owner_or_capable() and the setgid-stripping test - were done with
&nop_mnt_idmap.  On an idmapped overlay mount this compares the overlay
inode's id space directly against the caller's: it denies the rightful
owner (as seen through the mount idmap) the right to set an ACL, and
evaluates the setgid-drop decision in the wrong id space, which can
mis-set the mode on the upper inode.

Use the struct mnt_idmap passed in by the VFS for both.  Fold the
open-coded "caller not in group and not CAP_FSETID privileged" test
into in_group_or_capable() with i_gid_into_vfsgid(), the same
idmap-aware helpers used by setattr_should_drop_sgid().

The subsequent internal forced setgid-kill via ovl_setattr() stays on
&nop_mnt_idmap: it carries only ATTR_KILL_SGID with no uid/gid to
translate and is overlayfs' own mode change, not a user-driven
operation through the mount.

No functional change until FS_ALLOW_IDMAP is set on ovl_fs_type.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/overlayfs/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 45b2a5c3d978..57aa74de5bc4 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -550,7 +550,7 @@ int ovl_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 		return -EOPNOTSUPP;
 	if (type == ACL_TYPE_DEFAULT && !S_ISDIR(inode->i_mode))
 		return acl ? -EACCES : 0;
-	if (!inode_owner_or_capable(&nop_mnt_idmap, inode))
+	if (!inode_owner_or_capable(idmap, inode))
 		return -EPERM;
 
 	/*
@@ -558,8 +558,8 @@ int ovl_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 	 * be done with mounter's capabilities and so that won't do it for us).
 	 */
 	if (unlikely(inode->i_mode & S_ISGID) && type == ACL_TYPE_ACCESS &&
-	    !in_group_p(inode->i_gid) &&
-	    !capable_wrt_inode_uidgid(&nop_mnt_idmap, inode, CAP_FSETID)) {
+	    !in_group_or_capable(idmap, inode,
+				 i_gid_into_vfsgid(idmap, inode))) {
 		struct iattr iattr = { .ia_valid = ATTR_KILL_SGID };
 
 		err = ovl_setattr(&nop_mnt_idmap, dentry, &iattr);

-- 
2.47.3

