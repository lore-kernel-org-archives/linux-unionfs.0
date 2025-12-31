Received: from mail-ot1-f97.google.com (mail-ot1-f97.google.com [209.85.210.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65CB30FF2B
	for <linux-unionfs@vger.kernel.org>; Wed, 31 Dec 2025 10:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767176934; cv=none; b=QakZxVnyxxUMTtKK+svxiO6FVfxQSTk7kt5GJwScciut8oNAHJm9rsVipeT/qnmWUsJVFDtTISwz/e8jT8l8m6OGdbJh5U7iCWU4zE2jXUBN4TEHrYxGv2gRJpF1Z4TbOfLg4OnYfYsCWAHUVNuWd5J51enW/DJOBmprXQQggTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767176934; c=relaxed/simple;
	bh=G/ZhUjmDDhcPrFgzKSf53vaiynE6E43XY/+UxifF9h0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VYkjxXi7EXWIG1RN6KmB5lttIKI6HKhVcEV4H/IK+WkeSMjzsGFFkOaKSAFb1LtyMD8KlH4VyH8pzDvMDfLwKGM89ndYBJvActij9kl7QhQpOTbGCFvFPGcOna1qEk0bsMRo2+B3Wy8BbtW7WOhUAHci+94eI+EZ4BGrFP4BsnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=CG6E3ytb; arc=none smtp.client-ip=209.85.210.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="CG6E3ytb"
Received: by mail-ot1-f97.google.com with SMTP id 46e09a7af769-7cdd651c884so3576954a34.1
        for <linux-unionfs@vger.kernel.org>; Wed, 31 Dec 2025 02:28:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767176932; x=1767781732;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=17YsCloS89Rp+LrUIY8Ph1LvawoB0k2+NF16uLKUGNs=;
        b=xRy6V92X++6MyoCjqUxH8NAtzoUnCUWMCnnOJH5EBT08N20yn59ncWlQ3b97yaxCAn
         cH0pR8kEVeXTlHbZ0IRW9WJyulJ5lFRN1u7QnsIK4K0PfRU5X1zxXisZkBsF4vCQRdmY
         31NVYSMdwfO4xhgLjbtjYFvyUlb8qQVpzq0Ojb7Tq+ik/OXmWoepjD03LRbTj8zb66Kk
         BNgyscsjeFqpao/RP3OR1A8kDHFscOCX+iB+P6VgNwuR4Gbnf3iMLaCDhGlYhzgOqdLS
         3CW3vp4W6a20GTCxFFK8d1QrD89ITQU8W5lhz3g66I3uiFJ06XX1bLKNCM8/EkwNlv84
         SlZg==
X-Forwarded-Encrypted: i=1; AJvYcCVojP/L8mKgTxSG1GTT4mK5MiOyN9wlhqLMQvzMonyi4vh3GiRjmhEtBtY+cE7C6mXfKPc4QI9gnjYiM7HP@vger.kernel.org
X-Gm-Message-State: AOJu0YzU6qXccFuwo1U/1Imz4Kl9oGC/U/tMSQiWyKEvRAKpywFmwbaU
	uYR4xtgVgfSavJC+yHddvj+sjdn1SehZ/32e+thgL70vk2HWSYb3kVmJ0yuwIbH5P7Qmmnd/ymV
	9SBdGgz4FlsOERBPLlAvoqUb+2f8hcKL2c8vVj5tszlQPf3vUepZW1yFwU5nhAVdLYPtGN2LEoL
	WbUbtStmNyn1f4JUOb+N2fdVue2hiymLn6Sw2WufFRCRdBELxVU/1C35n1rsscXrP+YR9+Cmcv3
	QptCQBV4Pex+7Bn5rTI8fFlRrs=
X-Gm-Gg: AY/fxX4w6Z8TY/20PfJrxmEQOgOZ3tXY13ZWI6E/Ra0i8dXua4Wh6BYm6s+YhDsCF6j
	T1CEYnMCjAp5n4L3AsZ0s3+XfWKxr1RI8IoTzI9xVh6njoNFEvd7Kx7quTlUB1jFUS7CLAselDP
	+aa70alWvKezbEo7lzxJzW6noj5beaWzl9p5QMP57YHrzQ1nD+Mp6UtPdzOkGuN8EFdjnjbYiWl
	z6IvfYqI6iLMPeKBLIhAQ76Ywxb+/O0HfUA+wBBaOyvqrvE2hZdZzo5iCKVSINdixsNRM+XNhvk
	/Ryul+UFipVUGxLoazsisJzGMS3pJ9KKkl+ideuDv139UJUwdSNAsNnCzH4jFuuWYnbKUEsX4Wj
	FaZlwEpZSh9MynZfI0OPjtuKiEh0hP8fyfIOca58YwVtOaeUHeD6y0BOBCKbjumX8scxei0MSKl
	c71F7MlZHb9F+J5gEp575bKnvISElhgbTPGV0QWA/omEtkT2kJiWU=
X-Google-Smtp-Source: AGHT+IGbnLh3sAagzVJDpiJk90r1bh6elrIhlqkDTNBvOReKYHTJ29LzaGJ7b9RQ7LYGc/ypl+DnGx0jPlgQ
X-Received: by 2002:a05:6830:314c:b0:7c7:6a56:cfb5 with SMTP id 46e09a7af769-7cc65e3a826mr20375905a34.11.1767176931741;
        Wed, 31 Dec 2025 02:28:51 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-101.dlp.protect.broadcom.com. [144.49.247.101])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-7cc667d771esm4434723a34.6.2025.12.31.02.28.51
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Dec 2025 02:28:51 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-11ddcc9f85eso20261388c88.0
        for <linux-unionfs@vger.kernel.org>; Wed, 31 Dec 2025 02:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1767176930; x=1767781730; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=17YsCloS89Rp+LrUIY8Ph1LvawoB0k2+NF16uLKUGNs=;
        b=CG6E3ytb7GTrRoLviwY+HQ4chjiidzeAQ/A/eazj1P2ntX/baFhTroNumoHT81k7lQ
         LBHGERPlAWcBGsw5e1ppHTF6u3XkMza6W08Hhi+K5JXaQUSDx/ALZPKWpo3DyveFpLSu
         97+toV7FOESq9McllKVLVLyerc4FfBOTcg3tU=
X-Forwarded-Encrypted: i=1; AJvYcCWk2rpoZQT+9+xl2n5x3kQm3XK88OXOz9NMCaRlvhy+Ua20GEqgCZRJJa37lv/pm8iAXifJd9i2i6Q1728J@vger.kernel.org
X-Received: by 2002:a05:7022:688:b0:119:e569:f86c with SMTP id a92af1059eb24-12171a75857mr35097121c88.9.1767176929713;
        Wed, 31 Dec 2025 02:28:49 -0800 (PST)
X-Received: by 2002:a05:7022:688:b0:119:e569:f86c with SMTP id a92af1059eb24-12171a75857mr35097111c88.9.1767176929152;
        Wed, 31 Dec 2025 02:28:49 -0800 (PST)
Received: from shivania.lvn.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121725548b5sm138692126c88.17.2025.12.31.02.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Dec 2025 02:28:48 -0800 (PST)
From: Shivani Agarwal <shivani.agarwal@broadcom.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: miklos@szeredi.hu,
	amir73il@gmail.com,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vamsi-krishna.brahmajosyula@broadcom.com,
	yin.ding@broadcom.com,
	tapas.kundu@broadcom.com,
	Kees Cook <keescook@chromium.org>,
	syzbot+9d14351a171d0d1c7955@syzkaller.appspotmail.com,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH v5.10] ovl: Use "buf" flexible array for memcpy() destination
