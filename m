Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794049147;
	b=GtDMX8iOtGLejR+TUDioT5drX6tCJVrxM6/Wf3xZXmKjL80tISl39aJkcXh442kR7w5n
	 iXAstmBnAqVnvfQlw3BjFTOmXttKjQcpbmWCZr5UoW9VWWzjUlDB3/cI0y+T5X5/85mrE
	 JKfFVb3RgLWlBrN7D2gfYs+USTQOs4bUtw4SVU8HCDNHpw9xPsmdcrOCkLd5pCJpbcAPS
	 MSG2VaUI0kMwjrXJp7TLkWmbXTYG5kZ02fq1rThE6FySRuekEBCsjqrXIdZ3ucLFNbIb5
	 C0STlNN/pmi4x3M8I3iiA5WZjyF2T5lqeknLROCWsi2V1Ln/5QEsLEp8QfnJAh1qmqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794049147;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Y7ipCEUrdtIpyp5vON0jqVmEjc93IveEInQ5iyQmhTA=;
	b=kyMjHv1D2gZxFXxAdRPdv6WrBpBq+VFSqLCPN028ZxEh0EzchKWdh4Cm/DuBuWwE4Zwo
	 t0Y98anCIqaaDsxP+MDH2/lz6ikv8jACwpS52iCuepdbf4XM/NBI0S+nFLaSMwjm44hKa
	 5bEYxvkPc/qDxoXin1yBZ/yJ1HuCfrtSE1InKONYhhulo1FQ8qjLbBsNlkAOXhmPMEtlv
	 /Tg7JeAIH4MtklkUpnRYU/sD7IN6bJN+dUxsq7h3cFWvqsfO1EqPxZJzi3EoUFDO9L2Jt
	 KYpKcpov4Umxp0kwDiAP04VhMS4WtDB7OuVVLSbrnVs0CnnpoiYM/uy0PnX/gVTymBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HvHBgbPz;
	arc=none smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F49C606A32E
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 10:59:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F49C606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HvHBgbPz
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b587591414so1649401a12.0
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Nov 2026 02:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794049145; x=1794653945; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y7ipCEUrdtIpyp5vON0jqVmEjc93IveEInQ5iyQmhTA=;
        b=HvHBgbPzV9vYHHncefQoVq2YOPXOaNBD/LbZSBsl6UfsFTreUEenBqrKE53enVGuBZ
         cueLshNxWFgeHUaMlnJSyuePRFv9cT+JapbvK0CR0AuNoWM1s1N/plgLfyuGF918j6CL
         JnyxhTCp+Mf2P7oRpE6DHVRMATjRXyXkEcGgV6KD9cPZiK1wL31xrnGczuQvsUSXz7Aw
         1I53MsBjFTbYzDj8vZfcYNuXHhuGFXmJIsIo/BA/tIr6fK2zFvM7hPAyW159j6YDVvJn
         IjhaqiDJ/ulTJhQFzrbcrPEULvfN1P4GMk1YH3KRAGA79bkiLRRmnnGjPcfjgjHV9md1
         D+Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794049145; x=1794653945;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y7ipCEUrdtIpyp5vON0jqVmEjc93IveEInQ5iyQmhTA=;
        b=OTOs9Uqv7f8sg5xwQ2wx+w++lKAZZERSi5MX/TBlORbQo+NpRAPOBVMUwg6aYRIYSK
         Y5tXETP+MS05afUUjK7y5h7ibnJBD9yPozQcFshAkvoFIBIzMoI4secfK/E0O+WEBRge
         PHyQOMKbjJFZA2bf2zML80dgRh50b07b7xI8r7YW5n8FCXjVGf0mmF7B+pwKOyLUuobA
         Mfua7zPYBC7AuVL19nI9BsLe7ZLk+eXmjLSo2PFeV0iIU+Kl9Blk5rPjnkV5W4BhzWcv
         gNEJFzq31FGjP4FST/ABqk5llMRdv0h3WLeiKqSUGzfh7BlpAalHK4+M0GFCBwZvrFTs
         aLlQ==
