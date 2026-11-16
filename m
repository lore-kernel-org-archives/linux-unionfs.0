Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794822303;
	b=bDs4Rq+0k+4lQ+/XFckGuilLeGRanUzS1S7JQWiRIAIEszjVaGd4RUBq/qEa6VZLSRd5
	 TM5QXRIjkpDKtlmWIEWKymFP0oOw1e2cQJuqmPp13ICsEC5oYx7ywe1Iphjaqprk9zlY7
	 Odyd1FBQZsYsLp3A+RU01roH6nCswlu/OcGISrz/+Z8aVvkqdSbdpDpF1UQ+LmssyfL4S
	 4JxOFx14L1j/jloxXVS4+sqqL/UwrtEw692zilumjbhaOzdvI52cMGntvohz64W4HHGer
	 7g0UFTaE8eerKJMxNisHQ8UusKExdjXF6SuIwh14GBlQgJwe2y3GWQLEReypB0KMnJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794822303;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=vyW5QdKol+80/fjPgvhCylUQMF0z10mUg5s+ZbR/1uo=;
	b=0lRpdeYsadTyh0Tyu+Nj46swasHOd3UBoG2faxWoNzelZqiuuqklxfNDFSu/AqGGyRBE
	 RaYsR5lMYxYJE0DoITEYmfpAb6pUdVWmal7QZ5Vfu4xcdpKDsssvfn05Es+SgfjsLEADb
	 aeMEBjo6bG0Yqzwx0jqeAdR0Yt87B2AdrstlIkooT66TZaskO6PrwVPQdTUnJigYzGvHy
	 ARd6tIxFkvIgi2z7RbIQfgnGOozWPrqZ+fyo4yykxO3j+tT3BjHMXxDYsjIDgH8ULzVcn
	 lRgZhpMpVh5eTcqbujg4F0EiJuRG6QR+p2NkV10gSzolKY6izTfUxuurs7/dObRZvFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lprTDZ0s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2A5606A32C;
	Mon, 16 Nov 2026 09:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lprTDZ0s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580CE1F000CA;
	Mon, 16 Nov 2026 09:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822303;
	bh=vyW5QdKol+80/fjPgvhCylUQMF0z10mUg5s+ZbR/1uo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lprTDZ0sQotlHE/T58JvqHpPZT4UIPTL1aLAQ2c4vEHkIBx6rHhUdCUq6m8e1vPyK
	 PiAGWx2oLXgoC2RQpahV1BJEHTspBaY35fOQaE0ayPJbK2D8znJHHq+zsLdGNt6gmo
	 1ToKqIYZAcnAzWEMoa8mmSZAuSQ51ifK2Ug+BlNm+OEzaOIGtrPv9bhaXo5n2FMgMo
	 YmrevFYS1qHv7mgiu/jtpB+oRnR25WUoOcL7FMt/7bPHayO/XKCqSu3jFq6pRjjx+t
	 L5ywSOkyLF4vwl2LMkrIykHKjQIp144Z9EhRMyNsgYX2hNPyYUBU/u+Nxoq44qZVfi
	 6BOPmJD4ovJQg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:44:05 +0100
Subject: [PATCH v2 08/13] ipe: handle errors from resolving the real inode
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
Message-Id: <20261116-work-ovl-d_real-v2-8-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
In-Reply-To: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Fan Wu <wufan@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1834; i=brauner@kernel.org;
 h=from:subject:message-id; bh=fPWW49CWnZPR7FyEd0MmVPmcEagSdOdrpi8w3Ql2zVg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ulA+1YdlymPb6RFeazOEZ/k9/VjUem+5eE6jlN7t0
 7Yx4SvsOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZyypDhn+mznLf+U0R+vBBZ
 s1aO3+fL589PdtqcVzunfSEpSbFkeRPDXxEHv5mMfn8u8x6Su3Zm4r9PZRP8z6gq18a9yVfc/lt
 4Og8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

d_real() is about to be able to fail for D_REAL_DATA. So switch
ipe_build_eval_ctx() from d_real_inode() to d_real_data_inode() and deal
with the error.

Currently, if overlayfs fails to resolve the data of a file it hands
back the overlayfs inode and IPE evaluates the policy against that. The
overlayfs inode has neither a block device nor any fs-verity state so
none of the properties of the file hosting the data are visible.

Instead, leave the block device and inode state of the evaluation
context unset if the data can't be resolved so the file is evaluated
without any dm-verity or fs-verity state. IOW, IPE reaches the same
verdict as today but without looking at the overlayfs inode.

This is a no-op until d_real() can actually fail.

Suggested-by: Fan Wu <wufan@kernel.org>
Link: https://lore.kernel.org/all/4e9a39ac-9ad5-49d8-b0c4-09e665504609@kernel.org
Acked-by: Fan Wu <wufan@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/ipe/eval.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index 4a7be96c84f03..a2366eb9a47b3 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -102,9 +102,16 @@ void ipe_build_eval_ctx(struct ipe_eval_ctx *ctx,
 
 	if (file) {
 		build_ipe_sb_ctx(ctx, file);
-		ino = d_real_inode(file->f_path.dentry);
-		build_ipe_bdev_ctx(ctx, ino);
-		build_ipe_inode_ctx(ctx, ino);
+		/*
+		 * If the real data inode cannot be resolved, leave the bdev
+		 * and inode fields unset so the file is evaluated without
+		 * dm-verity/fs-verity state.
+		 */
+		ino = d_real_data_inode(file->f_path.dentry);
+		if (!IS_ERR(ino)) {
+			build_ipe_bdev_ctx(ctx, ino);
+			build_ipe_inode_ctx(ctx, ino);
+		}
 	}
 }
 

-- 
2.53.0

