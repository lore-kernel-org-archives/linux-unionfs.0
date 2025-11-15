Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0621A9FAC
	for <linux-unionfs@vger.kernel.org>; Sat, 15 Nov 2025 13:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763214112; cv=none; b=XsTM0loZqblDK3gGQf945NG12D2ymjNo8HvoGeXW9u58XCEeexuqNbHacDPS2vWQcP6tYSH+dJAAfnwyr7lIu0hVAmt8OYi+VArx89h4aI+WRgfvXe8PridQKUcnvtlc5but6zop9X5ixsEc4L1d4RIL5Kvn+g0vr5TDHL3mFBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763214112; c=relaxed/simple;
	bh=2g+Ig9rajCSJQdPS5HN+sWyz1uVJcolY62QNF/qsOF8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=NQ3l/9augfLxVV5meARJHL8AdGhi0dwIEK2xqgnCmhrthJIRm5/BqfdI1Ws80rfDUb98v8koD4ac2UxAPHAb8m6ZboXDUwSiFQfSRcMdX1RSTmdVOmSxduyBMQ6qjXbvkJHkhb8JWY9Y5fWy856M+gxBtOcnx4VlZujB6hAsTfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vrwmjsv3; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vrwmjsv3"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-297dc3e299bso29180025ad.1
        for <linux-unionfs@vger.kernel.org>; Sat, 15 Nov 2025 05:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763214110; x=1763818910; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vCuOKcivklTw1LxrDCwl7m8QKs9eVupotLkb+wFRGfA=;
        b=Vrwmjsv3rxUATFJavLauucU+gryqAIgaNZ9GcADd9B6qD+D1iwLTO6lqplQb4KSpYI
         u4nei6BMji4vPoCKfABrj6R4UfA7lAP5UYSeNwqx19qCUTaxC3fA3LNn7NwA3j0W0RXc
         c0mchsdmJP77uiUn1NP5Pb2DvH3F+5cb3XUpWoxVB828WBVfj6bRrekHY6oCtWWCC+do
         qqzU0vis5pC0j8DUOCJF1CxWx+USZJXCY/UNmFYMcE1VJWrkNIabynC9OVUbpFpa9ns3
         lKnrtGHg3k8IzfiL9SxYHaYlGJPykKlscx2Hf3gIjPRrXMqaRVyP+xJCXmJhb1iDUfup
         YFlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763214110; x=1763818910;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vCuOKcivklTw1LxrDCwl7m8QKs9eVupotLkb+wFRGfA=;
        b=MXSJZSGRE0ItbvRtrMgs64Ki4Sk612f3KFlQUXF+Oc9E8+MVC8/MyS98CTttsy/nlN
         I0/UZTiro6dGvMme9wwdcKHUF/IzWWS8aIGHyVgr9vov3G7Em8n1RH9h7Vc5ZMG3k9YW
         YPmT4pWEDbuc91bR0fdUbFvvDTKMOrSCZQeuvTZQH9EvIFkLmnXXMjDTdrjrkKOiBHOS
         xbbGbFazTL+8DWHzaAzIaFx2jL1Zm9slgH14xks41KjpjQU2JdgMnDx9b5oHNTKtZpZm
         18xfysDSEECjh258oVf+RjptE7KzoGwlGpPgWzv1UbC4d51cgYn/UIb5GSYCC5YcQ+j8
         CDKw==
X-Gm-Message-State: AOJu0YyAoSsIzLNNV2QY/c2RcjxKzeAqd8evYGS0j97a1HQnOhvkilgo
	+Tq5+tJCCSGqPVRfFBP+W2+BO6hgnw1k98b47iZVXee79ai0itrGMQnvy51gRg==
