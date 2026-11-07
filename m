Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794049151;
	b=de8/V//2WoPNPLoeMIa+l8lxAz/q+fxZJi2MKNpjGlGLMCKzyniG2WZgWDKxUVgszBbl
	 /o5/GddvA7/DgAzoKDEWdUFMxnoGeo84UP0yc8VBgiOheclu06STtopLS/9fVdMrmmTnk
	 lI5SEYWj5LuP82wYuiKLGXHmdIATQLjLIUZioub/mzKyXmKh/+Nx5BBOEEflJ1B3rtX4V
	 +xD4q05hHX6lJ6dm2yshOrwpK/bozJquaUrg6IPqlsmcE2nVkz0uHCESVFQQqGzQuHPYt
	 tq9YM1vVBNTDuGfDtgYE2O0Qdnbm7FyYvFMOAylhR0VNk19f6dP8Thw6sjAyhv0DaSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794049151;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f3l0zpGiWBDLrkdGS//TuXETPQIE+ln1iP7r/4acX0o=;
	b=Y50B1ipa4fp6PJu6ZTr1boA1hbHSMu5uD6lc/8IIEGY5W/18h/kswktR+OUbD7AiApDq
	 eA1KuU9r5Mte11LhOy8k/LvjUT49JDgjnxvT/LF2nmD5W0F9XDpVSbwPq2jLzv1pGUmms
	 /Dq2vKHWeGFcBM3txFnqHan2g+CVHNwZwV1uOrp2fm/GwoPQAnxq7OoqOoSztOs5XWSra
	 o4e/AFIlWAAIqGDSH5kuWVRh2IQxVHz38eliK9QGOhp3efP37RYYCV3nNgc+MC3cGmRSN
	 UhsdLKLknWkfnR1fSI3swHnOUly3JyCpQmduLgzgrbVjJEfhCuffoX9SpSaMh94liAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jmoJRG5L;
	arc=none smtp.remote-ip=209.85.218.54
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2674606A33F
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 10:59:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2674606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jmoJRG5L
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c169ae1cb26so78829866b.1
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Nov 2026 02:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794049149; x=1794653949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f3l0zpGiWBDLrkdGS//TuXETPQIE+ln1iP7r/4acX0o=;
        b=jmoJRG5LFPkpneFDc4+nTlERpAkw2Fyx79LANkHmU59Esr0Sy1tds04Tq+dLppDxGz
         94oKJZiMGy71L3Bqbv5rs7n0FN+yvV/HGbD6bBQQ6IvMBvUf6nmUV10ZkIhsjP2Wx+YM
         gyZ1KX7TIX1phuvp5z54OJWwDV7zeVDmMxPwKQQ4WQkVYTeQSSdA7UGAhE+3TrYbXtbh
         9BKDqRcRkct+tABBB1DbwKxAikMQlzq8tzEaNIHnuXCOVBU0BGFG3OANucQV5fAULe6x
         pqMxDWhomIWm/9+YWS6F3scQ0wlwSWTazLHOF6/Fx+/mQnkUinV5ur6KSJf2beTaWSsY
         Vp4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794049149; x=1794653949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=f3l0zpGiWBDLrkdGS//TuXETPQIE+ln1iP7r/4acX0o=;
        b=B3QujT61t98Om5tkXYXot7u3anJSNJg0d3BzksMtsWRkMB/P2lE9R0WfbMX8jMmK42
         zW7RlyTefaPetutwFZLb1d1BWMbjFuTyIpSSS6t2Mf+4zTgb29c6nhEheCQnMUZm5F0v
         MDRtwY35XYXcf6N4ncqpDGnST0BFazdXokt6jjGUWQp5ADcjTW/nppE0Lb9CbFhklO89
         zqA1JGLQ2ubRtEH9AEGFfvSk4uOsSLh5YbMI0/Z+qU8nXKUBlPZRQQ2hU9ayiTGWjifL
         jNtxzlRqpFMLoN3nkmucSTD3NNljMM8AZ8hGzazrRbihi+foccrX8cjP3KlNUJVIOkLi
         MOBw==
X-Forwarded-Encrypted: i=1; AL+hErGm1ly+mnYYpXjdaMGmIao1oXJel+2oDcBGEGfajtGO0TEcqoRKI8SdPF7QTBsOW3n6KylhLyQ3p7Tc5l22@vger.kernel.org
X-Gm-Message-State: APuU4Z/k0KdjzqBL+f3PTY81KD52BonseHAOqY88SWyRuO8xZlFr16/h
	kBt39bLd/2udu+IV45g6gVYe+NXhQ8FsFpun530KJqtn8vBbRgg26heJ
