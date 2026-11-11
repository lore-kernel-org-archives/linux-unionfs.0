Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.154
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794396424;
	b=UWrHbdzDwtYKBaqoRUTpFHWnFrMv81ebiVubczn8m6oBwcN29+Yj8JEt9Xv//Cogdhgi
	 g9LA2ec3AxacG44+BJDE+wdkk9W0DvhD+Opf5I+VSzk+qNhgIc7mVR1Cb8sgWaFXcEobD
	 HjdA69TJ2PbIveRRVmOZObrqZ2giFCV9/2BUkVlvJv4aMh9nWtPrFy31RerL4DnhpHYcA
	 Nhr8zYHNg9upNI5lSzluj5gbaxPnEy8Fai8XJKWljp/EvRzKF0HEAY4pJ3n+XqPH3nhsN
	 zDocyXaUAzAkMPCazCfz0do2OJo37dzl10BChjppOxRr+wkoVBVvWGfIP5R3Pkh1clQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794396424;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=OYgGkgBc3Zo8NbP8GoJ+WrX2F4k3zepbuBl3UZ0lVGU=;
	b=hLVABcWatfMplWjBJzxdzbELaQ68ZOapUTQy358N00cq2VAtxLrsvDR5WVRXlXFFNiz8
	 NXr+ggY6UCNQVA4ZyWxsHu044T+2l7X9DZt1sefbvMdisVQmEznlLwpRV4Jnj564EPitd
	 w84pdZE/sSQsdIlUrxV0E6d3a02W64T4n8IaVxJTmUO1J/HvQhkXSDX4TlGrwTZFn6zuo
	 /rFuQaQYSWBoa3CM8VCTkee8YfeSRrkftPLrOdjZ5uZLIfz9Ae/aig5+XNgjO8v4DI6/4
	 f1hRs9hV2g/fUGWo3wzT/ovo7hfNLqxtOSEt4p+oN5QN2JUYapr3wYhQBmW0qptwW0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=scrivano.org;
	spf=pass smtp.mailfrom=scrivano.org;
	dkim=pass header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm3 header.b=dT4osIbl;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b="l/E3bi5R";
	arc=none smtp.remote-ip=202.12.124.154
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717B9606A324
	for <linux-unionfs@vger.kernel.org>; Wed, 11 Nov 2026 11:27:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 717B9606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scrivano.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scrivano.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm3 header.b=dT4osIbl;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=l/E3bi5R
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 9EFE67A02B8
	for <linux-unionfs@vger.kernel.org>; Wed, 11 Nov 2026 06:27:02 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 11 Nov 2026 06:27:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scrivano.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1794396422; x=1794482822; bh=OYgGkgBc3Zo8NbP8GoJ+W
	rX2F4k3zepbuBl3UZ0lVGU=; b=dT4osIbl9/YNGbqAmHAj5Trwe53L+cjj5R8Vk
	2LreewxaTBGU7S4EjF/SaTuN+y7a0Zv+d/QI7K3tSAK3Xna/qxC7mB9rWBmqtSho
	Cy2QgF6WaG5rXM6ZlwcXoyLxKPRTTQCVGvn3Pp5Ups3iZz1wONdbXOoSGuwE/qxU
	RQA8g9eHvo01ZCliCNofpirfQKXq3KR8SOVU6gPdTxGOVi2WXmiZG5NJ9nXZ0t2z
	3azSBWW132RIIN0qf2+kGMpaI/RcYvTERpENEQetKnSu/1EtxlXNa7BUQx2KKBdT
	JRYkKW3ez3A/zWCzOTwKVOV5kYxexkuLwtTijBqSf/IAYX2Jg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794396422; x=1794482822; bh=OYgGkgBc3Zo8NbP8GoJ+WrX2F4k3zepbuBl
	3UZ0lVGU=; b=l/E3bi5RWSd2O48YxbUxxfteBZvjBKpN0hy4Stell7Thwb8qMNN
	Oq3tns4kchgPGRjw6k+e7P2k4sn7AYvRVCYX9cCAXGND0PrsjTKC1REYDdTNQrUj
	g3Iff5WCQYlly9ZLNxIKKzfvNTvSTu8sXywo9U3OxsXW38U1odsQhsdpU9JSPmmF
	2g84ZmwVQE0CN0l/DliHOKaDy68Igg2QE565LlMxeQrpW+a9nNB8HGht76vICL1o
	8ZDyBgJFsX8tb78B0qHctD0vtI6seCvW/KTt1En/+JrzAdUuX80kgeMgnO2fa9bc
	kC4ooA2m+3xGaF8q1edVuOmP4aGXLdis40g==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=scrivano.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794396422; d=scrivano.org;
	mf=PGdpdXNlcHBlQHNjcml2YW5vLm9yZz4=;
	rt=PGxpbnV4LXVuaW9uZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:tmSI+Vkc65SazqqNNQwez3+57KA41SmaedK41KsJ72bnG7g
	io904kpuEbVJVGzriix4YyKvTsB4WaJrVffdwxFvR9SqNQsMMuRV+GIANCWjxhDr
	alHrEJWdJ8FbwuCu5y5w5MNUe8hqzKJYKcCBxwWr1iZeqBKrVttYPc6Ba06TzraD
	pO+absj2eWq2Gp65Sjh7d5hVeExyFQLwCYcHkaNBILorvBVjXcaaCI3F4emyJyIS
	LWK0DPTtcYb7ZD3qb3EN0G31zDtDyDQ6z+MW8kuTmhxvJESpA4nKF43Qama/3Vgu
	t5b55h254aK7r+X8q6rne/RH5nQ4RLP/0ed7GLw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:hhmVjN5PypO+5msTxpJBN0oAY0+SHvACPp6O1ZCMfuU=:srlRenBE7/Coz1WJt52MgviareAXEifffzyyUOhLlU0=;
