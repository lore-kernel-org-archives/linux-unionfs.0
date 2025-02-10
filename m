Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B3024C686
	for <linux-unionfs@vger.kernel.org>; Mon, 10 Feb 2025 19:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739216722; cv=none; b=DzfMiT5jEXrq7LDLdK+sloqyP4PDdvSUPPunzvkocSNAQ8DzT+f1CbDChQnnWQLepKvZ6VGmNX3L9X9LJFGVf/RG2IvMguPAdDNmICxHEJcCGSkKMexWvV4CtUoN1vIoHMSXpgu0iSFDpqzs4y9AChNB/t/gpE5jelPIBGpvQkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739216722; c=relaxed/simple;
	bh=6I3nvrty6mIsXbdzuMVgchvm2WTK3+v1V3YGpFXZSsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tuPr/yeeYnPD9ytou3jD0WHgIz/TiKf+EWBDFfG5X8FAoTq9/PrrkpHq2Lj7ma38h4+hfcs6yHxD439HXaQyiV6HlMBX8pMNm6JtQvSHMC2iuQGMeKNjoq3r1rinZtOSPQRmTpLpwbtaU30NeYRFKEr+x6iovGPl0fFm33dqN/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AnoQv4LO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AnoQv4LO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739216719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0OxMWC3XA5FgD49oXcSz1TwT0Kbb0QMAHeVEoh+RJ7k=;
	b=AnoQv4LOQ5cMWCZ8Ms9IfZN1uLhX++dM5GMM8eBJDVVP+ZVPfChyVBFQloWyOni7eIgAaa
	cUhfSZR5gWDmRU4W3Wrzx5qUOlxjpjeJRk7sn2aA+8ULig2BXu6cb/bU2XCPdzzPgXXSHz
	sGafhDVxQTlWxf1bgocrciFvjO/Qmeg=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623--5OCgvMzNZe6ZP2ZmcCZ1g-1; Mon, 10 Feb 2025 14:45:18 -0500
X-MC-Unique: -5OCgvMzNZe6ZP2ZmcCZ1g-1
X-Mimecast-MFC-AGG-ID: -5OCgvMzNZe6ZP2ZmcCZ1g
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-aa6b904a886so357017966b.0
        for <linux-unionfs@vger.kernel.org>; Mon, 10 Feb 2025 11:45:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739216717; x=1739821517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0OxMWC3XA5FgD49oXcSz1TwT0Kbb0QMAHeVEoh+RJ7k=;
        b=lA2xAU5k77jVL8k9kdJNrlX/+98zAeMrZnq7twSClfNhGitF/6XgQl2weJjRJjfiqa
         +jRx00F7aCQgrU4mHr2ys+5yLWtu6t7byDjKwLMI5AB2jJtIIa1O0Hz4anhxQ7z/vPO9
         gcDW9F+gsZlo56CTp0YbhRAO7HEcFTAKtZxYbY2O+kobBiN9qs89M4ExY5VQawA/A1Px
         1jIO01nELwg0ce6lA9TJsrVZz/teEpj1XPWeJafvJRAODeEM0FgTVmB4QpbkVotsi8+6
         yUaIz/cn1AmSr3ZCxshv6JB4p38fXEnePG0uBlWwQeFEMAEOMycQibsGHKFd5V/v4iHS
         vglw==
X-Gm-Message-State: AOJu0YyFUaEEDWdCTrdunPCIT1sXrhVTFCdLeuIApoCggyS7YYyr/Msl
	Ht1V5Vq8ypVaUicyXy7dww5XWzVSLMrXjSxF4Ir4VWnr86ghzPy8TGj2rm8hPMxPzv+xyFeHA94
	SYNPSdU4WB6PgsPm0Gy926RtwMz12lEtPajswdAMi893Z/Pk7elZZWKr5dl3YR0ESwtjQY359tM
	fdDru5rZGf0+cSMPPqBlACzSJXVU9gcb8UQ6dVgJ1e4nDuIDczIQ==
X-Gm-Gg: ASbGnctBqFX1FtawoR5wjqRUZWuLBETGBQKAiI9OuRRgIWoyQXmKyQv2Bl/1cpIcwJv
	bYVw4Q0tG+RQ3mcYjLwIuFFIKGo9p3PJIPFoK7pb61Iqcq1KhPPUszGnHZcYWnRtWzl3QawEKCA
	hSH3j7DwsDXyzMkMXVZ8wVlklIq98kmCUVIU3aLFrLwUKqiVKeOq0vb17MAwMQv2e7poxPePN7l
	XDYpiBOAj0BmKgmRRNICrzFEDtBTFuia/OCNP6Yzg3lOLcSCgse/s+iFpMSnc9COUFi0few9AG/
	zvBq4DT7caWX6Y9w30au5+vKkd/EJryrWOpF7t30BLbES1TnHjsBXQ==
X-Received: by 2002:a17:907:3f27:b0:ab6:f06b:4a26 with SMTP id a640c23a62f3a-ab789aef91amr1549089466b.34.1739216716759;
        Mon, 10 Feb 2025 11:45:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGj+bPdauKCbaejXpaZDhdSfocK61NbRSKwlc7SJwI6g7ThhBURLvAXfYEoXrNhskWnPyPIqw==
