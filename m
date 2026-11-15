Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794751333;
	b=gOcqrr008jr0lmSy4sQlOfCga4d64py5MxBwfnfrFARwW6yas912Mobv1s6kGKy3CNLH
	 xnbi2vhAZj6cL1I+fwj73DqcPhmo4uS0j5uzggom1pp9QNB3zQeMOjmyC5rhGak5UoYxg
	 pIhHb1aCFEtwKKTClRB5rZ/PWg4kbXluMVgc9LmAO9PWmyb7TNjWZkqKyMs1fII0mWTBM
	 cjlUPuhDTPG5NRtfMdS3ReOR//JgZgv8JPBFCaXAj4ATEmN8eNy0MXQGHnAKtmucnnTTr
	 Kf7v5NMPPy2snlEEPhcdiJOlJmVyS1FHpOYOT43pXUhHHvuY1AO6AnCn7AN5HlIpCJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794751333;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=C0hZCZ1HlArCnNua5WGJXPR4s/dAC6fjh9Brf5xLf/I=;
	b=W/3U+seu0eiSNU1FhefTu/lo879ac/tagtIXPJ+Egy6yptHA16acTNbzsIY8sT8Qkej1
	 82ZFGcjFLYfCwRjO0nYeNiyg8ggVf1xCSxSzaGRlW0n2beTNTw5adLuBuw2gwFUApebBA
	 nihxPmruiCGh3vbacdlaGAhqU4bi6NJnt8n82n+TV6YOnI6NLlfN5qlOIUmYSZxmO7TdN
	 SiIyTb/XBS8AFu24g6OYcmCtDv7LEPttKJNqMiSaZ8xTauRQSq8jki7V4+U/tqfeaijOs
	 gzLjPtj4IuZhD2xi9BMwdpijlz6UYA3+/qp9oMxUkdjvuOsPCLTatwMcPuaBizJ8lIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lCmT3vgU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C644606A31D;
	Sun, 15 Nov 2026 14:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lCmT3vgU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7041F000C4;
	Sun, 15 Nov 2026 14:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751333;
	bh=C0hZCZ1HlArCnNua5WGJXPR4s/dAC6fjh9Brf5xLf/I=;
	h=From:Subject:Date:To:Cc;
	b=lCmT3vgUByzTeA9R757hy9aa0HZE4kCVK0A5FBSbwAooKZHJJK5oK2QqoPEHWyoRJ
	 swdVTlXDdJUVBnvWkHnXkipTzyAaAqAS70tC39ZUzbXkKiiE+btYREERd5StseDTbn
	 zcWzdziNnXo7X8mLYhlfZiPFvM6GhaTPKVNQ4SNKWtudv3284JWjz5NKhzyuvhykbo
	 ovdYHOZj3BYLhEEY0IXslCiJifUqNJRF1mJ/5GrBXZVB7wuVcQMnbQQ4wxPOeBmK1F
	 BFH5jgiZxb185bU/PJcIc3uCfdbR8kKmCpMNI1ltjBdq0NvcTQJfswD215TGXdMxuI
	 HmHiQHeWiNVOg==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 00/13] fs: let d_real() fail
Date: Sun, 15 Nov 2026 15:01:30 +0100
Message-Id: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMWw6CMBBA0a2Q+XYaWoJJ3YoxpI9BqqQ1U0UTw
 t5p5fPO46yQiQNluDQrMC0hhxRLyFMDbjLxThh8aVCtOkspe/wmfmJaZvQDk5lRSa271o+aXAf
 l68U0ht9fvN6Ozh/7IPeuTL2wJhNaNtFNdVRBUUBxgKKuYdt2HWulIpoAAAA=
