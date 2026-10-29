Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793282442;
	b=JsOZCMHM8ijwpKda3NXRTTbapV+P4QMhGg4nc8We+XX/e+FOFyDf1aY1T41XnLRkLTc0
	 K+BCmW/U5ZR/Ith7kxOCHOP/ZGSr0F9975crCiVpCFIcNAmMixapRNWrhrsq+GBUPDR72
	 7K34dedDjujI3nhkXCiSV6RfA/irN9NWpt0rarStUK101fa5rcQpFFjlQbvZk0omEImeT
	 ILBKudbcYvVrCLkRdtfpYgBjlMQZeORx/OMwzgdso80ixSLEZictYluEKBWsQ5BbcEQJp
	 iLE1Pxm+aQoj80hIdpxtivQQ9XbCKAvKsHBZcUZd02e8yuMEa8x73JbRiIJPkO2tPsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793282442;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=al7UmKsb96lOU+RKqFHZjOm7ylGXuict7jiv3KzJHfk=;
	b=KDfizNSBvoKGfTxIelCSztTj2ixNz9PN/9S1oRcRk5bFqNQlghyuWVvpjldqW5wHJdD+
	 xKmkixzXL9n9anUe7zOqthe6vjJcL4CS+bs4lml0WUQOu5PBqhHbmp6rrugRX2BKnWHyc
	 DJvp3ygw4TK8UaDlu6KaVPfE5P9bZS0M01CKOWVDFUPbFr+fNG6qpSfnZHT9NMxsZiSuD
	 SYbXS9gLkMpfkCjeHHmBhhajhkYdfUjc5WNkj1VYuSvRchOiuMvNoj1WiXhiJqSeLXuqE
	 qcCJA1suy4B0FjI37sm52YvbVTSDsYnAefuCzGIHYmSSkc7EHE7nZ1/xpRPgz/8SZoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h+uFP85g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B8A606A331;
	Thu, 29 Oct 2026 14:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h+uFP85g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5441F031E1;
	Thu, 29 Oct 2026 14:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793282441;
	bh=al7UmKsb96lOU+RKqFHZjOm7ylGXuict7jiv3KzJHfk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=h+uFP85gnikkPnQo2kSUJQ15j1EN9Vg2y14qjjt56RG1kOTTwFRKCyFkNb9mjmTFZ
	 xLau6+D236sVgk4qN0+9GPFwKW/gGBvCWPJ7myHR1a4QhPqWBVeLMnXp2OjJzCRNZl
	 AbSLPAUDPes/pm+wtQ6PWP122tpyYHAGFBT2BGvZFjqAbuWcAH3RpJiLBpk/OLm+QV
	 XYQ0Kw/Vf1b4UQSRqCI0FzRxyvVeD+8K+S3Ppcbp+7UBDf1gixLkl+ugdMTCjcrlxd
	 8613D6jBrR7yCvaMFv5SrQ0UF0zhIYMGpOunwZ4Nt0H7pZ8S8mkL6GawWzhfUmiEi6
	 u/C8hcCDa5hBQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 15:00:22 +0100
Subject: [PATCH 3/3] iov_iter: fix NULL deref in iov_iter_alignment()
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
Message-Id: <20261029-work-fs-ai-fixes-v1-3-88f22792f6f7@kernel.org>
References: <20261029-work-fs-ai-fixes-v1-0-88f22792f6f7@kernel.org>
In-Reply-To: <20261029-work-fs-ai-fixes-v1-0-88f22792f6f7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
 linux-aio@kvack.org, linux-unionfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1905; i=brauner@kernel.org;
 h=from:subject:message-id; bh=nhWMVYgWOYSkyxfd0VtYD/OB1+iZmFC+UDY5uicnwYU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9DqxWtf98yTladZPQmduHec6+ar20TiMw+vSiiQ80b
 sww8n+xsKOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAi28oYGd7mL5+kcyruyV65
 U6t8mhdXavo97F+ZHuYt8cf/jfCyqkCG32ziW1nmqu8siHz2Meyjo9+DSIkglVCtu88m8y9g9/X
 TZwEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

From: Chris Mason <mason@kernel.org>

Since commit 111a12b422a8 ("io_uring/rsrc: reject zero-length fixed
buffer import") io_import_fixed() hands out an empty ITER_BVEC for a
zero-length request. Its count is 0 and its bvec array is NULL.

iov_iter_alignment() only checks the count for ITER_UBUF. For ITER_BVEC
it calls iov_iter_alignment_bvec() and the do-while loop in there reads
bvec->bv_len before it looks at the count. So it dereferences NULL.

btrfs checks the alignment of a direct read with iov_iter_alignment()
before it looks at the count and f2fs does the same. So any user that
can open a file on btrfs can oops the kernel with a single zero-length
IORING_OP_READ_FIXED on an O_DIRECT file descriptor. With IOSQE_ASYNC
the oops happens in an io-wq worker. The dead worker stays on the worker
list and when the task that submitted the request exits io-wq writes to
the freed task_struct of the worker. That's just fallout from the oops
though.

Empty iterators with a NULL array aren't unusual. afs, tls and tipc
create them as well. So leave io_uring alone and make
iov_iter_alignment() return 0 for an empty iterator of any type.

Fixes: 111a12b422a8 ("io_uring/rsrc: reject zero-length fixed buffer import")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 lib/iov_iter.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 2072c04e99d0..56c59a2b589d 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -848,6 +848,10 @@ unsigned long iov_iter_alignment(const struct iov_iter *i)
 		return 0;
 	}
 
+	/* An empty iterator may have no segment array at all. */
+	if (!i->count)
+		return 0;
+
 	/* iovec and kvec have identical layouts */
 	if (likely(iter_is_iovec(i) || iov_iter_is_kvec(i)))
 		return iov_iter_alignment_iovec(i);

-- 
2.53.0

