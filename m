Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794049148;
	b=Hn4XIwOkKg5PgGl9sDEY2T6ES32Su+0/1wbbfjah1/jROOV4n/ZnzNr8pYeaXMojzfGA
	 QL7loxGlguzwRb2y8qjI46mkGIYpQQZxQR2/AjqYr9bQ+ZJABfQYyQoau66pJSfHHA/el
	 kWAzUqYJ+fL/w3wY+XHbOQT8lYWruwk3h5OF4i10gLA2tMsvHxgg8bf+DVIt9MIcDn5ro
	 fWV50rfe6G3UbDuyGLjmlQNgIb2m4AzSimN9WwRnH5KyRTyJ6rdyyItDgFb5OogwEfXBD
	 cGSMwDQYwT5AeGhOhQdIWyY7nTUav+MNBIckbPaNCDvKl38XoGCI1AwXFTJdEO4WXLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794049148;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uF3NLECGowX2y5BaUJvCNV96peqx+/eZQsYA4HOxfiA=;
	b=1O8DPOv+XMihqnBSm9eeeohAAVKmzmUsCOk8CVSiLGwM1CmVk+xGZLczgEa+26ejYtiE
	 aZ55w4JEDDatzd5MzNqS/dYShlIT7W9lW5EnkmRzpLuPxiASvcXq2aG69isGaVKeQSpvX
	 +TiCKQNAxlLpwQ0aBCI7InuMdouGoEJmGDejpU6PIQGpNA9q+r+8sBTIkgQswIZqhJpH3
	 ggBBtZp2CDMu7X0PEYpqD8z+Db2AJUDNicE3qjX5O2UfX9xRRrzqgsxSIVwrg+iTNOhg+
	 TQ2pI32iJT50zDDvyVTgNF0aiokZkrGaqo87ZQJyx4/GIvEz8CVlV9U/9STKyxfdPGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AfRugtVJ;
	arc=none smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B244606A33E
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 10:59:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B244606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AfRugtVJ
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c4d5b2db4bbso20026766b.0
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Nov 2026 02:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794049146; x=1794653946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uF3NLECGowX2y5BaUJvCNV96peqx+/eZQsYA4HOxfiA=;
        b=AfRugtVJHHWWen0rD4EPsg5cpCcP0AekhrFA9Qt/I/sf0AYhVFxJuJiuAaP9JFZtp0
         9yLwbTGPT4/921m5nXTYLd5LLMuzVqDb+Ws7u8HPuAjJhOuvma0tuCHivKiS2jNdBCbd
         Wz/2t0HI7G5QShGuq54OjEk7kvdwGFSsGqXVnIcoWjEpg3G/J/CtiMvkKoRfVVlLkNx+
         NJkDTTdZYy5W+2znJZcRy8D7Ua0T+MwIHdWnzM2+XXDCiUkOMVtqJJ2Hiyq6NpkpRckn
         gjA0dptNa7A0UY0NPLF4MLzY+Q8D0vk98gXYz3ZTuFiaTAZDmSueug51qA028x3scVF/
         fDyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794049146; x=1794653946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uF3NLECGowX2y5BaUJvCNV96peqx+/eZQsYA4HOxfiA=;
        b=0NErHIo9vspZQMYyu/QQqLaNaEz89Nx/Kk4uuAKUhDeCtIV9y29qkMAs4cV01Mac6G
         Znk8zczbrcygaT3YJUt8g4HoampSp1dSldqFwhCLz0O5DjnHAOIn3H8F7srCqTgMnBje
         dl/AkiRE8rnHKKX4zaLAfXNFm9lxzehOnvWeWuZxVWVealHIrXpsed9V1K/zoplkh3XD
         coHYT8WIq69McGw6pW+wN/FxnHxCAJmLNCRPm5Ee07ZONDIQpRPUvG97MKbgOQbPIP08
         QSoIl+rdrVnSY+WcY9HFFEo27d0Im7PWFSiKxMmVOnVJDBvjYW7PyaxqmFufg9VOk3XQ
         yoAA==
X-Forwarded-Encrypted: i=1; AKwUvBxjV0Km1X1AdQ9wposVGOy1Ae5aZm5MIEQmgHjJtFgH0iD9qTeHIZDEtBWR8LQbM8bFHDnlT0Dd8qKhaLcT@vger.kernel.org
X-Gm-Message-State: APuU4Z+adBKTWT8IEqqn8HXMDQOz/Jl9tGoh1bxAQiLJusBZ7sMFOzw9
	5PUc40TLJT8X3wtcwdDFwqsBZuMz0Tb5FSd3eFmaTokQTYnHjhhv2JFu
X-Gm-Gg: AYBFou1E5YIlycwiD4mSK1e3V7RgZa1mHSgqNnWxwwrnwJgL3hQYKlCLQqLmTWGIPSD
	fBWnjo/00UmHzBE84ibqUaHEXg33rn0oRbF7SIDSrky2jV3qdOF/bsplpMGagR1zVDqPViYcpTx
	DPZ9pDtulWauxp1K6Z3H+xm/GBSymwtXY1i3m4wY7zzgSAbqgnwfDQqCbRtJ6Qgh5iStwph2T0A
	PRyWa6m0+nz7BxV2zKarUKFHPJc35PNzDO1FNcJ7+mYLjwuxOfMe8SP3RtBht4XrpAg5cQKpmJm
	Nnr0IGR0r6jo3xnUWQJyRtCVM5nKp85xdpab46VACsRjSDz9Mu54jG+mmDefB9tr9jlZr8sQaET
	p5Wc1/BdZRhSMrFq0UE18OWBmvOld3yFP4pI3us0ZnG95HkMRTIzN8AkC/uyaLM6abZr3MtPiej
	2hUIwjuzVSau6D0c+4bWP+AVnM2lorUfYyUWs4cYiYyW3yJhBydeJ/cbszE2UPmh0UWFLgVOpEq
	8lSt/hJ7ZHV5P6ZW2uj8C/z9v6cqWASTjK7XSPOGqvU+XKU/D0hj0elZtY6OUnCp/TkTOOPM0en
	pLWqwZwCXjnm8NyNtdwJd1BIzvI+J/1BXtVykdqf0AxLHrrQvOrUnrYyxlF6kELj0wV3pZI5wRU
	JjgSLXOzfeXfL
X-Received: by 2002:a17:907:1c92:b0:c2e:2275:1168 with SMTP id a640c23a62f3a-c4d527afc43mr109634466b.19.1794049146286;
        Sat, 07 Nov 2026 02:59:06 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b664ff8a6asm1695097a12.32.2026.11.07.02.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 02:59:05 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Chris Mason <mason@kernel.org>
Subject: [PATCH 6.18] backing-file: always end a queued write
Date: Sat,  7 Nov 2026 11:59:01 +0100
Message-ID: <20261107105904.3962893-2-amir73il@gmail.com>
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
 	void (*end_write)(struct kiocb *iocb, ssize_t);
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

