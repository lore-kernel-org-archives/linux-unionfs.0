Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61216C8EB;
	Sun,  2 Aug 2026 18:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785693661; cv=none; b=Vr+rFGEIazx5lUJETGq7+XReoBZqzqn+wSP29SjNua5UZ0I+W8DHd+rYcDpMqgPrNjiHWKTC4KwaZvCFzqwX05FADhr4fFUM+9cFcLCCZl9BmcdA/wjTfyjmqhnMaPesOaJ5qNxZ6UNn9t0DlVGvJVamsLXVihpMOXwmOsqQmSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785693661; c=relaxed/simple;
	bh=oUEgEb1v4z/alxWWTvQ5NBBZo0HFrYjN+ySUTY9PsOc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SdUWXXHPxg8kI0mxfkDvtV0Ss4DG73ITqZsp3OCfXahjTdv3z/rhjqhzdxrKZB31UT28n0FHL4CokzUnDUdmFMlJesvGj9mXbe/Kh6GIBi+RylMxbzT6OTB9TEzwZ7lNlAC3Ucf8UGs/EpnEMa/b7KtmuKQ4mqvY3X5swSXc/7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KCxNHeld; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KCxNHeld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4D31F000E9;
	Sun,  2 Aug 2026 18:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785693660;
	bh=j7xpeM8pp0DEe6UpBgAa7dvpst5pAAcHLBVezKeavwU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KCxNHeldigD1lW+k0J4+fYSDsP5PV9V+qNTxpXefIV3PlRJnqSTHvjth8Rhn7dPnF
	 zmrbcxKtFERtySp6iLCRHQAR5bxVnvWhC9jRFPALjlmDjf7N0oQjIeraRU2CEz8EJx
	 F9bAm3xTC9CI9S5E7m1Z/HfyXjWtqT/PnRqHYi9H3VjlJrDrkFpIcyG7Q+w9qIoMj/
	 iOU2iH/Yms8vbyolzzaY1ojq9JNXOIPy3wGq9edZhG3RwBfTro7xm992awkccbNYcH
	 2vGJ+BmXq23AloX9ykUNU07HnWTmEgaLfv3xCS9gOKSAF6G4M8hJ930zIX1MA3IkhW
	 UJ4ExxKPwzCQw==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 02 Aug 2026 20:00:44 +0200
Subject: [PATCH 2/3] binfmt_misc: don't warn when the mount is completed
 from another user namespace
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260802-work-fill_super-warn-v1-2-4e987911a39a@kernel.org>
References: <20260802-work-fill_super-warn-v1-0-4e987911a39a@kernel.org>
In-Reply-To: <20260802-work-fill_super-warn-v1-0-4e987911a39a@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, Laurent Vivier <laurent@vivier.eu>, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-f2f85
X-Developer-Signature: v=1; a=openpgp-sha256; l=2548; i=brauner@kernel.org;
 h=from:subject:message-id; bh=oUEgEb1v4z/alxWWTvQ5NBBZo0HFrYjN+ySUTY9PsOc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTlt17Wf2lV0JMRe85k8qrdh4LEvaZFlOkFLxHbKqfHs
 EIyJ+J+RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETu/Wb4HyVi0Xuq+udHza8c
 t7aH8Hz1OvbCd+MOsUw5N/tTl51t5jL8Dwle+i4xZPvpaxqVHk/+t/3ao/Kzt1TK+t33C9a3y23
 aOQA=
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
So an unprivileged task can reach the WARN_ON() in bm_fill_super():
create a user and a mount namespace in a child, call
fsopen("binfmt_misc") there, send the fscontext fd to the parent and let
the parent issue FSCONFIG_CMD_CREATE. Both namespaces come from a plain
unshare(1) and no capability is needed anywhere:

  WARNING: fs/binfmt_misc.c:938 at bm_fill_super+0xa2/0xc0 [binfmt_misc]
  CPU: 15 UID: 1000 PID: 3243382 Comm: fswarn
  Call Trace:
   get_tree_keyed+0x7d/0xb0
   bm_get_tree+0x34/0x90 [binfmt_misc]
   vfs_get_tree+0x2a/0x100
   vfs_cmd_create+0x60/0xf0
   __do_sys_fsconfig+0x4b2/0x500

The child needs the mount namespace because fsopen() itself gates on
may_mount(), which asks for CAP_SYS_ADMIN in the user namespace owning
the caller's mount namespace. fsconfig() doesn't repeat that check.

It is a WARN_ON() and not a WARN_ON_ONCE(), so the condition can be
raised in a loop to taint the kernel and flood the log, and it panics a
kernel booted with panic_on_warn.

Keep refusing the mount and stop warning about it. Nothing in
bm_fill_super() depends on the two namespaces matching, it derives
everything from sb->s_user_ns.

Fixes: 21ca59b365c0 ("binfmt_misc: enable sandboxed mounts")
Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index c97f10b48b5b..613dd28e3f1a 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -937,7 +937,8 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
 		/* last one */ {""}
 	};
 
-	if (WARN_ON(user_ns != current_user_ns()))
+	/* The fscontext fd may have been passed to another user namespace. */
+	if (user_ns != current_user_ns())
 		return -EINVAL;
 
 	/* Never exec off this instance and never let anything stack on it. */

-- 
2.53.0

