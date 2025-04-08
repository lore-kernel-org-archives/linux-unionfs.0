Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F6F2288C6
	for <linux-unionfs@vger.kernel.org>; Tue,  8 Apr 2025 15:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744126821; cv=none; b=Ef9x+O5oF+NnA5JKiVuUY0bTN2+UD+trel1EySsGVUU1qH4l4FmsU6AbyzyRweyA8Q6hUp0dZTT1G6YJkUE5WF3nsZI5g0EPHBCx4lDtrxhmgPiBZhoZjFJR1O2VV/DTipsBPcQ6WfHBSXYp4J1em+ERmc2699W/JdkDKWmOxZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744126821; c=relaxed/simple;
	bh=6VNMoxYzbFk+VlKL7h88wDZ9Ynzzobrg4jsDJKB20sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnU98656X03z3YZ8MfaGNHahhZi6+qz8oxXKm58YduOkM+psieAfOrnlrklPAhfVpO05EU2FGVtPfw1rPSfBz7lzt15cx6tYshFmvH9D3YLB1prAQ+x2if7dzn8yzlF11UXZlr2qLRWdeCidVZsiUPTKM9yOIv4/TVDFc+saf1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gEoay3AG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gEoay3AG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744126818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g4xX7nQQJU6qGcbsTCbaOngAfrHbt+AL1BwlUbjEmks=;
	b=gEoay3AG9fB4TtxVd2ksoozuR21ICXqDgd4rq3yNquCvQ5nA9XFPn2ojQfi4nVVfacdM8F
	DOUm+8cTWjS18sS2pP3iSdrDdYk8LitTvMvOo4CECN9SRW6feuSkDp52gOWxUNP/LVfVqe
	U5geSOpWa9noMxSkXrGXKBbdjATxRLo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-575-0frdqo63NPiXUQDg_udMfA-1; Tue, 08 Apr 2025 11:40:16 -0400
X-MC-Unique: 0frdqo63NPiXUQDg_udMfA-1
X-Mimecast-MFC-AGG-ID: 0frdqo63NPiXUQDg_udMfA_1744126816
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5e68e9d9270so4906394a12.0
        for <linux-unionfs@vger.kernel.org>; Tue, 08 Apr 2025 08:40:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744126815; x=1744731615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g4xX7nQQJU6qGcbsTCbaOngAfrHbt+AL1BwlUbjEmks=;
        b=enEcLcEo3nlPf0Q/yWjTqbfmJh1S54SVoSWdz4lDM1r5szzkauUxI+QTpMKCCI47O7
         ZEtr32UGVK0W4JIzlSXikepOt4WgaaBS2EHyiuc68m7dwtDjoPRSprXS1n9p7Uw1esJf
         elBkuMIXt73WifctvrIS1sw151+Q4fNPgMrhkrYsxdA6DuZwraZQklPkGXT0gTj+Pvs1
         ASxLPYx22imEvMQOY403ejhJ7LYld7GVU2RuQFx5RoVpkaAQVnNE8IblXj6dJ6Zy7ReK
         CxC9iSYzn//Yz4zkeyLdEymDFjEdRfHvOvrUOiCbjbc8THqKek5WpG1nLBJVyP1fffco
         erBQ==
X-Gm-Message-State: AOJu0Yx/jBHNzYem3TKR+qnEDmwbbLgZof4A2xqlUL5hdwR+m9YFOUeD
	VVzFJ44dYa5dsY6t2BYqXlPpWBIKaROnOpwmSKaTOkUOC8hBtMZA3gwdN8VqwGjRKoGGCGGsVbs
	zDl+g6MPLL7c7OEA4XI5ZdwfIo4iSnHsXyqtHgPnxodk6ScUPEbK9+ZPE2t8YGaz7cikUYOeVY5
	xldTVAq7kyzRYrU/8bB1GyOBnRrEPsjyFFRhKb4w5OGEMHvpo=
X-Gm-Gg: ASbGncvPIbnfLEdkJE2lNN9JNpVVjS63xKTyVIWLkTaED5vPmm0iqbATL8bRrOTDU3x
	wiQkrsvBE1ug9rHpj5l8GSgVUc+tg7F0hzgnia90CAisSd39dIw6YjKCBLKu3S5/ObmnayTs9RG
	+8AQrdHZGGr6/Mo8I4fj+iA2xewhf/K5WN75z1MfjVEWPHdqMV+3DDlkQLD/hKtM03Qdl5J72kn
	fWziMBHprDJpg0k3a+TM/j+GTrQQtKArjfyg77N1J3JbS13Nt2N7uoerH08Cjp2D2oMry62/SLt
	DpUuEMwrMWlEFLmV0wsvZu8rF+U1vMKrApvzCfTPGPzoFt4QiDR4SLg1rMzqAyYBJvlg9v15
