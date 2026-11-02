Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.205.69.214
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793617056;
	b=K6mjpnm++g+AqbfCjMcujJhXMu5cm1+5dCFGZi19tglIgg5Hvm0TErUdipnNuBxFqGmf
	 9J+0QSV3FJCiMRxeWJJot5+RsWV6kHfiI+LUURQ5BArf7rD5eAcU6tG0DweDHhtCa1v57
	 628wsLT024o0FbkPU1a3XOkSNsXSHPo1yNgrO+hyVnouTcYJJQHEVKZE2Dx1EMYTfM5VZ
	 PXy/K9k3PgNIKGw7A2/psyC2HhohOSKAndKm1UHNeoDMO7Gwrywfb8aOl4pqWb0cY1QzP
	 Qqc2fkWzjr55SwOWyl1YZEftUhRiRO2YQ59kVraXdyI/m7WNCa0ShNkQJLPUjtzpPnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793617056;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Message-ID:
	 In-Reply-To:References:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Feedback-ID;
	bh=j+hZkYzIVJ9tilITm55Z46aHn+yx/FRnXY+i3pCcfjU=;
	b=Wc6e0xEqBUcgGhgiRkmTHeXje32p9XYwS64PDpAi2X7fPXzFw3q1K8S1qCWgwp5ijEMO
	 SoCTAWt425+YipCtEGMiN2mEGhQGujqYj9Unp9xiK7nyHF/2X5le/9kmhxwoi/qZQfD5f
	 6l+OIWhcZHbj6x8uUhG/voCH4H2XT7XL+4FGGjzo9P2D7KC+HhpRv91vuCuVgTUo9Om5W
	 O1QHP5giR7zkCxlAeBVgIDkoQh4YsLyC8QC2eko5882CGmhwTFX3qJqhhWhquai+egD5n
	 +aDkwrHESO0s6MgeMct+T8jigeZBvNFE1uuiBCIc4cZqdXF1hLbykNyo4tQQlfVBmrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tuta.io;
	spf=pass smtp.mailfrom=tuta.io;
	dkim=pass header.d=tuta.io header.i=@tuta.io header.a=rsa-sha256 header.s=s1 header.b=QC1Zl+zA;
	arc=none smtp.remote-ip=185.205.69.214
Received: from mail.w14.tutanota.de (mail.w14.tutanota.de [185.205.69.214])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265B460A5BCE
	for <linux-unionfs@vger.kernel.org>; Mon,  2 Nov 2026 10:57:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 265B460A5BCE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tuta.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuta.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=tuta.io header.i=@tuta.io header.a=rsa-sha256 header.s=s1 header.b=QC1Zl+zA
Received: from tutadb.w10.tutanota.de (w10.api.tuta.com [IPv6:fd:ac::d:10])
	by mail.w14.tutanota.de (Postfix) with ESMTP id 931341A0E92E5
	for <linux-unionfs@vger.kernel.org>; Mon,  2 Nov 2026 11:57:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1793617054;
	s=s1; d=tuta.io;
	h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Cc:Cc:Date:Date:In-Reply-To:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:References:Sender;
	bh=j+hZkYzIVJ9tilITm55Z46aHn+yx/FRnXY+i3pCcfjU=;
	b=QC1Zl+zAvweFYUJsfIXB+oARRLdGvi5cYOF28k6+f0iavdSy26br8e8t8Dv7vBML
	7wxYLNwx3lj0kKYwKnuAPGpguvRnFXvSK4QmooUoukAjWHgOa9WvqZ8yXeN6AqSAeB6
	uQj9nWMbBbr1rgiGv+D6P1YWtFxYapyqSLaaJgpW0K8epeN+xEWKMX/Ixlpp/zAQA0u
	blNy3ccAhErFiwKOWY5aDZeMNWaAlyeY9hPprt+NYSpOtbkBqVc9IcS/wMkMvYpXO2a
	L/kJQMl4LLu7hBvruSopBmlTcL71I5tDTL3aF9OqCZeOAThTlRuI1dVKt6umCwzvWxp
	/FpchbbJZw==
Date: Mon, 2 Nov 2026 11:57:34 +0100 (CET)
From: Edvard Conrad <edvard@tuta.io>
To: Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	Edvard Conrad <edvard@tuta.io>
Message-ID: <P5Qu3co--N-9@tuta.io>
In-Reply-To: <CAOQ4uxjm=cGPnug18VuhKqiMvkWwLPNLO_TE3KxO8iLZG+veYQ@mail.gmail.com>
References: <P58Wrer--F-9@tuta.io> <20261030-welpen-anbinden-nullen-b2432cee1d10@brauner> <CAOQ4uxjm=cGPnug18VuhKqiMvkWwLPNLO_TE3KxO8iLZG+veYQ@mail.gmail.com>
Subject: Re: [PATCH v3] fs: let backing files inherit FMODE_NONOTIFY from
 the user file
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Feedback-ID: 0127f977f5e13e8051b46c6e7f57d0f95a0470d24b79d7c31d07fdf611cc427ab823e0f4692a810119c92d8768973a9281:TurnOnPrivacy!:tutamail

On Fri, Oct 30, 2026 at 6:13 PM Amir Goldstein <amir73il@gmail.com> wrote:
> Would you mind adding test cases (or variants) to fanotify26 to cover
> this find and test the attached (sanity tested only) patch.

Two things on the directory side, one settled and one not.

Agreed on 130fdbc3d1f99 ("ovl: pass correct flags for opening real
directory"). Before it ovl_dir_open() passed the user file's f_flags to
ovl_path_open(), and __FMODE_NONOTIFY travelled with them; the commit
reasons through every O_* flag but that one is not an O_* flag. That
fits v6.13 failing the directory case and passing the file case.

The one that is not settled: with your patch, listing a merged
directory through the event fd still deadlocks. ovl_iterate() sends a
directory that has OVL_WHITEOUTS to ovl_iterate_merged(), and
ovl_dir_read() opens each layer with plain ovl_path_open(), which no
user file reaches. A listener that calls getdents64() on the fd before
answering blocks here:

  fanotify_handle_event
  fsnotify
  fsnotify_open_perm_and_set_mode
  do_dentry_open
  vfs_open
  dentry_open
  ovl_dir_read_merged
  ovl_iterate
  iterate_dir
  __x64_sys_getdents64

Two controls on the same kernel: the same merged directory without the
listing passes, and a lower-only directory with the listing passes,
since od->realfile is nonotify with your patch and iterate_dir() uses
it directly. That was on 6b4b543fa18 with your patch applied (with some
fuzz); the readdir.c paths involved are the same in today's master. I
have it as an extra case in a local copy of fanotify26 and can post it
once there is a fix to run it against.

Incidentally, I was thinking about your ask for something more
generic: a task-level "creating an event fd" state in fanotify would
cover the file and directory opens in one place, and the copy-up opens
in copy_up.c too, which also go through plain ovl_path_open() and
which an O_RDWR group would trigger for a lower-only file (from
reading, not tested). It would not reach the listing case above, which
runs at getdents() time, long after the fd exists.

Thanks,
Edvard
