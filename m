Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793297003;
	b=vkoZl+g6rOfwDBpymbkYjzF1NSPrJnpTeHctaCXmTtKo0jhr3Gdm+2/Lq2n7Dtx4orgY
	 /KBrRLWmkHerCbl1u9Iq03G348CYcaNXiKKr28gbHdZwaWnAvRI9QULfxvrdcoCLkq84I
	 ByJ7sX5tz67h2okTWRPXtVWYwzhZeHgWm4xOG1estXs8bxfd3mUQzLaNmQwMjeVe5Rrst
	 RMIQkrlxiZ4N/ZcXct44OMasPbJYC+uYvNUcK6QgCjLkVCPoYm84amt65bWihx/6Z9k8u
	 Io9nqXSuSjdDGDMlvkhNzdMIdGNOhyC1TngdXYfMvUXRA0BiqbOfEyGDkJ64dIAkKQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793297003;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=VPSwyQABsxDeIKe15KWcg49fMkA5mZOjf5WHg6hn20w=;
	b=UnkRlPSNCuXkjZeAg4jSkp/fMo+G7/sW/E/CJCoAZTFdqG6TVSE6Weh1lZ6F8PrbGpjH
	 nrR8w6obTE0TIYJ4OiQQhZEUFebE7QnsPGWrWZPzgM5hO3MooK33oQdgwnBfkgaGeTey0
	 E7yd/BjLbb/MNwuPuJ7BYxLOXX8CipUgsNf/sdID1dQKbYtV9X2f77xTjijcfXHpUM57+
	 nXtcbElrO4UMbp6OMXy685eRJH4PcUXovU39Iamsn+jY/sYJ0Gh4+b1Hw5SgT+nav1P3i
	 /jdwDKKxsM82KW37IlNhVkk1XSPhJL3mkLC9K/975XvKR8K9xJ3lRYYcDJEaC3Gmzsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZSsrL1ec;
	arc=none smtp.remote-ip=209.85.218.43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE104606A321
	for <linux-unionfs@vger.kernel.org>; Thu, 29 Oct 2026 18:03:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE104606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZSsrL1ec
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c49c32650adso291794766b.0
        for <linux-unionfs@vger.kernel.org>; Thu, 29 Oct 2026 11:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793297001; x=1793901801; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VPSwyQABsxDeIKe15KWcg49fMkA5mZOjf5WHg6hn20w=;
        b=ZSsrL1ecNekN3zaxWylXVh3KMWw3H1DckiwhWZhQsH2Fjxq/KCRzXlEdBL++OKYd72
         /tT9WcgWdzlhXV3VUmMy6OtAgikfoNKRY/W45ycj3ICAf166SZysPvClGAwBH76+my3L
         6h0z8Xr0XyCrBpYuC87CFbto4rYfuv+EkATe7hkSMm4Str6blamnW4iH2xjaoJ7hrjgA
         mgwhp3WnIm5ZEFEiriXois1iPfdcUpHWoY6VXmPKaP2TJbU5uHTNsFxZirU0f+269bgU
         iiKCBnrU7Ie91OvpnHRsU3ZORrqv+p/+CmbLEDrsHmazHn+YOumaD1rnmfAOGw1Ow7Kl
         2BZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793297001; x=1793901801;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VPSwyQABsxDeIKe15KWcg49fMkA5mZOjf5WHg6hn20w=;
        b=ZpN+LBr+bYsZ/Y6KfzvAFOO4G2mC72QmKS0GYta/t8GUlxJWHyGAuR+J3JC0BGnqHd
         iD9GO3e7sdl+Yj85YUa8gBQbo9Mpa6hdwwwpfyfTZANGUaLz7wQWi21BtXEG9FkqOTqq
         EuDxeyCW3dtEEBWWZnxoafs9iRGeS0f0vCJWUBD+xsFZXtNPYFxAX/pjyNQrdsS+ycxf
         XOYdgxxK+UdGGwTmK95JkPYmOPsxpvOJOCdmTMHIOFJa/4UnlVxmYHLAVZb/TkcoyUir
         8xUl9wHwy7y0h2GEjwk0BQNOYEVl6k89eERg07/e0wbBMXjawdkmaPgXW1lvx0+pi+9W
         92GA==
