Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793938297;
	b=MV7svrmfjbXdaL0KQ0Kk8qm4onbjzo1hGIFAhhYqraNVJWe+9rbYpvKV7667mZo4XTMp
	 ZMahRnLeOpvYv5HZm9F3+uRlYmbo5FPkPyp/PcMhqY3hzYGZdjhgaTc11pfN/5isqJUAS
	 x89N9VuRocrR5OxlJ5BPtfDKGj9pGEeO1jf1SYFGF/YZaChEnRLVih0+l6sgoE9pLVkTI
	 mGT22oFlQDIEaPmvA+T8iSHmNgUmdSV72KzdM7z8OO9/9E0NwIl1bOalnIPYgP6XA9O7P
	 uRUV5u8UU4Q0Fk2jRC0aLL4Dh7EH2zS/T7q8g7nVQ08/7+n+na545Phu+oTFTPmq6pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793938297;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ohbx3Ig9z23TcoeMZrspJpYnLJsnWzy6p3a5v/NiZ58=;
	b=bo3hCweDmdCJRpbkCszF2V/SwmoychmT/8jzZn5WaWBniBPb1AW/m+Cw9F4jA4AQmbme
	 RSKNtlYcqRD8iSt64RNkiHPOvUymi+r+7PzZSd2s/4d37RxFYhuki+mi6rhCttttgL3/W
	 r40fSa9ppYvtOTqMNwm5YAgOytQtxyBpnO4vszWkBq7FSrzNBfnX51HwXlYw8c7iWht6F
	 m/EaSqIL/5UFE4TK0h08nit9VPrJigRdkjk4K05N2Nqbj7Iaf879wGtOaToGmMVsSvnXJ
	 Q2EzDbAYcOHYmCo95gsnGrUmJbsz9v1Z+xOanIQGNPmoOmD9E65WwUx4MGz3nuehyoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Nke7FdKR;
	arc=none smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0B7606A337
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 04:11:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C0B7606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Nke7FdKR
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b1b13e09ffso214406a12.3
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Nov 2026 20:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793938296; x=1794543096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ohbx3Ig9z23TcoeMZrspJpYnLJsnWzy6p3a5v/NiZ58=;
        b=Nke7FdKRKIYANwrvp+6uoQaNApgSrQnLeOaQdCwROv6gzM3vnNyFmEW9e0Xu9Odzvr
         qL8104lHFVOihtenk8ovQ65GvQpZDai68CSn8sQECniqE9h6p5iZWr5MHp79kk9Etchc
         MC4sTCdyck7K7x9or1+mm+J/0toQEQCe6fMe+Df67BGihaaKDODYjy2eJy6jzK7PIf2L
         6CQfDhcBus5YDr14IKvaWnb0DLS/O34Vv+u2h/nv2BBhGv7tFW/rf0Ktx/U3ldge6yaz
         kqp0b56HcA9kFKs4rI+JDMOPh4mV//bAX/mFy9nQXNH4P6/g6o4gwrz3R+ZZiaVCnB//
         FhPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793938296; x=1794543096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ohbx3Ig9z23TcoeMZrspJpYnLJsnWzy6p3a5v/NiZ58=;
        b=cm9x4YbeVjk1gP4oTVvbibBDB//Yhs6qWKvo3sJjHDrRweCNdes+hq9RVvX/BhEb8f
         sTZVVyS9+ffSeh5BHGH1Cz5bGoKd09sSDbmBMpmy9x1JO7GLKORuBbvVI57j5wR46Vsy
         IappssOK0WWacJOGXxgyJ6lTKvQUq9MRI1LnThhm3mjTGEkmLigeTB+qF6zLSSiNbbEw
         Kpm3P+r6cRFlm/7d8iInnYaAzs0Tdm8RPTbFzHspi/XCWD/bf4x4jkkJiPAiPA3C2qPv
         +wuPnERGHatOPA5hS/OxXonhVhbS2hxPuignywyeuvKvJXxrOijpmBslyFjgXZiye3T5
         9kgA==
