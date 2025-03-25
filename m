Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917A91EBA1C
	for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 10:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742899605; cv=none; b=ppvWf4xg5oPJ+VhVWYyMzX/sgEtMOjchDX8Qy+XGT8DE2j0en5rmefex12bjcVQaOK84lJCjTtNEKuwTngO2NAhg+kFj0YJlMKxLCPw7w7y7J/OeFeIj29b+4zexJqPTRyiJ1H77H+vucizHGtxHGkZjv4daM3+6L0j8HTIDQ9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742899605; c=relaxed/simple;
	bh=dAcXi5fAdxGzgjq/JG7eFreFDNKrZcOkDEPNAgtXUSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W218mFoC0o+Ua2sh3vHGGcd6rgDvaZTpK2PbmNeF0Sx4B+t0o9fDTkeA0fyoOQKujcVwOkfm0UpJiJ9ONOn6ymCTg2kUn/PjelMOhw9qdf/IwCRSR9XAYzYOxd/LfDwK141u0QUCpcG0A0ZiQYbmqqY6ekPt5CoBD2N8oPUO6dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SNQi8nAA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SNQi8nAA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742899602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HtuxOK/+soZt5CGwob3MZFUYvqt0G5t0rerQy2j1XuI=;
	b=SNQi8nAArpF5ZPT5wEeOnyhZwje4/7+W3oHgqML3zNquSTRcgGn65hwJ0/9omkrupldXRX
	nVV0u0tdZ12dAxktT/LDvkuDXy7PxI8ptMFiY3to/dzdJ+z7MmxjgfTWXbuuZ0IXEvwkvN
	MCXenmPwHGhiAFMKqMKuHkiCij9T2Y0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-QOo7Yz2jOtiS79YjP5W6Nw-1; Tue, 25 Mar 2025 06:46:41 -0400
X-MC-Unique: QOo7Yz2jOtiS79YjP5W6Nw-1
X-Mimecast-MFC-AGG-ID: QOo7Yz2jOtiS79YjP5W6Nw_1742899600
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-39142ce2151so2184677f8f.1
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 03:46:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742899600; x=1743504400;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HtuxOK/+soZt5CGwob3MZFUYvqt0G5t0rerQy2j1XuI=;
        b=tE9ZcsClsifE1selD6V9PydoNL+qb8HXPIeCpw6z/P0n23nSGFm9VqLO6J4Fo677HF
         /Gc+5GM1LglhasLMHzPpzlp0lfczcSUJMl93Bo+SyoWK45elqTgg9oSIsAMV0/4ce5IL
         dZtzNAacgVhx2k08mgXJcAWHvMTjJit9sJtxJFcc66TiW87V6rflencyrrOgu81lho05
         DTD5U4x/FDClawa0LQvfS7li91z+V2Ym7bD/C1PyIWn3rXGxVL2uNYbBV305/x+T+QDg
         kS04970tjd78Cj01deDn1gQJPlbZMX+NazcAwVYX91MNuQxvvrisI9hIdd2/65Vw5h3B
         SMtw==
X-Gm-Message-State: AOJu0YydxZfiLtKdCns7i0SgXRYf6/sOqEpr+aAMio7Zji7bauTdZa94
	nrkk0yNHH1TJamuwkhcgWqeDjhC2gmcqiLs9VEdI6FwHJdwJJTmk234tyjMGglN58KLdhIcPx04
	Mve4Sdy9cU13718hMNIlFX2jufWvj+y76vJIkbq1glDkQvO/o0RnuIwMtYZiMT1QO8WT4kF//VE
	zKgrKjG2n9xjxZ0t6/TbgU9Uind7kjB4k+Dynb2GkOmg2n3Ls=
X-Gm-Gg: ASbGncs6Un8+PJqGLzcUpnCSlaBJPdk3xXIx3O01Dc3YrGDk9g7BGl8U0rGcBza1Ibr
	o1IQaJXlCdgt5RYvkoJLcaAYEgXAd9nDJFsjWPV90Hc5d5SyKahtYoWdoHtBkScbiHmNj16xqyg
	TitdcVdfLThizdMHNFTIclS/XK8dCzPNrxK6w/xOrfSDAFVPfQcSt3RJW9pZ/BMCqiiQM/UWdQh
	1bidoc/WeKZhaZpYQVaA0O/KHkjyhWhyaGNm8d2wrQzB4cv+H6yzykd0f5vaCUZIJjv04KF/GXc
	nbZ/EctC1ciybieOIK4DLDwbahsXFZmIWEXJfvy4t6woiEM2W4jRqyUDNtrds9qssh8=
X-Received: by 2002:a5d:64e4:0:b0:38f:3b9b:6f91 with SMTP id ffacd0b85a97d-3997f8fa8f5mr14887697f8f.12.1742899599781;
        Tue, 25 Mar 2025 03:46:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHbKZ4B8bhTCOofTlxaf+tlZNeeNYajiCDudd7iSXdtr0NxTTXTB04kEWPjz7bTK9e4I/Ac9w==
X-Received: by 2002:a5d:64e4:0:b0:38f:3b9b:6f91 with SMTP id ffacd0b85a97d-3997f8fa8f5mr14887665f8f.12.1742899599327;
        Tue, 25 Mar 2025 03:46:39 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (87-97-53-119.pool.digikabel.hu. [87.97.53.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9a50c1sm13572203f8f.38.2025.03.25.03.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 03:46:38 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	Giuseppe Scrivano <gscrivan@redhat.com>,
	Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v2 3/5] ovl: make redirect/metacopy rejection consistent
Date: Tue, 25 Mar 2025 11:46:31 +0100
Message-ID: <20250325104634.162496-4-mszeredi@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325104634.162496-1-mszeredi@redhat.com>
References: <20250325104634.162496-1-mszeredi@redhat.com>
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

Fix this inconsistency and make the logic more straightforward, paving the
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
2.49.0

