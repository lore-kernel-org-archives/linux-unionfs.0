Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C74C8EB;
	Sun,  2 Aug 2026 18:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785693658; cv=none; b=cwT8T6qZy4+u3h49k3qtECrbVMyLlRYQrNUcVXh4si53JBKBn8JgH974mF18q1YAI/dceTKEU7whOhE8F1NH89SlOK2rtenbz/S/KLWPAgTcUpjP7lHzOrwa0mwKu1tZqgIbA15Rj5cj7/6bqlxnD7XSUIHH1yc1m7mi7TDqBXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785693658; c=relaxed/simple;
	bh=M6JZlR8i5Q+W2IPwr6zZOJ0eNJQ8egqcpk2wTkdtdRQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FeJWFRMLGjGCnBCqttmRO/VCLbhRvrkP6hbRHFdFXULzsRSPBO2u2xUl9yE13UdvUEV2RPqucmjQ//3YGciVxT6m4aHUdkdQvBJ33UKWCR6zqSXrYfOETgzFFwfFW5ODGVQld/HCy86+dAXnwm9p2Rro66AkUADb+NH031ECdQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KEmN+I/S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KEmN+I/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9499C1F00A3A;
	Sun,  2 Aug 2026 18:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785693657;
	bh=xdUbIeEA0NY1lpHQDcBWvRIKEibZrc5Dbd8chU0BwRo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KEmN+I/SzbZDPFVG5b+3QkXRjLgREbM+/2vvRmaf+cf1uLFmH0QmTJ7eRMDyfQkZx
	 KYyl8n27eLCcuWRj0cVMkOyr/sMOsqnB6/r9/pOOLwshk+u+z91lRzg6FFy5n3eaL/
	 oEcNCZ5Ku3fY18PxIxdyxi6cVKRxws4t9qH6culmVY/z22HG1+U2SK0ofG7WRSVzE0
	 5M5Z4JLXwVzHBy83kPIC+eE8rkB7h4XkuvV1oVyfXJd5RINtFbX8moKeQ6LCHSKby1
	 6on/Zvmrn/E9J6jkqn/SeP6elDZneHITEpCxmNlYK9zTDZ8J8sUHutnIvGCR8GVv1G
	 dvsStJhE1MSqA==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 02 Aug 2026 20:00:43 +0200
Subject: [PATCH 1/3] ovl: don't warn when the mount is completed from
 another user namespace
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260802-work-fill_super-warn-v1-1-4e987911a39a@kernel.org>
References: <20260802-work-fill_super-warn-v1-0-4e987911a39a@kernel.org>
In-Reply-To: <20260802-work-fill_super-warn-v1-0-4e987911a39a@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, Laurent Vivier <laurent@vivier.eu>, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-f2f85
X-Developer-Signature: v=1; a=openpgp-sha256; l=2481; i=brauner@kernel.org;
 h=from:subject:message-id; bh=M6JZlR8i5Q+W2IPwr6zZOJ0eNJQ8egqcpk2wTkdtdRQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTlt15ulrh9w/j6jAsRNdGduTJdQcsuXHv196O76IeHV
 179ydL40VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRf7EM/wxMtkR+f+SQKNO5
 KuHPZa9lVa4B+5be38Lz4+z6hV+Pz6xlZJigarTw8hkG/i3eByZJhAdUSBvtPPG5JOWL0rLJPTp
 /+fkB
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

fsopen() records the caller's user namespace in fc->user_ns and hands
back an ordinary file descriptor. Nothing ties the task that calls
fsconfig(FSCONFIG_CMD_CREATE) to the task that created the context. The
fd is inherited across fork() and exec() and it can be passed over a
unix socket.

Completing a context from another user namespace is allowed on purpose.
vfs_cmd_create() authorizes the create with mount_capable(), which for
FS_USERNS_MOUNT checks ns_capable(fc->user_ns, CAP_SYS_ADMIN), and that
succeeds for a task holding CAP_SYS_ADMIN in an ancestor of fc->user_ns.
So an unprivileged task can reach the WARN_ON() in ovl_fill_super():
create a user and a mount namespace in a child, call fsopen("overlay")
there, send the fscontext fd to the parent and let the parent issue
FSCONFIG_CMD_CREATE. Both namespaces come from a plain unshare(1) and no
capability is needed anywhere:

  WARNING: fs/overlayfs/super.c:1551 at ovl_fill_super+0x7b9/0x1e20 [overlay]
  CPU: 3 UID: 1000 PID: 3243376 Comm: fswarn
  Call Trace:
   get_tree_nodev+0x71/0xa0
   ovl_get_tree+0x15/0x20 [overlay]
   vfs_get_tree+0x2a/0x100
   vfs_cmd_create+0x60/0xf0
   __do_sys_fsconfig+0x4b2/0x500

The child needs the mount namespace because fsopen() itself gates on
may_mount(), which asks for CAP_SYS_ADMIN in the user namespace owning
the caller's mount namespace. fsconfig() doesn't repeat that check.

It is a WARN_ON() and not a WARN_ON_ONCE(), so the condition can be
raised in a loop to taint the kernel and flood the log, and it panics a
kernel booted with panic_on_warn.

Keep refusing the mount and stop warning about it. ovl_parse_param()
already spells a user namespace check this way for Opt_override_creds.

Fixes: 1784fbc2ed9c ("ovl: port to new mount api")
Cc: stable@vger.kernel.org # v6.5+
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/overlayfs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 60f0b7ceef0a..60b808b85fc4 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1544,7 +1544,8 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 	int err;
 
 	err = -EIO;
-	if (WARN_ON(fc->user_ns != current_user_ns()))
+	/* The fscontext fd may have been passed to another user namespace. */
+	if (fc->user_ns != current_user_ns())
 		goto out_err;
 
 	ovl_set_d_op(sb);

-- 
2.53.0

