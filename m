Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794822293;
	b=iOq8/ySgMwokBEQUUKXBE3ve1Pkw3pWnHGvrmMm3GobXfUbcEzQXajNFkw9ooaGNnGmA
	 Nkgs2X/UdLLyAg0W+pXJUeqN4QbGo2miYiTlbI92Jy8diLxsxD00Oi2AgtdqeNf7wPG2b
	 nmcGePSe6BJ4JTtxYJGZKcQBrx4f12vdYd/rdVWS1ZdtEEi/UVGRpIxVchnUe/hIyWdjv
	 0HaMmQWtSBqcpr1ooEa+GhACJOR1r/zdOdvqgreWjMLBxFp3NaYRZqtlDZCIn2F+KUjBJ
	 xI4iCRHa+0Iqru9SukBcPLMlNXXKcSPdbNcpHh01qLkRVMJHjCIyjsQGw41zbHT9csQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794822293;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=IANanOK2Ba1PGTfMVQPFJfqOkf92d3DF/Ps8jRPsPqw=;
	b=U58KtZPZU7iiZ4LLc4eZJ2RsCGhXitqlXassd69KOkXFhD+I+zEmRUrApdnU5Ib817kW
	 nVfn6OuLO1ffrdeYjuO5xSM63vvCvsQAbsobcqX96aPYAcmqUbdXi/yYj9jcVLJ3nzJIf
	 vvx5A9Muku9J/Lxc9s5lKeRoTfxA09ldSoJYG9vYDWgSeDb870Xi6/umbBsAYWaCYSWkB
	 ekWgX/pOOfj5kTXVfTt9BSQsZexTHsP7UG2U7TWQvlEbTKH3NxSqrVy2HXk3Eyo8AaZl2
	 APjrm88oTXjiNtokURUsk94Lr8+W2qIrntXe6ugohzlXXmvrMUSlIW5Pniha279dcDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y6Xs8JpC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81643606A891;
	Mon, 16 Nov 2026 09:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y6Xs8JpC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7DA1F000C4;
	Mon, 16 Nov 2026 09:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822293;
	bh=IANanOK2Ba1PGTfMVQPFJfqOkf92d3DF/Ps8jRPsPqw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Y6Xs8JpCsGXuHbxdEkg8lvIZQYZxeM+EJ6/DbIIqWmClvYwhme8OlMochEtTROaSS
	 NIgtmTOZQvl3ODCUHi1+8r00a+CowPB+/JjqNNeFEckqc0KlLZOR+chquX4RXbnEEt
	 T+ICKp+ujhe5EabSPRCkh0zedJI1hEyOAT1YDJEoCF1tTAtS1Yh0+xFsp1FS+p80q+
	 KbVba8MERMf1NeS/iLtTzcSPtilA6qtKnqXYNAAMkp7g0sTIr4vsiw5cXEor3Gd34E
	 7j4R6FigAMH/3wdIr7I6i223HI6JUXaqAEQ3fmMtNyp7Dqo1wM/YxSxPP8spa0l1Rp
	 j2zEak9XjptEw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:44:02 +0100
Subject: [PATCH v2 05/13] selftests/bpf: handle d_real_data_inode() errors
 in bpf_testmod
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
Message-Id: <20261116-work-ovl-d_real-v2-5-90564c4ae347@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1637; i=brauner@kernel.org;
 h=from:subject:message-id; bh=CFSBYOx5MWIEkJ6eS1K7mXopv2zlOaMFahzvyHIDvE0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ulBSP4Vzyv7/kqnSF+a8D33eYM7sp7kgrt7916a/J
 qtF/2282VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRe/YMPxkDr+7Yeft72dTD
 cSE9HcVHy57JscvqXt2Zz6HRIfjssxojw/ufZRs3xR6Nefp/2c442Xe2d/LcVDb9vV3w2L+lIGf
 hfU4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

d_real() is about to be able to fail for D_REAL_DATA. So switch
testmod_register_uprobe() from d_real_inode() to d_real_data_inode()
and drop the path again if the data of /proc/self/exe can't be
resolved.

That's hard to hit in practice because exec opened the file already but
it is the only modular user and d_real_inode() is going away.

Acked-by: Alexei Starovoitov <ast@kernel.org>
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

