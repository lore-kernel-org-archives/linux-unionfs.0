Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793938302;
	b=IEw8AsOq6JOSmK041Cg/l89UpMMypBXcc0rbIPx+5x9NIQURu0Vqz0eZeqU2bp0JlLZA
	 KBNhhaX/itLpKEfx+NzjljoJBiJSP6NvqRNabPepyggTOjcWM/zkpoi04ORP/2tGUxut6
	 3pSuTdw4Qp8uThHzeSyV/5wbgEdfpkVKry4f3XduESNpAXIXCV3xAPJz2WAyjkNmv4Gg2
	 uDc3mgSxd45+JcTFSu9yRbC7er5aLKW1/LMRhSg3kASInpkZlRBK2mh5ToIM9RRWEAeJW
	 9QUB+/g5zUg74tOgxPGbpIXgW1dvY0/K1Up6mtPnMrkY7z0K8q2n9IpCKnNmHrY0rFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793938302;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NIgE2uQWtYxTbhtqb99xSrhaMp7sX/IVRuUE2g9SjPw=;
	b=l/YT1g7bo7tOavg+fxh5NGTOYugQRnitdWu2WjUPcvK3vhdNhr5K8J+QYfg05uWposCy
	 ZDh2v4KyNZsyFupdUXiFzgRHS/zJGgP8hAs5sIrhQyVppZocVMUahS1hH/+3+/g8sxJGL
	 /PIZWFOArp1O9fwX/0SnvyWaGsnpOFzlHmEjn5+Vg20CuAIhwj27Wjv2sfbOrCnGHkzcq
	 9qnRYAJ7DgO9RBYglCzgVcgSPtJhtF/fXTLCsGwrseiUBsvA3VBWP6IPsVajwKOsBS0SN
	 T5F/6ejZxYWeJ/1oUM4bEqMTPRRmIV5NHc82x4kRnLir5gP1KX2TOHifBXR/NynMWzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UHNCz6O7;
	arc=none smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C36606D80A
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 04:11:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96C36606D80A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UHNCz6O7
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c34bff61551so30331566b.2
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Nov 2026 20:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793938300; x=1794543100; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NIgE2uQWtYxTbhtqb99xSrhaMp7sX/IVRuUE2g9SjPw=;
        b=UHNCz6O7Vn34MTlJt1HM6eGcVP31ROlm2tiCpDJx8xgm/jeoBT0fyuJ4cXkFnBfgOR
         3ji/WbQi6blXKCPbtr4pRth4QZyZqF6eeadi2xHFq4fyVq2tNTyS8LdNDZPQfMZ17YVF
         xn6puwFawiDjmuRWF4PAmY4Qkg2r4aPAuts/X9aTixQidrbVBIJwlj23l2NyB71TIp39
         EoVhi5Bsp83+iJ+sLNvpF3w+NrQnFjNneuR+NWkGyFng1B3LsZkKZZf2yQnpYrfzh65Y
         NbgGbe+okOaLsJgk+ohENV66s+SKFksFdbTiFaVf5VotU0TON52bfqMjnptFExHS3eP2
         efBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793938300; x=1794543100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NIgE2uQWtYxTbhtqb99xSrhaMp7sX/IVRuUE2g9SjPw=;
        b=MCi0+8uI1qUdxl8uEruyiRIEdjeO/W23C4Ps6lJ2TGsJaBf6T77qW+NZxlPam6KHQd
         niyR02twntQnryrR4fcTnm+n+NRs6YSWLRK/siM9IQqjiSGcUU+7hIKInegRAUfM+eIR
         X/UfyhA2J3Xm7AoO8Qr14dndaV5EXC8xftA/2d1hO68X+fWcZFvSzGu58eSxG7ZnQZQs
         kXTMWBzvt54CFTFqpPINPt9MjdJ/j9GKXl9gFuROZZvEGmERcusaTXXTnGu/ItB5y8wN
         OmByXjsyK8C5q2tUAVTRutWT91DeRBGqBLsJIlLFblkU6MG4iMPAVje4+YbV10ux0kJC
         GO8g==
X-Forwarded-Encrypted: i=1; AKwUvByHtwMtLoJy6CxqZMO5v6TKyVJhB/ErXDD/B+ZmFgc7k8oDBr9YQgyJ2X7vt+ITUtk4r0u4if3vLFkY9koZ@vger.kernel.org
X-Gm-Message-State: APuU4Z+k2ZSCSk/DwGNH9IQFzT7qbHTVHM+inF7Cl+F8GP8H+D7Ax+Cg
	c7RKR2xyDUhrWYHy1oZfUvyWkkqhH+CPwXj/8w3aBzl4WEl0kvNPKVmP
X-Gm-Gg: AYBFou2rrlTFc7nwE42byfCUojhe9DlCAPFQn/7HD5Fjs7WFhzRc8A/pNWcHZxaA1IV
	3WgBU5gs9gn6Qk6hPYOk4K2MhhmGvATW93D7RUSgD82rNWyW7rybMJTmZ792lQGkJU269mYwE6+
	VAw+3JVWfQ4zWnshTZGO78lHiMIoWQOJFlRfKfWexCrN+qUnJCVuGeCBWe5noEN3qmkizMF4kU6
	s0p7/EpdvTKNiBqi+YC3m23CnbeADvbGGCCH2Aw1Q2XsQLSPjkw5NTm6g8TOIL4rxTLxC1Ado2A
	lslMUd/YxQ1oeX1MGR1RBKSfnIwiGI4mgeWJ7H+wtfuGePaGoR8YrY+uLEnVqxaPfzucKrq9CyN
	DZpGhJfP0YU6XLZVfbYfoVD5lqiA+bigfrn4Yt3uQ9O2Pp5yd0LQ0QA4BFdl3ds7NfQjaa2h0b9
	ef78LW9+08VKurHHV/+h2srszRp8q5lRVFccBF7DzyYCTIRd+xo524S6dd9TPgxSWUL1sJ12VBD
	pGF6cBJkLBL6kvi89IWjNq+xqsjkqn/SSRXwK5iKjKPb4a7cVGL0dRH/UwyG3yudwCluk6XzDAJ
	yzyF/HAUsgOTmENyAtcC0i6K4JfNOalabeQbuyDc/FGfLQ1tXfqpg250jOduhuTBFqMMoiJ+DDC
	emv0Ujf6d2jm9KlZwD3PPoXBr2a7XlJSlKQ==
X-Received: by 2002:a17:906:9f92:b0:c49:a408:f682 with SMTP id a640c23a62f3a-c4d34d3251amr118033766b.42.1793938299908;
        Thu, 05 Nov 2026 20:11:39 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d356a4690sm41228866b.61.2026.11.05.20.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 20:11:39 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.6 3/3] ovl: do not copy up a dentry that was removed
Date: Fri,  6 Nov 2026 05:11:28 +0100
Message-ID: <20261106041128.3797453-9-amir73il@gmail.com>
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
@@ -759,7 +759,14 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
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

