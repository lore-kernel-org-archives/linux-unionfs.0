Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793282433;
	b=snM3iVugO5ztAbOq2IEgqb6B3GvxT+xtqnIeJKrrle5xK6kUEatnluKCZAC01SldI3IH
	 VU6Ag53i7KhE32mn7He8oWSG82lxwozFWauMGM3LPog1b94xadQ3ttf6qx8NGKJ+a8Hyk
	 wGHw63DlXm4DLbYSM9GTodUVMiXVxoeNKIbHB7kwj3C6Yh3mKpqD4fA8Hg9+A/sfR1aYN
	 gIf/xydoMrwi45AIbc1d7YpnIEFD1WTyeTK0dENTp7U+MKZUFABg2tUxz+NKhnge7tofk
	 62d9xd765k6eZszDgcYPB7T1Ht17pLqPvPItR4tNR/vKA7/O/ZhnbANbC+VpEoeargQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793282433;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=YxekygzBxsNDcLoi4D5NHM3izgiL6ovqXJCr0LnyaUI=;
	b=P6S+x0R2X/3YI7XWBOKLlqv0e0FVq7bck4H0HWfHR+ftuaVq2YVx0gEzmoYpsBAKJ5d4
	 wm2mxj0U+x7QBELjWlaBe9VKNpAelIAcAJpbN5QeHlfoB7Dg+mc3VffMpZ1ARVlRiSxd7
	 foVpZnUsXnNzre2WriiywfP7WKchO4wVcBXTxOwnDfPjlX1WjtBvUQEKkyMyHpBHMR4QL
	 hStNyjVjQe2GCDZIWxmTq5lufBTajjiGUhOqyfoxBjGe38RSFI42qjGocvl1dZHkfwWnl
	 z2rgGbQFy4d1fJYL6ZQE3JJIJBU76AT42VJZdwFrsdkJTwLimMJLZGsijLNH5CGCvbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JgM5p73t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78818606A31D;
	Thu, 29 Oct 2026 14:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JgM5p73t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6211F01828;
	Thu, 29 Oct 2026 14:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793282432;
	bh=YxekygzBxsNDcLoi4D5NHM3izgiL6ovqXJCr0LnyaUI=;
	h=From:Subject:Date:To:Cc;
	b=JgM5p73tZ0XDa9iy3MbCsU+BHR2NvteXXvx27W4hlENX4vHHrPK3ALLagnO4+ZJ3K
	 KO33bL4EJfEKQYgvT/WnnQ2BuaEQEcdErCdbZj0v0sGQjqyNG+C9kakaYkApZSq5oP
	 /IlVYZpxYbLhlHNqKdOXBDLXktcbhS8I/3IS/BzIwnXq2VpKw7olrnkC2BHfyjgjiv
	 pu7TTutlI8PI1n3tKbaiSHJMGRQy+C6mzuQg6ieTP97PaJLI70mDOYHm/xf56ekV9G
	 7znGrV4wOo+Hq6V/2gxI2vfSQ2U7PTUCuQXv6M4o0GhLpynKKgCP5Xhr00mwBOjnVn
	 NcfcLhbs/K+CA==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/3] fs: fixes for aio rings, backing files and
 iov_iter_alignment()
Date: Thu, 29 Oct 2026 15:00:19 +0100
Message-Id: <20261029-work-fs-ai-fixes-v1-0-88f22792f6f7@kernel.org>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/zWMTQ7CIBBGr9LM2iHAwlivYlwMdLCjCTWM1SZN7
 17QuHzfz1tBuQgrnLsVCr9FZcoV3KGDOFK+McpQGbz1R2d9j5+pPDApkmCShRVtsK53bqATEdT
 bs/C3qK/L9cc6hzvHV/O0RSBlDIVyHFvUjCap+RtN62Hbdmvt6QCcAAAA
X-Change-ID: 20261029-work-fs-ai-fixes-0b01911da8aa
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
 linux-aio@kvack.org, linux-unionfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2700; i=brauner@kernel.org;
 h=from:subject:message-id; bh=36jg5gwmg7BOgPkta04SwpDslnorY2za+ZK4iofOV74=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9DqwOeuRwYIFyxXbW7c0uTZ98pr3v3OH+60zAQxPvl
 Jlxja51HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNxPsHwh09i9Y87qdU96+v6
 v0/5EHDe24h/oat6efw0de/p//55sjD8T5S59CSvRjFDLcs81vKro9L/5NfuC3TTp9xfxtgxJ+U
 ANwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

The aio bug fixed here is the third way this year to fault on an aio
ring after its file was truncated. The ring file has no ->read_folio
because all of its folios are supposed to be in the page cache so we
jump to NULL. This time vm_munmap() gets interrupted by a fatal signal
in io_destroy() and leaves the ring mapped. I didn't want to plug yet
another route so the ring now gets a ->read_folio that fails and the
fault gets SIGBUS. Making the munmap unkillable would only cover this
one route.

I rewrote the backing-file one. FUSE passthrough opens the backing file
with the flags of the user's open but never runs the may_open() checks
against the backing inode. So a passthrough file backed by an
append-only file can be overwritten anywhere and one backed by an
immutable file can be written to. Chris' version only checked the write
paths. That left shared mappings and S_IMMUTABLE open and it failed
writes on file descriptors opened before chattr +a which can keep
writing on any other filesystem. So the checks are now done at open and
mmap time like may_open() and do_mmap() do and writes only fail if
append mode was taken away from the user file.

FUSE reports EIO instead of EPERM for a refused open because it turns
every error from opening the backing file into EIO. I left that alone.
Miklos, if you'd rather pass the error through I can do that on top.
Amir, for overlayfs this only changes something if the upper inode is
changed behind its back.

The iov_iter one is a NULL deref that any user can trigger on btrfs with
a single zero-length IORING_OP_READ_FIXED on an O_DIRECT file.
io_import_fixed() hands out an empty bvec iterator without an array for
that and iov_iter_alignment() looks at the first segment before it
checks the count. Other places build such iterators as well so I fixed
iov_iter_alignment() instead of io_uring.

All three are tested in a KASAN VM. Without the patches the aio and
iov_iter reproducers oops and the backing-file one overwrites both an
append-only and an immutable file through FUSE passthrough. With them
none of that happens.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Chris Mason (2):
      aio: fix NULL deref when a fault races ring truncation
      iov_iter: fix NULL deref in iov_iter_alignment()

Christian Brauner (1):
      backing-file: enforce append-only and immutable backing inodes

 fs/aio.c          | 11 +++++++++++
 fs/backing-file.c | 28 ++++++++++++++++++++++++++++
 lib/iov_iter.c    |  4 ++++
 3 files changed, 43 insertions(+)
---
base-commit: 02a336a831f02a18047bacbd49018a237af8a172
change-id: 20261029-work-fs-ai-fixes-0b01911da8aa

