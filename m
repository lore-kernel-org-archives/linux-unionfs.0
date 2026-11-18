Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020092;
	b=0mzdvtV8NxT9y4m7PS4y5eGAkJLNiboYhdtbU8Nznb+Rlzn+6Wxw0o1F+KUHxW3s5ioh
	 rFbYV7i276vzh6Vjltkom+BtqVNQc1/NMdz/G1sviAqQ1ppSKLCbXJkixXyuFjPMIIk1W
	 vZLTKDt02nxO4l6BtknX3U68N7Bj544aSCvjghE+8S7zZKljxt4pO2muW6gXORx27KAnl
	 kUuJGQ/5793rwa2BfKbde8rP1QvN7t3aeBVQQAcNSJIS/0eiSP2s/Qjg1euL159e3q/s6
	 7JWzIAR9A077aXND//L7YQ36vdUxqIEyKn21uKwk0yH5ZIP+eOyNXkv7mMMi2tQQpIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020092;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=KpCOWgYItNRFdCHLthVjrjZj9hh3G9ExdOPVMRYpXJw=;
	b=eExjBAljpbvf3g/N8hhVAkzy1DLHXIT8uGVz+B8nOeAGwHJEEOEOURJNRRIaS9x5CJQK
	 NgXKkaQl9UVZFibuIqIW44AgKmO8M2qfYTpCEDZx2Z/ssWvwWHPKkvS1XcQQ3M/SfVVtC
	 JQU9T7NSMde589/RCLKCMS7bE6X3BWYaI4hD0KPINxTpLYBJ9//mrx+qGtkBFVHpEzp+2
	 rhiDcqt2c/CyvKYm/oNtWiT7JoKMh3u5Orx7XCIZmNQ3YXl/ALCn9dPkGzpV48nqJlPqd
	 cU/6dskUBSgjUTORUSURE+XOWyNn7uCwTYpMuCpU+TA8d9VzIEULS/h2Je2cSOoiUZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=etms+rmi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEF8606A320;
	Wed, 18 Nov 2026 16:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=etms+rmi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E0B1F000C4;
	Wed, 18 Nov 2026 16:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795020092;
	bh=KpCOWgYItNRFdCHLthVjrjZj9hh3G9ExdOPVMRYpXJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=etms+rmi+8L/OLERxU+EOMiH1yzh7QvrCedbLLFvfyOXftr1190X213cLfSMIdQhc
	 xktDkWAsGluc5sjs6Q+0xPnu0cRRv8WL1LtgbH7hhvypFoq0KCjcNGSmDaySPjxe57
	 KSVCR2Ief3MVz6qMcEC3A89jIrfeeEJz4Oisdraf0VRAKp9ACtii9Nc+6p0hWsiOHC
	 cOA3QRG4XS4ZJ0/KN+/71smKz//P77MiR2wPC2xQXa/VFXn7cC4W+hKsihDTtUOf3q
	 FbeaJe4k0/kwhoD/wk2H7C/C6O6Lmm8fqXI0k6UkmMQ6tQVBRU1FPwwdFAJCOA/i5u
	 /z3SJ8YKVa3QA==
Date: Wed, 18 Nov 2026 17:41:26 +0100
From: Christian Brauner <brauner@kernel.org>
To: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, 
	Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 03/13] tracing/uprobes: handle errors from resolving
 the real inode
Message-ID: <20261118-beenden-wirken-halsschlagader-00aa2083c904@brauner>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
 <20261116-work-ovl-d_real-v2-3-90564c4ae347@kernel.org>
 <undine-1794965448776121119-595ee1289c37e7d3@undined.local>
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
Content-Disposition: inline
In-Reply-To: <undine-1794965448776121119-595ee1289c37e7d3@undined.local>

On Wed, Nov 18, 2026 at 10:30:48AM +0900, Masami Hiramatsu (Google) wrote:
> On Mon, 16 Nov 2026 10:44:00 +0100, Christian Brauner <brauner@kernel.org> wrote:
> > d_real() is about to be able to fail for D_REAL_DATA. So switch
> > trace_uprobe from d_real_inode() to d_real_data_inode() and deal with
> > the error.
> >
> > Currently, nothing checks whether the data can be resolved when a uprobe
> > is created. The first resolution happens in validate_ref_ctr_offset()
> > under event_mutex and the last one when the event is enabled. If the
> > data of a metacopy file in an overlayfs data-only layer can't be found
> > the event is created just fine and enabling it fails later with an -EIO
> > from uprobe_register() because the overlayfs inode has no
> > ->read_folio().
> >
> > Instead, resolve the inode hosting the data once in
> > __trace_uprobe_create() right after kern_path(). That happens outside
> > of event_mutex and if it fails the write to uprobe_events or
> > dynamic_events fails with the actual error and a new NO_FILE_DATA entry
> > in the error log. The resolved inode is passed down to
> > validate_ref_ctr_offset() and trace_uprobe_has_same_uprobe() so we don't
> > resolve it again under event_mutex.
> >
> > Both functions still resolve the existing probes they compare against.
> > If that fails the existing probe can't be on the same inode so we just
> > skip it. For validate_ref_ctr_offset() that's fine because
> > uprobe_register() refuses a mismatching reference counter offset for the
> > same uprobe anyway.
> >
> > trace_uprobe_enable() returns the error and probe_event_enable()
> > already unwinds the probes that were enabled before.
> >
> > While at it, resolve the data in create_local_trace_uprobe() as well.
> > perf_event_open() of a uprobe PMU event registers the probe right away
> > so it would fail in trace_uprobe_enable() anyway. But this way the first
> > resolution happens before perf_uprobe_init() takes event_mutex just like
> > for uprobes created through tracefs.
> >
> > This is a no-op until d_real() can actually fail.
> >
> 
> Looks good to me.
> 
> Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> 
> However, since this conflict with commit 72d3a5cb0cd7 ("tracing/probes:
> Enable newly appended probe when target event is enabled"), please
> rebase it on v7.4-rc3.

Yeah, I had already done that.
