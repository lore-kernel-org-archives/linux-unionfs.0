Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48060337BB2
	for <linux-unionfs@vger.kernel.org>; Fri, 21 Nov 2025 07:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763711478; cv=none; b=XLaqd+2GIXJaPnod9YHxWCvjDt328uEpvps6biDgdx1soKIxTmVSfrGuMpOr/stAJkjR9kk27ANX1kzZRR7+imuLmNrXY2m8iQy+FXITTJdzjfX+jNPyVLevJ+btd8Fp+ZfNxtJllcr1vB8STQM8PjRCKhBBewa88qTJt8L70Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763711478; c=relaxed/simple;
	bh=6qqxc++n3lp/1MZ+C0N/Kqmwt3XjytAp9kJbaEylyJI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=IejGdoojtjICc8O77nLUAVVcQe2wBFRYvnsokekMW5uMcmNsEUmnjtTvySBAkBXxsM9iql/CjvrqHorRmGBGwYXPQfv0jIYq+CkbCBYrgQlkLpN4vRRU/YBl1fjEh0pV8nWoW8WYBJP9cRFIXdv3NhgaiyZ3SoFZDojeJvr2e68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OUNF9Q6b; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OUNF9Q6b"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7baf61be569so2030180b3a.3
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Nov 2025 23:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763711476; x=1764316276; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EsWBmfvjtR5jVNwVNQDY7scvrS6suu+rDwbNJN5shsk=;
        b=OUNF9Q6bahU/q7xLMm+3LO3QZr3HZhvAQiI37K5clSPn2DsojBMku0wcFBW8q1ETpT
         Q0Z5eMxM1cIsVsUcdaNeUEWnSIigEp3PJ1NBuVarnM5HVahqsd+gIoSKMkD16ZPVwm/c
         /xT/4Uqm4LkgH/E1Hr2+texxpD3Cmr9jwTY68p+vozaYpARVidi5dnOJzkUz3OGGSyoC
         3eipP1WHUCoR4a8pwFuCiQLpiDLeTJ8h+oeRDZT2LCCpIsvx2i/l5XtFUSgUF+v/d7zg
         aYGXZXi1XC/8q59PXqVtF5gC7veSZJwyebNpWZaMxL7uvoyMQn4WB4IYJQ/w5pIM/aQ3
         apGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763711476; x=1764316276;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EsWBmfvjtR5jVNwVNQDY7scvrS6suu+rDwbNJN5shsk=;
        b=kMjSDU0NSZfhydubEsDIqH3aGsUY2udiDTuX6yR+KdFJ2emM4H439jcEkCzbhXtkEC
         0anVPdvzuVuOoxy2UmR38X1B/GRJzZ6A9Hyz1It4YK63QkDDuepvKC9f/6aC3gevXGAo
         nrJajshjHYtMdGFJSouW4AaS2azJQIHZWrqLVrmCoMOh9dDQMXOodN+Q8KUqIy+IUV6o
         nLOkfnmnly6/4B5JotnYRmb7EhjKdLsyojOmByOLFc7nZjEjUVeLfDJ5Z1uoh1zy9au6
         XN6TOkWXRkP3mYrJ1vr+cZgw5Oeyqb4pifYTqsXjn99jGJHacVbgJ6KAePm/fP6Ts1W2
         WHQA==
X-Gm-Message-State: AOJu0YyYSeuxo0Fxz4nl4ZSs08bHbyMgI3AkI6nMTK5232auTsvvyK4K
	yFJqvRF/x3AZGs+37flIYfuwIW5KKbt21dIH/lYz42fdr0nkC2h6E5ik
X-Gm-Gg: ASbGncuYflo8VD2LHH4NSdWtwl+so/xBGiH1tMbVRqmYn6GjGrNnx/3ZzBxAqWavCtl
	SGOsvYyXzmjkr17dQGIcvVDYpdRjm5CiRD05wemGUGH4oGv21oeDLotGEEViaaLTkxi0R6VY4Tn
	zHStWb5zRljepZ3RcyVrdwoHiYIrOAI6BRl6UUq4wj7NGaKoa4vmP10/AGtVNqtE0T5nF0WWegL
	5mp+tzB8epZ8GM46rJUYY4JIcD/DyU1Ju7CVRedhKFjKBVRc8piiu/tu9KGAhmVulmvRBsqBNLC
	TxmS7psZQBJ9gAMhJffLr+mO/3VQ/5Mh9XnZqMGpKmO27PaC2vm+15/MWoFMMF0ye+6d9hAJ5XH
	vug+YBREFnin/j81HeZkhkPJ04t4qIBr8X6MQM8f6H0HMhiovSBygxJu4XsMymYTHSNauXqywiE
	8s7onD2ZzCKg==
