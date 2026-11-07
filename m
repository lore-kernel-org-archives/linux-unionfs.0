Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794079192;
	b=0SKNaF2YMTmlvMYduIi4n0lYbEOvLfGNiwnhbkGoHTsSoHpySEdn7FS0VbxCKrDWO9DR
	 n+RKJ0n2N4leTZa3U3n9EOGlQ2Fagb4KjB5FMutl3Jw1b1XBSZvO5zNmyi59NnPKEhP1R
	 /MhbSDW6zJpsb6S4b1efA3TJ8vFwkj48GaTX6gcs/FO2vCqsbXNSwMnS1nBOY1ShWsoCp
	 S9Oco4rLwJ8uWmiBGh2W6WAvHb81Rl9vUyP/WCWe6OT6yQV71vHBWXiDygITUOHN3nHfw
	 nwBbPNgyJ/zCb5hhPJCGneVYRIS/I1v3w8ls5XKLZ7DTS+awhCuwyiDWE5+ShKgntKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794079192;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=fsgc145zwHET8lvApLf2hA0PKAQBWP1kvOH0cyQnSe8=;
	b=xNYdNxkZ/Wvf1vFNRKXERJsA/e/Sb/qS/K2UzgwgOd/7paUD9LJGKRKCQKsSOuAlR9id
	 pLxqBy9Fcn8HqAOMwMyx/ZYNca5j1ZEto4qOFUUdRBqb2qa7zp4J82WPQ+p2MDYTXB+Z4
	 nuC9m6p2e1nbzaREvvAs6krYQj47voWbSZzcWJjmKkyK2LObPCQUHhl1GjuLRwR4VcA0A
	 HrrEMP3zNCOOTtqNpRv+MqGWelejvRtw1DXZ+hYQtbfYG8Mdhw6e38PygfokhxJHvD8Am
	 32c+oWY0k7toNQ0z6ZcGbxFZ2ZK6pSfILRULD6gxvQ2x7Bu7r9dB8YUNKuygKxg7wMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=Z7Cak0sV;
	arc=none smtp.remote-ip=209.85.222.179
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C097606A326
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 19:19:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C097606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=Z7Cak0sV
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93f3c8958d5so218177185a.2
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Nov 2026 11:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1794079191; x=1794683991; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fsgc145zwHET8lvApLf2hA0PKAQBWP1kvOH0cyQnSe8=;
        b=Z7Cak0sVPYDVlTVtWN6Ehc8TdfydtFdbYV4fK9sTpR2rgLokdojTHPgr16ezty/AHS
         5ILzEEg9zIYy+0nMbgQp+dbEsix9RGwRbf+h4pEaCkb3kktB4kWnOQ+UrbC4D3jTy1jX
         wpy5kJ60tBqsYp465NuMSi4DM6ZZDLrW6T8RMR3mHchkAOK8Wn3ii/uHY4vdhi8Xo2Y9
         TlIkdID1id2sUJ2gCsyVWLRKdtbQaM5OfC5UhEcHI9WWx30KdBM5qUZHbbLXwK8Pp5JR
         MZqJw20C0b9Nzx4R/o+sVSZGqk5bjnKvD5zACVQCxYYLPVOPW2loSY6novsLpgTHTt1c
         HuMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794079191; x=1794683991;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fsgc145zwHET8lvApLf2hA0PKAQBWP1kvOH0cyQnSe8=;
        b=Z3w+vvrzBBA2gDddHcsDlU+ROkJGecyAhxBsvV0ypq/dMjOTqu1AhmcziY4GpTnVtF
         lNZSZyzRlYK7qnEe1M1dmM3QoA71g9mltCXM7sBa6io49la5JZuV4hq7n4/afmpCBAP8
         +2gv8/IEjxp2lal6Hkjf+QCDIWlaAymIWjvHwbcvT1CwQ55SmU4Tbhhe8cRg98RtZGdY
         8N+1yFKLYggQSI8SuybTJR47+n7W10Z82P6wuRDxKMgN35x2aeZHFAbvDN+/iQnno0B6
         HbUH2CjkJmuOQ8I/5MDdExRfemliDwSmOBeUclMRDhUy/MXim0EfJ1SpK/hQzi6lTLSI
         2vZQ==
