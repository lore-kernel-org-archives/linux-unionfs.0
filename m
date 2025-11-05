Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBC8156C40
	for <linux-unionfs@vger.kernel.org>; Wed,  5 Nov 2025 14:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762353233; cv=none; b=R+VxnXHUF1kSTyqlpdl4+9q7SZ0c80CB61V41flBhfDMKLavRfRNI/GJkv/Mi5yGJqr4mrrzeXqwgCXgSS5c6TrjAl5+pA73pVESC9bWv5zDl+byI9seZfCAkRz/XaS6wQiQ14DUSa9yS3kKE+29h1hhYRU11kMlqUac9t61fK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762353233; c=relaxed/simple;
	bh=vg/RXprrlsVjtXM2tQTWZW5NZf2Zc1PI2BcwO3b4knc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=D3k1jwk+Va5GKQ3ARarBi9VvWJ+HtRtRiVlLQYdCvqTnLQptq1176N7y5HgRWoEnyVczae2dnDosDNfd+f6tWRwbQVwQCbJEJQziblbJenylNt0Qtxg3otEjz1PihAW+Iokpv+x5BY24lhdVA0w9tJq3310pcUWXR48PTxaILOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gGOwQrcM; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gGOwQrcM"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-33b9dc8d517so6074101a91.0
        for <linux-unionfs@vger.kernel.org>; Wed, 05 Nov 2025 06:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762353231; x=1762958031; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vpdMK/DRKVWAvOOWNiPRhZVNRMFfL3v2YgNMmVkwG6w=;
        b=gGOwQrcMlodBbKVVOiUBinmksNozEiX0dcbzLhJ6uSG87tTZnIMj4BnmEKMB7UBEdU
         VSTLj/BqJKuK34oeXzfw27+HAjeNlQXcpPxNHzru6AquGh1m+U+WWvtV0AbQhkiEMdZj
         4grP+Z/LdiRwUEESDOyYmmKNHLZMYBr08Zip3Qa0XNyiT7JNXtxJ+33ISpoI2AOiGtNd
         I7VYkj/iichxosgAvkOXMdENvSg3ggSHO9tMcBBoYDr0tLRU1D4OnkT/CpI4MOkzIjOS
         MRv9Rl5ni2iab9xQcAX+Afxs7zuDhCkZ7TO/xPYLLwKjyOsF3ccFysduXX98+YYATUxq
         wExQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762353231; x=1762958031;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vpdMK/DRKVWAvOOWNiPRhZVNRMFfL3v2YgNMmVkwG6w=;
        b=DKPM/B9XxBusVaSn2JicQg5PZ2RbdlDnDX2cavkk7hPdMSiMjfDjhufhgHWxyb3kAS
         05G6FqhxZirLTtufuZHwzcs5TH/MYAg9BS61CtLmVG03v6H3r8uuPAAiM0oZsFkklLmu
         YsfhXsN9KuKa1XfO3lWfw+c8F1pvI2rTnQ650rFONMS8Gjl54mxgoDXTeHJDyUQyBU3t
         Xkj37PLzDP7Vz0jhBkL2oKOJnBIrI1Udewbb5WtidhA4PSBZggmwpByYn0b+ACaVnq+q
         ca1dHurHB8EkwTLqMGB2oh3DcMtC4mNyjay39Zg/djoS5CWJS+UvlvfntbqjFYzfI5WS
         yrNA==
X-Gm-Message-State: AOJu0YzUGDF2YmIwMEGKqrsCCFHiHeoIncHz/YIXeDp6lRCWvwXaQDsp
	PEIWuUvPZNjmOnFj7tGCx6HlJcVVT4yJepO4Yt1Ggg+oL0gLHFqQlcra
X-Gm-Gg: ASbGncusvCSO1Tp1vVvY4xxy6TtWz3IG060GWr27NfjR22oBO6jDKkmHCLp5FjGF1fG
	vu17O7DvfsTiQpeZhvcr1NjP0lWGtn7899AUP5dDQDLxaR3tEg45HgP+NPcBL0vEZ+TMLCJ93bP
	55JH/eqdI7NqHFHxca+hu7La8TS4YiHsk2YXAXZwQqDAgFcvxRkPF+8GHw6XPV7APQYIWfusOFL
	rqch9Y/s9ASnt0YgLhqzd2VmzwHYhIIe8WL59YL3HOIN1ivrZaFZRDy3dSl2a6rUbp+sayboejZ
	ldgQ9tYvu9JqFXFbzSS3z+kUmaDAnjBHcOWuvNZdBeDh7NqUZeYACXpM+ggbtLbHfyBVDD2mlAR
	YHI1mdtrUeROpDlgpLmm7vm4M4ndKYNkXlo4EKf0Rg5absPv2SDKNivE44sktEHm3bh9mnxa125
	8=
