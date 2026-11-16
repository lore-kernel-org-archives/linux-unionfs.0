Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794822289;
	b=KSIsmxDlBSRc7H8hi2XVeZmGCDyC15Lh/bFGBntCeB1+JjYg1uyt3bVBCpNUQzqcaPSw
	 FKlObat+BbzEuhHskKY9oa0SoZb8fw6uZPu2OixEXIFy049/3PCLfMbb7/j7HvaypTfFI
	 /92k7yZCMGPE6mgGPXN2Nw2d5SzCXGd118zK8Qi2zNoolDEWbBJInjIMVBKZriObplxQk
	 o03s3n2O59tsImHcusFrfDKStBwWNexs+JVjk+W41/MSP7fj71QgJwG1IXL3rnRShhwbz
	 e4c7JoxjY9pEGUEH7KqD8txeMVvHlYTw8X+UFaS6k/BfKzLvg24GUIJ5d8uC+MH3s5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794822289;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=AskB65cJoQPi1ReB9/fhm9DblVUbyR84Mt3cKfNU18o=;
	b=P36Vw4Jax4HI4oTAORkRjwv6gBxpeOa4heGUiBqThbfXsZG9cabJIVj0PqHDILS3RaHD
	 pchwr9Syw0NbHMwkyo5NxjN9YegWswIMGzFRUrZtVg7SUTYEzWfaYGQdZNfQ5/givPqhJ
	 1pqaeHbEwi6+Ir3Gu4i0xfbGjjW3GWgWFNHp/aVqadS7Tgax1kI4d4FiWOZc8Ym2XZw28
	 6jakAlki5tjd+5w7ZhVWjFu/C1HXBbKy1+dJ1i2H9jnEv/Aqu3N6l+sCxU3CK/219LDIa
	 MZDmf/8rFHshoGR5QAp7FkC5t3QjG1etdGVYb5rNEKVnE++y0CX91k15S9UxkpLME/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="iI/0Z97T";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D157D606A31C;
	Mon, 16 Nov 2026 09:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iI/0Z97T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9776A1F000CA;
	Mon, 16 Nov 2026 09:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822289;
	bh=AskB65cJoQPi1ReB9/fhm9DblVUbyR84Mt3cKfNU18o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iI/0Z97TWHJleWpplJITR8BJD2TN+kysLffD/3YQi1CrI0V4jhZQmJIVpvC7bmZHV
	 TM2A1F92pLjx8FyZxIVb025qs6dEIrLMkpEOhwpXqWalNqgCObsQS92c7qgKsOhAtS
	 NjzAGLscXobqFbaRNu5MHELODgktDkuvis9XMQ+M65lh5FPzLvWIv3ZXvc1HvF/Cmx
	 Ibsmwpp9zUNOG2yB7hHJ1BFvimgoJ8PUEQD1B1RhStmVOS0tM3vkrptvJWm7f45yVN
	 RLdzaPkT7LyB7rnec8t/XwNNe8pV+QnH3WAshQ5cVBT4guI0jRCHPvkkku/CTj8PYj
	 OuiIKWVpkm1EQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:44:01 +0100
Subject: [PATCH v2 04/13] bpf: handle errors from resolving the real inode
 in uprobe_multi
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
Message-Id: <20261116-work-ovl-d_real-v2-4-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
In-Reply-To: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2035; i=brauner@kernel.org;
 h=from:subject:message-id; bh=w0jMvi6Aqw5YdOXmHKxBMEO2g+Q12/7kbngiQF5xj0Q=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ulC0Ydnb74y8sqK8fcc3z3rrHDNDYoZzSrDLvWz/h
 LXSG3yYOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACaScISR4fSDtNDa6Mf/Q/j5
 V9zjnL53d1CB1bMmcyPXupyX1XpHMxn+Cr1fp/5s5tyHt+9GmlpF/7wd+oNj6b/6P63Wu49opv2
 cyg4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

d_real() is about to be able to fail for D_REAL_DATA. So switch
bpf_uprobe_multi_link_attach() from d_real_inode() to
d_real_data_inode() and deal with the error.

Currently, the real inode is resolved again for every single uprobe of
the link. There's no point in doing that. Resolve it once right after
the d_is_reg() check and fail BPF_LINK_CREATE with the error if the data
of the file can't be resolved. Then all uprobes of the link are
registered on the same inode.

This is a no-op until d_real() can actually fail.

Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/trace/bpf_trace.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 2aec56d7f3d3e..15f32b971326e 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -3280,6 +3280,7 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	struct bpf_uprobe *uprobes = NULL;
 	struct task_struct *task = NULL;
 	unsigned long __user *uoffsets;
+	struct inode *inode;
 	u64 __user *ucookies;
 	unsigned long size;
 	u32 flags, cnt, i;
@@ -3336,6 +3337,12 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 		goto error_path_put;
 	}
 
+	inode = d_real_data_inode(path.dentry);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		goto error_path_put;
+	}
+
 	if (pid) {
 		rcu_read_lock();
 		task = get_pid_task(find_vpid(pid), PIDTYPE_TGID);
@@ -3394,7 +3401,7 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 		      &bpf_uprobe_multi_link_lops, prog, attr->link_create.attach_type);
 
 	for (i = 0; i < cnt; i++) {
-		uprobes[i].uprobe = uprobe_register(d_real_inode(link->path.dentry),
+		uprobes[i].uprobe = uprobe_register(inode,
 						    uprobes[i].offset,
 						    uprobes[i].ref_ctr_offset,
 						    &uprobes[i].consumer);

-- 
2.53.0