Date: Wed, 31 Dec 2025 02:08:09 -0800
Message-Id: <20251231100809.642262-1-shivani.agarwal@broadcom.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: Kees Cook <keescook@chromium.org>

commit cf8aa9bf97cadf85745506c6a3e244b22c268d63 upstream.

The "buf" flexible array needs to be the memcpy() destination to avoid
false positive run-time warning from the recent FORTIFY_SOURCE
hardening:

  memcpy: detected field-spanning write (size 93) of single field "&fh->fb"
  at fs/overlayfs/export.c:799 (size 21)

Reported-by: syzbot+9d14351a171d0d1c7955@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/000000000000763a6c05e95a5985@google.com/
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Shivani: Modified to apply on 5.10.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
---
 fs/overlayfs/export.c    | 2 +-
 fs/overlayfs/overlayfs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index f98128317..dd3e1969e 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -788,7 +788,7 @@ static struct ovl_fh *ovl_fid_to_fh(struct fid *fid, int buflen, int fh_type)
 		return ERR_PTR(-ENOMEM);
 
 	/* Copy unaligned inner fh into aligned buffer */
-	memcpy(&fh->fb, fid, buflen - OVL_FH_WIRE_OFFSET);
+	memcpy(fh->buf, fid, buflen - OVL_FH_WIRE_OFFSET);
 	return fh;
 }
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 87b7a4a74..5ac968f70 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -104,7 +104,7 @@ struct ovl_fh {
 	u8 padding[3];	/* make sure fb.fid is 32bit aligned */
 	union {
 		struct ovl_fb fb;
-		u8 buf[0];
+		DECLARE_FLEX_ARRAY(u8, buf);
 	};
 } __packed;
 
-- 
2.40.4