X-Forwarded-Encrypted: i=1; AKwUvBwIeKZFMrVxPKQdBRbCCal57Tv/Rf/yAlWSOdK1LMAVC+O8EwLIjhr6nHuBTSzFQwZPSx0z+n4pUSwRY8JN@vger.kernel.org
X-Gm-Message-State: AFq9FYLilKYX6AVYtEgHIqjHdIol9l/l8DnEDzTWIGgIsrrNarxVYiXx
	GJOk9jYaXMGqKX8IPwqe1A8SKKPQAlMj7HQ5PgHcTPRvxzVZf6lCK91C
X-Gm-Gg: AYBFou3Ib7uhwl8Kphv3DC1q97kFDs07GQBjo2xw4GpVDTK4HMrbJry71Hh2ehILve/
	U2vtzb0uJpXJd6VCvgjglc48s8hKug407qQsvRx31brmuROUXDHV8v4oJfmA83ch4lfsGTS37Dh
	pWXHU0jzMTSgBgd67hpt782I8z58YVkreiQCZgw50HegWkpSYBWTeZyJAptO9Bu+DFOQy0NUVeN
	BEq1IGfTCb58aQ8Wb68Lcsou5lc10AYHFmGmmtuE1J6ZjNB/uJ1n4C7L/K/mJ4U54/t7UoC0yjD
	5hHgnf1ONFpQqnBdBPi2D1MndhgQvuipIf4pfGT58tNyTGDD0UYnhFvP0SeCMUZGMp/tInSs2kS
	pHC9H5suz9VNCD7KssfUiQazNfDQwV9BuhJO0Y3GILPf/VMlqf8GoZWXRUAD+nO0n0ayCZxL3rr
	/3E3GNnguI0oCny4FbPJORli3TLiR7s2sVDYWJYCv2NTNFo6WlE+4X6HLai7K0bWuJ5dORS9jlF
	cE5LOSgGYLiDlzTv5bF+z2Z6ZtgKawOjMdneCcFUCItzvjIPcNEXX6G3EST7wd1PPFr7gnpcd29
	EFGMBlVrV4VD7x6GyiS54WY40oLX1DgFro0tW9roZT5G5VMxQyHBPrMEwJXP9SHO3hAvH9EJAuz
	sW/O/2Y783Mec
X-Received: by 2002:a17:907:d92:b0:c41:26b8:c49c with SMTP id a640c23a62f3a-c49bdf0b4aemr514913166b.10.1793297000979;
        Thu, 29 Oct 2026 11:03:20 -0700 (PDT)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4ca3003e65sm8631466b.21.2026.10.29.11.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 11:03:20 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] backing-file: always end a queued write
Date: Thu, 29 Oct 2026 19:03:19 +0100
Message-ID: <20261029180319.2852090-1-amir73il@gmail.com>
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
---

Christian,

This fixes a nasty little bug.
It is not critical because it cannot be exploited by unpriv, but
innocent priv users could hit it by mistake.

I could carry it via ovl-fixes with your ACK or you could take it with
your other backing file fixes.

Which way do you prefer?

Thanks,
Amir.


 fs/backing-file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/backing-file.c b/fs/backing-file.c
index cc101143f9212..ca8654fa1d83b 100644
--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -84,6 +84,7 @@ struct backing_aio {
 	refcount_t ref;
 	struct kiocb *orig_iocb;
 	/* used for aio completion */
+	bool is_write;
 	void (*end_write)(struct kiocb *iocb, ssize_t);
 	struct work_struct work;
 	long res;
@@ -124,7 +125,8 @@ static void backing_aio_rw_complete(struct kiocb *iocb, long res)
 	struct backing_aio *aio = container_of(iocb, struct backing_aio, iocb);
 	struct kiocb *orig_iocb = aio->orig_iocb;
 
-	if (iocb->ki_flags & IOCB_WRITE)
+	/* Pairs with kiocb_start_write() in vfs_iocb_iter_write() */
+	if (aio->is_write)
 		kiocb_end_write(iocb);
 
 	backing_aio_cleanup(aio, res);
@@ -239,6 +241,7 @@ static int do_backing_file_write_iter(struct file *file, struct iov_iter *iter,
 		return -ENOMEM;
 
 	aio->orig_iocb = iocb;
+	aio->is_write = true;
 	aio->end_write = end_write;
 	kiocb_clone(&aio->iocb, iocb, get_file(file));
 	aio->iocb.ki_flags = flags;
-- 
2.55.0

