Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794751336;
	b=MuFpfV4EGofMJOPyu43wReN+kkID/96PQZKBBOvSQpbwqoiHblxnVd5/XL1nj8pe8kse
	 PfyBqNhHepptdKsNv9/mDABhvKBJdqMSxbuBEoG6jpkDw0fZOachCvZwAOOLNeyFyPvJ3
	 pH+jgdlsm94RgEFWLEQgCy79/IBc3MRMZEjEbx4TwGJIHkeXHrncLb5AZ9ZeCNcdsSnPY
	 tmU3VUmy9yMjxMZckk/VvjdCdT9XRdMg0ml0b6In33RYsA3NWvtuSjGh6lkDw8GIyR7eL
	 pp09jWjhSCx0VOolDB0S5NFD1vUAPWgLPMPrfzqucJsGE/msfVtgVd34V5jej4eMQHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794751336;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=c6eosVpV9md7dDH4Dg9j5xGxupJ1RL325XFcOlNRDkU=;
	b=HGjcFwbDi+YmzyOQ27YQph/GTxU09DPxSLyJwAaC9HS/HNKnyhIjpIL6YubvrUQwHM4G
	 jwBS4JoJ9jn1WYUrAhk2IQ3kGh4OV5GVvbPDjcNjjYYFQeg/k259c0vbHOkBs2FMCiVMq
	 LjnUqop9hCLTY1in0s37RWNEYQOv9QyG9PlHSnNg8SEWMdVPsx3D5pxwCZK9kyZujzqpN
	 t4sh36xMJFdHM31m8oFaKA3FBxUlvzuc26H9dQMC2Ji2dwFlYgBNZsnFTS3/CDlaR1e3d
	 vxQgdAHm++eRS960e9kRdLca/7+W7HUNVrgemCNAshjvad0WiWK64Wqn3g/Vf5ksLyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="lOksanS/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05BE606A337;
	Sun, 15 Nov 2026 14:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lOksanS/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3AF1F000C5;
	Sun, 15 Nov 2026 14:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751336;
	bh=c6eosVpV9md7dDH4Dg9j5xGxupJ1RL325XFcOlNRDkU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lOksanS/VqnZbRdXu7nBR840FdAclGs5Z+PmqFV3kKfja5rHjnJPZqe/pc7VoV5/s
	 YhNIQhsNZtFLQ4iGgN0xGxKQ9vVvxz5Mcm4wVs/YdwVbRBeZOFiVBdsCG17zj5Cpfu
	 sOO5LrGglgmjkK1AwqwrI2Kutcer8RoRRGdcD+8WpHbb1322gA5vltaSK2i38uBb9I
	 Ijicb7W8qmmdSMq/PEF10VUq1wHK7taw1/uDPE3w0FR5RJ7LPvwRu/mNgP6erhMHGY
	 08ytPETR+u+r9iWoOHE/OtPDAvB55cKDKngLMs3fzuhMDLRhxvJpZ4QYb8cBDkSx6t
	 i+FWaOy+K+ShA==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 15 Nov 2026 15:01:31 +0100
Subject: [PATCH 01/13] ovl: don't warn when the lazy lowerdata lookup fails
 in ovl_d_real()
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
Message-Id: <20261115-work-ovl-d_real-v1-1-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3156; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Zbi39YqO7L9a16+QLh0UHzMgmw4RUFL6Vukkxu0QXn8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93B2wq/7JO5+brPs++rxTut3jnXzktIT25pkH/hUdE
 Eprz1dh7ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIhAPDXwGvnVdyXTZcPXfx
 qOxa+4jMZXy17xbpvc58Y2LnZbRycQcjw5smzY69HhfVVpVI7cvL/53v8DvnY5GP9Xyte6yOubK
 p/AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

ovl_d_real() looks up the data of a metacopy file in a data-only layer
itself if nothing has done that yet. If that lookup fails it WARN()s and
returns the overlayfs dentry.

Commit 42dd69ae1af4 ("ovl: implement lazy lookup of lowerdata in
data-only layers") assumed that the file would be read before
trace_uprobe places a uprobe on it so the data would be there already.

But nothing actually guarantees that. trace_uprobe takes the path from
kern_path() and calls d_real_inode() on it when the event is created and
again when it is enabled. So a uprobe on a metacopy file whose redirect
points at nothing warns twice:

  ovl_d_real(/f, 0): real dentry not found
  WARNING: fs/overlayfs/super.c:79 at ovl_d_real+0xc9/0x210, CPU#2: sh/279
  Call Trace:
   <TASK>
   __trace_uprobe_create+0x1869/0x25b0
   trace_probe_create+0xcc/0xe0
   dyn_event_create+0x46/0x70
   create_or_delete_trace_uprobe+0x3c/0x70
   trace_parse_run_command+0x1a6/0x320
   vfs_write+0x1cd/0xfa0
   ksys_write+0x116/0x250
   do_syscall_64+0x10e/0x5e0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

bpf's uprobe_multi does the same.

A failed lookup isn't a bug though. The data can be missing, its verity
digest can be wrong or a signal can interrupt the wait for the inode
lock. ovl_open() simply fails in that case and
ovl_maybe_lookup_lowerdata() already warns ratelimited about failed
lookups. So return the overlayfs dentry without warning. That's what the
WARN() path returned anyway.

Fixes: 42dd69ae1af4 ("ovl: implement lazy lookup of lowerdata in data-only layers")
Fixes: 184996e92e86 ("ovl: Validate verity xattr when resolving lowerdata")
Cc: stable@vger.kernel.org # v6.5+
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-214581@kernel.org
Reported-by: Chris Down <chris@chrisdown.name>
Closes: https://lore.kernel.org/all/20261114120557.4bc1eb6e57218cdc@chrisdown.name
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/overlayfs/super.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 08695a99f4f93..1985b553a47b7 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -58,15 +58,13 @@ static struct dentry *ovl_d_real(struct dentry *dentry, enum d_real_type type)
 
 	/*
 	 * Best effort lazy lookup of lowerdata for D_REAL_DATA case to return
-	 * the real lowerdata dentry.  The only current caller of d_real() with
-	 * D_REAL_DATA is d_real_inode() from trace_uprobe and this caller is
-	 * likely going to be followed reading from the file, before placing
-	 * uprobes on offset within the file, so lowerdata should be available
-	 * when setting the uprobe.
+	 * the real lowerdata dentry. Callers may ask for files that were never
+	 * opened, e.g. for uprobes or O_PATH files, so the lookup can fail
+	 * here. Return the overlayfs dentry then.
 	 */
 	err = ovl_verify_lowerdata(dentry);
 	if (err)
-		goto bug;
+		return dentry;
 	lower = ovl_dentry_lowerdata(dentry);
 	if (!lower)
 		goto bug;

-- 
2.53.0

