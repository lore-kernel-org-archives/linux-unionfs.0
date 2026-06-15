Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA083F4854;
	Mon, 15 Jun 2026 13:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529627; cv=none; b=Q/mAgxZcjcaZKVjZ6dxNhMHpcAo1fJhjqQsIhGK/8uJ4L4kM/YLK3536382jkhlUKa8omfoFfwC1O8o+RLVJ1ZWGlXyjBip5xgAQTisw7rtRJHcaRverb0Rl4xsKP3HaAYm0nbfKIUFBDegDWQE2ttMIWpjBrxhq9e/Xj1cjGJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529627; c=relaxed/simple;
	bh=M4ZFBTAO15hYG88uEThIubDhMsKglHfRxofxqk2LQ/Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HyXmJS+webfYsZv2Gfn44wIyoB13wPGn3jpP0LA45LRypc9iJLhA7uorDQyxCd6APyRDNNTWSisECzDe96AFszNGGANjgun2MXmRekmSDomH/fkojBoXLmOmtUwrLTpclRAVSPP7JQSGLS3TxRH7S4jo1T2y03e4u+cBLbwGNgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kGf72LtZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kGf72LtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8D41F00A3A;
	Mon, 15 Jun 2026 13:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781529626;
	bh=4cOnYUZDQ75v9fLH4qbWdCjxbQQAKrOonlUBhGbXu14=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kGf72LtZA92Rz5RhFLY88WK2lgh1FD5eh76tt8S8DyqOqHg0A5y8CurFIkEddqYXw
	 XKb7RwSgpQLe0aeHYg8XdKr7igZgQne9Rsvg4U/zGmEWThqPWIiSJjMqz1AOqcVlJZ
	 +ggAy8uTC+32Lv0ztFjLFNkOcGyHC6P/UwpVNu392JgY2LfBdVUIK9P7E6hQ6sFtPv
	 7rFfOJY9rW6W/4wn/RWKpDWF0QHLyJko5AV+BU1+SdorLC1Pes00IjVoWUhx/TPQIo
	 QFXqFi6CCAo1Mx44ecwZPNxOJEFb2fxuNX2eyYnlVROJUa99jh42+x9Rnx91rMkmgz
	 Q/v16gRghhZew==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 15 Jun 2026 15:19:55 +0200
Subject: [PATCH 06/10] ovl: allow idmapping overlay mounts
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-work-idmapped-overlayfs-v1-6-7381632aa402@kernel.org>
References: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org>
In-Reply-To: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f5839
X-Developer-Signature: v=1; a=openpgp-sha256; l=1853; i=brauner@kernel.org;
 h=from:subject:message-id; bh=M4ZFBTAO15hYG88uEThIubDhMsKglHfRxofxqk2LQ/Q=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTp/+FdO+v/vCARER7fikRTn3KtAp72dxmXs+3XnNl84
 l1W27u2jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIm8mMnwP1JUeEmvcUPs+gAB
 fssb7x4H1ljv11tl8LL4u2bVwXO3lBgZFmpKvRc8ulCaIfOJl55397TyW3tnO3tcFORO3PnEvk2
 TGQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Now that every overlay inode operation honors the overlay mount idmap,
allow the merged overlay mount itself to be idmapped by setting
FS_ALLOW_IDMAP on ovl_fs_type.  mount_setattr(MOUNT_ATTR_IDMAP) can
then apply an idmapping to an overlay mount, exposing the merged tree
under a different ownership view.

The composition is clean because overlayfs already normalizes every
underlying id through the relevant layer idmap when it copies
attributes into the overlay inode (ovl_copyattr()); the overlay inode's
i_{u,g}id are thus "overlay-final" ids.  The overlay mount idmap
composes on top of that pivot: it is applied to (getattr) and removed
from (setattr, create) those ids at the overlay-inode boundary -
permission, getattr, setattr, ACL owner checks and inode_init_owner() -
while the underlying layers keep being accessed with the mounter's
credentials through their own, possibly idmapped, mounts.  The mount
idmap therefore only changes how the caller sees the overlay inode and
never widens the mounter's access to the layers.

This is deliberately the final code patch of the series: only once
every operation honors the mount idmap is it safe to make overlay
mounts idmappable.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/overlayfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 60f0b7ceef0a..f2889cf9bc07 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1573,7 +1573,7 @@ struct file_system_type ovl_fs_type = {
 	.name			= "overlay",
 	.init_fs_context	= ovl_init_fs_context,
 	.parameters		= ovl_parameter_spec,
-	.fs_flags		= FS_USERNS_MOUNT,
+	.fs_flags		= FS_USERNS_MOUNT | FS_ALLOW_IDMAP,
 	.kill_sb		= kill_anon_super,
 };
 MODULE_ALIAS_FS("overlay");

-- 
2.47.3