X-Change-ID: 20261115-work-ovl-d_real-219930df9ec3
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3833; i=brauner@kernel.org;
 h=from:subject:message-id; bh=pa24T6yCoOSBNbgGCY6AwfmcBlLS5Ar6zkTbMn0Wgmg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93O2vqVrhsEVk8w8bwRPB9mu2b58txH/6hPzbCzOYZ
 7yfu3bL5Y5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJ7DvK8D+374Hlzv9ipvZl
 Rq1dFcfahVq2mU5V8n4bsrj5WOOGjjhGhnYt3WqWp77Lo13D994t4tVteLmD2d3HMMT838fvTsd
 uMAAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

overlayfs looks up the data of a metacopy file in a data-only layer
lazily and validates its verity digest when it's first needed. Both can
fail but d_real() has no way to report it. So ovl_d_real() warns and
hands back the overlayfs dentry and every caller silently works with an
inode that doesn't host the data:

- uprobes get created just fine and fail later with a bogus -EIO. Every
  new uprobe warns again for each of them. With panic_on_warn that's a
  panic.
- IMA skips detecting changes to the backing file and hands out a cached
  verdict.
- IPE evaluates its policy against an inode that has none of the
  dm-verity or fs-verity properties of the real file.

And that's not limited to files nobody opened yet. A metadata-only
copy-up of an open file makes overlayfs validate the digest again.

As Amir pointed out the correct fix is to teach the callers to deal with
an error. So d_real() may now fail for D_REAL_DATA and all callers
handle it: uprobes fail when they're created, IMA treats it like failing
to hash the file, IPE denies and the bpf kfunc returns NULL. Then
d_real_inode() goes away so nobody can ignore the error again. The first
patch only drops the WARN.

This came out of the same work as the freeze protection fixes for
backing files (cf. [1]). I ran into it with the pseudo filesystem
series (cf. [2]) where file_check_backing() looks at the file hosting
the data of O_PATH files registered for fuse passthrough. With this
series it can just return the error. But this stands on its own.

[1]: https://lore.kernel.org/r/20261114-work-fs-frozen_writes-v1-0-f5ae61c898b1@kernel.org
[2]: https://lore.kernel.org/r/20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (13):
      ovl: don't warn when the lazy lowerdata lookup fails in ovl_d_real()
      fs: add d_real_data_inode() and d_real_metadata_inode()
      tracing/uprobes: handle errors from resolving the real inode
      bpf: handle errors from resolving the real inode in uprobe_multi
      selftests/bpf: handle d_real_data_inode() errors in bpf_testmod
      ima: handle errors from resolving the real inode
      ima,evm: use d_real_metadata_inode()
      ipe: handle errors from resolving the real inode
      bpf: return NULL from bpf_real_data_inode() on errors
      ovl: return the error from the lazy lowerdata lookup in ovl_d_real()
      fs: remove d_real_inode()
      selftests/ftrace: add uprobe tests on overlayfs
      selftests/bpf: add uprobe_multi test on overlayfs without data

 Documentation/filesystems/porting.rst              |  10 ++
 Documentation/filesystems/vfs.rst                  |   6 +
 fs/bpf_fs_kfuncs.c                                 |  13 +-
 fs/overlayfs/super.c                               |  19 ++-
 include/linux/dcache.h                             |  47 ++++++-
 kernel/trace/bpf_trace.c                           |   9 +-
 kernel/trace/trace_probe.h                         |   1 +
 kernel/trace/trace_uprobe.c                        |  57 +++++++--
 security/integrity/evm/evm_crypto.c                |   2 +-
 security/integrity/ima/ima_api.c                   |  17 ++-
 security/integrity/ima/ima_main.c                  |  11 +-
 security/ipe/eval.c                                |  15 ++-
 security/ipe/eval.h                                |   1 +
 .../selftests/bpf/prog_tests/uprobe_multi_test.c   | 141 +++++++++++++++++++++
 .../testing/selftests/bpf/test_kmods/bpf_testmod.c |  11 +-
 .../test.d/dynevent/add_remove_uprobe_overlayfs.tc |  92 ++++++++++++++
 16 files changed, 408 insertions(+), 44 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261115-work-ovl-d_real-219930df9ec3

