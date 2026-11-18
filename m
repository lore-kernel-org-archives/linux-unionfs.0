Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794965453;
	b=rHjpXgeZifz5lWSBwSkgpT7cKrinUQRjWMo0LnWQPXhnHiFYC1O58StOH6TE0R5Oekeu
	 HGpGxSaj953bCDHPmJrYidVX4sQdXApM+GTKhGBD24nPhVBeL+yaZPTa/8zmLrUuMzGBT
	 OLhkwu7BJpKodh4TXigtfAhEDxS8kxq1p3LF+ne7lVzgvcueW/FVCAVk9jcP4iQKV6Fjr
	 UcCamT5OF/QfamH2mLfd+UZCI1doAKLI4gkQlN9SOQ97MmTxDdD2gBEPlh8cmZBC5HFNv
	 mccWuzdreZbVZRrTiiX/7x7BMPaAdJ7xZSvSjKN0O1p5tO10RbQu1mN8+1zoVfXau0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794965453;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=SYxJl/ui6AD3kajNhdADlMAkHr2mk3aeY3/59dkg6Lw=;
	b=PaqyPG7P18/0z8de2hgi279Nzo9apNef5m2iuNdQNmNF5CQzFja2a/8A1YJZOj+KlUOd
	 8+29ngFH4qYhf7A9wx48+G6ASrJlz5DyXZyzzqB7mbS9bcQ6bo0/+4z3r+gdC2bp1oI3o
	 Z/lhmkD2DgZtXrI+4fqFPR4XLXr0ElsKIXfjljXieGadSpsKg6AKIMAIDjuiHON/j8l+X
	 /ezBMKS0q1F9gz85fd3Nu91NsEK+m0/eUEhsSAxV0ytPY9lvmUbmfoM/V7cSxARbWsNRs
	 gW4FFTMMn2IQqJ19IQeYm7sp7b62jV3eE/7o+2koqHBgesl9ZEBvqdg6pmgpv8/CZiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="l31FgM/Z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417EB606A31C;
	Wed, 18 Nov 2026 01:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l31FgM/Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B061F000C4;
	Wed, 18 Nov 2026 01:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794965452;
	bh=SYxJl/ui6AD3kajNhdADlMAkHr2mk3aeY3/59dkg6Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l31FgM/ZjLtH40ctlLvybLwXbLE+3+wF4z5UuiB1y8c/cjf0fv3wl6rF6n8KnN00d
	 hnUYi24/uEvPi9j1PoaxJo7QXsbljWERK8J3Pc4lC1vUqjBjU+X4+fVvpxWLH6ghV8
	 WwnA3+sKuPJVToL9ZSeUx1LXDOnLQVOaY0Q5YZXLjWCI3q47MgE1PM/Bs7SEvvAzAI
	 QYF4ReA4rdx6/PLLUv0uxngeIAnagio6XTnN6OxkehL4g2143roOX2nHEbV9XGeF2V
	 3AHqznVQbcbhmgY0SdLmZPe8v+YS7UkwMFkXZoYLaUes5Q5QvXFmYbEz2UANpRbPOS
	 VU2pGfAAJOFJQ==
From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 03/13] tracing/uprobes: handle errors from resolving the real inode
Date: Wed, 18 Nov 2026 10:30:48 +0900
Message-ID: <undine-1794965448776121119-595ee1289c37e7d3@undined.local>
X-Mailer: UndineD 0.1
In-Reply-To: <20261116-work-ovl-d_real-v2-3-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org> <20261116-work-ovl-d_real-v2-3-90564c4ae347@kernel.org>
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

On Mon, 16 Nov 2026 10:44:00 +0100, Christian Brauner <brauner@kernel.org> wrote:
> d_real() is about to be able to fail for D_REAL_DATA. So switch
> trace_uprobe from d_real_inode() to d_real_data_inode() and deal with
> the error.
>
> Currently, nothing checks whether the data can be resolved when a uprobe
> is created. The first resolution happens in validate_ref_ctr_offset()
> under event_mutex and the last one when the event is enabled. If the
> data of a metacopy file in an overlayfs data-only layer can't be found
> the event is created just fine and enabling it fails later with an -EIO
> from uprobe_register() because the overlayfs inode has no
> ->read_folio().
>
> Instead, resolve the inode hosting the data once in
> __trace_uprobe_create() right after kern_path(). That happens outside
> of event_mutex and if it fails the write to uprobe_events or
> dynamic_events fails with the actual error and a new NO_FILE_DATA entry
> in the error log. The resolved inode is passed down to
> validate_ref_ctr_offset() and trace_uprobe_has_same_uprobe() so we don't
> resolve it again under event_mutex.
>
> Both functions still resolve the existing probes they compare against.
> If that fails the existing probe can't be on the same inode so we just
> skip it. For validate_ref_ctr_offset() that's fine because
> uprobe_register() refuses a mismatching reference counter offset for the
> same uprobe anyway.
>
> trace_uprobe_enable() returns the error and probe_event_enable()
> already unwinds the probes that were enabled before.
>
> While at it, resolve the data in create_local_trace_uprobe() as well.
> perf_event_open() of a uprobe PMU event registers the probe right away
> so it would fail in trace_uprobe_enable() anyway. But this way the first
> resolution happens before perf_uprobe_init() takes event_mutex just like
> for uprobes created through tracefs.
>
> This is a no-op until d_real() can actually fail.
>

Looks good to me.

Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

However, since this conflict with commit 72d3a5cb0cd7 ("tracing/probes:
Enable newly appended probe when target event is enabled"), please
rebase it on v7.4-rc3.

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  kernel/trace/trace_probe.h  |  1 +
>  kernel/trace/trace_uprobe.c | 57 ++++++++++++++++++++++++++++++++++-----------
>  2 files changed, 45 insertions(+), 13 deletions(-)
>

Thanks,

-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
