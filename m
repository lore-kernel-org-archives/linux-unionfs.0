Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793536483;
	b=2CSTBhEB+2bVqkZFuKsQPRcM7gqrFibIMDpB9NmbWFE+4tXMajTChtWg9m+7+845cacb
	 cLMf84HeJr6tfw+nrZ5XbbBrfQIAc1HNHxl8v3TKFGChnI/obNlX2tWhRncqxA+e3GMNp
	 nrO4LpCpYcFUACJkq32cuX8+8+iTDwHQ3QpoBwH13kknAiRDTHQ5y/ottbAzI63FD4ZrW
	 qalzXEiUG4V8YRtCjEzAV04hNH2ycGAfCf8uu5H1JTBxm/Prema/T4uJcRhHBrVZcFVPq
	 PDLwvQDQ5Rt+V6Laa6ozOqK/SeC3QnT9C1vfWCylOjd4J7eJvn8V72h08KoWTL5U8gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793536483;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/D/A9T2EJRYZY/+rdAawlrNFx7uSdrcye6ffwoxRa54=;
	b=Iup5JzIWAwG+orcKAffAxvp7Woni4+HdF2VjvOD0ErmXDiTjmC+QsN0njJWPtsd8ZsqV
	 rBrVlUhcbVS0JwbqAAq5mff/aOwH+4LHf2pBKN3wOheKSfRL06DpCZ5MY+cYolsWkgSIo
	 QRoHfBkCpzuinOHnrTn+uuAU1XMOurQbRbv0SX09J4N+aCA1eCWGwOcTIn+oK71EkzTZG
	 RUgNYjTuhKnkdiN3tgcYD7EAQjHJ3vLrUb66rClX1JRKZhUf0Mtgpx+v+M/CvbaQnZlDU
	 3saaIxS+cV8CdMg/9sN+vVhC7AD9wqxy1m5AQUONoGxftGHpovxcquvdaNWDHOUJOPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ea5BdI1n;
	arc=none smtp.remote-ip=209.85.218.42
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9589C606A324
	for <linux-unionfs@vger.kernel.org>; Sun,  1 Nov 2026 12:34:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9589C606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ea5BdI1n
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c169ae1cb26so512528166b.1
        for <linux-unionfs@vger.kernel.org>; Sun, 01 Nov 2026 04:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793536482; x=1794141282; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/D/A9T2EJRYZY/+rdAawlrNFx7uSdrcye6ffwoxRa54=;
        b=ea5BdI1n3jMl3nTFIjg1OVwLozn1JI9ufbHSZXBBTwqcISfpOrOD/hWSMAK8goj+JV
         ghJw6j73yFnthUnjFxDslLRT+4HB7LlKV30AQYBDStO7smzuBRVrv8FErRmKnTSoG+Hj
         HGHO7IrLwKc0e5GRHgH76UfMvD0Kx9ImmbG7L6G4wlqp8coCHtDEUXPTDrPeq16C0EJk
         B4SjJ2hc8+jSM00jQEiKvveoTypIWvKmLgpreALDqigMx4jHf5g6oCgmucBsLR6y2anN
         cpWLspOjtXj3p1OjOQQA6moH5MO6dK1nAz8nb8lfgSH1fVyNMRdow7h2cIsuiO7KjvR6
         4LxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793536482; x=1794141282;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/D/A9T2EJRYZY/+rdAawlrNFx7uSdrcye6ffwoxRa54=;
        b=ICx/8U7OtT3LPWCE5xCx3CveWNd3ZVTen9yqeI7AvyA4mMPYePQD8xdEPHcdXqzAEL
         VkiEP1bnb/S5R2Sl2S6PKI0O0tHDgE6nIXvDsv9BC40Ub+yO5HVVrabnxGiZR7FgrM8E
         32A9TiLK4Nr76qFuiYwBoEcKIjMNF9jJ2z6dYf/2UIb6Be3IXEQIUyp6tam1gZxnfxdO
         DxpIfFSHM+aRnd1brK2KjYlc45c9CX5lfKqz/gCK5dn6GiDP1OuZHAaq9laSvpb3Hoz8
         d+wXLN/fRNYPw+aNl0bhi9lTtygtHR2pvNXKUSKzn+MqRbJlmWd1kFwRvq1q36Fg6rK1
         VbrQ==
X-Forwarded-Encrypted: i=1; AKwUvBwV0QstPHmp9lSuLHoDiRwLlmllXBjq0h6XDbZOr4LYyJEiAKfCxqcQlBQ8n7Hwzbsb9vtYxb9hrIqFzOql@vger.kernel.org
X-Gm-Message-State: AFq9FYJM72WYyuLBnGlAFLWLztY3aFe90EEQ5kEYqWTIXUsFkW1+wEvV
	eMWCtQOuZXhmtlJqrdLk+PMqsKqxm/o4SixlJyymFfPdUALKXw8Z+QGa
