Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794751357;
	b=OFBBSkr/yokJvVm9OeAJ133Yt9Dop5xrcp3Ng+BGE5qHCtWg9hZYlWNDVn+P7NoWsiDk
	 j3K2UIT4gEFEhKWXBbCGHW9M5TfR7nQGbGt1lQJ38MOk3KAnYfgLnIauFBdSoP/tK/cU9
	 XiF2hIAkH0Fg5ix5GMqxLaKBQ063EJEZ73P58BLMdjFvg2brZp2g6+8Cfyjft+07ysGbi
	 vyDaCdViRKIoZmUE04zxT2AUk1yw8YnJs87CL80b9ER8cE2T6/EnyGJCshIatnBlLib8b
	 8DpllAc4SqM9P1u8xQt10vea6geHRtVW2CsAKUDf6Kl9dlloN1eHc11HtJKGjXvPt+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794751357;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=qJ0EchGlVA269SbkEhgc06ZWAj446vqDrn2p8jAuv/E=;
	b=nRUkhFd0WVcScxo4hvwYLrADQDR6UMR5Ldlc8QJUbBiu2Dd0V84rau1o89SRSxviUwuy
	 KpI3cySjEJ8pFuqNLc+Ui187lT6h2YN6PdPlQMJP/Wn/HvzFYdXIqaiMmZbfm1l6TT+EW
	 OuJC2rSmqns/nKKPOnDzeh1ez3X6XawcPUYycwMKgagaj3Z/OJN6NkleT0MiLILjfjCna
	 Y43L3Zf7bzY0yFGVD+ojNnyBJ83MlQ7QWPAi9AEh8OTkPXC7rpJUpy+U76FHI0QSRRhHh
	 FbWE468lZAjwHn8L5el24ZR4HH3FNkdnjf980owz57Sbotb8SS2cOXPoNjUciRlEKrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j9ddginL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59390606A327;
	Sun, 15 Nov 2026 14:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j9ddginL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE30F1F000CD;
	Sun, 15 Nov 2026 14:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751357;
	bh=qJ0EchGlVA269SbkEhgc06ZWAj446vqDrn2p8jAuv/E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=j9ddginL1G0GxAHDpTjszI0GOWTyBzsRGUoqoOS/Eq8EtiggIDFzkrpgaY+H2IhoP
	 F7aqPREaqPHqyq4OWyMq1EFrAlM4QIX3S8k4pDFGQwI7QWeE2U5nOf8pNR8VpggXuZ
	 MA1gn14DoMP0a7WU8bqRZ5MQCZCUhB45HgWBLR4H9dxZ/IXff8SUQG8rNjQahgLXg4
	 +AH8yGJ424iNwn3m70UcEEcndFSWEe99TefI+eeanISs9IGtZvBjIwrADK98N4ryJF
	 q2PksGa1dCMIgZ8X9dxuC9g1esWHbuQWvX3PpeLUnne4rIxIyHyBSgOQ0Z859r9Hh8
	 T/9hROhAfl1nQ==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 15 Nov 2026 15:01:38 +0100
Subject: [PATCH 08/13] ipe: handle errors from resolving the real inode
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-work-ovl-d_real-v1-8-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2633; i=brauner@kernel.org;
 h=from:subject:message-id; bh=5DKvK6nh9WS+g3ryQ++IdJj14tjmxK81GaGi01tWosw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93B05rfno6g8PCtlUrx64aLL53fxOYZOOh/+aGYKkd
 4cJLlAW7ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIFmNGhjtnWnuNPd2FTQ9o
 zxPitZL93r+hRG6BfmmXsTpLMrvvPIb/Hjr7DYQrrr/flR1urazf7bq6ZpaMxQb+LiuRs/v4roj
 wAAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

d_real() is about to be able to fail for D_REAL_DATA. So switch
ipe_build_eval_ctx() from d_real_inode() to d_real_data_inode() and deal
with the error.

Currently, if overlayfs fails to resolve the data of a file it hands
back the overlayfs inode and IPE evaluates the policy against that. The
overlayfs inode has neither a block device nor any fs-verity state so
none of the properties of the file hosting the data are visible.

Remember the error in the evaluation context and if a policy is loaded
refuse the operation with -EACCES without looking at the rules. That's
what IPE returns for every denial and what IMA returns when it can't
appraise a file. Permissive mode allows it like any other denial and
without a policy IPE still allows everything.

Note that the operation wouldn't necessarily fail on its own. overlayfs
doesn't verify the data again on mmap() so a file whose data can't be
resolved could otherwise be mapped executable.

This is a no-op until d_real() can actually fail.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/ipe/eval.c | 15 ++++++++++++++-
 security/ipe/eval.h |  1 +
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index 4a7be96c84f03..3751963509df4 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -102,7 +102,11 @@ void ipe_build_eval_ctx(struct ipe_eval_ctx *ctx,
 
 	if (file) {
 		build_ipe_sb_ctx(ctx, file);
-		ino = d_real_inode(file->f_path.dentry);
+		ino = d_real_data_inode(file->f_path.dentry);
+		if (IS_ERR(ino)) {
+			ctx->file_err = PTR_ERR(ino);
+			return;
+		}
 		build_ipe_bdev_ctx(ctx, ino);
 		build_ipe_inode_ctx(ctx, ino);
 	}
@@ -335,6 +339,15 @@ int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
 		return 0;
 	}
 
+	/*
+	 * Without the inode hosting the data none of the properties of the
+	 * file can be evaluated. Refuse it unless IPE is permissive.
+	 */
+	if (ctx->file_err) {
+		rcu_read_unlock();
+		return READ_ONCE(enforce) ? -EACCES : 0;
+	}
+
 	if (ctx->op == IPE_OP_INVALID) {
 		if (pol->parsed->global_default_action == IPE_ACTION_INVALID) {
 			WARN(1, "no default rule set for unknown op, ALLOW it");
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
index b26d1147d0708..58ca50987b2b5 100644
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -42,6 +42,7 @@ struct ipe_eval_ctx {
 	enum ipe_hook_type hook;
 
 	const struct file *file;
+	int file_err;
 	bool initramfs;
 #ifdef CONFIG_IPE_PROP_DM_VERITY
 	const struct ipe_bdev *ipe_bdev;

-- 
2.53.0

