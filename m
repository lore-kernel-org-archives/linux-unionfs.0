Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75633391E7C
	for <linux-unionfs@vger.kernel.org>; Mon,  7 Sep 2026 06:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788761768; cv=none; b=RQuqhRpIYA15RsZc9cKL4V/atPQttTMffMvOffFeUOCngbyJhfUuQoEiy6xwhNjyCHo/7HPlgjUsfRGXQ9+HsU/oS2hWm4dF52jHi7GsoYNxc+PyRwTwXOKWe+2Az8eU3F8cQdSh2JM3fmgirQUX1HtvORqm9IvB/8V+xMYrzOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788761768; c=relaxed/simple;
	bh=mtSmIqXyZYQO5QPo1KQvMrB8/LuZqhaYJLfOvCWymqs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NfR37AGVUWoN9kOHxHxoD8EetR1gcaCGufihciYTt+99ltDAPPlw9ePESVU3Ah5SYcPGhnRkgjYhHwDMVd1gNQ/4VZNqLsTXzo4KiJ6fLOvq2mEISfyHQ/L6I0Xah9ayxMu9R4xA56KB1u6u8e88taicRLzvFqIAWdFRTiqHTuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rp/PTAH2; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rp/PTAH2"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2d9db539a54so24662345ad.0
        for <linux-unionfs@vger.kernel.org>; Sun, 06 Sep 2026 23:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788761767; x=1789366567; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kdG2Bvmu5SnbThhcAJgYn2GjYKQOxh1FtKMeRXlphuc=;
        b=Rp/PTAH2TaWIvxd7BlxRMQ+vlgwj9+N2e3AGENnFr7Vj/9reGmSQH+ELV00EfFG0nC
         sz+rsdwA4ndctSKF/SAmwzEQGelxoc0v8dAkpvxt8gDvPhsYre/lpSuHAlT6F7V1i8xb
         gKU4tdh5BHFP5PXGOfBvoix8qve+V7SzM7PtrCghUrM1kKO2hRZLTr3OXp9DyZlH1ifp
         0DLVLxhhgciFyzvFxBMkFTTnICVxnt+VTYBUus1ta1eK5Acz5gQ9SzyzlyOHyWO8F3fU
         2XhQjCN2KsZunsglxX+nbJxvgyCT1/aGzmzO57fSlwCIKYohuSVph3n4F2Y3T6nzWFzy
         xrsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788761767; x=1789366567;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kdG2Bvmu5SnbThhcAJgYn2GjYKQOxh1FtKMeRXlphuc=;
        b=Xt5VK6PI8qCxohgwaFml877HOtAUdBehqBce5aOFXbmgOYQp4InWXbvVKM9DnghVPH
         7MA+iJ5dVwOx7WE/a+asGEPTNxHNe2wZ+7iJ8XNYpOI5Mzv5bfO80X/8e0YwZb07FrRc
         FDmYFqhH9aVRK+VQ7AjhQZgcWDzUO9yrwp9joPvyowxe8JcSx+v1tmcpocqa5aeWud73
         UuFiFYfGdZDC7mH0GSdW7+tBwbewoLrXD+HHIruBSyhbuS/jdMiIlE3ELdvhX0iVtILI
         9ec2+2mpiIbRYx5JwAQErd3SYkJpSb2D7C1QOoRcmY424CbfPQp70AjSD1tK0dIX4+71
         fbcQ==
X-Gm-Message-State: AFuF++lcKugz0ay/RZ/l0hQoiWTrucUjwsxknyHfnUiYMqBTlrlZY9n0
	wg0BvCAn4pws1o1X8ns4cjudN0tNcRgDbNKSisP+Kt5fDYeLW4cSr7le
X-Gm-Gg: AYBFou0Fz2GfuaBwTIBTwNwb4scFPTcMDA1LMLnhMSh6hGFPBfql+wtQ1mM7GMgFf0J
	cJ5Hi3M86r89mfUVaqXw54zfAEqh/aRoH+/fwC08Z1IgqdCmigWb3IO8KQJDsZ8uXryJ+igbHOW
	sJNjm9KmhJy/vJyexi99a7Fx0/AAgsGig6tehbouZlD4Snis2Jnn7YLMNti1gCa0zzrfPRdiZiy
	r8JnDAidczM7X2dMf350Sd6A8PDEqUzEgM56T+fGz6R0cjPC8wsr6U6Qn/OsAAJhSoInzCHIkOM
	8crl28ciZwVeuswejN9w+TdDA0bvcE8OschFCcoPAYsR3tvtK9MdGJw3UnImP+uu1XD/8H2Bn81
	HytBcN1Kwm1nD8IeNtNkTppGh88rmwfZexpOe7QfPMM7wMF8Wf6jQzQzCvfAkc8YtG403NVJ7Pe
	2fifdfCgEZ7hxETL9oLSQLXtsTgMmpLB4n0B74qsy7Xk0gPXppellqyLvG7jQos7YxBkHgCt0Eh
	ovV/naKPCEq0A==
X-Received: by 2002:a17:903:2acc:b0:2db:5f8c:b81c with SMTP id d9443c01a7336-2db5f8cca7emr33548785ad.19.1788761766586;
        Sun, 06 Sep 2026 23:16:06 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33688cfc714sm8104557eec.20.2026.09.06.23.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 23:16:06 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] overlayfs: fix repeated word 'the' in comment
Date: Mon,  7 Sep 2026 11:46:01 +0530
Message-ID: <20260907061601.36474-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drop the second 'the', reported by checkpatch.pl as a possible repeated
word.  Only touches a comment, no code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 fs/overlayfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e487597337e8..20ed85840648 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1520,7 +1520,7 @@ static int ovl_fill_super_creds(struct fs_context *fc, struct super_block *sb)
 	sb->s_iflags |= SB_I_SKIP_SYNC;
 	/*
 	 * Ensure that umask handling is done by the filesystems used
-	 * for the the upper layer instead of overlayfs as that would
+	 * for the upper layer instead of overlayfs as that would
 	 * lead to unexpected results.
 	 */
 	sb->s_iflags |= SB_I_NOUMASK;
-- 
2.48.1