X-Google-Smtp-Source: AGHT+IFhgXKJ4vhkJNxXbe74Kq1mJjWs4yqe0dw+xDqXwgk8gyjw+XNt0LDe6GfLNBlv2sqKPJa/Lg==
X-Received: by 2002:a17:90b:55c3:b0:340:b152:efe7 with SMTP id 98e67ed59e1d1-341a6c4d3b5mr4552306a91.11.1762353231054;
        Wed, 05 Nov 2025 06:33:51 -0800 (PST)
Received: from aheev.home ([2401:4900:88f4:f6c4:1d39:8dd:58db:2cee])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-341a696d978sm3132190a91.11.2025.11.05.06.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 06:33:50 -0800 (PST)
From: Ally Heev <allyheev@gmail.com>
Date: Wed, 05 Nov 2025 20:03:44 +0530
Subject: [PATCH] overlayfs: fix uninitialized pointers with free attr
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251105-aheev-uninitialized-free-attr-overlayfs-v1-1-6ae4624655db@gmail.com>
X-B4-Tracking: v=1; b=H4sIAEdgC2kC/x3NywrCMBBG4Vcps3YgSS9aX0VcBPvHDpRUJjFYS
 9/d4PLbnLNTggoSXZudFEWSrLHCnhp6zD4+wTJVkzOut9b07Geg8DtKlCx+kS8mDgqwz1l5LdD
 FbyHxcDm349B1boShWnspgnz+p9v9OH4fFA/BeQAAAA==
X-Change-ID: 20251105-aheev-uninitialized-free-attr-overlayfs-6873964429e0
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Dan Carpenter <dan.carpenter@linaro.org>, Ally Heev <allyheev@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1461; i=allyheev@gmail.com;
 h=from:subject:message-id; bh=vg/RXprrlsVjtXM2tQTWZW5NZf2Zc1PI2BcwO3b4knc=;
 b=owGbwMvMwCU2zXbRFfvr1TKMp9WSGDK5E7x/mmaYJghHbb161vBg2pXXuVO+iX5v/hVhFlOyi
 W3TjUd3OkpZGMS4GGTFFFkYRaX89DZJTYg7nPQNZg4rE8gQBi5OAZiIHD8jwxMjm3+J234vm5rD
 b3vynJmj9XmVBYeXJwUvc107f/1bjnWMDFPLfO/uupf24b/z0+LKuFsS7af+VDFrV6oxuM7lb5n
 qww0A
X-Developer-Key: i=allyheev@gmail.com; a=openpgp;
 fpr=01151A4E2EB21A905EC362F6963DA2D43FD77B1C

Uninitialized pointers with `__free` attribute can cause undefined
behaviour as the memory assigned(randomly) to the pointer is freed
automatically when the pointer goes out of scope

overlayfs doesn't have any bugs related to this as of now, but
it is better to initialize and assign pointers with `__free` attr
in one statement to ensure proper scope-based cleanup

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/aPiG_F5EBQUjZqsl@stanley.mountain/
Signed-off-by: Ally Heev <allyheev@gmail.com>
---
 fs/overlayfs/params.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 63b7346c5ee1c127a9c33b12c3704aa035ff88cf..56d5906e1e41ae6581911cbd269d0fb085db4516 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -448,10 +448,9 @@ static int ovl_parse_layer(struct fs_context *fc, struct fs_parameter *param,
 		err = ovl_do_parse_layer(fc, param->string, &layer_path, layer);
 		break;
 	case fs_value_is_file: {
-		char *buf __free(kfree);
 		char *layer_name;
+		char *buf __free(kfree) = kmalloc(PATH_MAX, GFP_KERNEL_ACCOUNT);
 
-		buf = kmalloc(PATH_MAX, GFP_KERNEL_ACCOUNT);
 		if (!buf)
 			return -ENOMEM;
 

---
base-commit: c9cfc122f03711a5124b4aafab3211cf4d35a2ac
change-id: 20251105-aheev-uninitialized-free-attr-overlayfs-6873964429e0

Best regards,
-- 
Ally Heev <allyheev@gmail.com>