X-Gm-Gg: AYBFou13/eu72vwaABHYVSRuy/Gm8ssS/yD2jC239TqjE6zUG+GP4Di9kon+Q/jnuBl
	+27yc5YbMlMb0fXvu0JEdkg530fqW/+tNchbb/eEeq1bPDL+nkUF0Ncz/Sxl6B1+UYRcjZ6bcMp
	8qt+5QJKfxEwuvYdXjwYsW01T+Sk/aXPAl3ZDSveP8YSc4lRVp2jA5KzCUgwwMQKRYBVFUq9kYk
	ov6sS1OyDJyYQzbcprxBZ4wkVJFmF15XOzwLB7FZee6esAKMDgpL1vHTw3oBTSq/BRZgUKcldoB
	saXBmGiPgp2rNUGohdc7kzg91R3+jgqFZnzo+rjmoS7MTyu6s6pD8fdnL5y9DvbjfjiKvwNA/DS
	DZ9py7kWL/IB6Z6hS2qNbBNcoFMRhP5x9E/P1T+s6Yk+l162DYJTYQ+bCAQ8ljXZiMcQ08t1Aky
	GH5htKqjUKxyUWlRTPPdFbmIGO7TemQMu98FrhBxwm85mx6Cx9EAvXvEYnm1IXEjCRb5eGVuEAl
	gIU1n/0fu2ZAJxtEoz6cxZTbpVcrMxLm/BMhLwC7OA/Py6oaoyEC9snYuqqgXWD8AdN2ATEoihu
	YRRThlKpqbLEbddAAT/3JKoueLiH0BXshVV7g7ZjdidRHKkuU10tRS2yubAaELUbmQ1I4s9llg/
	idi0WCEIrLv4=
X-Received: by 2002:a17:907:94c9:b0:c26:1cfd:4244 with SMTP id a640c23a62f3a-c4d525794f8mr109604366b.11.1794049149018;
        Sat, 07 Nov 2026 02:59:09 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d354ac7ddsm144880566b.8.2026.11.07.02.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 02:59:08 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Chris Mason <mason@kernel.org>
Subject: [PATCH 6.6] backing-file: always end a queued write
Date: Sat,  7 Nov 2026 11:59:03 +0100
Message-ID: <20261107105904.3962893-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107105904.3962893-1-amir73il@gmail.com>
References: <20261107105904.3962893-1-amir73il@gmail.com>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chris Mason <mason@kernel.org>

commit 627cdcbc2a2eceb0452078a0c14370f9f1f17a91 upstream.

Writes to a loop device with direct I/O on an overlay file make the
next freeze of the upper filesystem hang for ever.

Every kiocb_start_write() needs a kiocb_end_write(). For a write that
is queued, vfs_iocb_iter_write() leaves the end to the completion, and
backing_aio_rw_complete() only calls kiocb_end_write() when IOCB_WRITE
is set in the flags copied from the submitter. In-kernel submitters
such as loop do not set that flag, so each queued write keeps the
freeze protection of the backing filesystem.

Direct writes to a loop device with direct I/O backed by an overlay
file left fsfreeze of the ext4 upper filesystem, and a later touch
there, blocked in D state. It takes write access to the node of the
loop device, which root has by default, to attach the file and to write.

The fix used here is to mark a write in struct backing_aio and to call
kiocb_end_write() on completion of every marked write.

Reproduced under qemu without KVM, on v7.3-rc6-21-g602042bf29f6 with
earlier fixes of this series applied, with and without this change,
once each. The kernel was not changed for the run. With this change
fsfreeze finished in about a second. Not run: the nvmet and LIO file
backends, which do not set IOCB_WRITE either, FUSE passthrough, and an
xfs upper filesystem.

Fixes: 2406a307ac7d ("ovl: implement async IO routines")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[amir: use aio->is_write to explicitly mark a write aio]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://patch.msgid.link/20261029180319.2852090-1-amir73il@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[backport: no fs/backing-file.c, mark the write in struct ovl_aio_req and
 test it in ovl_aio_cleanup_handler()]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -19,6 +19,7 @@ struct ovl_aio_req {
 	struct kiocb iocb;
 	refcount_t ref;
 	struct kiocb *orig_iocb;
+	bool is_write;
 };
 
 static struct kmem_cache *ovl_aio_request_cachep;
@@ -289,7 +290,8 @@ static void ovl_aio_cleanup_handler(struct ovl_aio_req *aio_req)
 	struct kiocb *iocb = &aio_req->iocb;
 	struct kiocb *orig_iocb = aio_req->orig_iocb;
 
-	if (iocb->ki_flags & IOCB_WRITE) {
+	/* Pairs with kiocb_start_write() in ovl_write_iter() */
+	if (aio_req->is_write) {
 		struct inode *inode = file_inode(orig_iocb->ki_filp);
 
 		kiocb_end_write(iocb);
@@ -413,6 +415,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 			goto out;
 
 		aio_req->orig_iocb = iocb;
+		aio_req->is_write = true;
 		kiocb_clone(&aio_req->iocb, iocb, get_file(real.file));
 		aio_req->iocb.ki_flags = ifl;
 		aio_req->iocb.ki_complete = ovl_aio_rw_complete;
-- 
backport
