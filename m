Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794049149;
	b=jFmcKkv28FkdDGr2ZN7l2dEoA8lh5lSscIaPJEFWU3HnfWOJWqtlWOnEhO0HTwJRqjiv
	 D0sSllFn49sgVeA9Jfd6qdibDxAr0hTPON/f+iVSJkm00qxz2vvylw3pcDfNCQnRMSZW+
	 Tbgs8tMj8q3awdB3ny3BufGo5y2k5syWyuUx3BXkDUugHCxld8trurs7GOFDpk/0lYFFZ
	 vssri8axiRGvlANTn6QM8EpT1MUFRJqThCwsuJnV0BQ9YwGd0O0DyBfRwXJAk1og2Unbf
	 0S07R9Q4La6y+MmAOv8foYX070gvcYMcL1VvRiL+fg4WxyMCbzKjHruYUBPPvlPvLAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794049149;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y7eKlQFnzHnXX2CdTEqVqjFeVAewWs55ryAaOGj8KvE=;
	b=WU5bCCd3+3gtNAfzCiukvIOm+JBcrK7vnzWKmQchb1jJS8ggbE0lEs8+g7MwlBbvzbUv
	 03qJyC2xwghJmjb9zaeUwXKtvxu7qZhe4ok+g9g9p49ALy0quiSTcNiNNlBUdJjOal+PI
	 79zJM600lmqmKAyNHOYxA1Ch6xBND0o0hMATtGj4MRw2H6u1Q9zvpyAo2UABpee1evHgj
	 ze7+McpK614NIChGGzHv4GX1JZYQAdMYJtbC0y6E2SHk1MiR/lznQqtmFUeScH0fwdaEF
	 WnFu/PoTJN8HWhFuxMkdERWI0s+ZXA478ox2CVlEXZLsWbBexD9BIqsHgSfhwfCeu1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Y06Y0WFV;
	arc=none smtp.remote-ip=209.85.218.47
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202FF606A32F
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 10:59:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 202FF606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Y06Y0WFV
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c411e139259so134309266b.2
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Nov 2026 02:59:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794049147; x=1794653947; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y7eKlQFnzHnXX2CdTEqVqjFeVAewWs55ryAaOGj8KvE=;
        b=Y06Y0WFViwKkS32pCebWEBBoJbm6etoFc+KHIQ4KUvTNNMqrREM3XOZT7Ismb+7Ixz
         ju9gaUCeEu0qpYjIqShKelhTtnyGF7y9w/wYb9DueOPa69HhmccCwzIOPLdhK0sJ1I5c
         x/Jy+uQDWou8xD/muiYNkWVAINs3RaqNKXFuRDSVK1cM2hsMrcKNb6URLanbATBaN8D4
         yr7UpIhLF2DyhvG7GFaNDjqiySfzSJSdZRFK+6rF3Pjn7u1v6kiCHc3LyAveTxPKEekC
         SBe88C+ff/dPWzE73Jy4CSTO+pfz2vS7DFG6xLiEcGD8IvN0vTMLUm4LhvN6OPuiQNos
         cL8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794049147; x=1794653947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=y7eKlQFnzHnXX2CdTEqVqjFeVAewWs55ryAaOGj8KvE=;
        b=tdobxHj7M6UIOBmB2v7bfcIIaRvoBXqP/uFexVs8qGj4U1Qb769Xy1Tnk4Bp0unAIN
         zml5GH3aaQqDtlgYgKSUG7aru297YxoqPkN6nBoVTJUC+FjO62tPfeJzROqhJbqk1CJR
         0gwVsYwiXJIiaLobjW7W7Qg45GQFXUTCncSO05rD9D3Jg/FSnIwKNUOkcJ8ATobew4Q9
         f3kjTqoD1GfyCWMD0bw/Eb1OodVoWpJe/vrwfBX78VLFVkzCCCj4O8Qpw7XX5ua/sTLw
         PSG1qryMvo3wHuDrk6HwdLhj/2jiMS2Kfo6je3gY1EoM/QjK/SY1Tb6Pk9HxFYJt3b8f
         iinQ==
