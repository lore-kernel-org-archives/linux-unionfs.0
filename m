Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794966669;
	b=udbuMG/+7g+CJeftAzcKt5pXo/c+gSQeOuBegufGDjQ2lqHBTW6578Jx94ShgLqLor8D
	 nkofuEvtmaCqZZj2XvZ6fP6N7ozkRfi0M1k29d1+vG0Vkcpnwl+fDwCDCf51vdJgXpyxK
	 QNxGMSCrtLh0Pdh3Iu2xw9EXx2pOGq/FXaYL5VvG6A+KbGMWdZ+oLzFUxGGzjTkD4aBGQ
	 8oaybHndWJgZ0KrYmphj/QSH8tg0rtMJrc1US8i2qfbJG+370+mS8CON8kE2FbLhB6fPk
	 IfQSPj26rFh8lMp8JkJPHNQgq8PN7cd5NeyNETKdSlj8VyRQQKDULsz/K5tzchRyPvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794966669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=OszsEJToNze6tnzlcvPsV51oFOJRwGBjy9Ri823e+68=;
	b=Tx8Gy25RJIJ2lh0GUk+h16/Rv1P/OHHxkoNn2Wx3i6QfnOf4VeCoRRav7hGWGCRrCt70
	 ifgkwXrVsK3G20IrqX8veuoOqaqvNwVnHBy2ymk/Fwy6DLNEZP+ZFrQGVFXMykaWfj3j1
	 X3U+73V4e5dLNPXkQkXyMKuLAN9mBE7/N6oXj9cV5az2lGLeIfoTxLhK8K1vNV0RG56fa
	 a4IcKFk62TkO7xE/2XSRQhuqOj8mtCJisNmHsQqpjt1OPM9iGrHA3xO6XmZi2xU7BmOYr
	 SkANA1XblnDnXowj4eF9TJQcbJHQC09sodfN2Z3Pjx8P5CmEF1S4E0xdxCoMVwrS1cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ThrwtBHp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99211606A32A;
	Wed, 18 Nov 2026 01:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ThrwtBHp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAB61F000C4;
	Wed, 18 Nov 2026 01:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794966668;
	bh=OszsEJToNze6tnzlcvPsV51oFOJRwGBjy9Ri823e+68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ThrwtBHpTaXzf7hassKaKBcUyzwDmGgefOFtf6hJdkgZJjnMXGIbtvBZXQKoyZCtt
	 +MJdcR5DkVpwEGdqNthqxNFo2bYfiMBufYpH5otviGB5eMPoBtMjfBjl+ujAR8Q6pK
	 FWfnPfqU4c7QakERFWloJeY+amgH+ep80Y7wd8DBEfvSKmAXBLfeDNXVCcohp/5nWT
	 z+aTBNVIkh3dCQnbkh1sCSuEnFv3HkTIic3D6yUyw0ifyHcuMsXFEVzmhu2oVVQyKd
	 CJbjQ+p2Lz50jjITHtZyV3EKFBgn7EsdQ33RUrpoqGrd++kbjzVGUOlt/WxQHe0a6/
	 0tdEykQIgFjRw==
From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 12/13] selftests/ftrace: add uprobe tests on overlayfs
Date: Wed, 18 Nov 2026 10:51:04 +0900
Message-ID: <undine-1794966664951744079-93786e4e480023ea@undined.local>
X-Mailer: UndineD 0.1
In-Reply-To: <20261116-work-ovl-d_real-v2-12-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org> <20261116-work-ovl-d_real-v2-12-90564c4ae347@kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On Mon, 16 Nov 2026 10:44:09 +0100, Christian Brauner <brauner@kernel.org> wrote:

> diff --git a/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe_overlayfs.tc b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe_overlayfs.tc
> --- a/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe_overlayfs.tc
> +++ b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe_overlayfs.tc
> @@ -0,0 +1,96 @@
> +
> +OVL=$TMPDIR/ovl
> +mkdir $OVL
> +mount -t tmpfs tmpfs $OVL

nit: If `CONFIG_TMPFS` is not enabled in the running kernel, `mount -t
tmpfs` will fail under `set -e` and report `[FAIL]` instead of
`[UNSUPPORTED]`.

Maybe you need to check tmpfs support in /proc/filesystems too?

> +
> +cleanup() {
> +  echo 0 > events/enable
> [...]
> +setfattr -n trusted.overlay.metacopy $OVL/lower/broken
> +setfattr -n trusted.overlay.redirect -v /missing $OVL/lower/broken
> +
> +mount -t overlay overlay -o lowerdir=$OVL/lower::$OVL/data $OVL/merged

Similarly to `test_attach_api_fails_ovl_no_data()` in patch 13/13, if
mounting overlayfs with data-only lower layers
(`lowerdir=$OVL/lower::$OVL/data`) fails (e.g., on an older kernel that
lacks data-only layer support), it would be better to skip with
`exit_unsupported` rather than failing the test.

(Note that this selftest can be ran on older stable kernels.)

Thank you,

> +
> +TAINT_WARN=512
> +TAINTED=`cat /proc/sys/kernel/tainted`

-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
