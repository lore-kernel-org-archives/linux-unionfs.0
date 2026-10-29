Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793282436;
	b=htQJzng60jpT79x+fb7QWFw6yser5yort15of6a/DBUzYjdFofZH15pTgTVs9lJE864Y
	 e4N5zJmBB0YKjGrx9wB7zjZzK/LgO0YqUSlIeZcu7t9ua40Li8SX8wRjbe3hug4alVeh6
	 TtUSqhVl2dWvpp6S+8+y+LbHeQlFna0gx1x/eFfhaok+AXiVotJ1WvtiJxOlFEObTrT4H
	 QY4vsTyyrfJxaFfBUxzZ6HTpXuynPV9XfyyON6w5k6BfOqfLwSzDifXuxJsIarUmMuaks
	 iUvJWLwayD61fl6tIpf+p+LI8S3bDOzQUD88xVEecU22qQWTn8wCtQnVSdESoPyn2YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793282436;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=MLLAdMU5HT5t86S+vjGAxgKxyxaC1MN1KU1SlVyCf48=;
	b=RiEmni7+DSU0QTYX5zKl+nzeAi/v4l4vb6I2OxVlU/q3N7YHRgqo37E3PmVumKJw8bP/
	 qwNd4zKtjqupt4N3iHvWzL57+DjKDChytZEKtzyAqSHzndoobGCy2x9gc3o0vJ1/kTW77
	 46fYKrYHIbDx9kHCrtuzGM2WWD5UhJWGm/LdxzjIc2CovXHHgfIoFf/X27sRZ4f7q+iNO
	 2x04rlj6OhdH0cFSPPctcULPjXf0twD2EjaWlIjHO98H3w7kkZiakFAzGgcF49v1hKbWf
	 bOoazg8Yv8LNEfOcIdfAgC9hRkNd1bsFsof5cnVEBK66IKfetCUpcQ19xLPWbHb+4HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IuNJxDnj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7E6606A325;
	Thu, 29 Oct 2026 14:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IuNJxDnj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2948C1F01829;
	Thu, 29 Oct 2026 14:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793282435;
	bh=MLLAdMU5HT5t86S+vjGAxgKxyxaC1MN1KU1SlVyCf48=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IuNJxDnj7d9wLRRWHKbLI00gvfslOaWMSCopeA6elf36hhCM4SdrXrlYnmVfyz3Hs
	 F7KvMnYkJJX7IXooNVXlBhr5cv093PF1PUBSu4WPEpGN4aeBeR1ZXok/ooc7rv1An2
	 4s4QIIzl73RQ5QHUNyWLuwOo1zoIjRYd4TKVl3XGY0BKbCwgJ9675N0ScxqP0gl/3c
	 5jr0F/6I4NEuThgMW/XYiPf6DV2zLdFWbfxiYH+9a7Tz3N+Zd0YMksf6tEyp744OdW
	 bDDDsfR+GpKYdE1Rf/pPUDSqxyNsy6JioXTKfFvVYmbnvwbxg9yN28ilTuhGycAM4b
	 V2LYbbLclkxzg==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 15:00:20 +0100
Subject: [PATCH 1/3] aio: fix NULL deref when a fault races ring truncation
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
Message-Id: <20261029-work-fs-ai-fixes-v1-1-88f22792f6f7@kernel.org>
References: <20261029-work-fs-ai-fixes-v1-0-88f22792f6f7@kernel.org>
In-Reply-To: <20261029-work-fs-ai-fixes-v1-0-88f22792f6f7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
 linux-aio@kvack.org, linux-unionfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3646; i=brauner@kernel.org;
 h=from:subject:message-id; bh=r0hXdS9DkzlJ6nPMHVJZAXe24OnrKrajsnJp/+nD854=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9Dqxe/4Etf8eZA7ON5OJ+zhC9/alCuXB2y6HgoI8ZL
 968ys/Q7yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhI7E6G/x5GIX9TtfO6/xVe
 mxVvJBD0ifW285MS0/llmaYc4l9k7jEyXDpXdDL43kbV4z8l587/07Pt/2GP7K8eb/57JgVuPvl
 ImB8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

From: Chris Mason <mason@kernel.org>

The aio ring lives in a file on the aio pseudo filesystem and the ring
VMA uses filemap_fault(). aio_ctx_aops doesn't have a ->read_folio
because aio_setup_ring() puts all folios of the ring into the page
cache. So a fault on the ring only works as long as it finds its folio
in the page cache. If it doesn't, filemap_fault() calls ->read_folio
without checking and we jump to NULL.

We already fixed this twice this year. A forked child could inherit the
ring mapping, fixed by commit c03ce4173c7b ("fs: aio: set
VMA_DONTCOPY_BIT in mmap to fix NULL-pointer-dereference error"). And a
partial mremap() could leave part of the ring mapped, fixed by
commit 3adf7ae18bf4 ("fs: aio: reject partial mremap to avoid
Null-pointer-dereference error"). Both times a VMA outlived the ring and
the ring file was truncated under it.

There's a third way to get there. kill_ioctx() and the error path of
ioctx_alloc() unmap the ring with vm_munmap() and ignore the return
value. If vm_munmap() has to wait for mmap_lock and a fatal signal is
pending it returns -EINTR and the VMA stays. free_ioctx() then calls
put_aio_ring_file() which truncates the ring file to zero. A fault that
passed the i_size check in filemap_fault() before that doesn't find its
folio anymore, allocates a new one and calls ->read_folio:

    fault on the ring                 io_destroy() with SIGKILL pending
    =================                 =================================
                                      vm_munmap() returns -EINTR
    filemap_fault()
      i_size check passes
                                      free_ioctx()
                                        put_aio_ring_file()
                                          truncate_setsize(inode, 0)
      no folio, allocate a new one
      filemap_read_folio()
        ->read_folio == NULL

All that's needed is a second process that shares the mm. If a CLONE_VM
child calls io_destroy() and gets SIGKILLed while it waits for mmap_lock
the ring stays mapped for the threads of the parent. Any user can do
that.

Instead of plugging the routes one by one give the ring a ->read_folio
that unlocks the folio and returns -EIO. All folios of a live ring are
in the page cache so a fault can only end up there if the ring was
truncated. The fault now gets SIGBUS. Nothing else reads the ring file
and the aio filesystem uses noop_backing_dev_info so there's no
readahead either.

Making vm_munmap() unkillable in those two places would only close this
one route and bring back what commit ae7987835643 ("mm: make vm_munmap
killable") fixed.

Fixes: 36bc08cc0170 ("fs/aio: Add support to aio ring pages migration")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/aio.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index 4f32b45cb8a0..893db6961ad3 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -528,7 +528,18 @@ static int aio_migrate_folio(struct address_space *mapping, struct folio *dst,
 #define aio_migrate_folio NULL
 #endif
 
+/*
+ * filemap_fault() reads a folio that it did not find in the page cache. All
+ * folios of a live ring are there, so the ring was truncated under the fault.
+ */
+static int aio_read_folio(struct file *file, struct folio *folio)
+{
+	folio_unlock(folio);
+	return -EIO;
+}
+
 static const struct address_space_operations aio_ctx_aops = {
+	.read_folio	= aio_read_folio,
 	.dirty_folio	= noop_dirty_folio,
 	.migrate_folio	= aio_migrate_folio,
 };

-- 
2.53.0

