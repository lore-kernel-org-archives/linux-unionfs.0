Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794753468;
	b=kP2wCI7ZUcroYv1JifOCnC2P2RPx48pQvTvtijmUs/0KpVmXiqkS7fq4gbpmlnqWWSOH
	 4715I/0E08v3/I+NUSbbQNP3YNAohU1I/QsKGm37hayyynbxS6lsaVQ3M9DSbyt8S792C
	 krWQNBa1wsd4WEZKXzOcXuyy9a+x0SzCDDiJ1eF6GZFxJ53oy5WzO+LoHQFGpcq47aa7H
	 dWGoB8u5ICxkZ2jPOVQjkFRMAFhJUZCO/RdrsCivB+vjLBYfY9Lr+sYMdJ69R4hlhV6f4
	 G8ilyW1eVXEBwL6UA42jVVLIm10y1E8M23T7GOjRixtCCIzbHng+8Ms56VSVdIcFOSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794753468;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=2aQpD+5wOwFw2m2I7/vgi2Nycby2o3K9U9x+kyRBQZ4=;
	b=Bz1jCZ9ZUB3HbYsayh/qjIw/0GBFzyJmtQLS3rx/xeJeGFV9EmOcNh384eer9LV96Vfh
	 YgX0/CajRg107YrWBhc2vOV4R8IHwbuuWmWBtC6TRu2+2+p5fFDAZcBe1QmPnwEm0i7/q
	 hvVBiNzIKuSnJJZucrxcOzVKosezIjeNwwmDLCfZUpBPhTNu8qskeVAXf3foNBcBqJ8AA
	 eTHk+5ScdegOyEXy+agGI5jENO2YG+j97rJdEE7sRs9KvLOrlUwpAoFXjxUZU+/aCF4zt
	 HHUSrzkLrAyrayBKRKC3sZtu2mRb9bRVar0jf3eL8HnjmSFAU+Lt1W2n/Yd11ltidlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="F/8qSbuo";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93337606A31D;
	Sun, 15 Nov 2026 14:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F/8qSbuo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A461F000C5;
	Sun, 15 Nov 2026 14:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794753468;
	bh=2aQpD+5wOwFw2m2I7/vgi2Nycby2o3K9U9x+kyRBQZ4=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=F/8qSbuoGQZGQtgBxIr6B2ueFpU95+7qJMwmm8INX1xDHRlTUaSD8BFdbq4CbOxrR
	 ox1qNccLa8/HK300SOpQmBbk5Qvso5s0ej0nnLzfaw7woW9fsTRsB3fn8XKtg4GZi2
	 mkIHuNrdV77fS3AS7HGyBsRW6r1I1TVsLts0dAY635e5VsCW997Apri30eUILQ8DE8
	 6QT8gY4VS7IF4+z6kjL7VWLQ7z0W25C7ZhfXYsY6RHZAfw5JKq52esd/VilnzZerDm
	 yfh9vV8t3VLyXsXWrgdekBNeTMfP6B4g7EKPziGoUoo9vqTOsFrf/z8rys1tdDFec/
	 iXGUcM50BmJSQ==
Content-Type: multipart/mixed; boundary="===============5766711597295612734=="
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <9bacf710b101058735f399d44953a18d1630aec3b6b176fe96215cdd2f0eb7ac@mail.kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-8-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-8-ca155efbcb2e@kernel.org>
Subject: Re: [PATCH 08/13] ipe: handle errors from resolving the real inode
From: bot+bpf-ci@kernel.org
To: brauner@kernel.org,amir73il@gmail.com,linux-fsdevel@vger.kernel.org
Cc: chris@chrisdown.name,mszeredi@redhat.com,linux-unionfs@vger.kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-integrity@vger.kernel.org,linux-security-module@vger.kernel.org,linux-mm@kvack.org,brauner@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 15 Nov 2026 14:37:46 +0000 (UTC)

--===============5766711597295612734==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> ipe: handle errors from resolving the real inode

TL;DR: Behaviour question: the new ipe_evaluate_event() early return for an
unresolvable real inode skips ipe_audit_match(), so enforce-mode -EACCES and
permissive-mode allows may leave no IPE audit record. Should it audit?

> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> --- a/security/ipe/eval.c
> +++ b/security/ipe/eval.c

[ ... ]

> @@ -335,6 +339,15 @@ int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
>  		return 0;
>  	}
>  
> +	/*
> +	 * Without the inode hosting the data none of the properties of the
> +	 * file can be evaluated. Refuse it unless IPE is permissive.
> +	 */
> +	if (ctx->file_err) {
> +		rcu_read_unlock();
> +		return READ_ONCE(enforce) ? -EACCES : 0;
> +	}
> +

Should this path emit an AUDIT_IPE_ACCESS record?

This early return skips the eval: label, so ipe_audit_match() is never
called.  Every other way ipe_evaluate_event() ends in a denial goes through:

eval:
	ipe_audit_match(ctx, match_type, action, rule);
	rcu_read_unlock();

	if (action == IPE_ACTION_DENY)
		rc = -EACCES;

	if (!READ_ONCE(enforce))
		rc = 0;

With this patch, in permissive mode a file whose data cannot be resolved
returns 0 and leaves no record at all, even though
Documentation/admin-guide/LSM/ipe.rst says that in permissive mode policy
violations are logged.  In enforce mode the -EACCES has no IPE audit record
to explain it.  The commit message says "Permissive mode allows it like any
other denial", but other denials are audited and this one is not.

This path can be reached for an already open file.  ovl_open() verifies
lowerdata and sets OVL_VERIFIED_DIGEST, but a metacopy copy-up clears that
flag (ovl_clear_flag(OVL_VERIFIED_DIGEST, inode) in fs/overlayfs/copy_up.c).
A later mmap(PROT_EXEC) on the open fd then goes:

vm_mmap_pgoff()
  security_mmap_file()
    ipe_mmap_file()
      ipe_build_eval_ctx()
        d_real_data_inode()
          ovl_d_real()
            ovl_verify_lowerdata()
              ovl_maybe_validate_verity()

which can fail with -EINTR from ovl_inode_lock_interruptible() or with an
error from ovl_validate_verity(), setting ctx->file_err.  The IMA patch in
this series (c9952f8fed84) describes the same scenario, and its error path
in ima_collect_measurement() still calls integrity_audit_msg().

Could this set action = IPE_ACTION_DENY with a suitable match type and jump
to eval:, or use a dedicated audit helper that records the error, so that
denials and permissive-mode would-be denials are still logged?  No later
commit in the series touches security/ipe.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/43723438893
--===============5766711597295612734==--
