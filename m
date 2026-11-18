Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794987068;
	b=jGG2DzxDFxHlXmbdCVCIvFhiEP8I5iQPpM1ZIv82iC8yAxN6zFQ5T9fLjx+SQCsKwuik
	 wLDs4a94Wh9XCFEYTvVuAk4XBcpqnY81umJD3EG+ubXzkqd2LcV5OhX7fTI35LXJc6EeT
	 17Peqn0s7B6j1fMgQgTQCajEBSlX2f423+I2N1KvpQpH5ZIigyPKCJwFDgPSaGB4Xl2J0
	 BwCGpUsckJICzEfpF1FI/BlDWp0vnJVCfudPF/keAV/MCpt2CZdZvvvL/UqwDDKNfd5aE
	 vauuNmsRdDiDq9Nttrv3erFNptXlqvfufe3iqWF7XVFU31MgnQVn4QjGq6+qwm54KGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794987068;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HnO59Gsxop8C8ANboyy/O6qVew13Ea/m2m09fv+8pYo=;
	b=xs+vGoqTKMMytSOUM5VmvSNDP5PLrj0a5V/8YZSP1zwihH1v8nJCbBTHj9cTq/ABtGbS
	 oB3JxyNVmTxTUXyiYYqrdkGAlBf3Ho/2rPeGvj3syyHCRb3c4pewvWULrJ8P6IounhxFZ
	 +8JUX64cSC/OkfnPCVjlIv7NvjFzA/ektgZBxPJHXflqAvvpMCzoZTjcjFZedm2msSNAq
	 R5/UFBVKeG54VoLBMbm55U84LhXENYva5lNTq6oGSfRKtVMW0aqwoIPPGDNrVi7ScLqX8
	 IUjA9RgYKkQDSWquPhJvOnO2zTMyK4fcvgYqVrPd3N91gT96d0iIVUPLh5WoUPUgaNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CLV2x8Ib;
	arc=none smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0779606A338
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 07:31:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0779606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CLV2x8Ib
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c4d427836e9so73542166b.1
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Nov 2026 23:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794987066; x=1795591866; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HnO59Gsxop8C8ANboyy/O6qVew13Ea/m2m09fv+8pYo=;
        b=CLV2x8IbPmBUTIocL0+5nFl06i0tAsAhY4mHmyMQ21lo0OCNrgLfhNw6cUbCTaG+OL
         DveUySaQc7xrrZTx1lqELbvf1/+FsbspOHcsmvv1YJM7LDsrDieg7s/i7qg3QpqbF9k6
         VT5YAx0GrXoSmp08ON5j/ur14vliPFtwMDcNPFoRYjptneXn+9NAbUGhYVTQ/Tfkc01Y
         WAkREPXwknI3cAJeWRiszGkrMsotoGf+b3s3ESjBfKyn2KRT3SddWAb0A4wK8XKL5Lmt
         aN7Q4oyGRzHkZQow5ibn71zNhpAXopA0VhtHq6OW3cTDObsurbxOKJ/CqzdJerrV1E5O
         rWcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794987066; x=1795591866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HnO59Gsxop8C8ANboyy/O6qVew13Ea/m2m09fv+8pYo=;
        b=fFdxjvbgX05ANxnI14aoafb+XGri3Mp/QcLYF+/T0nIKCpatntJLSwayZrur9HxyfV
         A/FI4Lw02xm20Z1zLfd5tfTWFXg3v/Hgf6eRaUzk80voGBFuXmync3cL2LyZPzExdHSG
         l7RC7lXybVa7DOG0k0QMMncb+znSsn0C3yDkJ8hqWsf03kFvAy3Hc8AS5LOq73U2VR/U
         3sPctYcz8NxJkiYfSCLtm6Bd2pSX48e3xm6cKiVhHQJHs/sH9Y1ZdjiTv7XajOGeeACA
         0gXGTiRYL7kGY4jYj/nyNxgL7+DWX5FclVs1tvYMTv+Wxub2piG/fneX+we3A8PuNOo5
         N6vg==
