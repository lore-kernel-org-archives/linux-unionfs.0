Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792446923;
	b=xvIUauj7T0Tog4h/wqErLTk+fYahAM3EV7PY5IMIUQlD/WafB3aLHWpCgjhhNmpZSUiy
	 2lb9CRozaiB6k3yNRa2SF9NJbS1KbF/Mf08Z4ltjInUHuEktKa8vgzOdXd17ZShikijJQ
	 FsXhSi4yXLrpQLUWksn+gShc78XgTqUK41UqIuZ0+bRRA2810W3r2PtY1m/lFaq/pVHHt
	 bXXTosDhA9dZc0wm9gZ7zqn4A+uty3+L35y+CTxQRyiH2QLLR8jW3OqCslAaw7/ehtEK3
	 Aub4F8kB20wMeJPLzDNqVkbVqIKTDyRmr60kEQPWWCXQleVLer35BrO4khBLW3PSTEw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792446923;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=T8Iq4pdPlGHJEwvjJiX0aDJUqpeYVl+t+UzpRIrJcyY=;
	b=aOAoUNH4JVYByf+yfhlezPUOwghH6J37nAa8EhhgGzuBIY+RibdcPqsfh2QvJ8OuSiJI
	 +Mx7m7ECXTx8UClNYcOIAXipsTjSu4wSUh1n2nOiVtng6scdHBAe2vx3zUflKoieRiNDw
	 0NjRxNFKY4YHvPToeuuNEM6Bf9zboEb0HP5B29tDo5tYG3sfTchWfxnBzT3ZUuEBJUb/q
	 6/9HEEH7SzbYAdFRTq6beOTnXkDn8a6Zu9tOrqkdIFEVSRaUfClOKHMebxF5UDk73SUa5
	 /gyXMNz3GlKs3FXSPpYW7XCjz2zL3TmfLVSI9SNNmKSsZipxkTAa2FY7EZS0Pqc9q5g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YIjlvJfH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDAB606A319
	for <linux-unionfs@vger.kernel.org>; Mon, 19 Oct 2026 21:55:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FDAB606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YIjlvJfH
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b1cc392d8bso3179861a12.1
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Oct 2026 14:55:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792446922; cv=none;
        d=google.com; s=arc-20260327;
        b=lPArKG6Rq+tVFyZdrNrUdVOf9m2NoLijkRZ2yCio7T0F5lHruY3WqEYmbXKLC4i1xC
         N9BxnJJlf4U/B32gox65i6DHqMv4qSFd8NkYJ41gSuo2HLzLF+nUBWQvkFRpEGxKbJGg
         rVdQ4DilFcjKBsCopW4Ub26tQ82VCN2QkzssWL718Vp6OHyJJI/0grHq2tOubL/sDpZJ
         rmiriikX2EKNVwIH8QLDMQ190kkYG5CDLoPWrhGxk/M7B69KVb3lWQ54dmlw3zVzkNOs
         ANFVCirOnYpoubsCMbZYApkXFaslCLDbs7f4bAci2OMVLwtn7O/vj3ObK+tJtsO3yUDv
         YGhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=T8Iq4pdPlGHJEwvjJiX0aDJUqpeYVl+t+UzpRIrJcyY=;
        fh=0Gyctx8BjhuQLiE2jubUmjDwnhMLEyQ5vmbBwGOrd28=;
        b=Qo/sqMhuKixgqnTat+Hxz5JOSJQWvUcjKmUV2sEvUw5TAERuObtfsnluXp9T/Zn12Y
         k25Ev6wAfTBjgCTMA8+FtHoJ6DUROrriCiL9Uc1cJ1UZ9JVDfu7gApLRx9DIttykleMn
         ocezTIFtuYVAq1HG+79pGo1lJfr8zXL1qr2X1L95D1Pd6d8DskpQrFrRD+lzQ7YOBy+d
         4rdj9F3SCSlC2ZRzIOMH9iJgL3i7KGq4piHvcieMzUpsZ4bofVgDB82FyQ0maCnNMf4x
         RRnTLlTxokx5/7fLNAcZ0Hlptb3WS/SdKQib3gi/cI24bGYUp74MybHVlk19P/Gadtux
         0P5A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792446922; x=1793051722; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=T8Iq4pdPlGHJEwvjJiX0aDJUqpeYVl+t+UzpRIrJcyY=;
        b=YIjlvJfHZJwzkDyVmDSHEGAGGTMlDR73ZU13Cwy94sKyiVLB9MKtyGRhLVh4c6afSs
         pyX2JFu3rjoA/5fRLWrzZm/RA15uUw8PpgNkgmXxpjHfeqih/2zKcbgp1QiI0iglnHS1
         DeetUffXBMirCyrXz1ltNwGrxQZaInAgU81ac0FPiNtzdJ13bx6xJ3cKXmvVUqTWfVku
         ViCsmIb4npJY8gLEyn94IIBoZqJvXwPi9ut0+NC2k6ty9BWt1t8Nqu79uhQj7heOZ/aF
         teSxFtDqptinuBf+x5GlOWU7+UGF7q0OIemPd47oBCnSmIWb8j4DLI/V68ux/xzxnqqb
         VwGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792446922; x=1793051722;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T8Iq4pdPlGHJEwvjJiX0aDJUqpeYVl+t+UzpRIrJcyY=;
        b=yZZn94SkzqjJRVv7czIH+eOeByusUCGPeF75VAi9hlHlHIa4ByYZ4S7f3mfPV6uOzq
         wUKsNLebE/T9IpyjYuInYWYtG6sMXG+RKG+pruW0GcKRXIVS9Xx/JJoDsSAIPVK1AHrO
         KvfHfmJ1U8HRVGn9pCn/okm5XPrIF/vyINGHEnq9tCt26fVNnwLEFqhr+NVFmRkPW64C
         cAH4FSuFegUhYy9v7ofXwMf0fXxQpOoooOhFRAY8oTpuklEI8C2Lyg0bbK4lh94qAGk4
         gLKl/sNIgCF4gGY4DYhoeS3KbD7agDhCA7vqybSyLOwaFSM6Ce+gBN8waXD2vZiOQK07
         N7wQ==