X-Forwarded-Encrypted: i=1; AKwUvBwc4pg+skTfN/75mawezgaIVDbfX8SaIG7OoSLeVUX7h1YBueig8oZRKjFQhsbTRIl4sa3yOz/p9A76CZT/@vger.kernel.org
X-Gm-Message-State: APuU4Z8+QJM5ffFeBDDAPIr1W7BDbZVpaNYzurESwtlWsFLpL0gaxZeZ
	A/8qurxGaO0rtlBBLCw6poFFYDOAUA0+CN8hpXJf5w6ldqI3s+MBnyTU
X-Gm-Gg: AYBFou3iduR9vUesfw9qyP5bCf9A2vzBSai30xf5UJheoXYZEGsoQ0I3nCDwCTXCRbo
	t4xepFvjwYOf7aFDPbalQ0Ytrpt/WrtNs2Tkym5QxwbElALPOl9mIl76tRD7XbG2xsmMNJMGsuG
	KxScYaVjEZbbfzDIqzd+4CBIFAFaH4jCj4jLynCHY8hIFyckU7ykN9JZTXfgPasJqOOTLnzvarI
	I7wMC62raagGk4yAsCPA00Zo5LCIBJWJv0Jp82gRRe5Uc+7MXwrWQXFWYtcaMkRKqPRJUl+lugC
	7fg0Wo6/E00oKlSAmQu4PiSWWMgVoZ1Q29cQDVoYZhBjbZoQg25Kph/WWmoSxHSn8MgtR/x0CGE
	pB6KdN3EPRBiD8+37TzDVNU4DMjuosq2aQbmxXCfMe5KAg+fKfHWe66j0ZGs2aFy4S8XGzJjG3p
	UsBv8+z4T+pxtN6Bggc6NFiLYwHDqIEXTmS5WyEcf+JD75DtLAuvzCj19MIQzg0rQhkRj/yxmr+
	4cMJW+SveK/MJEGKrTHRQAsTOZtXjmhiA8zAEOjQNWY+BtpCvjqAEC+8h3InzpZTwE5ne+1PICs
	pgfcCw15k2kgAHsxGUXR0MV5sgj+Wc+KSEqvMym1cq5mbMttnjCfL2wMdlQpoyRf3q5VD5KI1kz
	Q1AWRHJtWFpM=
X-Received: by 2002:a17:907:3ea8:b0:c40:33d:f06f with SMTP id a640c23a62f3a-c4d34cb8b07mr416804266b.39.1794049147355;
        Sat, 07 Nov 2026 02:59:07 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d3569f6b8sm139673366b.54.2026.11.07.02.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 02:59:06 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Chris Mason <mason@kernel.org>
Subject: [PATCH 6.1] backing-file: always end a queued write
Date: Sat,  7 Nov 2026 11:59:02 +0100
Message-ID: <20261107105904.3962893-3-amir73il@gmail.com>
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
 fs/overlayfs/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

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
@@ -269,7 +270,7 @@ static void ovl_aio_cleanup_handler(struct ovl_aio_req *aio_req)
 	struct kiocb *iocb = &aio_req->iocb;
 	struct kiocb *orig_iocb = aio_req->orig_iocb;
 
-	if (iocb->ki_flags & IOCB_WRITE) {
+	if (aio_req->is_write) {
 		struct inode *inode = file_inode(orig_iocb->ki_filp);
 
 		/* Actually acquired in ovl_write_iter() */
@@ -396,6 +397,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 				     SB_FREEZE_WRITE);
 		real.flags = 0;
 		aio_req->orig_iocb = iocb;
+		aio_req->is_write = true;
 		kiocb_clone(&aio_req->iocb, iocb, get_file(real.file));
 		aio_req->iocb.ki_flags = ifl;
 		aio_req->iocb.ki_complete = ovl_aio_rw_complete;
-- 
backport