X-ME-Sender: <xms:BlH0arj88wy25H80swwo7DpOe4FQS-3e_B6jGCMHFsUCmhAKaNhonA>
    <xme:BlH0avfhYfTZXY_c1cRRcmhUIsfbNJAa0bExaOF-M_884-SzkyST2qC19Uhuvf6mD
    OpCfGvPg2Oyht9fq4NaRrvPHYI066ZCT3aLh4_-PGBxZtq_ubHSfPHd>
X-ME-Received: <xmr:BlH0aoco47Qa7W1YHo3pWwhnsSqp3x8phWL32uZGxOzOVXNVngp9qJHwjA79oa1pjIK4y3_oLkJcmnL_VzizowNTqle7>
X-ME-Proxy-Cause: dmFkZTEL27v9aQM9HY7ebTcGLY7juvS2voQuvstZCjgUv4mQ+QZ1YR1FF8urN7AamuiP3X
    0IcYRrxwh56VuXYV3B6XVkIjVx0rELYhW0GU+Sz2nkTsKetFwi0lMlEOxN88awsAr7Li+y
    SJ06v5AkAL8sk2pU5t7VFNUzO7ladu8VZGjOsSfq9WNU4jFWmKtv9prVuiNf0y4c7Ub51j
    wST3kHrL9avrc1hn6+BGWoqZOs9HJiWk/GqTehH8yglOmGaExdE/W/jI+CRv2G6cdS0tLC
    d/vcadYuwzs2nLEGcu652jSxEkoAbpTEhgSs0jqDzCL5rs5oPdh8N4kVl7LYH688kZT4LU
    YKu5eFphMIbgJw4BX6ig0qdbIAEC9YEZ4gX/87j8KMgbI7NTUYXdpN6rTOXVRnGHK1dxHj
    PfFfweZeqJAAyN1NGohV29GeY1E8bZRlif29GSHiap5P9PGnpft4NYYPWpHW2zNvEw4nYu
    3+jQq6SF4eLhRFvcXyJIYPt1SDuDxOWcLr21Q5ioOtwqHVQ2E8PCCXX9tPo7mYaebLUGKK
    rmZW+vFPL82jwT25clc+lrJCrwutvU2I5c0LYOjwy/BCF47uLhb+0GDzOvS6OfgnOoiD6W
    1cOv6VcslDkzclmQ1qOjOYaCseHZ408XvTbAUXvFrhAltF/lib4JTkdkxCiQ
X-ME-Proxy: <xmx:BlH0ah8PYHIwteY_CDF4WPfniynoFZsNnr8tr6WGHxDdhiMrxMxTqA>
    <xmx:BlH0asnFcT3V5mnxN73O9mP05ZdWONIwKPOJiw1jNHxmhWTRriZEvw>
    <xmx:BlH0ar9NAQ-mJWOTEE8w2aqyx63Uj8zksJ7Jn3INvidGplEMb2PTww>
    <xmx:BlH0aim-TktZiyrn-BDZLRS7RbnCAi254BZGa4KXMK9MCi6iOaZ5qw>
    <xmx:BlH0avcGqrQKEyBrUXoqzZfr-w9FPgdDFiNWELU6iLg9VMRJk4ZBRzVb>
Feedback-ID: i8e6e4897:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Nov 2026 06:27:01 -0500 (EST)
From: Giuseppe Scrivano <giuseppe@scrivano.org>
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com
Subject: [PATCH] ovl: return EIO if the lowerdata is missing
Date: Wed, 11 Nov 2026 12:26:04 +0100
Message-ID: <20261111112655.3454689-1-giuseppe@scrivano.org>
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

The data of a metacopy file that redirects to a data-only layer is
looked up when the file is opened, and the error of the lookup is
returned as is.  If the data file is missing, open() fails with ENOENT
even though the file is there and stat() works.

This can be an integrity problem when using composefs: a data file that
is changed or has the wrong fs-verity digest is reported with EIO, but
a missing one is not reported, the file just looks like it does not
exist, e.g. a configuration file that overrides the defaults.

Return EIO as it is already done in ovl_lookup() when no lower data is
found for a metacopy file.  ENOMEM is not changed.

Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
---
Hi Amir,

I hope I am still in time to send this last fix for ovl.  Rebased on top of ovl-fixes.

 fs/overlayfs/namei.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index d846c8d15b1c..298adac3a3f6 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1031,8 +1031,19 @@ static int ovl_maybe_lookup_lowerdata(struct dentry *dentry)
 
 	with_ovl_creds(dentry->d_sb)
 		err = ovl_lookup_data_layers(dentry, redirect, &datapath);
-	if (err)
-		goto out_err;
+	if (err) {
+		pr_warn_ratelimited("lazy lowerdata lookup failed (%pd2, err=%i)\n",
+				    dentry, err);
+		/*
+		 * The data of a metacopy file is missing or is not a regular
+		 * file in the data-only layers: the layers are corrupted.  Do
+		 * not return the error of the lookup (e.g. ENOENT) to the
+		 * caller, it would make the file look like it does not exist.
+		 */
+		if (err != -ENOMEM)
+			err = -EIO;
+		goto out;
+	}
 
 	err = ovl_dentry_set_lowerdata(dentry, &datapath);
 	if (err)
-- 
2.56.0

