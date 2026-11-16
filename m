Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794822276;
	b=3Lr1gVaDniyZzns1QcaKX/iDCGu66neTzBw3IcjZuGZUqVmLovwVaxB3MWUV24kdXlg4
	 SeoUoVUcQzYAooSJS2pwPLSPSkHjj/L4KDdW0TbXo3n6grQs4+qIOVvN8ngUekedHPqe/
	 ZEAyAQROY1LEsAzvXsf3/KtmBC9UQT7ULVeDDt8OIekAP8gMIy0SJjQhTERU7mcQYbenI
	 Hj7i7HXie0ZL1Tp26gdw2dt+ztEQPyv2+DCozhreH+AUYxgHxSO5zvSPVJnkJJfnYrUfO
	 0cneIZg2LASBEhyznikIW5sCLlytqFAPBbtnbmX2d1ZK5t/k9SV+CxVWCLt20q86RvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794822276;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=hgAtcboDPL4W6fp361vuNgNH6+9aIO13zK6GxzA5b0w=;
	b=GMrdxpU36tsjf4yojvB1cLQqhwxr85GR2lEh3Wdt/ASVRIZLIn34fBjYjvPsNmD+rijy
	 z4/NABtIDWJQEo4sHqbkAzoBSopy0T8f4j9FB12SNQwu1kx3yhx7ANcpXny0dh5jv6Hde
	 aRuyjqu2Z4zfKOm9qGPS7rAqAljzYHsD0JWQ4b3xPDXSI05ZBhckTIzdTkL0/HPyy2shD
	 5CCt9y17smA+4njIj65AholQKkI6m1vyAo9jRQ/fzFLbhMx0JQGK7p55ZDPpDd7WKP4fU
	 ET18ykLtSIAMBG6MBk9LhkrfIqAoiTUxjHgQ5GlDls7D0yBjJIulpmDLtWhJUpM6tHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YlABBZ7I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F734606A31C;
	Mon, 16 Nov 2026 09:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YlABBZ7I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0C01F000C4;
	Mon, 16 Nov 2026 09:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822276;
	bh=hgAtcboDPL4W6fp361vuNgNH6+9aIO13zK6GxzA5b0w=;
	h=From:Subject:Date:To:Cc;
	b=YlABBZ7ISyY8j9P4gftvIQ5fQX3zDPKib7Xm2Dt4ZAhPRcGr+/KKlsHo/3tOVOal8
	 umF+AfHn881H4gGHyQN8o6pBKilCFGTV8WGl8O54Gzsoe52282VhJ8IohFXYzjILeM
	 Let/7ORvD2U4VNGTjZ62YCYccjeKWpE4tjn+M7eBrWMbQLXcsp/coEvxLhRAydF8Qt
	 O58FMbiYeMX+2voIsP9thDz4sR4bxAa7U6nSggyQFkgKv97uk0tUgDno7ZuSnIHRAl
	 cLJWQF4d53VBcI3pFOVos3Ff6CwRk91RoPBANnUL3EmQTBdtN4B+XLy+HRqNOAMy/H
	 6T9wmN4DB3ovg==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH v2 00/13] fs: let d_real() fail
Date: Mon, 16 Nov 2026 10:43:57 +0100
Message-Id: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WOQQ6CMBBFr0K6dhpaggmuvIchpi0DVEhrplg1h
 Lvbwtrlm/n/5a8sIFkM7FKsjDDaYL1LIE8FM6NyA4LtEjNZyrMQooa3pwl8nKG7E6oZpGiaquz
 6Bk3FUutJ2NvPbry1B4eXfqBZsiYntAoImpQzYz5lIU9Cfgh5fufYaMPi6bsviyLr/o+IAkowS
 tQ19tpoidcJyeHMPQ2s3bbtB2HccVPoAAAA
X-Change-ID: 20261115-work-ovl-d_real-219930df9ec3
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, Fan Wu <wufan@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4516; i=brauner@kernel.org;
 h=from:subject:message-id; bh=FpAJ8KCoIs10Y+5ts8jOVO0UnpzoDHqYPZv0TdThKa0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9upD3SNq0pzY55Vzy72eZf51fdBpUzJKr4e5eVP+F8
 3ic7q/EjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgInsS2D4KzK7arksS08gw+99
 c9d5rrl0U1OwwGFl8U7lEyFLTyx48oThn+rPlE+RWx+uM/7D9GSh1cfUCMlTd1cKLFOfEFLqsDn
 sIzMA
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
to hash the file, IPE evaluates the file without verity state and the
bpf kfunc returns NULL. Then d_real_inode() goes away so nobody can
ignore the error again. The first patch only drops the WARN.

This came out of the same work as the freeze protection fixes for
backing files (cf. [1]). I ran into it with the pseudo filesystem
series (cf. [2]) where file_check_backing() looks at the file hosting
the data of O_PATH files registered for fuse passthrough. With this
series it can just return the error. But this stands on its own.

[1]: https://lore.kernel.org/r/20261114-work-fs-frozen_writes-v1-0-f5ae61c898b1@kernel.org
[2]: https://lore.kernel.org/r/20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Changes in v2:
- Drop the second Fixes: tag from the first patch as per Amir's
  suggestion.
- Let d_real_metadata_inode() fail too and handle that in IMA and EVM
  as per Amir's suggestion.
- Evaluate a file whose data can't be resolved without any verity state
  in IPE instead of denying it as per Fan's suggestion.
- Disable the events before removing the uprobes in the ftrace selftest
  cleanup, skip it without tmpfs xattr support and add the config
  options it needs.
- Link to v1: https://patch.msgid.link/20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org

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
 Documentation/filesystems/vfs.rst                  |   7 +
 fs/bpf_fs_kfuncs.c                                 |  13 +-
 fs/overlayfs/super.c                               |  19 ++-
 include/linux/dcache.h                             |  50 +++++++-
 kernel/trace/bpf_trace.c                           |   9 +-
 kernel/trace/trace_probe.h                         |   1 +
 kernel/trace/trace_uprobe.c                        |  57 +++++++--
 security/integrity/evm/evm_crypto.c                |   5 +-
 security/integrity/evm/evm_main.c                  |   9 +-
 security/integrity/ima/ima_api.c                   |  17 ++-
 security/integrity/ima/ima_main.c                  |  14 +-
 security/ipe/eval.c                                |  13 +-
 .../selftests/bpf/prog_tests/uprobe_multi_test.c   | 141 +++++++++++++++++++++
 .../testing/selftests/bpf/test_kmods/bpf_testmod.c |  11 +-
 tools/testing/selftests/ftrace/config              |   3 +
 .../test.d/dynevent/add_remove_uprobe_overlayfs.tc |  96 ++++++++++++++
 17 files changed, 423 insertions(+), 52 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261115-work-ovl-d_real-219930df9ec3