X-Received: by 2002:a17:907:3f27:b0:ab6:f06b:4a26 with SMTP id a640c23a62f3a-ab789aef91amr1549086866b.34.1739216716303;
        Mon, 10 Feb 2025 11:45:16 -0800 (PST)
Received: from maszat.piliscsaba.szeredi.hu (84-236-3-29.pool.digikabel.hu. [84.236.3.29])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7922efbb7sm702006666b.2.2025.02.10.11.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 11:45:15 -0800 (PST)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/5] ovl: make redirect/metacopy rejection consistent
Date: Mon, 10 Feb 2025 20:45:07 +0100
Message-ID: <20250210194512.417339-3-mszeredi@redhat.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250210194512.417339-1-mszeredi@redhat.com>
References: <20250210194512.417339-1-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When overlayfs finds a file with metacopy and/or redirect attributes and
the metacopy and/or redirect features are not enabled, then it refuses to
act on those attributes while also issuing a warning.

There was a slight inconsistency of only warning on an upper metacopy if it
found the next file on the lower layer, while always warning for metacopy
found on a lower layer.

Fix this inconsistency and make the logic more straightforward, pavig the
way for following patches to change when dataredirects are allowed.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/namei.c | 67 +++++++++++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 23 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index be5c65d6f848..da322e9768d1 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1040,6 +1040,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct inode *inode = NULL;
 	bool upperopaque = false;
 	char *upperredirect = NULL;
+	bool nextredirect = false;
+	bool nextmetacopy = false;
 	struct dentry *this;
 	unsigned int i;
 	int err;
@@ -1087,8 +1089,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			if (err)
 				goto out_put_upper;
 
-			if (d.metacopy)
+			if (d.metacopy) {
 				uppermetacopy = true;
+				nextmetacopy = true;
+			}
 			metacopy_size = d.metacopy;
 		}
 
@@ -1099,6 +1103,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 				goto out_put_upper;
 			if (d.redirect[0] == '/')
 				poe = roe;
+			nextredirect = true;
 		}
 		upperopaque = d.opaque;
 	}
@@ -1113,6 +1118,29 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	for (i = 0; !d.stop && i < ovl_numlower(poe); i++) {
 		struct ovl_path lower = ovl_lowerstack(poe)[i];
 
+		/*
+		 * Following redirects/metacopy can have security consequences:
+		 * it's like a symlink into the lower layer without the
+		 * permission checks.
+		 *
+		 * This is only a problem if the upper layer is untrusted (e.g
+		 * comes from an USB drive).  This can allow a non-readable file
+		 * or directory to become readable.
+		 *
+		 * Only following redirects when redirects are enabled disables
+		 * this attack vector when not necessary.
+		 */
+		if (nextmetacopy && !ofs->config.metacopy) {
+			pr_warn_ratelimited("refusing to follow metacopy origin for (%pd2)\n", dentry);
+			err = -EPERM;
+			goto out_put;
+		}
+		if (nextredirect && !ovl_redirect_follow(ofs)) {
+			pr_warn_ratelimited("refusing to follow redirect for (%pd2)\n", dentry);
+			err = -EPERM;
+			goto out_put;
+		}
+
 		if (!ovl_redirect_follow(ofs))
 			d.last = i == ovl_numlower(poe) - 1;
 		else if (d.is_dir || !ofs->numdatalayer)
@@ -1126,12 +1154,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		if (!this)
 			continue;
 
-		if ((uppermetacopy || d.metacopy) && !ofs->config.metacopy) {
-			dput(this);
-			err = -EPERM;
-			pr_warn_ratelimited("refusing to follow metacopy origin for (%pd2)\n", dentry);
-			goto out_put;
-		}
+		if (d.metacopy)
+			nextmetacopy = true;
 
 		/*
 		 * If no origin fh is stored in upper of a merge dir, store fh
@@ -1185,22 +1209,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			ctr++;
 		}
 
-		/*
-		 * Following redirects can have security consequences: it's like
-		 * a symlink into the lower layer without the permission checks.
-		 * This is only a problem if the upper layer is untrusted (e.g
-		 * comes from an USB drive).  This can allow a non-readable file
-		 * or directory to become readable.
-		 *
-		 * Only following redirects when redirects are enabled disables
-		 * this attack vector when not necessary.
-		 */
-		err = -EPERM;
-		if (d.redirect && !ovl_redirect_follow(ofs)) {
-			pr_warn_ratelimited("refusing to follow redirect for (%pd2)\n",
-					    dentry);
-			goto out_put;
-		}
+		if (d.redirect)
+			nextredirect = true;
 
 		if (d.stop)
 			break;
@@ -1218,6 +1228,17 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		ctr++;
 	}
 
+	if (nextmetacopy && !ofs->config.metacopy) {
+		pr_warn_ratelimited("refusing to follow metacopy origin for (%pd2)\n", dentry);
+		err = -EPERM;
+		goto out_put;
+	}
+	if (nextredirect && !ovl_redirect_follow(ofs)) {
+		pr_warn_ratelimited("refusing to follow redirect for (%pd2)\n", dentry);
+		err = -EPERM;
+		goto out_put;
+	}
+
 	/*
 	 * For regular non-metacopy upper dentries, there is no lower
 	 * path based lookup, hence ctr will be zero. If a dentry is found
-- 
2.48.1

