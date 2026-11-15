Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794751348;
	b=1AxZcQi37imuqE7GLL92/RPgoPUPHlru0kysMErdrDm7ZloDZZYUb66YKJv42LCiKium
	 7bEfN+begTQyk3saswoffsbknyIlGF8yhi1ZDR6IjnNi05Twz+ffKHwdW6f5tleyVSCZY
	 oc8gcbROj2xGbdvR1MiUbxAawULtMx+T44RPOsetMcfGDZ5cA/8bjKAUDB1dnkU7hlqpm
	 3gVhBbaupt3OsDpqxiZtThEHri7L8c/NjjoPR8ArXzgY4qU5OxEC1D0+MxuVQJKZX6PUW
	 RqHwOlo6e7SuY8ZXmYlsIbCOGt+2ymH2o1WIUe/pLCKKNaXwbcCm5v4uvWqt1/+kE9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794751348;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=exSQh+ckYaGqDXTdGKRk/DINSz+CEfauTHf2mGVm1qs=;
	b=krrdUDvirjqgspGCHCbZ19Y16+iQK7IsiCk3gEQzFF3fBQr34iJ5GMvEJYwYWZW1l9vN
	 fMrH82HGXrSFmdF3vnti6eiksJObScIdevIn0j+IVy4t5E/Mm0j05bJfs2O4MMOm8lGHn
	 gO9dkXHEqAxDknqwfG9K1Tgs+F8ct0beiyxYSAvOr7TTR2k3xvwTjeP4X+4GTlRiYFnMi
	 esOeB+f8r7iBNHZblDoX+sUu+f1UwYA1VANwopZraSWCwbUh0qZSzzVWyJIPQHpQbf6hU
	 9IHqC32TYjJFcPPSbkVioS2f3paIm4z2RS+89C6IPAaFO3Nm25IvZK3wapY1L7b+xhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mVDBwAAm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E37E606A8BF;
	Sun, 15 Nov 2026 14:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mVDBwAAm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB31C1F000C5;
	Sun, 15 Nov 2026 14:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751348;
	bh=exSQh+ckYaGqDXTdGKRk/DINSz+CEfauTHf2mGVm1qs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mVDBwAAmMMfoI07kdlegIgj6TgxNBrmadzij2h6L+/SAceIm4g1BJTXFeH0ULv6Ii
	 MPoimMgdje5DxfoVdFo/7BqRAQGTsQhv7It1+6irZXYWHEXZ/IzNq4GP/O0V9HGLtg
	 6rQFM0ffCCWzBpHlPrBmQN9XBNtRjC4D+i+pFgXM44MQRmgC05j/CSzPHmoN4wJnfl
	 R9SepAKc2/vo6FRAm246FMyCPUTXU7d9DXT4Ql136WAN1hFOWQQcczRtkn9BTJcjYs
	 uy1P6CM3r9DEp47qWwldVtxy/IzyZElL1ervdfnyBqFpt5CZ/2GmyBJR3A92OdCw4R
	 /TqtG5CUfs3Xw==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 15 Nov 2026 15:01:35 +0100
Subject: [PATCH 05/13] selftests/bpf: handle d_real_data_inode() errors in
 bpf_testmod
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
Message-Id: <20261115-work-ovl-d_real-v1-5-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1590; i=brauner@kernel.org;
 h=from:subject:message-id; bh=8ojyWSbSgAy9/5Lt4D7/0d3uAgnyMk/lTnwvRHMWeIQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93B3q9z78x+8L37QlfDfd/xpzriLxjHO/uMxytjg93
 U+L72xW6ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhI+ROG/84TY99yZnBb1Hzf
 rbrBVdn1Q2DcbIv7EvejegKfntz2Pprhn9prvXMcX0qPHJebwriM0ev68+tK155UXfQNusKZnbM
 rkgEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

d_real() is about to be able to fail for D_REAL_DATA. So switch
testmod_register_uprobe() from d_real_inode() to d_real_data_inode()
and drop the path again if the data of /proc/self/exe can't be
resolved.

That's hard to hit in practice because exec opened the file already but
it is the only modular user and d_real_inode() is going away.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/bpf/test_kmods/bpf_testmod.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c b/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
index 76fbe64755ef9..9d065a800f655 100644
--- a/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
@@ -948,6 +948,7 @@ static struct testmod_uprobe uprobe = {
 
 static __always_inline int testmod_register_uprobe(loff_t offset)
 {
+	struct inode *inode;
 	int err = -EBUSY;
 
 	if (uprobe.uprobe)
@@ -962,8 +963,14 @@ static __always_inline int testmod_register_uprobe(loff_t offset)
 	if (err)
 		goto out;
 
-	uprobe.uprobe = uprobe_register(d_real_inode(uprobe.path.dentry),
-					offset, 0, &uprobe.consumer);
+	inode = d_real_data_inode(uprobe.path.dentry);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		path_put(&uprobe.path);
+		goto out;
+	}
+
+	uprobe.uprobe = uprobe_register(inode, offset, 0, &uprobe.consumer);
 	if (IS_ERR(uprobe.uprobe)) {
 		err = PTR_ERR(uprobe.uprobe);
 		path_put(&uprobe.path);

-- 
2.53.0