X-Forwarded-Encrypted: i=1; AKwUvBxbKk3NZDt+If54ZpD9w/q9Y3IEnQiji0Q4WY83mJN2ah6tv/TxdQadinjzUvbNf2JE7maBZWIhNNzfxbPA@vger.kernel.org
X-Gm-Message-State: APuU4Z8UDhqItdBYJD+mkplOM9GD61vowSsm8N/RD9Be/J5ecFyKa/nw
	vToI7E60px6HWoVJpJ9POQeW8OiFsDyCYjetr4qONW6mHcZ8N28Xq1dw
X-Gm-Gg: AYBFou0xBSdq3vwFNDHBgqa8nsaMDKJ3yeCjooUVV12IyiWwjM8WHdraIlGqUutKrME
	R3aaYx5Pls2/58lgreaP9dfYecRhp05wJgK2mAXGVm88p/b4oBPKDCIZg4cFDKySMtuHwDyHXsX
	kDY3anrcirawtgV+rLxZKLjgRsXLkoBvsj0LGRlbN85cVMdN467wZK+bW5amFuW5NT4fEVL9TR7
	0qnsq/Ot++yKoepZsrWiO0yhKPgOy/1XQlLC5bC323kO6z/FOYKugr0pGleDF2FUAuZcaYSkq2x
	2JcbhINzIR6JZytMd7nsUmdEfbAZEEYPj9a8YtGpmavANch4GbC9AzyBGN1LoOJIzMi08vYO8qB
	qs9K9T9YnmUSXaglYhQg6yDPMsra3DFPP/bPXvaRvy0wRHtKGCvyI1mMM5j/sVSicsft/FPqdri
	9fYKEsCFwfK0MBHEr+VbjhGjdeQvcw9HFdGOUZT/rOQzNCmGLuy4BqSyTvvJWdPz/AmYWnfRiNL
	Kf1OhCtspTCeCZ0ByQYXLYJWnSbMvoXHF6q/nJXlBolB4o2fViRCbHglP3d/tpDJRgu5xbQn196
	M4d6YIvmykSclrtkldt8d01SlN2xP2wdxEx2cIM2Ww4p6wxluKWVfwDkOyaeqVvMIPa6emo1OZH
	UoudR5zgU8HuQ
X-Received: by 2002:a17:907:d649:b0:c40:38b5:d784 with SMTP id a640c23a62f3a-c4d34bdd04amr110673866b.22.1793938295851;
        Thu, 05 Nov 2026 20:11:35 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d356e58c7sm41723066b.78.2026.11.05.20.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 20:11:35 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.12 3/3] ovl: do not copy up a dentry that was removed
Date: Fri,  6 Nov 2026 05:11:25 +0100
Message-ID: <20261106041128.3797453-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261106041128.3797453-1-amir73il@gmail.com>
References: <20261106041128.3797453-1-amir73il@gmail.com>
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

commit f635192ad223d2009ee640b63adf5ce3198aa338 upstream.

A change to a removed file through an open descriptor replaces whatever
has its old name in the upper layer.

Copy up must only create a name in the upper directory, never replace
one. After an unlink, an rmdir or a rename over a lower dentry, a
dentry that an open file keeps alive still has its old parent and name,
but in the upper directory that name is now a whiteout or a new object.
ovl_copy_up_workdir() renames the copy over it, which brings back the
removed object and destroys whatever took its name.

An unprivileged user opened a lower FIFO and unlinked it, root created
a file at that name, and fchmod on the old descriptor replaced the file
of root with the FIFO.

Fix this by looking up the target name of the rename in
ovl_copy_up_workdir() with LOOKUP_EXCL, so that copy up fails with
-EEXIST if the name is taken, as copy up with O_TMPFILE already does
when it links the copy to the name.

Fixes: e9be9d5e76e3 ("overlay filesystem")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: use LOOKUP_EXCL instead of relying on d_unhashed()]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[backport: no start_renaming_dentry() and LOOKUP_EXCL, fail with -EEXIST if
 the target of ovl_lookup_upper() is positive]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -828,7 +828,14 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 	err = PTR_ERR(upper);
 	if (IS_ERR(upper))
 		goto cleanup;
 
+	/* The name may have been taken since lookup, never replace it */
+	err = -EEXIST;
+	if (d_is_positive(upper)) {
+		dput(upper);
+		goto cleanup;
+	}
+
 	err = ovl_do_rename(ofs, wdir, temp, udir, upper, 0);
 	dput(upper);
 	if (err)
-- 
backport