X-Forwarded-Encrypted: i=1; AL+hErFobagUNlmWfqi0kbQ6Gdg9tsydZnM4f+i8b4ME7zRdTzOzxMFqP0YIboLyYfcjsmseETXpxpxcEfqhTc5G@vger.kernel.org
X-Gm-Message-State: APuU4Z8Ke8L8vUIcFNbQIhpQash1R3bUxxtLYNd98rfAoYTI/YKvUp50
	6f7w2uOKmgN80bbQvss4tOa4R25LE2ONyLmDskp3eFGzVbz7LC299YJa
X-Gm-Gg: AYBFou0kSax4LcqK8bDWp6k9w1bN1JD7G3bOJh89ITOCCrXNYvBUvg5QtKcHWByi7C4
	9+dj08UDHmgVzNvCYaTNtVL3QBClR9BhDdm8RQ7Xp3sIZxJhh31UR/QebhBwjViBhja/SltnZ5B
	L+Mj2yK+KZe3/PMw/Lv50fUP+gNgbWQA47XlP2dNf9KNg8FFDGAhR2G3170kCDuwkvUXT0Raw3X
	RV2GAS10j2zVNghWTS+bXcLEA6Ke2aSfaV4OcUiveV45FPmwHqjVzoPhoeJ3NpTV3sjmjt+zg0O
	Hl0ulVHLZPLMNl9/rd1V3fyHaip6J/MSDasTvzZMqcI8td7BOdOmJu3kWAc88xnPlGRr+GUhYM4
	IrT/Apd74O7oBg+in69ZMowHntZfTo+Lvh5uJ4sZ+fkPYujw0YgckKm8DRaLl0hrboJN+rWWPdD
	LkYo3HECoowxrl7nnntVa6rg9qqZVhmjEIwHU9NuNh+kV7iKepq0TTiC2ofGmEq0qqDiYka2WW5
	qOR+xYK5AE1aHKSI8sS0KJQ08bCM3yvLfAnUuQVnzhjJZ/XjpVnIF05Hj3mvR2BTbdyE3j0WmI0
	aDdy6p43sncNbfkN60nuyffr9XTxk/NLhGUBpjYU3GfgGbY8rHsE9RW4kvXSvW+1yoLMgUI9dtX
	Kh4No/6MnTTqVq5StOMrbBF/u2DnX29iTJw==
X-Received: by 2002:a17:907:d307:b0:c3e:f39b:2298 with SMTP id a640c23a62f3a-c510e19965bmr112773766b.16.1794987066137;
        Tue, 17 Nov 2026 23:31:06 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c510ca0f03csm66065166b.19.2026.11.17.23.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 23:31:05 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: [PATCH 3/6] ovl: refuse pseudo filesystem as upper layer
Date: Wed, 18 Nov 2026 08:30:59 +0100
Message-ID: <20261118073102.1216568-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261118073102.1216568-1-amir73il@gmail.com>
References: <20261118073102.1216568-1-amir73il@gmail.com>
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

Using pseudo filesystems as overlayfs layers is a questionable practice.
Copy up requires that the size of the lower file correctly represents
the expected data size, which is not always the case with pseudo
filesystems.

None of the pseudo filesystems can act as a functional upper layer.
Most of them fail to create the work dir and the overlayfs mount falls
back to read-only (e.g. sysfs, cgroup, debugfs). Others (bpffs, configfs,
tracefs) create the work dir, but fail the mount later on. So let's stop
pretending and explicitly deny pseudo fs as upper layer. Setups that
used to fall back to a read-only mount now fail to mount.

Link: https://lore.kernel.org/all/CAOQ4uxgPerkkG4ie0SyHVXaBD9VZN2wYfQpEAEi4hytn=ara3A@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/params.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 0c7bfff7f06dc..8da739b9fb883 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -347,7 +347,8 @@ static int ovl_mount_dir_check(struct fs_context *fc, const struct path *path,
 	 * as the mount attributes could change.
 	 */
 	if (upper) {
-		if (path->dentry->d_flags & DCACHE_OP_REAL)
+		if ((path->dentry->d_flags & DCACHE_OP_REAL) ||
+		    (path->dentry->d_sb->s_iflags & SB_I_PSEUDO))
 			return invalfc(fc, "filesystem on %s not supported as upperdir", name);
 		if (__mnt_is_readonly(path->mnt))
 			return invalfc(fc, "filesystem on %s is read-only", name);
-- 
2.56.1