X-Gm-Gg: AYBFou1vpJ0fh7RPbRhFudRxVwQ02N870Nyo508mMir5/5LTuvufkqrBUMeZ2/sruzB
	yVWaS6vCMwpCelPvhQ6DhODMHRRV6DpulK8E6Y6h2OSc3+gsnAmVcDBDWsN9l6UkT0bfyi0GCBA
	gyTYC2bDoNfBvR5rRaDI8C0Ik2UC/NV+MCElKcayOPUZjReOoDbjoUHMVUe4LkfQHqAGgxenMpD
	nYmNUBBeE1/sWw3qkydCNttejMq5NJdeYoRdyO5rBQxYG3V+jnJYZDbXJnahtZVG7za9kXszhFe
	5MYkufmROuy91bBhIwzfXrY3+/mVeVNiBBAduo4Ff1z5qDAP86u2B1vBln5KWddnRjG/1goRH9U
	15uUubKi3qgsWJQYyo9kgUqoWA3yA+/+Q62EPU43TV3mAyBeS6Z+b9qy0wGQJot0uR3ffh1PFzJ
	hYzMYr+YFlDxMVQhU5b89GKvrWvWEHyF5N7akb24fCCfzK58OZQG7j9awosFRwGWtzyiQFI5sag
	Jb+AQJhCNy6GIxQbqFIJt3790tMbQMllk/jjWnhUqmuPytA1382eebHHOQzG9PjskCO4PLZs+M6
	4wHRVyk2zu5/nqLYSoZj4i/MgATts8VRxEqGtsU8aYgrktd2TBf9LfHKNAo6+mV7bsMnG1t0ePh
	ugdr1hYzmcZw=
X-Received: by 2002:a17:907:3f9c:b0:c42:fc8b:6c6a with SMTP id a640c23a62f3a-c4ca7a9ef71mr660488666b.14.1793536481629;
        Sun, 01 Nov 2026 04:34:41 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4cabc18ec5sm275298666b.12.2026.11.01.04.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 04:34:41 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	linux-unionfs@vger.kernel.org,
	Chris Mason <mason@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] backing-file: pass RWF_NOAPPEND to synchronous writes
Date: Sun,  1 Nov 2026 13:34:40 +0100
Message-ID: <20261101123440.3184069-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
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

pwritev2() with RWF_NOAPPEND ignores the offset and appends the data on
an overlayfs or FUSE passthrough file that was opened with O_APPEND, and
the call still returns success. The flag must make the write go to the
given offset even though the file is in append mode. Any user who can
write to the file is affected, with the default mount options.

overlayfs and FUSE passthrough forward the reads and writes on their
files to a backing file on an underlying filesystem, through the helpers
in fs/backing-file.c.

The flag works for the file that the user opened: kiocb_set_rw_flags()
clears IOCB_APPEND in the write's kiocb. It also copies RWF_NOAPPEND
into ki_flags, as it does with every RWF_ flag.

overlayfs and FUSE passthrough then pass the write on to the backing
file. They opened it with the open flags of the user's file, so it is in
append mode too.

For a synchronous write, do_backing_file_write_iter() calls
vfs_iter_write(), which sets up a new kiocb for the backing file. That
kiocb starts out with IOCB_APPEND set. vfs_iter_write() is only given
the flags of the user's kiocb that are in BACKING_IOCB_MASK, and
RWF_NOAPPEND is not one of them. So nothing clears IOCB_APPEND again,
and the data goes to the end of the file while the call returns success.

An asynchronous write reuses the flags of the user's kiocb and is not
affected.

Reproduced by calling pwritev2() with RWF_NOAPPEND at offset 0, on an
overlayfs file and on a FUSE passthrough file opened with O_APPEND: the
data was at the end of the file afterwards.

Fix this by adding RWF_NOAPPEND to BACKING_IOCB_MASK.

Fixes: 73fa7547c70b ("vfs: add RWF_NOAPPEND flag for pwritev2")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Christian,

This is a followup to commit 19b18e01d0361 ("backing-file: enforce
append-only and immutable backing inodes").

It is NOT a security fix, but a correctness fix for both overlayfs and
FUSE passthrough. It fixes RWF_NOAPPEND being ignored by sync writes.

It had to go after "enforce append-only", otherwise sync writes could
also overwrite append-only FUSE backing files, as async writes could.

Thanks,
Amir.

 fs/backing-file.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/backing-file.c b/fs/backing-file.c
index 5780f60662d07..c601b27f0fd35 100644
--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -115,8 +115,13 @@ struct backing_aio {
 
 static struct kmem_cache *backing_aio_cachep;
 
+/*
+ * RWF_NOAPPEND stays set in ki_flags.  Pass it on, because the backing file is
+ * in append mode as well and a new kiocb for it starts with IOCB_APPEND.
+ */
 #define BACKING_IOCB_MASK \
-	(IOCB_NOWAIT | IOCB_HIPRI | IOCB_DSYNC | IOCB_SYNC | IOCB_APPEND)
+	(IOCB_NOWAIT | IOCB_HIPRI | IOCB_DSYNC | IOCB_SYNC | IOCB_APPEND | \
+	 (__force int) RWF_NOAPPEND)
 
 static rwf_t iocb_to_rw_flags(int flags)
 {
-- 
2.55.0