X-Gm-Gg: ASbGncvoI1M2QW0+ACxzPZ7oP7fI8zx4RlY7DxzN7qigL3sqF1aAAWX1UXWQsZ4kL38
	P2DqT9p7YyQ6Usms5qN6ln0ZBJrHkHKqk8GgRsFnjxasikYNEjDtuOlCdA5u2Usbei36mUoDOmM
	6eaQBExXTwu+SCtW1N+SpUJqp1I5HRVs+gxeou5PBPUR/XjYbQrO1wyctBiHs8mcBKXKCbg+ffU
	io0x5nfuvUmd2lWKjvI6/BNyQDCOltWCDzqzE8r3unZGkiFiH6MwbwFoQNzxiEdtDsXrqrtXl9Q
	M04qQHV+Coa12p6O5WckwYaEhnrBAKTxLudLUB1dJZrAUUGeDI4KoL8EEwvoCMHg0PQybmA/sCE
	RSu/CvFiuv4XC76OYJpKf2kyFYKMs2kdTdvMlgU1lc1uNPNYOyxgIbrc/0UlJvH5PaHMD/3fTuQ
	==
X-Google-Smtp-Source: AGHT+IF54Re3ExzoazVcf8AZ8foNwyuzuy1McXXtSzG3Eaxo/eWEkrctnQvsUBeuHFdTTfqmxM62sg==
X-Received: by 2002:a17:903:3586:b0:288:5d07:8a8f with SMTP id d9443c01a7336-2986a6d7a64mr69752785ad.24.1763214110435;
        Sat, 15 Nov 2025 05:41:50 -0800 (PST)
Received: from aheev.home ([106.215.173.137])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bc36e8a58cfsm7410316a12.10.2025.11.15.05.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 05:41:49 -0800 (PST)
From: Ally Heev <allyheev@gmail.com>
Date: Sat, 15 Nov 2025 19:11:27 +0530
Subject: [PATCH v2] overlayfs: fix uninitialized pointers with free
 attribute
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251115-aheev-uninitialized-free-attr-overlayfs-v2-1-815a48767340@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAaDGGkC/5XNQQ7CIBCF4as0rB1TENC68h6mC2yn7SQtGEBib
 bi72Bu4/N/ifRsL6AkDu1Yb85gokLMlxKFi3WTsiEB9aSZqoTivFZgJMcHLkqVIZqYP9jB4RDA
 xenAJ/WzWIYC+nE+NllI0WLPy9vQ40HuX7m3piUJ0ft3hxH/r/0biwEEblFpIrVT/uI2LofnYu
 YW1Oecv1O//SN4AAAA=
X-Change-ID: 20251105-aheev-uninitialized-free-attr-overlayfs-6873964429e0
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Dan Carpenter <dan.carpenter@linaro.org>, Ally Heev <allyheev@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1625; i=allyheev@gmail.com;
 h=from:subject:message-id; bh=2g+Ig9rajCSJQdPS5HN+sWyz1uVJcolY62QNF/qsOF8=;
 b=owGbwMvMwCU2zXbRFfvr1TKMp9WSGDIlmnlW5N+xmXHh+X1rZpXV3gvr3j4qF7h3++fHJ2rMX
 /bmTpt3qKOUhUGMi0FWTJGFUVTKT2+T1IS4w0nfYOawMoEMYeDiFICJ/I5g+MP76c3TPYszdG9E
 Vb3v/VesmcP6xWjVlriPc+YHp1+KereOkWFfuM22H9MiD3g5/353cbY88471n07n5Jzzr8j4ZS0
 WM4MDAA==
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
Changes in v2:
- moved the variable initialization to the top
- Link to v1: https://lore.kernel.org/r/20251105-aheev-uninitialized-free-attr-overlayfs-v1-1-6ae4624655db@gmail.com
---
 fs/overlayfs/params.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 63b7346c5ee1c127a9c33b12c3704aa035ff88cf..37086f73ac3ecfcd1c09ae6eccbb69723006e031 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -448,7 +448,7 @@ static int ovl_parse_layer(struct fs_context *fc, struct fs_parameter *param,
 		err = ovl_do_parse_layer(fc, param->string, &layer_path, layer);
 		break;
 	case fs_value_is_file: {
-		char *buf __free(kfree);
+		char *buf __free(kfree) = NULL;
 		char *layer_name;
 
 		buf = kmalloc(PATH_MAX, GFP_KERNEL_ACCOUNT);

---
base-commit: c9cfc122f03711a5124b4aafab3211cf4d35a2ac
change-id: 20251105-aheev-uninitialized-free-attr-overlayfs-6873964429e0

Best regards,
-- 
Ally Heev <allyheev@gmail.com>