X-Received: by 2002:a17:907:1ca8:b0:ac1:fa91:2b98 with SMTP id a640c23a62f3a-ac7d6d00dafmr1619425166b.14.1744126815532;
        Tue, 08 Apr 2025 08:40:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG8aLezkLhIOxoF3ubbNutZOtgZSeu+nF9/yCx5dLPuyit/AbsIcKCEyAJEIEGs3zk4DrLqig==
X-Received: by 2002:a17:907:1ca8:b0:ac1:fa91:2b98 with SMTP id a640c23a62f3a-ac7d6d00dafmr1619421266b.14.1744126815056;
        Tue, 08 Apr 2025 08:40:15 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (193-226-212-63.pool.digikabel.hu. [193.226.212.63])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c01bb793sm927553766b.161.2025.04.08.08.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 08:40:14 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	Giuseppe Scrivano <gscrivan@redhat.com>,
	Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v3 2/3] ovl: relax redirect/metacopy requirements for lower -> data redirect
Date: Tue,  8 Apr 2025 17:40:03 +0200
Message-ID: <20250408154011.673891-3-mszeredi@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408154011.673891-1-mszeredi@redhat.com>
References: <20250408154011.673891-1-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow the special case of a redirect from a lower layer to a data layer
without having to turn on metacopy.  This makes the feature work with
userxattr, which in turn allows data layers to be usable in user
namespaces.

Minimize the risk by only enabling redirect from a single lower layer to a
data layer iff a data layer is specified.  The only way to access a data
layer is to enable this, so there's really no reason not to enable this.

This can be used safely if the lower layer is read-only and the
user.overlay.redirect xattr cannot be modified.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 Documentation/filesystems/overlayfs.rst |  7 +++++++
 fs/overlayfs/namei.c                    | 14 ++++++++------
 fs/overlayfs/params.c                   |  5 -----
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 2db379b4b31e..4133a336486d 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -443,6 +443,13 @@ Only the data of the files in the "data-only" lower layers may be visible
 when a "metacopy" file in one of the lower layers above it, has a "redirect"
 to the absolute path of the "lower data" file in the "data-only" lower layer.
 
+Instead of explicitly enabling "metacopy=on" it is sufficient to specify at
+least one data-only layer to enable redirection of data to a data-only layer.
+In this case other forms of metacopy are rejected.  Note: this way data-only
+layers may be used toghether with "userxattr", in which case careful attention
+must be given to privileges needed to change the "user.overlay.redirect" xattr
+to prevent misuse.
+
 Since kernel version v6.8, "data-only" lower layers can also be added using
 the "datadir+" mount options and the fsconfig syscall from new mount api.
 For example::
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 5cebdd05ab3a..3d99e5fe5cfc 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1068,6 +1068,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct inode *inode = NULL;
 	bool upperopaque = false;
 	char *upperredirect = NULL;
+	bool check_redirect = (ovl_redirect_follow(ofs) || ofs->numdatalayer);
 	struct dentry *this;
 	unsigned int i;
 	int err;
@@ -1080,7 +1081,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		.is_dir = false,
 		.opaque = false,
 		.stop = false,
-		.last = ovl_redirect_follow(ofs) ? false : !ovl_numlower(poe),
+		.last = check_redirect ? false : !ovl_numlower(poe),
 		.redirect = NULL,
 		.metacopy = 0,
 		.nextredirect = false,
@@ -1152,7 +1153,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			goto out_put;
 		}
 
-		if (!ovl_redirect_follow(ofs))
+		if (!check_redirect)
 			d.last = i == ovl_numlower(poe) - 1;
 		else if (d.is_dir || !ofs->numdatalayer)
 			d.last = lower.layer->idx == ovl_numlower(roe);
@@ -1233,13 +1234,14 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		}
 	}
 
-	/* Defer lookup of lowerdata in data-only layers to first access */
+	/*
+	 * Defer lookup of lowerdata in data-only layers to first access.
+	 * Don't require redirect=follow and metacopy=on in this case.
+	 */
 	if (d.metacopy && ctr && ofs->numdatalayer && d.absolute_redirect) {
 		d.metacopy = 0;
 		ctr++;
-	}
-
-	if (!ovl_check_nextredirect(&d)) {
+	} else if (!ovl_check_nextredirect(&d)) {
 		err = -EPERM;
 		goto out_put;
 	}
diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 6759f7d040c8..2468b436bb13 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -1025,11 +1025,6 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 		 */
 	}
 
-	if (ctx->nr_data > 0 && !config->metacopy) {
-		pr_err("lower data-only dirs require metacopy support.\n");
-		return -EINVAL;
-	}
-
 	return 0;
 }
 
-- 
2.49.0