X-Gm-Message-State: AFq9FYJIzwH9M4324O5hpRK8zv8yu7WVpyQcWg2jiBtyJGf9ViaroqeG
	cRIM0UnQc91p1IvxZtZowq0xGCQRojXsKkI3qj2Lq9CWasqOdQClI3MnFSXHHa0zwOXWGaKM6yg
	3Bjej2ZHgmgqW6vRfygUrOHcTnRpwvNU=
X-Gm-Gg: AYBFou2XzAEQiQzOySeEsiCtcXgg9nSYd4WuoW+bfcOReQ7AMwhzV7ad+E1/Z6WzwI+
	R4zb1LLKP+iDC90is+XyAfqssI7IDSHK4fMt5+iSWik7Ow/ke5VmpK7nnBSiwhk0C+J0vcA2k4B
	mvMmc53vciKHOxXEfkPsMPTr4m5T06a4cloPbqZYNSCESSR+iVj/qRaqR/ggr2/P+wXxEqAntzC
	5WsMZNVMbZDM4bOVDqJVrq1Z6cHmFrM2SsoajVc6NhgI2e3+Uvh5BcUkvx2MX9iCPdr1FNDp+Nv
	vbpBMO45+PB3cCv51LD++oEDNt+FGuTHAPNCrldGLfu3TBnSDmHwGx1QPYMp7KAX/Q==
X-Received: by 2002:a05:6402:21d2:b0:6b3:c0a8:721a with SMTP id
 4fb4d7f45d1cf-6b3c0a876a7mr3271800a12.32.1792446921583; Mon, 19 Oct 2026
 14:55:21 -0700 (PDT)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CACs2WyyyGBxznvnJRDYWziAbzz8QROr41CF9Wtu9fOj7jX1fDw@mail.gmail.com>
In-Reply-To: <CACs2WyyyGBxznvnJRDYWziAbzz8QROr41CF9Wtu9fOj7jX1fDw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 19 Oct 2026 23:55:09 +0200
X-Gm-Features: AclHuK-vu5bxZTtJjQZs-cG_GwqGQ0GiQt0sHWbR5qBAbzeswFscmOXiOptU_M0
Message-ID: <CAOQ4uxh0g1MtgCO7Q2f4yJP5vq5rLEiiXHbVfeCxwXB5ff4-VQ@mail.gmail.com>
Subject: Re: overlayfs: unprivileged writes can use ext4's reserved blocks
 with the default resuid
To: Claudio Fernando Pinto <claudiofernandopinto@gmail.com>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, 
	linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 19, 2026 at 12:03=E2=80=AFPM Claudio Fernando Pinto
<claudiofernandopinto@gmail.com> wrote:
>
> Hello,
>
> ovl_fill_super() lowers CAP_SYS_RESOURCE in the creator credentials with
> the comment "Never override disk quota limits or use reserved space"
> (fs/overlayfs/super.c:1511 in v7.3-rc7). On an ext4 upper with the
> default reserve owner, the second half does not hold:
> ext4_has_free_clusters() grants the reserve when the allocating task's
> fsuid equals s_resuid, 0 by default, before it looks at the capability
> (fs/ext4/balloc.c:654-657). Writes through overlayfs run with the
> mounter's credentials (ovl_write_iter() sets .cred =3D ovl_creds(sb) and
> backing_file_write_iter() applies it), so with a root mounter the fsuid
> that reaches ext4 is 0, and an unprivileged writer can spend the blocks
> reserved for root.
>
> Reproducer, a 64 MiB ext4 image with the default 5% reserve (1146
> blocks), the same user ("nobody") filling it once directly and once
> through an overlay mounted by root:
>
>   direct:  reserve=3D1146 free_after=3D1146  (reserve kept)
>   overlay: reserve=3D1146 free_after=3D327   (819 reserved blocks used)
>
> v7.3-rc7 (24a19b953e2a), arm64 under QEMU, writer uid 65534; the same
> on 7.0.14 in Docker Desktop's VM (1148 and 331). Script below.
>
> I ran into this in an out-of-tree stacked filesystem I work on, which
> copied the overlayfs approach and had the same gap. There I now run
> data writes, fallocate, clone and copy_file_range with a copy of the
> mounter credentials that carries the writer's fsuid, fsgid and groups
> (built the way ovl_create_or_link() builds creation credentials, and
> cached per file while the same identity writes), so ext4 decides the
> reserve as it would for a direct write. I do not know whether that is
> the direction you would want here, given the per-write cost and copy-up
> also allocating with the mounter credentials, or whether this case is
> already known and accepted as one of the behaviours that cannot be
> implemented with full fidelity.

Practically it is one of those cases

> Is it worth a patch,

Which patch? How would you suggest solving it?

> or should the
> comment just say that resuid/resgid still apply?
>

I don't object to a patch clarifying the comment,
but don't overdo it.

I would just drop mention of resuid, but tbh I don't think it matters
so much.

Thanks,
Amir.