X-Forwarded-Encrypted: i=1; AL+hErERFDGi7MXq9/u/dz2TaznDiaBN+VEyRAhqBUc/byUqTczrRk7fLyIVPd8pAe+j2mp6xPYtr3FMprjaEpqj@vger.kernel.org
X-Gm-Message-State: APuU4Z8kG4azgIVjDux3/+3nTHt3GO/+OobJwjevSJJwSd5mFwZVWnfQ
	0T8F32bNT/6cgMSAE36YZQE/qTTpwnrY+JdNWklv3LB4GFO8v1Ma5OzJ
X-Gm-Gg: AYBFou2ppq41ChUUmh5T3wwpw26HXrHarqiCztIu4N65TTYDu+wzY9pNxVYLGFUzMEM
	y6K0fLnpc40Vb4B2Qk7Rsu4q22tKidNpX9rzQdLoGZICIVjPheAsbT/ujP8VrgmU4lFe2sN+szu
	dCDB2CK0Vk+ZnwJvC87g5/0WHRstPF/6gftNv1hBPrw4BcTx/te5G1Za4/XTaF5+8D7PXI0rCy2
	QGmGgqgrjb2p8hdxcvM2xXVRfbUecjmMVa3PZvSaYYhRmq1jmHlaPJTkMUvLA4yoR4yEmfU7F12
	lbdRZZmTv4R/iFInupmahUnRi8edqKZQlwKZfQFYemswwdjmaCzi703sB6gYK28gcF4YGIt0vqU
	0fW1+6HRssGLhNpYLRH27a9tHZv9fjtFHiHXp50qGVquSxNKPHGEyYwyU7d5ZLqynBbCJFfuftH
	wIzzff04b8ZcR3JCdWdmF34dJhLVFGxTquad9q51HkhPRcKMuegZohwgUrSK3q9cPey8VMNQZMm
	6RmlCNZGL7Y4dMJ552D8e/Je6gzFePszCEA3WgRbTdGdRnXQkoOPSwX1bAfwaW6LQL8wiLwMxhd
	fFHvaEKMfFthIpossvdLd2XT43rbj3GPssd4xUZlrH3jJQy55Rs7zwbQVAvgx4Sbvx6ncedtTdH
	O4wB7YNSIofg=
X-Received: by 2002:a05:6402:43cf:b0:6b5:4fa7:4f49 with SMTP id 4fb4d7f45d1cf-6b59753419cmr3643652a12.6.1794049145133;
        Sat, 07 Nov 2026 02:59:05 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b65d6b3847sm1654045a12.1.2026.11.07.02.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 02:59:04 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Chris Mason <mason@kernel.org>
Subject: [PATCH 6.12] backing-file: always end a queued write
Date: Sat,  7 Nov 2026 11:59:00 +0100
Message-ID: <20261107105904.3962893-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.56.0
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
---
[ backport: context: no do_backing_file_write_iter(), the write is marked
  in backing_file_write_iter() ]

 fs/backing-file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/backing-file.c b/fs/backing-file.c
--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -83,6 +83,7 @@ struct backing_aio {
 	refcount_t ref;
 	struct kiocb *orig_iocb;
 	/* used for aio completion */
+	bool is_write;
 	void (*end_write)(struct file *, loff_t, ssize_t);
 	struct work_struct work;
 	long res;
@@ -123,7 +124,8 @@ static void backing_aio_rw_complete(struct kiocb *iocb, long res)
 	struct backing_aio *aio = container_of(iocb, struct backing_aio, iocb);
 	struct kiocb *orig_iocb = aio->orig_iocb;
 
-	if (iocb->ki_flags & IOCB_WRITE)
+	/* Pairs with kiocb_start_write() in vfs_iocb_iter_write() */
+	if (aio->is_write)
 		kiocb_end_write(iocb);
 
 	backing_aio_cleanup(aio, res);
@@ -255,6 +257,7 @@ ssize_t backing_file_write_iter(struct file *file, struct iov_iter *iter,
 		if (!aio)
 			goto out;
 
 		aio->orig_iocb = iocb;
+		aio->is_write = true;
 		aio->end_write = ctx->end_write;
 		kiocb_clone(&aio->iocb, iocb, get_file(file));
 		aio->iocb.ki_flags = flags;
-- 
backport

