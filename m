Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793372306;
	b=OAN20+ZMpvTHCP9evi+bQDHqIYoqnzvjtasosQ599gqmI0rJane7jbSHP/7oHEyJSWnI
	 FiFHCXIqkA5AXoWNHTY3mYnT23jthocxPjcvpBoxfqsFSzZKjFvGjSUxwnIs44pO0hwy1
	 a4S9O5Ox2s4qDKuEHnzi8hgpJpmJLG+vdMRgK0lM1hJjjg7kubtZMIakKNsgfMRxju27n
	 3HbndsDW0daQZpWRfaicpVSlR1Pm4h6qSkkQxbiMNebE5Qj5OtWTa7TYJHRhWCipcR0TR
	 nxfXBc32Fz31wnFwccds5t9n/5PdDWK5Kw4ZbPKYZA4sSfSYkq3jcqppZgt/VKQrhuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793372306;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=DUNXpN2VVEcIQImbc7YoIxdXpeHxb6W2cXiqNoHVCq4=;
	b=HunBciTO/WKWyERwuBGFNYZ51F79EugZGkGwLkASHIn5ReA9MCfMKzDuVfKnLTYVvFhE
	 hob0ubwD6oIrDkVE5WwzyWHy+LJaSnysEXu/gck6jvIM3lO72Th6oBofCOxQPk7xVwSVw
	 rPzD7n8lM63o+gEvtMYzW/tROSEGbewCoVEsWdAQWpqOPh37ppnGcodWX0COWHxB1RUU7
	 pipq/OvvexAYP5/nA8VbqaLOnj3NOkyEghvRJxXi2mI4CinvVYbj+8kqtIemWGFBYr2dg
	 lUBuHigsy1pZIrAE19XNkSSPM9OywJuvdVUTyIeLfhNO+ZwjzdAeFz8y+Ir/iK36HBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LL1N7P9G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735B2606A31C;
	Fri, 30 Oct 2026 14:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LL1N7P9G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBE01F000C1;
	Fri, 30 Oct 2026 14:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793372305;
	bh=DUNXpN2VVEcIQImbc7YoIxdXpeHxb6W2cXiqNoHVCq4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=LL1N7P9GiWY+Ht9DHaO4CPj7BWn5gUuTu7rVqxKzVddINHxmgsNUa42MxQM7UO/ra
	 TxZlU9nYaarOBEqQKo6DxZs7tF6+Nl298ZihkVcw9dKlwQ/0Zn5hvZn+FqWUboEAVB
	 5YHr/8jXogDKPsN0XtC1DnMVE/K68qb59gzGvXc3qbJOvTDIR618ccoLwJGxTQ/oXy
	 NJAEqSGUt0/Vy2HpjFvsGqEnzdVQGc4GID1ymZIy230COvAkvPvW+4lZ/3mvKkfFXd
	 g/fOf01idt7ScYJR/D9I0zKUayhFIp3eskMSUBaFUciIICSrxP79lkpNFp5fENp94C
	 Tx75d7F6hRZ9Q==
From: Christian Brauner <brauner@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Edvard Conrad <edvard@tuta.io>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <P58Wrer--F-9@tuta.io>
References: <P58Wrer--F-9@tuta.io>
Subject: Re: [PATCH v3] fs: let backing files inherit FMODE_NONOTIFY from
 the user file
Message-Id: <20261030-erdumlaufbahn-zehnkampf-annullieren-f6068ed99cc1@brauner>
Date: Fri, 30 Oct 2026 15:58:22 +0100
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
X-Mailer: b4 0.17-dev-ce4c1

On Thu, 29 Oct 2026 22:18:40 +0100, Edvard Conrad wrote:
> When fanotify reports a permission event, copy_event_to_user() creates
> the event fd with dentry_open_nonotify(), so that the listener's use of
> that fd does not generate further events. If the event's path is on a
> stacked filesystem, the stacked filesystem's ->open() opens the real
> file with backing_file_open(). Since commit ebe559609d78 ("fs: get rid
> of __FMODE_NONOTIFY kludge"), FMODE_NONOTIFY lives in f_mode only and
> the backing file does not inherit it: it is allocated with the default
> fsnotify mode, and fsnotify_open_perm_and_set_mode() raises FS_OPEN_PERM
> on the real path if the backing filesystem has permission event
> watchers.
> 
> [...]

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] fs: let backing files inherit FMODE_NONOTIFY from the user file
      https://git.kernel.org/vfs/vfs/c/c3d355f427ce

