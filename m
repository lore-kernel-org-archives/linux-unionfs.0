Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794751345;
	b=Co98z3tcGeur/0Sznf7g6Vpc38CZOSy9UTs2VPoVdSa9wTRhF9rXHcMZKkpHFqFOydau
	 4ADtkuQwhcUlUlBkdZlbb7/m7fmXXaNKQenUkSbYfbFMSg5VEJJfeAM9U/ksAV2PQ0RQg
	 uHa7txWHugD/Qobf4cwqfvwRdBWlwIalNBQNVP5iHvtwnIkXl3orSTAIg/MKjftFdW+0+
	 0zsAj3uArIWNwvfKhbKYL2quu/2AYIwenAdfBCnVXtIQHy1udHVGE1BjFQiI9bDxIsMZi
	 NJfIJxnEof3r3wdbHgubLZTzTM9U+npONttun66MYeNIHQ4YHiYH0B0AxrwBjloLdlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794751345;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=5oUYGBoKkBqpSXIVcJnlDk8QcSCyfAXF5SKIMuUlOHo=;
	b=tMmXC2ho5gPaUt9ztxzGBY+jTB9FgVnuwLIvEfC/Xtj7z4ntE5eWyZ/OpkjnzyRZzj/m
	 cxB7ZkMlWywYxSSbwyJ55Z2ziU9AfBm7wyiemAcAh18XIzcvWb1+4auR2/yiuIgJUi4BC
	 rGBuY+3LxMxcIRZhzdBcv/90byQgARxaoXUTGW9TjePFcqSfHJ3viWsZHsIFz0djob+3s
	 TtpEeWxH7zTy4jKGUChuLTcOCt7Wezo+XOfK2o95GGBRrf8rMJ1JZemY95tdCy4nG5r/E
	 yRnjqCutlQvjmtPgAccxLVgjabTXiikGVhoV2cq/VOBGM+MozyVtGAySFE1hptIcP7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BKlN1ePm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23BB606A885;
	Sun, 15 Nov 2026 14:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BKlN1ePm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C463E1F0181A;
	Sun, 15 Nov 2026 14:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751345;
	bh=5oUYGBoKkBqpSXIVcJnlDk8QcSCyfAXF5SKIMuUlOHo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BKlN1ePmcvZPicZgSvyq2gFmq0LHU3RqhRWTkS89/oQQ5sMgH2mlZnbAGJYFYdVnp
	 CiTplMFlor+54osiSyJdokh0dOvWtdDkgTOa98BfA+GMnITM07Hd2rXbsZG9gez7sa
	 6smUBtR2bo5UYS3zvF7Rs8jMyJNBChu+d8PChicys8H7WUCvMmlF0BypywlI+bzR9J
	 0418lL6aBSmkiaiVMSy/8C5P617iY+VppR2k82Ks94lnFi2ANSyYohUGS3pe12PnUI
	 2jJ8sQmlCN2i+kjtTZX0Xcwta4TJe2Q4BMSUOfI+TQLc2rl4zkN7kvUe/uHGs+1IuU
	 8mpNAyJ2rZ57Q==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 15 Nov 2026 15:01:34 +0100
Subject: [PATCH 04/13] bpf: handle errors from resolving the real inode in
 uprobe_multi
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
Message-Id: <20261115-work-ovl-d_real-v1-4-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1988; i=brauner@kernel.org;
 h=from:subject:message-id; bh=viYx97t2m4wJXNi6UiuGqezFK69cu1tybe/q2U/ijp0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93B3S/t3wrMhMnloe3abb9kvuuKtx7+HYL3pxQ6Jg5
 VmbwiOFHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABO59ZqR4ckGD1OzKceyRDzX
 x5zvXScud2D3F2ct1/hcAdnEP5M0lzMyTLvkMYd5xS5PswO3P2jqHnzjWqf4L6PSyOTV4Zggfe+
 D/AA=
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