X-Forwarded-Encrypted: i=1; AKwUvBwk5a9adkcH0A6ytfMt+G7S7DlLN4Y7eJZ/BhgTU4E48J7f+lToUqq/6/UbFG5Pqgq1W7BbYc2gtne3Ihdi@vger.kernel.org
X-Gm-Message-State: APuU4Z8DtbeZsu/gIWB44Z8ovzvxENv/RQIq3Zn9SM6V0IWkXV+2ug+K
	a4DfxUnkfGwCc8jv/YcIS2AKgY9+sAbCnSZWrYiG+VUNrCmBxaf7xLvWdjqlRpykDt0=
X-Gm-Gg: AYBFou2c8bHLejm2ajzcss6WZBxrCwgYDMBjQQM1t50yt1QV99xNFKHptyx+hjwrpsw
	vepyyJOIqKF+lvKeD3aSoGDO1O7gTL8K71uDpNgi7o6TRgnI3+pXfLH4X5upOKlzmJbWa5gZQWz
	wTdDI4tLSnGAwwH948xRy8VQfzZblZwwD+DlYikeZgU+qe7StyQrw6c4/r3qF2yH2LlZ7C27IAv
	ZgZuazPO0OGKYtJ78gbLwEw0uBVmIjr8yeK35pI9nBvpapUcM1IRzScNm+iSzvpWwM7svsPTNhO
	dYxJg1jX0YNATuDjUVKyhjzwxysDP3g17jwOgPxPvvWiurMi4LFyO7HVjS+a9glZDBVvg55gY7Z
	kHD/SFeSA94Eezv18hbYHP86oo5VXlKFtYgzfrH0DjkBOPBRcPKbBVfhlKJXR4xWEidKpyyXbVn
	ksChFp0r9YLSVlOjLSaSb7NoIfzSMlA3IioOPlRt7wNTNVhsbmg3GfZmETBbjM2iGS70EQsoNMN
	bF+scenzexcCGWdhxBb0BGGc4TzCC8vzJg1UUyeRgxjtuT0sVxrYlQ2JaocZTu7MndGO0CSxqdK
	hF7FV0+unT4JZAwjC5hdrApvduRTq1yvhjYUHE55waN6z+cuvUReK9j1ETzdE5fmFnI=
X-Received: by 2002:a05:620a:4156:b0:93e:646c:9133 with SMTP id af79cd13be357-945f35bfe65mr1012265885a.64.1794079191223;
        Sat, 07 Nov 2026 11:19:51 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.243])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94782daa389sm2934085a.26.2026.11.07.11.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 11:19:50 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Sat, 07 Nov 2026 19:19:32 +0000
Subject: [PATCH v5 3/8] ovl: setup overlayfs' private bdi
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
Message-Id: <20261107-b4-ovl-containerized-sync-v5-3-d34b4ae57fdf@toxicpanda.com>
References: <20261107-b4-ovl-containerized-sync-v5-0-d34b4ae57fdf@toxicpanda.com>
In-Reply-To: <20261107-b4-ovl-containerized-sync-v5-0-d34b4ae57fdf@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Chengguang Xu <charliecgxu@tencent.com>, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1794079181; l=1000;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=oigsy1vUIPeqGe01IWwnaOrpAKAk76udNuQNtC58Mj4=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QNI/mI7OdiJcEaP0mvnF4I92ol6HamcTIv5i6f7c4gVJLbFmOBMSe1XrqWUH4y/1LsDC0DWIHi8
 /QqJSQz9ABAE=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

From: Chengguang Xu <charliecgxu@tencent.com>

Setup overlayfs' private bdi so that we can collect
overlayfs' own dirty inodes.

Signed-off-by: Chengguang Xu <charliecgxu@tencent.com>
[josef: only for an overlay that tracks dirty inodes]
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/super.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 81da70fd53a6..22a8d4eb3b7c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1490,6 +1490,16 @@ static int ovl_fill_super_creds(struct fs_context *fc, struct super_block *sb)
 		if (!ofs->workdir)
 			sb->s_flags |= SB_RDONLY;
 
+		/*
+		 * Dirty overlay inodes go on the lists of this bdi.  fsync_mode
+		 * is final once ovl_get_workdir() has returned.
+		 */
+		if (ovl_tracks_dirty(ofs)) {
+			err = super_setup_bdi(sb);
+			if (err)
+				return err;
+		}
+
 		sb->s_stack_depth = upper_sb->s_stack_depth;
 		sb->s_time_gran = upper_sb->s_time_gran;
 	}

-- 
2.55.0