X-Google-Smtp-Source: AGHT+IG6DWPFSBEdVwXYgVRG9D8vLgq4phzaxO17rW01pLLh9q6GAIlUtdsLVIU+nFtLiHjmiIL5nA==
X-Received: by 2002:a05:6a20:3d86:b0:352:eede:89cd with SMTP id adf61e73a8af0-36150e71f54mr1454265637.17.1763711476494;
        Thu, 20 Nov 2025 23:51:16 -0800 (PST)
Received: from aheev.home ([2401:4900:8fcd:4575:1ad3:3d1a:3314:cdd0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3ecf7d849sm5075009b3a.14.2025.11.20.23.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 23:51:16 -0800 (PST)
From: Ally Heev <allyheev@gmail.com>
Date: Fri, 21 Nov 2025 13:21:09 +0530
Subject: [PATCH v3] overlayfs: fix uninitialized pointers with free
 attribute
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251121-aheev-uninitialized-free-attr-overlayfs-v3-1-346f631a9c37@gmail.com>
X-B4-Tracking: v=1; b=H4sIAOwZIGkC/5XNsQ6CMBSF4Vchnb2GlraAk+9hHCpc4CZATYuNS
 Hh3CxMr4znD9y/MoyP07JYszGEgT3aMI7skrOrM2CJQHTcTqVCcpwpMhxjgM9JIE5meflhD4xD
 BTJMDG9D1Zm486CLPSi2lKDFlUXs7bOi7lx7PuDvyk3XzHg58e883AgcO2qDUQmql6te9HQz11
 8oObGsEcXD5CVdEt+DKyCLXeSbTo7uu6x9vr7ziNgEAAA==
X-Change-ID: 20251105-aheev-uninitialized-free-attr-overlayfs-6873964429e0
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Dan Carpenter <dan.carpenter@linaro.org>, Ally Heev <allyheev@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1859; i=allyheev@gmail.com;
 h=from:subject:message-id; bh=6qqxc++n3lp/1MZ+C0N/Kqmwt3XjytAp9kJbaEylyJI=;
 b=owGbwMvMwCU2zXbRFfvr1TKMp9WSGDIVJD/M+nSG/U+47WaxQmWB3Nnvqnm/6KjvdZ0Qbtrld
 n2JkrdORykLgxgXg6yYIgujqJSf3iapCXGHk77BzGFlAhnCwMUpABNRamL4Z+e38OvepJXliQk7
 Qv/Pf8PytOrewq3M28orEwIr7q+rUGb4K1ZvtV5gtbFjjcI17RaW7wtqV7k0mWtde7KlmXPt8Qm
 NvAA=
X-Developer-Key: i=allyheev@gmail.com; a=openpgp;
 fpr=01151A4E2EB21A905EC362F6963DA2D43FD77B1C

Uninitialized pointers with `__free` attribute can cause undefined
behavior as the memory assigned randomly to the pointer is freed
automatically when the pointer goes out of scope.

overlayfs doesn't have any bugs related to this as of now, but
it is better to initialize and assign pointers with `__free` attribute
in one statement to ensure proper scope-based cleanup

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/aPiG_F5EBQUjZqsl@stanley.mountain/
Acked-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Ally Heev <allyheev@gmail.com>
---
Changes in v3:
- reverted to v1
- Link to v2: https://lore.kernel.org/r/20251115-aheev-uninitialized-free-attr-overlayfs-v2-1-815a48767340@gmail.com

Changes in v2:
- moved the variable initialization to the top
- Link to v1: https://lore.kernel.org/r/20251105-aheev-uninitialized-free-attr-overlayfs-v1-1-6ae4624655db@gmail.com
---
 fs/overlayfs/params.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 63b7346c5ee1c127a9c33b12c3704aa035ff88cf..59445b53b5b88893ef7923128da99cd1934bdc6c 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -448,10 +448,10 @@ static int ovl_parse_layer(struct fs_context *fc, struct fs_parameter *param,
 		err = ovl_do_parse_layer(fc, param->string, &layer_path, layer);
 		break;
 	case fs_value_is_file: {
-		char *buf __free(kfree);
 		char *layer_name;
 
-		buf = kmalloc(PATH_MAX, GFP_KERNEL_ACCOUNT);
+		char *buf __free(kfree) = kmalloc(PATH_MAX, GFP_KERNEL_ACCOUNT);
+
 		if (!buf)
 			return -ENOMEM;
 

---
base-commit: c9cfc122f03711a5124b4aafab3211cf4d35a2ac
change-id: 20251105-aheev-uninitialized-free-attr-overlayfs-6873964429e0

Best regards,
-- 
Ally Heev <allyheev@gmail.com>

